import 'package:mdg_project/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:mdg_project/screens/image_screen.dart';
import 'package:mdg_project/services/assets_manager.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Expanded(
        child: Column(
          
          children: [
               const SizedBox(height: 70,),
               ListTile(
             
              title: Text(
                'Tools',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Colors.black,
                      fontSize: 18,
                    ),
              ),
              onTap: () {
                },
            ),
            
            ListTile(
              leading:Image.asset(AssetsManager.galleryImage),
              title: Text(
                'Image Generator',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Colors.black,
                      fontSize: 16,
                    ),
              ),
              onTap: () {
                 Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) =>const ImageScreen()));},
            ),
            ListTile(
              leading: Image.asset(AssetsManager.botImage),
              title: Text(
                'ChatBot',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Colors.black,
                      fontSize: 16,
                    ),
              ),
              onTap: () {
                 Navigator.of(context).pop();
                 Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) =>const ChatScreen()));},
            ),
           
        
          ],
        ),
      ),
    );
  }
}