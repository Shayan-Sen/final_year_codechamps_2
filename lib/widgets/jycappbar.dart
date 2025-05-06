import 'package:flutter/material.dart';

class JycAppbar extends StatelessWidget implements PreferredSizeWidget{
  const JycAppbar({super.key, required this.data, this.actions});
  final String data;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: 90,
      leading: Builder(
        builder: (context) {
      return Center(child: Text("SmartTutor",style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),));
    }
    ),
      centerTitle: true,
      foregroundColor: Colors.white,
      backgroundColor: Color(0xFF001B4D),
      shadowColor: Colors.black,
      elevation: 4,
      title: Text(data),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
