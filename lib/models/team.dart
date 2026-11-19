class Team {
  final String id;
  final String name;
  final String displayName;
  Team({required this.id, required this.name, required this.displayName});

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'],
      name: json['name'] ?? '',
      displayName: json['display_name'] ?? '',
    );
  }
}
