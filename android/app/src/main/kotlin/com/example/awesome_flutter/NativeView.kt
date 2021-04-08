package com.example.awesome_flutter

import android.content.Context
import android.graphics.Color
import android.view.Gravity
import android.view.View
import android.widget.Button
import android.widget.LinearLayout
import android.widget.TextView
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.common.MethodChannel

internal class NativeView(context: Context, binaryMessenger: BinaryMessenger, id: Int, creationParams: Map<String?, Any?>?) : PlatformView {
    private val view: View

    private val methodChannel: MethodChannel = MethodChannel(binaryMessenger, "awesome_flutter/platform_view/method_channel")

    init {
        view = LinearLayout(context).apply {
            orientation = LinearLayout.VERTICAL
            gravity = Gravity.CENTER_VERTICAL
            setBackgroundColor(Color.WHITE)
            addView(TextView(context).apply {
                text = "This is Android view (id: $id)"
                textSize = 25f
                setTextColor(Color.BLACK)
                gravity = Gravity.CENTER
            })
            addView(TextView(context))
            addView(Button(context).apply {
                text = "Show Flutter View Bottom Sheet"
                textSize = 20f
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


// Try to use compose in Flutter's Platform View.
// Currently not working.
/*
view = ComposeView(context).apply {
    setContent {
        testView()
    }
}

@Composable
fun testView() {
    Scaffold(
        drawerContent = {
            Text("Drawer content")
        },
        topBar = {
            TopAppBar(
                title = {
                    Text("Android View")
                }
            )
        },
        floatingActionButtonPosition = FabPosition.End,
        floatingActionButton = {
            ExtendedFloatingActionButton(
                text = { Text("Inc") },
                onClick = { /* Nothing */ }
            )
        },
        content = { innerPadding ->
            LazyColumn(contentPadding = innerPadding) {
                items(100) {
                    Text(it.toString())
                }
            }
        }
    )
}
 */