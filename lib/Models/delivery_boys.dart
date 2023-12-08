import 'package:cloud_firestore/cloud_firestore.dart';

class DeliveryBoy {
  String? name;
  String? mobile;
  String? uid;
  String? address;
  bool? isVerified;
  String? email;
  Timestamp? appliedTime;

  DeliveryBoy({
    this.name,
    this.mobile,
    this.uid,
    this.address,
    this.isVerified,
    this.email,
    this.appliedTime,
  });
  Stream<List<DeliveryBoy>> get deliveryBoys {
    return FirebaseFirestore.instance
        .collection('DeliveryBoys')
        .orderBy('appliedTime', descending: true)
        .snapshots()
        .map((QuerySnapshot querySnapshot) => querySnapshot.docs
            .map((DocumentSnapshot documentSnapshot) => DeliveryBoy(
                  name: documentSnapshot.get('name'),
                  mobile: documentSnapshot.get('phone'),
                  uid: documentSnapshot.get('uid'),
                  address: documentSnapshot.get('address'),
                  isVerified: documentSnapshot.get('isVerified'),
                  email: documentSnapshot.get('email'),
                  appliedTime: documentSnapshot.get('appliedTime'),
                ))
            .toList());
  }
}
