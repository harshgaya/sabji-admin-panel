import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class OrdersAttr {
  final String? orderId;
  final String? productTitle;
  final String? address;
  final String? status;
  final String? userId;
  final String? productId;
  final double? price;
  final String? imageUrl;
  final double? quantity;
  final Timestamp? orderDate;
  final String? phone;
  final String? deliveryBoy;

  OrdersAttr(
      {this.productTitle,
      this.address,
      this.status,
      this.orderId,
      this.userId,
      this.productId,
      this.price,
      this.imageUrl,
      this.quantity,
      this.orderDate,
      this.phone,
      this.deliveryBoy});

  Stream<List<OrdersAttr>> get orders {
    return FirebaseFirestore.instance
        .collection('order')
        .orderBy('orderDate', descending: true)
        .snapshots()
        .map((QuerySnapshot querySnapshot) => querySnapshot.docs
            .map((DocumentSnapshot documentSnapshot) => OrdersAttr(
                productTitle: documentSnapshot.get('productTitle'),
                address: documentSnapshot.get('address'),
                status: documentSnapshot.get('status'),
                orderId: documentSnapshot.get('orderId'),
                userId: documentSnapshot.get('userId'),
                productId: documentSnapshot.get('productId'),
                price: documentSnapshot.get('price'),
                imageUrl: documentSnapshot.get('imageUrl'),
                quantity: documentSnapshot.get('quantity'),
                orderDate: documentSnapshot.get('orderDate'),
                phone: documentSnapshot.get('Phone'),
                deliveryBoy: documentSnapshot.get('deliveryBoy')))
            .toList());
  }
}
