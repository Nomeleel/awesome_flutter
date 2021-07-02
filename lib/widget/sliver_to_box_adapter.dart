import 'package:flutter/widgets.dart';

class SliverToBoxScrollViewAdapter extends StatelessWidget {
  const SliverToBoxScrollViewAdapter({
    Key key,
    @required this.boxScrollView,
  })  : assert(boxScrollView != null),
        super(key: key);

  final BoxScrollView boxScrollView;

  @override
  Widget build(BuildContext context) {
    return _toSliver(context, boxScrollView) ?? _sliverEmpty;
  }

  Widget _toSliver(BuildContext context, BoxScrollView view) {
    if (view == null) return view;

    final padding = view.padding;
    // ignore: invalid_use_of_protected_member
    Widget sliver = view.buildChildLayout(context);
    if (padding != null && padding != EdgeInsets.zero) {
      sliver = SliverPadding(
        padding: padding,
        sliver: sliver,
      );
    }
    return sliver;
  }

  Widget _sliverEmpty() => SliverPadding(padding: EdgeInsets.zero);
}

mixin SliverToBoxAdapterMixin {
  Widget buildSliver(BuildContext context);

  Widget boxScrollViewToSliver(BuildContext context, BoxScrollView boxScrollView) {
    return SliverToBoxScrollViewAdapter(
      boxScrollView: boxScrollView,
    );
  }
}
