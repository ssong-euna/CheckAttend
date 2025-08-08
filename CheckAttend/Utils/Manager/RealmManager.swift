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
    
    func update(obj: Object) {
        do {
            try realm?.write {
                realm?.add(obj, update: .modified)
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
    
    // [F-2262] 푸시박스 Realm 사용하여 적재
    func parsePushData(title: String, link: String, isChecked: Bool) -> ListRealmModel? {
        var listModel: ListRealmModel
        
        // 저장 시간(받아오는 시간정보가 없어, 저장할 때 시간 기록)
        let date = Date().toKST()
        let day  = date.removeTime()
        
        listModel = ListRealmModel(id: self.incrementaPushBoxID(),
                                   title: title,
                                   link: link,
                                   isChecked: isChecked,
                                   date: day)
        
        return listModel
    }
    
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
