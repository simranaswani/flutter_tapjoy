# **Tapjoy Plugin for Flutter**

#### Note: There are seperate implementations for Android & iOS. For iOS, replace your `AppDelegate.swift` with the example repo's `AppDelegate.swift` file & add `pod TapjoySDK` at the end of your Podfile.

## Getting started:
### 1. Initialise Tapjoy 
Call `initTapjoy()` during app initialization
Replace `api_key` with your Tapjoy key.

```sh
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
```
  
### 2. Initialise callback listeners
 
 ```sh
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
 ```
 ### 3. Call TJPlacement 
  Replace `placement_name` with your Tapjoy placement. 
  
  ```sh
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
 ```               
  
  ### IMPORTANT: If you’re Publishing and using Proguard add these lines to your configuration file:
  ```sh
    -keep class com.tapjoy.** { *; }
    -keep class com.moat.** { *; }
    -keepattributes JavascriptInterface
    -keepattributes *Annotation*
    -keep class * extends java.util.ListResourceBundle {
     protected Object[][] getContents();
    }
    -keep public class com.google.android.gms.common.internal.safeparcel.SafeParcelable {
    public static final *** NULL;
    }
    -keepnames @com.google.android.gms.common.annotation.KeepName class *
    -keepclassmembernames class * {
    @com.google.android.gms.common.annotation.KeepName *;
    }
    -keepnames class * implements android.os.Parcelable {
    public static final ** CREATOR;
    }
    -keep class com.google.android.gms.ads.identifier.** { *; }
    -dontwarn com.tapjoy.**
 ```   
  For the complete implementation, please refer to the example repo.        
