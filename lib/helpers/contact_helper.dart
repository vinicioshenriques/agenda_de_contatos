import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String contactTable = 'contactTable';
final String idColumn = 'id';
final String nameColumn = 'name';
final String emailColumn = 'email';
final String phoneColumn = 'phone';
final String imgColumn = 'img';

class ContactHelper {
  static final ContactHelper _instance = ContactHelper.internal();

  factory ContactHelper() => _instance;

  ContactHelper.internal();

  Database _db;

  get db {
    if (_db != null) {
      return _db;
    } else {
      _db = initDb();
    }
  }

  initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'contacts.db');

    openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute(
          'CREATE TABLE $contactTable($idColumn INTEGER PRIMARY KEY, $nam)');
    });
  }
}

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

  Map toMap() {
    Map<String, dynamic> map = {
      nameColumn: name,
      emailColumn: email,
      phoneColumn: phone,
      imgColumn: img,
    };
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return 'Contact(Name: $name, Email: $email, Phone: $phone, Img: $img)';
  }
}
