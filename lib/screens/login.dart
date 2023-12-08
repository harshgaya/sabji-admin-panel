import 'package:admin_panel_ecommerce/global_method.dart';
import 'package:admin_panel_ecommerce/responsive_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/Login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FocusNode _passwordFocusNode = FocusNode();
  bool _obscureText = true;
  String _emailAddress = '';
  String _password = '';
  String email = "";
  String pass = '';
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalMethod _globalMethods = GlobalMethod();
  bool _isLoading = false;
  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _submitForm() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      _formKey.currentState!.save();
      try {
        if (_emailAddress == email && _password == pass) {
          await _auth
              .signInWithEmailAndPassword(
                  email: _emailAddress.toLowerCase().trim(),
                  password: _password.trim())
              .then((value) =>
                  Navigator.canPop(context) ? Navigator.pop(context) : null);
        } else {
          _globalMethods.authErrorHandle('You are not an admin !', context);
        }
      } catch (error) {
        _globalMethods.authErrorHandle(error.toString(), context);
        print('error occured ${error}');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> getID() async {
    await FirebaseFirestore.instance
        .collection("admin")
        .get()
        .then((QuerySnapshot adminSnapshot) {
      adminSnapshot.docs.forEach((element) {
        email = element.get('id');
        pass = element.get('password');
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getID();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveDesign(
        mobile: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Login',
                    style: Theme.of(context).textTheme.headline1,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                  ),
                  cursorColor: Colors.black,
                  key: const ValueKey('email'),
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () =>
                      FocusScope.of(context).requestFocus(_passwordFocusNode),
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                      hintText: 'Email',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.normal),
                      filled: true,
                      prefixIcon: Icon(
                        Icons.email,
                        color: Colors.black,
                      ),
                      labelText: 'Email Address',
                      fillColor: Colors.white,
                      labelStyle: TextStyle(
                        color: Colors.black,
                      )),
                  onSaved: (value) {
                    _emailAddress = value!;
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  key: const ValueKey('Password'),
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                  ),
                  cursorColor: Colors.black,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 7) {
                      return 'Please enter a valid Password';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  focusNode: _passwordFocusNode,
                  decoration: InputDecoration(
                    labelStyle: const TextStyle(
                      color: Colors.black,
                    ),
                    hintText: 'Password',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.normal),
                    filled: true,
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: Colors.black,
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      child: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                        color: Colors.black,
                      ),
                    ),
                    labelText: 'Password',
                    fillColor: Colors.white,
                  ),
                  onSaved: (value) {
                    _password = value!;
                  },
                  obscureText: _obscureText,
                  onEditingComplete: _submitForm,
                ),
                const SizedBox(
                  height: 30,
                ),
                const SizedBox(width: 10),
                _isLoading
                    ? const CircularProgressIndicator()
                    : Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _submitForm,
                              child: const Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
        desktop: Center(
          child: Container(
            //decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            width: 400,
            //height: MediaQuery.of(context).size.height / 1.3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Login',
                        style: Theme.of(context).textTheme.headline1,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 18,
                      ),
                      cursorColor: Colors.black,
                      key: const ValueKey('email'),
                      validator: (value) {
                        if (value!.isEmpty || !value.contains('@')) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () => FocusScope.of(context)
                          .requestFocus(_passwordFocusNode),
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          hintText: 'Email',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.normal),
                          filled: true,
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.black,
                          ),
                          labelText: 'Email Address',
                          fillColor: Colors.white,
                          labelStyle: TextStyle(
                            color: Colors.black,
                          )),
                      onSaved: (value) {
                        _emailAddress = value!;
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      key: const ValueKey('Password'),
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 18,
                      ),
                      cursorColor: Colors.black,
                      validator: (value) {
                        if (value!.isEmpty || value.length < 7) {
                          return 'Please enter a valid Password';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      focusNode: _passwordFocusNode,
                      decoration: InputDecoration(
                          labelStyle: const TextStyle(
                            color: Colors.black,
                          ),
                          hintText: 'Password',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.normal),
                          filled: true,
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Colors.black,
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            child: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.black,
                            ),
                          ),
                          labelText: 'Password',
                          fillColor: Colors.white),
                      onSaved: (value) {
                        _password = value!;
                      },
                      obscureText: _obscureText,
                      onEditingComplete: _submitForm,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const SizedBox(width: 10),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _submitForm,
                                  child: const Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Text(
                                      'Login',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
