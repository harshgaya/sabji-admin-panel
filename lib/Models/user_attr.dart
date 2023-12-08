import 'package:cloud_firestore/cloud_firestore.dart';

class UserAttr {
  String? id;
  String? mobileNumber;
  String? name;
  String? email;
  Timestamp? joinedDate;
  String? status;

  UserAttr(
      {this.id,
      this.mobileNumber,
      this.name,
      this.email,
      this.joinedDate,
      this.status});
  Stream<List<UserAttr>> get users {
    return FirebaseFirestore.instance
        .collection('users')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((QuerySnapshot querySnapshot) => querySnapshot.docs
            .map((DocumentSnapshot documentSnapshot) => UserAttr(
                  id: documentSnapshot.get('id'),
                  mobileNumber: '',
                  name: documentSnapshot.get('name'),
                  email: documentSnapshot.get('email'),
                  joinedDate: documentSnapshot.get('createdAt'),
                  status: documentSnapshot.get('status'),
                ))
            .toList());
  }
}
