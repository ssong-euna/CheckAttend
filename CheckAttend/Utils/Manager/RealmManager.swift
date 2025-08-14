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
    
    private var realm: Realm? = {
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
    
    func read<Element: RealmFetchable>(obj: Element.Type, filter: String) -> Results<Element>? {
        let data = realm?.objects(obj).filter(filter)
        
        return data
    }
    
    func readListRealmModel() -> Results<ListRealmModel>? {
        let objs = realm?.objects(ListRealmModel.self)
        
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
    
    func insertPushData(list: ListRealmModel) {
        self.create(obj: list)
    }
    
    // MARK: Delete
    func deletePushData(list: ListRealmModel) {
        self.delete(obj: list)
    }
    
    func incrementaPushBoxID() -> Int {
            if let retNext = realm?.objects(ListRealmModel.self).sorted(byKeyPath: "id").last?.id {
                return retNext + 1
        } else {
            return 0
        }
    }
}
