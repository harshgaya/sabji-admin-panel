import 'package:admin_panel_ecommerce/screens/dashboard.dart';
import 'package:admin_panel_ecommerce/screens/login.dart';
import 'package:admin_panel_ecommerce/screens/side_navigatiobar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserState extends StatelessWidget {
  static const routeName = '/userState';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          // ignore: missing_return
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (userSnapshot.connectionState == ConnectionState.active) {
              if (userSnapshot.hasData) {
                print('The user is already logged in');
                return SideNavigationbar();
              } else {
                print('The user didn\'t login yet');
                return LoginScreen();
              }
            } else if (userSnapshot.hasError) {
              return const Center(
                child: Text('Error occured'),
              );
            }
            return const Center(
              child: Text('Error occured'),
            );
          }),
    );
  }
}
