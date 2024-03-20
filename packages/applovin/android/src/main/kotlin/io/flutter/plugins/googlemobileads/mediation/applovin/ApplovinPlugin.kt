package io.flutter.plugins.googlemobileads.mediation.applovin

import android.content.Context
import android.util.Log
import androidx.annotation.NonNull
import com.applovin.sdk.AppLovinPrivacySettings
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** ApplovinPlugin */
class ApplovinPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var context: Context

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    context = flutterPluginBinding.getApplicationContext()
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "applovin")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    Log.d("MethodCall", "onMethodCall")
    if (call.method == "setDoNotSell") {
      val doNotSell: Any? = call.argument("doNotSell")
      if (doNotSell == null || doNotSell !is Boolean) {
        Log.d("MethodCall", "$doNotSell is not a Boolean")
        result.notImplemented()
        return
      }
      Log.d("MethodCall", "setDoNotSell($doNotSell)")
      setDoNotSell(doNotSell)
      result.success(null)
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  private fun setDoNotSell(doNotSell: Boolean) {
    AppLovinPrivacySettings.setDoNotSell(doNotSell, context)
  }
}
