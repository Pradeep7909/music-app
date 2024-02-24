//
//  FirebaseFunctions.swift
//  MusicApp
//
//  Created by Qualwebs on 13/02/24.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import SwiftUI

func getUrl(folder : String){ // songAudio, songImages
    let storageRef =  Storage.storage().reference()
    
    let songsDirectoryRef = storageRef.child(folder)
    
    songsDirectoryRef.listAll { (result, error) in
        if let error = error {
            print("Error fetching list of items: \(error.localizedDescription)")
            return
        }
        guard let result = result else{
            print("error in result")
            return
        }
        
        for item in result.items {
            // Get the download URL for each audio file
            item.downloadURL { (url, error) in
                if let error = error {
                    print("Error getting download URL for \(item.name): \(error.localizedDescription)")
                } else if let downloadURL = url {
                    print("Download URL for \(item.name): \(downloadURL.absoluteString)")
                }
            }
        }
    }
}


func storeSong(song: Song){
    let db = Firestore.firestore()
    db.collection("songs").document(song.id).setData([
        "artistName": song.artistName,
        "title": song.title,
        "url": song.url,
        "songImage" : song.songImage
    ]) { err in
        if let err = err {
            print("Error writing document: \(err)")
        } else {
            print("User data successfully written!")
        }
    }
}

func addPurchasedSong(song: Song, userViewModel: UserViewModel) {
    print("addPurchasedSong executing")
    guard let currentUser = userViewModel.user else {
        print("User is nil")
        return
    }
    
    
    let db = Firestore.firestore()
    let userRef = db.collection("users").document(currentUser.uid)
    let newCredit = currentUser.credit - song.cost
    userRef.updateData([
        "credit": newCredit
    ]) { error in
        if let error = error {
            print("Error updating user credit: \(error)")
        } else {
            print("Successfully deducted amount from user credit")
            userRef.updateData([
                "purchasedSongs": FieldValue.arrayUnion([song.songId])
            ]) { error in
                if let error = error {
                    print("Error updating purchasedSongs: \(error)")
                } else {
                    print("Successfully updated purchasedSongs")
                    var updatedUser = currentUser
                    updatedUser.purchasedSongs?.append(song.songId)
                    updatedUser.credit = newCredit
                    NotificationCenter.default.post(name: Notification.Name("ShowToastNotification"), object: ("Song is purchased", Color.green))
                    userViewModel.updateUser(user: updatedUser)
                    print("Updated user in local storage")
                }
            }
        }
    }
}




