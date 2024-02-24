//
//  ProfileScreenView.swift
//  MusicApp
//
//  Created by Qualwebs on 12/02/24.
//

import SwiftUI
import PhotosUI
import FirebaseAuth
import FirebaseFirestore

struct ProfileScreenView: View {
    @AppStorage("uid") var userId : String = ""
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var audioPlayerManager: AudioPlayerManager
    @State var showAlert : Bool = false
    
    var profileCells: [ProfileCell] = [
        ProfileCell(image: Image(systemName: "questionmark.circle"), title: "Help & Support"),
        ProfileCell(image: Image(systemName: "gearshape"), title: "Setting"),
        ProfileCell(image: Image(systemName: "info.circle"), title: "About"),
        ProfileCell(image: Image("logout"), title: "Logout"),
        
    ]
    
    var body: some View {
        ZStack {
            Color.appcolor.ignoresSafeArea(.all)
            VStack (spacing : 20){
                HStack{
                    Spacer()
                    Text(" \(userViewModel.user?.credit ?? 0)")
                        .font(.system(size: 20))
                        .padding(.top, 5)
                    Image("wallet")
                        .resizable()
                        .frame(width: 30, height: 30)
                }.foregroundStyle(.white)
                    .padding(.bottom, -40)
                
                Image("applogo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .background(.appcolordark)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 2)
                    )
                    .padding(.top, 20)
                
                
                VStack(spacing: 5) {
                    Text(userViewModel.user?.name ?? "*****")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(.white)
                    Text(userViewModel.user?.email ?? "***@gmail.com")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.white.opacity(0.8))
                }
                .padding(.bottom ,  20)
                
                ForEach(profileCells){ cell in
                    profileCellView(image: cell.image, title: cell.title, showAlert: $showAlert)
                }
                Spacer()
            }
            .padding(.horizontal , 20)
            .alert(isPresented: $showAlert, content: {
                Alert(title: Text("Do you want to logout ?"),
                      primaryButton: .cancel(Text("No")),
                      secondaryButton: .destructive(
                        Text("Yes"),
                        action: {
                            let firebaseAuth = Auth.auth()
                            do {
                                try firebaseAuth.signOut()
                                audioPlayerManager.reset()
                                withAnimation {
                                    userId = ""
                                }
                            } catch let signOutError as NSError {
                                print("Error signing out: %@", signOutError)
                            }
                        }
                      )
                )
            })
        }
        
    }
}


struct ProfileScreenView_Previews: PreviewProvider {
    static let audioPlayerManager = AudioPlayerManager()
    static let  userViewModel = UserViewModel()
    static var previews: some View {
        ProfileScreenView()
            .environmentObject(audioPlayerManager)
            .environmentObject(userViewModel)
    }
}

struct profileCellView :View {
    var image  : Image
    var title : String
    @Binding var showAlert : Bool
    var body: some View {
        HStack{
            image
                .resizable()
                .frame(width: 30, height: 30)
                .padding(.leading , 20)
            Text(title)
                .padding(.horizontal , 20)
            
            Spacer()
            Image(systemName: "chevron.right")
                .resizable()
                .frame(width: 12, height: 18)
                .padding(.trailing , 20)
        }
        .frame(height: 60)
        .foregroundStyle(.white)
        .background(.appcolordark)
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .onTapGesture {
            if title == "Logout"{
                showAlert.toggle()
            }
        }
    }
    
}


struct ProfileCell : Identifiable{
    var id = UUID().uuidString
    let image: Image
    let title: String
}
