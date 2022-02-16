//
//  CameraManager.swift
//  BabyTracking
//
//  Created by Cem Kazım Genel on 16/02/2022.
//

import AVFoundation

class CameraManager: ObservableObject {
    
    static let shared = CameraManager()
    
    enum Status {
        case unconfigured
        case unauthorized
        case failed
    }
    
//    private enum CameraPosition {
//        case front
//        case back
//    }
    
    private var status = Status.unconfigured
    
    let session = AVCaptureSession()
    
    private let sessionQueue = DispatchQueue(label: "com.raywenderlich.SessionQ")
    private let videoOutput = AVCaptureVideoDataOutput()
    
    private init() {
        checkPermissions()
        sessionQueue.async {
            self.configureCaptureSession()
            self.session.startRunning()
        }
    }
    
    private func checkPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            sessionQueue.suspend()
            AVCaptureDevice.requestAccess(for: .video) { authorized in
                if !authorized {
                    self.status = .unauthorized
                }
                self.sessionQueue.resume()
            }
        case .restricted:
            status = .unauthorized
        case .denied:
            status = .unauthorized
        case .authorized:
            break
        default:
            status = .unauthorized
        }
    }
    
    private func configureCaptureSession() {
        guard status == .unconfigured else {
            return
        }
        session.beginConfiguration()
        do {
            session.commitConfiguration()
        }
        // If you want the back camera, you can change position...
        let device = AVCaptureDevice.default(
            .builtInWideAngleCamera,
            for: .video,
            position: .front)
        guard let camera = device else {
            status = .failed
            return
        }
        do {
          let cameraInput = try AVCaptureDeviceInput(device: camera)
          if session.canAddInput(cameraInput) {
            session.addInput(cameraInput)
          } else {
            status = .failed
            return
          }
        } catch {
          status = .failed
          return
        }
        if session.canAddOutput(videoOutput) {
          session.addOutput(videoOutput)
          videoOutput.videoSettings =
            [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
          let videoConnection = videoOutput.connection(with: .video)
          videoConnection?.videoOrientation = .portrait
        } else {
          status = .failed
          return
        }
    }
    
    func set(_ delegate: AVCaptureVideoDataOutputSampleBufferDelegate, queue: DispatchQueue) {
        sessionQueue.async {
            self.videoOutput.setSampleBufferDelegate(delegate, queue: queue)
        }
    }
}
