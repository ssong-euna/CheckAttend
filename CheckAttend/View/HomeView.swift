//
//  HomeView.swift
//  CheckAttend
//
//  Created by 송은아 on 8/6/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack(root: {
            VStack(alignment: .center, content: {
                Text(Date().nowTime())
                    .padding()
                
                Spacer()
                
                ContentView()
            })
        })
    }
}
