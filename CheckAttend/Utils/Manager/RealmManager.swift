//
//  RealmManager.swift
//  CheckAttend
//
//  Created by 송은아 on 8/6/25.
//

import Realm
import RealmSwift

class RealmManager: NSObject {
    static let shared = RealmManager()
    
    var realm: Realm? = {
        do {
            return try Realm()
        } catch {
            print("Realm 초기화 실패:", error)
            return nil
        }
    }()
    
    private override init() {}    // 객체 생성 못하도록 막음. shared로만 사용.
    
    func create(obj: Object) {
        do {
            try realm?.write {
                realm?.add(obj)
            }
        } catch {
            print("create fail")
        }
    }
    
    func update(obj: Object) {
        do {
            try realm?.write {
                realm?.add(obj, update: .modified)
            }
        } catch {
            print("create fail")
        }
    }
    
    func read<Element: RealmFetchable>(obj: Element.Type, filter: String = "", keyPath: String = "") -> Results<Element>? {
        var data = realm?.objects(obj)
        
        if !filter.isEmpty {
            data = data?.filter(filter)
        }
        
        if !keyPath.isEmpty {
            data = data?.sorted(by: [RealmSwift.SortDescriptor(keyPath: keyPath, ascending: true)])
        }
        
        return data
    }
    
    func delete(obj: Object) {
        do {
            try realm?.write {
                realm?.delete(obj)
            }
        } catch {
            print("delete fail")
        }
    }
    
    func deleteAll() {
        do {
            try realm?.write {
                realm?.deleteAll()
            }
        } catch {
            print("delete fail")
        }
    }
    
    /// Realm 경로확인
    func getRealmPath() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        
        return documentsDirectory
    }
}

// MARK: PushData
extension RealmManager {
    
    func insertData(list: ListRealmModel) {
        self.create(obj: list)
    }
    
    func incrementaPushBoxID() -> Int {
            if let retNext = realm?.objects(ListRealmModel.self).sorted(byKeyPath: "id").last?.id {
                return retNext + 1
        } else {
            return 0
        }
    }
    
    func readListRealmModel() -> Results<ListRealmModel>? {
        let objs = RM.read(obj: ListRealmModel.self, keyPath: "index")
        
        return objs
    }
    
    func updateIsCheck(id: String, isChecked: Bool) {
        do {
            try realm?.write {
                if let obj = RM.read(obj: ListRealmModel.self, filter: "id == \(id)")?.first {
                    obj.isChecked = isChecked
                }
            }
        } catch {
            print("update fail")
        }
    }
    
    func updateDate(id: String, date: Date) {
        do {
            try realm?.write {
                if let obj = RM.read(obj: ListRealmModel.self, filter: "id == \(id)")?.first {
                    obj.date = date
                }
            }
        } catch {
            print("update fail")
        }
    }
    
    func updateLink(id: String, link: String) {
        do {
            try realm?.write {
                if let obj = RM.read(obj: ListRealmModel.self, filter: "id == \(id)")?.first {
                    obj.link = link
                }
            }
        } catch {
            print("update Fail")
        }
    }
}
