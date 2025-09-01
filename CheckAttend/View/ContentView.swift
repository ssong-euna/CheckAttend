//
//  ContentView.swift
//  CheckAttend
//
//  Created by 송은아 on 8/6/25.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase
    
    @StateObject var appLists = ListViewModel()
    @State private var isAdd: Bool = false
    @State private var isWebView: Bool = false
    
    @State private var selecteList: AppList? = nil
    
    @Binding var todayDate: Date
    @Binding var refreshId: UUID
    
    var body: some View {
        VStack(alignment: .center, content: {
            let lists = appLists.saveLists
            List {
                Section {
                    ForEach(lists.indices, id: \.self, content: { index in
                        let list = lists[index]
                        Toggle(isOn: $appLists.saveLists[index].isChecked, label: {
                            Button(action: {
                                if let encodeLink = list.link.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                                   let url = URL(string: encodeLink) {
                                    if url.scheme == "https" {
                                        selecteList = list
                                        isWebView = true
                                        
                                    } else {
                                        UIApplication.shared.open(url)
                                    }
                                    
                                    if let realmId = list.realmId {
                                        appLists.saveLists[index].isChecked = true
                                        RM.updateIsCheck(id: "\(realmId)", isChecked: true)
                                        RM.updateDate(id: "\(realmId)", date: Date.now)
                                    }
                                }
                            }, label: {
                                Text(list.title)
                            })
                        })
                        .onChange(of: appLists.saveLists[index].isChecked, { oldValue, newValue in
                            if let realmId = list.realmId {
                                RM.updateIsCheck(id: "\(realmId)", isChecked: newValue)
                                RM.updateDate(id: "\(realmId)", date: Date.now)
                            }
                        })
                        .foregroundStyle(Color.init(hex: list.isChecked ? "#999999" : "#222222"))
                        
                    })
                    .onDelete(perform: delete)
                    .onMove(perform: move)
                } header: {
                    Button(action: {
                        RM.deleteAll()
                        refreshId = UUID()
                    }, label: {
                        Text("모두 삭제")
                            .padding(.bottom, 10)
                    })
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
            .listStyle(.insetGrouped)
            .onChange(of: scenePhase) { oldValue, newValue in
                if newValue == .active {
                    if checkDate() {
                        todayDate = Date()
                        refreshId = UUID()
                    }
                }
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
            appLists.getSaveLists()
        }
        .sheet(item: $selecteList, content: { list in
            if let url = URL(string: list.link) {
                SafariWebView(url: url)
            }
        })
    }
    
    func delete(at offsets: IndexSet) {
        if let index = offsets.first,
           let realmId = appLists.saveLists[index].realmId,
           let obj = RM.read(obj: ListRealmModel.self, filter: "id == \(realmId)")?.first {
            RM.delete(obj: obj)
            
            appLists.saveLists.remove(atOffsets: offsets)
        }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        appLists.saveLists.move(fromOffsets: source, toOffset: destination)
        
        for (idx, list) in appLists.saveLists.enumerated() {
            RM.update(obj: ListRealmModel(id: list.realmId ?? 0,
                                          title: list.title,
                                          link: list.link,
                                          isChecked: false,
                                          date: Date.now,
                                          index: idx))
        }
    }
    
    func checkDate() ->  Bool {
        if Calendar.current.isDate(todayDate, inSameDayAs: Date()) {
            return false
        } else {
            return true
        }
    }
}
