//
//  HomeView.swift
//  CheckAttend
//
//  Created by 송은아 on 8/6/25.
//

import SwiftUI
import RealmSwift

struct HomeView: View {
    @State var today = Date()
    @State var refreshId = UUID()
    
    init() {
        let config = Realm.Configuration(
            schemaVersion: 3,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 2 {
                    // ✅ 이전 버전이 1이었고, 2로 올라가는 상황
                    migration.enumerateObjects(ofType: ListRealmModel.className()) { oldObject, newObject in
                        // 새로 추가한 type 필드에 기본값 세팅
                        newObject?["type"] = Options.attend.rawValue
                    }
                }
            }
        )
        Realm.Configuration.defaultConfiguration = config
    }
    
    var body: some View {
        NavigationStack(root: {
            VStack(alignment: .center, content: {
                Text(today.nowTime())
                    .padding()
                
                Spacer()
                
                PickerView(todayDate: $today, refreshId: $refreshId)
            })
            .id(refreshId)
        })
    }
}
