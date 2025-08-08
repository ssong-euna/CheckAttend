//
//  ListRealmModel.swift
//  CheckAttend
//
//  Created by 송은아 on 8/6/25.
//

import RealmSwift

class ListRealmModel: Object {
    @Persisted(primaryKey: true) var id: Int
    
    @Persisted var title: String = ""
    @Persisted var link: String = ""
    @Persisted var isChecked: Bool = false
    @Persisted var date: Date?
    
    convenience init(id: Int, title: String, link: String, isChecked: Bool, date: Date?) {
        self.init()
        
        self.id = id
        self.title = title
        self.link = link
        self.isChecked = isChecked
        self.date = date
    }
}
