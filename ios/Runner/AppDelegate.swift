import UIKit
import Flutter
import StoreKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // platform view in flutter.
    weak var registrar = self.registrar(forPlugin: "ios-platform-view")
    let factory = FLNativeViewFactory(messenger: registrar!.messenger())
    self.registrar(forPlugin: "<ios-platform-view>")!.register(
        factory,
        withId: "<ios-platform-view-type>"
    )
    
    // Platform Channel -> Method Channel
    GeneratedPluginRegistrant.register(with: self)
    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    let methodChannel = FlutterMethodChannel.init(name: "awesome_flutter/platform_view/method_channel", binaryMessenger: controller.binaryMessenger)
    methodChannel.setMethodCallHandler({(call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      if ("openAppStoreProductView" == call.method) {
          let productView = SKStoreProductViewController()
          //productView.delegate = self
          productView.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier : call.arguments as! String])
          
          controller.present(productView, animated: true, completion: nil)
      } else {
          result(FlutterMethodNotImplemented)
      }
    });

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
