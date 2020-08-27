import 'dart:async';
import 'package:flutter/services.dart';

typedef void OnPlacementRequestSuccessListener();
typedef void OnPlacementRequestFailureListener(String error);
typedef void OnContentReadyListener();
typedef void OnContentShowListener();
typedef void OnContentDismissListener();
typedef void OnClickListener();
typedef void OnRewardRequestListener(int quantity);
typedef void OnTapjoyConnectSuccessListener();
typedef void OnTapjoyConnectFailureListener();

class Tapjoy {
  static Tapjoy get instance => _instance;
  final MethodChannel _channel;

  static final Tapjoy _instance = Tapjoy.private(
    const MethodChannel('ios_native'),
  );

  Tapjoy.private(MethodChannel channel) : _channel = channel {
    _channel.setMethodCallHandler(_platformCallHandler);
  }

  static OnPlacementRequestSuccessListener _onPlacementRequestSuccessListener;
  static OnPlacementRequestFailureListener _onPlacementRequestFailureistener;
  static OnContentReadyListener _onContentReadyListener;
  static OnContentShowListener _onContentShowListener;
  static OnContentDismissListener _onContentDismissListener;
  static OnRewardRequestListener _onRewardRequestListener;
  static OnClickListener _onClickListener;
  static OnTapjoyConnectSuccessListener _onTapjoyConnectSuccessListener;
  static OnTapjoyConnectFailureListener _onTapjoyConnectFailureListener;
  Future<void> setDebugEnabled(bool isDebug) async {
    try {
      await _channel.invokeMethod('setDebugEnabled', isDebug);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> setUserConsent(String consent) async {
    try {
      await _channel.invokeMethod('setUserConsent', consent);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> connect(String tapjoyKey) async {
    try {
      await _channel.invokeMethod('connect', tapjoyKey);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> getPlacement(String placementName) async {
    try {
      await _channel.invokeMethod('getPlacement', placementName);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> requestContent() async {
    try {
      await _channel.invokeMethod('requestContent');
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> showContent() async {
    try {
      await _channel.invokeMethod('showContent');
    } catch (e) {
      print(e.toString());
    }
  }

  Future _platformCallHandler(MethodCall call) async {
    switch (call.method) {
      case "onPlacementRequestSuccess":
        _onPlacementRequestSuccessListener();
        print("Tapjoy: onPlacementRequestSuccess");

        break;

      case "onPlacementRequestFailure":
        _onPlacementRequestFailureistener(call.arguments);
        print("Tapjoy : onPlacementRequestFailure");

        break;

      case "onContentReady":
        _onContentReadyListener();
        print("Tapjoy : onContentReady");

        break;

      case "onContentShow":
        _onContentShowListener();
        print("Tapjoy : onContentShow");

        break;
      case "onContentDismiss":
        _onContentDismissListener();
        print("Tapjoy : onContentDismiss");

        break;
      case "onRewardRequest":
        _onRewardRequestListener(call.arguments);
        print("Tapjoy : onRewardRequest");

        break;
      case "onClick":
        _onClickListener();
        print("Tapjoy : onClick");

        break;
      case "onTapjoyConnectSuccess":
        _onTapjoyConnectSuccessListener();
        print("Tapjoy : onTapjoyConnectSuccess");

        break;
      case "onTapjoyConnectFailure":
        _onTapjoyConnectFailureListener();
        print("Tapjoy : onTapjoyConnectFailure");

        break;
      default:
        print('Unknown method ${call.method} ');
    }
  }

  void setonPlacementRequestSuccessListener(
          OnPlacementRequestSuccessListener
              onPlacementRequestSuccessListener) =>
      _onPlacementRequestSuccessListener = onPlacementRequestSuccessListener;

  void setonPlacementRequestFailureistener(
          OnPlacementRequestFailureListener onPlacementRequestFailureistener) =>
      _onPlacementRequestFailureistener = onPlacementRequestFailureistener;

  void setonContentReadyListener(
          OnContentReadyListener onContentReadyListener) =>
      _onContentReadyListener = onContentReadyListener;

  void setonContentShowListener(OnContentShowListener onContentShowListener) =>
      _onContentShowListener = onContentShowListener;

  void setonContentDismissListener(
          OnContentDismissListener onContentDismissListener) =>
      _onContentDismissListener = onContentDismissListener;

  void setonRewardRequestListener(
          OnRewardRequestListener onRewardRequestListener) =>
      _onRewardRequestListener = onRewardRequestListener;

  void setOnClickListener(OnClickListener onClickListener) =>
      _onClickListener = onClickListener;

  void setOnTapjoyConnectFailureListener(
          OnTapjoyConnectFailureListener onTapjoyConnectFailureListener) =>
      _onTapjoyConnectFailureListener = onTapjoyConnectFailureListener;

  void setOnTapjoyConnectSuccessListener(
          OnTapjoyConnectSuccessListener onTapjoyConnectSuccessListener) =>
      _onTapjoyConnectSuccessListener = onTapjoyConnectSuccessListener;
}
