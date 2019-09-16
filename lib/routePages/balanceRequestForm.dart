import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:smartinventory/database/databaseFile.dart';
import 'package:smartinventory/routePages/availableBalance.dart';
import 'package:smartinventory/routePages/todaysCollection.dart';

import 'balanceRequestList.dart';

class BalanceRequestForm extends StatefulWidget {
  final String id, customerName, amount, balance,paidAmount;

  BalanceRequestForm( {

    Key key,
    this.id,
    this.customerName,
    this.amount,
    this.balance,
    this.paidAmount
  }) : super(key: key);

  @override
  BalanceRequestFormState createState() => BalanceRequestFormState(
      id: this.id, customerName: this.customerName, amount: this.amount, balance: this.balance,paidAmount: this.paidAmount);
}

class BalanceRequestFormState extends State<BalanceRequestForm> {
  String id, customerName, amount, balance,paidAmount;

  BalanceRequestFormState({
    this.id,
    this.customerName,
    this.amount,
    this.balance,
    this.paidAmount,
  });


  Future<List<Customer>> customer;
  Future<List<BalanceRequestForm>> balanceRequest;
  TextEditingController controllerAmount = TextEditingController();
  TextEditingController controllerBalance = TextEditingController();
  TextEditingController controllerPaidAmount = TextEditingController();
  var _currentUser;
  var DbHelper;
  bool isUpdating;
  String name;
  final formKey = new GlobalKey<FormState>();

  clearName() {
    controllerAmount.text = '';
    controllerBalance.text = '';
    _currentUser = null;
    balance = '';
    amount = '';
    id = '';
    customerName = '';
    name='';
  }

  @override
  void initState() {
    super.initState();
    DbHelper = dbHelper();
    if (id != null) {
      setState(() {
        isUpdating = true;
        _currentUser = int.parse(id);
        controllerAmount.text = amount;
        controllerBalance.text = balance;
        controllerPaidAmount.text=paidAmount;
        name = customerName;
      });

    } else {
      isUpdating = false;
    }
  }

  validate() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      if (isUpdating && id != null) {
        BalanceRequest e = BalanceRequest(
          _currentUser,
          name,
          int.parse(balance),
          int.parse(amount),
          int.parse(paidAmount),
        );
        DbHelper.updateMybalance(e);
        showToast("Updated Successfully");
        setState(() {
          isUpdating = false;
        });
        print(e);
        newPage();
      } else {
        BalanceRequest e = BalanceRequest(
          null,
          name,
          int.parse(balance),
          int.parse(amount),
          int.parse(paidAmount),
        );
        DbHelper.saveBalanceRequest(e);
        showToast("Save Successfully");
        clearName();
        newPage();
      }
    }
  }

  void newPage() {
    Navigator.of(context).pop();
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) => new BalanceRequestList()));
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
        title: Text('Balance Request'),
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
                FutureBuilder<List<Customer>>(
                    future: DbHelper.getCustomer(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Customer>> snapshot) {
                      if (!snapshot.hasData) return CircularProgressIndicator();
                      return DropdownButton<Customer>(
                        items: snapshot.data
                            .map((user) => DropdownMenuItem<Customer>(
                          child: Text(user.name),
                          value: user,
                        ))
                            .toList(),
                        onChanged: (Customer value) {
                          setState(() {
                            _currentUser = value;
                             name = _currentUser.name;
                          });
                        },
                        isExpanded: true,
                        //value: _currentUser,
                        hint: name != null
                            ? Text(name)
                            : Text("Select customer"),
                      );
                    }),
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
                TextFormField(
                  controller: controllerPaidAmount,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(labelText: 'Paid Amount'),
                  validator: (val) => val.length == 0 ? 'Enter Paid Amount' : null,
                  onSaved: (val) => paidAmount = val,
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