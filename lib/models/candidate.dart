class Candidate {
  final int number;
  final String title;
  final String firstName;
  final String lastName;
  final int? score;

  Candidate({
    required this.number,
    required this.title,
    required this.firstName,
    required this.lastName,
    required this.score,
  });

  factory Candidate.fromJson(Map<String, dynamic> json) {
    return Candidate(
      number: json['number'],
      title: json['title'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      score: json['score'],
    );
  }
}
