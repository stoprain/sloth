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
            NavigationView {
                VStack {
                    Button(action: {
                        self.showPicker.toggle()
                    }, label: {
                        Text("Add EPUB from Files")
                    })
                    .sheet(isPresented: self.$showPicker) {
                        DocumentPickerView()
                    }
                    .frame(height: 100)
                  
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
