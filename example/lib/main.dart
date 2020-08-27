import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_tapjoy/tapjoy.dart';

import 'dart:io';

import '../../lib/tapjoy.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> initTapjoy() async {
    Tapjoy.instance.setDebugEnabled(true);
    Tapjoy.instance.setUserConsent('1');
    Tapjoy.instance.connect('api_key');
    Tapjoy.instance.setOnTapjoyConnectFailureListener(tapjoyConnectFailure);
    Tapjoy.instance.setContentDidAppearListener(tapjoyDidAppear);
    Tapjoy.instance.setTapjoyContentDidDisappearListener(tapjoyDidDisappear);
    Tapjoy.instance.setTapjoyDidRequestRewardListener(tapjoyReward);
    Tapjoy.instance..setTapjoyRequestDidFaiListener(tapjoyConnectFailure);
    Tapjoy.instance.setTapjoyRequestDidSucceedListener(tapjoyConnectSuccess);
    Tapjoy.instance.setTapjoyContentIsReadyListener(tapjoyisReady);
    
    Tapjoy.instance.setOnTapjoyConnectSuccessListener(tapjoyConnectSuccess);
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
    Tapjoy.instance.showContent();
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
                  Tapjoy.instance.getPlacement('placement_name');
                  Tapjoy.instance.requestContent();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
