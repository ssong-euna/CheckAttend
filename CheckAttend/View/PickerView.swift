//
//  PickerView.swift
//  CheckAttend
//
//  Created by 송은아 on 10/13/25.
//

import SwiftUI

enum Options: String, CaseIterable {
    case attend = "출석체크"
    case walk = "걷기"
    
    var id: Self { self }
}

struct PickerView: View {
    @Binding var todayDate: Date
    @Binding var refreshId: UUID
    
    @State private var selectedOption: Options = .attend
    
    var body: some View {
        VStack() {
            Picker("", selection: $selectedOption, content: {
                ForEach(Options.allCases, id: \.self) { option in
                    Text(option.rawValue)
                }
            })
            .pickerStyle(.segmented)
            .padding()
            
            Group {
                ContentView(optionType: $selectedOption, todayDate: $todayDate, refreshId: $refreshId)
            }
        }
    }
}
