import 'package:flutter/material.dart';
import 'package:segpnew/screens/chat.dart';
import 'package:appwrite/appwrite.dart';
import 'package:segpnew/appwrite/auth_api.dart';
import 'package:segpnew/screens/login_page.dart';
import 'package:segpnew/screens/register_page.dart';
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

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create your profile'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: firstNameController,
                decoration: const InputDecoration(
                  labelText: 'First name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),

              const SizedBox(height: 16),
              TextField(
                controller: lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Last name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
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

                
              )



            ],
          ), 
        ),
      ),
    );
  }

}