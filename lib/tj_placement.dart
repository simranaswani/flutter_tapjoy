import 'package:flutter/services.dart';
import './tapjoy.dart';
import './tj_actionRequest.dart';
import './tj_error.dart';

typedef void OnRequestSuccess(TJPlacement tjPlacement);
typedef void OnRequestFailure(TJPlacement tjPlacement, TJError tjError);
typedef void OnContentReady(TJPlacement tjPlacement);
typedef void OnContentShow(TJPlacement tjPlacement);
typedef void OnContentDismiss(TJPlacement tjPlacement);
typedef void OnPurchaseRequest(TJPlacement tjPlacement,
    TJActionRequest tjActionRequest, String productIds);
typedef void OnRewardRequest(TJPlacement tjPlacement,
    TJActionRequest tjActionRequest, String itemId, int quantity);
typedef void OnClick(TJPlacement tjPlacement);

class TJPlacement {
  String placementName = '';
  static MethodChannel _channel;
  OnRequestSuccess onRequestSuccess;
  OnRequestFailure onRequestFailure;
  OnContentReady onContentReady;
  OnContentShow onContentShow;
  OnContentDismiss onContentDismiss;
  OnPurchaseRequest onPurchaseRequest;
  OnRewardRequest onRewardRequest;
  OnClick onClick;

  TJPlacement(this.placementName,
      {this.onRequestSuccess,
      this.onRequestFailure,
      this.onContentReady,
      this.onContentShow,
      this.onPurchaseRequest,
      this.onRewardRequest,
      this.onClick}) {
    _channel = MethodChannel("TJPlacement_" + this.placementName);
    _channel.setMethodCallHandler(this._handle);
  }

  Future<Null> _handle(MethodCall call) async {
    if (call.method == 'onRequestSuccess') {
      onRequestSuccess(this);
    } else if (call.method == 'onRequestFailure') {
      onRequestFailure(
        this,
        TJError(
            errorCode: call.arguments('code'),
            errorMessage: call.arguments('message')),
      );
    } else if (call.method == 'onContentReady') {
      if (onContentReady != null) onContentReady(this);
    } else if (call.method == 'onContentShow') {
      onContentShow(this);
    } else if (call.method == 'onContentDismiss') {
      onContentDismiss(this);
    } else if (call.method == 'onPurchaseRequest') {
      String productId = call.arguments('productId');
      onPurchaseRequest(this, ActionRequest(call), productId);
    } else if (call.method == 'onRewardRequest') {
      String itemId = call.arguments('itemId');
      int quantity = call.arguments('quantity');
      onRewardRequest(this, ActionRequest(call), itemId, quantity);
    } else if (call.method == 'onClick') {
      onClick(this);
    }
  }

  Future<bool> isContentAvailable() async {
    bool contentStatus = await _channel.invokeMethod('isContentAvailable');
    return contentStatus;
  }

  Future<bool> isContentReady() async {
    bool contentStatus = await _channel.invokeMethod('isContentReady');
    return contentStatus;
  }

  Future<void> requestContent() async {
    if (await Tapjoy.isConnected()) {
      await _channel.invokeMethod('requestContent');
    } else {
      print('content not ready');
    }
  }

  Future<void> showContent() async {
    if (await this.isContentAvailable() || await this.isContentReady()) {
      await _channel.invokeMethod('showContent');
    } else {
      print('no content to show, or it has not yet downloaded');
    }
  }

  Future<void> setMediationName(String mediationName) async {
    await _channel.invokeMethod('setMediationName');
  }

  Future<void> setMediationId(String mediationId) async {
    await _channel.invokeMethod('setMediationId', {'mediationId': mediationId});
  }

  Future<void> setAdapterVersion(String adapterVersion) async {
    await _channel
        .invokeMethod('setAdapterVersion', {'adapterVersion': adapterVersion});
  }

  Future<bool> isLimited() async {
    bool isLimited = await _channel.invokeMethod('isLimited');
    return isLimited;
  }

  Future<String> getName() async {
    String name = await _channel.invokeMethod('getName');
    return name;
  }

  Future<String> getGUID() async {
    String guid = await _channel.invokeMethod('getGUID');
    return guid;
  }

  Future<void> setVideoListener(
      {Function onVideoStart,
      Function onVideoError,
      Function onVideoComplete}) async {
    await _channel.invokeMethod('setVideoListener');
    _channel.setMethodCallHandler((methodCall) {
      switch (methodCall.method) {
        case 'onVideoStart':
          onVideoStart();
          break;
        case 'onVideoError':
          onVideoError();
          break;
        case 'onVideoComplete':
          onVideoComplete();
          break;
        default:
      }
      return;
    });
  }

  // This Functions Not Implementted Uptil Now.

  Future<void> setAuctionData() async {
    throw UnsupportedError('This Function Not Implementted Uptil Now!');
  }

  Future<void> getListener() async {
    throw UnsupportedError('This Function Not Implementted Uptil Now!');
  }

  Future<void> getVideoListener() async {
    throw UnsupportedError('This Function Not Implementted Uptil Now!');
  }
}

class ActionRequest implements TJActionRequest {
  MethodCall call;
  ActionRequest(this.call);
  @override
  String getToken() {
    return call.arguments('token');
  }

  @override
  String getRequestId() {
    return call.arguments('requestId');
  }

  @override
  void completed() {
    call.arguments('');
  }

  @override
  void cancelled() {
    call.arguments('');
  }
}
