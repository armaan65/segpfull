import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:appwrite/appwrite.dart';
import 'package:path/path.dart'; // If you need to use basename() for filenames
import 'package:segpnew/constants/constants.dart';


class UploadPage extends StatefulWidget {
  const UploadPage({Key? key}) : super(key: key);
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  late Client client;

  @override
  void initState() {
  super.initState();
  initAppwrite();
}

  void initAppwrite() {
    client = Client()
      .setEndpoint(APPWRITE_URL) // Your Appwrite Endpoint
      .setProject(APPWRITE_PROJECT_ID) // Your project ID
      .setSelfSigned(); // Adjust based on your SSL setup
  }

 /* Future<File?> compressImage(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 50,
      minWidth: 1024,
      minHeight: 768,
      );
      return result;
  }*/

  Future<void> uploadImageToRoboflow(String filePath) async {

  const apiKey = roboflowApiKey;
  
   // Encode the image file in base64
  var file = File(filePath);
  var bytes = await file.readAsBytes();
  var base64Image = base64Encode(bytes);

  var encodedBase64Image = Uri.encodeComponent(base64Image);

  // Construct the URL (assuming 'name' is a required query parameter)
  var uploadURL = Uri.parse("https://2578-203-217-129-139.ngrok-free.app/skin-classification4/5?api_key=$apiKey&image=$encodedBase64Image");

  // Send the request
  var response = await http.post(
    uploadURL,
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: {},
  );

  // Check the response and print it
  if (response.statusCode == 200) {
    print('Upload successful');
    print('Response from Roboflow: ${response.body}');
  } else {
    print('Failed to upload image. Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
  }


  }

  Future<void> uploadImageToAppwrite(String filePath) async {

  try {
    Storage storage = Storage(client); // Assuming 'client' is already correctly initialized
    var response = await storage.createFile(
      bucketId: BUCKET_ID,
      fileId: 'unique()', // Automatically generates a unique ID
      file: InputFile.fromPath(
        path: filePath,
        filename: basename(filePath), // Assuming you've imported 'package:path/path.dart'
      ),
    );

    // Now 'response' holds the Response<dynamic> object returned by createFile
    print('File uploaded: ${response.toString()}'); // Correct use of the response
  } catch (e) {
    print('Error uploading file: $e');
  }
}


@override
Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Image'),
        backgroundColor: const Color(0xFF53CADA),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _imageFile != null
                ? Image.file(
                    File(_imageFile!.path),
                  )
                : const Text('No image selected.'),
            ElevatedButton(
              onPressed: () async {
                final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                setState(() {
                  if (pickedFile != null) {
                    _imageFile = pickedFile;
                    uploadImageToAppwrite(pickedFile.path);
                    uploadImageToRoboflow(pickedFile.path);
                  } else {
                    print('No image selected.');
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF53CADA),
                foregroundColor: Colors.white
              ),
              child: const Text('Select Image'),
            ),
            ElevatedButton(
              onPressed: () async {
                final pickedFile = await _picker.pickImage(source: ImageSource.camera);
                setState(() {
                  if (pickedFile != null) {
                    _imageFile = pickedFile;
                    uploadImageToAppwrite(pickedFile.path);
                    uploadImageToRoboflow(pickedFile.path);
                  } else {
                    print('No image selected.');
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF53CADA),
                foregroundColor: Colors.white
              ),
              child: const Text('Take Photo'),
            ),
          ],
        ),
      ),
    );
  }
}


/*
Future<void> uploadImageToRoboflow(String filePath) async {
  var uri = Uri.parse('http://detect.roboflow.com/skin-classification4/5');
  var request = http.MultipartRequest('POST', uri)
    ..fields['api_key'] = API_KEY // Replace with your actual API key
    ..files.add(await http.MultipartFile.fromPath('file', filePath, filename: basename(filePath)));

  http.StreamedResponse streamedResponse = await request.send();
  int redirectCount = 0;

  // Follow redirects up to 5 times to avoid infinite loops
  while (streamedResponse.isRedirect && redirectCount < 5) {
    String? location = streamedResponse.headers['location'];
    if (location != null) {
      uri = Uri.parse(location);
      request = http.MultipartRequest('POST', uri)
        ..fields['api_key'] = 'YOUR_API_KEY' // Replace with your actual API key
        ..files.clear() // Clear previous files
        ..files.add(await http.MultipartFile.fromPath('file', filePath, filename: basename(filePath)));
      streamedResponse = await request.send();
    }
    redirectCount++;
  }

  // Check the final response
  if (streamedResponse.statusCode == 200) {
    print('File uploaded successfully.');
    // You can use http.Response.fromStream(streamedResponse) to read the body if needed
  } else {
    print('Request failed after following redirects with status: ${streamedResponse.statusCode}.');
    // Optionally, read the response body for more details
    final responseBody = await http.Response.fromStream(streamedResponse);
    print('Response body: ${responseBody.body}');
  }
}*/

  /*var request = http.MultipartRequest('POST', Uri.parse(roboflowUploadEndpoint));
  request.files.add(await http.MultipartFile.fromPath('_imageFile', filePath));
  request.headers.addAll({
    'Authorization': 'Bearer $roboflowApiKey'
    });

  var response = await request.send();

  if (response.statusCode == 200) {
    print('Upload successful');
  } else {
    print('Upload failed');
  }
  }*/