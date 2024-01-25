import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image'),
        backgroundColor: Color(0xFF53CADA),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _imageFile != null
                ? Image.file(
                    File(_imageFile!.path),
                  )
                : Text('No image selected.'),
            ElevatedButton(
              onPressed: () async {
                final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                setState(() {
                  if (pickedFile != null) {
                    _imageFile = pickedFile;
                  } else {
                    print('No image selected.');
                  }
                });
              },
              child: Text('Select Image'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF53CADA),
                foregroundColor: Colors.white
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final pickedFile = await _picker.pickImage(source: ImageSource.camera);
                setState(() {
                  if (pickedFile != null) {
                    _imageFile = pickedFile;
                  } else {
                    print('No image selected.');
                  }
                });
              },
              child: Text('Take Photo'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF53CADA),
                foregroundColor: Colors.white
              ),
            ),
          ],
        ),
      ),
    );
  }
}
