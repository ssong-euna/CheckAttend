//
//  ListViewModel.swift
//  CheckAttend
//
//  Created by 송은아 on 8/6/25.
//

import SwiftUI

final class ListViewModel: ObservableObject {
    @Published var saveLists: [AppList] = []
    @Published var serverLists: [AppList] = []
    
    @Published var walkSaveLists: [AppList] = []
    @Published var walkServerLists: [AppList] = []
    
    func getSaveLists() {
        saveLists.removeAll()
        if let objcs = RM.readListRealmModel(type: .attend) {
            
            for objc in objcs {
                var isChecked = objc.isChecked
                var link = objc.link
                
                if let saveDate = objc.date,
                   !(Calendar.current.isDate(saveDate, inSameDayAs: Date())) {
                    isChecked = false
                    RM.updateIsCheck(id: "\(objc.id)", isChecked: false, type: .attend)
                }
                
                // 변경된 link 대입
                let mapLists = Dictionary(uniqueKeysWithValues: serverLists.map { ($0.title, $0.link) })
                if let newLink = mapLists[objc.title] {
                    link = newLink
                }
                
                saveLists.append(AppList(realmId: objc.id,
                                         title: objc.title,
                                         link: link,
                                         isChecked: isChecked))
            }
        }
    }
    
    func getServerLists(completion: (() -> Void)? = nil) {
        // 서버 호출 또는 더미 데이터
        var lists: [AppList] = []
        NM.requestURLList(success: { [weak self] data in
            let items = data["items"].arrayValue
            
            for item in items {
                lists.append(AppList(realmId: nil,
                                     title: item["name"].stringValue,
                                     link: item["url"].stringValue,
                                     isChecked: false))
            }
            
            self?.serverLists = lists
            completion?()
        })
    }
    
    func getWalkSaveLists() {
        walkSaveLists.removeAll()
        
        if let objcs = RM.readListRealmModel(type: .walk) {
            
            for objc in objcs {
                var isChecked = objc.isChecked
                var link = objc.link
                
                if let saveDate = objc.date,
                   !(Calendar.current.isDate(saveDate, inSameDayAs: Date())) {
                    isChecked = false
                    RM.updateIsCheck(id: "\(objc.id)", isChecked: false, type: .walk)
                }
                
                // 변경된 link 대입
                let mapLists = Dictionary(uniqueKeysWithValues: walkServerLists.map { ($0.title, $0.link) })
                if let newLink = mapLists[objc.title] {
                    link = newLink
                }
                
                walkSaveLists.append(AppList(realmId: objc.id,
                                             title: objc.title,
                                             link: link,
                                             isChecked: isChecked))
            }
        }
    }
    
    func getWalkServerLists(completion: (() -> Void)? = nil) {
        // 서버 호출 또는 더미 데이터
        let lists = [
            AppList(realmId: nil,
                    title: "모니모",
                    link: "monimoapp://adbrix?",
                    isChecked: false),
        
            AppList(realmId: nil,
                    title: "국민은행",
                    link: "kbbank://call?cmd=move_to&id=web&url=/mquics?page=D016793&urlparam=",
                    isChecked: false),
            
            AppList(realmId: nil,
                    title: "토스",
                    link: "supertoss://",
                    isChecked: false),
            
            AppList(realmId: nil,
                    title: "카카오뱅크",
                    link: "kakaobank://benefit?type=detail&bnf_id=86&af_deeplink=true&af_dp=kakaobank%3A%2F%2Fbenefit%3Ftype%3Ddetail%26bnf_id%3D86&af_xp=custom&shortlink=frfvcw7m&source_caller=ui",
                    isChecked: false),
            
            AppList(realmId: nil,
                    title: "카카오페이",
                    link: "https://link.kakaopay.com/_/NY6a9yS",
                    isChecked: false)]
        
        walkServerLists = lists
        completion?()
    }
}
