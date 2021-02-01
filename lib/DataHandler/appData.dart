import 'package:flutter/cupertino.dart';
import 'package:drivers_app/Models/address.dart';

class AppData extends ChangeNotifier {
  String earnings = "0";
  void updateEarnings(String updatedEarnings) {
    earnings = updatedEarnings;
    notifyListeners();
  }
}
