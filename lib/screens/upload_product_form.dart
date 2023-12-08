import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../Models/category.dart';
import '../global_method.dart';

class UploadProductForm extends StatefulWidget {
  static const routeName = '/UploadProductForm';

  @override
  _UploadProductFormState createState() => _UploadProductFormState();
}

class _UploadProductFormState extends State<UploadProductForm> {
  final _formKey = GlobalKey<FormState>();

  var _productTitle = '';
  var _productPrice = '';
  var _cuttedPrice = '';
  var _productCategory = '';
  var _productUnit = '';
  // var _productBrand = '';
  var _productDescription = '';
  // var _productQuantity = '';
  bool _popular = false;
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();
  final TextEditingController _popularController = TextEditingController();
  final TextEditingController _productTitleController = TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();
  final TextEditingController _productCuttedPriceController =
      TextEditingController();
  String? _categoryValue;
  String? _popularValue;
  String? _unitValue;
  GlobalMethod _globalMethods = GlobalMethod();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  File? _pickedImage;
  bool _isLoading = false;
  String? url;
  var uuid = const Uuid();
  bool isUploading = false;
  Uint8List? image;
  String? imageName;

  void _trySubmit() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      try {
        if (image == null) {
          _globalMethods.authErrorHandle('Please pick an image', context);
        } else {
          setState(() {
            _isLoading = true;
          });

          if (_popularValue == 'Yes') {
            _popular = true;
          } else {
            _popular = false;
          }

          if (double.parse(_cuttedPrice) >= double.parse(_productPrice)) {
            final User? user = _auth.currentUser;
            final _uid = user!.uid;
            final productId = uuid.v4();
            try {
              final imageName = uuid.v4();

              final ref = FirebaseStorage.instance
                  .ref()
                  .child('productsImages')
                  .child(imageName + '.jpg');
              await ref.putData(
                  image!,
                  SettableMetadata(
                    contentType: "image/jpg",
                  ));
              url = await ref.getDownloadURL();
              await FirebaseFirestore.instance
                  .collection('products')
                  .doc(productId)
                  .set({
                'productId': productId,
                'productTitle': _productTitle,
                'price': _productPrice,
                'productImage': url,
                'productCategory': _categoryValue,
                'unitAmount': _unitValue,
                'productDescription': _productDescription,
                'userId': _uid,
                'inStock': true,
                'cuttedPrice': _cuttedPrice,
                'percentOff': ((double.parse(_cuttedPrice) -
                            double.parse(_productPrice)) /
                        double.parse(_cuttedPrice) *
                        100)
                    .toStringAsFixed(2),
                'isPopular': _popular,
                'createdAt': Timestamp.now(),
              }).then((value) {
                _globalMethods.authSuccessHandle(
                    title: 'Success!',
                    subtitle: 'Product added successfully.',
                    context: context);

                setState(() {
                  _productTitleController.text = '';
                  _productPriceController.text = '';
                  _productCuttedPriceController.text = '';
                  _categoryValue = null;
                  _unitValue = null;
                  _productDescription = '';
                  image = null;
                  _cuttedPrice = '';
                  _popularValue = null;
                  _isLoading = false;
                });
              }).catchError((error) {
                _globalMethods.authErrorHandle(
                    'Unable to add product', context);
                setState(() {
                  _isLoading = false;
                });
              });
            } catch (e) {}
          } else {
            _globalMethods.authErrorHandle(
                'Cutted Price should be Greater than Product Price', context);
          }
        }
      } catch (error) {
        _globalMethods.authErrorHandle(error.toString(), context);
        print('error occured ${error.toString()}');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _pickImageGallery() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result != null) {
      setState(() {
        image = result.files.first.bytes;
        imageName = result.files.first.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        bottomSheet: Container(
          height: kBottomNavigationBarHeight * 0.8,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(
                color: Colors.grey,
                width: 0.5,
              ),
            ),
          ),
          child: Material(
            color: Theme.of(context).backgroundColor,
            child: _isLoading
                ? const Center(
                    child: SizedBox(
                        height: 40,
                        width: 40,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        )))
                : InkWell(
                    onTap: _trySubmit,
                    splashColor: Colors.grey,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(right: 2),
                          child: Text('Upload',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                              textAlign: TextAlign.center),
                        ),
                        Icon(
                          FontAwesomeIcons.upload,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              width: mediaQuery.width < 768
                  ? mediaQuery.width - 50
                  : mediaQuery.width / 2,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    const Text(
                      'Add Product',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _productTitleController,
                      key: const ValueKey('Title'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a Title';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                          filled: true,
                          prefixIcon: Icon(
                            Icons.text_fields_rounded,
                            color: Colors.black,
                          ),
                          labelText: 'Product Title',
                          fillColor: Colors.white,
                          labelStyle: TextStyle(
                            color: Colors.black,
                          ),
                          hintText: 'Product Title'),
                      onSaved: (value) {
                        _productTitle = value!;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _productPriceController,
                      key: const ValueKey('Price'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter product price!';
                        }
                        return null;
                      },
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: const InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                        filled: true,
                        prefixIcon: Icon(
                          Icons.currency_rupee,
                          color: Colors.black,
                        ),
                        labelText: 'Product Price',
                        fillColor: Colors.white,
                        hintText: 'Product Price',
                        labelStyle: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      //obscureText: true,
                      onSaved: (value) {
                        _productPrice = value!;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _productCuttedPriceController,
                      key: const ValueKey('Cutted Price'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter product cutted price!';
                        }
                        return null;
                      },
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: const InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                        filled: true,
                        prefixIcon: Icon(
                          Icons.currency_rupee,
                          color: Colors.black,
                        ),
                        labelText: 'Product Cutted Price',
                        hintText: 'Cutted Price',
                        fillColor: Colors.white,
                        labelStyle: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      //obscureText: true,
                      onSaved: (value) {
                        _cuttedPrice = value!;
                      },
                    ),
                    const SizedBox(height: 20),
                    /* Image picker here ***********************************/
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          //  flex: 2,
                          child: Container(
                            height: 200,
                            width: 200,
                            decoration: BoxDecoration(
                              border: Border.all(width: 1),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: image == null
                                ? const Text(
                                    'Select Image',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 10,
                                    ),
                                  )
                                : Image.memory(
                                    image!,
                                    fit: BoxFit.contain,
                                  ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FittedBox(
                              child: TextButton.icon(
                                onPressed: _pickImageGallery,
                                icon: const Icon(Icons.image,
                                    color: Colors.purpleAccent),
                                label: const Text(
                                  'Gallery',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Consumer<List<Category>>(
                        builder: (context, categoryList, child) {
                      List<DropdownMenuItem<String>> dropdownLists =
                          categoryList.map((category) {
                        return DropdownMenuItem<String>(
                          child: Text(category.name!),
                          value: category.name!,
                        );
                      }).toList();
                      return DropdownButtonFormField<String>(
                        items: dropdownLists,
                        onChanged: (String? value) {
                          setState(() {
                            _categoryValue = value;
                            _categoryController.text = value!;
                            print(_productCategory);
                          });
                        },
                        hint: const Text('Select a Category'),
                        value: _categoryValue,
                        validator: (value) =>
                            value == null ? 'Please Select Category' : null,
                      );
                    }),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      items: const [
                        DropdownMenuItem<String>(
                          child: Text('Kg'),
                          value: 'Kg',
                        ),
                        DropdownMenuItem<String>(
                          child: Text('Liter'),
                          value: 'Liter',
                        ),
                        DropdownMenuItem<String>(
                          child: Text('Dozen'),
                          value: 'Dozen',
                        ),
                        DropdownMenuItem<String>(
                          child: Text('Packet'),
                          value: 'Packet',
                        ),
                        DropdownMenuItem<String>(
                          child: Text('Piece'),
                          value: 'Piece',
                        ),
                      ],
                      onChanged: (String? value) {
                        setState(() {
                          _unitValue = value;
                          _unitController.text = value!;
                          print(_productUnit);
                        });
                      },
                      hint: const Text('Select a Unit'),
                      value: _unitValue,
                      validator: (value) =>
                          value == null ? 'Please Select Unit' : null,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                        key: const ValueKey('Description'),
                        // validator: (value) {
                        //   if (value!.isEmpty) {
                        //     return 'product description is required';
                        //   }
                        //   return null;
                        // },
                        //controller: this._controller,
                        maxLines: 2,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: const InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                          filled: true,
                          prefixIcon: Icon(
                            Icons.description,
                            color: Colors.black,
                          ),
                          labelText: 'Product Description',
                          hintText: 'Product Description',
                          fillColor: Colors.white,
                          labelStyle: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        onSaved: (value) {
                          _productDescription = value!;
                        },
                        onChanged: (text) {
                          // setState(() => charLength -= text.length);
                        }),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      items: const [
                        DropdownMenuItem<String>(
                          child: Text('Yes'),
                          value: 'Yes',
                        ),
                        DropdownMenuItem<String>(
                          child: Text('No'),
                          value: 'No',
                        ),
                      ],
                      onChanged: (String? value) {
                        setState(() {
                          _popularValue = value;
                          _popularController.text = value!;
                          //_controller.text= _productCategory;
                          print(_popularValue);
                        });
                      },
                      hint: const Text('Select Popularity'),
                      value: _popularValue,
                      validator: (value) =>
                          value == null ? 'Please Select Popularity' : null,
                    ),
                    const SizedBox(
                      height: 100,
                    )
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
