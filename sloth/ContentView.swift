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
            Button(action: {
                self.showPicker.toggle()
            }, label: {
                Text("Push me")
            })
            .sheet(isPresented: self.$showPicker) {
                DocumentPickerView()
            }
            DocumentListView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
