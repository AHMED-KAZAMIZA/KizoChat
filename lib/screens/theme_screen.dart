import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components.dart';
import '../controller.dart';

class ThemesScreen extends StatelessWidget {
  final Controller controller = Get.put(Controller());
  
  @override
  Widget build(BuildContext context) {
    return  Obx(
      () => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          foregroundColor: (controller.isDarkMode.value) ? Colors.white : Colors.black,
          elevation: 0,
          title: const Text('Themes'),
          centerTitle: true,
        ),
    
        body: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical:20.0),
                child: Center(child: Text('Choose Your Best Color', style: Theme.of(context).textTheme.headlineSmall,)),
              ),
    
              Padding(
                padding: const EdgeInsets.only( top: 20 ),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric( vertical: 10 ),
                    width: 300,
                    
                    decoration: const BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)
                      )
                    ),
                    child: Text('Color House', 
                      textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold
                    )),
                  ),
                ),
    
                ),
    
                Padding(
                  padding: const EdgeInsets.symmetric( horizontal: 10.0),
                  child: Card(
                    color: (controller.isDarkMode.value) ? Colors.black12 : Colors.grey[300],
                    child: Container(
                      height: 475,
                      child: Column(
                        
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ColorCircle(color: Colors.purple),
                              ColorCircle(color: Colors.deepPurple),
                              ColorCircle(color: Colors.pink),
                            ] ),
    
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ColorCircle(color: Colors.orange),
                              ColorCircle(color: Colors.deepOrange),
                              ColorCircle(color: Colors.red),
                            ] ),
    
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ColorCircle(color: Colors.yellow),
                              ColorCircle(color: Colors.lime),
                              ColorCircle(color: Colors.green),
                            ] ),
    
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ColorCircle(color: Colors.cyan),
                              ColorCircle(color: Colors.blue),
                              ColorCircle(color: Colors.teal),
                            ] ),
    
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ColorCircle(color: Colors.blueGrey),
                              ColorCircle(color: Colors.brown),
                              ColorCircle(color: Colors.black),
                            ] ),
    
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox( height: 20, ),

                Padding(
                padding: const EdgeInsets.symmetric(vertical:20.0),
                child: Center(child: Text('Change App Mode', style: Theme.of(context).textTheme.headlineSmall,)),
              ),
    
                ListTile(
                  leading: const Text('Enable Dark Mode', style: TextStyle(
                    fontSize: 20
                  ),),
                  title: Switch(
                    activeColor: Colors.purple,
                    value: controller.isDarkMode.value, 
                    onChanged: (val) {
                      if(controller.isDarkMode.value) {
                        controller.disableDarkMode();
                      } else {
                        controller.enableDarkMode();
                      }
                    }),
                )
              
          ],
        ),
      ),
    );
  }
}