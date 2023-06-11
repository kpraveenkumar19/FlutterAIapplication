import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:mdg_project/constants/api_consts.dart';
import 'package:mdg_project/models/chat_model.dart';

import 'package:http/http.dart' as http;

class ApiService {

  // Send Message using ChatGPT API
  static Future<List<ChatModel>> sendMessageGPT(
      {required String message}) async {
    try {

      var response = await http.post(
        Uri.parse("$BASE_URL/chat/completions"),
        headers: {
          'Authorization': 'Bearer $API_KEY',
          "Content-Type": "application/json"
        },
        body: jsonEncode(
          {
            "model": "gpt-3.5-turbo",
            "messages": [
              {
                "role": "user",
                "content": message,
              }
            ]
          },
        ),
      );

      
      Map data  = json.decode(utf8.decode(response.bodyBytes));
      if (data ['error'] != null) {
      
        throw HttpException(data ['error']["message"]);
      }
      List<ChatModel> chatList = [];
      if (data ["choices"].length > 0) {
       
        chatList = List.generate(
          data ["choices"].length,
          (index) => ChatModel(
            msg: data ["choices"][index]["message"]["content"],
            chatIndex: 1,
          ),
        );
      }
      return chatList;
    } catch (error) {
      log("error $error");
      rethrow;
    }
  }
  // Text to Image 
  static  imageGenerator(
      {required String message}) async {
   

      var response = await http.post(
        Uri.parse("$BASE_URL/images/generations"),
        headers: {
          'Authorization': 'Bearer $API_KEY',
          "Content-Type": "application/json"
        },
        body: jsonEncode(
          {
            "prompt": message,
            "n": 1,
            "size": "1024x1024"
          },
        ),
      );

      if(response.statusCode==200){
        var data  =jsonDecode(response.body.toString());
        return data ['data'][0]['url'].toString();
    
      }
      else{

      }
    
  }
  
}