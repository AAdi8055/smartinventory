import 'dart:io' as io;
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class Vendor {
  int id;
  String name;
  String address;
  String contact;
  String email;

  Vendor(this.id, this.name, this.address, this.contact, this.email);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'name': name,
      'address': address,
      'contact': contact,
      'email': email,
    };
    return map;
  }

  Vendor.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    address = map['address'];
    contact = map['contact'];
    email = map['email'];
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

  static const String ID = 'id';
  static const String CID = 'cid';
  static const String VID = 'vid';
  static const String VENDOR_TABLE = 'Vendor';
  static const String VENDOR_NAME = 'name';
  static const String VENDOR_ADDRESS = 'address';
  static const String VENDOR_CONTACT = 'contact';
  static const String VENDOR_EMAIL = 'email';

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
        "create table $VENDOR_TABLE ($ID integer primary key ,$VENDOR_NAME text,$VENDOR_ADDRESS text, $VENDOR_CONTACT text, $VENDOR_EMAIL text)");
    await db.execute(
        "create table $CUSTOMER_TABLE ($ID integer primary key ,$CUSTOMER_NAME text,$CUSTOMER_ADDRESS text, $CUSTOMER_CONTACT text, $CUSTOMER_EMAIL text)");
    await db.execute(
        "create table $TODAYSCOLLECTION_TABLE ($ID integer primary key ,$CCUSTOMER_NAME text,$CUSTOMER_AMOUNT int, $CUSTOMER_DATE text,$CID int)");
    await db.execute(
        "create table $MYBALANCE_TABLE ($ID integer primary key ,$MYBALANCE_VNAME text,$MYBALANCE_AMOUNT int, $MYBALANCE_BALANCE int,$MYBALANCE_DATE text,$VID int)");
    await db.execute(
        "create table $BALANCEREQ_TABLE ($ID integer primary key ,$BALANCEREQ_CUSTOMERNAME text, $BALANCEREQ_AMOUNT int,$BALANCEREQ_BALANCE int,$BALANCEREQ_PAIDAMOUNT int,$BALANCEREQ_DATE text,$CID int )");
  }

  Future<Vendor> saveVendor(Vendor vendor) async {
    var dbClient = await db;
    vendor.id = await dbClient.insert(VENDOR_TABLE, vendor.toMap());
    return vendor;
  }

  Future<List<Vendor>> getVendor() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(VENDOR_TABLE,
        columns: [
          ID,
          VENDOR_NAME,
          VENDOR_ADDRESS,
          VENDOR_CONTACT,
          VENDOR_EMAIL,
        ]);
    List<Vendor> vendor = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        vendor.add(Vendor.fromMap(maps[i]));
      }
    }
    print(vendor);
    return vendor;
  }

  Future<List<Vendor>> getVendorModelData() async {
    var dbClient = await db;
    String sql;
    sql = "SELECT * FROM $VENDOR_TABLE";

    var result = await dbClient.rawQuery(sql);
    if (result.length == 0) return null;

    List<Vendor> list = result.map((item) {
      return Vendor.fromMap(item);
    }).toList();

    print(result);
    return list;
  }

  Future<int> deleteVendor(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete(VENDOR_TABLE, where: ' $ID = ?', whereArgs: [id]);
  }

  Future<int> updateVendor(Vendor vendor) async {
    var dbClient = await db;
    return await dbClient.update(VENDOR_TABLE, vendor.toMap(),
        where: '$ID=?', whereArgs: [vendor.id]);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
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
  Future<int> balanceCustomerupdate(Customer customer) async {
    var dbClient = await db;
    return await dbClient.rawUpdate('UPDATE $BALANCEREQ_TABLE SET $BALANCEREQ_CUSTOMERNAME=? WHERE $CID = ?',
         [customer.name,customer.id]);
  }
  Future<int> collectionCustomerupdate(Customer customer) async {
    var dbClient = await db;
    return await dbClient.rawUpdate('UPDATE $TODAYSCOLLECTION_TABLE SET $CCUSTOMER_NAME=? WHERE $CID = ?',
        [customer.name,customer.id]);
  }
  Future<int> balanceVendorupdate(Vendor vendor) async {
    var dbClient = await db;
    return await dbClient.rawUpdate('UPDATE $MYBALANCE_TABLE SET $MYBALANCE_VNAME=? WHERE $VID = ?',
        [vendor.name,vendor.id]);
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
      CUSTOMER_DATE,
    CID
  ]);
    List<TodaysCollection> todayCollection = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        todayCollection.add(TodaysCollection.fromMap(maps[i]));
      }

    }
    if (todayCollection.length == 0) return null;
