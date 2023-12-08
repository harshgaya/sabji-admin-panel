import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../global_method.dart';

class DeliveryBoyWidget extends StatefulWidget {
  final String name;
  final String mobile;
  final String uid;
  final String address;
  final Timestamp appliedTime;
  final bool isVerified;
  final String email;
  final String index;

  DeliveryBoyWidget(
      {required this.name,
      required this.mobile,
      required this.uid,
      required this.address,
      required this.appliedTime,
      required this.isVerified,
      required this.email,
      required this.index});

  @override
  State<DeliveryBoyWidget> createState() => _DeliveryBoyWidgetState();
}

class _DeliveryBoyWidgetState extends State<DeliveryBoyWidget> {
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
    var sizeToEachRow = size / 9;

    String formatTimestamp() {
      final timestampDate = widget.appliedTime.toDate();
      final now = DateTime.now();
      final today =
          DateTime(timestampDate.year, timestampDate.month, timestampDate.day);
      final todayTime = DateTime(now.year, now.month, now.day);
      final yesterdayTime = DateTime(now.year, now.month, now.day - 1);

      String formattedTime =
          DateFormat.jm().format(widget.appliedTime.toDate());

      if (today == todayTime) {
        return 'today at ${formattedTime}';
      } else if (today == yesterdayTime) {
        return 'yesterday at ${formattedTime}';
      }

      var format = DateFormat('d-MMMM-y'); // <- use skeleton here
      return format.format(widget.appliedTime.toDate());
    }

    return Container(
      color: Colors.white,
      height: 70,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                //   color: Colors.purple,
                width: sizeToEachRow,
                child: Text(
                  widget.index,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 10, fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                //  color: Colors.indigo,
                width: sizeToEachRow,
                child: Text(
                  widget.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 10, fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                //   color: Colors.blue,
                width: sizeToEachRow,
                child: Text(
                  widget.mobile,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 10, fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                //  color: Colors.green,
                width: sizeToEachRow,
                child: Text(
                  widget.address,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 10, fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                // color: Colors.yellow,
                width: sizeToEachRow,
                child: Text(
                  widget.email,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 10, fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                //  color: Colors.orange,
                width: sizeToEachRow,
                child: Text(
                  widget.uid,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 10, fontWeight: FontWeight.w600),
                ),
              ),
              InkWell(
                onTap: () {
                  if (widget.isVerified) {
                    globalMethods.showDialogg('Unverify?',
                        'Are you sure, delivery boy ${widget.name} (${widget.mobile}) will be unverified.',
                        () async {
                      try {
                        await FirebaseFirestore.instance
                            .collection('DeliveryBoys')
                            .doc(widget.uid)
                            .update({'isVerified': false}).then((value) {
                          globalMethods.authSuccessHandle(
                              title: 'Success !',
                              subtitle:
                                  'Delivery Boy ${widget.name} (${widget.mobile}) unverified successfully.',
                              context: context);
                        }).catchError((error) {
                          globalMethods.authErrorHandle(
                              error.toString(), context);
                        });
                      } catch (e) {}
                    }, context);
                  } else {
                    globalMethods.showDialogg('Verify?',
                        'Are you sure, delivery boy ${widget.name} (${widget.mobile}) will be verified.',
                        () async {
                      try {
                        await FirebaseFirestore.instance
                            .collection('DeliveryBoys')
                            .doc(widget.uid)
                            .update({'isVerified': true}).then((value) {
                          globalMethods.authSuccessHandle(
                              title: 'Success !',
                              subtitle:
                                  'Delivery Boy ${widget.name} (${widget.mobile}) verified successfully.',
                              context: context);
                        }).catchError((error) {
                          globalMethods.authErrorHandle(
                              error.toString(), context);
                        });
                      } catch (e) {}
                    }, context);
                  }
                },
                child: Container(
                  // color: Colors.red,
                  width: sizeToEachRow,
                  child: widget.isVerified
                      ? const Text(
                          'Verified',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 10,
                              fontWeight: FontWeight.w600),
                        )
                      : const Text(
                          'Not Verified',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 10,
                              fontWeight: FontWeight.w600),
                        ),
                ),
              ),
              Container(
                //   color: Colors.black,
                width: sizeToEachRow,
                child: Text(
                  formatTimestamp(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 10, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(
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
