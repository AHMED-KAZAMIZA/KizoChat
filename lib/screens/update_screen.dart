import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:get/get.dart';
import '../components.dart';
import '../controller.dart';

class UpdateScreen extends StatefulWidget {
  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  
  final Controller controller = Get.put(Controller());
  final picker = ImagePicker();
  var nameController = TextEditingController();
  var statusController = TextEditingController();
  String imageLink = '', imageURL = '';
  bool isImageSelected = false;
  dynamic imageFile;
  
  // this code takes an image from the phone gallery
   getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if(pickedFile != null) {
      setState(() {
         imageFile = File(pickedFile.path);
         isImageSelected = true;
      });
    }  }

  // this code checks the internet connection
  

  //  @override
  // void initState() {
  //  controller.checkInternetConnection();
  //   super.initState();
  // }


  void uploadImage() {
      // this code uploads the image path to the users folder in the storage section in firebase
    firebase_storage.FirebaseStorage.instance.ref().child(
      'users/${Uri.file(imageFile.path).pathSegments.last}'
      ).putFile(imageFile)
      .then(
        (value) { 
          value.ref.getDownloadURL().then((link) {
          setState(() {
            imageLink = link;
          });
            
            print('Image link is : $imageLink');
            
        });
        }
        ).catchError((linkError) => print('There are some errors in image link : $linkError'))
         .catchError((error) => print('There are errors : $error'));
  
  }


  @override
  Widget build(BuildContext context) {
    controller.checkInternetConnection();
    return Scaffold(
      appBar: AppBar(
        foregroundColor: (controller.isDarkMode.value) ? Colors.white : Colors.black,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: const Text('Update Account'),
      ),
      body:  StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').where('email', isEqualTo: userEmail).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return   ListView(
              physics: const BouncingScrollPhysics(),
              children: snapshot.data!.docs.map((document) {
                return Padding(
                      padding: const EdgeInsets.symmetric( vertical: 20.0),
                      child: Column(
                        children: [
                          Stack(
                                alignment: Alignment.topCenter,
                                children: [
                                  
                                  Container(
                                  margin: const EdgeInsets.all(15),
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: (imageFile == null) ? Image.network(theImage) : Image.file(imageFile),
                                  ),
                    
                                  GestureDetector(
                                    onTap: () { getImageFromGallery(); },
                                    child: CircleAvatar(
                                      backgroundColor: Colors.purple,
                                      child: Icon(Icons.photo, color: Colors.white,),
                                    ),
                                  ),
                                ]
                              ),
                    
                          Input(
                            text: 'Name',
                            icon: const Icon(Icons.person), 
                            isHidden: false,
                            controller: nameController
                          ),
                    
                          Input(
                            text: 'Status',
                            icon: const Icon(Icons.short_text),
                            isHidden: false,
                            controller: statusController
                          ),
                  
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: MaterialButton(
                              shape: const StadiumBorder(),
                              color: Colors.purple,
                              minWidth: 180,
                              padding: const EdgeInsets.symmetric( vertical: 15),
                              child: const Text('Update', style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                              ),),
                              onPressed: () {
                                if(controller.isInternetConnected) {

                                if(!isImageSelected && nameController.text.isEmpty && statusController.text.isEmpty) {
                                  showMessage(
                                    'Cannot update your data, fields should not be empty', 
                                    Colors.purple
                                    );
                                }  else if(isImageSelected) {
                                      firebase_storage.FirebaseStorage.instance.ref().child(
      'users/${Uri.file(imageFile.path).pathSegments.last}'
      ).putFile(imageFile)
      .then(
        (value) {
          value.ref.getDownloadURL().then((link) {
                      imageLink = link;
                       print('image link after pressing the button is : $imageLink');
                  FirebaseFirestore.instance.collection('users')
                                .doc(document.id).update({
                                  'image': imageLink,
                                  'username': (nameController.text.isNotEmpty) ? nameController.text : document['username'],
                                  'status': (statusController.text.isNotEmpty) ? statusController.text : document['status']
                                }).then(
                                  (value) => showMessage(
                                    'Data has been updated successfully', 
                                    Colors.green
                                    )).catchError((error) => showMessage(
                                      'Cannot update profile image',
                                      Colors.purple
                                      ));
                                })
      .catchError((error) => print('There are errors : $error'));

          }).catchError((err) {

          });

        }  else if(!isImageSelected && (nameController.text.isNotEmpty || statusController.text.isNotEmpty )) {
           
            FirebaseFirestore.instance.collection('users').doc(document.id).update(
                                  {
                                  'username': (nameController.text.isNotEmpty) ? nameController.text : document['username'],
                                  'status': (statusController.text.isNotEmpty) ? statusController.text : document['status'],
                                }).then(
                                  (value) => showMessage(
                                    'Data has been updated successfully',
                                    Colors.green
                                    )).catchError((error) => showMessage(
                                      'Cannot update data',
                                      Colors.purple
                                      ));

        }
            } else {
              showMessage('No Internet Connection', Colors.purple);
            }
        }  ),
                          )
                        ],
                      ),
                    );

              },).toList()
             
            );

        },
      )
    );
  }
}