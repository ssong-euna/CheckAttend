//
//  NetworkManager.swift
//  CheckAttend
//
//  Created by 송은아 on 1/2/26.
//

import UIKit
import SwiftyJSON
import Alamofire

class NetworkManager: NSObject {
    static let shared = NetworkManager()
    private override init(){}    // 객체 생성 못하도록 막음. shared로만 사용.
    
    var userAgent: String {
        get {
            var userAgent = ""
            userAgent.append("IOS/MOBILE")
            userAgent.append("/" + DM.appVer)
            
            return userAgent
        }
        /*
        set(newValue) {
            self.webUserAgent.append(newValue)
        }
         */
    }
    
    let customSession: Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = API_REQUEST_TIMEOUT
        configuration.httpCookieAcceptPolicy = .never
        configuration.httpShouldSetCookies = false
        configuration.urlCache = nil
        
        return Session(configuration: configuration)
    }()
    
    //MARK: HTTP Headers
    var httpHeaders: HTTPHeaders {
        let config = URLSessionConfiguration.af.default
        config.headers.update(name: "Content-Type", value: "application/json")
        config.headers.update(name: "x-api-token", value: "aklejqiekqjfhgkeiqutieiqkthekjfadpdiqkehtnadknl125ahigpekadhlkgklahdflkh")
        config.headers.update(name: "User-Agent", value: userAgent)

        return config.headers
    }
    
    //MARK: JSON 통신
    func requestJSONData(_ url: String,
                         method: HTTPMethod = .get,
                         params: Parameters?,
                         success: ((JSON) -> Void)?,
                         failure: ((AFError?, JSON?, Int?) -> Void)?,
                         inspect: ((Int?) -> Void)? = nil) {
        
        var paramEncoding: ParameterEncoding
        if method == .post || method == .put { // post,put 요청이면 body에 들어가도록 json 인코딩
            paramEncoding = JSONEncoding.default
        } else { // 나머지는 쿼리 형식으로 인코딩
            paramEncoding = URLEncoding.default
        }
        
        var headers = self.httpHeaders
        
        func successCodeCheck(json: JSON, code: Int) {
            switch code {
            case 1:
                success?(json)
                return
                
            case 200:
                success?(json)
                return
                
            case 500:
                failure?(nil, nil, 500)
                return
                
            default:
                let error = AFError.createURLRequestFailed(error: NSError(domain: "\nURL: \(url)\nError: \n\(json)", code: code, userInfo: nil))
                failure?(error, json, nil)
            }
            
            // 서버 오류 메시지 얼럿 처리
            let returnCode = json["returnCode"].stringValue
            let returnMessage = json["returnMessage"].stringValue
            if (code != 200 || code != 1 || returnCode != "SUCCESS"), returnCode != "0000", !returnMessage.isEmpty {
            }
        }
        
        customSession.request(url,
                              method: method,
                              parameters: params,
                              encoding: paramEncoding,
                              headers: headers).responseJSON(completionHandler: { response in
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("###### success:: \(json) url:: \(url)")
                if let returnStatus = json["returnStatus"].int {
                    successCodeCheck(json: json, code: returnStatus)
                    
                } else if let returnSuccess = json["success"].int {
                    if returnSuccess == 0 {
                        inspect?(json["errCode"].int)
                        return
                    }
                    
                    successCodeCheck(json: json, code: returnSuccess)
                    
                } else if let code = json["code"].int {
                    successCodeCheck(json: json, code: code)
                    
                } else {
                    //UMS를 위함
                    if let umsResultCode = json["HEADER"]["RESULTCODE"].string,
                       umsResultCode == "0000" {
                        success?(json)
                        return
                    }
                    
                    failure?(nil, json, nil)
                }
            case .failure(let error):
                print("###### fail:: \(error) url:: \(url)")
                failure?(error, nil, nil)
            }
        })
    }
    
    func requestURLList(success: ((JSON) -> Void)? = nil, failure: ((AFError?, JSON?) -> Void)? = nil) {
        self.requestJSONData("http://3.39.21.123/api/public/sites",
                             method: .get,
                             params: ["type": "A"],
                             success: { json in
            print("requestURLList = \(json)")
            
            success?(json)
        },
                             failure: { error, _, code in
            failure?(error, nil)
        })
    }
}
