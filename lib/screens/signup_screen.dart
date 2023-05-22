import 'package:flutter/material.dart';
import 'package:kizochat/screens/login_screen.dart';
import 'package:get/get.dart';
import '../controller.dart';
import '../components.dart';

class SignupScreen extends StatelessWidget {
  final Controller controller = Get.put(Controller());

   SignupScreen({Key? key}) : super(key: key);
  final TextEditingController username = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.black,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 30),
            reverse: true,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only( top: 30, bottom: 10 ),
                  child: const Text('Let\'s Get Started', style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold
                  ) ),
                ),

                Container(
                  margin: const EdgeInsets.only( bottom: 30 ),
                  child: Text('Sign up now to communicate with your friends', style: TextStyle(
                      fontSize: 17,
                      color: Colors.grey[600]
                  )
                  ),
                ),

                Input(
                    text: 'User Name',
                    icon: const Icon(Icons.person),
                    isHidden: false,
                    controller: username
                ),

                Input(
                    text: 'Email',
                    icon: const Icon(Icons.email),
                    isHidden: false,
                    controller: email
                ),

                Input(
                    text: 'Phone Number',
                    icon: const Icon(Icons.phone_android),
                    data: TextInputType.number,
                    isHidden: false,
                    controller: phoneNumber
                ),

                Input(
                    text: 'Password',
                    icon: const Icon(Icons.lock),
                    secondIcon:  IconButton(
                        onPressed: () {
                          if(controller.isPassword2Hidden.value) {
                            controller.make2Hidden();
                          } else {
                            controller.make2Visible();
                          }
                        },
                        icon: (controller.isPassword2Hidden.value) ?
                        const Icon(Icons.visibility) :
                        const Icon(Icons.visibility_off)
                    ),
                    isHidden: controller.isPassword2Hidden.value,
                    controller: password
                ),

                Input(
                    text: 'Confirm Password',
                    icon: const Icon(Icons.lock),
                    secondIcon:  IconButton(
                        onPressed: () {
                          if(controller.isPassword3Hidden.value) {
                            controller.make3Hidden();
                          } else {
                            controller.make3Visible();
                          }
                        },
                        icon: (controller.isPassword3Hidden.value) ?
                        const Icon(Icons.visibility) :
                        const Icon(Icons.visibility_off)
                    ),
                    isHidden: controller.isPassword3Hidden.value,
                  controller: confirmPassword
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Button(
                      text: 'Sign Up',
                      function: () {
                        if(
                        username.text.isNotEmpty && email.text.isNotEmpty &&
                        phoneNumber.text.isNotEmpty && password.text.isNotEmpty &&
                        confirmPassword.text.isNotEmpty) {
                          if(password.text == confirmPassword.text) {
                            controller.register(
                              username.text,
                              email.text.trim(), 
                              password.text.trim(),
                              phoneNumber.text.trim());
                            
                          } else {
                            showMessage('Password is not the same', Colors.purple);
                          }
                        } else {
                          showMessage('All fields must be filled', Colors.purple);
                        }
                      }
                  ),
                ),

                Question(
                    questionText: 'Already have an account?',
                    buttonText: 'Sign In',
                    function: () {
                      Get.off(LoginScreen());
                    })
              ],
            )  ),
        )  ),
    );
  }  }