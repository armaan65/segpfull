import 'package:flutter/material.dart';
import 'package:segpnew/screens/chat.dart';
import 'package:appwrite/appwrite.dart';
import 'package:segpnew/appwrite/auth_api.dart';
import 'package:segpnew/screens/login_page.dart';
import 'package:segpnew/screens/register_page.dart';
import 'package:segpnew/screens/scorten.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CreateProfile extends StatefulWidget {
  const CreateProfile({Key? key}) : super(key:key);

  @override
  _CreateProfileState createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  File? profileImage;

  //Creating global key that identifies Form widget and allows validation of form
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create your profile'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Form (
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: firstNameController,
                  decoration: const InputDecoration(
                    labelText: 'First name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  //Checking if input is empty
                  validator: (value) {
                    if (value == null || value.isEmpty){
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
            
                const SizedBox(height: 16),
                TextFormField(
                  controller: lastNameController,
                  decoration: const InputDecoration(
                    labelText: 'Last name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value){
                    if (value == null || value.isEmpty){
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                ),
            
                const SizedBox(height: 16),
            
                //Image picker widget
                GestureDetector(
                  onTap: () async{
                    final ImagePicker _picker = ImagePicker();
                    //Show two options Gallery and Camera
                    await showModalBottomSheet(
                      context: context, 
                      builder: (context){
                        return Wrap(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.photo_library),
                              title: const Text('Gallery'),
                              onTap: () async {
                                //Get image from gallery
                                final XFile? xfile = await _picker.pickImage(source: ImageSource.gallery);
                                //Convert XFile into file
                                final File? file = xfile != null ? File(xfile.path) : null;
                                //Assign image to profileImage
                                setState(() {
                                  profileImage = file;
                                });
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.camera_alt),
                              title: const Text('Camera'),
                              onTap: () async {
                                //Get image from camera
                                final XFile? xfile = await _picker.pickImage(source: ImageSource.camera);
                                final File? file = xfile != null? File(xfile.path) : null;
                                //Assign image to profileImage
                                setState(() {
                                  profileImage = file;
                                });
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                      );
                  },
            
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[200],
                      ),
                      child: profileImage != null
                      ? ClipOval(
                        child: Image.file(
                          profileImage!,
                          fit: BoxFit.cover,
                        ),
                      )
                      : const Icon(
                        Icons.camera_alt,
                        size: 50,
                        ),
                      ),
            
                  
                ),
            
                const SizedBox(height: 16),
            
                ElevatedButton(
                  child: const Text('Next'),
                  onPressed: () {
                    if (_formKey.currentState != null && _formKey.currentState!.validate()){

                      //Add the database logic here

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ScortenCalculatorPage()),
                      );
                    }
                  },
                  )
            
            
            
              ],
            ),
        ), 
        ),
      ),
    );
  }

}