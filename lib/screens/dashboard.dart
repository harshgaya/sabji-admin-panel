import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../Models/orders_attr.dart';
import '../order/order_full.dart';
import '../responsive_helper.dart';
import 'package:flutterfire_ui/firestore.dart';

class Dashboard extends StatefulWidget {
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late TextEditingController _searchTextController;
  var totalDelivered = 0;
  var totalOrders = 0;
  var totalCancelled = 0;
  var totalOutForDelivery = 0;
  double totalEarnings = 0;
  bool isFirstTime = true;
  List<OrdersAttr> ls = [];

  Stream<List<OrdersAttr>> getCancelledOrders() {
    return FirebaseFirestore.instance
        .collection('order')
        .orderBy('orderDate', descending: true)
        .where('status', isEqualTo: 'Cancelled')
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

  Stream<List<OrdersAttr>> getOutForDelivery() {
    return FirebaseFirestore.instance
        .collection('order')
        .orderBy('orderDate', descending: true)
        .where('status', isEqualTo: 'Out For Delivery')
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

  Stream<List<OrdersAttr>> getOrders() {
    return FirebaseFirestore.instance
        .collection('order')
        .orderBy('orderDate', descending: true)
        .where('status', isEqualTo: 'Ordered')
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

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? lastDocument;

  getTotalEarning() async {
    final collectionRef = _firestore.collection('TotalEarning');
    totalDelivered = await collectionRef
        .get()
        .then((value) => value.docs[0].get('totalDelivered'));

    lastDocument =
        await collectionRef.get().then((value) => value.docs[0].get('lastDoc'));
    totalEarnings = await collectionRef
        .get()
        .then((value) => value.docs[0].get('totalEarning'));

    // print('last doc ${lastDocument!.get('lastDoc')}');
    // print('total earning ${lastDocument!.get('totalEarning')}');

    final collectionReference = _firestore
        .collection('order')
        .where('status', isEqualTo: 'Delivered')
        .orderBy('orderDate', descending: false);

    late QuerySnapshot<Map<String, dynamic>> querySnapshot;
    if (lastDocument == '') {
      querySnapshot = await collectionReference.get();
      List<OrdersAttr> orders = querySnapshot.docs
          .map((documentSnapshot) => OrdersAttr(
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
          .toList();

      orders.forEach((element) {
        totalEarnings += element.price!;
      });
      int totalDeliveredOrders = totalDelivered + orders.length;
      await _firestore
          .collection('TotalEarning')
          .doc('m45TFgTZCLwiHPjfka1f')
          .update({
        'totalEarning': totalEarnings,
        'totalDelivered': totalDeliveredOrders
      });
    } else {
      final coll = FirebaseFirestore.instance.collection('order');

      final doc = await coll.doc(lastDocument).get();

      querySnapshot = await collectionReference.startAfterDocument(doc).get();

      if (querySnapshot.docs.isNotEmpty) {
        List<OrdersAttr> orders = querySnapshot.docs
            .map((documentSnapshot) => OrdersAttr(
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
            .toList();

        orders.forEach((element) {
          totalEarnings += element.price!;
        });
        int totalDel = totalDelivered + orders.length;
        await _firestore
            .collection('TotalEarning')
            .doc('m45TFgTZCLwiHPjfka1f')
            .update(
                {'totalEarning': totalEarnings, 'totalDelivered': totalDel});
      }
    }
    lastDocument = querySnapshot.docs.last.id;
    await _firestore
        .collection('TotalEarning')
        .doc('m45TFgTZCLwiHPjfka1f')
        .update({'lastDoc': lastDocument});
  }

  @override
  void initState() {
    super.initState();
    _searchTextController = TextEditingController();
    _searchTextController.addListener(() {
      setState(() {});
    });
    getCancelledOrders().listen((event) {
      print(event.length);

      if (mounted) {
        setState(() {
          totalCancelled = event.length;
        });
      }
    });
    getOutForDelivery().listen((event) {
      if (mounted) {
        setState(() {
          totalOutForDelivery = event.length;
        });
      }
    });
    getOrders().listen((event) {
      if (mounted) {
        setState(() {
          totalOrders = event.length;
        });
      }
    });
    if (isFirstTime) {
      print('only first time');
      getTotalEarning();
      isFirstTime = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _searchTextController.dispose();
  }

  List<OrdersAttr> queryOrderList = [];

  @override
  Widget build(BuildContext context) {
    var mediaQueryWidth = MediaQuery.of(context).size.width;
    var size;

    if (mediaQueryWidth < 768) {
      size = 1200;
    } else {
      size = mediaQueryWidth - 200;
    }
    // var size = MediaQuery.of(context).size.width - 200;
    var sizeToEachRow = size / 9;

    // return Consumer<List<OrdersAttr>>(builder: (context, ordersList, child) {
    var ordersList = [];
    var deliveredList = [];
    // ordersList.where((element) => element.status == 'Delivered').toList();
    var cancelledList = [];
    // ordersList.where((element) => element.status == 'Cancelled').toList();
    var orderList = [];
    //  ordersList.where((element) => element.status == 'Ordered').toList();
    var outForDeliveryList = [];
    // .where((element) => element.status == 'Out For Delivery')
    // .toList();
    double totalEarning = 0;
    deliveredList.forEach((element) {
      totalEarning = totalEarning + element.price!.toDouble();
    });

    return ResponsiveDesign(
        desktop: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                    child: ListCard(
                  title: 'Orders',
                  subTitle: '${totalOrders}',
                  icon: FontAwesomeIcons.shoppingCart,
                  color: const Color(0xFF2E5AAC),
                )),
                Expanded(
                    child: ListCard(
                  title: 'Out For Delivery',
                  subTitle: '${totalOutForDelivery}',
                  icon: Icons.delivery_dining,
                  color: Colors.deepPurpleAccent,
                )),
                Expanded(
                  child: ListCard(
                      title: 'Delivered Orders ${totalDelivered}',
                      subTitle: 'Total Earning: $totalEarnings INR',
                      icon: Icons.done,
                      color: Colors.green),
                ),
                Expanded(
                    child: ListCard(
                  title: 'Cancelled Orders',
                  subTitle: '${totalCancelled}',
                  icon: Icons.error,
                  color: const Color(0xFFDA1414),
                )),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 400,
              child: TextField(
                controller: _searchTextController,
                minLines: 1,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                  ),
                  hintText: 'Search by id, address, title',
                  hintStyle: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  suffixIcon: IconButton(
                    onPressed: _searchTextController.text.isEmpty
                        ? null
                        : () {
                            _searchTextController.clear();
                          },
                    icon: Icon(Icons.close,
                        color: _searchTextController.text.isNotEmpty
                            ? Colors.red
                            : Colors.grey),
                  ),
                ),
                onChanged: (value) {
                  _searchTextController.text.toLowerCase();
                  setState(() {
                    // queryOrderList = ordersList
                    //     .where((element) =>
                    //         element.orderId.toString().toLowerCase().contains(
                    //             _searchTextController.text.toLowerCase()) ||
                    //         element.productTitle!.toLowerCase().contains(
                    //             _searchTextController.text.toLowerCase()) ||
                    //         element.address!.toLowerCase().contains(
                    //             _searchTextController.text.toLowerCase()))
                    //     .toList();
                  });
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 40,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Recent Orders',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Container(
              height: 40,
              color: Colors.pink.shade100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      //  color: Colors.purple,
                      width: sizeToEachRow,
                      child: const Text(
                        'Index',
                        textAlign: TextAlign.center,
                      )),
                  // Container(
                  //     //  color: Colors.indigo,
                  //     width: sizeToEachRow,
                  //     child: const Text(
                  //       'User',
                  //       textAlign: TextAlign.center,
                  //     )),
                  Container(
                      //  color: Colors.indigo,
                      width: sizeToEachRow,
                      child: const Text(
                        'Product Title',
                        textAlign: TextAlign.center,
                      )),
                  Container(
                      width: sizeToEachRow,
                      child: const Text(
                        'Address',
                        textAlign: TextAlign.center,
                      )),
                  Container(
                      // color: Colors.blue,
                      width: sizeToEachRow,
                      child: const Text(
                        'Order Id',
                        textAlign: TextAlign.center,
                      )),
                  Container(
                      // color: Colors.green,
                      width: sizeToEachRow,
                      child: const Text(
                        'Total Amount',
                        textAlign: TextAlign.center,
                      )),
                  Container(
                      //  color: Colors.yellow,
                      width: sizeToEachRow,
                      child: const Text(
                        'Order Date',
                        textAlign: TextAlign.center,
                      )),
                  Container(
                      //   color: Colors.orange,
                      width: sizeToEachRow,
                      child: const Text(
                        'Quantity',
                        textAlign: TextAlign.center,
                      )),
                  Container(
                      //  color: Colors.red,
                      width: sizeToEachRow,
                      child: const Text(
                        'Status',
                        textAlign: TextAlign.center,
                      )),
                  Container(
                      //  color: Colors.grey,
                      width: sizeToEachRow,
                      child: const Text(
                        'Delivery Boy',
                        textAlign: TextAlign.center,
                      )),
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Expanded(
              child: FirestoreQueryBuilder(
                  query: FirebaseFirestore.instance
                      .collection('order')
                      .orderBy('orderDate', descending: true),
                  builder: (BuildContext context,
                      FirestoreQueryBuilderSnapshot<dynamic> snapshot,
                      Widget? child) {
                    if (snapshot.isFetching) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text('Error Occurred'),
                      );
                    }

                    return Column(
                      children: [
                        Expanded(
                            child: ListView.builder(
                                itemCount: snapshot.docs.length,
                                itemBuilder: (context, index) {
                                  if (snapshot.hasMore &&
                                      index + 1 == snapshot.docs.length) {
                                    // Tell FirestoreQueryBuilder to try to obtain more items.
                                    // It is safe to call this function from within the build method.
                                    snapshot.fetchMore();
                                  }

                                  var data = snapshot.docs[index];

                                  return OrderFull(
                                    index: (index + 1).toString(),
                                    productTitle: data['productTitle'],
                                    orderId: data['orderId'],
                                    price: data['price'],
                                    orderDate: data['orderDate'],
                                    quantity: data['quantity'],
                                    status: data['status'],
                                    address: data['address'],
                                    deliveryBoyId: data['deliveryBoy'],
                                    userId: data['userId'],
                                  );
                                })),
                        snapshot.isFetchingMore
                            ? const CircularProgressIndicator()
                            : Container()
                      ],
                    );
                  }),
            ),
          ],
        ),
        mobile: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            Container(
              width: 1200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: ListCard(
                        title: 'Orderss',
                        subTitle: '${orderList.length}',
                        icon: FontAwesomeIcons.shoppingCart,
                        color: const Color(0xFF2E5AAC),
                      )),
                      Expanded(
                          child: ListCard(
                        title: 'Out For Delivery',
                        subTitle: '${outForDeliveryList.length}',
                        icon: Icons.delivery_dining,
                        color: Colors.deepPurpleAccent,
                      )),
                      Expanded(
                        child: ListCard(
                            title: 'Delivered Orders ${deliveredList.length}',
                            subTitle: 'Total Earning: $totalEarning INR',
                            icon: Icons.done,
                            color: Colors.green),
                      ),
                      Expanded(
                          child: ListCard(
                        title: 'Cancelled Orders',
                        subTitle: '${cancelledList.length}',
                        icon: Icons.error,
                        color: const Color(0xFFDA1414),
                      )),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: _searchTextController,
                      minLines: 1,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                        ),
                        hintText: 'Search by id, address, title',
                        hintStyle: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                        filled: true,
                        fillColor: Theme.of(context).cardColor,
                        suffixIcon: IconButton(
                          onPressed: _searchTextController.text.isEmpty
                              ? null
                              : () {
                                  _searchTextController.clear();
                                },
                          icon: Icon(Icons.close,
                              color: _searchTextController.text.isNotEmpty
                                  ? Colors.red
                                  : Colors.grey),
                        ),
                      ),
                      onChanged: (value) {
                        _searchTextController.text.toLowerCase();
                        setState(() {
                          // queryOrderList = ordersList
                          //     .where((element) =>
                          //         element.orderId
                          //             .toString()
                          //             .toLowerCase()
                          //             .contains(_searchTextController.text
                          //                 .toLowerCase()) ||
                          //         element.productTitle!
                          //             .toLowerCase()
                          //             .contains(_searchTextController.text
                          //                 .toLowerCase()) ||
                          //         element.address!.toLowerCase().contains(
                          //             _searchTextController.text
                          //                 .toLowerCase()))
                          //     .toList();
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 40,
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Recent Orders',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 40,
                    color: Colors.pink.shade100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            //  color: Colors.purple,
                            width: sizeToEachRow,
                            child: const Text(
                              'Index',
                              textAlign: TextAlign.center,
                            )),
                        // Container(
                        //     //  color: Colors.indigo,
                        //     width: sizeToEachRow,
                        //     child: const Text(
                        //       'User',
                        //       textAlign: TextAlign.center,
                        //     )),
                        Container(
                            // color: Colors.indigo,
                            width: sizeToEachRow,
                            child: const Text(
                              'Product Title',
                              textAlign: TextAlign.center,
                            )),
                        Container(
                            width: sizeToEachRow,
                            child: const Text(
                              'Address',
                              textAlign: TextAlign.center,
                            )),
                        Container(
                            // color: Colors.blue,
                            width: sizeToEachRow,
                            child: const Text(
                              'Order Id',
                              textAlign: TextAlign.center,
                            )),
                        Container(
                            // color: Colors.green,
                            width: sizeToEachRow,
                            child: const Text(
                              'Total Amount',
                              textAlign: TextAlign.center,
                            )),
                        Container(
                            //  color: Colors.yellow,
                            width: sizeToEachRow,
                            child: const Text(
                              'Order Date',
                              textAlign: TextAlign.center,
                            )),
                        Container(
                            //   color: Colors.orange,
                            width: sizeToEachRow,
                            child: const Text(
                              'Quantity',
                              textAlign: TextAlign.center,
                            )),
                        Container(
                            //  color: Colors.red,
                            width: sizeToEachRow,
                            child: const Text(
                              'Status',
                              textAlign: TextAlign.center,
                            )),
                        Container(
                            //  color: Colors.grey,
                            width: sizeToEachRow,
                            child: const Text(
                              'Delivery Boy',
                              textAlign: TextAlign.center,
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    child: _searchTextController.text.isEmpty
                        ? ListView.builder(
                            itemCount: ordersList.length,
                            itemBuilder: (context, index) {
                              return OrderFull(
                                index: (index + 1).toString(),
                                productTitle: ordersList[index].productTitle!,
                                orderId: ordersList[index].orderId!,
                                price: ordersList[index].price!,
                                orderDate: ordersList[index].orderDate!,
                                quantity: ordersList[index].quantity!,
                                status: ordersList[index].status!,
                                address: ordersList[index].address!,
                                deliveryBoyId: ordersList[index].deliveryBoy!,
                                userId: ordersList[index].userId!,
                              );
                            })
                        : ListView.builder(
                            itemCount: queryOrderList.length,
                            itemBuilder: (context, index) {
                              return OrderFull(
                                index: (index + 1).toString(),
                                productTitle:
                                    queryOrderList[index].productTitle!,
                                orderId: queryOrderList[index].orderId!,
                                price: queryOrderList[index].price!,
                                orderDate: queryOrderList[index].orderDate!,
                                quantity: queryOrderList[index].quantity!,
                                status: queryOrderList[index].status!,
                                address: queryOrderList[index].address!,
                                deliveryBoyId:
                                    queryOrderList[index].deliveryBoy!,
                                userId: ordersList[index].userId!,
                              );
                            }),
                  ),
                ],
              ),
            )
          ],
        ));

    ///    return Consumer<List<OrdersAttr>>(builder: (context, ordersList, child) {
    //       var deliveredList =
    //           ordersList.where((element) => element.status == 'Delivered').toList();
    //       var cancelledList =
    //           ordersList.where((element) => element.status == 'Cancelled').toList();
    //       var orderList =
    //           ordersList.where((element) => element.status == 'Ordered').toList();
    //       var outForDeliveryList = ordersList
    //           .where((element) => element.status == 'Out For Delivery')
    //           .toList();
    //       double totalEarning = 0;
    //       deliveredList.forEach((element) {
    //         totalEarning = totalEarning + element.price!.toDouble();
    //       });
    //       return ResponsiveDesign(
    //           desktop: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               const SizedBox(
    //                 height: 10,
    //               ),
    //               Row(
    //                 children: [
    //                   Expanded(
    //                       child: ListCard(
    //                     title: 'Orders',
    //                     subTitle: '${orderList.length}',
    //                     icon: FontAwesomeIcons.shoppingCart,
    //                     color: const Color(0xFF2E5AAC),
    //                   )),
    //                   Expanded(
    //                       child: ListCard(
    //                     title: 'Out For Delivery',
    //                     subTitle: '${outForDeliveryList.length}',
    //                     icon: Icons.delivery_dining,
    //                     color: Colors.deepPurpleAccent,
    //                   )),
    //                   Expanded(
    //                     child: ListCard(
    //                         title: 'Delivered Orders ${deliveredList.length}',
    //                         subTitle: 'Total Earning: $totalEarning INR',
    //                         icon: Icons.done,
    //                         color: Colors.green),
    //                   ),
    //                   Expanded(
    //                       child: ListCard(
    //                     title: 'Cancelled Orders',
    //                     subTitle: '${cancelledList.length}',
    //                     icon: Icons.error,
    //                     color: const Color(0xFFDA1414),
    //                   )),
    //                 ],
    //               ),
    //               const SizedBox(
    //                 height: 20,
    //               ),
    //               SizedBox(
    //                 width: 400,
    //                 child: TextField(
    //                   controller: _searchTextController,
    //                   minLines: 1,
    //                   decoration: InputDecoration(
    //                     border: OutlineInputBorder(
    //                       borderRadius: BorderRadius.circular(10),
    //                       borderSide: const BorderSide(
    //                         width: 0,
    //                         style: BorderStyle.none,
    //                       ),
    //                     ),
    //                     prefixIcon: const Icon(
    //                       Icons.search,
    //                     ),
    //                     hintText: 'Search by id, address, title',
    //                     hintStyle: const TextStyle(
    //                       fontSize: 12,
    //                       color: Colors.grey,
    //                     ),
    //                     filled: true,
    //                     fillColor: Theme.of(context).cardColor,
    //                     suffixIcon: IconButton(
    //                       onPressed: _searchTextController.text.isEmpty
    //                           ? null
    //                           : () {
    //                               _searchTextController.clear();
    //                             },
    //                       icon: Icon(Icons.close,
    //                           color: _searchTextController.text.isNotEmpty
    //                               ? Colors.red
    //                               : Colors.grey),
    //                     ),
    //                   ),
    //                   onChanged: (value) {
    //                     _searchTextController.text.toLowerCase();
    //                     setState(() {
    //                       queryOrderList = ordersList
    //                           .where((element) =>
    //                               element.orderId.toString().toLowerCase().contains(
    //                                   _searchTextController.text.toLowerCase()) ||
    //                               element.productTitle!.toLowerCase().contains(
    //                                   _searchTextController.text.toLowerCase()) ||
    //                               element.address!.toLowerCase().contains(
    //                                   _searchTextController.text.toLowerCase()))
    //                           .toList();
    //                     });
    //                   },
    //                 ),
    //               ),
    //               const SizedBox(
    //                 height: 20,
    //               ),
    //               Container(
    //                 height: 40,
    //                 color: Colors.white,
    //                 child: Row(
    //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                   children: const [
    //                     Text(
    //                       'Recent Orders',
    //                       style: TextStyle(fontWeight: FontWeight.w600),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //               Container(
    //                 height: 40,
    //                 color: Colors.pink.shade100,
    //                 child: Row(
    //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                   children: [
    //                     Container(
    //                         //  color: Colors.purple,
    //                         width: sizeToEachRow,
    //                         child: const Text(
    //                           'Index',
    //                           textAlign: TextAlign.center,
    //                         )),
    //                     // Container(
    //                     //     //  color: Colors.indigo,
    //                     //     width: sizeToEachRow,
    //                     //     child: const Text(
    //                     //       'User',
    //                     //       textAlign: TextAlign.center,
    //                     //     )),
    //                     Container(
    //                         //  color: Colors.indigo,
    //                         width: sizeToEachRow,
    //                         child: const Text(
    //                           'Product Title',
    //                           textAlign: TextAlign.center,
    //                         )),
    //                     Container(
    //                         width: sizeToEachRow,
    //                         child: const Text(
    //                           'Address',
    //                           textAlign: TextAlign.center,
    //                         )),
    //                     Container(
    //                         // color: Colors.blue,
    //                         width: sizeToEachRow,
    //                         child: const Text(
    //                           'Order Id',
    //                           textAlign: TextAlign.center,
    //                         )),
    //                     Container(
    //                         // color: Colors.green,
    //                         width: sizeToEachRow,
    //                         child: const Text(
    //                           'Total Amount',
    //                           textAlign: TextAlign.center,
    //                         )),
    //                     Container(
    //                         //  color: Colors.yellow,
    //                         width: sizeToEachRow,
    //                         child: const Text(
    //                           'Order Date',
    //                           textAlign: TextAlign.center,
    //                         )),
    //                     Container(
    //                         //   color: Colors.orange,
    //                         width: sizeToEachRow,
    //                         child: const Text(
    //                           'Quantity',
    //                           textAlign: TextAlign.center,
    //                         )),
    //                     Container(
    //                         //  color: Colors.red,
    //                         width: sizeToEachRow,
    //                         child: const Text(
    //                           'Status',
    //                           textAlign: TextAlign.center,
    //                         )),
    //                     Container(
    //                         //  color: Colors.grey,
    //                         width: sizeToEachRow,
    //                         child: const Text(
    //                           'Delivery Boy',
    //                           textAlign: TextAlign.center,
    //                         )),
    //                   ],
    //                 ),
    //               ),
    //               const SizedBox(
    //                 height: 5,
    //               ),
    //               FirestorePagination(
    //                   query: FirebaseFirestore.instance
    //                       .collection('order')
    //                       .orderBy('orderDate', descending: true),
    //                   isLive: true,
    //                   limit: 2,
    //                   reverse: false,
    //                   padding: const EdgeInsets.all(8.0),
    //                   separatorBuilder: (context, index) => const Divider(),
    //                 itemBuilder: (context, snapshot,index) {
    //                   return _searchTextController.text.isEmpty
    //                       ? ListView.builder(
    //                           itemCount: ordersList.length,
    //                           itemBuilder: (context, index) {
    //                             return OrderFull(
    //                               index: (index + 1).toString(),
    //                               productTitle: ordersList[index].productTitle!,
    //                               orderId: ordersList[index].orderId!,
    //                               price: ordersList[index].price!,
    //                               orderDate: ordersList[index].orderDate!,
    //                               quantity: ordersList[index].quantity!,
    //                               status: ordersList[index].status!,
    //                               address: ordersList[index].address!,
    //                               deliveryBoyId: ordersList[index].deliveryBoy!,
    //                               userId: ordersList[index].userId!,
    //                             );
    //                           })
    //                       : ListView.builder(
    //                           itemCount: queryOrderList.length,
    //                           itemBuilder: (context, index) {
    //                             return OrderFull(
    //                               index: (index + 1).toString(),
    //                               productTitle: queryOrderList[index].productTitle!,
    //                               orderId: queryOrderList[index].orderId!,
    //                               price: queryOrderList[index].price!,
    //                               orderDate: queryOrderList[index].orderDate!,
    //                               quantity: queryOrderList[index].quantity!,
    //                               status: queryOrderList[index].status!,
    //                               address: queryOrderList[index].address!,
    //                               deliveryBoyId: queryOrderList[index].deliveryBoy!,
    //                               userId: ordersList[index].userId!,
    //                             );
    //                           });
    //                 }
    //               ),
    //             ],
    //           ),
    //           mobile: ListView(
    //             scrollDirection: Axis.horizontal,
    //             children: [
    //               Container(
    //                 width: 1200,
    //                 child: Column(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: [
    //                     const SizedBox(
    //                       height: 10,
    //                     ),
    //                     Row(
    //                       children: [
    //                         Expanded(
    //                             child: ListCard(
    //                           title: 'Orderss',
    //                           subTitle: '${orderList.length}',
    //                           icon: FontAwesomeIcons.shoppingCart,
    //                           color: const Color(0xFF2E5AAC),
    //                         )),
    //                         Expanded(
    //                             child: ListCard(
    //                           title: 'Out For Delivery',
    //                           subTitle: '${outForDeliveryList.length}',
    //                           icon: Icons.delivery_dining,
    //                           color: Colors.deepPurpleAccent,
    //                         )),
    //                         Expanded(
    //                           child: ListCard(
    //                               title: 'Delivered Orders ${deliveredList.length}',
    //                               subTitle: 'Total Earning: $totalEarning INR',
    //                               icon: Icons.done,
    //                               color: Colors.green),
    //                         ),
    //                         Expanded(
    //                             child: ListCard(
    //                           title: 'Cancelled Orders',
    //                           subTitle: '${cancelledList.length}',
    //                           icon: Icons.error,
    //                           color: const Color(0xFFDA1414),
    //                         )),
    //                       ],
    //                     ),
    //                     const SizedBox(
    //                       height: 20,
    //                     ),
    //                     SizedBox(
    //                       width: 300,
    //                       child: TextField(
    //                         controller: _searchTextController,
    //                         minLines: 1,
    //                         decoration: InputDecoration(
    //                           border: OutlineInputBorder(
    //                             borderRadius: BorderRadius.circular(10),
    //                             borderSide: const BorderSide(
    //                               width: 0,
    //                               style: BorderStyle.none,
    //                             ),
    //                           ),
    //                           prefixIcon: const Icon(
    //                             Icons.search,
    //                           ),
    //                           hintText: 'Search by id, address, title',
    //                           hintStyle: const TextStyle(
    //                             fontSize: 12,
    //                             color: Colors.grey,
    //                           ),
    //                           filled: true,
    //                           fillColor: Theme.of(context).cardColor,
    //                           suffixIcon: IconButton(
    //                             onPressed: _searchTextController.text.isEmpty
    //                                 ? null
    //                                 : () {
    //                                     _searchTextController.clear();
    //                                   },
    //                             icon: Icon(Icons.close,
    //                                 color: _searchTextController.text.isNotEmpty
    //                                     ? Colors.red
    //                                     : Colors.grey),
    //                           ),
    //                         ),
    //                         onChanged: (value) {
    //                           _searchTextController.text.toLowerCase();
    //                           setState(() {
    //                             queryOrderList = ordersList
    //                                 .where((element) =>
    //                                     element.orderId
    //                                         .toString()
    //                                         .toLowerCase()
    //                                         .contains(_searchTextController.text
    //                                             .toLowerCase()) ||
    //                                     element.productTitle!
    //                                         .toLowerCase()
    //                                         .contains(_searchTextController.text
    //                                             .toLowerCase()) ||
    //                                     element.address!.toLowerCase().contains(
    //                                         _searchTextController.text
    //                                             .toLowerCase()))
    //                                 .toList();
    //                           });
    //                         },
    //                       ),
    //                     ),
    //                     const SizedBox(
    //                       height: 20,
    //                     ),
    //                     Container(
    //                       height: 40,
    //                       color: Colors.white,
    //                       child: Row(
    //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                         children: const [
    //                           Text(
    //                             'Recent Orders',
    //                             style: TextStyle(fontWeight: FontWeight.w600),
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                     Container(
    //                       height: 40,
    //                       color: Colors.pink.shade100,
    //                       child: Row(
    //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                         children: [
    //                           Container(
    //                               //  color: Colors.purple,
    //                               width: sizeToEachRow,
    //                               child: const Text(
    //                                 'Index',
    //                                 textAlign: TextAlign.center,
    //                               )),
    //                           // Container(
    //                           //     //  color: Colors.indigo,
    //                           //     width: sizeToEachRow,
    //                           //     child: const Text(
    //                           //       'User',
    //                           //       textAlign: TextAlign.center,
    //                           //     )),
    //                           Container(
    //                               // color: Colors.indigo,
    //                               width: sizeToEachRow,
    //                               child: const Text(
    //                                 'Product Title',
    //                                 textAlign: TextAlign.center,
    //                               )),
    //                           Container(
    //                               width: sizeToEachRow,
    //                               child: const Text(
    //                                 'Address',
    //                                 textAlign: TextAlign.center,
    //                               )),
    //                           Container(
    //                               // color: Colors.blue,
    //                               width: sizeToEachRow,
    //                               child: const Text(
    //                                 'Order Id',
    //                                 textAlign: TextAlign.center,
    //                               )),
    //                           Container(
    //                               // color: Colors.green,
    //                               width: sizeToEachRow,
    //                               child: const Text(
    //                                 'Total Amount',
    //                                 textAlign: TextAlign.center,
    //                               )),
    //                           Container(
    //                               //  color: Colors.yellow,
    //                               width: sizeToEachRow,
    //                               child: const Text(
    //                                 'Order Date',
    //                                 textAlign: TextAlign.center,
    //                               )),
    //                           Container(
    //                               //   color: Colors.orange,
    //                               width: sizeToEachRow,
    //                               child: const Text(
    //                                 'Quantity',
    //                                 textAlign: TextAlign.center,
    //                               )),
    //                           Container(
    //                               //  color: Colors.red,
    //                               width: sizeToEachRow,
    //                               child: const Text(
    //                                 'Status',
    //                                 textAlign: TextAlign.center,
    //                               )),
    //                           Container(
    //                               //  color: Colors.grey,
    //                               width: sizeToEachRow,
    //                               child: const Text(
    //                                 'Delivery Boy',
    //                                 textAlign: TextAlign.center,
    //                               )),
    //                         ],
    //                       ),
    //                     ),
    //                     const SizedBox(
    //                       height: 5,
    //                     ),
    //                     Expanded(
    //                       child: _searchTextController.text.isEmpty
    //                           ? ListView.builder(
    //                               itemCount: ordersList.length,
    //                               itemBuilder: (context, index) {
    //                                 return OrderFull(
    //                                   index: (index + 1).toString(),
    //                                   productTitle: ordersList[index].productTitle!,
    //                                   orderId: ordersList[index].orderId!,
    //                                   price: ordersList[index].price!,
    //                                   orderDate: ordersList[index].orderDate!,
    //                                   quantity: ordersList[index].quantity!,
    //                                   status: ordersList[index].status!,
    //                                   address: ordersList[index].address!,
    //                                   deliveryBoyId: ordersList[index].deliveryBoy!,
    //                                   userId: ordersList[index].userId!,
    //                                 );
    //                               })
    //                           : ListView.builder(
    //                               itemCount: queryOrderList.length,
    //                               itemBuilder: (context, index) {
    //                                 return OrderFull(
    //                                   index: (index + 1).toString(),
    //                                   productTitle:
    //                                       queryOrderList[index].productTitle!,
    //                                   orderId: queryOrderList[index].orderId!,
    //                                   price: queryOrderList[index].price!,
    //                                   orderDate: queryOrderList[index].orderDate!,
    //                                   quantity: queryOrderList[index].quantity!,
    //                                   status: queryOrderList[index].status!,
    //                                   address: queryOrderList[index].address!,
    //                                   deliveryBoyId:
    //                                       queryOrderList[index].deliveryBoy!,
    //                                   userId: ordersList[index].userId!,
    //                                 );
    //                               }),
    //                     ),
    //                   ],
    //                 ),
    //               )
    //             ],
    //           ));
    //     });
  }
}

class ListCard extends StatelessWidget {
  final String title;
  final String subTitle;
  final IconData icon;
  final Color color;

  ListCard(
      {required this.title,
      required this.subTitle,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
        ),
        subtitle: Text(
          subTitle,
          style: TextStyle(color: Colors.white),
        ),
        trailing: Icon(
          icon,
          color: Colors.white,
        ),
        isThreeLine: false,
      ),
    );
  }
}
