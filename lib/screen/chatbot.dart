import 'package:dialog_flowtter/dialog_flowtter.dart';

import 'package:flutter/material.dart';

import '../helper/message.dart';

class Chatbotsupport extends StatefulWidget {
  const Chatbotsupport({Key? key}) : super(key: key);

  @override
  _ChatbotsupportState createState() => _ChatbotsupportState();
}

class _ChatbotsupportState extends State<Chatbotsupport> {
  late DialogFlowtter dialogFlowtter;
  final TextEditingController _controller = TextEditingController();

  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    DialogFlowtter.fromFile().then((instance) => dialogFlowtter = instance);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Write your query here?",
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 20,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(child: MessagesScreen(messages: messages)),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 1, vertical: 0),
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color.fromARGB(103, 255, 255, 255),
              ),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: _controller,
                    style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    decoration: InputDecoration(
                      //label text and style
                      // labelText: 'Type your query here',
                      // labelStyle: TextStyle(
                      //   color: Color.fromARGB(255, 139, 13, 236),
                      // ),

                      hintText: 'What is use of the App?',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 154, 120, 255),
                          width: 0,
                        ),
                        borderRadius: BorderRadius.circular(30.0),
                        //thickness: 5,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 0,
                          color: Color.fromRGBO(158, 136, 255, 1),
                        ),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  )),
                  IconButton(
                    onPressed: () {
                      sendMessage(_controller.text);
                      _controller.clear();
                      FocusScope.of(context).unfocus();
                    },
                    icon: Icon(Icons.send_outlined),
                    color: Color.fromARGB(255, 139, 13, 236),
                    iconSize: 30,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  sendMessage(String text) async {
    if (text.isEmpty) {
      print('Message is empty');
    } else {
      setState(() {
        addMessage(Message(text: DialogText(text: [text])), true);
      });

      DetectIntentResponse response = await dialogFlowtter.detectIntent(
          queryInput: QueryInput(text: TextInput(text: text)));
      if (response.message == null) return;
      setState(() {
        addMessage(response.message!);
      });
    }
  }

  addMessage(Message message, [bool isUserMessage = false]) {
    messages.add({'message': message, 'isUserMessage': isUserMessage});
  }
}
