import 'dart:typed_data';

import 'package:admin_panel_ecommerce/responsive_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import '../Models/category.dart';
import '../global_method.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class CategoryDashboard extends StatefulWidget {
  const CategoryDashboard({Key? key}) : super(key: key);

  @override
  State<CategoryDashboard> createState() => _CategoryDashboardState();
}

class _CategoryDashboardState extends State<CategoryDashboard> {
  GlobalMethod globalMethod = GlobalMethod();
  Uuid uuid = Uuid();
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final categoryController = TextEditingController();
  final categoryController2 = TextEditingController();
  Uint8List? fileBytes;
  Uint8List? newImage;
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);
  bool isLoading = false;
  bool isLoading2 = false;
  String? name;
  String? newName;
  String changedCategoryName = '';
  bool isLoadingImage = false;

// ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    var mediaQueryWidth = MediaQuery.of(context).size.width;
    var size;

    if (mediaQueryWidth < 768) {
      size = 1200;
    } else {
      size = mediaQueryWidth - 200;
    }
    // var size = MediaQuery.of(context).size.width - 200;
    var sizeToEachRow = size / 7;

    String formatTimestamp(Timestamp timestamp) {
      final timestampDate = timestamp.toDate();
      final now = DateTime.now();
      final today =
          DateTime(timestampDate.year, timestampDate.month, timestampDate.day);
      final todayTime = DateTime(now.year, now.month, now.day);
      final yesterdayTime = DateTime(now.year, now.month, now.day - 1);

      String formattedTime = DateFormat.jm().format(timestamp.toDate());

      if (today == todayTime) {
        return 'today at ${formattedTime}';
      } else if (today == yesterdayTime) {
        return 'yesterday at ${formattedTime}';
      }

      var format = DateFormat('d-MMMM-y'); // <- use skeleton here
      return format.format(timestamp.toDate());
    }

    return ResponsiveDesign(
      desktop: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 300,
              child: TextFormField(
                controller: categoryController,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                ),
                cursorColor: Colors.black,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter category name !';
                  }
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    hintText: 'Category Name',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.normal),
                    filled: true,
                    prefixIcon: Icon(
                      Icons.category,
                      color: Colors.black,
                    ),
                    labelText: 'Category Name',
                    fillColor: Colors.white,
                    labelStyle: TextStyle(
                      color: Colors.black,
                    )),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const Text(
                  'Select Category Background color',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  height: 20,
                  width: 20,
                  color: pickerColor,
                ),
                const SizedBox(
                  width: 10,
                ),
                IconButton(
                  padding: const EdgeInsets.all(0),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Pick a color!'),
                          content: SingleChildScrollView(
                            child: ColorPicker(
                              pickerColor: pickerColor,
                              onColorChanged: changeColor,
                            ),
                          ),
                          actions: <Widget>[
                            ElevatedButton(
                              child: const Text('Got it'),
                              onPressed: () {
                                setState(() => currentColor = pickerColor);
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.colorize),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
            Row(
              children: [
                InkWell(
                    onTap: () async {
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles(
                        type: FileType.image,
                      );

                      if (result != null) {
                        fileBytes = result.files.first.bytes;
                        setState(() {
                          name = result.files.first.name;
                        });
                      }
                    },
                    child: Row(
                      children: const [
                        Text(
                          'Select Category Image',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Icon(Icons.image),
                      ],
                    )),
                name == null ? Container() : Text('${name}'),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      if (fileBytes == null) {
                        globalMethod.authErrorHandle(
                            'Select category image.', context);
                      } else {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          try {
                            setState(() {
                              isLoading = true;
                            });
                            final imageName = uuid.v4();

                            final ref = FirebaseStorage.instance
                                .ref()
                                .child('Category')
                                .child(imageName + '.jpg');
                            await ref.putData(fileBytes!);
                            String url = await ref.getDownloadURL();

                            FirebaseFirestore.instance
                                .collection('Category')
                                .doc(imageName)
                                .set({
                              'image': url,
                              'id': imageName,
                              'name': categoryController.text.trim(),
                              'backgroundColor': pickerColor.toString(),
                              'createdAt': Timestamp.now()
                            }).then((value) {
                              globalMethod.authSuccessHandle(
                                  title: 'Success!',
                                  subtitle: 'New category added successfully.',
                                  context: context);
                              setState(() {
                                isLoading = false;
                                categoryController.text = '';
                              });
                            }).catchError((error) {
                              globalMethod.authErrorHandle(
                                  'Unable to add category.', context);
                              setState(() {
                                isLoading = false;
                                categoryController.text = '';
                              });
                            });
                          } catch (e) {}
                        }
                      }
                    },
                    child: const Text('Add New Category')),
            const SizedBox(
              height: 20,
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
                    ),
                  ),
                  Container(
                    //  color: Colors.purple,
                    width: sizeToEachRow,
                    child: const Text(
                      'Name',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    //  color: Colors.purple,
                    width: sizeToEachRow,
                    child: const Text(
                      'Image',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    //  color: Colors.purple,
                    width: sizeToEachRow,
                    child: const Text(
                      'Id',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    //  color: Colors.purple,
                    width: sizeToEachRow,
                    child: const Text(
                      'Background Color',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    //  color: Colors.purple,
                    width: sizeToEachRow,
                    child: const Text(
                      'Created At',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    //  color: Colors.purple,
                    width: sizeToEachRow,
                    child: const Text(
                      'Delete',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Expanded(
              child: Consumer<List<Category>>(
                  builder: (context, categoryList, child) {
                print('categrory length ${categoryList.length}');

                Color getColor(String value, int index) {
                  String valueString = categoryList[index]
                      .backgroundColor!
                      .split('(0x')[1]
                      .split(')')[0]; // kind of hacky..
                  int value = int.parse(valueString, radix: 16);
                  Color otherColor = new Color(value);
                  return otherColor;
                }

                if (categoryList.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                    itemCount: categoryList.length,
                    itemBuilder: (context, index) {
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
                                    (index + 1).toString(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return StatefulBuilder(
                                              builder: (context, setState) {
                                            return Center(
                                              child: Container(
                                                height: 500,
                                                width: 500,
                                                child: Material(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            20.0),
                                                    child: Form(
                                                      key: _formKey2,
                                                      child: Column(
                                                        children: [
                                                          const Text(
                                                            'Change category name',
                                                            style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 20,
                                                          ),
                                                          TextFormField(
                                                            initialValue:
                                                                categoryList[
                                                                        index]
                                                                    .name!,
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontSize: 18,
                                                            ),
                                                            cursorColor:
                                                                Colors.black,
                                                            validator: (value) {
                                                              if (value!
                                                                  .isEmpty) {
                                                                return 'Please enter category name !';
                                                              }
                                                              return null;
                                                            },
                                                            keyboardType:
                                                                TextInputType
                                                                    .emailAddress,
                                                            decoration:
                                                                const InputDecoration(
                                                              hintText:
                                                                  'Category Name',
                                                              floatingLabelBehavior:
                                                                  FloatingLabelBehavior
                                                                      .always,
                                                              hintStyle: TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                              filled: true,
                                                              prefixIcon: Icon(
                                                                Icons.category,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                              labelText:
                                                                  'Category Name',
                                                              fillColor:
                                                                  Colors.white,
                                                              labelStyle:
                                                                  TextStyle(
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                            onSaved: (value) {
                                                              changedCategoryName =
                                                                  value!;
                                                            },
                                                          ),
                                                          const SizedBox(
                                                            height: 20,
                                                          ),
                                                          isLoading2
                                                              ? const CircularProgressIndicator()
                                                              : ElevatedButton(
                                                                  onPressed:
                                                                      () async {
                                                                    if (_formKey2
                                                                        .currentState!
                                                                        .validate()) {
                                                                      _formKey2
                                                                          .currentState!
                                                                          .save();
                                                                      try {
                                                                        setState(
                                                                            () {
                                                                          isLoading2 =
                                                                              true;
                                                                        });
                                                                        await FirebaseFirestore
                                                                            .instance
                                                                            .collection('Category')
                                                                            .doc(categoryList[index].id!)
                                                                            .update({
                                                                          'name':
                                                                              changedCategoryName.trim(),
                                                                        }).then((value) {
                                                                          globalMethod.authSuccessHandle(
                                                                              title: 'Success!',
                                                                              subtitle: 'category name changed successfully.',
                                                                              context: context);
                                                                          setState(
                                                                              () {
                                                                            isLoading2 =
                                                                                false;
                                                                          });
                                                                        }).catchError((error) {
                                                                          globalMethod.authErrorHandle(
                                                                              'unable to change category name',
                                                                              context);
                                                                          setState(
                                                                              () {
                                                                            isLoading2 =
                                                                                false;
                                                                          });
                                                                        });
                                                                      } catch (e) {}
                                                                    }
                                                                  },
                                                                  child: const Text(
                                                                      'Change'),
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
                                    //  color: Colors.purple,
                                    width: sizeToEachRow,
                                    child: Text(
                                      categoryList[index].name!,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return StatefulBuilder(
                                              builder: (context, setState) {
                                            return AlertDialog(
                                              title: const Text(
                                                  'Change Category Image'),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    width: 200,
                                                    height: 200,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.black),
                                                    ),
                                                    child: newImage == null
                                                        ? const Text(
                                                            'select image',
                                                            style: TextStyle(
                                                              fontSize: 10,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          )
                                                        : Image.memory(
                                                            newImage!),
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Row(
                                                    children: [
                                                      ElevatedButton(
                                                        onPressed: () async {
                                                          FilePickerResult?
                                                              result =
                                                              await FilePicker
                                                                  .platform
                                                                  .pickFiles(
                                                            type:
                                                                FileType.image,
                                                          );

                                                          if (result != null) {
                                                            newImage = result
                                                                .files
                                                                .first
                                                                .bytes;

                                                            setState(() {
                                                              newName = result
                                                                  .files
                                                                  .first
                                                                  .name;
                                                            });
                                                          }
                                                        },
                                                        child: const Text(
                                                            'Select Image'),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              actionsAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              actions: [
                                                isLoadingImage
                                                    ? const CircularProgressIndicator()
                                                    : TextButton(
                                                        onPressed: () async {
                                                          if (newImage ==
                                                              null) {
                                                            globalMethod
                                                                .authErrorHandle(
                                                                    'Select category image.',
                                                                    context);
                                                          } else {
                                                            try {
                                                              setState(() {
                                                                isLoadingImage =
                                                                    true;
                                                              });
                                                              final imageName =
                                                                  uuid.v4();

                                                              final ref = FirebaseStorage
                                                                  .instance
                                                                  .ref()
                                                                  .child(
                                                                      'Category')
                                                                  .child(
                                                                      imageName +
                                                                          '.jpg');
                                                              await ref.putData(
                                                                  newImage!);
                                                              String url = await ref
                                                                  .getDownloadURL();

                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'Category')
                                                                  .doc(categoryList[
                                                                          index]
                                                                      .id)
                                                                  .update({
                                                                'image': url,
                                                              }).then((value) {
                                                                globalMethod.authSuccessHandle(
                                                                    title:
                                                                        'Success!',
                                                                    subtitle:
                                                                        'image changed successfully.',
                                                                    context:
                                                                        context);
                                                                setState(() {
                                                                  newImage ==
                                                                      null;
                                                                  isLoadingImage =
                                                                      false;
                                                                });
                                                              }).catchError(
                                                                      (error) {
                                                                globalMethod
                                                                    .authErrorHandle(
                                                                        'Unable to change image.',
                                                                        context);
                                                                setState(() {
                                                                  newImage ==
                                                                      null;
                                                                  isLoadingImage =
                                                                      false;
                                                                });
                                                              });
                                                            } catch (e) {}
                                                          }
                                                        },
                                                        child: const Text(
                                                            'Change Image')),
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child:
                                                        const Text('Cancel')),
                                              ],
                                            );
                                          });
                                        });
                                  },
                                  child: Container(
                                      //  color: Colors.purple,
                                      width: sizeToEachRow,
                                      child: Image.network(
                                        categoryList[index].url!,
                                        fit: BoxFit.contain,
                                        width: 50,
                                        height: 50,
                                      )),
                                ),
                                Container(
                                  //  color: Colors.purple,
                                  width: sizeToEachRow,
                                  child: Text(
                                    categoryList[index].id!,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return StatefulBuilder(
                                            builder: (context, setState) {
                                          return AlertDialog(
                                            title: const Text(
                                                'Change Icon Background Color?'),
                                            content: SingleChildScrollView(
                                              child: ColorPicker(
                                                pickerColor: pickerColor,
                                                onColorChanged: changeColor,
                                              ),
                                            ),
                                            actions: <Widget>[
                                              ElevatedButton(
                                                child: const Text('Change'),
                                                onPressed: () async {
                                                  setState(() => currentColor =
                                                      pickerColor);
                                                  try {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('Category')
                                                        .doc(categoryList[index]
                                                            .id!)
                                                        .update({
                                                      'backgroundColor':
                                                          pickerColor
                                                              .toString(),
                                                    }).then((value) {
                                                      globalMethod
                                                          .authSuccessHandle(
                                                              title: 'Success!',
                                                              subtitle:
                                                                  'icon background color changed successfully.',
                                                              context: context);
                                                    }).catchError((error) {
                                                      globalMethod.authErrorHandle(
                                                          'unable to change icon background color',
                                                          context);
                                                    });
                                                  } catch (e) {}
                                                },
                                              ),
                                              ElevatedButton(
                                                child: const Text('Cancel'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                      },
                                    );

                                    // globalMethod.showDialogg(
                                    //     'Change background color?',
                                    //     'Category background color will be changed.',
                                    //     () async {
                                    //
                                    //   try {
                                    //     // await FirebaseFirestore.instance
                                    //     //     .collection('Category')
                                    //     //     .doc(categoryList[index].id!)
                                    //     //     .update({
                                    //     //   'backgroundColor':
                                    //     //       pickerColor.toString(),
                                    //     // }).then((value) {
                                    //     //   globalMethod.authSuccessHandle(
                                    //     //       title: 'Success!',
                                    //     //       subtitle:
                                    //     //           'icon background color changed successfully.',
                                    //     //       context: context);
                                    //     // }).catchError((error) {
                                    //     //   globalMethod.authErrorHandle(
                                    //     //       'unable to change icon background color',
                                    //     //       context);
                                    //     // });
                                    //   } catch (e) {}
                                    // }, context);
                                  },
                                  child: Container(
                                    //  color: Colors.purple,
                                    width: sizeToEachRow,
                                    color: getColor(
                                        categoryList[index].backgroundColor!,
                                        index),
                                    height: 50,
                                  ),
                                ),
                                Container(
                                  //  color: Colors.purple,
                                  width: sizeToEachRow,
                                  child: Text(
                                    formatTimestamp(
                                        categoryList[index].createdAt!),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    globalMethod.showDialogg('Delete Category?',
                                        'delete category ${categoryList[index].name!}',
                                        () async {
                                      await FirebaseFirestore.instance
                                          .collection('Category')
                                          .doc(categoryList[index].id!)
                                          .delete()
                                          .then((value) {
                                        globalMethod.authSuccessHandle(
                                            title: 'Success',
                                            subtitle:
                                                'category deleted successfully.',
                                            context: context);
                                      }).catchError((error) {
                                        globalMethod.authErrorHandle(
                                            'unable to delete category',
                                            context);
                                      });
                                    }, context);
                                  },
                                  child: Container(
                                    //  color: Colors.purple,
                                    width: sizeToEachRow,
                                    child: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
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
              }),
            )
          ],
        ),
      ),
      mobile: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          SizedBox(
            width: 1200,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 300,
                    child: TextFormField(
                      controller: categoryController,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 18,
                      ),
                      cursorColor: Colors.black,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter category name !';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          hintText: 'Category Name',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.normal),
                          filled: true,
                          prefixIcon: Icon(
                            Icons.category,
                            color: Colors.black,
                          ),
                          labelText: 'Category Name',
                          fillColor: Colors.white,
                          labelStyle: TextStyle(
                            color: Colors.black,
                          )),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      const Text(
                        'Select Category Background color',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        height: 20,
                        width: 20,
                        color: pickerColor,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      IconButton(
                        padding: const EdgeInsets.all(0),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Pick a color!'),
                                content: SingleChildScrollView(
                                  child: ColorPicker(
                                    pickerColor: pickerColor,
                                    onColorChanged: changeColor,
                                  ),
                                ),
                                actions: <Widget>[
                                  ElevatedButton(
                                    child: const Text('Got it'),
                                    onPressed: () {
                                      setState(
                                          () => currentColor = pickerColor);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.colorize),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      InkWell(
                          onTap: () async {
                            FilePickerResult? result =
                                await FilePicker.platform.pickFiles(
                              type: FileType.image,
                              withData: true,
                            );

                            if (result != null) {
                              fileBytes = result.files.first.bytes;
                              setState(() {
                                name = result.files.first.name;
                              });
                            }
                          },
                          child: Row(
                            children: const [
                              Text(
                                'Select Category Image',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Icon(Icons.image),
                            ],
                          )),
                      name == null ? Container() : Text('${name}'),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () async {
                            if (fileBytes == null) {
                              globalMethod.authErrorHandle(
                                  'Select category image.', context);
                            } else {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                try {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  final imageName = uuid.v4();

                                  final ref = FirebaseStorage.instance
                                      .ref()
                                      .child('Category')
                                      .child(imageName + '.jpg');
                                  await ref.putData(fileBytes!);
                                  String url = await ref.getDownloadURL();

                                  FirebaseFirestore.instance
                                      .collection('Category')
                                      .doc(imageName)
                                      .set({
                                    'image': url,
                                    'id': imageName,
                                    'name': categoryController.text.trim(),
                                    'backgroundColor': pickerColor.toString(),
                                    'createdAt': Timestamp.now()
                                  }).then((value) {
                                    globalMethod.authSuccessHandle(
                                        title: 'Success!',
                                        subtitle:
                                            'New category added successfully.',
                                        context: context);
                                    setState(() {
                                      isLoading = false;
                                      categoryController.text = '';
                                    });
                                  }).catchError((error) {
                                    globalMethod.authErrorHandle(
                                        'Unable to add category.', context);
                                    setState(() {
                                      isLoading = false;
                                      categoryController.text = '';
                                    });
                                  });
                                } catch (e) {}
                              }
                            }
                          },
                          child: const Text('Add New Category')),
                  const SizedBox(
                    height: 20,
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
                          ),
                        ),
                        Container(
                          //  color: Colors.purple,
                          width: sizeToEachRow,
                          child: const Text(
                            'Name',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          //  color: Colors.purple,
                          width: sizeToEachRow,
                          child: const Text(
                            'Image',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          //  color: Colors.purple,
                          width: sizeToEachRow,
                          child: const Text(
                            'Id',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          //  color: Colors.purple,
                          width: sizeToEachRow,
                          child: const Text(
                            'Background Color',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          //  color: Colors.purple,
                          width: sizeToEachRow,
                          child: const Text(
                            'Created At',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          //  color: Colors.purple,
                          width: sizeToEachRow,
                          child: const Text(
                            'Delete',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    child: Consumer<List<Category>>(
                        builder: (context, categoryList, child) {
                      Color getColor(String value, int index) {
                        String valueString = categoryList[index]
                            .backgroundColor!
                            .split('(0x')[1]
                            .split(')')[0]; // kind of hacky..
                        int value = int.parse(valueString, radix: 16);
                        Color otherColor = Color(value);
                        return otherColor;
                      }

                      if (categoryList.isEmpty) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return ListView.builder(
                          itemCount: categoryList.length,
                          itemBuilder: (context, index) {
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
                                          (index + 1).toString(),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return StatefulBuilder(builder:
                                                    (context, setState) {
                                                  return Center(
                                                    child: Container(
                                                      width:
                                                          mediaQuery.width - 80,
                                                      child: Material(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(20.0),
                                                          child: Form(
                                                            key: _formKey2,
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                const Text(
                                                                  'Change category name',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  height: 20,
                                                                ),
                                                                TextFormField(
                                                                  initialValue:
                                                                      categoryList[
                                                                              index]
                                                                          .name!,
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    fontSize:
                                                                        18,
                                                                  ),
                                                                  cursorColor:
                                                                      Colors
                                                                          .black,
                                                                  validator:
                                                                      (value) {
                                                                    if (value!
                                                                        .isEmpty) {
                                                                      return 'Please enter category name !';
                                                                    }
                                                                    return null;
                                                                  },
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .emailAddress,
                                                                  decoration:
                                                                      const InputDecoration(
                                                                    hintText:
                                                                        'Category Name',
                                                                    floatingLabelBehavior:
                                                                        FloatingLabelBehavior
                                                                            .always,
                                                                    hintStyle: TextStyle(
                                                                        color: Colors
                                                                            .grey,
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.normal),
                                                                    filled:
                                                                        true,
                                                                    prefixIcon:
                                                                        Icon(
                                                                      Icons
                                                                          .category,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                    labelText:
                                                                        'Category Name',
                                                                    fillColor:
                                                                        Colors
                                                                            .white,
                                                                    labelStyle:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                  ),
                                                                  onSaved:
                                                                      (value) {
                                                                    changedCategoryName =
                                                                        value!;
                                                                  },
                                                                ),
                                                                const SizedBox(
                                                                  height: 20,
                                                                ),
                                                                isLoading2
                                                                    ? const CircularProgressIndicator()
                                                                    : ElevatedButton(
                                                                        onPressed:
                                                                            () async {
                                                                          if (_formKey2
                                                                              .currentState!
                                                                              .validate()) {
                                                                            _formKey2.currentState!.save();
                                                                            try {
                                                                              setState(() {
                                                                                isLoading2 = true;
                                                                              });
                                                                              await FirebaseFirestore.instance.collection('Category').doc(categoryList[index].id!).update({
                                                                                'name': changedCategoryName.trim(),
                                                                              }).then((value) {
                                                                                globalMethod.authSuccessHandle(title: 'Success!', subtitle: 'category name changed successfully.', context: context);
                                                                                setState(() {
                                                                                  isLoading2 = false;
                                                                                });
                                                                              }).catchError((error) {
                                                                                globalMethod.authErrorHandle('unable to change category name', context);
                                                                                setState(() {
                                                                                  isLoading2 = false;
                                                                                });
                                                                              });
                                                                            } catch (e) {}
                                                                          }
                                                                        },
                                                                        child: const Text(
                                                                            'Change'),
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
                                          //  color: Colors.purple,
                                          width: sizeToEachRow,
                                          child: Text(
                                            categoryList[index].name!,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return StatefulBuilder(builder:
                                                    (context, setState) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        'Change Category Image'),
                                                    content: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Container(
                                                          width: 200,
                                                          height: 200,
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                          child: newImage ==
                                                                  null
                                                              ? const Text(
                                                                  'select image',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                                )
                                                              : Image.memory(
                                                                  newImage!),
                                                        ),
                                                        const SizedBox(
                                                          height: 20,
                                                        ),
                                                        Row(
                                                          children: [
                                                            ElevatedButton(
                                                              onPressed:
                                                                  () async {
                                                                FilePickerResult?
                                                                    result =
                                                                    await FilePicker
                                                                        .platform
                                                                        .pickFiles(
                                                                  type: FileType
                                                                      .image,
                                                                  withData:
                                                                      true,
                                                                );

                                                                if (result !=
                                                                    null) {
                                                                  newImage =
                                                                      result
                                                                          .files
                                                                          .first
                                                                          .bytes;

                                                                  setState(() {
                                                                    newName = result
                                                                        .files
                                                                        .first
                                                                        .name;
                                                                  });
                                                                }
                                                              },
                                                              child: const Text(
                                                                  'Select Image'),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    actionsAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    actions: [
                                                      isLoadingImage
                                                          ? const CircularProgressIndicator()
                                                          : TextButton(
                                                              onPressed:
                                                                  () async {
                                                                if (newImage ==
                                                                    null) {
                                                                  globalMethod
                                                                      .authErrorHandle(
                                                                          'Select category image.',
                                                                          context);
                                                                } else {
                                                                  try {
                                                                    setState(
                                                                        () {
                                                                      isLoadingImage =
                                                                          true;
                                                                    });
                                                                    final imageName =
                                                                        uuid.v4();

                                                                    final ref = FirebaseStorage
                                                                        .instance
                                                                        .ref()
                                                                        .child(
                                                                            'Category')
                                                                        .child(imageName +
                                                                            '.jpg');
                                                                    await ref
                                                                        .putData(
                                                                            newImage!);
                                                                    String url =
                                                                        await ref
                                                                            .getDownloadURL();

                                                                    FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'Category')
                                                                        .doc(categoryList[index]
                                                                            .id)
                                                                        .update({
                                                                      'image':
                                                                          url,
                                                                    }).then(
                                                                            (value) {
                                                                      globalMethod.authSuccessHandle(
                                                                          title:
                                                                              'Success!',
                                                                          subtitle:
                                                                              'image changed successfully.',
                                                                          context:
                                                                              context);
                                                                      setState(
                                                                          () {
                                                                        newImage ==
                                                                            null;
                                                                        isLoadingImage =
                                                                            false;
                                                                      });
                                                                    }).catchError(
                                                                            (error) {
                                                                      globalMethod.authErrorHandle(
                                                                          'Unable to change image.',
                                                                          context);
                                                                      setState(
                                                                          () {
                                                                        newImage ==
                                                                            null;
                                                                        isLoadingImage =
                                                                            false;
                                                                      });
                                                                    });
                                                                  } catch (e) {}
                                                                }
                                                              },
                                                              child: const Text(
                                                                  'Change Image')),
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: const Text(
                                                              'Cancel')),
                                                    ],
                                                  );
                                                });
                                              });
                                        },
                                        child: Container(
                                            //  color: Colors.purple,
                                            width: sizeToEachRow,
                                            child: Image.network(
                                              categoryList[index].url!,
                                              fit: BoxFit.contain,
                                              width: 50,
                                              height: 50,
                                            )),
                                      ),
                                      Container(
                                        //  color: Colors.purple,
                                        width: sizeToEachRow,
                                        child: Text(
                                          categoryList[index].id!,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return StatefulBuilder(
                                                  builder: (context, setState) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      'Change Icon Background Color?'),
                                                  content:
                                                      SingleChildScrollView(
                                                    child: ColorPicker(
                                                      pickerColor: pickerColor,
                                                      onColorChanged:
                                                          changeColor,
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    ElevatedButton(
                                                      child:
                                                          const Text('Change'),
                                                      onPressed: () async {
                                                        setState(() =>
                                                            currentColor =
                                                                pickerColor);
                                                        try {
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'Category')
                                                              .doc(categoryList[
                                                                      index]
                                                                  .id!)
                                                              .update({
                                                            'backgroundColor':
                                                                pickerColor
                                                                    .toString(),
                                                          }).then((value) {
                                                            globalMethod.authSuccessHandle(
                                                                title:
                                                                    'Success!',
                                                                subtitle:
                                                                    'icon background color changed successfully.',
                                                                context:
                                                                    context);
                                                          }).catchError(
                                                                  (error) {
                                                            globalMethod
                                                                .authErrorHandle(
                                                                    'unable to change icon background color',
                                                                    context);
                                                          });
                                                        } catch (e) {}
                                                      },
                                                    ),
                                                    ElevatedButton(
                                                      child:
                                                          const Text('Cancel'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              });
                                            },
                                          );

                                          // globalMethod.showDialogg(
                                          //     'Change background color?',
                                          //     'Category background color will be changed.',
                                          //     () async {
                                          //
                                          //   try {
                                          //     // await FirebaseFirestore.instance
                                          //     //     .collection('Category')
                                          //     //     .doc(categoryList[index].id!)
                                          //     //     .update({
                                          //     //   'backgroundColor':
                                          //     //       pickerColor.toString(),
                                          //     // }).then((value) {
                                          //     //   globalMethod.authSuccessHandle(
                                          //     //       title: 'Success!',
                                          //     //       subtitle:
                                          //     //           'icon background color changed successfully.',
                                          //     //       context: context);
                                          //     // }).catchError((error) {
                                          //     //   globalMethod.authErrorHandle(
                                          //     //       'unable to change icon background color',
                                          //     //       context);
                                          //     // });
                                          //   } catch (e) {}
                                          // }, context);
                                        },
                                        child: Container(
                                          //  color: Colors.purple,
                                          width: sizeToEachRow,
                                          color: getColor(
                                              categoryList[index]
                                                  .backgroundColor!,
                                              index),
                                          height: 50,
                                        ),
                                      ),
                                      Container(
                                        //  color: Colors.purple,
                                        width: sizeToEachRow,
                                        child: Text(
                                          formatTimestamp(
                                              categoryList[index].createdAt!),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          globalMethod.showDialogg(
                                              'Delete Category?',
                                              'delete category ${categoryList[index].name!}',
                                              () async {
                                            await FirebaseFirestore.instance
                                                .collection('Category')
                                                .doc(categoryList[index].id!)
                                                .delete()
                                                .then((value) {
                                              globalMethod.authSuccessHandle(
                                                  title: 'Success',
                                                  subtitle:
                                                      'category deleted successfully.',
                                                  context: context);
                                            }).catchError((error) {
                                              globalMethod.authErrorHandle(
                                                  'unable to delete category',
                                                  context);
                                            });
                                          }, context);
                                        },
                                        child: Container(
                                          //  color: Colors.purple,
                                          width: sizeToEachRow,
                                          child: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
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
                    }),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
