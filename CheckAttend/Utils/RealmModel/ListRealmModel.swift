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
    @Persisted var index: Int = 0
    @Persisted var type: String = Options.attend.rawValue
    
    convenience init(id: Int, title: String, link: String, isChecked: Bool, date: Date?, index: Int, type: Options) {
        self.init()
        
        self.id = id
        self.title = title
        self.link = link
        self.isChecked = isChecked
        self.date = date
        self.index = index
        self.type = type.rawValue
    }
}
