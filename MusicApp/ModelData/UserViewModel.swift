//
//  UserViewModel.swift
//  MusicApp
//
//  Created by Qualwebs on 14/02/24.
//

import FirebaseFirestore
import FirebaseAuth
import Combine

class UserViewModel: ObservableObject {
    @Published var user: User?
    private var db = Firestore.firestore()
    private var cancellables = Set<AnyCancellable>()

    func fetchUser() {
        print("fetching user data..")
        if let userId = Auth.auth().currentUser?.uid {
            DispatchQueue.global(qos: .background).async { [weak self] in
                guard let self = self else { return }
                self.db.collection("users").document(userId).getDocument { document, error in
                    if let document = document, document.exists {
                        let data = document.data()
                        let id = document.documentID
                        let userName = data?["name"] as? String ?? ""
                        let email = data?["email"] as? String ?? ""
                        let credit = data?["credit"] as? Int ?? 0
                        let purchasedSongs = data?["purchasedSongs"] as? [String] ?? []
                        let favoriteSongs = data?["favoriteSongs"] as? [String] ?? []
                        print("user data fetched")
                        
                        // Update UI on the main queue
                        DispatchQueue.main.async {
                            self.user = User(uid: id, email: email, name: userName, credit: credit, purchasedSongs: purchasedSongs, favoriteSongs : favoriteSongs)
                            print(self.user!)
                        }
                    } else {
                        print("User document not found: \(error?.localizedDescription ?? "Unknown error")")
                    }
                }
            }
        }
    }
    // Method to update the user object
    func updateUser(user: User) {
        self.user = user
        print("update user data: user")
    }
}
