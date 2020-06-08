import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_list_vs/models/item_fs.dart';

class FSDatabase {

  final String uid;
  FSDatabase({this.uid});

  final CollectionReference shopListColl = Firestore.instance.collection('ShopLists');
  final CollectionReference favItemsColl = Firestore.instance.collection('FavouriteItems');

  final fs = Firestore.instance;

  Stream<List<ItemFS>> itemStream(String listId) {
    var col = fs.collection('ShopLists').document(listId).collection('Items');
    
    return col.snapshots().map((items) => 
      items.documents.map((item) => ItemFS.fromFirestore(item)).toList());
  }

  modifyItem(String listId, String itemId, newData) async{
    var doc = fs.document('ShopLists/$listId').collection('Items').document(itemId);

    await doc.updateData(newData);
  }

  deleteItem(String listId, String itemId) async{
    await fs.document('ShopLists/$listId').collection('Items')
      .document(itemId)
      .delete();
  }


  // ****************************
  // Testing methods, not for production!
  // ****************************

  List<ItemFS> _itemsfromFStore(QuerySnapshot snap) {
    return snap.documents.map((doc) {
      return ItemFS(
        name:doc.data['title'] ?? '',
        favourite: doc.data['favourite'] ?? false,
        timeout: doc.data['timeout'] ?? 0
      );
    }).toList();
  }

  DocumentReference get testDoc {
    return Firestore.instance.document('ShopLists/EcHIwuuJsAc6bhHKop9z');
  }

  // Stream<List<ItemFS>> get itemStream {
  //   return testDoc.collection('Items').snapshots()
  //     .map(_itemsfromFStore);
  // }
}