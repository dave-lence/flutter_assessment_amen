class LoginModel {
  String? username;
  String? password;

  LoginModel({required this.username, required this.password});

  Map<String, dynamic> toMap() {
    return {'username': username, 'password': password};
  }

  factory LoginModel.fromJson(Map<String, dynamic> map){
    return LoginModel(
        username: map['username'] ?? '',
        password: map['password'] ?? ''
    );
  }
}
 