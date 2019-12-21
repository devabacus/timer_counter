import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timer_stopwatch/styles/text_styles.dart';
import 'package:timer_stopwatch/timerData.dart';
import 'package:vibration/vibration.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TimerData>(
      create: (_) => TimerData(),
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text("Timer/StopWatch"),
          ),
          body: TimerWidget(),
        ),
      ),
    );
  }
}

class TimerWidget extends StatelessWidget{
  Timer mTimer;
  TimerData timerData;
  DateTime get timerVal => timerData.curTimerValue;
  bool get isTimerWork => timerData.isTimerWork;
  timerSet(DateTime newTime) => timerData.setTimer(newTime);
  setIsWork(bool newValue) => timerData.setTimerWork(newValue);

  _startTimer() {
    setIsWork(true);
    mTimer = Timer.periodic(Duration(seconds: 1), (_timer) {
      timerSet(timerVal.subtract(Duration(seconds: 1)));
      if (timerVal.compareTo(DateTime(2019)) == 0) {
        _timer.cancel();
        Vibration.vibrate(duration: 1000);
        setIsWork(false);
        print("timer is finished");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    timerData = Provider.of<TimerData>(context);
    if(mTimer == null) mTimer = Timer(Duration(seconds: 1), () {});
    return InkWell(
      onLongPress: () {
        if (mTimer.isActive) {
          mTimer.cancel();
          setIsWork(false);
        }
        timerSet(DateTime(2019));
      },
      onTap: () {
        if (mTimer.isActive) {
          mTimer.cancel();
          timerData.setTimerWork(false);
        } else {
          if (timerVal != DateTime(2019)) {
            _startTimer();
          } else {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text("Установите значение таймера"),
              backgroundColor: Colors.blueAccent,
            ));
          }
        }
      },
      child: Row(
        children: <Widget>[
          _timeSett(Duration(hours: 1), "HH : "),
          _timeSett(Duration(minutes: 1), "mm"),
          _timeSett(Duration(seconds: 1), " : ss")
        ],
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
      ),
    );
  }

  Widget _timeSett(Duration duration, String format) {
    return Column(children: <Widget>[
      Offstage(
        offstage: isTimerWork,
        child: IconButton(
            icon: Icon(Icons.add),
            onPressed: () => timerSet(timerVal.add(duration))),
      ),
      Text(
        DateFormat(format).format(timerVal),
        style: mTextStyles.mFont1,
      ),
      Offstage(
        offstage: isTimerWork,
        child: IconButton(
            icon: Icon(Icons.remove),
            onPressed: () => timerSet(timerVal.subtract(duration))),
      )
    ]);
  }
}