print(todayCollection);
    return todayCollection;
  }

  Future<TodaysCollection> saveCollection(
      TodaysCollection todayCollection) async {
    var dbClient = await db;
    todayCollection.id =
    await dbClient.insert(TODAYSCOLLECTION_TABLE, todayCollection.toMap());
    return todayCollection;
  }

  Future<MyBalance> saveMybalance(MyBalance myBalance) async {
    var dbClient = await db;
    myBalance.id = await dbClient.insert(MYBALANCE_TABLE, myBalance.toMap());
    return myBalance;
  }
  Future<List<MyBalance>> getMyBalance() async {
    var dbClient = await db;
    String sql;
    sql = "SELECT * FROM $MYBALANCE_TABLE";

    var result = await dbClient.rawQuery(sql);
    if (result.length == 0) return null;

    List<MyBalance> list = result.map((item) {
      return MyBalance.fromMap(item);
    }).toList();

    print(result);
    return list;
  }
  Future<List<MyBalance>> daw() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(MYBALANCE_TABLE, columns: [
      ID,
      MYBALANCE_VNAME,
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
  static const String MYBALANCE_VNAME = 'vname';
  static const String MYBALANCE_AMOUNT = 'amount';
  static const String MYBALANCE_BALANCE = 'balance';
  static const String MYBALANCE_DATE = 'date';


  static const String BALANCEREQ_TABLE = 'Balance_request';
  static const String BALANCEREQ_DATE = 'date';
  static const String BALANCEREQ_CUSTOMERNAME = 'customername';
  static const String BALANCEREQ_AMOUNT = 'amount';
  static const String BALANCEREQ_BALANCE = 'balance';
  static const String BALANCEREQ_PAIDAMOUNT = 'paidAmount';

  Future<BalanceRequest> saveBalanceRequest(
      BalanceRequest balanceRequest) async {
    var dbClient = await db;
    balanceRequest.id =
    await dbClient.insert(BALANCEREQ_TABLE, balanceRequest.toMap());
    print(balanceRequest);
    return balanceRequest;
  }
  Future<List<BalanceRequest>> getBalanceRequest() async {
    var dbClient = await db;
    String sql;
    sql = "SELECT * FROM $BALANCEREQ_TABLE";

    var result = await dbClient.rawQuery(sql);
    if (result.length == 0) return null;

    List<BalanceRequest> list = result.map((item) {
      return BalanceRequest.fromMap(item);
    }).toList();

    print(result);
    return list;
  }


  Future<List<BalanceRequest>> ads() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(BALANCEREQ_TABLE, columns: [
      ID,
      BALANCEREQ_PAIDAMOUNT,
      BALANCEREQ_BALANCE,
      BALANCEREQ_AMOUNT,
      BALANCEREQ_DATE,
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
  Future<int> updateBalanceReq(BalanceRequest balanceRequest) async {
    var dbClient = await db;
    return await dbClient.update(BALANCEREQ_TABLE, balanceRequest.toMap(),
        where: '$ID=?', whereArgs: [balanceRequest.id]);
  }

  Future calculateTotalCollection() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery(
        "SELECT SUM($CUSTOMER_AMOUNT) as Total FROM $TODAYSCOLLECTION_TABLE");
    print(result.toList());
    return result;
  }

  Future calculateTotalBalanceReq() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery(
        "SELECT SUM($BALANCEREQ_AMOUNT) as Total FROM $BALANCEREQ_TABLE");
    print(result.toList());
    return result;
  }

  Future <List<CustomerReport>> customerWiseReport() async {
    var dbClient = await db;
    List<Map> result = await dbClient.rawQuery(
        "SELECT * FROM (SELECT T1.$BALANCEREQ_CUSTOMERNAME,T1.$BALANCEREQ_DATE,(T1.$BALANCEREQ_AMOUNT-T1.$BALANCEREQ_PAIDAMOUNT) AS $BALANCEREQ_AMOUNT FROM $BALANCEREQ_TABLE T1 UNION SELECT T2.$CCUSTOMER_NAME,T2.$CUSTOMER_DATE,T2.$CUSTOMER_AMOUNT FROM $TODAYSCOLLECTION_TABLE T2) MYDETAILS ORDER BY MYDETAILS.$CUSTOMER_DATE DESC ");

    List<CustomerReport> customerReport = [];

    if (result.length > 0) {
      for (int i = 0; i < result.length; i++) {
        customerReport.add(CustomerReport.fromMap(result[i]));
      }
    }
    if (result.length == 0) return null;
    return customerReport;
  }

  Future <List<CustomerReport>> customerSingleWiseReport(String cname) async {
    var dbClient = await db;
    List<Map> result = await dbClient.rawQuery(
        "SELECT * FROM (SELECT T1.$BALANCEREQ_CUSTOMERNAME,T1.$BALANCEREQ_DATE,(T1.$BALANCEREQ_AMOUNT-T1.$BALANCEREQ_PAIDAMOUNT) AS $BALANCEREQ_AMOUNT FROM $BALANCEREQ_TABLE T1 UNION SELECT T2.$CCUSTOMER_NAME,T2.$CUSTOMER_DATE,T2.$CUSTOMER_AMOUNT FROM $TODAYSCOLLECTION_TABLE T2) MYDETAILS WHERE $BALANCEREQ_CUSTOMERNAME='$cname'  ORDER BY MYDETAILS.$CUSTOMER_DATE DESC ");

    List<CustomerReport> customerReport = [];
    if (result.length > 0) {
      for (int i = 0; i < result.length; i++) {
        customerReport.add(CustomerReport.fromMap(result[i]));
      }
    }
    if (result.length == 0) return null;
    return customerReport;
  }

  Future <List<CustomerReport>> dateReport() async {
    var dbClient = await db;
    List<Map> result = await dbClient.rawQuery(
        "SELECT * FROM (SELECT T1.$BALANCEREQ_CUSTOMERNAME,T1.$BALANCEREQ_DATE,(T1.$BALANCEREQ_AMOUNT-T1.$BALANCEREQ_PAIDAMOUNT) AS $BALANCEREQ_AMOUNT FROM $BALANCEREQ_TABLE T1 UNION SELECT T2.$CCUSTOMER_NAME,T2.$CUSTOMER_DATE,T2.$CUSTOMER_AMOUNT FROM $TODAYSCOLLECTION_TABLE T2) MYDETAILS ORDER BY MYDETAILS.$CUSTOMER_DATE DESC ");

    List<CustomerReport> customerReport = [];
    List<CustomerReport> tempCustomerReport = [];
    if (result.length > 0) {
      Map<String, CustomerReport> mp = {};
      for (int i = 0; i < result.length; i++) {
        customerReport.add(CustomerReport.fromMap(result[i]));
      }

      for (var item in customerReport) {
        mp[item.date] = item;
      }

      tempCustomerReport = mp.values.toList();
  }

    return tempCustomerReport;
  }

  Future <List<CustomerReport>> dateWiseReport(String date) async {
    var dbClient = await db;
    List<Map> result = await dbClient.rawQuery(
        "SELECT * FROM (SELECT T1.$BALANCEREQ_CUSTOMERNAME,T1.$BALANCEREQ_DATE,(T1.$BALANCEREQ_AMOUNT-T1.$BALANCEREQ_PAIDAMOUNT) AS $BALANCEREQ_AMOUNT FROM $BALANCEREQ_TABLE T1 UNION SELECT T2.$CCUSTOMER_NAME,T2.$CUSTOMER_DATE,T2.$CUSTOMER_AMOUNT FROM $TODAYSCOLLECTION_TABLE T2) MYDETAILS WHERE $CUSTOMER_DATE='$date'  ORDER BY MYDETAILS.$CUSTOMER_DATE DESC ");

    List<CustomerReport> customerReport = [];
    if (result.length > 0) {
      for (int i = 0; i < result.length; i++) {
        customerReport.add(CustomerReport.fromMap(result[i]));
      }
    }
    return customerReport;
  }

  Future <List<HistoryReport1>> historyReport() async {
    var dbClient = await db;
    List<Map> result = await dbClient.rawQuery(
        "SELECT T1.$BALANCEREQ_CUSTOMERNAME,((SUM(T1.$BALANCEREQ_AMOUNT-T1.$BALANCEREQ_PAIDAMOUNT)- SUM(T2.$CUSTOMER_AMOUNT))) AS OUTSTANDING FROM $BALANCEREQ_TABLE T1, $TODAYSCOLLECTION_TABLE T2 GROUP BY T1.$BALANCEREQ_CUSTOMERNAME");
    /*select t1.name,((sum(t1.amount-t1.paid) - sum(t2.amount))) as outstanding from collection t2,test_balance t1group by t1.name*/
    List<HistoryReport1> historyReport = [];
    if (result.length > 0) {
      for (int i = 0; i < result.length; i++) {
        historyReport.add(HistoryReport1.fromMap(result[i]));
      }
    }
    if (result.length == 0) return null;
    return historyReport;
  }

  Future <List<HistoryReport1>> historyReportInvividual(String name) async {
    var dbClient = await db;
    List<Map> result = await dbClient.rawQuery(
        "SELECT T1.$BALANCEREQ_CUSTOMERNAME,((SUM(T1.$BALANCEREQ_AMOUNT-T1.$BALANCEREQ_PAIDAMOUNT)- SUM(T2.$CUSTOMER_AMOUNT))) AS OUTSTANDING FROM $BALANCEREQ_TABLE T1, $TODAYSCOLLECTION_TABLE T2 where T1.$BALANCEREQ_CUSTOMERNAME='$name' GROUP BY T1.$BALANCEREQ_CUSTOMERNAME");
    /*select t1.name,((sum(t1.amount-t1.paid) - sum(t2.amount))) as outstanding from collection t2,test_balance t1group by t1.name*/
    List<HistoryReport1> historyReport = [];
    if (result.length > 0) {
      for (int i = 0; i < result.length; i++) {
        historyReport.add(HistoryReport1.fromMap(result[i]));
      }
    }
    return historyReport;
  }

}

class CustomerReport {
  String customerName;
  String date;
  int amount;

  CustomerReport(this.customerName, this.date, this.amount);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'customerName': customerName,
      'date': date,
      'amount': amount,
    };
    return map;
  }

  CustomerReport.fromMap(Map<String, dynamic> map) {
    customerName = map['customername'];
    date = map['date'];
    amount = map['amount'];
  }
}

