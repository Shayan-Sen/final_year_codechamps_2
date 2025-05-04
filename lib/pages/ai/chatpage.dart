import 'package:final_year_codechamps_2/widgets/jycappbar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';


class ChatPage extends StatelessWidget {
  ChatPage({super.key});
  final String apiKey = dotenv.env['GEMINI_API_KEY']!;

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
            apiKey: apiKey,
          ),
        ),
      ),
    ),
  );
}