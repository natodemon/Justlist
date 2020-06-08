
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_list_vs/utils/database_fs.dart';

class ItemFS {

  final String docId;
  String name;
  int timeout;
  bool favourite;
  bool selected;
  int id; // Temp var for compatibility

  ItemFS({this.docId, this.name, this.favourite, this.timeout, this.selected});

  factory ItemFS.fromFirestore(DocumentSnapshot doc) {
    Map contents = doc.data;

    return ItemFS(
      docId: doc.documentID,
      name: contents['name'] ?? 'NA',
      timeout: contents['timeout'] ?? 0,
      favourite: contents['favourite'] ?? false,
      selected: contents['selected'] ?? false,
    );
  }

  toggleSelected(String listId) {
    FSDatabase().modifyItem(listId, this.docId, {'selected': !this.selected});
  }

  Map<String, dynamic> toFirestore() {
    var map = Map<String, dynamic>();

    map['name'] = this.name;
    map['timeout'] = this.timeout ?? 0;
    map['favourite'] = this.favourite ?? false;
    map['selected'] = this.selected ?? false;

    return map;
  }

}