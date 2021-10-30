import 'dart:async';
import 'dart:convert';

import 'package:app/pages/home_page.dart';
import 'package:app/utils/dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

const dateFormat = 'MM/dd/yyyy, hh:mm a';
const examDateTimeText = '10/31/2021, 9:00 AM';

class LandingPage extends StatefulWidget {
  static const routeName = '/landing_page';

  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'สอบปลายภาค',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.kanit(
                            fontSize: 45.0, color: const Color(0xFFA00000)),
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        'วิชา Mobile Application Development',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.kanit(fontSize: 25.0),
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        'CP SU 1/2564',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.kanit(fontSize: 25.0),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CountDownTimer(),
                        Text(
                          'ขอให้นักศึกษาทุกคนโชคดี 🎉',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.kanit(fontSize: 25.0),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: (width > 500 ? 0.1 : 0.05) * width),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildButton(context, 'ข้อสอบ', onClick: () async {
                          if (!_isExamTime()) return;

                          /*if (!await _showExam()) {
                            showMaterialDialog(
                              context,
                              'ERROR',
                              'อาจารย์ยังไม่เปิดข้อสอบ',
                            );
                            return;
                          }*/

                          launch('https://bit.ly/3bq5iA3');
                        }),
                        _buildButton(context, 'Application', onClick: () async {
                          if (!_isExamTime()) return;

                          /*if (!await _showExam()) {
                            showMaterialDialog(
                              context,
                              'ERROR',
                              'อาจารย์ยังไม่เปิดข้อสอบ',
                            );
                            return;
                          }*/

                          Navigator.pushNamed(context, HomePage.routeName);
                        }),
                        _buildButton(context, 'แบบฟอร์มส่งข้อสอบ', onClick: () {
                          if (!_isExamTime()) return;

                          /*showMaterialDialog(
                            context,
                            'ERROR',
                            'ขออภัย เลยเวลาส่งข้อสอบแล้ว',
                          );*/

                          launch('https://forms.gle/tCLJCBhbEWYsdZTr8');
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.6),
              child: const Center(
                child: SizedBox(
                  width: 140.0,
                  height: 140.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 8.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
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

  Future<bool> _showExam() async {
    setState(() {
      _isLoading = true;
    });
    var backendUri = Uri.parse('https://rocky-inlet-70419.herokuapp.com/');
    var response = await http.get(backendUri);
    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      //print('RESPONSE BODY: ${response.body}');
      if (jsonDecode(response.body)['showExam'] == 'ok-flutter') {
        return true;
      }
      return false;
    } else {
      return false;
    }
  }

  Widget _buildButton(BuildContext context, String label,
      {required Function() onClick}) {
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
                child: Text(label, style: GoogleFonts.kanit(fontSize: 25.0)),
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
        Text(
          'นับถอยหลัง เริ่มการสอบ',
          textAlign: TextAlign.center,
          style: GoogleFonts.kanit(fontSize: 20.0),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCountDownItem(hoursLeft, 'Hours'),
            _buildCountDownItem(minutesLeft, 'Minutes'),
            _buildCountDownItem(secondsLeft, 'Seconds'),
            /*Text('Hour: $hoursLeft, '),
            Text('Minute: $minutesLeft, '),
            Text('Second: $secondsLeft'),*/
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
              //border: Border.all(color: Colors.grey, width: 2.0),
            ),
            child: Text(
              num.toString(),
              style: GoogleFonts.kanit(
                fontSize: 22.0,
                color: Colors.white,
              ),
            ),
          ),
          Text(unit, style: GoogleFonts.kanit(fontSize: 16.0))
        ],
      ),
    );
  }

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
}
