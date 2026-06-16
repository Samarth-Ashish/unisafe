class Admin {
  final String email;
  final int block;

  Admin({
    required this.email,
    required this.block,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'block': block,
    };
  }

  factory Admin.fromMap(Map<String, dynamic> map) {
    return Admin(
      email: map['email'] ?? '',
      block: (map['block'] as num?)?.toInt() ?? 0,
    );
  }

  Admin copyWith({
    String? email,
    int? block,
  }) {
    return Admin(
      email: email ?? this.email,
      block: block ?? this.block,
    );
  }
}
