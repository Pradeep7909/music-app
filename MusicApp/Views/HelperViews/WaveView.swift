//
//  SwiftUIView.swift
//  SwiftUI-Project
//
//  Created by Qualwebs on 16/02/24.
//

import SwiftUI

struct WaveView: View {
    @Binding var isAnimating : Bool
    var noOfWave : Int = 5
    
    @State private var isWaveUp = false
    var body: some View {
        VStack {
            if isAnimating{
                HStack(spacing: 5) {
                    ForEach(0..<noOfWave , id: \.self) { index in
                        VStack {
                            Spacer()
                            WaveBox(isUp: isWaveUp, delay: Double(index) * 0.1)
                            Spacer()
                        }
                        .frame(height: 30)
                    }
                }
                .frame(height: 30)
                .onAppear {
                    startAnimation()
                }
            }else{
                HStack(spacing: 5) {
                    ForEach(0..<noOfWave , id: \.self) { index in
                        VStack {
                            Spacer()
                            RoundedRectangle(cornerRadius: 2.5)
                                .fill(Color.frontcolor)
                                .frame(width: 5, height:5)
                            Spacer()
                        }
                    }
                }
                .frame(height: 30)
            }
        }
    }
    
    private func startAnimation() {
        isAnimating = true
        withAnimation(isAnimating ? Animation.linear(duration: 1).repeatForever() : nil) {
            isWaveUp.toggle()
        }
    }
    
    private func stopAnimation() {
        isAnimating.toggle()
    }
}

struct WaveBox: View {
    let isUp: Bool
    let delay: Double
    
    var body: some View {
        RoundedRectangle(cornerRadius: 2.5)
            .fill(LinearGradient(gradient: Gradient(colors: [.orange, .red, .frontcolor, .frontcolor]), startPoint: .top, endPoint: .bottom))
            .frame(width: 5, height: isUp ? 30 : 5)
            .animation(Animation.easeInOut(duration: 0.2).delay(delay).repeatForever(autoreverses: true))
    }
}

//struct WaveView_Previews: PreviewProvider {
//    static var previews: some View {
//        WaveView()
//    }
//}
