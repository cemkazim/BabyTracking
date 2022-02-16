//
//  CameraFeedView.swift
//  BabyTracking
//
//  Created by Cem Kazım Genel on 16/02/2022.
//

import SwiftUI
import AVFoundation

struct CameraFeedView: View {
    
    @StateObject private var viewModel = CameraFeedViewModel()
    
    var body: some View {
        FrameView(image: viewModel.frame)
            .edgesIgnoringSafeArea(.all)
    }
}

struct CameraFeedView_Previews: PreviewProvider {
    static var previews: some View {
        CameraFeedView()
    }
}
