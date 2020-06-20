package ru.semkin;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;

public class YandexLoginModule extends ReactContextBaseJavaModule {

    private final ReactApplicationContext reactContext;

    public YandexLoginModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    @Override
    public String getName() {
        return "YandexLogin";
    }

    @ReactMethod
    public void timeToStartCheckout(boolean testMode) {
        // TODO: Implement some actually useful functionality
        //callback.invoke("Received numberArgument: " + numberArgument + " stringArgument: " + stringArgument);
    }
}
