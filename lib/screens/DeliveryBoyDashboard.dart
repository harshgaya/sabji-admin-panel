import 'package:admin_panel_ecommerce/global_method.dart';
import 'package:admin_panel_ecommerce/responsive_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import './delivery_boys_screen.dart';

class DeliveryBoyDashboard extends StatefulWidget {
  const DeliveryBoyDashboard({Key? key}) : super(key: key);

  @override
  State<DeliveryBoyDashboard> createState() => _DeliveryBoyDashboardState();
}

class _DeliveryBoyDashboardState extends State<DeliveryBoyDashboard> {
  bool _obscureText = false;
  String emailAddress = '';
  String name = '';
  String password = '';
  String workingArea = '';
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  GlobalMethod _globalMethod = GlobalMethod();
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController areaController = TextEditingController();

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

    return ResponsiveDesign(
        desktop: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Container(
              height: 40,
              color: Colors.pink.shade100,
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      // color: Colors.purple,
                      width: sizeToEachRow,
                      child: const Text(
                        'Index',
                        textAlign: TextAlign.center,
                      )),
                  Container(
                      //  color: Colors.indigo,
                      width: sizeToEachRow,
                      child: const Text(
                        'Name',
                        textAlign: TextAlign.center,
                      )),
                  Container(
                      width: sizeToEachRow,
                      child: const Text(
                        'Mobile',
                        textAlign: TextAlign.center,
                      )),
                  Container(
                      //   color: Colors.blue,
                      width: sizeToEachRow,
                      child: const Text(
                        'Address',
                        textAlign: TextAlign.center,
                      )),
                  Container(
                      //   color: Colors.green,
                      width: sizeToEachRow,
                      child: const Text(
                        'Email',
                        textAlign: TextAlign.center,
                      )),
                  Container(
                      //   color: Colors.yellow,
                      width: sizeToEachRow,
                      child: const Text(
                        'Uid',
                        textAlign: TextAlign.center,
                      )),
                  Container(
                      //  color: Colors.orange,
                      width: sizeToEachRow,
                      child: const Text(
                        'Verified Status',
                        textAlign: TextAlign.center,
                      )),
                  Container(
                      //  color: Colors.red,
                      width: sizeToEachRow,
                      child: const Text(
                        'Applied Date',
                        textAlign: TextAlign.center,
                      )),
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            const Expanded(child: DeliveryBoyScreen()),
          ],
        ),
        mobile: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            SizedBox(
              width: 1200,
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Container(
                    height: 40,
                    color: Colors.pink.shade100,
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            // color: Colors.purple,
                            width: sizeToEachRow,
                            child: const Text(
                              'Index',
                              textAlign: TextAlign.center,
                            )),
                        Container(
                            //  color: Colors.indigo,
                            width: sizeToEachRow,
                            child: const Text(
                              'Name',
                              textAlign: TextAlign.center,
                            )),
                        Container(
                            width: sizeToEachRow,
                            child: const Text(
                              'Mobile',
                              textAlign: TextAlign.center,
                            )),
                        Container(
                            //   color: Colors.blue,
                            width: sizeToEachRow,
                            child: const Text(
                              'Address',
                              textAlign: TextAlign.center,
                            )),
                        Container(
                            //   color: Colors.green,
                            width: sizeToEachRow,
                            child: const Text(
                              'Email',
                              textAlign: TextAlign.center,
                            )),
                        Container(
                            //   color: Colors.yellow,
                            width: sizeToEachRow,
                            child: const Text(
                              'Uid',
                              textAlign: TextAlign.center,
                            )),
                        Container(
                            //  color: Colors.orange,
                            width: sizeToEachRow,
                            child: const Text(
                              'Verified Status',
                              textAlign: TextAlign.center,
                            )),
                        Container(
                            //  color: Colors.red,
                            width: sizeToEachRow,
                            child: const Text(
                              'Applied Date',
                              textAlign: TextAlign.center,
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Expanded(child: DeliveryBoyScreen()),
                ],
              ),
            )
          ],
        ));
  }
}
