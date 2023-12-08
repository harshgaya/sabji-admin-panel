import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import '../Models/delivery_boys.dart';
import '../global_method.dart';
import '../Models/user_attr.dart';

class OrderFull extends StatefulWidget {
  final String index;
  final String productTitle;
  final String address;
  final String orderId;
  final double price;
  final Timestamp orderDate;
  final double quantity;
  final String status;
  final String deliveryBoyId;
  final String userId;

  OrderFull({
    required this.index,
    required this.productTitle,
    required this.orderId,
    required this.price,
    required this.orderDate,
    required this.quantity,
    required this.status,
    required this.address,
    required this.deliveryBoyId,
    required this.userId,
  });

  @override
  _OrderFullState createState() => _OrderFullState();
}

List<String> lists = ['Out For Delivery', 'Delivered', 'Cancelled', 'Ordered'];

class _OrderFullState extends State<OrderFull> {
  Color getMyColor(String value) {
    if (value == 'Delivered') {
      return Colors.green;
    } else if (value == 'Cancelled') {
      return const Color(0xFFDA1414);
    } else if (value == 'Ordered') {
      return const Color(0xFF2E5AAC);
    } else if (value == 'Out For Delivery') {
      return Colors.deepPurpleAccent;
    }
    return Colors.green;
  }

  String status = lists[0];

  @override
  Widget build(BuildContext context) {
    GlobalMethod globalMethods = GlobalMethod();
    var mediaQuery = MediaQuery.of(context).size;
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
      final timestampDate = widget.orderDate.toDate();
      final now = DateTime.now();
      final today =
          DateTime(timestampDate.year, timestampDate.month, timestampDate.day);
      final todayTime = DateTime(now.year, now.month, now.day);
      final yesterdayTime = DateTime(now.year, now.month, now.day - 1);

      String formattedTime = DateFormat.jm().format(widget.orderDate.toDate());

      if (today == todayTime) {
        return 'today at ${formattedTime}';
      } else if (today == yesterdayTime) {
        return 'yesterday at ${formattedTime}';
      }

      var format = DateFormat('d-MMMM-y'); // <- use skeleton here
      return format.format(widget.orderDate.toDate());
    }

