import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_list_vs/models/item_fs.dart';

class FSDatabase {

  final CollectionReference shopListColl = Firestore.instance.collection('ShopLists');
  final CollectionReference favItemsColl = Firestore.instance.collection('FavouriteItems');

  Stream<QuerySnapshot> get test {
    DocumentReference testList = Firestore.instance.document('ŚhopLists/EcHIwuuJsAc6bhHKop9z');

    return testList.collection('Items').snapshots();
  }

  List<ItemFS> _ItemsfromFStore(QuerySnapshot snap) {
    return snap.documents.map((doc) {
      return ItemFS(
        name:doc.data['title'] ?? '',
        favourite: doc.data['favourite'] ?? false,
        timeout: doc.data['timeout'] ?? 0
      );
    }).toList();
  }
}