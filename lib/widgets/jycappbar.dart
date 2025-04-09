import 'package:flutter/material.dart';

class JycAppbar extends StatelessWidget implements PreferredSizeWidget{
  const JycAppbar({super.key, required this.data});
  final String data;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      foregroundColor: Colors.white,
      backgroundColor: Colors.blue,
      shadowColor: Colors.black,
      elevation: 4,
      title: Text(data),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
