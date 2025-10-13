//
//  AppListView.swift
//  CheckAttend
//
//  Created by 송은아 on 8/6/25.
//

import SwiftUI

struct AppListView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var appLists: ListViewModel
    
    @Binding var optionType: Options
    
    var body: some View {
        VStack(alignment: .center, content: {
            let links = Set(appLists.saveLists.map { $0.link })
            let serverLists = appLists.serverLists.filter { !links.contains($0.link) }
            
            let walkLinks = Set(appLists.walkSaveLists.map { $0.link })
            let walkServerLists = appLists.walkServerLists.filter { !walkLinks.contains($0.link) }
            
            switch optionType {
            case .attend:
                List(serverLists, id: \.self) { list in
                    Button(action: {
                        let id = RM.incrementaPushBoxID()
                        RM.insertData(list: ListRealmModel(id: id,
                                                           title: list.title,
                                                           link: list.link,
                                                           isChecked: false,
                                                           date: Date.now,
                                                           index: id,
                                                           type: .attend))
                        
                        dismiss()
                    }, label: {
                        Text(list.title)
                    })
                    .foregroundStyle(Color.init(hex: "#222222"))
                }
                
            case .walk:
                List(walkServerLists, id: \.self) { list in
                    Button(action: {
                        let id = RM.incrementaPushBoxID()
                        RM.insertData(list: ListRealmModel(id: id,
                                                           title: list.title,
                                                           link: list.link,
                                                           isChecked: false,
                                                           date: Date.now,
                                                           index: id,
                                                           type: .walk))
                        
                        dismiss()
                    }, label: {
                        Text(list.title)
                    })
                    .foregroundStyle(Color.init(hex: "#222222"))
                }
            }
        })
    }
}
