import 'package:flutter/material.dart';

class JYCLoginFormField extends StatefulWidget {
  const JYCLoginFormField({
    super.key,
    this.obscureText = false,
    this.hintText,
    this.controller,
    this.validator,
    required this.labelText,
  });
  final bool obscureText;
  final String? hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String labelText;

  @override
  State<JYCLoginFormField> createState() => _JYCLoginFormFieldState();
}

class _JYCLoginFormFieldState extends State<JYCLoginFormField> {
  late bool isPressed;

  @override
  void initState() {
    super.initState();
    isPressed = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: TextFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          suffixIcon:
              (widget.obscureText)
                  ? IconButton(
                    onPressed: () {
                      setState(() {
                        isPressed = !isPressed;
                      });
                    },
                    icon:
                        (isPressed)
                            ? Icon(Icons.remove_red_eye_outlined)
                            : Icon(Icons.remove_red_eye_rounded),
                  )
                  : null,
          hintText: widget.hintText,
          fillColor: Colors.white54,
          filled: true,
          labelText: widget.labelText,
        ),
        obscureText: isPressed,
        controller: widget.controller,
        validator: widget.validator,
      ),
    );
  }
}
