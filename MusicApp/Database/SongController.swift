//
//  SongController.swift
//  MusicApp
//
//  Created by Qualwebs on 13/02/24.
//

import SwiftUI
import FirebaseFirestore
import CoreData

class SongViewModel: ObservableObject {
    @Published var allSongs: [Song] = []
    @Published var storedSongs : [Song] = []
    @Published var favSongs : [Song] = []
    private var db = Firestore.firestore()

    func fetchAllSongs() {
        db.collection("songs").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching songs: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No songs found")
                return
            }
            
            self.allSongs = documents.compactMap { queryDocumentSnapshot in
                let data = queryDocumentSnapshot.data()
                let id = queryDocumentSnapshot.documentID
                let artistName = data["artistName"] as? String ?? ""
                let title = data["title"] as? String ?? ""
                let url = data["url"] as? String ?? ""
                let image = data["songImage"] as? String ?? ""
                let cost = data["cost"] as? Int ?? 0
                return Song(songId: id, artistName: artistName, title: title, url: url, songImage: image, cost: cost)
            }
        }
    }
    
    
    func addFavoriteSong(song: Song, userViewModel: UserViewModel) {
        print("addFavoriteSong executing")
        guard let currentUser = userViewModel.user else {
            print("User is nil")
            return
        }
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(currentUser.uid)
        userRef.updateData([
            "favoriteSongs": FieldValue.arrayUnion([song.songId])
        ]) { error in
            if let error = error {
                print("Error updating favoriteSongs: \(error)")
            } else {
                print("Successfully updated favoriteSongs")
                var updatedUser = currentUser
                updatedUser.favoriteSongs?.append(song.songId)
                self.favSongs.append(song)
                NotificationCenter.default.post(name: Notification.Name("ShowToastNotification"), object: ("Song is added as favorite", Color.green))
                userViewModel.updateUser(user: updatedUser)
                print("Updated user in local storage")
            }
        }
    }
    
    
    func removeFavoriteSong(song: Song, userViewModel: UserViewModel) {
        print("removeFavoriteSong executing")
        guard let currentUser = userViewModel.user else {
            print("User is nil")
            return
        }
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(currentUser.uid)
        userRef.updateData([
            "favoriteSongs": FieldValue.arrayRemove([song.songId])
        ]) { error in
            if let error = error {
                print("Error removing song from favoriteSongs: \(error)")
            } else {
                print("Successfully removed song from favoriteSongs")
                var updatedUser = currentUser
                if let index = updatedUser.favoriteSongs?.firstIndex(of: song.songId) {
                    updatedUser.favoriteSongs?.remove(at: index)
                }
                if let index = self.favSongs.firstIndex(of: song) {
                    self.favSongs.remove(at: index)
                }
                
                NotificationCenter.default.post(name: Notification.Name("ShowToastNotification"), object: ("Song is removed from favorites", Color.green))
                userViewModel.updateUser(user: updatedUser)
                print("Updated user in local storage")
            }
        }
    }
    
    
    
    //MARK: Core Data
    
    let context = PersistenceController.shared.container.viewContext
    
    func fetchStoredSongs() {
        storedSongs = fetchSongs()
    }
    
    private func fetchSongs() -> [Song] {
        let fetchRequest: NSFetchRequest<SongEntity> = SongEntity.fetchRequest()
        do {
            let songEntities = try context.fetch(fetchRequest)
            return songEntities.map { songEntity in
                Song(songId: songEntity.songId!, artistName: songEntity.artistName!, title: songEntity.title!, url: songEntity.url!, songImage: songEntity.songImage!, cost: Int(songEntity.cost))
            }
        } catch {
            print("Error fetching songs: \(error)")
            return []
        }
    }

    // Save a song to Core Data
    func saveSong(song: Song) {
        let songEntity = SongEntity(context: context)
        songEntity.songId = song.songId
        songEntity.artistName = song.artistName
        songEntity.title = song.title
        songEntity.url = song.url
        songEntity.songImage = song.songImage
        songEntity.cost = Int16(song.cost)
        
        do {
            try context.save()
            print("Data saved in Core Data successfully")
            storedSongs.append(song)
            NotificationCenter.default.post(name: Notification.Name("ShowToastNotification"), object: ("Song Downloaded", Color.green))
        } catch {
            print("Error saving song: \(error)")
        }
    }
    
    func downloadSong(song : Song){
        var savingSong : Song = song
        if let audioURL = URL(string: song.url) {
            AudioFileManager.downloadAudio(from: audioURL, songTitle: song.title) { result in
                switch result {
                case .success(let localURL):
                    print("Audio downloaded successfully and saved at: \(localURL)")
                    savingSong.url = song.title.replacingOccurrences(of: " ", with: "") + "_audio.mp3"
                    self.downloadImage(from: URL(string: song.songImage)!, songTitle: song.title) { pathURL in
                        if let path = pathURL{
                            print("image saved at : \(path)")
                            savingSong.songImage = song.title.replacingOccurrences(of: " ", with: "") + "_image.jpg"
                            self.saveSong(song: savingSong)
                            
                        }else{
                            print("error downloading image")
                        }
                    }
                case .failure(let error):
                    print("Failed to download audio: \(error.localizedDescription)")
                }
            }
        } else {
            print("Invalid audio URL")
        }
    }
    
    
    func downloadImage(from url: URL,songTitle : String, completion: @escaping (URL?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Failed to download image: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            
            // Get the URL for the Documents directory
            guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                print("Failed to get Documents directory URL")
                completion(nil)
                return
            }
            
            let destinationFileName = "\(songTitle.replacingOccurrences(of: " ", with: ""))_image.jpg"
            let fileURL = documentsURL.appendingPathComponent(destinationFileName)
            
            // Write the image data to the file URL
            do {
                try data.write(to: fileURL)
                completion(fileURL)
            } catch {
                print("Error saving image to documents directory: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }
    
    
    
    func deleteSong(song: Song) {
        let audioFileName = song.title.replacingOccurrences(of: " ", with: "") + "_audio.mp3"
        let imageFileName = song.title.replacingOccurrences(of: " ", with: "") + "_image.jpg"
        
        if let audioURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(audioFileName),
           let imageURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(imageFileName) {
            
            do {
                try FileManager.default.removeItem(at: audioURL)
                print("Audio file deleted successfully")
            } catch {
                print("Error deleting audio file: \(error.localizedDescription)")
            }
            
            do {
                try FileManager.default.removeItem(at: imageURL)
                print("Image file deleted successfully")
            } catch {
                print("Error deleting image file: \(error.localizedDescription)")
            }
        } else {
            print("Error constructing file URLs")
        }

        let fetchRequest: NSFetchRequest<SongEntity> = SongEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "songId == %@", song.songId)
        
        do {
            let songs = try context.fetch(fetchRequest)
            guard let songEntity = songs.first else {
                print("Song not found in Core Data")
                return
            }
            
            context.delete(songEntity)
            try context.save()
            print("Song deleted from Core Data")
            
            if let index = storedSongs.firstIndex(where: { $0.songId == song.songId }) {
                storedSongs.remove(at: index)
                NotificationCenter.default.post(name: Notification.Name("ShowToastNotification"), object: ("Removed from Downloads", Color.green))
            }
        } catch {
            print("Error deleting song from Core Data: \(error.localizedDescription)")
        }
    }

    
}




struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init() {
        print("init PersistenceController")
        container = NSPersistentContainer(name: "SongStore")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("Error initializing Core Data: \(error)")
            }
            print("storeDescription \(storeDescription)")
        }
    }
}



struct AudioFileManager {
    static func downloadAudio(from url: URL, songTitle : String, completion: @escaping (Result<URL, Error>) -> Void) {
        let task = URLSession.shared.downloadTask(with: url) { location, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let location = location else {
                completion(.failure(NSError(domain: "InvalidLocation", code: 0, userInfo: nil)))
                return
            }
            
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let destinationFileName = "\(songTitle.replacingOccurrences(of: " ", with: ""))_audio.mp3"
            let destinationURL = documentsURL.appendingPathComponent(destinationFileName)
            
            do {
                try FileManager.default.moveItem(at: location, to: destinationURL)
                completion(.success(destinationURL))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
