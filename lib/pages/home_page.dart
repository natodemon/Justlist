import 'package:flutter/material.dart';
import 'package:shopping_list_vs/pages/list_gen.dart';
import 'package:shopping_list_vs/utils/database_helper.dart';
import 'package:shopping_list_vs/models/item.dart';
import 'package:shopping_list_vs/models/shop_list.dart';
import 'package:shopping_list_vs/utils/listItem_input_dialog.dart';
import 'package:shopping_list_vs/pages/favourite_selection.dart';

class HomePage extends StatefulWidget {
  HomePageState createState() => HomePageState();
}


class HomePageState extends State<HomePage> {
  final GlobalKey<ListGenState> _listGenState = GlobalKey<ListGenState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DBHelper dbHelper = DBHelper();
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Justlist'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.navigate_next),
            tooltip: 'Faves Page',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavouriteList())
              );
            },
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            SizedBox(
              height: 80.0,
              child: DrawerHeader(
                child: Text('List Categories', style: TextStyle(color: Colors.white, fontSize: 18.0),),
                decoration: BoxDecoration(color: Colors.blue),
              ),
            ),
            ListTile(
              title: Text('Cat 1', style: TextStyle(fontSize: 18.0,),),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Cat 2', style: TextStyle(fontSize: 18.0,),),
              onTap: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
      drawerEdgeDragWidth: MediaQuery.of(context).size.width /6,
      body: ListGen(key: _listGenState),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          _scaffoldKey.currentState.hideCurrentSnackBar();

          await showDialog(
            context: context,
            builder: (context){
              return ListInputDialog();
            }
          );
          _listGenState.currentState.updateListDB();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<String> _constructDialog(BuildContext context) async{
    String itemName = '';
    //bool newchecked;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('New item entry'),
          content: TextField(
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(hintText: 'Enter item name e.g. bread'),
            onChanged: (value) {
              itemName = value;
            },
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Add'),
              onPressed: () {
                Navigator.of(context).pop(itemName);
              },
            ),
            Text('Favorite'),
            Checkbox(
              value: isChecked,
              onChanged: (bool newChecked) {
                setState(() {
                  isChecked = newChecked;
                });
              }
            )
          ],
        );
      }
    );
  }

  Item _constructNewItem(String itemName) {
    // Will need some validation here or at time of input
    return Item(itemName,false,0);
  }
}