class HistoryReport1 {
  String customerName;
  int amount;

  HistoryReport1(this.customerName, this.amount);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'customerName': customerName,
      'amount': amount,
    };
    return map;
  }

  HistoryReport1.fromMap(Map<String, dynamic> map) {
    customerName = map['customername'];
    amount = map['OUTSTANDING'];
  }
}

class BalanceRequest {
  int id;
  int cid;
  String customerName;
  String date;
  int amount;
  int balance;
  int paidAmount;

  BalanceRequest(this.id, this.customerName, this.date, this.balance,
      this.amount, this.paidAmount,this.cid);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'cid': cid,
      'customerName': customerName,
      'date': date,
      'amount': amount,
      'balance': balance,
      'paidAmount': paidAmount
    };
    return map;
  }

  BalanceRequest.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    cid = map['cid'];
    customerName = map['customername'];
    date = map['date'];
    amount = map['amount'];
    balance = map['balance'];
    paidAmount = map['paidAmount'];
  }
}

class TodaysCollection {
  int id;
  int cid;
  String customerName;
  int amount;
  String date;

  TodaysCollection(this.id,
      this.customerName,
      this.amount,
      this.date,this.cid);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'cid': cid,
      'customername': customerName,
      'amount': amount,
      'date': date,
    };
    return map;
  }

  TodaysCollection.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    cid = map['cid'];
    customerName = map['customername'];
    amount = map['amount'];
    date = map['date'];
  }
}

class MyBalance {

  int id;
  String vname;
  String date;
  int balance;
  int amount;
  int vid;

  MyBalance(this.id, this.vname, this.date, this.balance, this.amount,this.vid);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'vid': vid,
      'vname': vname,
      'date': date,
      'balance': balance,
      'amount': amount,
    };
    return map;
  }

  MyBalance.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    vid = map['vid'];
    vname = map['vname'];
    date = map['date'];
    amount = map['amount'];
    balance = map['balance'];
  }


}
