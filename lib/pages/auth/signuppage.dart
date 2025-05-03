import 'package:file_picker/file_picker.dart';
import 'package:final_year_codechamps_2/pages/auth/loginpage.dart';
import 'package:final_year_codechamps_2/services/teacher_services.dart';
import 'package:final_year_codechamps_2/widgets/jycloginformfield.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatelessWidget {
  SignupPage({super.key});

  final ButtonStyle _buttonStyle = ButtonStyle(
    backgroundColor: WidgetStatePropertyAll<Color>(Colors.blue.shade900),
    foregroundColor: WidgetStatePropertyAll<Color>(Colors.white),
    shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    minimumSize: WidgetStatePropertyAll<Size>(Size(double.infinity, 50)),
    textStyle: WidgetStatePropertyAll<TextStyle>(TextStyle(fontSize: 25)),
    elevation: WidgetStatePropertyAll<double>(5),
    shadowColor: WidgetStatePropertyAll<Color>(Colors.grey),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade900, Colors.white],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Navigator.pushReplacement(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => StudentPageView(),
                    //   ),
                    // );
                  },
                  style: _buttonStyle,
                  child: Text("Student"),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TeacherPageView(),
                      ),
                    );
                  },
                  style: _buttonStyle,
                  child: Text("Teacher"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TeacherPageView extends StatefulWidget {
  const TeacherPageView({super.key});

  @override
  State<TeacherPageView> createState() => _TeacherPageViewState();
}

class _TeacherPageViewState extends State<TeacherPageView> {
  final TeacherServices services = TeacherServices();
  final GlobalKey<FormState> _nameformKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _emailformKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _passwordformKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _aboutformKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _edqualiformKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _fileformKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  final TextEditingController _edqualificationController =
      TextEditingController();
  FilePickerResult? filePickerResult;

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _aboutController.dispose();
    _edqualificationController.dispose();
    super.dispose();
  }

  Widget _filePickerField() {
    return FormField<FilePickerResult>(
      initialValue: filePickerResult,
      validator:
          (value) =>
              value == null
                  ? 'Please pick your proof of education file.'
                  : null,
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () async {
                final result = await FilePicker.platform.pickFiles(
                  type: FileType.any,
                  allowMultiple: false,
                );
                setState(() {
                  filePickerResult = result;
                  field.didChange(result);
                });
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Proof of Education',
                  errorText: field.errorText,
                  border: const OutlineInputBorder(),
                ),
                child: Text(
                  filePickerResult?.files.first.name ?? 'No file chosen',
                  style: TextStyle(
                    color:
                        filePickerResult != null
                            ? Colors.black87
                            : Colors.black38,
                  ),
                ),
              ),
            ),
            if (filePickerResult != null)
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    filePickerResult = null;
                    field.didChange(null);
                  });
                },
                icon: const Icon(Icons.clear),
                label: const Text('Clear'),
              ),
          ],
        );
      },
    );
  }

  void _submit() async{
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final about = _aboutController.text.trim();
    final edqualification = _edqualificationController.text.trim();
    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        about.isEmpty ||
        edqualification.isEmpty ||
        filePickerResult == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all the fields")),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignupPage()),
      );
    } else {
      String message = await services.signUp(
        name: name,
        email: email,
        password: password,
        about: about,
        educationQualification: edqualification,
        proofOfEd: filePickerResult!,
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
      print(message);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  int _currentPage = 0;
  void _nextPage() {
    if (_currentPage < 5) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 400),
        curve: Curves.ease,
      );
    } else {
      _submit();
    }
  }

  Widget _buildPage({
    required String label,
    required GlobalKey<FormState> formKey,
    required String description,
    required String buttonText,
    required Widget fieldWidget,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(label, style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 24),
              Text(description),
              const SizedBox(height: 50),
              fieldWidget,
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    _nextPage();
                  }
                },
                child: Text(buttonText),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("SmartTutor")),
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: (index) => setState(() => _currentPage = index),
        children: [
          //Name
          _buildPage(
            formKey: _nameformKey,
            label: "Name",
            description:
                "Enter your name here.This will appear in your profile as your registered teacher name",
            buttonText: "Next",
            fieldWidget: JYCLoginFormField(
              labelText: "Teacher name",
              controller: _nameController,
              hintText: "Enter your name",
              validator: (p0) {
                if (p0 == null || p0.isEmpty) {
                  return "Please enter your name";
                }
                return null;
              },
            ),
          ),

          // about
          _buildPage(
            formKey: _aboutformKey,
            label: "About",
            description: "Write something about yourself",
            buttonText: "Next",
            fieldWidget: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _aboutController,
                decoration: InputDecoration(
                  labelText: "About",
                  hintText: "Write something about yourself",
                ),
                validator: (p0) {
                  if (p0 == null || p0.isEmpty) {
                    return "Please enter something about yourself";
                  }
                  return null;
                },
              ),
            ),
          ),

          // Education Qualification
          _buildPage(
            formKey: _edqualiformKey,
            label: "Education Qualification",
            description: "Enter your education qualification",
            buttonText: "Next",
            fieldWidget: JYCLoginFormField(
              labelText: "Education Qualification",
              controller: _edqualificationController,
              hintText: "Enter your education qualification",
              validator: (p0) {
                if (p0 == null || p0.isEmpty) {
                  return "Please enter your education qualification";
                }
                return null;
              },
            ),
          ),

          //Proof of Education
          _buildPage(
            formKey: _fileformKey,
            label: "Proof of Education",
            description: "Upload your proof of education",
            buttonText: "Next",
            fieldWidget: _filePickerField(),
          ),

          //Email
          _buildPage(
            formKey: _emailformKey,
            label: "Email",
            description: "Enter your email id",
            buttonText: "Next",
            fieldWidget: JYCLoginFormField(
              labelText: "Email",
              controller: _emailController,
              hintText: "Enter your email id",
              validator: (p0) {
                if (p0 == null || p0.isEmpty) {
                  return "Please enter your email id";
                }
                return null;
              },
            ),
          ),

          //Password
          _buildPage(
            formKey: _passwordformKey,
            label: "Password",
            description: "Enter your password here",
            buttonText: "Submit",
            fieldWidget: JYCLoginFormField(
              labelText: "Password",
              controller: _passwordController,
              hintText: "Enter your password",
              obscureText: true,
              validator: (p0) {
                if (p0 == null || p0.isEmpty) {
                  return "Please enter your password";
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}
