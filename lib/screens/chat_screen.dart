import 'dart:developer';
import 'package:mdg_project/constants/constants.dart';
import 'package:mdg_project/providers/chats_provider.dart';
import 'package:mdg_project/widgets/chat_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../widgets/text_widget.dart';
import '../widgets/main_drawer.dart';
import '../services/assets_manager.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isTyping = false;
 
  late TextEditingController textEditingController;
  late ScrollController _ltcontroller;
  late FocusNode focusNode;
  @override
  void initState() {
    _ltcontroller = ScrollController();
    textEditingController = TextEditingController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _ltcontroller.dispose();
    textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    return Scaffold(
      appBar: AppBar(
          actions: [Image.asset(AssetsManager.iconImage),const Align(alignment: Alignment.center,)],
         elevation: 0,
        title:const Center(child: Text("BuriBuriAI")),
           
      ),
      drawer: const MainDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                  controller: _ltcontroller,
                  itemCount: chatProvider.getChatList.length, //chatList.length,
                  itemBuilder: (context, index) {
                    return ChatWidget(
                      msg: chatProvider
                          .getChatList[index].msg, // chatList[index].msg,
                      chatIndex: chatProvider.getChatList[index]
                          .chatIndex, //chatList[index].chatIndex,
                      shouldAnimate:
                          chatProvider.getChatList.length - 1 == index,
                    );
                  }),
            ),
            if (_isTyping) ...[
              const SpinKitThreeBounce(
                color: Colors.white,
                size: 18,
              ),
            ],
            const SizedBox(
              height: 15,
            ),
            Material(
              color: cardColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(

                      child: TextField(

                        focusNode: focusNode,
                        style: const TextStyle(color: Colors.white),
                        controller: textEditingController,
                        onSubmitted: (value) async {
                          await sendMessageFCT(
                              
                              chatProvider: chatProvider);
                        },
                        decoration:
                            
                            const InputDecoration.collapsed(
                              border: InputBorder.none,
                            hintText: "How can I help you",
                            hintStyle: TextStyle(color: Colors.grey)),
                             
                      ),
                    ),
                    IconButton(
                        onPressed: () async {
                          await sendMessageFCT(
                            
                              chatProvider: chatProvider);
                        },
                        icon: const Icon(
                          Icons.send,
                          color: Color.fromARGB(208, 57, 162, 90),
                        ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void scrollListToEND() {
    _ltcontroller.animateTo(
        _ltcontroller.position.maxScrollExtent,
        duration: const Duration(seconds: 2),
        curve: Curves.easeOut);
  }

  Future<void> sendMessageFCT(
      {
      required ChatProvider chatProvider}) async {
    if (_isTyping) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(
            label: "You cant send multiple messages at a time",
          ),
          backgroundColor: Color.fromARGB(255, 188, 48, 38),
        ),
      );
      return;
    }
    if (textEditingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(
            label: "Please Enter any prompt..",
          ),
          backgroundColor: Color.fromARGB(255, 149, 37, 29),
        ),
      );
      return;
    }
    try {
      String msg = textEditingController.text;
      setState(() {
        _isTyping = true;
  
        chatProvider.addUserMessage(msg: msg);
        textEditingController.clear();
        focusNode.unfocus();
      });
      await chatProvider.sendMessageAndGetAnswers(
          msg: msg);
     
      setState(() {});
    } catch (error) {
      log("error $error");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: TextWidget(
          label: error.toString(),
        ),
        backgroundColor: const Color.fromARGB(255, 196, 52, 42),
      ));
    } finally {
      setState(() {
        scrollListToEND();
        _isTyping = false;
      });
    }
  }
}