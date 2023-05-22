import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:kizochat/screens/login_screen.dart';
import 'screens/home_screen.dart';
import '../controller.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Controller controller = Get.put(Controller());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GetMaterialApp(
        title: 'KizoChat',
        debugShowCheckedModeBanner: false,
        darkTheme: controller.appMode.value,
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        home:  (controller.hasAccount() ? HomeScreen() : LoginScreen()),
      ),
    );
  }
}