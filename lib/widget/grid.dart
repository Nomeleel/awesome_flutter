/// 突然想到很久之前写UWP用XAML的时候，里面有个Grid布局（我记得是这个类似的名字），
/// 如果里面有很多Row和Coloumn嵌套，会使布局看起来很乱，所以就需要加个参数控制当前Widget在第几行第几列
/// 然后动态组装布局，或许是个很好的想法，经典的思想加上新近的弹性布局或许1 + 1 > 2
/// 这里先留个TODO，接下来去调研实现！！！

import 'package:flutter/widgets.dart';

/// 需要给Grid布局中的所有Widget配置Grid需要的参数。
/// extension是一种很好的侵入方式。
/// 1. 不支持字段，或许可以手动封装geter setert。
/// 2. 构建一个Config类进行配置，但在写法上会导致嵌套，与初衷不符。
/// 3. Column or Row Definition总是要写的，可以在里面加个字段存放Widget的index，但要同时配置Row和Column，并且Span情况下要配置更多。
/// 4. 在Definition同级添加属性，用来存放Config合集，并与Child中Widget做映射，类似于第二种，只是将嵌套提出来而已。
extension GridExtension on Widget {
  set columnIndex(int columnIndex) {
    columnIndex = columnIndex;
  }

  int get columnIndex => columnIndex;
  // int rowIndex;
  // int columnSpan;
  // int rowSpan;
}

class Test {
  void test() {
    Widget widget = Container();
    widget.columnIndex;
  }
}

/*
<Grid>
  <Grid.RowDefinitions>
      <RowDefinition/>
      <RowDefinition Height="25"/>
      <RowDefinition Height="20"/>
  </Grid.RowDefinitions>
  <Grid.ColumnDefinitions>
      <ColumnDefinition/>
      <ColumnDefinition/>
  </Grid.ColumnDefinitions>
  <Grid Grid.ColumnSpan="2">
      <Image/>
      <Image/>
  </Grid>
  <TextBlock Grid.Row="1" Grid.ColumnSpan="2"/>
  <StackPanel Grid.Row="2">
      <Image/>
      <TextBlock>
  </StackPanel>
  <StackPanel Grid.Row="2" Grid.Column="1">
      <Image/>
      <TextBlock/>
  </StackPanel>
</Grid>

*/