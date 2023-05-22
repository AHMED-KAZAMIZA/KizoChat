import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components.dart';
import '../controller.dart';
import 'message_screen.dart';

class NewChatScreen extends StatelessWidget {

 //  NewChatScreen({super.key});
   final Controller controller = Get.find();
   
  final searchController = TextEditingController();
   
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
        appBar: AppBar(
          title: const Text('New Chat'),
          centerTitle: true,
          foregroundColor: (controller.isDarkMode.value) ? Colors.white : Colors.black,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
        ),
    
        body: Obx(
          () => Column(
                         children: (controller.isFound.value) ? [
                          ChatItem(
                            context, 
                            id: controller.personId.value,
                            name: controller.personName.value,
                            number: controller.personNumber.value,
                            status: controller.personStatus.value,
                            image: controller.personImage.value,
                            icon: const Icon(Icons.arrow_forward_ios_rounded, size: 22, color: Colors.purple)
                            ),
        
                            Spacer(),
        
                            Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: MessageInput(
                                  type: TextInputType.phone,
                                  text: 'Search people by number',
                                  icon: Icons.search,
                                  controller: searchController,
                                  function: () {
                                    for(int i = 0; i < controller.numbers.length; i++) {
                                    if(searchController.text == controller.numbers[i]) {
                                      
                                       controller.viewResult(
                                        controller.ids[i], 
                                        controller.names[i], 
                                        controller.numbers[i], 
                                        controller.images[i],
                                        controller.status[i],
                                        );

                                        
        
                                      print('Number is found at index number $i');
                                      print('User id is : ${controller.personId.value}');
                                      print('User name is : ${controller.personName.value}');
                                      print('User number is : ${controller.personNumber.value}');
                                      print('User status is : ${controller.personStatus.value}');
        
                                       break;
                                    }  }
                                  } ),
                          )
                         ] : [
                            SizedBox( height: 100 ),
                             Center(
                              child: Text("User Not Found",
                              style: Theme.of(context).textTheme.headlineSmall,)),
                                
          
                                Spacer(),
          
                            Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: MessageInput(
                                  type: TextInputType.phone,
                                  text: 'Search people by number',
                                  icon: Icons.search,
                                  controller: searchController,
                                  function: () {

                                    if(searchController.text.isEmpty || searchController.text.codeUnits.first == 32) {
                                      showMessage('Insert a number', Colors.purple);
                                    } else {

                                    for(int i = 0; i < controller.numbers.length; i++) {
                                    if(searchController.text == controller.numbers[i]) {
                                      
                                       controller.viewResult(
                                        controller.ids[i], 
                                        controller.names[i], 
                                        controller.numbers[i], 
                                        controller.images[i],
                                        controller.status[i]
                                        );
        
                                      print('Number is found at index number $i');
                                      print('User id is : ${controller.personId.value}');
                                      print('User name is : ${controller.personName.value}');
                                      print('User number is : ${controller.personNumber.value}');
        
                                       break;
                                    }  }
                                    }
                                  } ),
                          )
                          ]
                        ),
        ),
            
                    // Expanded(
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(20),
                    //     child: Text('Input is here', style: TextStyle( fontSize: 20 ),),
                    //     ),
                    // )
                
   
            );
         
          } 
  }