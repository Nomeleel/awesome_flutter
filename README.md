# Awesome Flutter

[![Support Platforms](https://img.shields.io/badge/flutter-android%20%7C%20ios-green.svg)](https://github.com/Nomeleel/awesome_flutter) [![Flutter Sample](https://img.shields.io/badge/flutter-sample-purple.svg)](https://github.com/Nomeleel/fine_client) [![Star on GitHub](https://img.shields.io/github/stars/Nomeleel/awesome_flutter.svg?style=flat&logo=github&colorB=deeppink&label=stars)](https://github.com/Nomeleel/awesome_flutter) 

You say you are great, I do not believe it, I will verify it myself. Here are some attempts to use Flutter.

## Overview

| Name | Introduction | Note
| :------: | ------ | ------ |
| [App Store Card](#appstorecard) | Realize the animation of the Today tab page card of the Apple App Store. |
| [Yin Yang Switch](#yinyangswitch) | Use clipper method to achieve irregular shapes. |
| [Grid Paper Expansion](#gridpaperexpansion) | Expansion of flutter widget GridPaper. |
| [Water Wave](#waterwave) | Combining mathematical trigonometric functions and physical waves to achieve a water wave effect. |
| [Creative Stitching](#creativestitching) | Explore the possible feasibility of Flutter in image manipulation. |
| [Sliver AppBar Expansion](#sliverappbarexpansion) | Expansion of flutter widget SliverAppBar, suppert after pinned can switch title leading actions and brightness in app bar widget. |
| [Absorb Stack](#absorbstack) | 使stack下层也可以响应手势 解除只能命中一层的限制 |
| [Future Button](#) | buttton响应后 才能接受下次点击 |
| [Text Expansion](#) | |
| [Scroll View Jump Top](#) | |
| [Side Panel](#) | |
| [Nav To List View Auto Scroll View](#) | |
| [Combine List View](#) | |

**Next, let the picture dance.**

## AppStoreCard

<center>
    <img src="https://raw.githubusercontent.com/Nomeleel/Assets/master/awesome_flutter/markdown/app_store_card_1.gif" width="25%"/>
    <img src="https://raw.githubusercontent.com/Nomeleel/Assets/master/awesome_flutter/markdown/app_store_card_2.gif" width="25%"/>
</center>

## YinYangSwitch

<center>
    <img src="https://raw.githubusercontent.com/Nomeleel/Assets/master/awesome_flutter/markdown/yin_yang_switch.gif" width="25%"/>
</center>

## GridPaperExpansion

<center>
    <img src="https://raw.githubusercontent.com/Nomeleel/Assets/master/awesome_flutter/markdown/grid_paper_exp.gif" width="25%"/>
</center>

## WaterWave

<center>
    <img src="https://raw.githubusercontent.com/Nomeleel/Assets/master/awesome_flutter/markdown/water_wave.gif" width="25%"/>
</center>

## CreativeStitching

<center>
    <img src="https://raw.githubusercontent.com/Nomeleel/Assets/master/awesome_flutter/markdown/creative_stitching.gif" width="25%"/>
</center>

## SliverAppBarExpansion

If the initial background color and the pinned background color after scrolling big different, the same app bar cannot adapt to the two backgrounds. At this time, you need to automatically switch the appbar to adapt to the new background.

<center>SliverAppBar in Flutter ｜ SliverAppBarExpansion</center>

<center>
    <img src="https://raw.githubusercontent.com/Nomeleel/Assets/master/awesome_flutter/markdown/sliver_app_bar.gif" width="25%"/><img src="https://raw.githubusercontent.com/Nomeleel/Assets/master/awesome_flutter/markdown/sliver_app_bar_expansion.gif" width="25%"/>
</center>

## Found issues in Flutter

The inevitable thing is that I also found some issues in Flutter.

Current Dev Evn: **Flutter (Channel stable, v1.22.1, on Mac OS X 10.15.5 19F101, locale zh-Hans-CN)**

I have also create some issues, but finally found similar ones, whichever is the earliest.

| Issue ID | Description | About | Note
| :------: | :------: | :------: | :------: |
| [24786](https://github.com/flutter/flutter/issues/24786) | ReorderableListView#onReorder passes an incorrect new index. | [ReorderableListView](https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/material/reorderable_list.dart#L59) |  |
| [60594](https://github.com/flutter/flutter/issues/60594) | The target Hero widget is build three times. | [Hero](https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/widgets/heroes.dart#L154) |  |
| [13937](https://github.com/flutter/flutter/issues/13937) | Unable to call a platform channel method from another isolate. | Isolate |  |
| [59143](https://github.com/flutter/flutter/issues/59143) | Tabbar initialIndex indicator image not working. | TabBar Indicator Image Decoration |  |