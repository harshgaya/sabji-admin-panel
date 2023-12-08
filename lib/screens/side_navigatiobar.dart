import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import './DeliveryBoyDashboard.dart';
import './dashboard.dart';
import './productDashboard.dart';
import './slider_dashboard.dart';
import './userDashboard.dart';
import '../global_method.dart';
import './categoryDashboard.dart';
import './notificationDashboard.dart';

class SideNavigationbar extends StatefulWidget {
  @override
  State<SideNavigationbar> createState() => _SideNavigationbarState();
}

class _SideNavigationbarState extends State<SideNavigationbar> {
  GlobalMethod method = GlobalMethod();
  PageController page = PageController();
  bool canOrder = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final doc = FirebaseFirestore.instance
        .collection('Appservice')
        .doc('PfYO4WQFXzmhbt0wLGMJ')
        .get();
    doc.then((value) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            canOrder = value.get('canOrder');
          });
        }
      });
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'SabjiTaja Admin Panel',
          style: TextStyle(fontWeight: FontWeight.w800, color: Colors.black),
        ),
        actions: [
          Switch(
            value: canOrder,
            onChanged: (bool val) async {
              if (canOrder == true) {
                method.showDialogg(
                    'Are you sure?', 'Order will be closed in user app.',
                    () async {
                  await FirebaseFirestore.instance
                      .collection('Appservice')
                      .doc('PfYO4WQFXzmhbt0wLGMJ')
                      .update({'canOrder': false}).then((value) {
                    setState(() {});
                  });
                }, context);
              } else {
                method.showDialogg(
                    'Are you sure?', 'Order will be active in user app.',
                    () async {
                  await FirebaseFirestore.instance
                      .collection('Appservice')
                      .doc('PfYO4WQFXzmhbt0wLGMJ')
                      .update({'canOrder': true}).then((value) {
                    setState(() {});
                  });
                }, context);
              }
            },
          )
        ],
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SideMenu(
            controller: page,
            style: SideMenuStyle(
              openSideMenuWidth: 200,
              iconSize: 18,
              unselectedIconColor: Colors.grey,
              unselectedTitleTextStyle:
                  const TextStyle(color: Colors.grey, fontSize: 15),
              displayMode: SideMenuDisplayMode.auto,
              hoverColor: Colors.black12,
              selectedColor: Colors.black,
              selectedTitleTextStyle:
                  const TextStyle(color: Colors.white, fontSize: 15),
              selectedIconColor: Colors.white,
            ),
            title: const SizedBox(
              height: 20,
            ),
            footer: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    'SabjiTaja',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'admin@gmail.com',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.settings,
                        color: Colors.black,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onTap: () {
                          method.showDialogg(
                              'Logout', 'Are you sure you want to logout?',
                              () async {
                            await FirebaseAuth.instance.signOut();
                          }, context);
                        },
                        child: const Icon(
                          Icons.logout,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            items: [
              SideMenuItem(
                priority: 0,
                title: 'Dashboard',
                onTap: () => page.jumpToPage(0),
                icon: const Icon(Icons.home),
              ),
              SideMenuItem(
                priority: 1,
                title: 'Products',
                onTap: () => page.jumpToPage(1),
                icon: const Icon(FontAwesomeIcons.productHunt),
              ),
              SideMenuItem(
                priority: 2,
                title: 'Send Notification',
                onTap: () => page.jumpToPage(2),
                icon: const Icon(Icons.notifications_active_rounded),
              ),
              SideMenuItem(
                priority: 3,
                title: 'Users',
                onTap: () => page.jumpToPage(3),
                icon: const Icon(FontAwesomeIcons.user),
              ),
              SideMenuItem(
                priority: 4,
                title: 'Delivery Boys',
                onTap: () => page.jumpToPage(4),
                icon: const Icon(Icons.delivery_dining),
              ),
              SideMenuItem(
                priority: 5,
                title: 'Banners',
                onTap: () => page.jumpToPage(5),
                icon: const Icon(Icons.image),
              ),
              SideMenuItem(
                priority: 6,
                title: 'Category',
                onTap: () => page.jumpToPage(6),
                icon: const Icon(Icons.category),
              ),
            ],
          ),
          Expanded(
            child: PageView(
              controller: page,
              children: [
                Container(
                  color: Colors.white,
                  child: Dashboard(),
                ),
                Container(
                  color: Colors.white,
                  child: ProductDashboard(),
                ),
                Container(
                  color: Colors.white,
                  child: Center(child: NotificationDashboard()),
                ),
                Container(
                  color: Colors.white,
                  child: const Center(
                    child: UserDashboard(),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: const Center(child: DeliveryBoyDashboard()),
                ),
                SliderDashboard(),
                CategoryDashboard()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
