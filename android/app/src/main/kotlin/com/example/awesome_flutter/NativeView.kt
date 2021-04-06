package com.example.awesome_flutter

import android.content.Context
import android.graphics.Color
import android.view.Gravity
import android.view.View
import android.widget.Button
import android.widget.LinearLayout
import android.widget.Space
import android.widget.TextView
import androidx.compose.ui.Alignment
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.common.MethodChannel

internal class NativeView(context: Context, binaryMessenger: BinaryMessenger, id: Int, creationParams: Map<String?, Any?>?) : PlatformView {
    private val view: View

    private val methodChannel: MethodChannel = MethodChannel(binaryMessenger, "awesome_flutter/platform_view/method_channel")

    init {
        view = LinearLayout(context).apply {
            orientation = LinearLayout.VERTICAL
            gravity = Gravity.CENTER
            setBackgroundColor(Color.WHITE)
            addView(TextView(context).apply {
                text = "This is Android view (id: $id)"
                textSize = 25f
                setTextColor(Color.BLACK)
            })
            addView(TextView(context))
            addView(Button(context).apply {
                text = "Show Flutter View Bottom Sheet"
                textSize = 25f
                setBackgroundColor(Color.GREEN)
                setOnClickListener {
                    methodChannel.invokeMethod("showViewBottomSheet", "Android")
                }
            })
        }
    }

    override fun getView(): View {
        return view
    }

    override fun dispose() {}
}