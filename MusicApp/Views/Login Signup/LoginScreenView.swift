//
//  LoginView.swift
//  MusicApp
//
//  Created by Qualwebs on 12/02/24.
//

import SwiftUI
import FirebaseAuth

struct LoginScreenView: View {
    @AppStorage("uid") var userId : String = ""
    @State var emailTextField = ""
    @State var passwordTextField = ""
    
    //MARK: UI
    var body: some View {
        ZStack {
            Color.appcolor.ignoresSafeArea(.all)
            VStack(spacing: 20){
                Image("applogo")
                    .resizable()
                    .frame(width: 200, height:200)
                
                HStack {
                    Text("Login to your Account")
                        .font(.system(size: 20, weight: .medium))
                    Spacer()
                }
                
                CustomTextFieldView(textField: $emailTextField, placeholder: "Email", isEmail: true)
                CustomSecureTextFieldView(textField: $passwordTextField, placeholder: "Password")
                
                Button(action: {
                    buttonAction()
                }){
                    Text("Sign in")
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
                
                HStack {
                    Text("Dont have an account?")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.white.opacity(0.5))
                    
                    NavigationLink(destination: SignupScreenView()) {
                        Text("Sign up")
                            .foregroundStyle(.white)
                    }
                }
                .frame(maxWidth: .infinity )
                .padding(.bottom , 20)
            }
            .padding(.horizontal, 20)
            .foregroundStyle(.white)
        }
    }
    
    //MARK: Functions
    func buttonAction(){
        if checkValidation(){
            Auth.auth().signIn(withEmail: emailTextField, password: passwordTextField) { authResult, error in
                if let error = error{
                    print("Error: \(error)")
                    NotificationCenter.default.post(name: Notification.Name("ShowToastNotification"), object: ("Account not Found",Color.red))
                    
                }
                if let authResult = authResult{
                    print("Auth Result: \(authResult.user.uid)")
                    withAnimation{
                        userId = authResult.user.uid
                    }
                }
            }
            
        }
    }
    func checkValidation() -> Bool{
        if(!emailTextField.isValidEmail()){
            NotificationCenter.default.post(name: Notification.Name("ShowToastNotification"), object: ("Invalid email Address", Color.red ))
            
            return false
        }else if (passwordTextField.count < 6){
            NotificationCenter.default.post(name: Notification.Name("ShowToastNotification"), object: ("Password should be of 6 characters", Color.red))
            
            return false
        }
        return true
    }
}

#Preview {
    LoginScreenView()
}


//MARK: Toast Message
struct ToastMessageView: View {
    let message: String
    let backgroundColor: Color
    
    var body: some View {
        VStack {
            Text(message)
                .foregroundColor(.white)
                .padding(.all , 10)
                .background(backgroundColor.opacity(0.8))
                .cornerRadius(10)
                .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
            Spacer()
        }
        
    }
}


struct ToastModifier: ViewModifier {
    @Binding var showToast: Bool
    var message: String
    var backgroundColor: Color
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if showToast {
                ToastMessageView(message: message, backgroundColor: backgroundColor)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showToast = false
                        }
                    }
                    .zIndex(5)
            }
        }
    }
}

