//
//  ListModel.swift
//  CheckAttend
//
//  Created by 송은아 on 8/6/25.
//

import SwiftUI

struct AppList: Codable, Equatable, Hashable, Identifiable {
    var id: String { link }
    let realmId: Int?
    let title: String
    let link: String
    let isChecked: Bool
}

