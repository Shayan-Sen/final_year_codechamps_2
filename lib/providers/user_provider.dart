
import 'package:flutter/cupertino.dart';

class UserProvider extends ChangeNotifier{

  Future<void> refresh()async{
    notifyListeners();
  }
}