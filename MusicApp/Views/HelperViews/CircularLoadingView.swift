//
//  LoadingView.swift
//  MusicApp
//
//  Created by Qualwebs on 22/02/24.
//

import SwiftUI

struct CircularLoadingView: View {
    var diameter : CGFloat
    var color : Color = .white
    @State private var isLoading = false
    
    var body: some View {
            ZStack {
                Circle()
                    .trim(from: 0, to: 0.7)
                    .stroke(Color.white, lineWidth: 3)
                    .frame(width: diameter, height: diameter)
                    .rotationEffect(.degrees(isLoading ? 360 : 0))
                    .foregroundColor(Color.blue)
                    .onAppear() {
                        withAnimation(Animation
                                        .linear(duration: 1)
                                        .repeatForever(autoreverses: false)) {
                            self.isLoading = true
                        }
                    }
            }
        }
}


#Preview {
    CircularLoadingView(diameter: 50, color: .red)
}





