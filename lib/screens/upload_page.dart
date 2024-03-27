import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:appwrite/appwrite.dart';
import 'package:path/path.dart';
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
  List<dynamic> _top3Predictions = [];

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

  Future<void> uploadImageToRoboflow(String filePath) async {

  const apiKey = roboflowApiKey;
  
   // Encode the image file in base64
  File imageFile = File(filePath);
  List<int> imageBytes= await imageFile.readAsBytes();
  String base64Image = base64.encode(imageBytes);

  var uploadURL = Uri.parse("https://2578-203-217-129-139.ngrok-free.app/skin-classification4/5?api_key=$apiKey");

  // Send the request
  var response = await http.post(
    uploadURL,
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: base64Image,
  );


  // Check the response and print it
  if (response.statusCode == 200) {
    print('Upload successful');
    var responseJson = response.body;
    
    Map<String, dynamic> jsonResponse = json.decode(responseJson);

    List<dynamic> predictions = jsonResponse['predictions'];
    
    predictions.sort((a, b) => b['confidence'].compareTo(a['confidence']));

    List<dynamic> top3Predictions = predictions.take(3).toList();

    setState(() {
      _top3Predictions = top3Predictions;
    });
  } else {
    print('Failed to upload image. Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    
  }

  }

  Future<void> uploadImageToAppwrite(String filePath) async {

  try {
    Storage storage = Storage(client);
    var response = await storage.createFile(
      bucketId: BUCKET_ID,
      fileId: 'unique()',
      file: InputFile.fromPath(
        path: filePath,
        filename: basename(filePath),
      ),
    );


    print('File uploaded: ${response.toString()}'); 
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
              ? Column(
                  children: [
                    Image.file(
                      File(_imageFile!.path),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Top 3 Predictions:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Column(
                      children: _top3Predictions.map((prediction) {
                        double confidence = prediction['confidence'] * 100;
                        String shorterConfidence = confidence.toStringAsFixed(2);
                        return Text(
                          'Class: ${prediction['class']}, Confidence: $shorterConfidence%',
                          style: TextStyle(fontSize: 20),
                        );
                      }).toList(),
                    ),
                  ],
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
              foregroundColor: Colors.white,
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
              foregroundColor: Colors.white,
            ),
            child: const Text('Take Photo'),
          ),
        ],
      ),
    ),
  );
}
}
