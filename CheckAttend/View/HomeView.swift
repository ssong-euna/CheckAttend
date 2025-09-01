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
            schemaVersion: 2,
            migrationBlock: { _, _ in }
        )
        Realm.Configuration.defaultConfiguration = config
    }
    
    var body: some View {
        NavigationStack(root: {
            VStack(alignment: .center, content: {
                Text(today.nowTime())
                    .padding()
                
                Spacer()
                
                ContentView(todayDate: $today, refreshId: $refreshId)
            })
            .id(refreshId)
        })
    }
}
