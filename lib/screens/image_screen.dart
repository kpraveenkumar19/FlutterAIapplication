import 'dart:core'; 
import 'package:mdg_project/constants/constants.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:mdg_project/services/api_service.dart';
import 'package:flutter/material.dart';
import '../widgets/main_drawer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mdg_project/services/assets_manager.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({super.key});

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  
 
  var textController =TextEditingController();
  String image="";

  bool imageShowing=false;
  void referesh(){
    setState(() {
      imageShowing =false;
      image="";
      textController.text="";
    });
  }
  void displayImage( TextEditingController textController) async {
    
    image = await ApiService.imageGenerator(message: textController.text);

    setState(() {imageShowing=true; });
  }
  @override
  void initState() {
   
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title:const  Center(
          child: Text("Image Generator"),
        ),
           actions: [Image.asset(AssetsManager.iconImage),const Align(alignment: Alignment.center,)],
      ),
         drawer: const MainDrawer(),
     body : 
      
       Column(
        children: [
          Expanded(child: Container(
            color: scaffoldBackgroundColor,
            child: Column(
           
              children: [
               const SizedBox(
                  height: 40,
                ),
               
                Row(
                  children: [
                 const    SizedBox(
                      height: 30,
                        ),
                    Container(
                     
                      child: Expanded(
                        child: Container(
                          height: 40,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(30)
                          ),
                          child: TextFormField(
                            controller: textController,style:const  
                            TextStyle(
                              color: Colors.white
                              ),
                            decoration:const InputDecoration(
                               
                              hintText: "                          Enter image prompt",
                                hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                            ),
                          ),
                          
                        ),
                      ),
                    ),
                       
                  ],
                  
                ),
              const  SizedBox(
                      height: 18,
                        ),
               
                Row(
                  children: [
                    const SizedBox(
                      height: 12,
                      width: 12,
                    ),
                    
                    
                    ElevatedButton(
                      
                      style:
                       ElevatedButton.styleFrom(
                        
                        backgroundColor: const Color.fromARGB(255, 59, 143, 62),
                        shape: const StadiumBorder()
                      ),
                      onPressed: () async{
                       if(textController.text.isNotEmpty){
                        setState(() {
                          imageShowing=false;
                        });
                        displayImage(textController);
                       }
                       else{
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enter the text of Required Image"),),);
                       }
                      }, 
                      child: const  Text("Generate Image")),
                       const SizedBox(
                      height: 12,
                      width: 12,
                    ),
                      ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 59, 143, 62),
                        shape: const StadiumBorder()
                      ),
                      onPressed: () async{
                        await GallerySaver.saveImage(image,albumName: 'flutterpics');
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Image saved to the Gallery"),),);},
                      child: const  Text("Save Image")),
                      
                      IconButton(
                        onPressed: () {
                          referesh();
                        },
                        icon: const Icon(
                          Icons.refresh,
                          color: Colors.white,
                        ))
                  ],
                ),
               
                Expanded(
            
            child: imageShowing ? 
               SizedBox(
                height: 100,
                width: 400,
                child: Image.network(image),
                )
                
               :
               
              const SizedBox(
                      height:130,
                      child:  SpinKitThreeBounce(
                color: Colors.white,
                size: 42,
              ),
                        ),
                 
            ),
         
                 
              ],
              
            ),
          )),
        
         
        ],
       ),
     
      
    );
  }

  
}