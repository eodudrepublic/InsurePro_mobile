class Team {
  final int pk;
  final String teamName;

  Team({required this.pk, required this.teamName});

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      pk: json['pk'],
      teamName: json['teamName'],
    );
  }
}
