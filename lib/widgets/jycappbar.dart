import 'package:flutter/material.dart';

class JycAppbar extends StatelessWidget implements PreferredSizeWidget{
  const JycAppbar({super.key, required this.data, this.actions});
  final String data;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      foregroundColor: Colors.white,
      backgroundColor: Colors.blue,
      shadowColor: Colors.black,
      elevation: 4,
      title: Text(data),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
