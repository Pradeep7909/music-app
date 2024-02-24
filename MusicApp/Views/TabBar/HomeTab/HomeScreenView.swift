//
//  HomeScreenView.swift
//  MusicApp
//
//  Created by Qualwebs on 12/02/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

struct HomeScreenView: View {
    
    //MARK: Variables
    @EnvironmentObject var songViewModel: SongViewModel
    @State private var hasFetchedData = false
    @EnvironmentObject var audioPlayerManager: AudioPlayerManager
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var showPopup = false
    @State private var isShowingCurrentSongScreen = false
    
    
    //MARK: UI
    var body: some View {
        ZStack {
            ZStack {
                Color.appcolor.ignoresSafeArea(.all)
                VStack{
                    HStack{
                        Text("My Music")
                            .font(.system(size: 25, weight: .bold))
                            .padding(.leading, 20)
                        Spacer()
                    }
                    
                    
                    
                    Spacer()
                    ScrollView {
                        LazyVStack(spacing : 20) {
                            ForEach(songViewModel.allSongs) { song in
                                SongCellView(song: song)
                            }
                        }.padding(.all, 20)
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
                        SingleSongScreenView(song: audioPlayerManager.currentSong ?? staticSongs[0], isDownloadScreen: audioPlayerManager.playingDownloadedScreenSong)
                            .zIndex(1)
                            .environmentObject(audioPlayerManager)
                            .environmentObject(userViewModel)
                    }
                }
                
                .foregroundStyle(.white)
                .navigationBarBackButtonHidden()
                
                
            }
            .zIndex(1)
            .onAppear {
                if !hasFetchedData{
                    userViewModel.fetchUser()
                    songViewModel.fetchAllSongs()
//                    songViewModel.allSongs = staticSongs
                    songViewModel.fetchStoredSongs()
                    hasFetchedData = true
                }
            }
            .onReceive(audioPlayerManager.$showPopUp){ show in
                showPopup = show
            }
    
            PopUpView(isShowing: $showPopup, song: audioPlayerManager.currentSong ?? staticSongs[0])
        }
        .onReceive(userViewModel.$user){ user in
            if showPopup{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    let songPurchased = userViewModel.user?.purchasedSongs?.contains(audioPlayerManager.currentSong!.songId) ?? false
                    showPopup = !songPurchased
                    audioPlayerManager.isSongPurchased = true
                    audioPlayerManager.resume()
                }
            }
        }
    }
}

//MARK: Preview

//struct ContentView_Previews: PreviewProvider {
//    static let audioPlayerManager = AudioPlayerManager()
//    static let  userViewModel = UserViewModel()
//    static var previews: some View {
//        HomeScreenView()
//            .environmentObject(audioPlayerManager)
//            .environmentObject(userViewModel)
//    }
//}

//MARK: SOngCell
struct SongCellView :View {
    var song :  Song
    @EnvironmentObject var audioPlayerManager: AudioPlayerManager
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var songViewModel: SongViewModel
    @State var isSongPlaying = false
    @State var showWave = false
    @State  var downloadedSong = false
    
    var body: some View {
        HStack(spacing : 10){
            NavigationLink(destination: SingleSongScreenView(song: song)
                .environmentObject(audioPlayerManager)
                .environmentObject(userViewModel)
                .environmentObject(songViewModel)){
                    HStack{
                        if downloadedSong{
                            LocalImageView(size: 55, songImage: song.songImage)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }else{
                            NetworkImageView(imageURL: song.songImage, size: 55)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        VStack(alignment: .leading, spacing: 5){
                            Text(song.title)
                                .font(.system(size: 16, weight: .bold))
                            Text(song.artistName)
                                .font(.system(size: 14, weight: .medium))
                        }
                        Spacer()
                    }
                }
                .transition(.move(edge: .bottom))
            if showWave{
                WaveView(isAnimating: Binding<Bool>(
                    get: { isSongPlaying && audioPlayerManager.currentTime != 0 },
                    set: { _ in }
                ), noOfWave: 4)
            }
            Image(systemName: isSongPlaying ? "pause" : "play.fill" )
                .font(.system(size: 25, weight: .bold))
                .foregroundStyle(.frontcolor)
                .padding(.leading , 20)
                .onTapGesture {
                    if audioPlayerManager.currentSong == song{
                        isSongPlaying ?  audioPlayerManager.pause() : audioPlayerManager.resume()
                        audioPlayerManager.isSongPurchased = userViewModel.user?.purchasedSongs?.contains(song.songId) ?? false
                    }else{
                        isSongPlaying ?  audioPlayerManager.pause() : audioPlayerManager.play(song: song)
                        audioPlayerManager.isSongPurchased = userViewModel.user?.purchasedSongs?.contains(song.songId) ?? false
                    }
                    isSongPlaying.toggle()
                }
        }
        .frame(height: 55)
        .id(song.id)
        .onReceive(audioPlayerManager.$currentSong) { currentSong in
            isSongPlaying = currentSong == song
            showWave = currentSong == song
        }
        .onChange(of: song) { newSong in
            isSongPlaying = audioPlayerManager.currentSong == newSong
            showWave = audioPlayerManager.currentSong == newSong
            if audioPlayerManager.currentSong == song{
                isSongPlaying = audioPlayerManager.isPlayingSong
                downloadedSong = audioPlayerManager.playingDownloadedScreenSong
            }
        }
        .onReceive(audioPlayerManager.$isPlayingSong){ isPlaying in
            if audioPlayerManager.currentSong == song{
                isSongPlaying = isPlaying
            }else{
                isSongPlaying =  false
            }
        }
        .onAppear {
            if audioPlayerManager.currentSong == song{
                isSongPlaying = audioPlayerManager.isPlayingSong
                downloadedSong = audioPlayerManager.playingDownloadedScreenSong
            }else{
                isSongPlaying = false
            }
        }
    }
}

