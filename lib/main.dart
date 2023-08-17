import 'package:chatgpt_laith/chat_storage.dart';
import 'package:chatgpt_laith/get_responser_chat.dart';
import 'package:chatgpt_laith/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';


void main() => runApp(const ChatGPT());

class ChatGPT extends StatelessWidget {
  const ChatGPT({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CHAT-GPT - Flutter',
      home: Scaffold(
        body: Builder(
          builder: (context) => const ChatContent(),
        ),
      ),
    );
  }
}

class Message {
  Message({
    required this.isResponse,
    required this.message,
  });

  final bool isResponse;
  String message;

  Map<String, dynamic> toJson() {
    return {
      'isResponse': isResponse,
      'message': message,
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      isResponse: json['isResponse'] as bool,
      message: json['message'] as String,
    );
  }
}

class ChatContent extends StatefulWidget {
  const ChatContent({Key? key}) : super(key: key);

  @override
  State<ChatContent> createState() => _ChatContentState();
}

class _ChatContentState extends State<ChatContent> {
  final List<Message> messages = [];
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    retrieveSavedMessages();
  }

  @override
  void dispose() {
    saveMessages();
    super.dispose();
  }

  Future<void> saveMessages() async {
    await ChatStorage.saveMessages(messages);
  }

  Future<void> retrieveSavedMessages() async {
    final savedMessages = await ChatStorage.retrieveMessages();
    setState(() {
      messages.addAll(savedMessages);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        // AppBar(
        //   // backgroundColor: Colors.green,
        //   title: const Text(
        //     'Chat Laith',
        //     style: TextStyle(
        //         fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
        //   ),
        // ),
        body: Stack(
          children: [
            Image.asset(
              'images/ic_background.jpg',
              fit: BoxFit.fill,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
            ClipPath(
              clipper: OvalBottomBorderClipper(),
              child: Container(
                height: 84,
                width: MediaQuery.of(context).size.width,
                color: Colors.green,
                child: const Center(child:  Text("Chat Laith",style: TextStyle(fontSize: 35,color: Colors.white,fontWeight: FontWeight.bold),)),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 60,left: 8,right: 8,bottom: 8),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        return MessageBubble(
                          isResponse: message.isResponse,
                          message: message.message,
                          senderName: message.isResponse ? 'Chat-Laith' : 'أنت',
                        );
                      },
                    ),
                  ),
                  Stack(
                    children: [
                      if (islooding)
                        Container(
                          child: spinkit,
                        ),
                      Padding(
                        padding: const EdgeInsets.only(left: 320),
                        child: IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.lightGreen,
                          ),
                          onPressed: () {
                            setState(() {
                              messages.clear();
                            });
                            saveMessages(); // حفظ الرسائل المحذوفة
                          },
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 5.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15.0),
                            child: TextField(
                              controller: controller,
                              decoration: const InputDecoration(
                                hintText: 'اكتب سؤالك هنا...',
                                border: InputBorder.none,
                              ),
                              style: const TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.send,
                            color: Colors.lightGreen,
                          ),
                          onPressed: () {
                            final userMessage = controller.text;
                            if (userMessage.isNotEmpty && !islooding) {
                              controller.clear();
                              sendMessage(userMessage);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static bool islooding = false;
  static const spinkit = Center(
    child: SpinKitSpinningLines(
      color: Colors.lightGreenAccent,
      size: 50.0,
    ),
  );

  Future<void> sendMessage(String userMessage) async {
    if (userMessage == 'delete') {
      setState(() {
        messages.clear();
      });
      saveMessages(); // حفظ الرسائل المحذوفة
      return;
    }

    setState(() {
      messages.add(Message(isResponse: false, message: userMessage));
      islooding = true;
    });

    final response = await getChatGptResponse(question: userMessage);

    setState(() {
      messages.add(Message(isResponse: true, message: response));
      islooding = false;
    });
    saveMessages(); // Save the updated messages
  }
}
