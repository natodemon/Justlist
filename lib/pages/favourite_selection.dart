import 'package:flutter/material.dart';
import 'package:shopping_list_vs/utils/database_helper.dart';
import 'package:shopping_list_vs/models/item.dart';
import 'package:sqflite/sqflite.dart';

class FavouriteList extends StatefulWidget {
  @override
  FavouriteListState createState() => FavouriteListState();
}

class FavouriteListState extends State<FavouriteList> {
  DBHelper dbHelper = DBHelper();
  List<Item> _favList;
  final Set<int> _selectedIDs = Set<int>();

  @override
  Widget build(BuildContext context) {
    return _constructList(context);
  }

  _constructList(BuildContext context) {
    if(_favList == null) {
      _favList = List<Item>();
      fetchFavlistDB();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Favourites"),
      ),
      body: ListView.builder(
        itemCount: _favList.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: ValueKey(_favList[index]),
            onDismissed: (direction) {
              favDeleteHandler(context, index);
            },
            child: Card(
              color: _selectedIDs.contains(_favList[index].id) ? Colors.blueAccent : null,
              margin: EdgeInsets.all(2.0),
              child: ListTile(
                title: Text(_favList[index].name, style: TextStyle(fontSize: 18.0)),
                dense: true,
                onTap: () {
                  setState(() {
                    // Do some selection stuff here
                  });
                },
              ),
            ),

          );
        }
      ),
    );
  }

  void fetchFavlistDB() {
    final Future<Database> dbFuture = dbHelper.initDB();
    dbFuture.then((database) {
      Future<List<Item>> futureFavList = dbHelper.getFavouriteItems();
      futureFavList.then((favList) {
        setState(() {
          this._favList = favList;
          //print(_itemList.length);
        });
      });
    });
  }

  void favDeleteHandler(BuildContext context, int curIndex) {
    final dismissedListItem = _favList[curIndex];

    setState(() => _favList.remove(dismissedListItem));
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context)
      .showSnackBar(SnackBar(
        content: Text('${dismissedListItem.name} removed from Favourites'),
        duration: Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            fetchFavlistDB();
          },
        ),
      )
      )
      .closed.then((reason) {
        if(reason != SnackBarClosedReason.action) {
          dbHelper.removeFavItem(dismissedListItem.id);
        }
      });
  }
}