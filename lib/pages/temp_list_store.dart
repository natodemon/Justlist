import 'package:shopping_list_vs/models/item.dart';
import 'package:shopping_list_vs/models/shop_list.dart';

class ListStore {
  final List itemList = List();
  final List shoplistList = List();

  ListStore() {
    shoplistList.add(new ShopList.withId(0, 'Supermarket'));

    itemList.add(new Item.withId(0,'Loaf of bread',false,0));
    itemList.add(new Item.withId(1,'Milk',false,0));
    itemList.add(new Item.withId(2,'Bananas',true,0));
    itemList.add(new Item.withId(3,'Cereals',true,0,604800)); // 1 week timeout
  }

  List<Item> getItemList(int listNum) {
    List<Item> tempList = List();

    for(int i = 0; i < itemList.length; i++) {
      if(itemList[i].listId == listNum) {
        tempList.add(itemList[i]);
      }
    }

    return tempList;
  }

  List get getshopList => shoplistList;

  void removeItemAt(int itemId){
    itemList.removeAt(itemId);
  }

  void addItemAt(Item toAdd, int index) {
    itemList.insert(index, toAdd);
  }
}