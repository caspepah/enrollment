class Subject {
  final String name;
  final int credits;

  Subject({
    required this.name,
    required this.credits,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'credits': credits,
    };
  }

  factory Subject.fromMap(Map<String, dynamic> map) {
    return Subject(
      name: map['name'] ?? '',
      credits: map['credits'] ?? 0,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Subject && other.name == name && other.credits == credits;
  }

  @override
  int get hashCode => name.hashCode ^ credits.hashCode;
}
