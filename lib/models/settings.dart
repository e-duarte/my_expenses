class Settings {
  final int? id;
  final double monthValue;

  Settings({
    this.id,
    required this.monthValue,
  });

  factory Settings.fromMap(Map<String, Object?> data) {
    return Settings(
      id: data['id'] as int,
      monthValue: data['monthValue'] as double,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'monthValue': monthValue,
    };
  }

  Settings copyWith({
    int? id,
    double? monthValue,
  }) {
    return Settings(
      id: id ?? this.id,
      monthValue: monthValue ?? this.monthValue,
    );
  }

  @override
  String toString() {
    return '${toMap()}';
  }
}
