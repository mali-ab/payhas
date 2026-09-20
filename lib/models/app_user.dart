class AppUser {
  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
  });

  final int id;
  final String name;
  final String email;
  final String avatar;

  AppUser copyWith({String? name, String? avatar}) => AppUser(
        id: id,
        name: name ?? this.name,
        email: email,
        avatar: avatar ?? this.avatar,
      );

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        id: json['id'] as int,
        name: json['name'] as String,
        email: json['email'] as String,
        avatar: (json['avatar'] as String?) ?? '🧑‍🎓',
      );
}
