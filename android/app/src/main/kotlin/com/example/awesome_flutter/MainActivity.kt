package com.example.awesome_flutter

import android.content.Intent

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
  override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    flutterEngine
      .platformViewsController
      .registry
      .registerViewFactory("<android-platform-view-type>", NativeViewFactory(flutterEngine.dartExecutor))

    val methodChannel = MethodChannel(flutterEngine.dartExecutor, "awesome_flutter/platform_view/method_channel")
    methodChannel.setMethodCallHandler { call, result ->
      when (call.method) {
        "openShareView" -> {
          val intent = Intent(Intent.ACTION_SEND)
          intent.setTypeAndNormalize("text/plain")
          intent.putExtra(Intent.EXTRA_TEXT, call.arguments as String);
          startActivity(Intent.createChooser(intent, "Android Share View"));

          result.success(null)
        } else -> {
          result.notImplemented()
        }
      }
    }
  }
}
