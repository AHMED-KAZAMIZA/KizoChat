import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kizochat/components.dart';
class ReceiverInfoScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    print('user id in user profile screen is : $theId');
    print('receiver id in user profile screen is : $receiverId');
    return Scaffold(
      appBar: AppBar(
        foregroundColor: (controller.isDarkMode.value) ? Colors.white : Colors.black,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: const Text('User Profile'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').where('id', isEqualTo: receiverId).snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return  ListView(
            physics: const BouncingScrollPhysics(),

            children: snapshot.data!.docs.map((data) {
            
           return Column(
                      children: [
                        Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 50.0),
                          child: GestureDetector(
                            onTap: () {
                              receiverImage = data['image'];
                              showImgScreen(context);
                            },
                            child: CircleAvatar(
                              radius: 57,
                              backgroundColor: Colors.purple,
                              child: CircleAvatar(
                                radius: 55,
                                backgroundColor: Colors.transparent,
                                backgroundImage: NetworkImage(data['image']),
                              )  ),
                          ),
                        )  ),
                                Padding(
                                  padding: const EdgeInsets.symmetric( horizontal: 15.0),
                                  
                                    child: Card(
                                     
                                              child: Column(
                                                
                                            children: [
                                              
                                              ...ListTile.divideTiles(
                                            
                                                color: Colors.grey,
                                                tiles: [
                                                  ListTile(
                                                    contentPadding: EdgeInsets.symmetric(
                                                        horizontal: 12, vertical: 4),
                                                    leading: Icon(Icons.person, size: 33),
                                                    title: Text("Name"),
                                                    subtitle:  Text(data['username']),
                                                  ),
                                                       
                                                  ListTile(
                                                    contentPadding: EdgeInsets.symmetric(
                                                        horizontal: 12, vertical: 4),
                                                    leading: Icon(Icons.short_text, size: 33),
                                                    title: Text("Status"),
                                                    subtitle: Text(data['status']),
                                                  ),
                                                       
                                                  ListTile(
                                                    leading: Icon(Icons.phone),
                                                    title: Text("Phone Number"),
                                                    subtitle: Text(data['number']),
                                                  ),
                                                  
                                                ]  ),
                                            ],
                                          )),
                                ),

                      SizedBox( height: 40 ),

                      InkWell(
                        onTap: () {
                          confirmMessage(
                            'Confirm Block', 
                            'Do you really want to block this user ?', () {
                              controller.blockUser(senderId: theId, receiverId: receiverId);
                             });
                                                   
                        },

                        child:  Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: const Icon(Icons.block, color: Colors.red, size: 33),
                            title: Text('Block ${data["username"]}'),
                          )  ),
                      ),

                      InkWell(
                        onTap: () {
                                confirmMessage('Remove Block', 'Do you want to remove block ?', () { 
                                    controller.removeBlock(senderId: theId, receiverId: receiverId);
                                });
                                
                        },

                        child:  Padding(
                          padding: EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: Icon(Icons.check_circle_outline, color: Colors.green, size: 33),
                            title: Text('Remove Block'),
                          )  ),
                      ), 
                       
                      ],
                    );
           
                }).toList()
          );

        })
    );
  }
}