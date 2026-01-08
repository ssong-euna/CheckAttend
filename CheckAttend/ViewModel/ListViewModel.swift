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
    
    func getServerLists(type: URL_TYPE, completion: (() -> Void)? = nil) {
        // 서버 호출 또는 더미 데이터
        var lists: [AppList] = []
        NM.requestURLList(type: type, success: { [weak self] data in
            let items = data["items"].arrayValue
            
            for item in items {
                lists.append(AppList(realmId: nil,
                                     title: item["name"].stringValue,
                                     link: item["url"].stringValue,
                                     isChecked: false))
            }
            
            if type == .attend {
                self?.serverLists = lists
            } else if type == .walk {
                self?.walkServerLists = lists
            }
            
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
}
