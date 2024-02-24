//
//  MainView.swift
//  MusicApp
//
//  Created by Qualwebs on 12/02/24.
//

import SwiftUI

struct MainScreenView: View {
    var body: some View {
        NavigationStack{
            TabView(){
                HomeScreenView()
                    .tabItem { Label("Home", systemImage: "house") }
                YourMusicScreenView()
                    .tabItem { Label("Your Music", systemImage: "music.note.list") }
                ProfileScreenView()
                    .tabItem { Label("Profile", systemImage: "person") }
            }
            .tint(.frontcolor)
            .onAppear() {
                UITabBar.appearance().barTintColor = UIColor(.appcolor)
                UITabBar.appearance().backgroundColor = UIColor(.appcolor)
            }
        }
    }
}

#Preview {
    MainScreenView()
}
