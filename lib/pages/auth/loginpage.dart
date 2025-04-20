import 'package:final_year_codechamps_2/pages/home/homepage.dart';
import 'package:final_year_codechamps_2/pages/auth/signuppage.dart';
import 'package:final_year_codechamps_2/services/auth_services.dart';
import 'package:final_year_codechamps_2/widgets/jycloginformfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  final AuthServices _authServices = AuthServices();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _navigateToHomePage() {
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }

  void _navigationFailed(String message){
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Authentication failed: $message")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.blue.shade100,
          alignment: Alignment.center,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(flex: 1, child: SizedBox()),
                Text(
                  "Smart Tutor",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                Expanded(flex: 3, child: SizedBox()),
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
                    if (value == null || value.isEmpty) {
                      return "Please enter your password";
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try{
                        UserCredential credential = await _authServices.signIn(
                          email: _emailController.text.trim(),
                          password: _passwordController.text.trim(),
                        );
                        if (credential.user != null) {
                          _navigateToHomePage();
                        }
                      }on FirebaseAuthException catch (e){
                        if (mounted) {
                          _navigationFailed(e.message ?? "Unknown error");
                        }
                    }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Please fill all the fields")),
                      );
                    }
                  },
                  child: Text("Login"),
                ),
                Expanded(flex: 3, child: SizedBox()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => SignupPage()),
                        );
                      },
                      child: Text("Sign Up"),
                    ),
                  ],
                ),
                Expanded(flex: 1, child: SizedBox()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
