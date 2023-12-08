import 'package:flutter/material.dart';

class CartAttr {
   String id;
   String productId;
   String userId;
   String title;
   int quantity;
   double price;
   String imageUrl;
   double cuttedPrice;
   String unitAmount;
   String percentOff;

   CartAttr({required this.id,required this.productId,required this.userId,required this.title,required this.quantity,required this.price,
      required this.imageUrl,required this.cuttedPrice,required this.unitAmount,required this.percentOff});
}