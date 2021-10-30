import 'package:app/models/candidate.dart';
import 'package:flutter/material.dart';

class CandidateButton extends StatelessWidget {
  final Candidate candidate;
  final Function()? onClick;

  const CandidateButton({
    Key? key,
    required this.candidate,
    required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 32.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onClick,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.75),
            ),
            child: Row(
              children: [
                Container(
                  width: 52.0,
                  height: 52.0,
                  decoration: const BoxDecoration(color: Colors.green),
                  child: Center(
                    child: Text(
                      '${candidate.number}',
                      style:
                          const TextStyle(fontSize: 32.0, color: Colors.white),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      '${candidate.title}${candidate.firstName} ${candidate.lastName}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ),
                if (candidate.score != null)
                  SizedBox(
                    width: 52.0,
                    height: 52.0,
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: Text(
                          candidate.score.toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
