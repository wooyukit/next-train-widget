//
//  NextTrainApp.swift
//  NextTrainWatch WatchKit Extension
//
//  Created by WOO Yu Kit Vincent on 26/12/2021.
//

import SwiftUI

@main
struct NextTrainApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
