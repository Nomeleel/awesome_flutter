//
//  FLNativeView.swift
//  Runner
//
//  Created by Nomeleel on 2021/4/1.
//  Copyright © 2021 The Chromium Authors. All rights reserved.
//

import Flutter
import UIKit

class FLNativeViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return FLNativeView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger)
    }
}

class FLNativeView: NSObject, FlutterPlatformView {
    private var _view: UIView
    private var _methodChannel: FlutterMethodChannel

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?
    ) {
        _view = UIView()
        _methodChannel = FlutterMethodChannel(name: "awesome_flutter/platform_view/method_channel", binaryMessenger: messenger!)
        super.init()
        // iOS views can be created here
        createNativeView(view: _view)
    }

    func view() -> UIView {
        return _view
    }

    func createNativeView(view _view: UIView){
        _view.backgroundColor = UIColor.white

        let platformLabel = UILabel()
        platformLabel.text = "This is iOS view"
        platformLabel.textColor = UIColor.black
        platformLabel.textAlignment = .center
        platformLabel.frame = CGRect(x: 70.0, y: 300.0, width: 300.0, height: 50.0)
        _view.addSubview(platformLabel)
        
        let showButton = UIButton()
        showButton.setTitle("Show Flutter View Bottom Sheet", for: .normal)
        showButton.backgroundColor = UIColor.purple
        showButton.layer.cornerRadius = 25.0
        showButton.frame = CGRect(x: 70.0, y: 400, width: 300.0, height: 50.0)
        showButton.addTarget(self, action: #selector(showFlutterViewBottomSheet(_:)), for: .touchUpInside)
        _view.addSubview(showButton)
    }
    
    @objc func showFlutterViewBottomSheet(_ sender:UIButton!)
    {
        _methodChannel.invokeMethod("showViewBottomSheet", arguments: "iOS")
    }
}
