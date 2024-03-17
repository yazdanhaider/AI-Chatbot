import 'dart:convert';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  ChatUser myself = ChatUser(id: "1", firstName: "YAZDAN" );
  ChatUser bot = ChatUser(id: "2", firstName: "Gennie" );
  List<ChatMessage> allMessages = [];
  List<ChatUser> typing = [];

  final ourUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=AIzaSyB5eY4YAOGa3O__LTvi0PwUIZEFitWD87c";
  final header = {
    'Content-Type': 'application/json'
  };

  getData(ChatMessage m) async {
    var data = {"contents":[{"parts":[{"text": m.text}]}]};
    typing.add(bot);
    allMessages.insert(0, m);
    setState(() {});

    await http.post(Uri.parse(ourUrl), headers: header, body: jsonEncode(data)).
    then((value){
      if(value.statusCode==200){
        var result = jsonDecode(value.body);
        print(result["candidates"][0]["content"]["parts"][0]["text"]);

        ChatMessage m1 = ChatMessage(
            user: bot,
            createdAt: DateTime.now(),
          text: result["candidates"][0]["content"]["parts"][0]["text"],
        );

        allMessages.insert(0, m1);
      }else{
        print("Error occurred");
      }
    }).
    catchError((e){});
    typing.remove(bot);

    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gennie Bot')
      ),
      body: DashChat(
        messageOptions: MessageOptions(
          showTime: true
        ),
        typingUsers: typing,
        currentUser: myself,
        onSend: (ChatMessage m) {
          getData(m);
        },
        messages: allMessages,
      ),
    );
  }
}
