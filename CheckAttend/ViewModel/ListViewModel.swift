//
//  ListViewModel.swift
//  CheckAttend
//
//  Created by 송은아 on 8/6/25.
//

import SwiftUI

final class ListViewModel: ObservableObject {
    @Published var saveLists: [AppList] = []
    @Published var serverLists: [AppList] = []
    
    @Published var walkSaveLists: [AppList] = []
    @Published var walkServerLists: [AppList] = []
    
    func getSaveLists() {
        saveLists.removeAll()
        
        if let objcs = RM.readListRealmModel(type: .attend) {
            
            for objc in objcs {
                var isChecked = objc.isChecked
                var link = objc.link
                
                if let saveDate = objc.date,
                   !(Calendar.current.isDate(saveDate, inSameDayAs: Date())) {
                    isChecked = false
                    RM.updateIsCheck(id: "\(objc.id)", isChecked: false, type: .attend)
                }
                
                // 변경된 link 대입
                let mapLists = Dictionary(uniqueKeysWithValues: serverLists.map { ($0.title, $0.link) })
                if let newLink = mapLists[objc.title] {
                    link = newLink
                }
                
                saveLists.append(AppList(realmId: objc.id,
                                         title: objc.title,
                                         link: link,
                                         isChecked: isChecked))
            }
        }
    }
    
    func getServerLists(completion: (() -> Void)? = nil) {
        // 서버 호출 또는 더미 데이터
        let lists = [
            AppList(realmId: nil,
                    title: "홈플러스",
                    link: "homeplus://webUrl?url=https://mfront.homeplus.co.kr/promotion/2025/10/attendance",
                    isChecked: false),
            
            AppList(realmId: nil,
                    title: "신세계면세점",
                    link: "https://www.ssgdfs.com/kr/event/initEventDetail?event_no=E241253101",
                    isChecked: false),
            
            AppList(realmId: nil,
                    title: "롯데면세점",
                    link: "https://m.kor.lottedfs.com/kr/event/eventDetail?evtDispNo=1051495",
                    isChecked: false),
            
            AppList(realmId: nil,
                    title: "신라아이파크면세점",
                    link: "https://m.shillaipark.com/estore/kr/ko/event/eventView?eventId=E57853",
                    isChecked: false),
            
            AppList(realmId: nil,
                    title: "KT",
                    link: "ktmembershipsns://disptype=2&menutype=hot&name=8월%20출석체크&vendorcode=&linkurl=https%3A%2F%2Fapp.membership.kt.com%2Fmembershipv3%2Feventpage%2F1084",
                    isChecked: false),
            
            AppList(realmId: nil,
                    title: "키움",
                    link: "heromts://applink?code=&menu=4950&from=",
                    isChecked: false),
        
            AppList(realmId: nil,
                    title: "신한Pay",
                    link: "shinhan-appcard://goto_screen?screenid=NATIVE|RBFNA8021X01",
                    isChecked: false),
        
            AppList(realmId: nil,
                    title: "모니모",
                    link: "monimoapp://adbrix?",
                    isChecked: false),
        
            AppList(realmId: nil,
                    title: "KBPay",
                    link: "kb-acp://",
                    isChecked: false),
            
            AppList(realmId: nil,
                    title: "국민은행",
                    link: "kbbank://",
                    isChecked: false),
            
            AppList(realmId: nil,
                    title: "토스",
                    link: "supertoss://",
                    isChecked: false),
            
            AppList(realmId: nil,
                    title: "카카오뱅크",
                    link: "kakaobank://open_url?type=event&title=%EC%9D%B4%EB%B2%A4%ED%8A%B8&url=https%3A%2F%2Fevent.kakaobank.com%2Fp%2Fox",
                    isChecked: false),
            
            AppList(realmId: nil,
                    title: "카카오페이",
                    link: "https://link.kakaopay.com/_/NY6a9yS",
                    isChecked: false),
            
            AppList(realmId: nil,
                    title: "하나멤버스월렛",
                    link: "hanawalletmembers://",
                    isChecked: false),
            
            AppList(realmId: nil,
                    title: "네이버페이",
                    link: "https://point.pay.naver.com/main?focus=pp&payapptoolbar=true&closeall=true&from=share_mission",
                    isChecked: false),
        
            AppList(realmId: nil,
                    title: "해피포인트",
                    link: "happypointcard://deeplink?",
                    isChecked: false),
        
            AppList(realmId: nil,
                    title: "신세계포인트",
                    link: "https://preview.page.link/shinsegaepointapp.page.link/R6GT",
                    isChecked: false),
            
            AppList(realmId: nil,
                    title: "신라면세점",
                    link: "https://m.shilladfs.com/estore/kr/ko/event/eventView?eventId=E79722",
                    isChecked: false)]
        
        serverLists = lists
        completion?()
    }
    
    func getWalkSaveLists() {
        walkSaveLists.removeAll()
        
        if let objcs = RM.readListRealmModel(type: .walk) {
            
            for objc in objcs {
                var isChecked = objc.isChecked
                var link = objc.link
                
                if let saveDate = objc.date,
                   !(Calendar.current.isDate(saveDate, inSameDayAs: Date())) {
                    isChecked = false
                    RM.updateIsCheck(id: "\(objc.id)", isChecked: false, type: .walk)
                }
                
                // 변경된 link 대입
                let mapLists = Dictionary(uniqueKeysWithValues: walkServerLists.map { ($0.title, $0.link) })
                if let newLink = mapLists[objc.title] {
                    link = newLink
                }
                
                walkSaveLists.append(AppList(realmId: objc.id,
                                             title: objc.title,
                                             link: link,
                                             isChecked: isChecked))
            }
        }
    }
    
    func getWalkServerLists(completion: (() -> Void)? = nil) {
        // 서버 호출 또는 더미 데이터
        let lists = [
            AppList(realmId: nil,
                    title: "모니모",
                    link: "monimoapp://adbrix?",
                    isChecked: false),
        
            AppList(realmId: nil,
                    title: "국민은행",
                    link: "kbbank://call?cmd=move_to&id=web&url=/mquics?page=D016793&urlparam=",
                    isChecked: false),
            
            AppList(realmId: nil,
                    title: "토스",
                    link: "supertoss://",
                    isChecked: false),
            
            AppList(realmId: nil,
                    title: "카카오뱅크",
                    link: "kakaobank://benefit?type=detail&bnf_id=86&af_deeplink=true&af_dp=kakaobank%3A%2F%2Fbenefit%3Ftype%3Ddetail%26bnf_id%3D86&af_xp=custom&shortlink=frfvcw7m&source_caller=ui",
                    isChecked: false),
            
            AppList(realmId: nil,
                    title: "카카오페이",
                    link: "https://link.kakaopay.com/_/NY6a9yS",
                    isChecked: false)]
        
        walkServerLists = lists
        completion?()
    }
}
