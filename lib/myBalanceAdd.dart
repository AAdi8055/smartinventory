import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:smartinventory/routePages/availableBalance.dart';
import 'package:smartinventory/routePages/todaysCollection.dart';

import 'database/databaseFile.dart';

class AddMyBalance extends StatefulWidget {
  final String id, date, amount, balance;

  AddMyBalance({
    Key key,
    this.id,
    this.date,
    this.amount,
    this.balance,
  }) : super(key: key);

  @override
  _AddMyBalanceState createState() => _AddMyBalanceState(
      id: this.id, date: this.date, amount: this.amount, balance: this.balance);
}

class _AddMyBalanceState extends State<AddMyBalance> {
  String id, date, amount, balance;

  _AddMyBalanceState({
    this.id,
    this.date,
    this.amount,
    this.balance,
  });

  DateTime selectedDate = DateTime.now();
  String formattedDate;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null || picked != selectedDate)
      setState(() {
        selectedDate = picked;
        formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
        date = formattedDate;
        print(formattedDate);
      });
  }

  Future<List<Customer>> customer;
  Future<List<MyBalance>> myBalance;
  TextEditingController controllerAmount = TextEditingController();
  TextEditingController controllerBalance = TextEditingController();
  var _currentUser;
  var DbHelper;
  bool isUpdating;
  final formKey = new GlobalKey<FormState>();

  clearName() {
    controllerAmount.text = '';
    controllerBalance.text = '';
    _currentUser = null;
    balance = '';
    amount = '';
    id = '';
    date = '';
  }

  @override
  void initState() {
    super.initState();
    DbHelper = dbHelper();
    if (id != null) {
      isUpdating = true;
      _currentUser = int.parse(id);
      controllerAmount.text = amount;
      controllerBalance.text = balance;
      formattedDate = date;
    } else {
      isUpdating = false;
    }
  }

  validate() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      if (isUpdating && id != null) {
        MyBalance e = MyBalance(
          _currentUser,
          date,
          int.parse(balance),
          int.parse(amount),
        );
        DbHelper.updateMybalance(e);
        showToast("Updated Successfully");
        setState(() {
          isUpdating = false;
        });
        print(e);
        newPage();
      } else {
        MyBalance e = MyBalance(
          null,
          date,
          int.parse(balance),
          int.parse(amount),
        );
        DbHelper.saveMybalance(e);
        showToast("Save Successfully");
        clearName();
        formattedDate = null;
        newPage();
      }
    }
  }

  void newPage() {
    Navigator.of(context).pop();
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) => new AvailableBalance()));
  }

  void showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Balance'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                FlatButton(
                    onPressed: () => _selectDate(context),
                    padding: EdgeInsets.only(top: 20.0),
                    child: formattedDate != null
                        ? Text(formattedDate.toString())
                        : Text('Select date \n')),
                TextFormField(
                  controller: controllerAmount,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(labelText: 'Amount'),
                  validator: (val) => val.length == 0 ? 'Enter Amount' : null,
                  onSaved: (val) => amount = val,
                ),
                TextFormField(
                  controller: controllerBalance,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(labelText: 'Balance'),
                  validator: (val) => val.length == 0 ? 'Enter Balance' : null,
                  onSaved: (val) => balance = val,
                ),
                RaisedButton(
                  onPressed: validate,
                  child: Text(isUpdating ? 'Update' : 'Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
