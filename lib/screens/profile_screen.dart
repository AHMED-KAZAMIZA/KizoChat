import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kizochat/screens/update_screen.dart';
import '../components.dart';
import '../controller.dart';


class ProfileScreen extends StatelessWidget {

    final Controller controller = Get.find();


  Widget build(BuildContext context) {
    print('User Email in account screen is : $userEmail');
    return Scaffold(
      appBar: AppBar(
        foregroundColor: (controller.isDarkMode.value) ? Colors.white : Colors.black,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: const Text('My Profile'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').where('email', isEqualTo: userEmail ).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
      
        return ListView(
              physics: const BouncingScrollPhysics(),
              children: snapshot.data!.docs.map((data) {
                return  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: GestureDetector(
                            onTap: () {
                              receiverName = data['username'];
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
                                        leading: Icon(Icons.email),
                                        title: Text("Email"),
                                        subtitle: Text(data['email']),
                                      ),
      
                                      ListTile(
                                        leading: Icon(Icons.phone),
                                        title: Text("Phone Number"),
                                        subtitle: Text(data['number']),
                                      ),
                                      
                                    ]  ),
                                ],
                              ))),
      
                              SizedBox( height: 20, ),
      
                      InkWell(
                        onTap: () {
                          Get.to(UpdateScreen());
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: Icon(Icons.update, color: Colors.orange, size: 33,),
                            title: Text('Update Profile'),
                          )  ),
                      ),
      
      
                      InkWell(
                        onTap: () {
                          confirmMessage(
                            'Confirm Logout',
                            'Do you really want to logout ?',
                            () {
                                 controller.logout();
                            });
                         
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: Icon(Icons.logout, color: Colors.orange[800], size: 33,),
                            title: const Text('Logout Account'),
                            
                          )  ),
                      ),
      
                      InkWell(
                        onTap: () {
                            
                        },
                        child:  Padding(
                          padding: EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: Icon(Icons.delete, color: Colors.red, size: 33,),
                            title: Text('Delete Account'),
                          )  ),
                      ),
                    ],
                  );

              },).toList()
                
                );
                  },
  
      )
    );
  }
}