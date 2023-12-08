import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ProductAttr {
  final String? id;
  final String? title;
  final String? description;
  final String? price;
  final String? cuttedPrice;
  final String? imageUrl;
  final String? productCategoryName;
  final String? unitAmount;
  final bool? isPopular;
  final String? percentOff;
  final bool? inStock;

  ProductAttr({
    this.id,
    this.title,
    this.description,
    this.price,
    this.cuttedPrice,
    this.imageUrl,
    this.productCategoryName,
    this.unitAmount,
    this.isPopular,
    this.percentOff,
    this.inStock,
  });
  Stream<List<ProductAttr>> get products {
    return FirebaseFirestore.instance
        .collection('products')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((QuerySnapshot querySnapshot) => querySnapshot.docs
            .map((DocumentSnapshot documentSnapshot) => ProductAttr(
                  id: documentSnapshot.get('productId'),
                  title: documentSnapshot.get('productTitle'),
                  description: documentSnapshot.get('productDescription'),
                  price: documentSnapshot.get('price'),
                  cuttedPrice: documentSnapshot.get('cuttedPrice'),
                  imageUrl: documentSnapshot.get('productImage'),
                  productCategoryName: documentSnapshot.get('productCategory'),
                  unitAmount: documentSnapshot.get('unitAmount'),
                  isPopular: documentSnapshot.get('isPopular'),
                  percentOff: documentSnapshot.get('percentOff'),
                  inStock: documentSnapshot.get('inStock'),
                ))
            .toList());
  }
}
