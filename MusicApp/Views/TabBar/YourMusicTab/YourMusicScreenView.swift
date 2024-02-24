//
//  YourMusicScreenView.swift
//  MusicApp
//
//  Created by Qualwebs on 15/02/24.
//

import SwiftUI

struct YourMusicScreenView: View {
    
    @EnvironmentObject var audioPlayerManager: AudioPlayerManager
    @EnvironmentObject var songViewModel: SongViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var hasFetchedData = false
    @State private var showFavorite = false
    @State private var showDownload = false
    @State private var isShowingCurrentSongScreen = false
    @State private var showPopup = false
    @State private var FavSongCollection : [Song]  = []
    
    
    var body: some View {
        ZStack {
            ZStack{
                Color.appcolor.ignoresSafeArea(.all)
                VStack(alignment : .leading){
                    if showFavorite{
                        Text("Favorite Songs")
                            .font(.system(size: 24, weight: .bold))
                            .padding(.leading, 20)
                        ScrollView(.horizontal, showsIndicators: false){
                            HStack(spacing: 20) {
                                ForEach(FavSongCollection){song in
                                    singleSongCollectionCellView(FavCollection: true, song: song)
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    if showDownload{
                        Text("Downloaded Songs")
                            .font(.system(size: 24, weight: .bold))
                            .padding(.leading, 20)
                        ScrollView(.horizontal, showsIndicators: false){
                            HStack(spacing: 20) {
                                ForEach(songViewModel.storedSongs){song in
                                    singleSongCollectionCellView(downdloadCollection: true, song: song)
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    
                    Spacer()
                    
                    HStack{
                        if audioPlayerManager.currentSong != nil{
                            SongCellView(song: audioPlayerManager.currentSong!)
                                .padding(.all, 15)
                            
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .background(.appcolordark)
                    .cornerRadius(10)
                    .padding(.all, 10)
                    .simultaneousGesture(
                        DragGesture()
                            .onChanged { gesture in
                                let threshold: CGFloat = 100
                                if gesture.translation.height < -threshold {
                                    // Swipe up
                                    print("Swiped up")
                                    isShowingCurrentSongScreen = true
                                }
                            }
                    )
                    .fullScreenCover(isPresented: $isShowingCurrentSongScreen) {
                        SingleSongScreenView(song: audioPlayerManager.currentSong ?? staticSongs[0] , isDownloadScreen: audioPlayerManager.playingDownloadedScreenSong)
                            .zIndex(1)
                            .environmentObject(audioPlayerManager)
                            .environmentObject(userViewModel)
                    }
                }
                
                
            }
            .zIndex(1)
            .foregroundStyle(.white)
            .onAppear{
                fetchFavoriteSongs()
                FavSongCollection = songViewModel.favSongs
                showFavorite = songViewModel.favSongs.count != 0
                showDownload = songViewModel.storedSongs.count != 0
                
            }
            .onReceive(songViewModel.$storedSongs){ songs  in
                showDownload =  songs.count != 0
            }
            .onReceive(songViewModel.$favSongs){ songs  in
                showFavorite =  songs.count != 0
                FavSongCollection = songs
            }
            
            
            
            PopUpView(isShowing: $showPopup, song: audioPlayerManager.currentSong ?? staticSongs[0])
        }
        
    }
    func fetchFavoriteSongs() {
        if let favoriteSongIds = userViewModel.user?.favoriteSongs {
            songViewModel.favSongs = favoriteSongIds.compactMap { id in
                songViewModel.allSongs.first { $0.songId == id }
            }
        }
    }
}

#Preview {
    YourMusicScreenView()
}

struct singleSongCollectionCellView : View {
    @EnvironmentObject var audioPlayerManager: AudioPlayerManager
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var songViewModel: SongViewModel
    var downdloadCollection : Bool = false
    var FavCollection : Bool = false
    var song : Song
    @State private var isNavigationActive = false
    @State var showAlert : Bool = false
    
    var body: some View {
        HStack {
            NavigationLink(destination: SingleSongScreenView(song: song, isDownloadScreen : downdloadCollection, isFavScreen: FavCollection)
                .environmentObject(audioPlayerManager)
                .environmentObject(userViewModel)
                .environmentObject(songViewModel),
                           isActive: $isNavigationActive) {
                EmptyView()
            }
            .frame(width: 0, height: 0)
                           .opacity(0)
                           .disabled(true)
            
            
            VStack{
                if downdloadCollection{
                    LocalImageView(size: 140, songImage: song.songImage)
                        .cornerRadius(10)
                } else {
                    NetworkImageView(imageURL: song.songImage, size: 140)
                        .cornerRadius(10)
                }
                Text(song.title)
                    .font(.system(size: 14, weight: .medium))
                Text(song.artistName)
                    .font(.system(size: 12, weight: .regular))
            }
            .frame(width: 140, height: 180)
            .onTapGesture {
                print("Normal tap detected")
                isNavigationActive = true
            }
            .gesture(
                LongPressGesture(minimumDuration: 1.0)
                    .onEnded { _ in
                        print("Long press detected")
                        showAlert.toggle()
                    }
            )
            .alert(isPresented: $showAlert, content: {
                Alert(title: Text(downdloadCollection ? "Do you want delete song \"\(song.title)\" from downloads?" : "Do you want remove song \"\(song.title)\" from favorite?"),
                      primaryButton: .cancel(Text("No")),
                      secondaryButton: .destructive(
                        Text("Yes"),
                        action: {
                            downdloadCollection ? songViewModel.deleteSong(song: song) : songViewModel.removeFavoriteSong(song: song, userViewModel: userViewModel)
                            
                        }
                      )
                )
            })
        }
    }
}
