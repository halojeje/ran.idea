import 'dart:convert';

class UserModelSQL {
  final int? id;
  final String nama;
  final String email;
  final String nomorHp;
  final String password;

  UserModelSQL({
    this.id,
    required this.nama,
    required this.email,
    required this.nomorHp,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'email': email,
      'nomor_hp': nomorHp,
      'password': password,
    };
  }

  factory UserModelSQL.fromMap(Map<String, dynamic> map) {
    return UserModelSQL(
      id: map['id'],
      nama: map['nama'],
      email: map['email'],
      nomorHp: map['nomor_hp'],
      password: map['password'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModelSQL.fromJson(String source) =>
      UserModelSQL.fromMap(json.decode(source) as Map<String, dynamic>);
}
