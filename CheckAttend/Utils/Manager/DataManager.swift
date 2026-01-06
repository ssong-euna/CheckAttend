//
//  DataManager.swift
//  CheckAttend
//
//  Created by 송은아 on 1/2/26.
//

import UIKit

class DataManager: NSObject {
    static let shared = DataManager()
    private override init(){}    // 객체 생성 못하도록 막음. shared로만 사용.
    
    /// Bundle Idendifier
    let bundleID: String = Bundle.main.bundleIdentifier ?? "com.sea.attend"

    /// OS 버전
    let osVer: String = UIDevice.current.systemVersion
    
    /// 앱 버전
    let appVer: String = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    
    /// 앱 빌드넘버
    let appBuildNo: String = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
    
    /*
    /// 앱 최초구동 여부
    var isFirstLaunch: Bool {
        get {
            // 값 없을때 기본이 false 이므로 반대로 리턴
            return !(userDefaults.bool(forKey: KEY_IS_FIRST_LAUNCH))
        }
        
        // get 할때 반대로 리턴하므로 반대로 저장
        set (isFirstLaunch) {
            userDefaults.set(!isFirstLaunch, forKey: KEY_IS_FIRST_LAUNCH)
        }
    }
    */
}
