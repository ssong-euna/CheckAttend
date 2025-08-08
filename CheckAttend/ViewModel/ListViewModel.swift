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
    
    func getSaveLists() {
        saveLists.removeAll()
        
        if let objcs = RM.readListRealmModel() {
            
            for objc in objcs {
                var isChecked = objc.isChecked
                
                if let saveDate = objc.date,
                   !(Calendar.current.isDate(saveDate, inSameDayAs: Date())) {
                    isChecked = false
                    RM.updateIsCheck(id: "\(objc.id)", isChecked: false)
                }
                
                saveLists.append(AppList(realmId: objc.id,
                                         title: objc.title,
                                         link: objc.link,
                                         isChecked: isChecked))
            }
        }
    }

    func getServerLists() {
        // 서버 호출 또는 더미 데이터
        let lists = [
            AppList(realmId: nil,
                    title: "홈플러스",
                    link: "homeplus://webUrl?url=https://mfront.homeplus.co.kr/promotion/2025/08/attendance",
                    isChecked: false),
            
            AppList(realmId: nil,
                    title: "마이홈플러스",
                    link: "myhomeplus://strUrl=/event/atnd?evntNo=7238",
                    isChecked: false),
            
            AppList(realmId: nil,
                    title: "신세계면세점",
                    link: "https://www.ssgdfs.com/kr/event/initEventDetail?event_no=E241253101",
                    isChecked: false),
            
            AppList(realmId: nil,
                    title: "롯데면세점",
                    link: "https://m.kor.lottedfs.com/kr/event/eventDetail?evtDispNo=1050757",
                    isChecked: false),
            
            AppList(realmId: nil,
                    title: "신라아이파크면세점",
                    link: "https://m.shillaipark.com/estore/kr/ko/event/eventView?eventId=E57853",
                    isChecked: false),
            
            AppList(realmId: nil,
                    title: "KT",
                    link: "ktmembershipsns://disptype=2&menutype=hot&name=8월%20출석체크&vendorcode=&linkurl=https%3A%2F%2Fapp.membership.kt.com%2Fmembershipv3%2Feventpage%2F1084&imageurl=https%3A%2F%2Fapp.membership.kt.com%2Feventpage%2Fevn1084%2Fsns_banner.png%3F0505&closeconfirm=&login=Y&snstype=etc",
                    isChecked: false),
            
            AppList(realmId: nil,
                    title: "핫핑",
                    link: "https://m.hotping.co.kr/attend/stamp.html",
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
                    link: "monimopay://",
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
                    link: "https://kakaobank.onelink.me/0qMi/ysxkqbud",
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
                    isChecked: false)]
        
        let links = Set(saveLists.map { $0.link })
        serverLists = lists.filter { !links.contains($0.link) }
    }
}
