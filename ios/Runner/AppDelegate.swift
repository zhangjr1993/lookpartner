import Flutter
import UIKit
import Photos
import AVFoundation
import AppTrackingTransparency

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let permissionChannel = FlutterMethodChannel(name: "com.lookpartner.permissions",
                                                binaryMessenger: controller.binaryMessenger)
    
    permissionChannel.setMethodCallHandler({
      [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      // Note to maintain strong reference to self. Remember to set weak self if result is used in a closure that might outlive the current scope.
      guard call.method == "requestCameraPermission" || call.method == "requestPhotoPermission" else {
        result(FlutterMethodNotImplemented)
        return
      }
      
      if call.method == "requestCameraPermission" {
        self?.requestCameraPermission(result: result)
      } else if call.method == "requestPhotoPermission" {
        self?.requestPhotoPermission(result: result)
      }
    })
    
    GeneratedPluginRegistrant.register(with: self)
      
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
          if #available(iOS 14, *) {
              ATTrackingManager.requestTrackingAuthorization { status in
                  // Handle tracking authorization status
              }
          }
      }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  private func requestCameraPermission(result: @escaping FlutterResult) {
    if #available(iOS 14.0, *) {
      let status = AVCaptureDevice.authorizationStatus(for: .video)
      
      switch status {
      case .authorized:
        result("granted")
      case .denied, .restricted:
        result("denied")
      case .notDetermined:
        AVCaptureDevice.requestAccess(for: .video) { granted in
          DispatchQueue.main.async {
            result(granted ? "granted" : "denied")
          }
        }
      @unknown default:
        result("denied")
      }
    } else {
      // Fallback for iOS 13 and earlier
      let status = AVCaptureDevice.authorizationStatus(for: .video)
      
      switch status {
      case .authorized:
        result("granted")
      case .denied, .restricted:
        result("denied")
      case .notDetermined:
        AVCaptureDevice.requestAccess(for: .video) { granted in
          DispatchQueue.main.async {
            result(granted ? "granted" : "denied")
          }
        }
      @unknown default:
        result("denied")
      }
    }
  }
  
  private func requestPhotoPermission(result: @escaping FlutterResult) {
    if #available(iOS 14.0, *) {
      let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
      
      switch status {
      case .authorized, .limited:
        result("granted")
      case .denied, .restricted:
        result("denied")
      case .notDetermined:
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
          DispatchQueue.main.async {
            switch status {
            case .authorized, .limited:
              result("granted")
            default:
              result("denied")
            }
          }
        }
      @unknown default:
        result("denied")
      }
    } else {
      // Fallback for iOS 13 and earlier
      let status = PHPhotoLibrary.authorizationStatus()
      
      switch status {
      case .authorized:
        result("granted")
      case .denied, .restricted:
        result("denied")
      case .notDetermined:
        PHPhotoLibrary.requestAuthorization { status in
          DispatchQueue.main.async {
            switch status {
            case .authorized:
              result("granted")
            default:
              result("denied")
            }
          }
        }
      @unknown default:
        result("denied")
      }
    }
  }
}
