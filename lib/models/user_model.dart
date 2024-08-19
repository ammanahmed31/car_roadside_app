// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class User {
  int id;
  String name;
  String userName;
  String email;
  String address;
  String mobileNumber;

  User({
    required this.id,
    required this.name,
    required this.userName,
    required this.email,
    required this.address,
    required this.mobileNumber,
  });

  User copyWith({
    int? id,
    String? name,
    String? userName,
    String? email,
    String? address,
    String? mobileNumber,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      address: address ?? this.address,
      mobileNumber: mobileNumber ?? this.mobileNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'username': userName,
      'email': email,
      'address': address,
      'mobile_no': mobileNumber,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] != null ? map['id'] as int : 0,
      name: map['name'] as String,
      userName: map['username'] as String,
      email: map['email'] as String,
      address: map['address'] as String,
      mobileNumber: map['mobile_no'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(id: $id, name: $name, userName: $userName, email: $email, address: $address, mobileNumber: $mobileNumber)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name && other.userName == userName && other.email == email && other.address == address && other.mobileNumber == mobileNumber;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ userName.hashCode ^ email.hashCode ^ address.hashCode ^ mobileNumber.hashCode;
  }
}
