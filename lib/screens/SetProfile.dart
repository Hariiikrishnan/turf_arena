import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:turf_arena/constants.dart';
// import 'package:firebase_storage/firebase_storage.dart';

class SetProfile extends StatefulWidget {
  const SetProfile({super.key});

  @override
  State<SetProfile> createState() => _SetProfileState();
}

class _SetProfileState extends State<SetProfile> {
  File? _image;

  var imageName = DateTime.now().millisecondsSinceEpoch.toString();
// var storageRef = FirebaseStorage.instance.ref().child('driver_images/$imageName.jpg');
// var uploadTask = storageRef.putFile(_image!);
// var downloadUrl = await (await uploadTask).ref.getDownloadURL();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 200.0,
              // height: 400.0,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 200.0,
                    backgroundColor: whiteColor,
                    backgroundImage: _image == null
                        ? null
                        : FileImage(
                            _image!), // Use FileImage if _image is a File
                    child: _image == null
                        ? Icon(
                            Icons.person,
                            size: 130.0,
                          )
                        : null,
                  ),
                  Align(
                    heightFactor: 6.2,
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          side: BorderSide(
                            width: 1.0,
                            color: whiteColor,
                          )),
                      onPressed: () async {
                        final image = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          setState(() {
                            _image = File(image.path);
                          });
                        }
                      },
                      child: Icon(
                        Icons.edit,
                        color: whiteColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: whiteColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    12.0,
                  ),
                ),
              ),
              onPressed: () {},
              child: Text(
                'Add Profile ',
                style: TextStyle(
                  fontSize: 18.0,
                  color: primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
