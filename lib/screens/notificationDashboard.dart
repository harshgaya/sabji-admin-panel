import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../global_method.dart';

class NotificationDashboard extends StatefulWidget {
  const NotificationDashboard({Key? key}) : super(key: key);

  @override
  State<NotificationDashboard> createState() => _NotificationDashboardState();
}

class _NotificationDashboardState extends State<NotificationDashboard> {
  final _formKey = GlobalKey<FormState>();
  String notificationTitle = '';
  String notificationSubtitle = '';
  Uint8List? image;
  final notificationTitleController = TextEditingController();
  final notificationSubtitleController = TextEditingController();
  GlobalMethod globalMethod = GlobalMethod();
  bool isLoading = false;
  var uuid = const Uuid();

  void _pickImageGallery() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result != null) {
      setState(() {
        image = result.files.first.bytes;
      });
    }
  }

  Future<void> submitNotification() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (image == null) {
        globalMethod.authErrorHandle('Please add image.', context);
      } else {
        setState(() {
          isLoading = true;
        });
        try {
          final imageName = uuid.v4();

          final ref = FirebaseStorage.instance
              .ref()
              .child('notificationImages')
              .child(imageName + '.jpg');
          await ref.putData(image!);
          var url = await ref.getDownloadURL();
          final notificationId = uuid.v4();
          FirebaseFirestore.instance
              .collection('notification')
              .doc(notificationId)
              .set({
            'id': notificationId,
            'title': notificationTitleController.text.trim(),
            'subtitle': notificationSubtitleController.text.trim(),
            'image': url,
          }).then((value) {
            globalMethod.authSuccessHandle(
                title: 'Success!',
                subtitle: 'Notification sent successfully.',
                context: context);
            setState(() {
              isLoading = false;
              notificationSubtitleController.text = '';
              notificationTitleController.text = '';
              image = null;
            });
          }).catchError((error) {
            globalMethod.authErrorHandle(
                'Unable to send notification.', context);
            setState(() {
              isLoading = false;
            });
          });
        } catch (e) {}
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            // const Text(
            //   'Notification',
            //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            // ),
            // const SizedBox(
            //   height: 20,
            // ),
            TextFormField(
              controller: notificationTitleController,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter notification title!';
                }
                return null;
              },
              decoration: const InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
                filled: true,
                prefixIcon: Icon(
                  Icons.title,
                  color: Colors.black,
                ),
                labelText: 'Notification Title',
                fillColor: Colors.white,
                hintText: 'Notification Title',
                labelStyle: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: notificationSubtitleController,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter notification title!';
                }
                return null;
              },
              decoration: const InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
                filled: true,
                prefixIcon: Icon(
                  Icons.subtitles,
                  color: Colors.black,
                ),
                labelText: 'Notification Subtitle',
                fillColor: Colors.white,
                hintText: 'Notification Subtitle',
                labelStyle: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.circular(2)),
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FittedBox(
                      child: TextButton.icon(
                        onPressed: _pickImageGallery,
                        icon:
                            const Icon(Icons.image, color: Colors.purpleAccent),
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
            const SizedBox(
              height: 20,
            ),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () {
                      submitNotification();
                    },
                    child: const Text('Send Notification'),
                  ),
          ],
        ),
      ),
    );
  }
}
