//
//  ContentView.swift
//  NextTrain
//
//  Created by WOO Yu Kit Vincent on 19/12/2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView{
            List{
                Text("Hello, world!")
            }
            .navigationBarTitle("Next Train Widget")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
