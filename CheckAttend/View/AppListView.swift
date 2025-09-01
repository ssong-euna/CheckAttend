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
    
    var body: some View {
        VStack(alignment: .center, content: {
            let lists = appLists.serverLists
            List(lists, id: \.self) { list in
                Button(action: {
                    let id = RM.incrementaPushBoxID()
                    RM.insertData(list: ListRealmModel(id: id,
                                                       title: list.title,
                                                       link: list.link,
                                                       isChecked: false,
                                                       date: Date.now,
                                                       index: id))
                    
                    dismiss()
                }, label: {
                    Text(list.title)
                })
                .foregroundStyle(Color.init(hex: "#222222"))
            }
        }).onAppear {
            appLists.getServerLists()
        }
    }
}
