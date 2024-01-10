//
//  UserConsentWorker.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 23/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class UserConsentWorker {
    
    private var cameraCompletion: ((_ accessGranted: Bool) -> Void)?
    private var microphoneCompletion: ((_ accessGranted: Bool) -> Void)?
    
    /* Request Camera Access */
    func requestCameraAccess(completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        self.cameraCompletion = completionHandler
        checkCameraAccess(status: AVCaptureDevice.authorizationStatus(for: .video))
    }
    
    /* Request MicroPhone Access */
    func requestMicroPhoneAccess(completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        self.microphoneCompletion = completionHandler
        checkMicrophoneAccess(status: AVAudioSession.sharedInstance().recordPermission)
    }
    
    /* Check Camera Permission Status */
    func checkCameraAccess(status: AVAuthorizationStatus) {
        switch status {
        case .denied:
            cameraCompletion?(false)
        case .restricted:
            cameraCompletion?(false)
        case .authorized:
            cameraCompletion?(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { success in
                if success {
                    self.cameraCompletion?(true)
                } else {
                    self.cameraCompletion?(false)
                }
            }
        @unknown default:
            break
        }
    }
    
    /* Check MicroPhone Permission Status */
    func checkMicrophoneAccess(status: AVAudioSession.RecordPermission ) {
        switch status {
        case .granted:
            microphoneCompletion?(true)
        case .denied:
            microphoneCompletion?(false)
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission({ granted in
                if granted {
                    self.microphoneCompletion?(true)
                } else {
                    self.microphoneCompletion?(false)
                }
            })
        @unknown default:
            microphoneCompletion?(false)
        }
    }
}
