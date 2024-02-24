//
//  AudioPlayerManager.swift
//  MusicApp
//
//  Created by Qualwebs on 14/02/24.
//
import SwiftUI
import AVKit

let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

class AudioPlayerManager: ObservableObject {
    @Published var audioPlayer = AVPlayer()
    @Published var currentSong: Song?
    @Published var isPlayingSong : Bool = false
    @Published var isSongPurchased : Bool = false
    @Published var currentTime : TimeInterval = 0
    @Published var songDuration : TimeInterval = 0
    @Published var showPopUp : Bool = false
    @Published var playingDownloadedScreenSong : Bool = false
    
    var tempDuration : TimeInterval = 0
    var timeObserver: Any?
    
    func getDuration(song: Song, downloaded : Bool = false, completion: @escaping (Double) -> Void) {
        
        var songURL: URL
        if downloaded{
            songURL = documentsDirectory.appendingPathComponent(song.url)
        }else{
            guard let url = URL(string: song.url) else {
                print("Invalid local file URL")
                return
            }
            songURL = url
        }
        let playerItem = AVPlayerItem(url: songURL)
        playerItem.asset.loadValuesAsynchronously(forKeys: ["duration"]) {
            var error: NSError?
            let status = playerItem.asset.statusOfValue(forKey: "duration", error: &error)
            if status == .loaded {
                let durationInSeconds = playerItem.asset.duration.seconds
                let duration = durationInSeconds.isFinite ? durationInSeconds : 0
                DispatchQueue.main.async {
                    self.tempDuration = duration
                    completion(duration)
                }
            } else {
                print("Failed to load duration of song  :", error?.localizedDescription ?? "Unknown error")
                print("url of song : \(songURL)")
                DispatchQueue.main.async {
                    completion(0)
                }
            }
        }
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: audioPlayer.currentItem, queue: .main) { _ in
            self.isPlayingSong = false
        }
    }
    
    
    func play(song: Song, downloaded : Bool = false) {
        if let observer = timeObserver {
            audioPlayer.removeTimeObserver(observer)
            timeObserver = nil
        }
        currentSong = song
        currentTime = 0
        playingDownloadedScreenSong = downloaded
        var url: URL
        
        if downloaded{
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            url = documentsDirectory.appendingPathComponent(song.url)
        }else{
            guard let songURL = URL(string: song.url) else {
                print("Invalid local file URL")
                return
            }
            url = songURL
        }
        
        getDuration(song: song, downloaded: downloaded) { time in
            self.songDuration = time
        }
        let playerItem = AVPlayerItem(url: url)
        audioPlayer = AVPlayer(playerItem: playerItem)
        timeObserver = audioPlayer.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: .main) { time in
            self.currentTime = time.seconds
            if self.currentTime >= 30 && self.isSongPurchased == false {
                self.pause()
                self.isPlayingSong = false
                self.showPopUp = true
            }
        }
        
        showPopUp = false
        resume()
    }
    
    
    func resume() {
        audioPlayer.play()
        showPopUp = false
        isPlayingSong = true
    }
    
    func pause() {
        audioPlayer.pause()
        isPlayingSong = false
    }
    
    func stop() {
        audioPlayer.pause()
        audioPlayer.seek(to: .zero)
        isPlayingSong = false
    }
    
    func seek(to time: CMTime) {
        audioPlayer.seek(to: time)
    }
    
    func reset() {
        audioPlayer.pause()
        currentSong = nil
        isPlayingSong = false
        isSongPurchased = false
        currentTime = 0
        songDuration = 0
        showPopUp = false
        playingDownloadedScreenSong = false
        
        if let observer = timeObserver {
            audioPlayer.removeTimeObserver(observer)
            timeObserver = nil
        }
    }
}


