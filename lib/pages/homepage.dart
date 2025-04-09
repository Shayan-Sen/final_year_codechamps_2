import 'package:final_year_codechamps_2/widgets/jycappbar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: JycAppbar(data: "Final Year CodeChamps"),
      body: Center(
        child: Text(
          "Welcome to Home Page of final year \n codechamps",
          style: TextStyle(fontSize: 19),
        ),
      ),
    );
  }
}
