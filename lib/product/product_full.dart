import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../global_method.dart';
import '../Models/category.dart';

class ProductFull extends StatefulWidget {
  final String index;
  final String id;
  final String title;
  final String description;
  final String price;
  final String cuttedPrice;
  final String imageUrl;
  final String productCategoryName;
  final String unitAmount;
  final bool isPopular;
  final String percentOff;
  final bool inStock;

  ProductFull({
    required this.index,
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.cuttedPrice,
    required this.imageUrl,
    required this.productCategoryName,
    required this.unitAmount,
    required this.percentOff,
    required this.isPopular,
    required this.inStock,
  });

  @override
  State<ProductFull> createState() => _ProductFullState();
}

class _ProductFullState extends State<ProductFull> {
  GlobalMethod globalMethod = GlobalMethod();
  final _formKey2 = GlobalKey<FormState>();
  bool isLoading2 = false;
  String productName = '';
  String productDescription = '';
  String productPrice = '';
  String cuttedPrice = '';
  Uint8List? newImage;
  String? newName;
  Uuid uuid = Uuid();
  bool isLoadingImage = false;

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
    var sizeToEachRow = size / 13;

    return Consumer<List<Category>>(builder: (context, categoryList, child) {
      return Container(
        height: 80,
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
                  ),
                ),

                Container(
                  width: sizeToEachRow,
                  child: Text(
                    widget.id,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                  ),
                ),
                InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(builder: (context, setState) {
                            return Center(
                              child: Container(
                                width: mediaQuery.width > 768
                                    ? 300
                                    : mediaQuery.width - 80,
                                child: Material(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Form(
                                      key: _formKey2,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text(
                                            'Change product name',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          TextFormField(
                                            initialValue: widget.title!,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 18,
                                            ),
                                            cursorColor: Colors.black,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Please enter product name !';
                                              }
                                              return null;
                                            },
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            decoration: const InputDecoration(
                                              hintText: 'Product Name',
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.always,
                                              hintStyle: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 14,
                                                  fontWeight:
                                                      FontWeight.normal),
                                              filled: true,
                                              prefixIcon: Icon(
                                                FontAwesomeIcons.productHunt,
                                                color: Colors.black,
                                              ),
                                              labelText: 'Product Name',
                                              fillColor: Colors.white,
                                              labelStyle: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                            onSaved: (value) {
                                              productName = value!;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          isLoading2
                                              ? const CircularProgressIndicator()
                                              : ElevatedButton(
                                                  onPressed: () async {
                                                    if (_formKey2.currentState!
                                                        .validate()) {
                                                      _formKey2.currentState!
                                                          .save();
                                                      try {
                                                        setState(() {
                                                          isLoading2 = true;
                                                        });
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'products')
                                                            .doc(widget.id!)
                                                            .update({
                                                          'productTitle':
                                                              productName
                                                                  .trim(),
                                                        }).then((value) {
                                                          globalMethod
                                                              .authSuccessHandle(
                                                                  title:
                                                                      'Success!',
                                                                  subtitle:
                                                                      'Product name changed successfully.',
                                                                  context:
                                                                      context);
                                                          setState(() {
                                                            isLoading2 = false;
                                                          });
                                                        }).catchError((error) {
                                                          globalMethod
                                                              .authErrorHandle(
                                                                  'unable to change product name',
                                                                  context);
                                                          setState(() {
                                                            isLoading2 = false;
                                                          });
                                                        });
                                                      } catch (e) {}
                                                    }
                                                  },
                                                  child: const Text('Change'),
                                                ),
                                        ],
                                      ),
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
                    child: Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 10, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(builder: (context, setState) {
                            return Center(
                              child: Container(
                                width: mediaQuery.width > 768
                                    ? 300
                                    : mediaQuery.width - 80,
                                child: Material(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Form(
                                      key: _formKey2,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text(
                                            'Change product description',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          TextFormField(
                                            initialValue: widget.description!,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 18,
                                            ),
                                            cursorColor: Colors.black,
                                            validator: (value) {
                                              // if (value!.isEmpty) {
                                              //   return 'Please enter product name !';
                                              // }
                                              // return null;
                                            },
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            decoration: const InputDecoration(
                                              hintText: 'Product Description',
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.always,
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
                                              fillColor: Colors.white,
                                              labelStyle: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                            onSaved: (value) {
                                              productDescription = value!;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          isLoading2
                                              ? const CircularProgressIndicator()
                                              : ElevatedButton(
                                                  onPressed: () async {
                                                    if (_formKey2.currentState!
                                                        .validate()) {
                                                      _formKey2.currentState!
                                                          .save();
                                                      try {
                                                        setState(() {
                                                          isLoading2 = true;
                                                        });
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'products')
                                                            .doc(widget.id!)
                                                            .update({
                                                          'productDescription':
                                                              productDescription
                                                                  .trim(),
                                                        }).then((value) {
                                                          globalMethod
                                                              .authSuccessHandle(
                                                                  title:
                                                                      'Success!',
                                                                  subtitle:
                                                                      'Product description changed successfully.',
                                                                  context:
                                                                      context);
                                                          setState(() {
                                                            isLoading2 = false;
                                                          });
                                                        }).catchError((error) {
                                                          globalMethod
                                                              .authErrorHandle(
                                                                  'unable to change product description',
                                                                  context);
                                                          setState(() {
                                                            isLoading2 = false;
                                                          });
                                                        });
                                                      } catch (e) {}
                                                    }
                                                  },
                                                  child: const Text('Change'),
                                                ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
                        });
                  },
                  child: SizedBox(
                    width: sizeToEachRow,
                    height: 50,
                    child: Center(
                      child: Text(widget.description,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: const TextStyle(
                              fontSize: 10, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(builder: (context, setState) {
                            return Center(
                              child: Container(
                                width: mediaQuery.width > 768
                                    ? 300
                                    : mediaQuery.width - 80,
                                child: Material(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Form(
                                      key: _formKey2,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text(
                                            'Change product price',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          TextFormField(
                                            initialValue: widget.price!,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 18,
                                            ),
                                            cursorColor: Colors.black,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Please enter product price !';
                                              }
                                              return null;
                                            },
                                            inputFormatters: <
                                                TextInputFormatter>[
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                            ],
                                            keyboardType: TextInputType.number,
                                            decoration: const InputDecoration(
                                              hintText: 'Product Price',
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.always,
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
                                              labelStyle: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                            onSaved: (value) {
                                              productPrice = value!;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          isLoading2
                                              ? const CircularProgressIndicator()
                                              : ElevatedButton(
                                                  onPressed: () async {
                                                    if (_formKey2.currentState!
                                                        .validate()) {
                                                      _formKey2.currentState!
                                                          .save();
                                                      try {
                                                        setState(() {
                                                          isLoading2 = true;
                                                        });
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'products')
                                                            .doc(widget.id!)
                                                            .update({
                                                          'price': productPrice
                                                              .trim(),
                                                        }).then((value) {
                                                          globalMethod
                                                              .authSuccessHandle(
                                                                  title:
                                                                      'Success!',
                                                                  subtitle:
                                                                      'Product price changed successfully.',
                                                                  context:
                                                                      context);
                                                          setState(() {
                                                            isLoading2 = false;
                                                          });
                                                        }).catchError((error) {
                                                          globalMethod
                                                              .authErrorHandle(
                                                                  'unable to change product price',
                                                                  context);
                                                          setState(() {
                                                            isLoading2 = false;
                                                          });
                                                        });
                                                      } catch (e) {}
                                                    }
                                                  },
                                                  child: const Text('Change'),
                                                ),
                                        ],
                                      ),
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
                    child: Text(
                      widget.price,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 10, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(builder: (context, setState) {
                            return Center(
                              child: Container(
                                width: mediaQuery.width > 768
                                    ? 300
                                    : mediaQuery.width - 80,
                                child: Material(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Form(
                                      key: _formKey2,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text(
                                            'Change product cutted price',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          TextFormField(
                                            initialValue: widget.cuttedPrice!,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 18,
                                            ),
                                            cursorColor: Colors.black,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Please enter product cutted price !';
                                              }
                                              return null;
                                            },
                                            inputFormatters: <
                                                TextInputFormatter>[
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                            ],
                                            keyboardType: TextInputType.number,
                                            decoration: const InputDecoration(
                                              hintText: 'Product Cutted Price',
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.always,
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
                                              fillColor: Colors.white,
                                              labelStyle: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                            onSaved: (value) {
                                              cuttedPrice = value!;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          isLoading2
                                              ? const CircularProgressIndicator()
                                              : ElevatedButton(
                                                  onPressed: () async {
                                                    if (_formKey2.currentState!
                                                        .validate()) {
                                                      _formKey2.currentState!
                                                          .save();
                                                      try {
                                                        setState(() {
                                                          isLoading2 = true;
                                                        });
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'products')
                                                            .doc(widget.id!)
                                                            .update({
                                                          'cuttedPrice':
                                                              cuttedPrice
                                                                  .trim(),
                                                        }).then((value) {
                                                          globalMethod
                                                              .authSuccessHandle(
                                                                  title:
                                                                      'Success!',
                                                                  subtitle:
                                                                      'Product cutted price changed successfully.',
                                                                  context:
                                                                      context);
                                                          setState(() {
                                                            isLoading2 = false;
                                                          });
                                                        }).catchError((error) {
                                                          globalMethod
                                                              .authErrorHandle(
                                                                  'unable to change product cutted price',
                                                                  context);
                                                          setState(() {
                                                            isLoading2 = false;
                                                          });
                                                        });
                                                      } catch (e) {}
                                                    }
                                                  },
                                                  child: const Text('Change'),
                                                ),
                                        ],
                                      ),
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
                    child: Text(
                      widget.cuttedPrice,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 10, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(builder: (context, setState) {
                            return AlertDialog(
                              title: const Text('Change Product Image'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 200,
                                    height: 200,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                    ),
                                    child: newImage == null
                                        ? const Text(
                                            'select image',
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey,
                                            ),
                                          )
                                        : Image.memory(newImage!),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () async {
                                          FilePickerResult? result =
                                              await FilePicker.platform
                                                  .pickFiles(
                                            type: FileType.image,
                                            withData: true,
                                          );

                                          if (result != null) {
                                            newImage = result.files.first.bytes;

                                            setState(() {
                                              newName = result.files.first.name;
                                            });
                                          }
                                        },
                                        child: const Text('Select Image'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              actionsAlignment: MainAxisAlignment.spaceBetween,
                              actions: [
                                isLoadingImage
                                    ? const CircularProgressIndicator()
                                    : TextButton(
                                        onPressed: () async {
                                          if (newImage == null) {
                                            globalMethod.authErrorHandle(
                                                'Select product image.',
                                                context);
                                          } else {
                                            try {
                                              setState(() {
                                                isLoadingImage = true;
                                              });
                                              final imageName = uuid.v4();

                                              final ref = FirebaseStorage
                                                  .instance
                                                  .ref()
                                                  .child('productsImages')
                                                  .child(imageName + '.jpg');
                                              await ref.putData(newImage!);
                                              String url =
                                                  await ref.getDownloadURL();

                                              FirebaseFirestore.instance
                                                  .collection('products')
                                                  .doc(widget.id)
                                                  .update({
                                                'productImage': url,
                                              }).then((value) {
                                                globalMethod.authSuccessHandle(
                                                    title: 'Success!',
                                                    subtitle:
                                                        'image changed successfully.',
                                                    context: context);
                                                setState(() {
                                                  newImage == null;
                                                  isLoadingImage = false;
                                                });
                                              }).catchError((error) {
                                                globalMethod.authErrorHandle(
                                                    'Unable to change image.',
                                                    context);
                                                setState(() {
                                                  newImage == null;
                                                  isLoadingImage = false;
                                                });
                                              });
                                            } catch (e) {}
                                          }
                                        },
                                        child: const Text('Change Image')),
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancel')),
                              ],
                            );
                          });
                        });
                  },
                  child: Container(
                    height: 50,
                    width: sizeToEachRow,
                    child: Image.network(widget.imageUrl),
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (categoryList.isEmpty) {
                      globalMethods.authErrorHandle(
                          'No Category Found!', context);
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
                                            'Product Category  is already added, if you want to change select from below',
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
                                            height: mediaQuery.height / 2,
                                            child: ListView.builder(
                                                itemCount: categoryList.length,
                                                itemBuilder: (context, index) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      bottom: 5,
                                                    ),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        border: Border.all(
                                                          color: Colors.black,
                                                          width: 1,
                                                        ),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: ListTile(
                                                          leading:
                                                              Image.network(
                                                            categoryList[index]
                                                                .url!,
                                                          ),
                                                          title: Text(
                                                            categoryList[index]
                                                                .name!,
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                          ),
                                                          onTap: () {
                                                            globalMethods.showDialogg(
                                                                'Add Category !',
                                                                'add category  ${categoryList[index].name!}  to the product ${widget.title}',
                                                                () {
                                                              try {
                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'products')
                                                                    .doc(widget
                                                                        .id!)
                                                                    .update({
                                                                  'productCategory':
                                                                      categoryList[
                                                                              index]
                                                                          .name!,
                                                                }).then(
                                                                        (value) {
                                                                  globalMethods.authSuccessHandle(
                                                                      title:
                                                                          'Added Successfully!',
                                                                      subtitle:
                                                                          'Category  ${categoryList[index].name!}  added to product ${widget.title}',
                                                                      context:
                                                                          context);
                                                                }).catchError(
                                                                        (error) {
                                                                  globalMethods
                                                                      .authErrorHandle(
                                                                          'Unable to add product category',
                                                                          context);
                                                                });
                                                              } catch (error) {}
                                                            }, context);
                                                          },
                                                        ),
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
                  },
                  child: Container(
                    width: sizeToEachRow,
                    child: Text(
                      '${widget.productCategoryName}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 10, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                Container(
                  width: sizeToEachRow,
                  child: Text(
                    widget.unitAmount,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 10, fontWeight: FontWeight.w600),
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (widget.isPopular) {
                      globalMethods.showDialogg('Make Unpopular?',
                          'Are you sure, product ${widget.title} will be unpopular.',
                          () async {
                        try {
                          await FirebaseFirestore.instance
                              .collection('products')
                              .doc(widget.id)
                              .update({'isPopular': false}).then((value) {
                            globalMethods.authSuccessHandle(
                                title: 'Success !',
                                subtitle:
                                    'Product ${widget.title}  is unpopular now',
                                context: context);
                          }).catchError((error) {
                            globalMethods.authErrorHandle(
                                error.toString(), context);
                          });
                        } catch (e) {}
                      }, context);
                    } else {
                      globalMethods.showDialogg('Make popular?',
                          'Are you sure, product ${widget.title} will be popular.',
                          () async {
                        try {
                          await FirebaseFirestore.instance
                              .collection('products')
                              .doc(widget.id)
                              .update({'isPopular': true}).then((value) {
                            globalMethods.authSuccessHandle(
                                title: 'Success !',
                                subtitle:
                                    'Product ${widget.title}  is popular now',
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
                    width: sizeToEachRow,
                    child: widget.isPopular
                        ? const Text(
                            'Yes',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.green,
                            ),
                          )
                        : const Text(
                            'No',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.red,
                            ),
                          ),
                  ),
                ),
                Container(
                  width: sizeToEachRow,
                  child: Text(
                    widget.percentOff,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 10, fontWeight: FontWeight.w600),
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (widget.inStock) {
                      globalMethods.showDialogg('Do out of stock?',
                          'Are you sure, product ${widget.title} will be out of stock.',
                          () async {
                        try {
                          await FirebaseFirestore.instance
                              .collection('products')
                              .doc(widget.id)
                              .update({'inStock': false}).then((value) {
                            globalMethods.authSuccessHandle(
                                title: 'Success !',
                                subtitle:
                                    'Product ${widget.title}  is out of stock now',
                                context: context);
                          }).catchError((error) {
                            globalMethods.authErrorHandle(
                                error.toString(), context);
                          });
                        } catch (e) {}
                      }, context);
                    } else {
                      globalMethods.showDialogg('Do in stock?',
                          'Are you sure, product ${widget.title} will be in stock.',
                          () async {
                        try {
                          await FirebaseFirestore.instance
                              .collection('products')
                              .doc(widget.id)
                              .update({'inStock': true}).then((value) {
                            globalMethods.authSuccessHandle(
                                title: 'Success !',
                                subtitle:
                                    'Product ${widget.title}  is in stock now',
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
                    width: sizeToEachRow,
                    child: widget.inStock
                        ? const Text(
                            'Yes',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.green),
                          )
                        : const Text(
                            'Out of Stock',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.red,
                            ),
                          ),
                  ),
                ),

                Container(
                    width: sizeToEachRow,
                    child: InkWell(
                        onTap: () {
                          globalMethods.showDialogg(
                              'Remove Product!', 'Product will be deleted!',
                              () async {
                            try {
                              await FirebaseFirestore.instance
                                  .collection('products')
                                  .doc(widget.id)
                                  .delete()
                                  .then((value) {
                                globalMethod.authSuccessHandle(
                                    title: 'Success',
                                    subtitle:
                                        'product ${widget.title} deleted successfully.',
                                    context: context);
                              }).catchError((error) {
                                globalMethod.authErrorHandle(
                                    'Unable to delete product ${widget.title}',
                                    context);
                              });
                            } catch (e) {}
                          }, context);
                        },
                        child: const Icon(
                          Icons.delete,
                          size: 20,
                          color: Colors.red,
                        ))),
                // Expanded(child: Container(child: Text(widget.total,style: TextStyle(fontSize: 10,fontWeight: FontWeight.w600)),)),
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
