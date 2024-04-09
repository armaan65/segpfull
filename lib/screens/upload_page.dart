import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:appwrite/appwrite.dart';
import 'package:segpnew/basePage.dart';
import 'package:path/path.dart';
import 'package:segpnew/constants/constants.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


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
  bool _isLoading = false;
  final Color primaryColor = Color (0xFF53CADA);

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

  var uploadURL = Uri.parse("https://raptor-trusting-pleasantly.ngrok-free.app/skin-classification4/5?api_key=$apiKey");

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
        backgroundColor: primaryColor,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0), // Add spacing around your elements
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20),
              _imageFile != null
                  ? Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                              ),
                            ],
                            shape: BoxShape.circle, // Display the image in a circular shape
                          ),
                          child: ClipOval( // Clip the image to a circle
                            child: Image.file(
                              File(_imageFile!.path),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Top 3 Predictions:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Column(
                          children: _top3Predictions.map((prediction) {
                            double confidence = prediction['confidence'] * 100;
                            String shorterConfidence =
                                confidence.toStringAsFixed(2);
                            return Text(
                              'Class: ${prediction['class']}, Confidence: $shorterConfidence%',
                              style: TextStyle(fontSize: 20),
                            );
                          }).toList(),
                        ),
                      ],
                    )
                  : _isLoading
                      ? SpinKitCircle(color: primaryColor)
                      : const Text('No image selected.'),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget> [

                  ElevatedButton(
                    onPressed: () async {
                      final pickedFile =
                          await _picker.pickImage(source: ImageSource.gallery);
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
                      backgroundColor: Color(0xFF53CADA),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      elevation: 5, //Shadow effect
                    ),
                    child: const Icon(Icons.photo_library),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      final pickedFile =
                          await _picker.pickImage(source: ImageSource.camera);
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
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      elevation: 5,
                    ),
                    child: const Icon(Icons.camera_alt),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => BasePage(),
                        ),
                      );
                    },
                    child: Icon(Icons.arrow_forward),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor, // Dark blue button
                      foregroundColor: Colors.white, // White text on button
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}