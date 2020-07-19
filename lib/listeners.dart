import 'dart:async';
import 'package:flutter/services.dart';

typedef void TapjoyRequestDidSucceedListener();
typedef void TapjoyRequestDidFaiListener();
typedef void TapjoyContentIsReadyListener();
typedef void TapjoyContentDidAppearListener();
typedef void TapjoyContentDidDisappearListener();
typedef void TapjoyDidRequestRewardListener(int quantity);

class TapjoySwift {
  static TapjoySwift get instance => _instance;
  final MethodChannel _channel;

  static final TapjoySwift _instance = TapjoySwift.private(
    const MethodChannel('ios_native'),
  );

  TapjoySwift.private(MethodChannel channel) : _channel = channel {
    _channel.setMethodCallHandler(_platformCallHandler);
  }

  static TapjoyRequestDidSucceedListener _tapjoyRequestDidSucceedListener;
  static TapjoyRequestDidFaiListener _tapjoyRequestDidFaiListener;
  static TapjoyContentIsReadyListener _tapjoyContentIsReadyListener;
  static TapjoyContentDidAppearListener _tapjoyContentDidAppearListener;
  static TapjoyContentDidDisappearListener _tapjoyContentDidDisappearListener;
  static TapjoyDidRequestRewardListener _tapjoyDidRequestRewardListener;

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
      case "requestDidSucceed":
        _tapjoyRequestDidSucceedListener();
        print("Tapjoy iOS: requestDidSucceed");

        break;

      case "requestDidFail":
        _tapjoyRequestDidFaiListener();
        print("Tapjoy iOS: requestDidFail");

        break;

      case "contentIsReady":
        _tapjoyContentIsReadyListener();
        print("Tapjoy iOS: contentIsReady");

        break;

      case "contentDidAppear":
        _tapjoyContentDidAppearListener();
        print("Tapjoy iOS: contentDidAppear");

        break;
      case "contentDidDisappear":
        _tapjoyContentDidDisappearListener();
        print("Tapjoy iOS: contentDidDisappear");

        break;
      case "didRequestReward":
        _tapjoyDidRequestRewardListener(call.arguments);
        print("Tapjoy iOS: didRequestReward");

        break;
      default:
        print('Unknown method ${call.method} ');
    }
  }

  void setTapjoyRequestDidSucceedListener(
          TapjoyRequestDidSucceedListener tapjoyRequestDidSucceedListener) =>
      _tapjoyRequestDidSucceedListener = tapjoyRequestDidSucceedListener;

  void setTapjoyRequestDidFaiListener(
          TapjoyRequestDidFaiListener tapjoyRequestDidFaiListener) =>
      _tapjoyRequestDidFaiListener = tapjoyRequestDidFaiListener;

  void setTapjoyContentIsReadyListener(
          TapjoyContentIsReadyListener tapjoyContentIsReadyListener) =>
      _tapjoyContentIsReadyListener = tapjoyContentIsReadyListener;

  void setTapjoyContentDidAppearListener(
          TapjoyContentDidAppearListener tapjoyContentDidAppearListener) =>
      _tapjoyContentDidAppearListener = tapjoyContentDidAppearListener;

  void setTapjoyContentDidDisappearListener(
          TapjoyContentDidDisappearListener
              tapjoyContentDidDisappearListener) =>
      _tapjoyContentDidDisappearListener = tapjoyContentDidDisappearListener;

  void setTapjoyDidRequestRewardListener(
          TapjoyDidRequestRewardListener tapjoyDidRequestRewardListener) =>
      _tapjoyDidRequestRewardListener = tapjoyDidRequestRewardListener;
}
