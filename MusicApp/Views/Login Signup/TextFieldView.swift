//
//  TextFieldView.swift
//  MusicApp
//
//  Created by Qualwebs on 12/02/24.
//

import SwiftUI

struct CustomTextFieldView : View {
    @Binding var textField : String
    var placeholder = ""
    var isEmail = false
    
    var body: some View {
        HStack (spacing : 0){
            TextField("", text: $textField)
                .padding(.all, 10)
                .autocapitalization(.none)
                .foregroundColor(.white)
                .background(
                    Text(placeholder)
                        .foregroundColor(.gray)
                        .padding(.leading, 10)
                        .opacity(textField.isEmpty ? 1 : 0)
                    ,alignment: .leading
                )
            if isEmail{
                if(textField.count != 0){
                    Image(systemName: textField.isValidEmail() ? "checkmark" : "xmark")
                        .padding(.horizontal, 10)
                        .foregroundStyle(textField.isValidEmail() ? .green : .red)
                }
            }else{
                if(textField.count != 0){
                    Image(systemName: !textField.isEmpty ? "checkmark" : "xmark")
                        .padding(.horizontal, 10)
                        .foregroundStyle(!textField.isEmpty ? .green : .red)
                }
            }
            
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
        .frame(height: 50)
        .background(.gray.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}


struct CustomSecureTextFieldView : View {
    @Binding var textField : String
    @State private var isPasswordVisible: Bool = false
    var placeholder = ""
    
    var body: some View {
        HStack (spacing : 0){
            if isPasswordVisible {
                TextField("", text: $textField)
                    .padding(.all, 10)
                    .autocapitalization(.none)
                    .foregroundColor(.white)
                    .background(
                        Text(placeholder)
                            .foregroundColor(.gray)
                            .padding(.leading, 10)
                            .opacity(textField.isEmpty ? 1 : 0)
                        ,alignment: .leading
                    )
            } else {
                SecureField(placeholder, text: $textField)
                    .padding(.all , 10)
                    .autocapitalization(.none)
                    .foregroundColor(.white)
                    .background(
                        Text(placeholder)
                            .foregroundColor(.gray)
                            .padding(.leading, 10)
                            .opacity(textField.isEmpty ? 1 : 0)
                        ,alignment: .leading
                    )
            }
            Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                .resizable()
                .frame(width: 25, height: isPasswordVisible ? 20 : 17)
                .padding(.horizontal, 10)
                .foregroundStyle(.white.opacity(0.7))
                .onTapGesture {
                    isPasswordVisible.toggle()
                }
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
        .frame(height: 50)
        .background(.gray.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
