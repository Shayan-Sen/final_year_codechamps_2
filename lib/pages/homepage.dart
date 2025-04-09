import 'package:final_year_codechamps_2/pages/loginpage.dart';
import 'package:final_year_codechamps_2/widgets/jycappbar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: JycAppbar(data: "Final Year CodeChamps"),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Welcome to Home Page of final year \n codechamps \n\n Kaioken Times 20 !!!! ",
              style: TextStyle(fontSize: 19),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text("Login Page"),
            ),
          ],
        ),
      ),
    );
  }
}
