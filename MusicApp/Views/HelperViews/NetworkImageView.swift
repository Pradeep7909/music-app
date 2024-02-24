//
//  NetworkImageView.swift
//  MusicApp
//
//  Created by Qualwebs on 13/02/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct NetworkImageView: View {
    var imageURL : String
    var size : CGFloat
    var body: some View {
        
        WebImage(url: URL(string: imageURL))
            .resizable()
            .placeholder(Image("applogo"))
            .indicator(.activity)
            .transition(.fade(duration: 0.5))
            .aspectRatio(contentMode: .fill)
            .frame(width: size, height: size)
    }
}

#Preview {
    NetworkImageView(imageURL: "", size: 200)
}

func loadImageFromPath(path: String) -> UIImage? {
    guard let image = UIImage(contentsOfFile: path) else {
        print("Image not found at path:", path)
        return nil
    }
    return image
}
