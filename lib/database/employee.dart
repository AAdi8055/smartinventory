import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class Employee {
  int id;
  String name;
  String number;

  Employee(this.id, this.name,this.number);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{'id': id, 'name': name, 'number':number};
    return map;
  }

  Employee.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    number = map['number'];
  }
}
class Company {
  int id;
  String name;

  Company(this.id, this.name);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{'id': id, 'name': name};
    return map;
  }

  Company.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
  }
}

class dbHelper {
  static Database _db;
  static const String ID = 'id';
  static const String NAME = 'name';
  static const String NUMBER = 'number';
  static const String TABLE = 'Employee';
  static const String TABLE1 = 'Company';
  static const String DB_NAME = 'employee.db';

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDB();
    return _db;
  }

  initDB() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate, /*onUpgrade: _onUpgrade*/);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db
        .execute("create table $TABLE ($ID integer primary key ,$NAME text,$NUMBER text)");
    await db
        .execute("create table $TABLE1 ($ID integer primary key ,$NAME text)");

  }

  Future<Employee> save(Employee employee) async {

    var dbClient = await db;
    employee.id = await dbClient.insert(TABLE, employee.toMap());
    return employee;
  }

  Future<List<Employee>> getEmployees() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(TABLE, columns: [ID, NAME, NUMBER]);
    List<Employee> employee = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        employee.add(Employee.fromMap(maps[i]));
      }
    }
    return employee;
  }
  Future<List<Employee>> getUserModelData() async {
    var dbClient = await db;
    String sql;
    sql = "SELECT * FROM $TABLE";

    var result = await dbClient.rawQuery(sql);
    if (result.length == 0) return null;

    List<Employee> list = result.map((item) {
      return Employee.fromMap(item);
    }).toList();

    print(result);
    return list;
  }


  Future<List<Employee>> getEmployeesName() async {
    var dbClient = await db;
    var maps = await dbClient.query(TABLE, columns: [ NAME]);
    List<Employee> employeeName = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        employeeName.add(Employee.fromMap(maps[i]));
      }
    }
    return employeeName;
  }
 Future<int> delete(int id) async{
   var dbClient = await db;
   return await dbClient.delete(TABLE,where:' $ID = ?',whereArgs: [id] );
 }
 Future<int> update(Employee employee) async{
   var dbClient = await db;
   return await dbClient.update(TABLE, employee.toMap(),where:'$ID=?',whereArgs: [employee.id]);
 }
 Future close() async{
   var dbClient = await db;
   dbClient.close();
 }
 Future<int> deleteAll(int id) async{
    var dbClient = await db;

    return await dbClient.delete(TABLE);

 }

  void dropTable() async {
    var dbClient = await db;
    dbClient.query('DROP TABLE IF EXISTS Employee');
  }
/* void _onUpgrade(Database db, int oldVersion, int newVersion) {
   if (oldVersion < newVersion) {
     db.execute("ALTER TABLE $TABLE ADD COLUMN $NUMBER TEXT;");
   }
 }*/
  Future<List<Company>> getCompany() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(TABLE1, columns: [ID, NAME]);
    List<Company> company = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        company.add(Company.fromMap(maps[i]));
      }
    }
    return company;
  }
  Future<Company> saveCompany(Company company) async {

    var dbClient = await db;
    company.id = await dbClient.insert(TABLE1, company.toMap());
    return company;
  }
  Future<int> deleteCompany(int id) async{
    var dbClient = await db;
    return await dbClient.delete(TABLE1,where:' $ID = ?',whereArgs: [id] );
  }
  Future<int> updateCompany(Company company) async{
    var dbClient = await db;
    return await dbClient.update(TABLE1, company.toMap(),where:'$ID=?',whereArgs: [company.id]);
  }
}
