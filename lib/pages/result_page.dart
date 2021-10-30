import 'package:app/models/candidate.dart';
import 'package:app/pages/widgets/candidate_button.dart';
import 'package:app/services/api.dart';
import 'package:flutter/material.dart';

class ResultPage extends StatefulWidget {
  static const routeName = '/result_page';

  const ResultPage({Key? key}) : super(key: key);

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  Future<List<Candidate>>? _futureCandidateList;

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
          child: Column(
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
                      Image.asset('assets/images/vote_hand.png', width: 100.0),
                      const Text(
                        'EXIT POLL',
                        style:
                            TextStyle(fontSize: 22.0, color: Color(0xFFCDD6DA)),
                      ),
                    ],
                  ),
                ),
              ),
              const Text('RESULT',
                  style: TextStyle(fontSize: 26.0, color: Colors.white)),
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
                            onClick: null,
                          );
                        },
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<Candidate>> _fetchCandidates() async {
    List list = await Api().fetch('exit_poll/result');
    return list.map((item) => Candidate.fromJson(item)).toList();
  }
}
