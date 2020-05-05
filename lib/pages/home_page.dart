import 'package:flutter/material.dart';
import 'package:shopping_list_vs/pages/list_gen.dart';
import 'package:shopping_list_vs/utils/database_helper.dart';
import 'package:shopping_list_vs/models/item.dart';
import 'package:shopping_list_vs/models/shop_list.dart';
import 'package:shopping_list_vs/utils/listItem_input_dialog.dart';
import 'package:shopping_list_vs/pages/favourite_selection.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  HomePageState createState() => HomePageState();
}


class HomePageState extends State<HomePage> {
  final GlobalKey<ListGenState> _listGenState = GlobalKey<ListGenState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  DBHelper dbHelper = DBHelper();
  bool isChecked = false;

  int curShoplistId = 0;

  @override
  void initState() {
    super.initState();
    _fetchListId();
  }

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
            onPressed: () async {
              _scaffoldKey.currentState.hideCurrentSnackBar();
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavouriteList(curShoplistId))
              );
              Future.delayed(Duration(milliseconds: 500), () {
                _listGenState.currentState.updateListDB();
              });
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
              title: Text('Dynamic List', style: TextStyle(fontSize: 18.0,),),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Future Feature', style: TextStyle(fontSize: 18.0,),),
              onTap: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
      drawerEdgeDragWidth: MediaQuery.of(context).size.width /6,
      body: ListGen(curShoplistId, key: _listGenState),
      floatingActionButton: SpeedDial(
        tooltip: 'New Entry Selection',
        shape: CircleBorder(),
        animatedIcon: AnimatedIcons.menu_arrow,
        children: [
          SpeedDialChild(
            child: Icon(Icons.note_add),
            backgroundColor: Colors.redAccent,
            label: 'New List',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () async{
              _scaffoldKey.currentState.hideCurrentSnackBar();
              await handleNewListCreation();
            }
          ),
          SpeedDialChild(
            child: Icon(Icons.edit_attributes),  // or Icons.mode_edit
            backgroundColor: Colors.blue,
            label: 'New Item',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () async{
              _scaffoldKey.currentState.hideCurrentSnackBar();

              await showDialog(
                context: context,
                builder: (context){
                  return ListInputDialog(curShoplistId);
                }
              );
              _listGenState.currentState.updateListDB();
            },
          )
        ],
      ),
    );
  }

  Future<int> handleNewListCreation() async {
    _incrementListId();
    //int needToWait = await dbHelper.insertList(genNewShopList());

    _listGenState.currentState.updateListDB();
    // async delete old items or handle in DBhelper
    //return needToWait;
  }

  void _fetchListId() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      curShoplistId = (prefs.getInt('listCounter') ?? 0);
    });

    // Adds list if new one doesn't exist w/ ID
    bool outcome = await dbHelper.checkListIdExists(curShoplistId);
    if(!outcome) {
      await dbHelper.insertList(genNewShopList());
    }
  }

  Future<int> _incrementListId() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      curShoplistId = (prefs.getInt('listCounter') ?? 0) + 1;
      prefs.setInt('listCounter', curShoplistId);
    });

    return await dbHelper.insertList(genNewShopList());
  }

  ShopList genNewShopList() {
    int timeNow = DateTime.now().toUtc().millisecondsSinceEpoch;

    return ShopList.withId(curShoplistId, 'DynamicList$curShoplistId', timeNow);
  }

  // Future<String> _constructDialog(BuildContext context) async{
  //   String itemName = '';
  //   //bool newchecked;
  //   return showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text('New item entry'),
  //         content: TextField(
  //           autofocus: true,
  //           textCapitalization: TextCapitalization.sentences,
  //           decoration: InputDecoration(hintText: 'Enter item name e.g. bread'),
  //           onChanged: (value) {
  //             itemName = value;
  //           },
  //         ),
  //         actions: <Widget>[
  //           FlatButton(
  //             child: Text('Add'),
  //             onPressed: () {
  //               Navigator.of(context).pop(itemName);
  //             },
  //           ),
  //           Text('Favorite'),
  //           Checkbox(
  //             value: isChecked,
  //             onChanged: (bool newChecked) {
  //               setState(() {
  //                 isChecked = newChecked;
  //               });
  //             }
  //           )
  //         ],
  //       );
  //     }
  //   );
  // }

  // Item _constructNewItem(String itemName) {
  //   // Will need some validation here or at time of input
  //   return Item(itemName,false,0);
  // }

  // Can most likely remove this ^
}
