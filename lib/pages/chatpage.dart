import 'package:final_year_codechamps_2/widgets/jycappbar.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';


class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: JycAppbar(data: "Chat Page"),
    body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue,
            Colors.white,
          ],
        ),
      ),
      child: LlmChatView(
        style: LlmChatViewStyle(
          backgroundColor: Colors.black38
        ),
        provider: GeminiProvider(
          model: GenerativeModel(
            model: 'gemini-2.0-flash',
            apiKey: 'AIzaSyBfpGQmKYu7eD89E22QWEARNy67HCRCkb0',
          ),
        ),
      ),
    ),
  );
}