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
    
    @Binding var optionType: Options
    @Binding var todayDate: Date
    @Binding var refreshId: UUID
    
    var body: some View {
        VStack(alignment: .center, content: {
            let lists = optionType == .walk ? appLists.walkSaveLists : appLists.saveLists
            
            List {
                Section {
                    switch optionType {
                    case .walk:
                        ForEach(Array(lists.enumerated()), id: \.element.id, content: { index, list in
                            let list = lists[index]
                            Toggle(isOn: $appLists.walkSaveLists[index].isChecked, label: {
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
                                            appLists.walkSaveLists[index].isChecked = true
                                            RM.updateIsCheck(id: "\(realmId)", isChecked: true, type: optionType)
                                            RM.updateDate(id: "\(realmId)", date: Date.now, type: optionType)
                                        }
                                    }
                                }, label: {
                                    Text(list.title)
                                })
                            })
                            .onChange(of: appLists.walkSaveLists[index].isChecked, { oldValue, newValue in
                                if let realmId = list.realmId {
                                    RM.updateIsCheck(id: "\(realmId)", isChecked: newValue, type: optionType)
                                    RM.updateDate(id: "\(realmId)", date: Date.now, type: optionType)
                                }
                            })
                            .foregroundStyle(Color.init(hex: list.isChecked ? "#999999" : "#222222"))
                            
                        })
                        .onDelete(perform: delete)
                        .onMove(perform: move)
                        
                    case .attend:
                        ForEach(Array(lists.enumerated()), id: \.element.id, content: { index, list in
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
                                            RM.updateIsCheck(id: "\(realmId)", isChecked: true, type: optionType)
                                            RM.updateDate(id: "\(realmId)", date: Date.now, type: optionType)
                                        }
                                    }
                                }, label: {
                                    Text(list.title)
                                })
                            })
                            .onChange(of: appLists.saveLists[index].isChecked, { oldValue, newValue in
                                if let realmId = list.realmId {
                                    RM.updateIsCheck(id: "\(realmId)", isChecked: newValue, type: optionType)
                                    RM.updateDate(id: "\(realmId)", date: Date.now, type: optionType)
                                }
                            })
                            .foregroundStyle(Color.init(hex: list.isChecked ? "#999999" : "#222222"))
                            
                        })
                        .onDelete(perform: delete)
                        .onMove(perform: move)
                    }
                    
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
                appLists.getWalkSaveLists()
            }, content: {
                AppListView(appLists: appLists, optionType: $optionType)
            })
        }).onAppear {
            appLists.getServerLists(completion: {
                appLists.getSaveLists()
            })
            
            appLists.getWalkServerLists(completion: {
                appLists.getWalkSaveLists()
            })
        }
        .sheet(item: $selecteList, content: { list in
            if let url = URL(string: list.link) {
                SafariWebView(url: url)
            }
        })
    }
    
    func delete(at offsets: IndexSet) {
        if let index = offsets.first,
           let realmId = optionType == .attend ? appLists.saveLists[index].realmId : appLists.walkSaveLists[index].realmId,
           let obj = RM.read(obj: ListRealmModel.self, filter: "id == \(realmId) && type == '\(optionType.rawValue)'")?.first {
            RM.delete(obj: obj)
            
            if optionType == .attend {
                appLists.saveLists.remove(atOffsets: offsets)
            } else if optionType == .walk {
                appLists.walkSaveLists.remove(atOffsets: offsets)
            }
        }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        switch optionType {
        case .attend:
            appLists.saveLists.move(fromOffsets: source, toOffset: destination)
            
            for (idx, list) in appLists.saveLists.enumerated() {
                RM.update(obj: ListRealmModel(id: list.realmId ?? 0,
                                              title: list.title,
                                              link: list.link,
                                              isChecked: false,
                                              date: Date.now,
                                              index: idx,
                                              type: optionType))
            }
            
        case .walk:
            appLists.walkSaveLists.move(fromOffsets: source, toOffset: destination)
            
            for (idx, list) in appLists.walkSaveLists.enumerated() {
                RM.update(obj: ListRealmModel(id: list.realmId ?? 0,
                                              title: list.title,
                                              link: list.link,
                                              isChecked: false,
                                              date: Date.now,
                                              index: idx,
                                              type: optionType))
            }
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
