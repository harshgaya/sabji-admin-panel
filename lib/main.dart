import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import './Models/user_attr.dart';
import './Models/category.dart';
import './Models/product_attr.dart';
import './Models/delivery_boys.dart';
import './Models/orders_attr.dart';
import './screens/productDashboard.dart';
import './screens/slider_dashboard.dart';
import './screens/upload_product_form.dart';
import './screens/user_state.dart';
import './screens/userDashboard.dart';
import './widegt/no_internet.dart';
import 'package:url_strategy/url_strategy.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ConnectivityResult _connectionStatus = ConnectivityResult.wifi;

  final Connectivity _connectivity = Connectivity();

  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e);
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  static const MaterialColor primaryBlack = MaterialColor(
    _blackPrimaryValue,
    <int, Color>{
      50: Color(0xFF000000),
      100: Color(0xFF000000),
      200: Color(0xFF000000),
      300: Color(0xFF000000),
      400: Color(0xFF000000),
      500: Color(_blackPrimaryValue),
      600: Color(0xFF000000),
      700: Color(0xFF000000),
      800: Color(0xFF000000),
      900: Color(0xFF000000),
    },
  );
  static const int _blackPrimaryValue = 0xFF000000;

  @override
  Widget build(BuildContext context) {
    if (_connectionStatus == ConnectivityResult.none) {
      print('connection state in main.dart $_connectionStatus');
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(child: NoInternet()),
        ),
      );
    }
    return MultiProvider(
        providers: [
          StreamProvider<List<OrdersAttr>>(
            create: (context) => OrdersAttr().orders,
            initialData: [],
            catchError: (context, error) {
              return [];
            },
          ),
          StreamProvider<List<UserAttr>>(
            create: (context) => UserAttr().users,
            initialData: [],
            catchError: (context, error) {
              return [];
            },
          ),
          StreamProvider<List<DeliveryBoy>>(
            create: (context) => DeliveryBoy().deliveryBoys,
            initialData: [],
            catchError: (context, error) {
              return [];
            },
          ),
          StreamProvider<List<Category>>(
            create: (context) => Category().category,
            initialData: [],
            catchError: (context, error) {
              return [];
            },
          ),
          StreamProvider<List<ProductAttr>>(
            create: (context) => ProductAttr().products,
            initialData: [],
            catchError: (context, error) {
              return [];
            },
          ),
        ],
        child: Builder(builder: (BuildContext context) {
          BuildContext rootContext = context;
          return MaterialApp(
            title: 'Sabjitaja Admin Panel',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                iconTheme: const IconThemeData(
                  color: Colors.black,
                ),
                elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, // background (button) color
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ), // foreground (text) color
                  ),
                ),
                progressIndicatorTheme: const ProgressIndicatorThemeData(
                  color: Colors.black,
                ),
                textTheme: const TextTheme(
                    headline1: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                )),
                inputDecorationTheme: const InputDecorationTheme(
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 1.0,
                    ),
                  ),
                ),
                buttonTheme: const ButtonThemeData(
                  buttonColor: Colors.black,
                ),
                bottomSheetTheme: const BottomSheetThemeData(
                    backgroundColor: Colors.transparent),
                appBarTheme: const AppBarTheme(
                    systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Colors.black,
                )),
                primaryColor: Colors.black,
                primarySwatch: primaryBlack,
                scaffoldBackgroundColor: Colors.white),
            home: UserState(),
            routes: {
              UserState.routeName: (contex) => UserState(),
              UserDashboard.routeName: (contex) => UserDashboard(),
              ProductDashboard.routeName: (context) => ProductDashboard(),
              UploadProductForm.routeName: (context) => UploadProductForm(),
              SliderDashboard.routeName: (context) => SliderDashboard(),
            },
          );
        }));
    // FutureBuilder<Object>(
    //     future: _initialization,
    //     builder: (context, snapshot) {
    //       if(snapshot.connectionState==ConnectionState.waiting){
    //         return MaterialApp(
    //           home: Scaffold(
    //             body: Center(
    //               child: CircularProgressIndicator(),
    //             ),
    //           ),
    //         );
    //       }else if(snapshot.hasError){
    //         return MaterialApp(
    //           home: Scaffold(
    //             body: Center(
    //               child: Text(
    //                 'Error Occured'
    //               ),
    //             ),
    //           ),
    //         );
    //       }return
    //     }
    //   );
  }
}
