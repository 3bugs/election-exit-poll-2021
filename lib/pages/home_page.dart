import 'package:flutter/material.dart';
import 'package:app/models/candidate.dart';
import 'package:app/pages/result_page.dart';
import 'package:app/pages/widgets/candidate_button.dart';
import 'package:app/pages/widgets/header.dart';
import 'package:app/pages/widgets/my_scaffold.dart';
import 'package:app/services/api.dart';
import 'package:app/utils/dialog.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home_page';

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<Candidate>>? _futureCandidateList;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    _futureCandidateList = _fetchCandidates();
  }

  Future<List<Candidate>> _fetchCandidates() async {
    List list = await Api().fetch('exit_poll');
    return list.map((item) => Candidate.fromJson(item)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      child: Stack(
        children: [
          Column(
            children: [
              const Header(title: 'เลือกตั้ง อบต.'),
              const Padding(
                padding: EdgeInsets.only(top: 16.0, bottom: 24.0),
                child: Text(
                  'รายชื่อผู้สมัครรับเลือกตั้ง\nนายกองค์การบริหารส่วนตำบลเขาพระ\nอำเภอเมืองนครนายก จังหวัดนครนายก',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
              ),
              Expanded(
                child: _buildList(),
              ),
              _buildResultButton(),
            ],
          ),
// loading icon สำหรับตอนบันทึกโพล
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(
                    color: Colors.white.withOpacity(0.6)),
              ),
            )
        ],
      ),
    );
  }

  FutureBuilder<List<Candidate>> _buildList() {
    return FutureBuilder<List<Candidate>>(
      future: _futureCandidateList,
      builder: (context, snapshot) {
// กรณีสถานะของ Future ยังไม่สมบูรณ์ เช่น ขณะที่รอข้อมูลจาก API
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(
            child:
                CircularProgressIndicator(color: Colors.white.withOpacity(0.6)),
          );
        }

// กรณีสถานะของ Future สมบูรณ์แล้ว แต่เกิด Error
        if (snapshot.hasError) {
          return Center(
            child: Container(
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 12.0),
                    child: Text(
                      'ผิดพลาด: ${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _futureCandidateList = _fetchCandidates();
                      });
                    },
                    child: const Text('RETRY'),
                  ),
                ],
              ),
            ),
          );
        }

// กรณีสถานะของ Future สมบูรณ์ และสำเร็จ
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var candidate = snapshot.data![index];
              return CandidateButton(
                candidate: candidate,
                onClick: () => _handleClickCandidateButton(candidate),
              );
            },
          );
        }

// กรณีอื่นๆ
        return const SizedBox.shrink();
      },
    );
  }

  Container _buildResultButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: _handleClickResultButton,
        child: const Text('ดูผล'),
      ),
    );
  }

  _handleClickCandidateButton(Candidate candidate) async {
    setState(() {
      _isLoading = true;
    });
    try {
      var result = await Api()
          .submit('exit_poll', {'candidateNumber': candidate.number});
      showMaterialDialog(context, 'SUCCESS', 'บันทึกข้อมูลสำเร็จ $result');
    } catch (e) {
      showMaterialDialog(context, 'ERROR', e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  _handleClickResultButton() {
    Navigator.pushNamed(context, ResultPage.routeName);
  }
}
