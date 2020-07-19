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


public class FlutterTapjoyPlugin implements MethodCallHandler {

    static MethodChannel channel;
    static private Registrar registrar;
    static Map<String, TJPlacement> placements = new HashMap<>();
    private final Activity activity;

    public static void registerWith(Registrar registrar) {
        FlutterTapjoyPlugin.registrar = registrar;
        channel = new MethodChannel(registrar.messenger(), "tapjoy");
        channel.setMethodCallHandler(new FlutterTapjoyPlugin(registrar.activity()));
    }

    private FlutterTapjoyPlugin(Activity activity) {
      this.activity = activity;
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        if (call.method.equals("setDebugEnabled")) {
            boolean isDebug = call.argument("isDebug");
            Tapjoy.setDebugEnabled(isDebug);
            result.success(null);
        } else if (call.method.equals("setActivity")) {
            Tapjoy.setActivity(this.activity);
            result.success(null);
        } else if (call.method.equals("isConnected")) {
            if (Tapjoy.isConnected())
                result.success(true);
            else
                result.error(null, null, null);
        } else if (call.method.equals("connect")) {
            Hashtable<String, Object> connectFlags = new Hashtable<>();
            String tapjoyKey = call.argument("tapjoyKey");
            result.success(Tapjoy.connect(activity.getApplicationContext(), tapjoyKey, connectFlags, new TJConnectListener() {
                @Override
                public void onConnectSuccess() {
                    channel.invokeMethod("connect", "success");
                }

                @Override
                public void onConnectFailure() {
                    channel.invokeMethod("connect", "fail");
                }
            }));
        } else if (call.method.equals("getPlacement")) {
            String placementName = call.argument("placementName");
            TJPlacement placement = Tapjoy.getPlacement(placementName, new TJPlacementListenerPlugin(this.registrar, placementName));
            placements.put(placement.getName(), placement);
            result.success(true);
        } else if (call.method.equals("setUserID")) {
            String userID = call.argument("userID");
            Tapjoy.setUserID(userID);
            result.success(true);
        } else if (call.method.equals("setGcmSender")) {
            String senderID = call.argument("senderID");
            Tapjoy.setGcmSender(senderID);
            result.success(null);
        } else if (call.method.equals("actionComplete")) {
            String actionID = call.argument("actionID");
            Tapjoy.actionComplete(actionID);
        } else if (call.method.equals("addUserTag")) {
            String tag = call.argument("tag");
            Tapjoy.addUserTag(tag);
        } else if (call.method.equals("belowConsentAge")) {
            boolean isBelowConsentAge = call.argument("isBelowConsentAge");
            Tapjoy.belowConsentAge(isBelowConsentAge);
        } else if (call.method.equals("clearUserTags")) {
            Tapjoy.clearUserTags();
        } else if (call.method.equals("endSession")) {
            Tapjoy.endSession();
        } else if (call.method.equals("getSupportURL")) {
            String supportURL = call.argument("supportURL");
            if (supportURL == null) {
                result.success(Tapjoy.getSupportURL());
            } else {
                result.success(Tapjoy.getSupportURL(supportURL));
            }
        } else if (call.method.equals("getUserToken")) {
            result.success(Tapjoy.getUserToken());
        } else if (call.method.equals("isLimitedConnected")) {
            result.success(Tapjoy.isLimitedConnected());
        } else if (call.method.equals("isPushNotificationDisabled")) {
            result.success(Tapjoy.isPushNotificationDisabled());
        } else if (call.method.equals("loadSharedLibrary")) {
            Tapjoy.loadSharedLibrary();
        } else if (call.method.equals("onActivityStart")) {
            Tapjoy.onActivityStart(this.activity);
        } else if (call.method.equals("onActivityStop")) {
            Tapjoy.onActivityStop(this.activity);
        } else if (call.method.equals("removeUserTag")) {
            String userTag = call.argument("userTag");
            Tapjoy.removeUserTag(userTag);
        } else if (call.method.equals("setAppDataVersion")) {
            String dataVersion = call.argument("dataVersion");
            Tapjoy.setAppDataVersion(dataVersion);
        } else if (call.method.equals("getVersion")) {
            result.success(Tapjoy.getVersion());
        } else if (call.method.equals("setDeviceToken")) {
            String deviceToken = call.argument("deviceToken");
            Tapjoy.setDeviceToken(deviceToken);
        } else if (call.method.equals("setPushNotificationDisabled")) {
            boolean disable = call.argument("disable");
            Tapjoy.setPushNotificationDisabled(disable);
        } else if (call.method.equals("setUserConsent")) {
            String consent = call.argument("consent");
            Tapjoy.setUserConsent(consent);
        } else if (call.method.equals("setUserCohortVariable")) {
            int cohortIndex = call.argument("cohortIndex");
            String cohortValue = call.argument("cohortValue");
            Tapjoy.setUserCohortVariable(cohortIndex, cohortValue);
        } else if (call.method.equals("subjectToGDPR")) {
            boolean gdprApplicable = call.argument("gdprApplicable");
            Tapjoy.subjectToGDPR(gdprApplicable);
        } else if (call.method.equals("startSession")) {
            Tapjoy.startSession();
        } else if (call.method.equals("setUserLevel")) {
            int userLevel = call.argument("userLevel");
            Tapjoy.setUserLevel(userLevel);
        } else if (call.method.equals("limitedConnect")) {
            String sdkKey = call.argument("sdkKey");
            Tapjoy.limitedConnect(activity.getApplicationContext(), sdkKey, new TJConnectListener() {
                @Override
                public void onConnectSuccess() {
                    registrar.activity().runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            channel.invokeMethod("onLimitedConnectSuccess", null);
                        }
                    });
                }

                @Override
                public void onConnectFailure() {
                    registrar.activity().runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            channel.invokeMethod("onLimitedConnectFailure", null);
                        }
                    });
                }
            });
        } else if (call.method.equals("getCurrencyBalance")) {
            Tapjoy.getCurrencyBalance(new TJGetCurrencyBalanceListener() {
                @Override
                public void onGetCurrencyBalanceResponse(String s, int i) {
                    registrar.activity().runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            channel.invokeMethod("onGetCurrencyBalanceResponse", null);
                        }
                    });
                }

                @Override
                public void onGetCurrencyBalanceResponseFailure(String s) {
                    registrar.activity().runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            channel.invokeMethod("onGetCurrencyBalanceResponseFailure", null);
                        }
                    });
                }
            });
        } else if (call.method.equals("awardCurrency")) {
            int amount = call.argument("amount");
            Tapjoy.awardCurrency(amount, new TJAwardCurrencyListener() {
                @Override
                public void onAwardCurrencyResponse(String s, int i) {
                    registrar.activity().runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            channel.invokeMethod("onAwardCurrencyResponse", null);
                        }
                    });
                }

                @Override
                public void onAwardCurrencyResponseFailure(String s) {
                    registrar.activity().runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            channel.invokeMethod("onAwardCurrencyResponseFailure", null);
                        }
                    });
                }
            });
        } else if (call.method.equals("getLimitedPlacement")) {
            String placementName = call.argument("placementName");
            Tapjoy.getLimitedPlacement(placementName, new TJPlacementListener() {
                @Override
                public void onRequestSuccess(TJPlacement tjPlacement) {

                }

                @Override
                public void onRequestFailure(TJPlacement tjPlacement, TJError tjError) {

                }

                @Override
                public void onContentReady(TJPlacement tjPlacement) {

                }

                @Override
                public void onContentShow(TJPlacement tjPlacement) {

                }

                @Override
                public void onContentDismiss(TJPlacement tjPlacement) {

                }

                @Override
                public void onPurchaseRequest(TJPlacement tjPlacement, TJActionRequest tjActionRequest, String s) {

                }

                @Override
                public void onRewardRequest(TJPlacement tjPlacement, TJActionRequest tjActionRequest, String s, int i) {

                }

                @Override
                public void onClick(TJPlacement tjPlacement) {

                }
            });
        } else if (call.method.equals("setEarnedCurrencyListener")) {
            Tapjoy.setEarnedCurrencyListener(new TJEarnedCurrencyListener() {
                @Override
                public void onEarnedCurrency(String s, int i) {
                    registrar.activity().runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            channel.invokeMethod("onEarnedCurrency", null);
                        }
                    });
                }
            });
        } else if (call.method.equals("setReceiveRemoteNotification")) {      // check for map argument.
            Map remoteMessage = call.argument("remoteMessage");
            Tapjoy.setReceiveRemoteNotification(activity.getApplicationContext(), remoteMessage);
        } else if (call.method.equals("trackEvent")) {
            String name = call.argument("name");
            Long value = call.argument("value");
            String category = call.argument("category");
            String parameter1 = call.argument("parameter1");
            String parameter2 = call.argument("parameter2");
            Map values = call.argument("values");

            if (value == null && category == null && parameter1 == null && parameter2 == null && values == null) {
                Tapjoy.trackEvent(name);
            } else if (category == null && parameter1 == null && parameter2 == null && values == null) {
                Tapjoy.trackEvent(name, value);
            } else if (parameter1 == null && parameter2 == null && values == null) {
                Tapjoy.trackEvent(category, name, value);
            } else if (value == null && values == null) {
                Tapjoy.trackEvent(category, name, parameter1, parameter2);
            } else if (values == null) {
                Tapjoy.trackEvent(category, name, parameter1, parameter2, value);
            } else if (value == null) {
                Tapjoy.trackEvent(category, name, parameter1, parameter2, values);
            } else {
                result.success("You Must Pass Compatible Arguments!");
            }
        } else if (call.method.equals("trackPurchaseById")) {
            String productId = call.argument("productId");
            String currencyCode = call.argument("currencyCode");
            double price = call.argument("price");
            String campaignId = call.argument("campaignId");
            Tapjoy.trackPurchase(productId, currencyCode, price, campaignId);
        } else if (call.method.equals("trackPurchaseByData")) {
            String skuDetails = call.argument("skuDetails");
            String purchaseData = call.argument("purchaseData");
            String dataSignature = call.argument("dataSignature");
            String campaignId = call.argument("campaignId");
            Tapjoy.trackPurchase(skuDetails, purchaseData, dataSignature, campaignId);
        } else {
            result.notImplemented();
        }
    }

}
