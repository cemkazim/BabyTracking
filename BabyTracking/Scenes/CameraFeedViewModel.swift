//
//  CameraFeedViewModel.swift
//  BabyTracking
//
//  Created by Cem Kazım Genel on 16/02/2022.
//

import SwiftUI
import CoreImage

class CameraFeedViewModel: ObservableObject {
    
    @Published var frame: CGImage?
    
    private let frameManager = FrameManager.shared
    
    init() {
        setupSubscriptions()
    }
    
    func setupSubscriptions() {
        frameManager.$current
            .receive(on: RunLoop.main)
            .compactMap { buffer in
                return UIImage.init(with: buffer)?.cgImage
            }
            .assign(to: &$frame)
    }
}
