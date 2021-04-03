package com.example.awesome_flutter

import android.os.Bundle

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity: FlutterActivity() {
  override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    flutterEngine
      .platformViewsController
      .registry
      .registerViewFactory("<android-platform-view-type>", NativeViewFactory())
  }
}
