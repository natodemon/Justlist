import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopping_list_vs/utils/database_helper.dart';
import 'package:shopping_list_vs/models/item.dart';

class ListInputDialog extends StatefulWidget {

  @override
  ListInputDialogState createState() => ListInputDialogState();
}

class ListInputDialogState extends State<ListInputDialog> {
  //TextEditingController _textEditingController = TextEditingController();
  DBHelper dbHelper = DBHelper();
  bool isFavourite = false;
  @override
  Widget build(BuildContext context) {
    return _constructDialog(context);
  }

  _constructDialog(BuildContext context) {
    String itemName = '';
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
            Text('Favourite'),
            Checkbox(
              value: isFavourite,
              onChanged: (newCheckedVal) {
                setState(() {
                  isFavourite = newCheckedVal;
                });
              },
            ),
            // Text('Timeout'),
            // TextField(
            //   keyboardType: TextInputType.number,
            //   inputFormatters: <TextInputFormatter>[
            //     WhitelistingTextInputFormatter.digitsOnly,
            //     LengthLimitingTextInputFormatter(2)
            //   ],
            // ),
            FlatButton(
              child: Text('Add'),
              onPressed: () {
                dbHelper.insertItem(_constructNewItem(itemName,isFavourite));
                Navigator.of(context).pop();
              },
            )
          ],
        );
  }

  Item _constructNewItem(String itemName, bool favourite) {
    // Will need some validation here or at time of input
    //int fav = (favourite == true ? 1 : 0);
    return Item(itemName,favourite,0);
  }
}