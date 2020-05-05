import 'package:flutter/material.dart';
import 'package:shopping_list_vs/models/item.dart';
import 'package:shopping_list_vs/models/shop_list.dart';
import 'package:shopping_list_vs/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class ListGen extends StatefulWidget {
  final int shopListId;

  ListGen(this.shopListId, {Key key}) : super(key: key);
  @override
  ListGenState createState() => ListGenState();
}

class ListGenState extends State<ListGen> {
  DBHelper dbHelper = DBHelper();
  final Set<int> _selectItems = Set<int>();
  List<Item> _itemList;

  @override
  Widget build(BuildContext context) {
    return _buildCurList(context);
  }

  Widget _buildCurList(BuildContext context) {
    if(_itemList == null) {
      _itemList = List<Item>();
      updateListDB();
    }

    return ListView.builder(
      itemCount: _itemList.length,
      itemBuilder: (context, index) {
        return Dismissible(
          key: ValueKey(_itemList[index]),
          onDismissed: (direction) {  // Should refactor this to separate method
            final dismissedListItem = _itemList[index];
            final int dismissedItemId = dismissedListItem.id;
            setState(() => _itemList.remove(dismissedListItem));
            Scaffold.of(context).hideCurrentSnackBar();
            Scaffold.of(context)
              .showSnackBar(SnackBar(
                content: Text('${dismissedListItem.name} removed'),
                duration: Duration(seconds: 4),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () {
                    updateListDB();   // Causes local list to be repopulated from database
                  },
                ),
              ),
              ) // showSnackBar
              .closed.then((reason) {
                if(reason != SnackBarClosedReason.action) {
                  if(dismissedListItem.favorite){
                    dbHelper.removeFavItem(dismissedItemId);
                  }else {
                    dbHelper.deleteItem(dismissedItemId);
                  }
                }
              });           
          },

          child: InkWell(
            onTap: () {
                  setState(() {
                    int curItemId = _itemList[index].id;
                    if(_selectItems.contains(curItemId)){
                      _selectItems.remove(curItemId);
                    }else{
                      _selectItems.add(curItemId);
                    }
                  });
                },
            child: Card(
              color: _selectItems.contains(_itemList[index].id) ? Colors.greenAccent : null,
              margin: EdgeInsets.all(2.0),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 11.0,horizontal: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(_itemList[index].name, style: TextStyle(fontSize:17.0),)
                  ],
                ),
              ),
            )
          )
        );  
      },
    );
  }

  void updateListDB() {
    final Future<Database> dbFuture = dbHelper.initDB();
    dbFuture.then((database) {
      Future<List<Item>> futureItemList = dbHelper.getItemsForShopList(widget.shopListId);
      futureItemList.then((itemList) {
        setState(() {
          this._itemList = itemList;
        });
      });
    });
  }

  void newListSetup() {
    setState(() {
      this._itemList = List<Item>(); // Blank out list removing old items
      this._selectItems.clear();
    });
    final Future<Database> dbFuture = dbHelper.initDB();
    dbFuture.then((database) {
      Future<List<Item>> futureItemList = dbHelper.getItemsForShopList(widget.shopListId);
      futureItemList.then((newItemList) {
        setState(() {
          this._itemList = newItemList;
        });
      });
    });
  }

  void stringList() async {
    // When item ID added to list, sleep no. of secs to allow for multiple selection
    // then convert to string & store in shared perfs
    // Retrieve list upon app load if set empty, convert to int set from strings
    // 
  }
}
