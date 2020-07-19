import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_tapjoy/tapjoy.dart';
import 'package:flutter_tapjoy/tj_placement.dart';
import 'package:flutter_tapjoy/listeners.dart';
import 'dart:io';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> initTapjoy() async {
    if (Platform.isAndroid) {
      Tapjoy.setDebugEnabled(true);
      Tapjoy.setUserConsent('1');
      Tapjoy.connect(
        'api_key',
        tapjoyConnectSuccess,
        tapjoyConnectFailure,
      );
    } else if (Platform.isIOS) {
      TapjoySwift.instance.setDebugEnabled(true);
      TapjoySwift.instance.setUserConsent('1');
      TapjoySwift.instance.connect('api_key');
      TapjoySwift.instance.setTapjoyContentDidAppearListener(tapjoyDidAppear);
      TapjoySwift.instance
          .setTapjoyContentDidDisappearListener(tapjoyDidDisappear);
      TapjoySwift.instance.setTapjoyDidRequestRewardListener(tapjoyReward);
      TapjoySwift.instance
        ..setTapjoyRequestDidFaiListener(tapjoyConnectFailure);
      TapjoySwift.instance
          .setTapjoyRequestDidSucceedListener(tapjoyConnectSuccess);
      TapjoySwift.instance.setTapjoyContentIsReadyListener(tapjoyisReady);
    }
  }

  void tapjoyConnectSuccess() {
    print('Tapjoy SDK connected');
  }

  void tapjoyConnectFailure() {
    print('Tapjoy SDK connection failure');
  }

  void tapjoyReward(int quantity) {
    print('Tapjoy SDK $quantity');
  }

  void tapjoyDidAppear() {
    print('Tapjoy SDK Appear');
  }

  void tapjoyDidDisappear() {
    print('Tapjoy SDK Disappear');
  }

  void tapjoyisReady() {
    TapjoySwift.instance.showContent();
    print('Tapjoy SDK Ready');
  }

  @override
  void initState() {
    initTapjoy();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: <Widget>[
            RaisedButton(
              child: Text('is Content Available'),
              onPressed: () async {
                if (Platform.isAndroid) {
                  TJPlacement tjPlacement = await Tapjoy.getPlacement(
                      'placement_name',
                      onRequestSuccess: (placement) => placement.showContent(),
                      onRequestFailure: (placement, error) => print(
                          error.errorCode.toString() +
                              ' - ' +
                              error.errorMessage));
                  tjPlacement.requestContent();
                } else if (Platform.isIOS) {
                  TapjoySwift.instance.getPlacement('placement_name');
                  TapjoySwift.instance.requestContent();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
