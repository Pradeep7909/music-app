//
//  SignupScreenView.swift
//  MusicApp
//
//  Created by Qualwebs on 12/02/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SignupScreenView: View {
    
    @AppStorage("uid") var userId : String = ""
    @State var emailTextField = ""
    @State var passwordTextField = ""
    @State var confirmPasswordTextField = ""
    @State var nameTextField = ""
    
    //MARK: UI
    var body: some View {
        ZStack {
            Color.appcolor.ignoresSafeArea(.all)
            VStack(spacing: 20){
                
                HStack {
                    BackButtonView()
                    Spacer()
                }
                
                Image("applogo")
                    .resizable()
                    .frame(width: 200, height:200)
                    .padding(.top, -40)
                
                HStack {
                    Text("Create Account")
                        .font(.system(size: 20, weight: .medium))
                    Spacer()
                }
                
                CustomTextFieldView(textField: $emailTextField, placeholder: "Email", isEmail: true)
                CustomTextFieldView(textField: $nameTextField, placeholder: "Name")
                CustomSecureTextFieldView(textField: $passwordTextField, placeholder: "Password")
                CustomSecureTextFieldView(textField: $confirmPasswordTextField, placeholder: "Confirm-Password")
                
                Button(action: {
                    buttonAction()
                }){
                    Text("Sign up")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.frontcolor)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(radius: 10)
                
                Spacer()

            }
            .padding(.horizontal, 20)
            .foregroundStyle(.white)
        }
        .navigationBarBackButtonHidden()
    }
    
    //MARK: Funcitons
    
    func buttonAction(){
        if checkValidation(){
            Auth.auth().createUser(withEmail: emailTextField, password: passwordTextField) { authResult, error in
                if let error = error{
                    print("Error : \(error)")
                }
                if let authResult = authResult{
                    print("Auth Result: \(authResult.user.uid)")
                    withAnimation{
                        userId = authResult.user.uid
                    }
                    saveUserDataToFirestore()
                    
                }
            }
        }
    }
    
    func checkValidation() -> Bool{
        if(!emailTextField.isValidEmail()){
            NotificationCenter.default.post(name: Notification.Name("ShowToastNotification"), object: ("Invalid email Address", Color.red))
            return false
        }else if(nameTextField.isEmpty){
            NotificationCenter.default.post(name: Notification.Name("ShowToastNotification"), object: ("Name field cannot be empty", Color.red))
            return false
        }else if (passwordTextField.count < 6){
            NotificationCenter.default.post(name: Notification.Name("ShowToastNotification"), object: ("Password should be of 6 characters",Color.red))
            return false
        }else if(confirmPasswordTextField != passwordTextField){
            NotificationCenter.default.post(name: Notification.Name("ShowToastNotification"), object: ("Passwords should be same", Color.red))
            return false
        }
        return true
    }
    
    
    func saveUserDataToFirestore() {
        let db = Firestore.firestore()
        db.collection("users").document(userId).setData([
            "email": emailTextField,
            "name": nameTextField,
            "credit": 100
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("User data successfully written!")
            }
        }
    }
}

#Preview {
    SignupScreenView()
}


struct BackButtonView : View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        Image(systemName: "arrow.left")
            .font(.system(size: 20, weight: .semibold))
            .foregroundStyle(.white)
            .onTapGesture {
                presentationMode.wrappedValue.dismiss()
            }
            .frame(width: 20, height: 20)
    }
}
