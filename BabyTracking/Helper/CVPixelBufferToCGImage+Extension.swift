//
//  CVPixelBufferToCGImage+Extension.swift
//  BabyTracking
//
//  Created by Cem Kazım Genel on 16/02/2022.
//

import SwiftUI
import VideoToolbox

extension UIImage {
    
    public convenience init?(with buffer: CVPixelBuffer?) {
        var cgImage: CGImage?
        if let buffer = buffer {
            VTCreateCGImageFromCVPixelBuffer(buffer, options: nil, imageOut: &cgImage)
        }
        guard let cgImage = cgImage else {
            return nil
        }
        self.init(cgImage: cgImage)
    }
}
