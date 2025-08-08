//
//  ListItemView.swift
//  CheckAttend
//
//  Created by 송은아 on 8/6/25.
//

import SwiftUI

enum ListType {
    case ADD
    case SELECT
}

struct ListItemView: View {
    var list: AppList
    var type: ListType
    
    var body: some View {
        HStack(content: {
            Text(list.title)
            
            Spacer()
            
            switch type {
            case .ADD:
                Button("추가", action: {
                    RM.insertPushData(list: ListRealmModel(id: RM.incrementaPushBoxID(),
                                                           title: list.title,
                                                           link: list.link,
                                                           isChecked: true,
                                                           date: Date.now))
                })
                .padding()
                .background(RoundedRectangle(cornerRadius: 8).stroke())
                
            case .SELECT:
                Button("선택", action: {
                    if let url = URL(string:list.link) {
                        UIApplication.shared.open(url)
                    }
                })
                .padding()
                .background(RoundedRectangle(cornerRadius: 8).stroke())
            }
        })
    }
}

#Preview {
    ListItemView(list: AppList(id: UUID().hashValue,
                               title: "홈플러스",
                               link: "",
                               isChecked: false),
                 type: .ADD)
}
