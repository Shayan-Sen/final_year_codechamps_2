import 'package:final_year_codechamps_2/pages/home/homepage.dart';
import 'package:final_year_codechamps_2/pages/auth/signuppage.dart';
import 'package:final_year_codechamps_2/services/student_services.dart';
import 'package:final_year_codechamps_2/services/teacher_services.dart';
import 'package:final_year_codechamps_2/widgets/jycloginformfield.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TeacherServices teacherServices = TeacherServices();
  final StudentServices studentServices = StudentServices();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _selectedRole;


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

  void _navigationSuccessful(String message){
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  void _submit() async {
    if (_selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a role")),
      );
      return;
    }

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    String message;
    bool loginSuccess = false;

    if (_selectedRole == 'Teacher') {
      message = await teacherServices.login(
          email: email, password: password);
      // Check if login was successful
      loginSuccess = message.contains("successfully");
    }
    else if (_selectedRole == 'Student') {
      message = await studentServices.login(
          email: email, password: password);
      // Check if login was successful
      loginSuccess = message.contains("successfully");
    }
    else {
      message = 'Invalid role selected';
    }

    // Show appropriate message and navigate only if login was successful
    if (loginSuccess) {
      _navigationSuccessful(message);
      _navigateToHomePage();
    } else {
      _navigationFailed(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
              Padding(
                padding: const EdgeInsets.all(22.0),
                child: Container(
                  color: Colors.white54,
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Select Role',
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedRole,
                    items: ['Teacher', 'Student']
                        .map((role) => DropdownMenuItem(
                      value: role,
                      child: Text(role),
                    ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedRole = value;
                      });
                    },
                    validator: (value) =>
                    value == null ? 'Please select a role' : null,
                  ),
                ),
              ),
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
                    _submit();
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
                      Navigator.push(
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
    );
  }
}
