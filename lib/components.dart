import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kizochat/screens/message_screen.dart';
import '../controller.dart';
import 'message_model.dart';

final Controller controller = Get.find();

bool isBlocked = false, blockController = false;
List<MessageModel> messages = [];

String receiverImage = '';
String receiverName = '';
String receiverId = '';
String receiverStatus = '';
String receiverNumber = '';
String userEmail = '';

  String theId = '', 
      theUsername = '', 
      theEmail = '',
      theStatus = '', 
      theNumber = '',
      theImage = '';

Widget Input({
  required String text,
  required Widget icon,
  Widget? secondIcon,
  TextInputType? data,
  required bool isHidden,
  required TextEditingController controller
}) => Container(
margin: const EdgeInsets.symmetric( horizontal: 20, vertical: 15 ),
child: TextField(
  obscureText: isHidden,
  keyboardType: data,
controller: controller,
decoration: InputDecoration(
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(50)
),
  labelText: text,
  prefixIcon: icon,
  suffixIcon: secondIcon,
),
) );


Widget Button({
  required String text,
  required VoidCallback function
}) => MaterialButton(
onPressed: function,
padding: const EdgeInsets.symmetric( horizontal: 60, vertical: 15 ),
color: Colors.purple,
shape: const StadiumBorder(),
child:  Text(text, style: const TextStyle(
fontSize: 22,
fontWeight: FontWeight.bold,
color: Colors.white
) ),
);


Widget Question({
  required String questionText,
  required String buttonText,
  required VoidCallback function
}) =>  Row(
mainAxisAlignment: MainAxisAlignment.center,
children: [
Text(questionText, style: const TextStyle(
fontSize: 18,
),),


TextButton(
onPressed: function,
child: Text(buttonText, style: const TextStyle(
fontSize: 20,
fontWeight: FontWeight.bold,
color: Colors.purple
) ) )
],
);


showMessage(String msg, Color color) {
  Get.snackbar('', '',
      backgroundColor: color,
      duration: const Duration(seconds: 2),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      messageText: Text(msg,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white)),
      margin: const EdgeInsets.all(20),
      borderRadius: 20);
}

confirmMessage(String title, String text, VoidCallback function) {
  Get.defaultDialog(
      title: title,
      middleText: text,
      textCancel: 'Cancel',
      textConfirm: 'Confirm',
      cancelTextColor: Colors.black,
      
      confirmTextColor: Colors.white,
      buttonColor: Colors.purple,
      onConfirm: function
  );
}

Widget ChatItem(
  context,{
  required String id,
  required String name,
  required String number,
  required String status,
  required String image,
  required Widget icon,
  bool? isUserBlocked,
  bool? block_controller,
}) => Padding(
  padding: const EdgeInsets.symmetric( vertical: 10),
  child:   ListTile(
  
    leading: GestureDetector(
  
      onTap: () {
  
        receiverImage = image;
  
        receiverName = name;
  
        showImgScreen(context);
  
      },
  
      child: CircleAvatar(
  
              backgroundColor: Colors.transparent,
  
              radius: 30,
  
              backgroundImage: NetworkImage(image),
  
      )),
  
  
  
    title:  InkWell(
  
      onTap: () {
      isBlocked = isUserBlocked!;
      receiverId = id;
      receiverName = name;
      receiverNumber = number;
      receiverStatus = status;
      receiverImage = image;
      controller.checkBlockController();
      Get.to(MessageScreen(), transition: Transition.rightToLeft);

      },
  
      child: Container(
  
        margin: const EdgeInsets.only( top: 4, bottom: 5 ),  
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(name, style: const TextStyle( 
  
        fontSize: 18,  
  
        fontWeight: FontWeight.bold,
  
        ) ),
  
    ),
  
    ),

    trailing: icon
  
  ) );
// Column(

// children: [
// InkWell(
//   onTap: () {
//     receiverId = id;
//     receiverName = name;
//     receiverNumber = number;
//     receiverStatus = status;
//     receiverImage = image;
//     Get.to(MessageScreen(), transition: Transition.rightToLeft);
//   },
//   child:  Container( 
  
  
//   padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
  
//   child: Row(
  
//   crossAxisAlignment: CrossAxisAlignment.start,
  
//   children: [
  
//   GestureDetector(
  
//     onTap: () {
  
//       receiverImage = image;
//       receiverName = name;
//       showImgScreen(context);
  
//     },
  
//       child: CircleAvatar(
  
//       backgroundColor: Colors.transparent,
//       radius: 30,
//       backgroundImage: NetworkImage(image),
  
//       ),
  
//   ),
  
//   Column(
  
//   crossAxisAlignment: CrossAxisAlignment.start,
  
//   children: [
  
//    Container( 
  
//     margin: const EdgeInsets.only( top: 4, left: 10, bottom: 5 ),
  
//     child: Text(name, style: const TextStyle(
  
//     fontSize: 18,
  
//     fontWeight: FontWeight.bold, 
  
//     ) ),
    
//     ),
  
//   ]  ),
  
//   ],
  
//   ) ),
// ),

// ] );

Widget SettingOption({
  required String optionName,
  required IconData optionIcon,
  required VoidCallback optionFunction
}) => Column(

    children: [
      InkWell(
        onTap: optionFunction,
        child: Padding(
        
                    padding: const EdgeInsets.all(10.0),
                      
                      child: ListTile(
                      
                        leading: Icon(optionIcon, size: 40, color: Colors.purple, ),
                      
                        title: Text(optionName, style: TextStyle(
                      
                          fontWeight: FontWeight.bold,
                      
                          fontSize: 18
                      
                          ) ),
                      
                      )  ),
      ),
  
                  Divider( color: (controller.isDarkMode.value) ? Colors.black26 : Colors.blueGrey[100], thickness: 1, ),
  
    ],
  );


Widget ColorCircle({
   required Color color
}) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12.0),
                              child: CircleAvatar(
                                  radius: 34,
                                  backgroundColor: color,
                                ),
                            );


  showImgScreen(BuildContext context) {
    controller.checkInternetConnection();
  Get.to(
    Scaffold(
           appBar: AppBar(
             foregroundColor: (controller.isDarkMode.value) ? Colors.white : Colors.black,
             backgroundColor: Theme.of(context).scaffoldBackgroundColor,
             elevation: 0,
             title: Text(receiverName),
           ),
           body: Center(
             child: (controller.isInternetConnected) ? InteractiveViewer(
                 panEnabled: true,
                 minScale: 0.5,
                 maxScale: 3.3,
                 child: Image.network(
                     receiverImage,
                     height: 630,
                 )
             ) : Text('No Internet Connection ):', style: Theme.of(context).textTheme.headlineSmall),
           ),
         ),
    transition: Transition.downToUp
  );
}

Widget MessageInput({
  TextInputType? type,
 required TextEditingController controller,
 required String text,
 required IconData icon,
 required VoidCallback function
}) =>  Container(
                    padding: const EdgeInsets.only(left: 6),
                   clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1
                      ),
                      borderRadius: BorderRadius.circular(12)
                    ),
                    height: 50,
                    
                    child:  Row(
                          
                            children: [
                                    
                              Expanded(
                                child: TextField(
                                  keyboardType: type ,
                                  controller: controller,
                                  decoration: InputDecoration(
                                    
                                    border: InputBorder.none,
                                    hintText: text,
                                    
                                  ),
                                )  ),
                              
                              MaterialButton(
                                height: 50,
                                minWidth: 1,
                                color: Colors.purple,
                                child: Icon(icon, color: Colors.white,),
                                onPressed: function
                                  
                                )
                            ],
                          )  );
