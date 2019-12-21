
import 'package:flutter/material.dart';

class TimerData extends ChangeNotifier {
  DateTime curTimerValue = DateTime(2019);
  bool isTimerWork = false;

  setTimer(DateTime dateTime){
    curTimerValue = dateTime;
    notifyListeners();
  }

  setTimerWork(bool newState){
    isTimerWork = newState;
    notifyListeners();
  }

}