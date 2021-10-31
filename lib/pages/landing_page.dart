import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:app/pages/home_page.dart';
import 'package:app/utils/dialog.dart';

const dateFormat = 'MM/dd/yyyy, hh:mm a';
const examDateTimeText = '10/31/2021, 9:00 AM';

class LandingPage extends StatefulWidget {
  static const routeName = '/landing_page';

  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg_landing.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              _buildHeader(),
              _buildFooter(),
              _buildMenuButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Column _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: const [
        Text(
          'สอบปลายภาค',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 45.0, color: Color(0xFFA00000)),
        ),
        SizedBox(height: 5.0),
        Text(
          'วิชา Mobile Application Development',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 25.0),
        ),
        SizedBox(height: 5.0),
        Text(
          'CP SU 1/2564',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 25.0),
        ),
      ],
    );
  }

  Align _buildFooter() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          CountDownTimer(),
          Text(
            'ขอให้นักศึกษาทุกคนโชคดี 🎉',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25.0),
          ),
        ],
      ),
    );
  }

  Padding _buildMenuButtons() {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;

    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: (width > 500 ? 0.1 : 0.05) * width),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildButton(
              context: context,
              label: 'ข้อสอบ',
              onClick: () async {
                if (!_isExamTime()) return;
                launch('https://bit.ly/3bq5iA3');
              }),
          _buildButton(
              context: context,
              label: 'Application',
              onClick: () async {
                if (!_isExamTime()) return;
                Navigator.pushNamed(context, HomePage.routeName);
              }),
          _buildButton(
              context: context,
              label: 'แบบฟอร์มส่งข้อสอบ',
              onClick: () {
                if (!_isExamTime()) return;
                launch('https://forms.gle/tCLJCBhbEWYsdZTr8');
              }),
        ],
      ),
    );
  }

  bool _isExamTime() {
    var examDateTime = DateFormat(dateFormat).parse(examDateTimeText);
    if (DateTime.now().isBefore(examDateTime)) {
      showMaterialDialog(
        context,
        'ยังไม่ถึงเวลาสอบ',
        'การสอบจะเริ่มในเวลา 9.00 น. วันอาทิตย์ที่ 31 ตุลาคม พ.ศ. 2564',
      );
      return false;
    }
    return true;
  }

  Widget _buildButton({
    required BuildContext context,
    required String label,
    required Function() onClick,
  }) {
    var screenSize = MediaQuery.of(context).size;
    var height = screenSize.height;

    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(0.012 * height),
            child: ElevatedButton(
              onPressed: onClick,
              style: ElevatedButton.styleFrom(
                primary: const Color(0xAA006000),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 2.0),
                child: Text(label, style: const TextStyle(fontSize: 25.0)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CountDownTimer extends StatefulWidget {
  const CountDownTimer({Key? key}) : super(key: key);

  @override
  _CountDownTimerState createState() => _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    if (_timer != null) _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var examDateTime = DateFormat(dateFormat).parse(examDateTimeText);
    var diffMilli = examDateTime.millisecondsSinceEpoch -
        DateTime.now().millisecondsSinceEpoch;

    if (diffMilli < 0) return const SizedBox.shrink();

    const milliPerSecond = 1000;
    const milliPerMinute = 60 * milliPerSecond;
    const milliPerHour = 60 * milliPerMinute;

    var hoursLeft = diffMilli ~/ milliPerHour;
    var milliLeft = diffMilli % milliPerHour;
    var minutesLeft = milliLeft ~/ milliPerMinute;
    milliLeft = milliLeft % milliPerMinute;
    var secondsLeft = milliLeft ~/ milliPerSecond;

    return Column(
      children: [
        const Text(
          'นับถอยหลัง เริ่มการสอบ',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20.0),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCountDownItem(hoursLeft, 'Hours'),
            _buildCountDownItem(minutesLeft, 'Minutes'),
            _buildCountDownItem(secondsLeft, 'Seconds'),
          ],
        ),
      ],
    );
  }

  Widget _buildCountDownItem(int num, String unit) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            width: 55.0,
            height: 55.0,
            decoration: const BoxDecoration(
              color: Color(0xFFA00000),
              shape: BoxShape.circle,
            ),
            child: Text(
              num.toString(),
              style: const TextStyle(
                fontSize: 22.0,
                color: Colors.white,
              ),
            ),
          ),
          Text(unit, style: const TextStyle(fontSize: 16.0))
        ],
      ),
    );
  }
}
