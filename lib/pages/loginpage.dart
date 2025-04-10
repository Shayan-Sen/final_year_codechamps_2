import 'package:final_year_codechamps_2/pages/homepage.dart';
import 'package:final_year_codechamps_2/widgets/jycloginformfield.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.green,
        alignment: Alignment.center,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              JYCLoginFormField(
                hintText: "Enter your Username",
                labelText: "Username",
                controller: _emailController,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your email";
                  }
                  return null;
                },
              ),
              JYCLoginFormField(
                hintText: "Enter your Password",
                labelText: "Password",
                obscureText: true,
                controller: _passwordController,
                validator: (String? value) {
                  if (value == null || value.isEmpty ) {
                    return "Please enter your password";
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Email: ${_emailController.text}   Password: ${_passwordController.text}"),
                      ),
                    );
                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Please fill all the fields"),
                      ),
                    );
                  }
                },
                child: Text("Home Page"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
