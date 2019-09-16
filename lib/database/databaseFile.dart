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
    await db.execute(
        "create table $TODAYSCOLLECTION_TABLE ($ID integer primary key ,$CCUSTOMER_NAME text,$CUSTOMER_AMOUNT int, $CUSTOMER_DATE text)");
    await db.execute(
        "create table $MYBALANCE_TABLE ($ID integer primary key ,$MYBALANCE_AMOUNT int, $MYBALANCE_BALANCE int,$MYBALANCE_DATE text)");
    await db.execute(
        "create table $BALANCEREQ_TABLE ($ID integer primary key ,$BALANCEREQ_CUSTOMERNAME text, $BALANCEREQ_AMOUNT int,$BALANCEREQ_BALANCE int,$BALANCEREQ_PAIDAMOUNT int )");
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
  Future<List<Customer>> getCustomer() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(CUSTOMER_TABLE, columns: [
      ID,
      CUSTOMER_NAME,
      CUSTOMER_ADDRESS,
      CUSTOMER_CONTACT,
      CUSTOMER_EMAIL
    ]);
    List<Customer> company = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        company.add(Customer.fromMap(maps[i]));
      }
    }
    return company;
  }

  Future<Customer> saveCustomer(Customer customer) async {
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

  Future<List<Customer>> getCustomerData() async {
    var dbClient = await db;
    String sql;
    sql = "SELECT * FROM $CUSTOMER_TABLE";

    var result = await dbClient.rawQuery(sql);
    if (result.length == 0) return null;

    List<Customer> list = result.map((item) {
      return Customer.fromMap(item);
    }).toList();

    print(result);
    return list;
  }

  Future<List<Product>> getProductData() async {
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

  Future<int> deleteProduct(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete(PRODUCT_TABLE, where: ' $ID = ?', whereArgs: [id]);
  }

  //Today collection Table filed start
  static const String TODAYSCOLLECTION_TABLE = 'Todays_collection';
  static const String CCUSTOMER_NAME = 'customername';
  static const String CUSTOMER_AMOUNT = 'amount';
  static const String CUSTOMER_DATE = 'date';

  //Today collection Table filed end
  Future<List<TodaysCollection>> getTodaysCollection() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(TODAYSCOLLECTION_TABLE, columns: [
      ID,
      CCUSTOMER_NAME,
      CUSTOMER_AMOUNT,
      CUSTOMER_DATE
    ]);
    List<TodaysCollection> todayCollection = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        todayCollection.add(TodaysCollection.fromMap(maps[i]));
      }
    }
    return todayCollection;
  }
  Future<TodaysCollection> saveCollection(TodaysCollection todayCollection) async {
    var dbClient = await db;
    todayCollection.id = await dbClient.insert(TODAYSCOLLECTION_TABLE, todayCollection.toMap());
    return todayCollection;
  }
  Future<MyBalance> saveMybalance(MyBalance myBalance) async {
    var dbClient = await db;
    myBalance.id = await dbClient.insert(MYBALANCE_TABLE, myBalance.toMap());
    return myBalance;
  }
  Future<List<MyBalance>> getMyBalance() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(MYBALANCE_TABLE, columns: [
      ID,
      MYBALANCE_DATE,
      MYBALANCE_AMOUNT,
      MYBALANCE_BALANCE,
    ]);
    List<MyBalance> myBalance = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        myBalance.add(MyBalance.fromMap(maps[i]));
      }
    }
    return myBalance;
  }
  Future<int> updateMybalance(MyBalance mybalance) async {
    var dbClient = await db;
    return await dbClient.update(MYBALANCE_TABLE, mybalance.toMap(),
        where: '$ID=?', whereArgs: [mybalance.id]);
  }
  Future<int> deleteMybalance(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete(MYBALANCE_TABLE, where: ' $ID = ?', whereArgs: [id]);
  }
  //Today collection Table filed start
  static const String MYBALANCE_TABLE = 'My_balance';
  static const String MYBALANCE_AMOUNT = 'amount';
  static const String MYBALANCE_BALANCE = 'balance';
  static const String MYBALANCE_DATE = 'date';


  static const String BALANCEREQ_TABLE = 'Balance_request';
  static const String BALANCEREQ_CUSTOMERNAME = 'customername';
  static const String BALANCEREQ_AMOUNT = 'amount';
  static const String BALANCEREQ_BALANCE = 'balance';
  static const String BALANCEREQ_PAIDAMOUNT = 'paidAmount';

  Future<BalanceRequest> saveBalanceRequest(BalanceRequest balanceRequest) async {
    var dbClient = await db;
    balanceRequest.id = await dbClient.insert(BALANCEREQ_TABLE, balanceRequest.toMap());
    return balanceRequest;
  }
  Future<List<BalanceRequest>> getBalanceRequest() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(BALANCEREQ_TABLE, columns: [
      ID,
      BALANCEREQ_PAIDAMOUNT,
      BALANCEREQ_BALANCE,
      BALANCEREQ_AMOUNT,
      BALANCEREQ_CUSTOMERNAME,
    ]);
    List<BalanceRequest> balanceRequest = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        balanceRequest.add(BalanceRequest.fromMap(maps[i]));
      }
    }
    return balanceRequest;
  }
  Future<int> deleteBalanceRequest(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete(BALANCEREQ_TABLE, where: ' $ID = ?', whereArgs: [id]);
  }
  Future calculateTotalCollection() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT SUM($CUSTOMER_AMOUNT) as Total FROM $TODAYSCOLLECTION_TABLE");
    print(result.toList());
    return result;
  }
  Future calculateTotalBalanceReq() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT SUM($BALANCEREQ_AMOUNT) as Total FROM $BALANCEREQ_TABLE");
    print(result.toList());
    return result;
  }

}

class BalanceRequest {
  int id;
  String customerName;
  int amount;
  int balance;
  int paidAmount;

  BalanceRequest(this.id, this.customerName, this.balance, this.amount, this.paidAmount);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'customerName': customerName,
      'amount': amount,
      'balance': balance,
      'paidAmount': paidAmount
    };
    return map;
  }
  BalanceRequest.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    customerName = map['customername'];
    amount = map['amount'];
    balance = map['balance'];
    paidAmount = map['paidAmount'];
  }
}

class TodaysCollection {
  int id;
  String customerName;
  int amount;
  String date;

  TodaysCollection(
    this.id,
    this.customerName,
    this.amount,
    this.date,
  );

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'customername': customerName,
      'amount': amount,
      'date': date,
    };
    return map;
  }

  TodaysCollection.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    customerName = map['customername'];
    amount = map['amount'];
    date = map['date'];
  }
}
class MyBalance{

  int id;
  String date;
  int balance;
  int amount;
  MyBalance(this.id, this.date, this.balance, this.amount);
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'date': date,
      'balance': balance,
      'amount': amount,
    };
    return map;
  }

  MyBalance.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    date = map['date'];
    amount = map['amount'];
    balance = map['balance'];

  }



}
