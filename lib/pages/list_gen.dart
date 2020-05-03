import 'package:flutter/material.dart';
import 'package:shopping_list_vs/models/item.dart';
import 'package:shopping_list_vs/models/shop_list.dart';
import 'package:shopping_list_vs/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class ListGen extends StatefulWidget {
  ListGen({Key key}) : super(key: key);
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
          onDismissed: (direction) {
            final dismissedListItem = _itemList[index];
            final int dismissedItemId = dismissedListItem.id;
            setState(() => _itemList.remove(dismissedListItem));
            //setState(() => dbHelper.deleteItem(dismissedItem.id));
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
                  dbHelper.deleteItem(dismissedItemId);
                  // Need to deal w/ checking if item is favourite and thus shouldn't be deleted from DB
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
                padding: EdgeInsets.symmetric(vertical: 9.0,horizontal: 15.0),
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
      Future<List<Item>> futureItemList = dbHelper.getItemsForShopList(0);
      futureItemList.then((itemList) {
        setState(() {
          this._itemList = itemList;
          //print(_itemList.length);
        });
      });
    });
  }

  void tempInsert() async{
    ShopList tempShopList = ShopList('First List');
    await dbHelper.insertList(tempShopList);

    Item tempItem0 = Item('Potatoes', false, 0);
    Item tempItem1 = Item('Bananas', false, 0);
    Item tempItem2 = Item('Bread', true, 0);

    await dbHelper.insertItem(tempItem0);
    await dbHelper.insertItem(tempItem1);
    await dbHelper.insertItem(tempItem2);

    updateListDB();
  }
}