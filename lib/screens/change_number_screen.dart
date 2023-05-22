import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../components.dart';
import '../controller.dart';

class ChangeNumberScreen extends StatelessWidget {
  final Controller controller = Get.put(Controller());
  final oldNumberController = TextEditingController();
  final newNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    controller.checkInternetConnection();
    return Scaffold(
      appBar: AppBar(
        foregroundColor: (controller.isDarkMode.value) ? Colors.white : Colors.black,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: const Text('Change Number'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').where('email', isEqualTo: userEmail).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(!snapshot.hasData) {
            return Center(
                  child: CircularProgressIndicator(),
                );
              }
          
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: snapshot.data!.docs.map((document) {
             
             return Column(
              children: [
              
              Text('Change your old number easily',
                  style: TextStyle(
                    fontSize: 20
                  ),
                ),

              SizedBox( height: 20 ),
            

              Input(
                                text: 'Old Number',
                                icon: const Icon(Icons.numbers), 
                                isHidden: false,
                                data: TextInputType.number,
                                controller: oldNumberController
                              ),

            Input(
                                text: 'New Number',
                                icon: const Icon(Icons.phone), 
                                isHidden: false,
                                data: TextInputType.number,
                                controller: newNumberController
                              ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: MaterialButton(
                shape: const StadiumBorder(),
                color: Colors.purple,
                minWidth: 180,
                padding: const EdgeInsets.symmetric( vertical: 15),
                child: const Text('Change', style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold
                                    ),),
                onPressed: () {
                  if(controller.isInternetConnected) {
                    if(oldNumberController.text.isNotEmpty && newNumberController.text.isNotEmpty) {
                      if(oldNumberController.text.length >= 8 && newNumberController.text.length >= 8) {
                        FirebaseFirestore.instance.collection('users').doc(document.id).update({
                            'number': newNumberController.text
                        }).then((value) => showMessage('The number has been changed', Colors.green)
                        ).catchError((error) {
                          print('Cannot update number : $error');
                        });
                        
                      } else {
                        showMessage('Less than 8 numbers not allowed', Colors.purple);
                      }
                     
                    } else {
                       showMessage('Fields must not be empty', Colors.purple);
                    }
                  } else {
                    showMessage('No Internet connection', Colors.purple);
                  }
                }
                ),
            )
            ],
             );

            }).toList()
          );
        }
      ),
    );
  }
}