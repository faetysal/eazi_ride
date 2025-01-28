class User {
  int? _id;
  String name;
  String email;
  String phone;

  User({
    int? id,
    this.name = '',
    this.email = '',
    this.phone = ''
  }): _id = id;

  factory User.fromMap(data) {
    return User(
      id: data['id'],
      name: data['name'],
      email: data['email'],
      phone: data['phone']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone
    };
  }

  int? get id => _id;
  set id(int? key) {
    _id = id;
  }
}