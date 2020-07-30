import 'package:sqflite/sqflite.dart';

final String idColumn = 'id';
final String nameColumn = 'name';
final String emailColumn = 'email';
final String phoneColumn = 'phone';
final String imgColumn = 'img';

class ContactHelper {}

class Contact {
  int id;
  String name;
  String email;
  String phone;
  String img;

  Contact.fromMap(Map map) {
    id = map[idColumn];
    name = map[nameColumn];
    email = map[emailColumn];
    phone = map[phoneColumn];
    img = map[imgColumn];
  }
}