    return Consumer<List<DeliveryBoy>>(
        builder: (context, deliveryBoysList, child) {
      List<DeliveryBoy> verifiedDeliveryBoys = [];
      DeliveryBoy? deliveryBoy = DeliveryBoy();

      if (deliveryBoysList.isNotEmpty) {
        List<DeliveryBoy> deliveryBoys = deliveryBoysList
            .where((element) => element.isVerified == true)
            .toList();
        verifiedDeliveryBoys = deliveryBoys;
        if (widget.deliveryBoyId.isNotEmpty) {
          deliveryBoy = deliveryBoys.firstWhereOrNull(
              (element) => element.uid == widget!.deliveryBoyId);
        }
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
                  //  color: Colors.purple,
                  width: sizeToEachRow,
                  child: Text(
                    widget.index,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 10, fontWeight: FontWeight.w600),
                  ),
                ),
                // Container(
                //   // color: Colors.yellow,
                //   width: sizeToEachRow,
                //   child: Consumer<List<UserAttr>>(
                //       builder: (context, users, child) {
                //     UserAttr user = users
                //         .firstWhere((element) => element.id == widget.userId);
                //     return Text('${user.name} ${user.email}',
                //         textAlign: TextAlign.center,
                //         style: const TextStyle(
                //             fontSize: 10, fontWeight: FontWeight.w600));
                //   }),
                // ),
                Container(
                  // color: Colors.indigo,
                  width: sizeToEachRow,
                  child: Text(
                    widget.productTitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 10, fontWeight: FontWeight.w600),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const SelectableText(
                              'Address',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            content: SelectableText(
                              widget.address,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Ok'),
                              ),
                            ],
                          );
                        });
                  },
                  child: Container(
                      // color: Colors.blue,
                      width: sizeToEachRow,
                      child: Center(
                          child: Container(
                        child: Text(widget.address,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: const TextStyle(
                                fontSize: 10, fontWeight: FontWeight.w600)),
                      ))),
                ),
                Container(
                  // color: Colors.green,
                  width: sizeToEachRow,
                  child: Text(
                    widget.orderId,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 10, fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  // color: Colors.yellow,
                  width: sizeToEachRow,
                  child: Text(widget.price.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 10, fontWeight: FontWeight.w600)),
                ),
                Container(
                  // color: Colors.orange,
                  width: sizeToEachRow,
                  child: Text(formatTimestamp(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 10, fontWeight: FontWeight.w600)),
                ),
                Container(
                  // color: Colors.red,
                  width: sizeToEachRow,
                  child: Text('${widget.quantity}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 10, fontWeight: FontWeight.w600)),
                ),
                InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(builder: (context, setState) {
                            return Center(
                              child: Material(
                                child: Container(
                                  color: Colors.white,
                                  width: mediaQuery.width > 768
                                      ? 300
                                      : mediaQuery.width - 80,
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        const Text(
                                          'Set Delivery Status',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        RadioListTile<String>(
                                          contentPadding:
                                              const EdgeInsets.all(0),
                                          title: Text(lists[0]),
                                          value: lists[0],
                                          groupValue: widget.status,
                                          onChanged: (value) async {
                                            await globalMethods.showDialogg(
                                                'Are you sure?',
                                                'Delivery status will be out for delivery.',
                                                () async {
                                              try {
                                                await FirebaseFirestore.instance
                                                    .collection('order')
                                                    .doc(widget.orderId)
                                                    .update({
                                                  'status': value
                                                }).then((value) {
                                                  setState(() {
                                                    globalMethods.authSuccessHandle(
                                                        title: 'Success!',
                                                        subtitle:
                                                            'Order status changed to out for delivery.',
                                                        context: context);
                                                  });
                                                }).catchError((error) async {
                                                  await globalMethods
                                                      .authErrorHandle(
                                                          error.toString(),
                                                          context);
                                                });
                                              } catch (error) {}
                                            }, context);
                                          },
                                        ),
                                        RadioListTile<String>(
                                          contentPadding:
                                              const EdgeInsets.all(0),
                                          title: Text(lists[1]),
                                          value: lists[1],
                                          groupValue: widget.status,
                                          onChanged: (value) async {
                                            await globalMethods.showDialogg(
                                                'Are you sure?',
                                                'Delivery status will be Delivered.',
                                                () async {
                                              try {
                                                await FirebaseFirestore.instance
                                                    .collection('order')
                                                    .doc(widget.orderId)
                                                    .update({
                                                  'status': value
                                                }).then((value) {
                                                  setState(() {
                                                    globalMethods.authSuccessHandle(
                                                        title: 'Success!',
                                                        subtitle:
                                                            'Order status changed to delivered.',
                                                        context: context);
                                                  });
                                                }).catchError((error) async {
                                                  await globalMethods
                                                      .authErrorHandle(
                                                          error.toString(),
                                                          context);
                                                });
                                              } catch (e) {}
                                            }, context);
                                          },
                                        ),
                                        RadioListTile<String>(
                                          contentPadding:
                                              const EdgeInsets.all(0),
                                          title: Text(lists[2]),
                                          value: lists[2],
                                          groupValue: widget.status,
                                          onChanged: (value) async {
                                            await globalMethods.showDialogg(
                                                'Are you sure?',
                                                'Delivery status will be cancelled.',
                                                () async {
                                              try {
                                                await FirebaseFirestore.instance
                                                    .collection('order')
                                                    .doc(widget.orderId)
                                                    .update({
                                                  'status': value
                                                }).then((value) {
                                                  setState(() {
                                                    globalMethods.authSuccessHandle(
                                                        title: 'Success!',
                                                        subtitle:
                                                            'Order status changed to cancelled.',
                                                        context: context);
                                                  });
                                                }).catchError((error) async {
                                                  await globalMethods
                                                      .authErrorHandle(
                                                          error.toString(),
                                                          context);
                                                });
                                              } catch (error) {}
                                            }, context);
                                          },
                                        ),
                                        const Text(
                                          'Below order status will be changed when in case of mistake you made during changing status',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 3,
                                        ),
                                        RadioListTile<String>(
                                          contentPadding:
                                              const EdgeInsets.all(0),
                                          title: Text(lists[3]),
                                          value: lists[3],
                                          groupValue: widget.status,
                                          onChanged: (value) async {
                                            await globalMethods.showDialogg(
                                                'Are you sure?',
                                                'Delivery status will be ordered.',
                                                () async {
                                              try {
                                                await FirebaseFirestore.instance
                                                    .collection('order')
                                                    .doc(widget.orderId)
                                                    .update({
                                                  'status': value
                                                }).then((value) {
                                                  setState(() {
                                                    globalMethods.authSuccessHandle(
                                                        title: 'Success!',
                                                        subtitle:
                                                            'Order status changed to ordered',
                                                        context: context);
                                                  });
                                                }).catchError((error) async {
                                                  await globalMethods
                                                      .authErrorHandle(
                                                          error.toString(),
                                                          context);
                                                });
                                              } catch (error) {}
                                            }, context);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
                        });
                  },
                  child: Container(
                    width: sizeToEachRow,
                    decoration: BoxDecoration(
                      color: getMyColor(widget.status),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.status,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            backgroundColor: getMyColor(widget.status),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (verifiedDeliveryBoys.isEmpty) {
                      globalMethods.authErrorHandle(
                          'No Delivery Boys Found!', context);
                    } else {
                      if (widget.deliveryBoyId.isNotEmpty) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(
                                  builder: (context, setState) {
                                return Center(
                                  child: Material(
                                    child: Container(
                                      width: mediaQuery.width > 768
                                          ? 300
                                          : mediaQuery.width - 80,
                                      color: Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            const Text(
                                              'Delivery Boy is already added, if you want to change select from below.',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  2,
                                              child: ListView.builder(
                                                  itemCount:
                                                      verifiedDeliveryBoys
                                                          .length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 5),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors.black,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        child: ListTile(
                                                          leading: const Icon(
                                                            Icons
                                                                .delivery_dining,
                                                            color: Colors.white,
                                                          ),
                                                          title: Text(
                                                            verifiedDeliveryBoys[
                                                                    index]
                                                                .name!,
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                          ),
                                                          subtitle: Text(
                                                            '${verifiedDeliveryBoys[index].mobile!}  ${verifiedDeliveryBoys[index].address!}',
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                          ),
                                                          isThreeLine: true,
                                                          onTap: () {
                                                            globalMethods.showDialogg(
                                                                'Add Delivery Boy !',
                                                                'add delivery boy ${verifiedDeliveryBoys[index].name!} (${verifiedDeliveryBoys[index].mobile!})  to the product ${widget.productTitle}',
                                                                () {
                                                              try {
                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'order')
                                                                    .doc(widget
                                                                        .orderId)
                                                                    .update({
                                                                  'deliveryBoy':
                                                                      verifiedDeliveryBoys[
                                                                              index]
                                                                          .uid!
                                                                }).then(
                                                                        (value) {
                                                                  globalMethods.authSuccessHandle(
                                                                      title:
                                                                          'Added Successfully!',
                                                                      subtitle:
                                                                          'Deivery Boy ${verifiedDeliveryBoys[index].name!} (${verifiedDeliveryBoys[index].mobile!}) added to product ${widget.productTitle}',
                                                                      context:
                                                                          context);
                                                                }).catchError(
                                                                        (error) {
                                                                  globalMethods
                                                                      .authErrorHandle(
                                                                          'Unable to add delivery boy',
                                                                          context);
                                                                });
                                                              } catch (error) {}
                                                            }, context);
                                                          },
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              });
                            });
                      } else {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(
                                  builder: (context, setState) {
                                return Center(
                                  child: Material(
                                    child: Container(
                                      width: mediaQuery.width > 768
                                          ? 300
                                          : mediaQuery.width - 80,
                                      color: Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            const Text(
                                              'Select Delivery Boy From List',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  2,
                                              child: ListView.builder(
                                                  itemCount:
                                                      verifiedDeliveryBoys
                                                          .length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 5),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors.black,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        child: ListTile(
                                                          leading: const Icon(
                                                            Icons
                                                                .delivery_dining,
                                                            color: Colors.white,
                                                          ),
                                                          title: Text(
                                                            verifiedDeliveryBoys[
                                                                    index]
                                                                .name!,
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                          ),
                                                          subtitle: Text(
                                                            '${verifiedDeliveryBoys[index].mobile!}  ${verifiedDeliveryBoys[index].address!}',
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                          ),
                                                          isThreeLine: true,
                                                          onTap: () {
                                                            globalMethods.showDialogg(
                                                                'Add Delivery Boy !',
                                                                'add delivery boy ${verifiedDeliveryBoys[index].name!} (${verifiedDeliveryBoys[index].mobile!})  to the product ${widget.productTitle}',
                                                                () {
                                                              try {
                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'order')
                                                                    .doc(widget
                                                                        .orderId)
                                                                    .update({
                                                                  'deliveryBoy':
                                                                      verifiedDeliveryBoys[
                                                                              index]
                                                                          .uid!
                                                                }).then(
                                                                        (value) {
                                                                  globalMethods.authSuccessHandle(
                                                                      title:
                                                                          'Added Successfully!',
                                                                      subtitle:
                                                                          'Deivery Boy ${verifiedDeliveryBoys[index].name!} (${verifiedDeliveryBoys[index].mobile!}) added to product ${widget.productTitle}',
                                                                      context:
                                                                          context);
                                                                }).catchError(
                                                                        (error) {
                                                                  globalMethods
                                                                      .authErrorHandle(
                                                                          'Unable to add delivery boy',
                                                                          context);
                                                                });
                                                              } catch (error) {}
                                                            }, context);
                                                          },
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              });
                            });
                      }
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: widget.deliveryBoyId.isEmpty
                          ? Colors.red
                          : Colors.black,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    width: sizeToEachRow,
                    child: widget.deliveryBoyId.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Add Delivery Boy',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '${deliveryBoy!.name} (${deliveryBoy.mobile})',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
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
    });
  }
}
