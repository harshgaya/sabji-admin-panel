import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  String? name;
  String? url;
  String? id;
  String? backgroundColor;
  Timestamp? createdAt;

  Category(
      {this.name, this.url, this.id, this.backgroundColor, this.createdAt});

  Stream<List<Category>> get category {
    return FirebaseFirestore.instance
        .collection('Category')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((QuerySnapshot querySnapshot) => querySnapshot.docs
            .map(
              (DocumentSnapshot documentSnapshot) => Category(
                name: documentSnapshot.get('name'),
                url: documentSnapshot.get('image'),
                id: documentSnapshot.get('id'),
                backgroundColor: documentSnapshot.get('backgroundColor'),
                createdAt: documentSnapshot.get('createdAt'),
              ),
            )
            .toList());
  }
}
