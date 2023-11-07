class User {
  final String id;
  final String name;
  final String email;
  final String avatarUrl;

  const User({
    this.id = '0',
    required this.name,
    required this.email,
    required this.avatarUrl,
  });
}
