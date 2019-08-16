import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class Product {
  int id;
  String productName;
  String productDesc;
  String cost;
  String unit;
  String quantity;

  Product(this.id, this.productName, this.productDesc, this.cost, this.unit,
      this.quantity);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'name': productName,
      'description': productDesc,
      'cost': cost,
      'unit': unit,
      'quantity': quantity
    };
    return map;
  }

  Product.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    productName = map['name'];
    productDesc = map['description'];
    cost = map['cost'];
    unit = map['unit'];
    quantity = map['quantity'];
  }
}

class Customer {
  int id;
  String name;
  String address;
  String email;
  String contact;

  Customer(this.id, this.name, this.address, this.contact, this.email);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'cname': name,
      'caddress': address,
      'ccontact': contact,
      'cemail': email
    };
    return map;
  }

  Customer.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['cname'];
    address = map['caddress'];
    contact = map['ccontact'];
    email = map['cemail'];

  }
}

class dbHelper {
  //Database name start
  static Database _db;
  static const String DB_NAME = 'smartinventroy.db';

  //Database name end
  //Product Table filed start
  static const String PRODUCT_TABLE = 'Product';
  static const String ID = 'id';
  static const String Product_NAME = 'name';
  static const String DESC = 'description';
  static const String UNIT = 'unit';
  static const String QUANTITY = 'quantity';
  static const String COST = 'cost';

  //Product Table filed end

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
    var db = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate, /*onUpgrade: _onUpgrade*/
    );
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        "create table $PRODUCT_TABLE ($ID integer primary key , $Product_NAME text, $DESC text, $COST text, $UNIT text, $QUANTITY text)");
    await db.execute(
        "create table $CUSTOMER_TABLE ($ID integer primary key ,$CUSTOMER_NAME text,$CUSTOMER_ADDRESS text, $CUSTOMER_CONTACT text, $CUSTOMER_EMAIL text)");
  }

  Future<Product> saveProduct(Product product) async {
    var dbClient = await db;
    product.id = await dbClient.insert(PRODUCT_TABLE, product.toMap());
    return product;
  }

  Future<List<Product>> getProduct() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(PRODUCT_TABLE,
        columns: [ID, Product_NAME, DESC, COST, UNIT, QUANTITY]);
    List<Product> product = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        product.add(Product.fromMap(maps[i]));
      }
    }
    return product;
  }

  Future<List<Product>> getUserModelData() async {
    var dbClient = await db;
    String sql;
    sql = "SELECT * FROM $PRODUCT_TABLE";

    var result = await dbClient.rawQuery(sql);
    if (result.length == 0) return null;

    List<Product> list = result.map((item) {
      return Product.fromMap(item);
    }).toList();

    print(result);
    return list;
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete(PRODUCT_TABLE, where: ' $ID = ?', whereArgs: [id]);
  }

  Future<int> update(Product product) async {
    var dbClient = await db;
    return await dbClient.update(PRODUCT_TABLE, product.toMap(),
        where: '$ID=?', whereArgs: [product.id]);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }

  Future<int> deleteAll(int id) async {
    var dbClient = await db;

    return await dbClient.delete(PRODUCT_TABLE);
  }

  void dropTable() async {
    var dbClient = await db;
    dbClient.query('DROP TABLE IF EXISTS Product');
  }

/* void _onUpgrade(Database db, int oldVersion, int newVersion) {
   if (oldVersion < newVersion) {
     db.execute("ALTER TABLE $TABLE ADD COLUMN $NUMBER TEXT;");
   }
 }*/

//Customer Table filed start
  static const String CUSTOMER_TABLE = 'Customer';
  static const String CUSTOMER_NAME = 'cname';
  static const String CUSTOMER_ADDRESS = 'caddress';
  static const String CUSTOMER_CONTACT = 'ccontact';
  static const String CUSTOMER_EMAIL = 'cemail';

  //Customer Table filed end
  // Customer database functions
  Future<List<Customer>> getCompany() async {
    var dbClient = await db;
    List<Map> maps =
        await dbClient.query(CUSTOMER_TABLE, columns: [ID, CUSTOMER_NAME, CUSTOMER_ADDRESS, CUSTOMER_CONTACT,CUSTOMER_EMAIL]);
    List<Customer> company = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        company.add(Customer.fromMap(maps[i]));
      }
    }
    return company;
  }

  Future<Customer> saveCompany(Customer customer) async {
    var dbClient = await db;
    customer.id = await dbClient.insert(CUSTOMER_TABLE, customer.toMap());
    return customer;
  }

  Future<int> deleteCustomer(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete(CUSTOMER_TABLE, where: ' $ID = ?', whereArgs: [id]);
  }

  Future<int> updateCustomer(Customer customer) async {
    var dbClient = await db;
    return await dbClient.update(CUSTOMER_TABLE, customer.toMap(),
        where: '$ID=?', whereArgs: [customer.id]);
  }
}
