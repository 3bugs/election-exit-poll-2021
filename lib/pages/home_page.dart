import 'package:app/models/candidate.dart';
import 'package:app/pages/result_page.dart';
import 'package:app/pages/widgets/candidate_button.dart';
import 'package:app/services/api.dart';
import 'package:app/utils/dialog.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 28.0),
                    child: GestureDetector(
                      onTap: () => setState(() {
                        _futureCandidateList = _fetchCandidates();
                      }),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/vote_hand.png',
                              width: 100.0),
                          const Text(
                            'EXIT POLL',
                            style: TextStyle(
                                fontSize: 22.0, color: Color(0xFFCDD6DA)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Text('เลือกตั้ง อบต.',
                      style: TextStyle(fontSize: 26.0, color: Colors.white)),
                  const SizedBox(height: 16.0),
                  const Text(
                      'รายชื่อผู้สมัครรับเลือกตั้ง\nนายกองค์การบริหารส่วนตำบลเขาพระ',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16.0, color: Colors.white)),
                  const Text('อำเภอเมืองนครนายก จังหวัดนครนายก',
                      style: TextStyle(fontSize: 16.0, color: Colors.white)),
                  const SizedBox(height: 24.0),
                  Expanded(
                    child: FutureBuilder<List<Candidate>>(
                      future: _futureCandidateList,
                      builder: (context, snapshot) {
// กรณีสถานะของ Future ยังไม่สมบูรณ์
                        if (snapshot.connectionState != ConnectionState.done) {
                          return Center(
                            child: CircularProgressIndicator(
                                color: Colors.white.withOpacity(0.6)),
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
                                    padding: const EdgeInsets.fromLTRB(
                                        12.0, 6.0, 12.0, 12.0),
                                    child: Text(
                                      'ผิดพลาด: ${snapshot.error}',
                                      textAlign: TextAlign.center,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        _futureCandidateList =
                                            _fetchCandidates();
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
                                onClick: () =>
                                    _handleClickCandidateButton(candidate),
                              );
                            },
                          );
                        }

                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton(
                      onPressed: _handleClickResultButton,
                      child: const Text('ดูผล'),
                    ),
                  ),
                ],
              ),
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
        ),
      ),
    );
  }

  Future<List<Candidate>> _fetchCandidates() async {
    List list = await Api().fetch('exit_poll');
    return list.map((item) => Candidate.fromJson(item)).toList();
  }

  _handleClickCandidateButton(Candidate candidate) {
    setState(() {
      _isLoading = true;
    });
    Future.delayed(const Duration(milliseconds: 500), () async {
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
    });
  }

  _handleClickResultButton() {
    Navigator.pushNamed(context, ResultPage.routeName);
  }
}
