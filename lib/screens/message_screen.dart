import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kizochat/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kizochat/screens/receiver_info_screen.dart';
import '../components.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  
    @override
  void initState() {
    super.initState();    
    getMessage();
    controller.checkInternetConnection();
      }

  final messageController = TextEditingController();

    Future getMessage () async {
      var database = FirebaseFirestore.instance.collection('users').doc(theId)
      .collection('chats').doc(receiverId).collection('messages').orderBy('dateTime');

      var querySnapshot = await database.get();

      setState(() {
        messages.clear();
      for (var queryDocumentSnapshot in querySnapshot.docs) {
          messages.add(MessageModel.fromJson(queryDocumentSnapshot.data()));
      }
        });
     }

    // check the user message in case no problem send message and show all messages with this user
    void validateAndSendMessage() {
                          if(messageController.text.isEmpty || messageController.text.codeUnits.first == 32) {
                      showMessage('Cannot send empty message', Colors.purple);
                    } else {
                      if(controller.isInternetConnected) {
                    controller.sendMessage(
                                      senderId: theId,
                                      receiverId: receiverId,
                                      dateTime: DateTime.now().toString(),
                                      text: messageController.text);

                    setState(() {
                            messageController.text = '';
                    });
          
                    getMessage().then((value) {
                    if(messages.length == 1) {
                      print('Only one message is here');
        FirebaseFirestore.instance.collection('users').doc(theId).collection('chats')
        .doc(receiverId).set({
          'id': receiverId,
          'username': receiverName,
          'number': receiverNumber,
          'image': receiverImage,
          'status': receiverStatus,
          'isblocked': false,
          'block_controller': false,
        });


        FirebaseFirestore.instance.collection('users').doc(receiverId).collection('chats')
        .doc(theId).set({
          'id': theId,
          'username': theUsername,
          'number': theNumber,
          'image': theImage,
          'status': theStatus,
          'isblocked': false,
          'block_controller': false,
        });

      } else {
        print('There are a lot of messages');
      }
                    });
                                                            
                      } else {
                        showMessage('No Internet Connection', Colors.purple);
                      }
                    }

     }


  @override
  Widget build(BuildContext context) {
    print('user id is : $theId');
    print('receiver id is : $receiverId');
    print('user block is : $isBlocked');
    print('block controller is : $blockController');
    return Scaffold(
      appBar: AppBar(
        foregroundColor: (controller.isDarkMode.value) ? Colors.white : Colors.black,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Text(receiverName),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: (isBlocked == true && blockController == false) ? Container() : IconButton(
              onPressed: () {
                Get.to(ReceiverInfoScreen());
              }, 
              icon: const Icon(Icons.account_circle, size: 40, color: Colors.purple,)),
          )
        ],
      ),
      body: (isBlocked) ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only( bottom: 10 ),
            child: Icon(Icons.block, size: 110, color: Colors.red,),
            ),
          Center(
            child: Text('This user is blocked', style: Theme.of(context).textTheme.headlineSmall,),
          ),
        ],
      ) : Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
             
                children: [
                  Expanded(
                     child: (messages.isNotEmpty) ? ListView.separated(
                      physics: const BouncingScrollPhysics(),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          var message = messages[index];
                              if(message.senderId == theId) {
                                return SenderMessage(message);
                              } else {
                                return ReceiverMessage(message);
                              }
                        },
                        separatorBuilder: (context, index) => SizedBox( height: 20 ),
                      ) : 
                      Center(
                        child: Text('Chat With $receiverName', style: Theme.of(context).textTheme.headlineSmall,),
                      ) ,
                   ),
                
              MessageInput(
                text: 'Type your message here',
                icon: Icons.send,
                controller: messageController, 
                function: () => validateAndSendMessage() )
                
              ] )
          )  );
  }

  Widget SenderMessage(MessageModel msg) => Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        margin: const EdgeInsets.all(20),
                        padding: const EdgeInsets.symmetric( vertical: 6, horizontal: 10 ),
                        decoration: const BoxDecoration(
                          color: Colors.purple,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10)
                          )
                        ),
                        child: Text(
                          msg.text.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white
                          ),
                          ),
                      )  );

  Widget ReceiverMessage(MessageModel msg) => Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.symmetric( vertical: 6, horizontal: 10 ),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade800,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10)
                      )
                    ),
                    child: Text(
                      msg.text.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white
                      )  ),
                  )  );
}