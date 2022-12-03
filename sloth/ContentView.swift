//
//  ContentView.swift
//  sloth
//
//  Created by Rain Qian on 2022/11/18.
//

import SwiftUI

struct ContentView: View {
    
    @State var showPicker = false
    
    var body: some View {
        VStack {
            NavigationStack {
                VStack {
                    NavigationLink {
                        DocumentListView()
                    } label: {
                        Text("EPUB")
                    }
                    .frame(height: 100)
                  
                    NavigationLink {
                        WebListView()
                    } label: {
                        Text("Web Bookmarks")
                    }
                    .frame(height: 100)
                }
                .sheet(isPresented: self.$showPicker) {
                    DocumentPickerView()
                }
                .navigationTitle("")
                .toolbar {
                    ToolbarItemGroup(placement: .primaryAction) {
                        Menu(content: {
                            Button(action: {
                              self.showPicker.toggle()
                            }) {
                                Label("Add from Files", systemImage: "folder")
                            }
                        }, label: {
                            Image(systemName: "plus")
                            
                        })
                    }
                }
            }
        }
        .onAppear {

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
