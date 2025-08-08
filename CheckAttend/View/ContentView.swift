//
//  ContentView.swift
//  CheckAttend
//
//  Created by 송은아 on 8/6/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var appLists = ListViewModel()
    @State private var isAdd: Bool = false
    @State private var isWebView: Bool = false
    
    @State private var selecteList: AppList? = nil
    
    var body: some View {
        VStack(alignment: .center, content: {
            let lists = appLists.saveLists
            List {
                ForEach(lists, content: { list in
                    Button(action: {
                        if let encodeLink = list.link.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                           let url = URL(string: encodeLink) {
                            if url.scheme == "https" {
                                selecteList = list
                                isWebView = true
                            } else {
                                UIApplication.shared.open(url)
                            }
                        }
                    }, label: {
                        Text(list.title)
                    })
                    .disabled(list.isChecked)
                    .foregroundStyle(Color.init(hex: list.isChecked ? "#eeeeee" : "#222222"))
                    
                })
                .onDelete(perform: delete)
            }
            Spacer()
            
            Button("추가하기") {
                isAdd = true
            }
            .sheet(isPresented: $isAdd, onDismiss: {
                appLists.getSaveLists()
            }, content: {
                AppListView(appLists: appLists)
            })
        }).onAppear {
//            RM.deleteAll()
            appLists.getSaveLists()
        }
        .sheet(item: $selecteList, content: { list in
            if let url = URL(string: list.link) {
                //                WebView(url: url)
                SafariWebView(url: url)
            }
        })
            
//                .navigationDestination(isPresented: $isWebView) {
//                    if let selecteList = selecteList,
//                       let url = URL(string: selecteList.link) {
//        //                WebView(url: url)
//                        SafariWebView(url: url)
//                    }
//                }
    }
    
    func delete(at offsets: IndexSet) {
        if let index = offsets.first,
           let realmId = appLists.saveLists[index].realmId,
           let obj = RM.read(obj: ListRealmModel.self, filter: "id == \(realmId)")?.first {
            RM.delete(obj: obj)
            
            appLists.saveLists.remove(atOffsets: offsets)
        }
    }
}
