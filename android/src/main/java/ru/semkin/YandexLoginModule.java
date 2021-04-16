package ru.semkin;

import android.app.Activity;
import android.content.Intent;
import android.os.Build;

import androidx.annotation.RequiresApi;

import com.facebook.react.bridge.ActivityEventListener;
import com.facebook.react.bridge.BaseActivityEventListener;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableNativeArray;
import com.yandex.authsdk.YandexAuthException;
import com.yandex.authsdk.YandexAuthLoginOptions;
import com.yandex.authsdk.YandexAuthOptions;
import com.yandex.authsdk.YandexAuthSdk;
import com.yandex.authsdk.YandexAuthToken;

public class YandexLoginModule extends ReactContextBaseJavaModule {

    private final String FAILED_TO_ACTIVATE = "FAILED_TO_ACTIVATE";
    private final int REQUEST_LOGIN_SDK = 1341;
    private final ReactApplicationContext reactContext;
    private Promise savedPromise;
    private YandexAuthSdk sdk;

    public YandexLoginModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
        reactContext.addActivityEventListener(mActivityEventListener);
    }

    @Override
    protected void finalize() throws Throwable {
        reactContext.removeActivityEventListener(mActivityEventListener);
        super.finalize();
    }

    @Override
    public String getName() {
        return "YandexLogin";
    }

    private final ActivityEventListener mActivityEventListener = new BaseActivityEventListener() {
        @Override
        public void onActivityResult(Activity activity, int requestCode, int resultCode, Intent intent) {
            if (requestCode == REQUEST_LOGIN_SDK) {
                try {
                    final YandexAuthToken yandexAuthToken = sdk.extractToken(resultCode, intent);
                    if (yandexAuthToken != null && savedPromise != null) {
                        new Thread() {
                            public void run() {
                                try {
                                    WritableNativeArray array = new WritableNativeArray();
                                    array.pushString(yandexAuthToken.getValue());
                                    array.pushString(sdk.getJwt(yandexAuthToken));

                                    savedPromise.resolve(array);
                                    savedPromise = null;
                                } catch (YandexAuthException e) {
                                    if (savedPromise != null) {
                                        savedPromise.reject(e);
                                        savedPromise = null;
                                    }
                                }
                            }
                        }.start();
                    }
                } catch (YandexAuthException e) {
                    if (savedPromise != null) {
                        savedPromise.reject(e);
                        savedPromise = null;
                    }
                }
            }
        }
    };

    @ReactMethod
    public void timeToStartCheckout(String nope, Promise promise) {
        try {
            savedPromise = promise;
            if (sdk != null) {
                final YandexAuthLoginOptions.Builder loginOptionsBuilder = new YandexAuthLoginOptions.Builder();
                final Intent intent = sdk.createLoginIntent(loginOptionsBuilder.build());
                getCurrentActivity().startActivityForResult(intent, REQUEST_LOGIN_SDK);
            }
        } catch (Exception e) {
            if (savedPromise != null) {
                savedPromise.reject(FAILED_TO_ACTIVATE, e);
                savedPromise = null;
            }
        }
    }

    @RequiresApi(api = Build.VERSION_CODES.KITKAT)
    @ReactMethod
    public void activate(String id) {
        YandexAuthOptions options = new YandexAuthOptions.Builder(reactContext)
                .build();
        sdk = new YandexAuthSdk(reactContext, options);
    }
}
