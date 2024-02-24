//
//  ScreenSize.swift
//  MusicApp
//
//  Created by Qualwebs on 12/02/24.
//

import Foundation
import SwiftUI

struct ScreenSize {
    static var size: CGSize {
        #if os(iOS)
        return UIScreen.main.bounds.size
        #elseif os(macOS)
        return NSScreen.main?.frame.size ?? CGSize(width: 800, height: 600)
        #endif
    }
}
