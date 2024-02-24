//
//  SingleSongScreen.swift
//  MusicApp
//
//  Created by Qualwebs on 13/02/24.
//

import SwiftUI
import AVKit
import FirebaseFirestore


struct SingleSongScreenView: View {
    
    //MARK: Variables
    var song :  Song
    @State var playSong : Bool = false
    var  slideSize = ScreenSize.size.width - 100
    var isDownloadScreen : Bool = false
    var isFavScreen : Bool = false
    
    @State var totalSongs : Int = 0
    @State private var progress: Double = 0
    @State private var isSongPlaying : Bool = false
    @State private var currentTime: TimeInterval = 0
    @State private var duration: TimeInterval = 0
    @EnvironmentObject var audioPlayerManager: AudioPlayerManager
    @State private var showPopup = false
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var songViewModel: SongViewModel
    @State private var isSongPurchased: Bool = false
    @State private var isSongAlreadySetup : Bool = false
    @State private var isFav : Bool = false
    @State private var isSliderUpdating : Bool = false
    @State private var navigatetoNewSong : Bool = false
    @State private var currentSongIndex = 0
    @State private var currentSong : Song = staticSongs[0]
    @GestureState private var dragOffset : CGFloat = 0
    @State private var songCollection : [Song] = []
    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var toastColor = Color.red
    @State private var isDownloaded = false
    @State private var downloadImageName = "arrow.down.to.line"
    @State private var showLoadingView : Bool =  false
    @State private var isDownloading : Bool = false
    
    
    //MARK: UI
    var body: some View {
        ZStack {
            ZStack{
                Color.appcolor.ignoresSafeArea(.all)
                VStack(spacing: 20){
                    HStack {
                        BackButtonView()
                        Spacer()
                        Text("Now Playing")
                            .font(.system(size: 20, weight: .bold))
                            .padding(.trailing , 20)
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    
                    PurchasedView(height: 50, isPurchased: $isSongPurchased)
                    
                    ZStack{
                        ForEach(0..<totalSongs , id: \.self){ index in
                            if isDownloadScreen{
                                LocalImageView(size: slideSize, songImage: songCollection[index].songImage)
                                    .frame(width: slideSize, height: slideSize)
                                    .cornerRadius(20)
                                    .opacity(currentSongIndex ==  index ? 1 : 0.8)
                                    .scaleEffect(currentSongIndex == index ? 1 : 0.8)
                                    .offset(x: CGFloat(index - currentSongIndex) * slideSize + dragOffset, y :0)
                                
                            }else{
                                NetworkImageView(imageURL: songCollection[index].songImage, size: slideSize)
                                    .frame(width: slideSize, height: slideSize)
                                    .cornerRadius(20)
                                    .opacity(currentSongIndex ==  index ? 1 : 0.8)
                                    .scaleEffect(currentSongIndex == index ? 1 : 0.8)
                                    .offset(x: CGFloat(index - currentSongIndex) * slideSize + dragOffset, y :0)
                            }
                            
                        }
                    }
                    .frame(height: slideSize)
                    .gesture(
                        DragGesture()
                            .onEnded(){ value in
                                let threshold : CGFloat = 50
                                if value.translation.width > threshold {
                                    withAnimation{
                                        currentSongIndex = max(0, currentSongIndex - 1)
                                        playSong = true
                                    }
                                }else if value.translation.width < -threshold{
                                    withAnimation{
                                        currentSongIndex = min(songCollection.count - 1, currentSongIndex + 1 )
                                        playSong = true
                                    }
                                }
                            }
                    )
                    
                    VStack(spacing : 5){
                        Text(currentSong.title)
                            .font(.system(size: 24, weight: .bold))
                        Text(currentSong.artistName)
                            .font(.system(size: 16, weight: .medium))
                    }
                    
                    
                    HStack(spacing: 50){
                        if(!isDownloaded){
                            Image(systemName: downloadImageName)
                                .font(.system(size: 30, weight: .medium))
                                .foregroundStyle(isSongPurchased ? .white : .white.opacity(0.5))
                                .onTapGesture {
                                    if (!isSongPurchased){
                                        showPopup = true
                                    }else{
                                        print("download song..")
                                        downloadImageName = "arrow.down"
                                        isDownloading = true
                                        songViewModel.downloadSong(song: currentSong)
                                    }
                                }
                                .overlay(
                                    isDownloading ? AnyView(CircularLoadingView(diameter: 40)) : AnyView(EmptyView())
                                )
                        }
                        Image(systemName: isFav ? "heart.fill" : "heart")
                            .font(.system(size: 30, weight: .medium))
                            .foregroundStyle( isFav ? .red : .white)
                            .onTapGesture {
                                isFav ? songViewModel.removeFavoriteSong(song: currentSong, userViewModel: userViewModel) : songViewModel.addFavoriteSong(song: currentSong, userViewModel: userViewModel)
                                isFav.toggle()
                            }
                    }
                    .frame(height: 30)
                    
                    WaveView(isAnimating: Binding<Bool>(
                        get: { isSongPlaying && audioPlayerManager.currentTime != 0 },
                        set: { _ in }
                    ), noOfWave: 6)
                    
                    VStack(spacing: 0) {
                        Slider(value: $progress,
                               onEditingChanged: { editing in
                            if (audioPlayerManager.currentSong == currentSong ){
                                editing ? isSliderUpdating = editing : DispatchQueue.main.asyncAfter(deadline: .now() + 1 ){
                                    isSliderUpdating = editing
                                }
                                
                                let TimeInSeconds = progress * duration
                                let time = CMTime(seconds: TimeInSeconds, preferredTimescale: 1)
                                audioPlayerManager.audioPlayer.seek(to: time)
                                audioPlayerManager.resume()
                                isSongPlaying = true
                            }
                        })
                        .tint(.frontcolor)
                        
                        HStack{
                            Text(formattedTime(progress * duration))
                            Spacer()
                            Text(formattedTime(duration))
                        }
                    }
                    .padding(.horizontal, 30)
                    
                    HStack(spacing: 50){
                        Image(systemName: "backward.end")
                            .font(.system(size: 30))
                            .onTapGesture {
                                withAnimation {
                                    currentSongIndex = max(0, currentSongIndex - 1)
                                }
                                playSong = true
                            }
                        HStack{
                            Circle()
                                .frame(width: 50, height: 50)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .fill(LinearGradient(gradient: Gradient(colors: [.red, .frontcolor]), startPoint: .top, endPoint: .bottom))
                                )
                                .onTapGesture {
                                    if !isSongAlreadySetup {
                                        audioPlayerManager.play(song: currentSong, downloaded: isDownloadScreen)
                                        audioPlayerManager.isSongPurchased = isSongPurchased
                                        isSongAlreadySetup = true
                                    }else{
                                        isSongPlaying ? audioPlayerManager.pause() : audioPlayerManager.resume()
                                        isSongPlaying.toggle()
                                    }
                                }
                                .overlay(
                                    ZStack{
                                        Image(systemName: isSongPlaying ? "pause" : "play")
                                            .font(.system(size: 30))
                                        if(isSongPlaying && currentTime == 0){
                                            CircularLoadingView(diameter: 60)
                                        }
                                        
                                    }
                                )
                        }
                        
                        Image(systemName: "forward.end")
                            .font(.system(size: 30))
                            .onTapGesture{
                                withAnimation {
                                    currentSongIndex = min(songCollection.count - 1, currentSongIndex + 1 )
                                }
                                playSong = true
                            }
                    }
                    .padding(.bottom , 20)
                }
                
            }
            .zIndex(1)
            .navigationBarBackButtonHidden()
            .foregroundStyle(.white)
            .onAppear {
                
                currentSong = song
                isFav = userViewModel.user?.favoriteSongs?.contains(currentSong.songId) ?? false
                
                isDownloaded = songViewModel.storedSongs.contains(where: { $0.songId == currentSong.songId })
                songCollection = isDownloadScreen ? songViewModel.storedSongs : (isFavScreen ? songViewModel.favSongs : songViewModel.allSongs)
                totalSongs = songCollection.count
                if let currentIndex = songCollection.firstIndex(where: { $0.songId == currentSong.songId }) {
                    currentSongIndex = currentIndex
                }
                if audioPlayerManager.currentSong == currentSong{
                    self.duration = audioPlayerManager.songDuration
                    self.isSongPurchased = audioPlayerManager.isSongPurchased
                    isSongPlaying = audioPlayerManager.isPlayingSong
                    isSongAlreadySetup = true
                    if duration == 0{
                        audioPlayerManager.getDuration(song: currentSong, downloaded: isDownloadScreen) { duration in
                            self.duration = duration
                        }
                    }
                }else{
                    audioPlayerManager.getDuration(song: currentSong, downloaded: isDownloadScreen) { duration in
                        self.duration = duration
                    }
                    checkIfSongIsPurchased(songId: currentSong.songId)
                }
            }
            .onReceive(audioPlayerManager.$isPlayingSong){ isPlaying in
                if audioPlayerManager.currentSong ==  song{
                    isSongPlaying = isPlaying
                }
            }
            .onReceive(audioPlayerManager.$currentTime){ time in
                
                if audioPlayerManager.currentSong == currentSong{
                    if(!isSliderUpdating){
                        currentTime = time
                        progress = currentTime / audioPlayerManager.songDuration
                    }
                }
            }
            PopUpView(isShowing: $showPopup, song: currentSong)
        }
        .onReceive(userViewModel.$user){ user in
            if showPopup{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    let songPurchased = userViewModel.user?.purchasedSongs?.contains(currentSong.songId) ?? false
                    showPopup = !songPurchased
                    isSongPurchased = songPurchased
                    audioPlayerManager.isSongPurchased = true
                    audioPlayerManager.resume()
                    NotificationCenter.default.post(name: Notification.Name("ShowToastNotification"), object: ("Song is purchased", Color.green))
                }
            }
        }
        .onReceive(audioPlayerManager.$showPopUp){ show in
            if audioPlayerManager.currentSong == currentSong{
                showPopup = show
            }
        }
        .onReceive(songViewModel.$storedSongs){ storedSongs in
            isDownloaded = storedSongs.contains(where: { $0.songId == currentSong.songId })
        }
        .onChange(of: currentSongIndex) { newIndex in
            if playSong{
                print("play new song.........")
                currentSong = songCollection[newIndex]
                currentTime = 0
                progress = currentTime / audioPlayerManager.songDuration
                isFav = userViewModel.user?.favoriteSongs?.contains(currentSong.songId) ?? false
                downloadImageName = "arrow.down.to.line"
                isDownloading =  false
                isDownloaded = songViewModel.storedSongs.contains(where: { $0.songId == currentSong.songId })
                isSongAlreadySetup = true
                isSongPlaying = true
                
                audioPlayerManager.play(song: currentSong, downloaded: isDownloadScreen)
                audioPlayerManager.isSongPurchased = userViewModel.user?.purchasedSongs?.contains(currentSong.songId) ?? false
                audioPlayerManager.getDuration(song: currentSong, downloaded: isDownloadScreen) { duration in
                    self.duration = duration
                }
                checkIfSongIsPurchased(songId: currentSong.songId)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("ShowToastNotification"))) { notification in
            if let message = notification.object as? (String, Color) {
                showToast = true
                toastMessage = message.0
                toastColor = message.1
            }
            print("toast message received")
        }
        .modifier(ToastModifier(showToast: $showToast, message: toastMessage, backgroundColor: toastColor))
    }
    
    
    //MARK: Action Functions
    
    func formattedTime(_ time: Double) -> String {
        if time.isInfinite || time.isNaN {
            return "00:00"
        } else {
            let minutes = Int(time) / 60
            let seconds = Int(time) % 60
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
    
    func checkIfSongIsPurchased(songId: String) {
        guard let user = userViewModel.user else {
            isSongPurchased = false
            return
        }
        isSongPurchased = user.purchasedSongs?.contains(songId) ?? false
        print("isSongPurchased : \(isSongPurchased)")
    }
}

//MARK: Preview
//
//struct ContentView_Previews: PreviewProvider {
//    static let audioPlayerManager = AudioPlayerManager()
//    static let  userViewModel = UserViewModel()
//    static var previews: some View {
//        SingleSongScreenView(song: staticSongs[0])
//            .environmentObject(audioPlayerManager)
//            .environmentObject(userViewModel)
//    }
//}

struct PurchasedView: View {
    var height : CGFloat
    @Binding var isPurchased: Bool
    var color: Color {
        isPurchased ? .green : .red
    }
    
    var body: some View {
        ZStack {
            Color.appcolor.ignoresSafeArea(.all)
            Circle()
                .stroke(color.opacity(0.4), lineWidth: 5)
                .frame(width: 40)
            Text(isPurchased ? "Purchased" : "Not Purchased")
                .foregroundColor(color)
                .font(.system(size: 14, weight: .bold))
        }
        .frame(height: height)
    }
}

//MARK: Popup View
struct PopUpView :View {
    @Binding var isShowing: Bool
    @State private var isPurchaseButtonDisable = false
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var audioPlayerManager: AudioPlayerManager
    var song : Song
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.1).ignoresSafeArea(.all)
            
            VStack {
                HStack{
                    VStack(alignment: .leading, spacing: 0){
                        Text("Song Cost : \(song.cost)")
                            .font(.system(size: 14))
                        Text("Your Credit : \(userViewModel.user?.credit ?? 0)")
                            .font(.system(size: 14))
                    }
                    .padding(.bottom, 10)
                    Spacer()
                    Image(systemName: "xmark")
                        .font(.system(size: 20, weight: .medium))
                        .onTapGesture {
                            isShowing = false
                            audioPlayerManager.showPopUp = false
                            isPurchaseButtonDisable = false
                        }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                Text(song.title)
                    .font(.system(size: 22, weight: .semibold))
                Text(song.artistName)
                    .font(.system(size: 16, weight: .semibold))
                Text("To access the full song, please purchase it.")
                    .font(.system(size: 20, weight: .medium))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                
                Button("Purchase") {
                    isPurchaseButtonDisable = true
                    if(userViewModel.user?.credit ?? 0 < song.cost){
                        NotificationCenter.default.post(name: Notification.Name("ShowToastNotification"), object: ("Your Credit is less", Color.red))
                    }else{
                        addPurchasedSong(song: song, userViewModel: userViewModel)
                    }
                    
                }
                .foregroundColor(.white)
                .padding(.all, 10)
                .background(Color.frontcolor)
                .cornerRadius(10)
                .padding(.bottom, 30)
                .disabled(isPurchaseButtonDisable)
            }
            .frame(maxWidth: .infinity)
            .background(.appcolordark)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(.horizontal, 20)
            .shadow(radius: 20)
        }
        .zIndex(isShowing ? 2 : 0)
    }
}

