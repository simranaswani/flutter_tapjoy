package com.anavrinapps.tapjoy.flutter_tapjoy;

import android.app.Activity;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import com.tapjoy.TJActionRequest;
import com.tapjoy.TJAwardCurrencyListener;
import com.tapjoy.TJConnectListener;

import com.tapjoy.TJEarnedCurrencyListener;
import com.tapjoy.TJError;
import com.tapjoy.TJGetCurrencyBalanceListener;
import com.tapjoy.TJPlacement;
import com.tapjoy.TJPlacementListener;
import com.tapjoy.Tapjoy;

import java.util.HashMap;
import java.util.Hashtable;
import java.util.Map;
import java.util.Objects;


/** FlutterTapjoyPlugin */
public class FlutterTapjoyPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {

    @SuppressLint("StaticFieldLeak")
    private static FlutterTapjoyPlugin Instance;
    private static MethodChannel Channel;
    @SuppressLint("StaticFieldLeak")
    static Activity ActivityInstance;
    static AdColonyInterstitial Ad;
    private static final Listeners listeners = new Listeners();
    TJPlacement placement;
    static FlutterTapjoyPlugin getInstance() {
      return Instance;
  }
    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
      this.OnAttachedToEngine(flutterPluginBinding.getBinaryMessenger());
      this.RegistrarBanner(flutterPluginBinding.getPlatformViewRegistry());
    }
  
    public static void registerWith(Registrar registrar) {
      if(ActivityInstance == null) ActivityInstance = registrar.activity();
      if (Instance == null) Instance = new FlutterTapjoyPlugin();
      Instance.OnAttachedToEngine(registrar.messenger());
      Instance.RegistrarBanner(registrar.platformViewRegistry());
    }
  
    private void RegistrarBanner(PlatformViewRegistry registry) {
      registry.registerViewFactory("/Banner", new BannerFactory());
  }
  private void OnAttachedToEngine(BinaryMessenger messenger) {
    if (FlutterTapjoyPlugin.Instance == null)
        FlutterTapjoyPlugin.Instance = new FlutterTapjoyPlugin();
    if (FlutterTapjoyPlugin.Channel != null)
        return;
    FlutterTapjoyPlugin.Channel = new MethodChannel(messenger, "AdColony");
    FlutterTapjoyPlugin.Channel.setMethodCallHandler(this);
  }
  void OnMethodCallHandler(final String method) {
    try {
        FlutterTapjoyPlugin.ActivityInstance.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                Channel.invokeMethod(method, null);
            }
        });
    } catch (Exception e) {
        Log.e("AdColony", "Error " + e.toString());
    }
  }
  
  @RequiresApi(api = Build.VERSION_CODES.KITKAT)
    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
      try {
        switch (call.method) {
            case "setDebugEnabled":
 boolean isDebug = call.argument("isDebug");
            Tapjoy.setDebugEnabled(isDebug);
            result.success(null);
                break;
            case "setUserConsent":
            String consent = call.argument("consent");
                        Tapjoy.setUserConsent(consent);
                break;
            case "connect":
            Hashtable<String, Object> connectFlags = new Hashtable<>();
            String tapjoyKey = call.argument("tapjoyKey");
            Tapjoy.connect(activity.getApplicationContext(), tapjoyKey, connectFlags, new TJConnectListener() {
                @Override
                public void onConnectSuccess() {
            channel.invokeMethod("requestDidSucceed", null); 
                } 
    
                @Override
                public void onConnectFailure() {
                    channel.invokeMethod( "requestDidFail",null);
                }
            });
                break;
            case "getPlacement":
            String placementName = call.argument("placementName");
           placement = Tapjoy.getPlacement(placementName, new TJPlacementListenerPlugin(this.registrar, placementName));
            placements.put(placement.getName(), placement);
            result.success(true);
                break;
            case "requestContent":
            placement.requestContent();
                break;
            case "showContent":
            placement.showContent();
                break;            
        }
        result.success(Boolean.TRUE);
    } catch (Exception e) {
        Log.e("Tapjoy", "Error " + e.toString());
    }
    }
  
   
    @RequiresApi(api = Build.VERSION_CODES.KITKAT)
    private void InitSdk(final HashMap args) {
        try {
            if (FlutterTapjoyPlugin.ActivityInstance != null) {
                AdColonyAppOptions options = new AdColonyAppOptions() {
                    {
                        setKeepScreenOn(true);
                        setGDPRConsentString((String) Objects.requireNonNull(args.get("Gdpr")));
                        setGDPRRequired(true);
                    }
                };
                Object[] arrayList = ((ArrayList) args.get("Zones")).toArray();
                String[] Zones = Arrays.copyOf(arrayList, arrayList.length, String[].class);
                AdColony.configure(FlutterTapjoyPlugin.ActivityInstance, options, (String) args.get("Id"), Zones);
                AdColony.setRewardListener(FlutterTapjoyPlugin.listeners);
            } else {
                Log.e("AdColony", "Activity Nulll");
            }
        } catch (Exception e) {
            Log.e("AdColony", e.getMessage());
        }
    }
  
    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    }
  
    @Override
    public void onAttachedToActivity(ActivityPluginBinding binding) {
        FlutterTapjoyPlugin.ActivityInstance = binding.getActivity();
    }
  
    @Override
    public void onDetachedFromActivityForConfigChanges() {
  
    }
  
    @Override
    public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {
        FlutterTapjoyPlugin.ActivityInstance = binding.getActivity();
    }
  
    @Override
    public void onDetachedFromActivity() {
  
    }
    @Override
    public void onRequestSuccess(TJPlacement tjPlacement) {
        channel.invokeMethod("onPlacementRequestSuccess", null); 
    }

    @Override
    public void onRequestFailure(TJPlacement tjPlacement, TJError tjError) {
        channel.invokeMethod("onPlacementRequestFailure", tjError.message); 
    }

    @Override
    public void onContentReady(TJPlacement tjPlacement) {
        channel.invokeMethod("onContentReady", null); 
    }

    @Override
    public void onContentShow(TJPlacement tjPlacement) {
        channel.invokeMethod("onContentShow", null); 
    }

    @Override
    public void onContentDismiss(TJPlacement tjPlacement) {
        channel.invokeMethod("onContentDismiss", null); 
    }


    @Override
    public void onRewardRequest(TJPlacement tjPlacement, TJActionRequest tjActionRequest, String s, int i) {
        channel.invokeMethod("onRewardRequest",i); 
    }

    @Override
    public void onClick(TJPlacement tjPlacement) {
        channel.invokeMethod("onClick", null); 
    }

  }
  