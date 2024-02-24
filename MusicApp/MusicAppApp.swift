//
//  MusicAppApp.swift
//  MusicApp
//
//  Created by Qualwebs on 12/02/24.
//

import SwiftUI
import FirebaseCore

@main
struct MusicAppApp: App {
    init(){
        FirebaseApp.configure()
    }
    
    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var toastColor = Color.red
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modifier(ToastModifier(showToast: $showToast, message: toastMessage, backgroundColor: toastColor))
                .onReceive(NotificationCenter.default.publisher(for: Notification.Name("ShowToastNotification"))) { notification in
                    if let message = notification.object as? (String, Color) {
                        showToast = true
                        toastMessage = message.0
                        toastColor = message.1
                    }
                }
        }
    }
}



//  Documnet :-   Users/qualwebs/Library/Developer/CoreSimulator/Devices/D0CFE9F1-600C-4FA3-B3A1-1E34B77DDD67/data/Containers/Data/Application/1E667E18-9485-4FB4-857A-99BE1FB8D7A6/Documents
