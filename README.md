# Awesome Flutter

[![Support Platforms](https://img.shields.io/badge/flutter-android%20%7C%20ios-green.svg)](https://github.com/Nomeleel/awesome_flutter) [![Flutter Sample](https://img.shields.io/badge/flutter-sample-purple.svg)](https://github.com/Nomeleel/fine_client) [![Star on GitHub](https://img.shields.io/github/stars/Nomeleel/awesome_flutter.svg?style=flat&logo=github&colorB=deeppink&label=stars)](https://github.com/Nomeleel/awesome_flutter) 

You say you are great, I do not believe it, I will verify it myself. Here are some attempts to use Flutter.

## Overview

[Web page for Awesome Flutter](https://nomeleel.github.io/awesome_flutter/)

| Name | Introduction | Note
| :------: | ------ | ------ |
| [App Store Card](#appstorecard) | Realize the animation of the Today tab page card of the Apple App Store. |
| [Yin Yang Switch](#yinyangswitch) | Use clipper method to achieve irregular shapes. |
| [Grid Paper Expansion](#gridpaperexpansion) | Expansion of flutter widget GridPaper. |
| [Water Wave](#waterwave) | Combining mathematical trigonometric functions and physical waves to achieve a water wave effect. |
| [Creative Stitching](#creativestitching) | Explore the possible feasibility of Flutter in image manipulation. |
| [Sliver AppBar Expansion](#sliverappbarexpansion) | Expansion of flutter widget SliverAppBar, suppert after pinned can switch title leading actions and brightness in app bar widget. |
| [Absorb Stack](#absorbstack) | Enable the Stack to respond to gestures at the specified level, remove the restriction of priority response to the outermost layer. |
| [Future Button](#futurebutton) | Disable the button before the end of this future response. |
| [Text Expansion](#textexpansion) | Text expand and collapse widget. |
| [Scroll View Jump Top](#scrollviewjumptop) | Wrap the scroll view so that it scrolls to a certain position and the upward button automatically appears, so it can return to the top of the view. |
| [Side Panel](#sidepanel-colorpicker) | Customize the sidebar panel. |
| [Color Picker](#sidepanel-colorpicker) | Simple color picker. |
| [Nav To List View Auto Scroll](#navtolistviewautoscroll) | Navigate to the listview and automatically scroll to the specified index to the middle of the view. |
| [Combine List View](#combinelistview) | In the listview, provide two lists for it, so that the sub-list is inserted into the main list every few items. |

**Next, let the picture dance.**

## AppStoreCard

[Web demo for App Store Card](https://nomeleel.github.io/awesome_flutter/)

<center>
    <img src="https://raw.githubusercontent.com/Nomeleel/Assets/master/awesome_flutter/markdown/app_store_card_1.gif" width="25%"/>
    <img src="https://raw.githubusercontent.com/Nomeleel/Assets/master/awesome_flutter/markdown/app_store_card_2.gif" width="25%"/>
</center>

## YinYangSwitch

[Web demo for Yin Yang Switch](https://nomeleel.github.io/awesome_flutter/#/yin_yang_switch_view)

<center>
    <img src="https://raw.githubusercontent.com/Nomeleel/Assets/master/awesome_flutter/markdown/yin_yang_switch.gif" width="25%"/>
</center>

## GridPaperExpansion

[Web demo for Grid Paper Expansion](https://nomeleel.github.io/awesome_flutter/#/grid_paper_exp_view)

<center>
    <img src="https://raw.githubusercontent.com/Nomeleel/Assets/master/awesome_flutter/markdown/grid_paper_exp.gif" width="25%"/>
</center>

## WaterWave

[Web demo for Water Wave](https://nomeleel.github.io/awesome_flutter/#/water_wave_view)

<center>
    <img src="https://raw.githubusercontent.com/Nomeleel/Assets/master/awesome_flutter/markdown/water_wave.gif" width="25%"/>
</center>

## CreativeStitching

[Web demo for Creative Stitching](https://nomeleel.github.io/awesome_flutter/#/creative_stitching_view)

<center>
    <img src="https://raw.githubusercontent.com/Nomeleel/Assets/master/awesome_flutter/markdown/creative_stitching.gif" width="25%"/>
</center>

## SliverAppBarExpansion

If the initial background color and the pinned background color after scrolling big different, the same app bar cannot adapt to the two backgrounds. At this time, you need to automatically switch the appbar to adapt to the new background.

[Web demo for Sliver AppBar Expansion](https://nomeleel.github.io/awesome_flutter/#/sliver_app_bar_exp_view)

<center>SliverAppBar in Flutter ｜ SliverAppBarExpansion</center>

<center>
    <img src="https://raw.githubusercontent.com/Nomeleel/Assets/master/awesome_flutter/markdown/sliver_app_bar.gif" width="25%"/><img src="https://raw.githubusercontent.com/Nomeleel/Assets/master/awesome_flutter/markdown/sliver_app_bar_expansion.gif" width="25%"/>
</center>

## AbsorbStack

[Web demo for Absorb Stack](https://nomeleel.github.io/awesome_flutter/#/absorb_stack_view)

## FutureButton

[Web demo for Future Button](https://nomeleel.github.io/awesome_flutter/#/future_button_view)

## ScrollViewJumpTop

[Web demo for Scroll View Jump Top](https://nomeleel.github.io/awesome_flutter/#/scroll_view_jump_top_view)

## SidePanel-ColorPicker

[Web demo for Side Panel && Color Picker](https://nomeleel.github.io/fine_client/)

<center>
    <img src="https://raw.githubusercontent.com/Nomeleel/Assets/master/fine_client/markdown/gctsq_2.gif" width="60%" />
</center>

## NavToListViewAutoScroll

[Web demo for Nav To List View Auto Scroll](https://nomeleel.github.io/awesome_flutter/#/nav_to_list_view_auto_scroll_view)

## CombineListView

[Web demo for Combine List View](https://nomeleel.github.io/awesome_flutter/#/combine_list_view_view)

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