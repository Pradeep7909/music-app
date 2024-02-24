//
//  ContentView.swift
//  MusicApp
//
//  Created by Qualwebs on 12/02/24.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("uid") var userId : String = ""
    @StateObject var audioPlayerManager = AudioPlayerManager()
    @StateObject var userViewModel = UserViewModel()
    @StateObject var songViewModel = SongViewModel()

    
    var body: some View {
        NavigationView {
            if userId == "" {
                LoginScreenView()
            } else{
                MainScreenView()
                    .environmentObject(audioPlayerManager)
                    .environmentObject(userViewModel)
                    .environmentObject(songViewModel)
            }
        }
    }
}

#Preview {
    ContentView()
}
