import '../route/view_routes.dart';
import 'package:flutter/material.dart';

class SearchDelegateTestView extends StatelessWidget {
  const SearchDelegateTestView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: CustomSearchHintDelegate(hintText: '有求必应'));
            },
            icon: Icon(Icons.search),
          )
        ],
      ),
    );
  }
}

class CustomSearchHintDelegate extends SearchDelegate<String> {
  CustomSearchHintDelegate({
    @required String hintText,
  }) : super(
          searchFieldLabel: hintText,
          keyboardType: TextInputType.text,
        );

  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    return theme.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.brightness == Brightness.dark ? Colors.grey[900] : Colors.white,
        iconTheme: theme.primaryIconTheme.copyWith(color: Colors.grey),
        shadowColor: primaryColor,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: InputBorder.none,
      ),
    );
  }

  final Color primaryColor = Colors.purple;

  @override
  Widget buildLeading(BuildContext context) => BackButton();

  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(icon: Icon(Icons.clear), tooltip: 'Clear', onPressed: () => query = ''),
    ];
  }

  @override
  PreferredSizeWidget buildBottom(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(.5),
      child: Divider(height: .5, color: primaryColor, thickness: .5),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView.separated(
      itemCount: query.length,
      itemBuilder: (context, index) {
        final label = '$query-$index';
        return ListTile(
          title: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
          leading: Icon(Icons.search),
          onTap: () {
            query = label;
            showResults(context);
          },
        );
      },
      separatorBuilder: (context, index) => Divider(
        indent: 7,
        endIndent: 7,
        color: Colors.primaries[index % Colors.primaries.length],
        height: .5,
        thickness: .5,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.only(top: 7, bottom: MediaQuery.maybeOf(context)?.padding?.bottom ?? 0),
      itemCount: query.length,
      itemBuilder: (context, index) {
        final label = '$query-$index';
        return ListTile(
          leading: Container(
            height: 50,
            width: 70,
            color: Colors.primaries[index % Colors.primaries.length],
            alignment: Alignment.center,
            child: Text('$index'),
          ),
          title: Text(label, maxLines: 2, overflow: TextOverflow.ellipsis),
          subtitle: Text(label * (index + 1), maxLines: 7, overflow: TextOverflow.ellipsis),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: () => Navigator.of(context).pushNamed(viewRoutes.keys.elementAt(index % viewRoutes.keys.length)),
        );
      },
      separatorBuilder: (context, index) => Divider(
        indent: 2,
        endIndent: 2,
        color: Colors.grey,
        height: .5,
        thickness: .5,
      ),
    );
  }
}
