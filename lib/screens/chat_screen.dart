import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'message_screen.dart';



class ChatScreen extends StatefulWidget {


  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  

  getUserInfo() async {

    var database = FirebaseFirestore.instance.collection('users').where('email', isEqualTo: userEmail );

    var querySnapshot = await database.get();
   // querySnapshot.docs.map((document) => document.id);
   // print('Data length is : ${querySnapshot.docs.length}');
    
    
    for (var queryDocumentSnapshot in querySnapshot.docs) {
                          Map<String, dynamic> data = queryDocumentSnapshot.data();
                          setState(() {
                          theId = data['id'];
                          theUsername = data['username'];
                          theEmail = data['email'];
                          theStatus = data['status'];
                          theNumber = data['number'];
                          theImage = data['image'];
                          });
                    }

     
                    print('the user id is : ${theId}');
                    print('the username is : ${theUsername}');
                    print('the email is : ${theEmail}');
                    print('User email in home screen is : $userEmail');
                    
    }

  Widget build(BuildContext context) {
     
   return (theId == '') ? const Center(
    child: CircularProgressIndicator(),
   )  :  StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').doc(theId).collection('chats').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
   
            return ListView(
              physics: const BouncingScrollPhysics(),
              children: snapshot.data!.docs.map(
                (data) => (data['id'] == theId) ? Container() : ChatItem(
                  context,
                  id: data['id'],
                  name: data['username'],
                  number: data['number'],
                  status: data['status'],
                  image: data['image'],
                  isUserBlocked: data['isblocked'],
                 // block_controller: blockController,
                 // block_controller: data['block_controller'],
                  icon: (data['isblocked'] == true) ? const Icon(Icons.block, color: Colors.red, size: 25,)
                    : IconButton(
                      onPressed: () {
                          isBlocked = data['isblocked'];
                          controller.checkBlockController();
                          receiverId = data['id'];
                          receiverName = data['username'];
                          receiverNumber = data['number'];
                          receiverStatus = data['status'];
                          receiverImage = data['image'];
                                  Get.to(MessageScreen(), transition: Transition.rightToLeft);
                      }, icon: Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.purple, size: 22,),
                      )) 
                  )
                ).toList(),
            );
        },
      );
  
  } }