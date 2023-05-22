import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kizochat/screens/signup_screen.dart';
import '../components.dart';
import 'package:get/get.dart';
import '../controller.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final Controller controller = Get.put(Controller());

  final TextEditingController username = TextEditingController();

  final TextEditingController password = TextEditingController();

  var database = FirebaseFirestore.instance.collection('users');



  @override
  Widget build(BuildContext context) {
    return Obx(
        () =>  Scaffold(
            body: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 33),
                reverse: true,
                child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only( top: 30 ),
                              height: 230,
                              width: 265,
                              child: Image.asset(
                                  'images/start_img.png',
                                  fit: BoxFit.cover,
                              )),

                          Container(
                            margin: const EdgeInsets.symmetric( vertical: 10 ),
                            child: const Text('Welcome to KizoChat', style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold
                            ), ),
                          ),

                          Container(
                            margin: const EdgeInsets.only( top: 5, bottom: 15 ),
                            child: Text(
                              'Find out your friends, discover your world',
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.grey[600]
                              ),
                            ),
                          ),

                          Input(
                                text: 'User Name',
                                icon: const Icon(Icons.person),
                                isHidden: false,
                                controller: username
                            ),

                          Input(
                              text: 'Password',
                              icon: const Icon(Icons.lock),
                              secondIcon:  IconButton(
                                  onPressed: () {
                                    if(controller.isPassword1Hidden.value) {
                                      controller.make1Hidden();
                                    } else {
                                      controller.make1Visible();
                                    }
                                  },
                                  icon: (controller.isPassword1Hidden.value) ?
                                  const Icon(Icons.visibility) :
                                  const Icon(Icons.visibility_off)
                              ),
                              isHidden: controller.isPassword1Hidden.value,
                              controller: password
                          ),

                          SizedBox( height: 30 ),

                          Button(
                              text: 'Sign In',
                              function: () {
                                if(username.text.isNotEmpty && password.text.isNotEmpty) {
                                  
                                  // userEmail = username.text.trim();
                                  // print('user email is : $userEmail');
                                  controller.login(username.text.trim(), password.text.trim());
                                  
                                } else {
                                  showMessage('All fields must be filled',
                                      Colors.purple);
                                }
                              }  ),


                          SizedBox( height: 30 ),

                           Question(
                               questionText: 'Don\'t have an account?',
                               buttonText: 'Sign Up',
                               function: () {
                                 Get.to(SignupScreen());
                               })

                        ]  ),
              )  ),
        )  );
  } }