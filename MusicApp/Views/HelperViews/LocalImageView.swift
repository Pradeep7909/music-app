//
//  LocalImageView.swift
//  MusicApp
//
//  Created by Qualwebs on 18/02/24.
//

import SwiftUI

struct LocalImageView: View {
    var size : CGFloat
    var songImage : String
    var body: some View {
        if let image = loadImageFromDocumentsDirectory(songImage) {
            Image(uiImage: image)
                .resizable()
                .frame(width: size, height: size)
                .aspectRatio(contentMode: .fill)
            
        } else {
            Image("applogo")
                .resizable()
                .frame(width: size, height: size)
                .aspectRatio(contentMode: .fill)
            
        }
    }
    
    func loadImageFromDocumentsDirectory(_ filename: String) -> UIImage? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {
            print("Error loading image : \(error)")
            return nil
        }
    }
}

struct LocalImageView_preview: PreviewProvider {
    static var previews: some View {
        LocalImageView(size: 200, songImage: "GroovyVibes_image.jpg")
    }
}







