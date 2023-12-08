import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../global_method.dart';

class UserFull extends StatefulWidget {
  final String index;
  final String id;
  final String name;
  final String email;
  final Timestamp joinedDate;
  final String phoneNumber;
  final String status;

  UserFull(
      {required this.index,
      required this.id,
      required this.name,
      required this.email,
      required this.joinedDate,
      required this.phoneNumber,
      required this.status});

  @override
  _UserFullState createState() => _UserFullState();
}

class _UserFullState extends State<UserFull> {
  @override
  Widget build(BuildContext context) {
    GlobalMethod globalMethods = GlobalMethod();

    var mediaQueryWidth = MediaQuery.of(context).size.width;
    var size;

    if (mediaQueryWidth < 768) {
      size = 1200;
    } else {
      size = mediaQueryWidth - 200;
    }
    // var size = MediaQuery.of(context).size.width - 200;
    var sizeToEachRow = size / 7;

    String formatTimestamp() {
      final timestampDate = widget.joinedDate.toDate();
      final now = DateTime.now();
      final today =
          DateTime(timestampDate.year, timestampDate.month, timestampDate.day);
      final todayTime = DateTime(now.year, now.month, now.day);
      final yesterdayTime = DateTime(now.year, now.month, now.day - 1);

      String formattedTime = DateFormat.jm().format(widget.joinedDate.toDate());

      if (today == todayTime) {
        return 'today at ${formattedTime}';
      } else if (today == yesterdayTime) {
        return 'yesterday at ${formattedTime}';
      }

      var format = DateFormat('d-MMMM-y'); // <- use skeleton here
      return format.format(widget.joinedDate.toDate());
    }

    return Container(
      height: 70,
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  width: sizeToEachRow,
                  child: Text(
                    widget.index,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 10, fontWeight: FontWeight.w600),
                  )),
              Container(
                  width: sizeToEachRow,
                  child: Text(
                    widget.id,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 10, fontWeight: FontWeight.w600),
                  )),
              Container(
                  width: sizeToEachRow,
                  child: Text(widget.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 10, fontWeight: FontWeight.w600))),
              Container(
                  width: sizeToEachRow,
                  child: Text(widget.phoneNumber,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 10, fontWeight: FontWeight.w600))),
              Container(
                  width: sizeToEachRow,
                  child: Text(widget.email,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 10, fontWeight: FontWeight.w600))),
              Container(
                  width: sizeToEachRow,
                  child: Text('${formatTimestamp()}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 10, fontWeight: FontWeight.w600))),
              InkWell(
                onTap: () {
                  if (widget.status == 'Unblocked') {
                    globalMethods.showDialogg('Block this user?',
                        'User will be blocked and he will no longer can buy product',
                        () {
                      try {
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(widget.id)
                            .update({'status': 'Blocked'}).then((value) {
                          globalMethods.authSuccessHandle(
                              title: 'Success!',
                              subtitle: 'User Blocked successfully.',
                              context: context);
                        }).catchError((error) {
                          globalMethods.authErrorHandle(
                              'Unable to block this user.', context);
                        });
                      } catch (e) {}
                    }, context);
                  } else {
                    globalMethods.showDialogg('Unblock this user?',
                        'User will be Unblocked and he will buy product', () {
                      try {
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(widget.id)
                            .update({'status': 'Unblocked'}).then((value) {
                          globalMethods.authSuccessHandle(
                              title: 'Success!',
                              subtitle: 'User Unblocked successfully.',
                              context: context);
                        }).catchError((error) {
                          globalMethods.authErrorHandle(
                              'Unable to Unblock this user.', context);
                        });
                      } catch (e) {}
                    }, context);
                  }
                },
                child: Container(
                    width: sizeToEachRow,
                    child: widget.status == 'Unblocked'
                        ? const Text('active',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.green))
                        : const Text('Blocked',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.red))),
              ),
            ],
          ),
          SizedBox(
            child: Divider(
              thickness: 1,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
