//
//  ContentView.swift
//  sloth
//
//  Created by Rain Qian on 2022/11/18.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            DocumentListView()
//            WebListView()
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
