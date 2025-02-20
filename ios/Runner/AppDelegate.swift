import UIKit
import Flutter
import Firebase
import GoogleMaps
import flutter_downloader

@main
@objc class AppDelegate: FlutterAppDelegate {
  
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    // (1) إضافة FlutterDownloaderPlugin ضمن Closure مباشرة
    FlutterDownloaderPlugin.setPluginRegistrantCallback { registry in
      GeneratedPluginRegistrant.register(with: registry)
    }
    
    // (2) Firebase
    FirebaseApp.configure()
    
    // (3) Google Maps
    if let apiKey = Bundle.main.object(forInfoDictionaryKey: "GMSServicesAPIKey") as? String {
      GMSServices.provideAPIKey(apiKey)
    } else {
      print("Error: Google Maps API Key is missing in Info.plist.")
    }
    
    // (4) تسجيل الـ Plugins الافتراضية
    GeneratedPluginRegistrant.register(with: self)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
