import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kizochat/screens/newchat_screen.dart';
import '../components.dart';
import '../controller.dart';
import 'chat_screen.dart';
import 'setting_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  
  final Controller controller = Get.put(Controller());
  var page = PageController();
  static FirebaseAuth auth = FirebaseAuth.instance;
     final user = auth.currentUser;

     
 final List <Widget> screens = [
    ChatScreen(),
    SettingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    userEmail = user!.email.toString();


     
    return Obx(
      () => Scaffold(
            appBar: AppBar(
              foregroundColor: Colors.purple,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 0,
              title: const Text('KizoChat', style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ) ),
              actions: [
               (controller.screenIndex.value == 0) ? IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.search)) : Container(),
              ],
            ),
            floatingActionButton: (controller.screenIndex.value == 0) ? FloatingActionButton(
              backgroundColor: Colors.purple,
                onPressed: () {
                  controller.hideResult();
                  Get.to(NewChatScreen(), transition: Transition.downToUp );
                },
                child: const Icon(Icons.chat, color: Colors.white,),
            ) : Container(),
      
            body: PageView.builder(
              physics: const BouncingScrollPhysics(),
                  itemCount: 2,
                  controller: page,
      
                onPageChanged: (index) {
                  
                  controller.changeScreen(index);         
                },
               
                itemBuilder: (context, index) => screens[index]
                  ),
      
            bottomNavigationBar: BottomNavigationBar(
              selectedItemColor: Colors.purple,
                  currentIndex: controller.screenIndex.value,
                onTap: ( index ) {
                  controller.changeScreen(index);
                  page.animateToPage(controller.screenIndex.value, duration: const Duration(milliseconds: 100), curve: Curves.ease);
                },
      
                  items: const [
                    BottomNavigationBarItem(
                    
                      
                        icon: Icon(Icons.chat),
                        
                        label: 'Chats'
                    ),
      
             
      
                    BottomNavigationBarItem(
                        icon: Icon(Icons.settings),
                        label: 'Settings'
                    ),
                  ]
              ),
          ),  );
  }
}