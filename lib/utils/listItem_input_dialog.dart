import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopping_list_vs/utils/database_helper.dart';
import 'package:shopping_list_vs/models/item.dart';

class ListInputDialog extends StatefulWidget {
  final int shopListId;

  ListInputDialog(this.shopListId); 
  @override
  ListInputDialogState createState() => ListInputDialogState();
}

class ListInputDialogState extends State<ListInputDialog> {
  //TextEditingController _textEditingController = TextEditingController();
  DBHelper dbHelper = DBHelper();
  
  // Input variables
  bool isFavourite = false;
  String itemName = '';
  int timeoutVal;
  
  @override
  Widget build(BuildContext context) {
    return _constructDialog(context);
  }

  _constructDialog(BuildContext context) {
    //String itemName = '';
    return AlertDialog(
          title: Text('New item entry'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      autofocus: true,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(hintText: 'Enter item name e.g. bread'),
                      onChanged: (textVal) {
                        setState(() {
                          itemName = textVal;
                        });
                      },
                    ),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Text('Favourite:'),
                  Checkbox(
                    value: isFavourite,
                    onChanged: (newCheckedVal) {
                      setState(() {
                        isFavourite = newCheckedVal;
                      });
                    },
                  ),
                  Text('Timeout:'),
                  SizedBox(width: 8.0,),
                  Expanded(
                    child: TextField(
                      style: TextStyle(fontSize: 18.0,),
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(hintText: 'Days'),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(2)
                      ],
                      onChanged: (newTimeout) {
                        timeoutVal = num.tryParse(newTimeout);
                      },
                    ),
                  )
                ],
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  MaterialButton(
                    color: Colors.blue,
                    child: Text('Add'),
                    onPressed: () {
                      dbHelper.insertItem(_constructNewItem(itemName,isFavourite, timeoutVal));
                      Navigator.of(context).pop();
                    },
                  )
                ],
              )
            ],
          ),
        );
  }

  Item _constructNewItem(String itemName, bool favourite, int timeout) {
    // Will need some validation here or at time of input
    //int fav = (favourite == true ? 1 : 0);
    if(timeout != null) {
      return Item(itemName,favourite,widget.shopListId, timeout);
    }else{
      return Item(itemName,favourite,widget.shopListId);
    }
  }
}