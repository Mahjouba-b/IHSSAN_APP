class User{
  final String name;
  final String email;
  final String role;


  User({this.name, this.email, this.role});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'role': role,
      

    };
  }}