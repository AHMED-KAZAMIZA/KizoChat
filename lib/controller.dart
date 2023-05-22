import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:get/get.dart';
import 'package:kizochat/message_model.dart';
import 'package:kizochat/screens/home_screen.dart';
import 'package:kizochat/screens/login_screen.dart';
import 'package:kizochat/user_model.dart';
import 'components.dart';

class Controller extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getAllNumbers();
    
  }
  static FirebaseAuth auth = FirebaseAuth.instance;

  var user = auth.currentUser;
  var appMode = ThemeData.light().obs;

  var isPassword1Hidden = true.obs;
  var isPassword2Hidden = true.obs;
  var isPassword3Hidden = true.obs;
  var isDarkMode = false.obs;
  var isFound = false.obs;
  var ids = [], numbers = [], names = [], images = [], status = [];
  var personId = ''.obs, 
      personName = ''.obs, 
      personNumber = ''.obs, 
      personImage = ''.obs,
      personStatus = ''.obs;

   UserModel um = UserModel();


  make1Visible() {
    isPassword1Hidden.value = true;
  }

  make1Hidden() {
    isPassword1Hidden.value = false;
  }

  make2Visible() {
    isPassword2Hidden.value = true;
  }

  make2Hidden() {
    isPassword2Hidden.value = false;
  }

  make3Visible() {
    isPassword3Hidden.value = true;
  }

  make3Hidden() {
    isPassword3Hidden.value = false;
  }

  enableDarkMode() {
    isDarkMode.value = true;
    appMode.value = ThemeData.dark();
  }

  disableDarkMode() {
    isDarkMode.value = false;
    appMode.value = ThemeData.light();
  }

  var screenIndex = 0.obs;
  void changeScreen(int screenNumber) {
      screenIndex.value = screenNumber;
  }

  bool hasAccount() {
    if(user == null) {
      return false;
    } else {
      return true;
    }
  }

  bool isInternetConnected = false;
  void checkInternetConnection() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
    isInternetConnected = true;
  } else {
    isInternetConnected = false;
  }
}

   register( String username, String email, String password, String number) async {
      
     await auth.createUserWithEmailAndPassword(
        email: email,
        password: password).then(
          (value) {
            UserModel model = UserModel(
            //  id: '${username}_${password}_$number' ,
              username: username,
              email: email,
              password: password, 
              number: number,
              status: 'Hello World I am using KizoChat',
              image: 'https://firebasestorage.googleapis.com/v0/b/kizochat-dd9e2.appspot.com/o/photo6.jpg?alt=media&token=bba808bd-078d-46c0-84de-202e73e0c985'
      );
            FirebaseFirestore.instance.collection('users').add(
              model.toMap()
            );
             showMessage('User account has been created successfully', Colors.green);
              Get.off(LoginScreen());
          }).catchError((error) {
             showMessage('Account creation failed', Colors.purple);
        print('Error is : $error');
          }
             );
  }

   login(String email, password) async {
     await auth.signInWithEmailAndPassword(
        email: email,
        password: password).then(
          (value) {
            showMessage(
            'User account has been created successfully',
           Colors.green);
         
           Get.offAll(HomeScreen());
          }).catchError((error) => showMessage('Login failed, check username and password', Colors.purple));
  }

   logout() async {
    await auth.signOut().then(
      (value) {
        userEmail = '';
        user = null;
        Get.offAll(LoginScreen());
      }).catchError((error) {
        showMessage('Cannot sign out', Colors.purple);
        print('There are some errors in sign out : $error');
      });
  }


   void updateName(String name) {
    UserModel model = UserModel(
      id: um.id,
      username: name,
      status: um.status,
      email: um.email,
      password: um.password,
      image: um.image,
      number: um.number
    );
    
    FirebaseFirestore.instance.collection('users').doc(user!.uid).update(
      model.toMap()
   ).then((value) => showMessage(
      'User name has been updated successfully', 
      Colors.green)
      ).catchError((error) {
        showMessage(
        'Cannot update your name',
        Colors.purple);
        print('Error is : $error');
    });
      
   }
   
  void updateStatus(String status)  {
    UserModel model = UserModel(
      id: um.id,
      username: um.username,
      status: status,
      email: um.email,
      password: um.password,
      image: um.image,
      number: um.number
    );
     FirebaseFirestore.instance.collection('users').doc(user!.uid).update(
      model.toMap()
  ).then((value) => showMessage(
      'Status has been updated successfully', 
      Colors.green)).catchError((error) { showMessage(
        'Cannot update your status', 
        Colors.purple);

        print('Error is : $error');
   });  
      
   }

    

    // var messages = [].obs;

    //  getMessage () async {
    //   var database = FirebaseFirestore.instance.collection('users').doc(theId)
    //   .collection('chats').doc(showReceiverId).collection('messages').orderBy('dateTime');

    //   var querySnapshot = await database.get();
    //     messages.clear();
    //   for (var queryDocumentSnapshot in querySnapshot.docs) {
        
    //       messages.add(MessageModel.fromJson(queryDocumentSnapshot.data()));
    //      // Map<String, dynamic> data = queryDocumentSnapshot.data();

    //   }
    //        FirebaseFirestore.instance.collection('users').doc(theId.value)
    //   .collection('chats').doc(receiverId)
    //   .collection('messages').orderBy('dateTime').snapshots().listen((event) {
    //       messages.clear();
    //       event.docs.forEach((element) {
    //           messages.add(MessageModel.fromJson(element.data()));
    //       });
    //   });
    //  }


    void sendMessage({
      required String senderId,
      required String receiverId,
      required String dateTime,
      required String text,
    }) {

      UserModel model = UserModel();

        MessageModel msgModel = MessageModel(
          dateTime: dateTime,
          senderId: senderId,
          receiverId: receiverId,
          text: text
        );

        FirebaseFirestore.instance.collection('users')
        .doc(senderId).collection('chats').doc(receiverId)
        .collection('messages').add(msgModel.toMap())
        .then((value) => print('Message has been sent to $receiverName')).catchError((err) {
          print('There are some errors : $err');
        } );


        FirebaseFirestore.instance.collection('users')
        .doc(receiverId).collection('chats').doc(senderId)
        .collection('messages').add(msgModel.toMap())
        .then((value) => print('Message has been sent from $theUsername')).catchError((err) {
          print('There are some errors : $err');
        } );
   
    }




  // void checkUserBlock({
  //   required String senderId,
  //   required String receiverId,
  // }) async {
  //   var database = FirebaseFirestore.instance.collection('users').doc(receiverId)
  //                   .collection('chats').where('id', isEqualTo: senderId);

  //             var querySnapshot = await database.get();

  //     for(var queryDocumentSnapshot in querySnapshot.docs) {
  //         Map<String, dynamic> data = queryDocumentSnapshot.data();
          
  //         isBlocked = data['isblocked'];
  //         blockController = data['block_controller'];
  //     }
  //     print('is user blocked : $isBlocked');
  //     print('are you blocker : $blockController');
  // }

  checkBlockController() async {
    var database = FirebaseFirestore.instance.collection('users').doc(receiverId).collection('chats').where('id', isEqualTo: theId);
    var querySnapshot = await database.get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
                          Map<String, dynamic> data = queryDocumentSnapshot.data();
                          blockController = data['block_controller'];
                    }
  }

    void blockUser({
      required String senderId,
      required String receiverId,
    })  {
                               
      Get.back();
        FirebaseFirestore.instance.collection('users')
                            .doc(senderId).collection('chats').doc(receiverId).update({
                              'isblocked': true,
                              'block_controller': false
                            });

        FirebaseFirestore.instance.collection('users')
                            .doc(receiverId).collection('chats').doc(senderId).update({
                              'isblocked': true,
                              'block_controller': true
                            }).then((value) {
                             // checkUserBlock(senderId: senderId, receiverId: receiverId);
                              showMessage('User has been blocked', Colors.purple);
                            }).catchError((err) {
                                print('There are some errors : $err');
                              showMessage('Cannot block the user', Colors.purple);
                            });              

    }


    removeBlock({
      required String senderId,
      required String receiverId,
    }) {
      Get.back();
            FirebaseFirestore.instance.collection('users')
                            .doc(senderId).collection('chats').doc(receiverId).update({
                              'isblocked': false,
                              'block_controller': false,
                            });

        FirebaseFirestore.instance.collection('users')
                            .doc(receiverId).collection('chats').doc(senderId).update({
                              'isblocked': false,
                              'block_controller': false,
                            }).then((value) {
                            //  checkUserBlock(senderId: senderId, receiverId: receiverId);
                              showMessage('User block removed', Colors.purple);
                            }).catchError((err) {
                              print('There are some errors in remove block : $err');
                              showMessage('Cannot remove block', Colors.purple);
                            });

    }

    void getAllNumbers() async {
      var database = FirebaseFirestore.instance.collection('users');

      var querySnapshot = await database.get();

      for(var queryDocumentSnapshot in querySnapshot.docs) {
          Map<String, dynamic> data = queryDocumentSnapshot.data();
          ids.add(data['id']);
          names.add(data['username']);
          numbers.add(data['number']);
          images.add(data['image']);
          status.add(data['status']);
      }

      print(numbers);
      print('There are ${numbers.length} numbers in database');
    }

    void viewResult(String id, String name, String number, String image, String status)  {
      isFound.value = true;
      personId.value = id;
      personName.value = name;
      personNumber.value = number;
      personImage.value = image;
      personStatus.value = status;
    }

    void hideResult() {
      isFound.value = false;
      personId.value = '';
      personName.value = '';
      personNumber.value = '';
      personImage.value = '';
      personStatus.value = '';
    }
    
      }

    // mohammed id : jhiBNlr1dXQBwUHZdJE0o1owEJa2
    // ahmed id : kIjtqQR3p3hHTBLKdS1tvn2r4CJ2
    // kIjtqQR3p3hHTBLKdS1tvn2r4CJ2