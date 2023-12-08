import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:uuid/uuid.dart';
import '../responsive_helper.dart';
import '../global_method.dart';

class SliderDashboard extends StatefulWidget {
  static const routeName = '/SliderDashboard';

  @override
  State<SliderDashboard> createState() => _SliderDashboardState();
}

class _SliderDashboardState extends State<SliderDashboard> {
  GlobalMethod _globalMethods = GlobalMethod();
  var uuid = Uuid();
  late Stream<QuerySnapshot> stream;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    stream = FirebaseFirestore.instance.collection("Banners").snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: StreamBuilder<QuerySnapshot>(
          stream: stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              );
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text('Error Occurred'),
              );
            }

            final images = snapshot.data!.docs;
            return ResponsiveDesign(
              desktop: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Stack(
                        children: [
                          SizedBox(
                            height: 270,
                            width: 540,
                            child: Image.network(
                              images[index].get('image'),
                              fit: BoxFit.contain,
                            ),
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: InkWell(
                              onTap: () {
                                try {
                                  _globalMethods.showDialogg(
                                      'Delete this banner ?',
                                      'Banner will be deleted.', () async {
                                    await FirebaseFirestore.instance
                                        .collection('Banners')
                                        .doc(images[index].get('id'))
                                        .delete()
                                        .then((value) {
                                      _globalMethods.authSuccessHandle(
                                          title: 'Success!',
                                          subtitle:
                                              'Banner deleted successfully.',
                                          context: context);
                                    }).catchError((error) {
                                      _globalMethods.authErrorHandle(
                                          'Unable to delete this banner.',
                                          context);
                                    });
                                  }, context);
                                } catch (e) {}
                              },
                              child: const CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  )),
                            ),
                          ),
                          Positioned(
                            top: 50,
                            right: 0,
                            child: InkWell(
                              onTap: () {
                                _globalMethods.showDialogg('Add new Banner?',
                                    'A new banner will be added.', () async {
                                  try {
                                    context.loaderOverlay.show();
                                    FilePickerResult? result =
                                        await FilePicker.platform.pickFiles(
                                      type: FileType.image,
                                      withData: true,
                                    );

                                    if (result != null) {
                                      Uint8List? fileBytes =
                                          result.files.first.bytes;
                                      // String fileName = result.files.first.name;
                                      final imageName = uuid.v4();

                                      final ref = FirebaseStorage.instance
                                          .ref()
                                          .child('SliderImages')
                                          .child(imageName + '.jpg');
                                      await ref.putData(fileBytes!);
                                      String url = await ref.getDownloadURL();

                                      FirebaseFirestore.instance
                                          .collection('Banners')
                                          .doc(imageName)
                                          .set({
                                        'image': url,
                                        'id': imageName
                                      }).then((value) {
                                        _globalMethods.authSuccessHandle(
                                            title: 'Success!',
                                            subtitle:
                                                'New banner added successfully.',
                                            context: context);
                                        context.loaderOverlay.hide();
                                      }).catchError((error) {
                                        _globalMethods.authErrorHandle(
                                            'Unable to add banner.', context);
                                        context.loaderOverlay.hide();
                                      });
                                    }
                                  } catch (e) {}
                                }, context);
                              },
                              child: const CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.green,
                                  )),
                            ),
                          )
                        ],
                      ),
                    );
                  }),
              mobile: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Stack(
                        children: [
                          SizedBox(
                            height: 140,
                            width: 300,
                            child: Image.network(
                              images[index].get('image'),
                              fit: BoxFit.contain,
                            ),
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: InkWell(
                              onTap: () {
                                try {
                                  _globalMethods.showDialogg(
                                      'Delete this banner ?',
                                      'Banner will be deleted.', () async {
                                    await FirebaseFirestore.instance
                                        .collection('Banners')
                                        .doc(images[index].get('id'))
                                        .delete()
                                        .then((value) {
                                      _globalMethods.authSuccessHandle(
                                          title: 'Success!',
                                          subtitle:
                                              'Banner deleted successfully.',
                                          context: context);
                                    }).catchError((error) {
                                      _globalMethods.authErrorHandle(
                                          'Unable to delete this banner.',
                                          context);
                                    });
                                  }, context);
                                } catch (e) {}
                              },
                              child: const CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  )),
                            ),
                          ),
                          Positioned(
                            top: 50,
                            right: 0,
                            child: InkWell(
                              onTap: () {
                                _globalMethods.showDialogg('Add new Banner?',
                                    'A new banner will be added.', () async {
                                  try {
                                    context.loaderOverlay.show();
                                    FilePickerResult? result =
                                        await FilePicker.platform.pickFiles(
                                      type: FileType.image,
                                      withData: true,
                                    );

                                    if (result != null) {
                                      Uint8List? fileBytes =
                                          result.files.first.bytes;
                                      // String fileName = result.files.first.name;
                                      final imageName = uuid.v4();

                                      final ref = FirebaseStorage.instance
                                          .ref()
                                          .child('SliderImages')
                                          .child(imageName + '.jpg');
                                      await ref.putData(fileBytes!);
                                      String url = await ref.getDownloadURL();

                                      FirebaseFirestore.instance
                                          .collection('Banners')
                                          .doc(imageName)
                                          .set({
                                        'image': url,
                                        'id': imageName
                                      }).then((value) {
                                        _globalMethods.authSuccessHandle(
                                            title: 'Success!',
                                            subtitle:
                                                'New banner added successfully.',
                                            context: context);
                                        context.loaderOverlay.hide();
                                      }).catchError((error) {
                                        _globalMethods.authErrorHandle(
                                            'Unable to add banner.', context);
                                        context.loaderOverlay.hide();
                                      });
                                    }
                                  } catch (e) {}
                                }, context);
                              },
                              child: const CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.green,
                                  )),
                            ),
                          )
                        ],
                      ),
                    );
                  }),
            );
          }),
    );

    //   Provider.of<SliderProvider>(context).getSliders.isEmpty?Scaffold(body: SafeArea(child: Container(child: Text('Loading..'),)),)
    //       :Scaffold(
    //   bottomSheet: Container(
    //     height: kBottomNavigationBarHeight * 0.8,
    //     width: double.infinity,
    //     decoration: BoxDecoration(
    //       color: Colors.white,
    //       border: Border(
    //         top: BorderSide(
    //           color: Colors.grey,
    //           width: 0.5,
    //         ),
    //       ),
    //     ),
    //     child: Material(
    //       color: Theme.of(context).backgroundColor,
    //       child:_isLoading
    //           ? Center(
    //           child: Container(
    //               height: 40,
    //               width: 40,
    //               child: CircularProgressIndicator()))
    //           : InkWell(
    //         onTap: _trySubmit,
    //         splashColor: Colors.grey,
    //         child: Row(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           mainAxisSize: MainAxisSize.max,
    //           children: <Widget>[
    //             Padding(
    //               padding: const EdgeInsets.only(right: 2),
    //               child:  Text('Update',
    //                   style: TextStyle(fontSize: 16),
    //                   textAlign: TextAlign.center),
    //             ),
    //             GradientIcon(
    //               FontAwesomeIcons.upload,
    //               20,
    //               LinearGradient(
    //                 colors: <Color>[
    //                   Colors.green,
    //                   Colors.yellow,
    //                   Colors.deepOrange,
    //                   Colors.orange,
    //                   Colors.yellow[800]!
    //                 ],
    //                 begin: Alignment.topLeft,
    //                 end: Alignment.bottomRight,
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    //   body: SafeArea(
    //     child: SingleChildScrollView(
    //       child: Padding(
    //         padding: const EdgeInsets.all(8.0),
    //         child: Column(
    //           children: [
    //             Row(
    //               mainAxisAlignment: MainAxisAlignment.start,
    //               children: <Widget>[
    //                 Expanded(
    //                   // flex: 1,
    //                   child:  Container(
    //                     margin: EdgeInsets.all(10),
    //                     height: 200,
    //                     width: 200,
    //                     child: Container(
    //                       height: 200,
    //
    //                       // width: 200,
    //                       decoration: BoxDecoration(
    //                         border: Border.all(width: 1),
    //                         borderRadius: BorderRadius.circular(4),
    //                         // borderRadius: BorderRadius.only(
    //                         //   topLeft: const Radius.circular(40.0),
    //                         // ),
    //                         color:
    //                         Theme.of(context).backgroundColor,
    //                       ),
    //                       child: Image.network(
    //                        url1==null? Provider.of<SliderProvider>(context,listen: false).getSliders.elementAt(0).image1:url1!,
    //                         fit: BoxFit.contain,
    //                         alignment: Alignment.center,
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //                 Column(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   children: [
    //                     isUploading?Text('Uploading..') :FittedBox(
    //                       child: TextButton.icon(
    //
    //                         onPressed: _pickImageGallery1,
    //                         icon: Icon(Icons.image,
    //                             color: Colors.purpleAccent),
    //                         label: Text(
    //                           'Gallery',
    //                           style: TextStyle(
    //                             fontWeight: FontWeight.w500,
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ],
    //             ),
    //             Row(
    //               mainAxisAlignment: MainAxisAlignment.start,
    //               children: <Widget>[
    //                 Expanded(
    //                   //  flex: 2,
    //                   child:  Container(
    //                     margin: EdgeInsets.all(10),
    //                     height: 200,
    //                     width: 200,
    //                     child: Container(
    //                       height: 200,
    //                       // width: 200,
    //                       decoration: BoxDecoration(
    //                         border: Border.all(width: 1),
    //                         borderRadius: BorderRadius.circular(4),
    //                         // borderRadius: BorderRadius.only(
    //                         //   topLeft: const Radius.circular(40.0),
    //                         // ),
    //                         color:
    //                         Theme.of(context).backgroundColor,
    //                       ),
    //                       child: Image.network(
    //                        url2==null? Provider.of<SliderProvider>(context,listen: false).getSliders.elementAt(0).image2:url2!,
    //                         fit: BoxFit.contain,
    //                         alignment: Alignment.center,
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //                 Column(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   children: [
    //                     isUploading?Text('Uploading..') :FittedBox(
    //                       child: TextButton.icon(
    //                         onPressed: _pickImageGallery2,
    //                         icon: Icon(Icons.image,
    //                             color: Colors.purpleAccent),
    //                         label: Text(
    //                           'Gallery',
    //                           style: TextStyle(
    //                             fontWeight: FontWeight.w500,
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ],
    //             ),
    //             Row(
    //               mainAxisAlignment: MainAxisAlignment.start,
    //               children: <Widget>[
    //                 Expanded(
    //                   //  flex: 2,
    //                   child: Container(
    //                     margin: EdgeInsets.all(10),
    //                     height: 200,
    //                     width: 200,
    //                     child: Container(
    //                       height: 200,
    //                       // width: 200,
    //                       decoration: BoxDecoration(
    //                         border: Border.all(width: 1),
    //                         borderRadius: BorderRadius.circular(4),
    //                         // borderRadius: BorderRadius.only(
    //                         //   topLeft: const Radius.circular(40.0),
    //                         // ),
    //                         color:
    //                         Theme.of(context).backgroundColor,
    //                       ),
    //                       child: Image.network(
    //                        url3==null? Provider.of<SliderProvider>(context,listen: false).getSliders.elementAt(0).image3:url3!,
    //                         fit: BoxFit.contain,
    //                         alignment: Alignment.center,
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //                 Column(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   children: [
    //                     isUploading?Text('Uploading..') :FittedBox(
    //                       child: TextButton.icon(
    //                         onPressed: _pickImageGallery3,
    //                         icon: Icon(Icons.image,
    //                             color: Colors.purpleAccent),
    //                         label: Text(
    //                           'Gallery',
    //                           style: TextStyle(
    //                             fontWeight: FontWeight.w500,
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ],
    //             ),
    //             Row(
    //               mainAxisAlignment: MainAxisAlignment.start,
    //               children: <Widget>[
    //                 Expanded(
    //                   //  flex: 2,
    //                   child:  Container(
    //                     margin: EdgeInsets.all(10),
    //                     height: 200,
    //                     width: 200,
    //                     child: Container(
    //                       height: 200,
    //                       // width: 200,
    //                       decoration: BoxDecoration(
    //                         border: Border.all(width: 1),
    //                         borderRadius: BorderRadius.circular(4),
    //                         // borderRadius: BorderRadius.only(
    //                         //   topLeft: const Radius.circular(40.0),
    //                         // ),
    //                         color:
    //                         Theme.of(context).backgroundColor,
    //                       ),
    //                       child: Image.network(
    //                       url4==null?  Provider.of<SliderProvider>(context,listen: false).getSliders.elementAt(0).image4:url4!,
    //                         fit: BoxFit.contain,
    //                         alignment: Alignment.center,
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //                 Column(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   children: [
    //                     isUploading?Text('Uploading..') :FittedBox(
    //                       child: TextButton.icon(
    //
    //                         onPressed: _pickImageGallery4,
    //                         icon: Icon(Icons.image,
    //                             color: Colors.purpleAccent),
    //                         label: Text(
    //                           'Gallery',
    //                           style: TextStyle(
    //                             fontWeight: FontWeight.w500,
    //
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ],
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}
