import 'package:flutter/material.dart';
import 'package:kizochat/components.dart';
import 'package:get/get.dart';
import 'package:kizochat/screens/profile_screen.dart';
import 'package:kizochat/screens/theme_screen.dart';
import 'change_number_screen.dart';

class SettingScreen extends StatelessWidget {
  final List<String> titles = [
    'My Profile',
    'Change Number',
    'Notifications',
    'Themes',
    'App Lock',
    'App Info',
  ];

  final List<IconData> icons = [
    Icons.account_circle,
    Icons.numbers,
    Icons.notifications,
    Icons.color_lens,
    Icons.lock_outlined,
    Icons.info_outline,
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
          itemCount: titles.length,
          itemBuilder: (context, index) => 
          SettingOption(
            optionName: titles[index],
            optionIcon: icons[index],
            optionFunction: () {
              switch (index) {
                case 0:
                  Get.to(ProfileScreen());
                  break;

                case 1:
                Get.to(ChangeNumberScreen());
                  break;

                case 3:
                  Get.to(ThemesScreen());
                  break;

                default:
              }
            }) ,
      ),
    );
  }
}