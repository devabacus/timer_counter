import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timer_stopwatch/styles/text_styles.dart';
import 'package:vibration/vibration.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Timer/StopWatch"),
        ),
        body: TimerWidget(),
      ),
    );
  }
}

class TimerWidget extends StatefulWidget {
  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  DateTime curTimerValue = DateTime(2019);
  bool set = true;
  Timer mTimer = Timer(Duration(seconds: 1), () {});

  _startTimer() {
    setState(() {
      set = false;
    });
    mTimer = Timer.periodic(Duration(seconds: 1), (_timer) {
      setState(() {
        curTimerValue = curTimerValue.subtract(Duration(seconds: 1));
      });
      if (curTimerValue.compareTo(DateTime(2019)) == 0) {
        _timer.cancel();
        Vibration.vibrate(duration: 1000);
        setState(() {
          set = true;
        });
        print("timer is finished");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () {
        setState(() {
          if (mTimer.isActive) {
            mTimer.cancel();
            set = true;
          }
          curTimerValue = DateTime(2019);
        });
      },
      onTap: () => setState(() {
        if (mTimer.isActive) {
          mTimer.cancel();
          set = true;
        } else {
          if (curTimerValue != DateTime(2019)) {
            _startTimer();
          } else {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text("Установите значение таймера"),
              backgroundColor: Colors.blueAccent,
            ));
          }
        }
      }),
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
        offstage: !set,
        child: IconButton(
            icon: Icon(Icons.add),
            onPressed: () =>
                setState(() => curTimerValue = curTimerValue.add(duration))),
      ),
      Text(
        DateFormat(format).format(curTimerValue),
        style: mTextStyles.mFont1,
      ),
      Offstage(
        offstage: !set,
        child: IconButton(
          icon: Icon(Icons.remove),
          onPressed: () =>
              setState(() => curTimerValue = curTimerValue.subtract(duration)),
        ),
      )
    ]);
  }
}
