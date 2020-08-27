import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, TJPlacementDelegate {
    
    var placement = TJPlacement()
    var action = TJActionRequest()
    var timer = Timer()
    var channel: FlutterMethodChannel!

    public func requestDidSucceed(_ placement: TJPlacement!) {
        channel.invokeMethod("requestDidSucceed", arguments: nil)
    }
    public func requestDidFail(_ placement: TJPlacement!, error: Error!) {
        channel.invokeMethod("requestDidFail", arguments: nil)
    }
    public func contentIsReady(_ placement: TJPlacement!) {
        channel.invokeMethod("contentIsReady", arguments: nil)
    }
    public func contentDidAppear(_ placement: TJPlacement!) {
        channel.invokeMethod("contentDidAppear", arguments: nil)
    }
    public func contentDidDisappear(_ placement: TJPlacement!) {
        channel.invokeMethod("contentDidDisappear", arguments: nil)
    }
    public func placement(_ placement: TJPlacement!, didRequestReward request: TJActionRequest!, itemId: String!, quantity: Int32) {
        channel.invokeMethod("didRequestReward", arguments: quantity)
    }
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        if #available(iOS 10.0, *) {
          UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
        }
        let rootViewController : FlutterViewController = window?.rootViewController as! FlutterViewController
        channel = FlutterMethodChannel(name: "ios_native", binaryMessenger: rootViewController as! FlutterBinaryMessenger)
        channel.setMethodCallHandler {(call: FlutterMethodCall, result: FlutterResult) -> Void in
            switch(call.method) {
            case "setDebugEnabled":
                let isDebug = call.arguments as! Bool
                Tapjoy.setDebugEnabled(isDebug)
                break;
            case "setUserConsent":
                let consent = call.arguments as! String
                Tapjoy.setUserConsent(consent)
                break;
            case "connect":
                let tapjoyKey = call.arguments as! String
                Tapjoy.connect(tapjoyKey)
                break;
            case "getPlacement":
                let placementName = call.arguments as! String
                self.placement = TJPlacement.placement(withName: placementName, delegate: self) as! TJPlacement
                break;
            case "requestContent":
                 self.placement.requestContent()
                break;
            case "showContent":
                if self.placement.isContentReady {
                    self.placement.showContent(with: nil)
                } else {
                    self.placement.requestContent()
                }
                break;
            default: result(FlutterMethodNotImplemented)
            }
        }
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
        
    }
    
}
