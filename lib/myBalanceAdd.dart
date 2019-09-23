import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:smartinventory/routePages/availableBalance.dart';
import 'package:smartinventory/routePages/todaysCollection.dart';

import 'database/databaseFile.dart';

class AddMyBalance extends StatefulWidget {
  final String id, date, amount, balance,vname;

  AddMyBalance({
    Key key,
    this.vname,
    this.id,
    this.date,
    this.amount,
    this.balance,
  }) : super(key: key);

  @override
  _AddMyBalanceState createState() => _AddMyBalanceState(
      id: this.id, vname: this.vname,date: this.date, amount: this.amount, balance: this.balance);
}

class _AddMyBalanceState extends State<AddMyBalance> {
  String id, date, amount, balance,vname;

  _AddMyBalanceState({
    this.id,
    this.vname,
    this.date,
    this.amount,
    this.balance,
  });

  DateTime selectedDate = DateTime.now();
  String formattedDate;
  int vid;
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
    vname='';
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
      vname=null;
    }
  }

  validate() {
    if(formattedDate == null ){
      showToast("Please enter Date");
    }
    else if(vname==null){
      showToast("Please enter Name");
    }
    else
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      if (isUpdating && id != null) {
        MyBalance e = MyBalance(
          _currentUser,
          vname,
          date,
          int.parse(balance),
          int.parse(amount),
          vid,
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
          vname,
          date,
          int.parse(balance),
          int.parse(amount),
          vid
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
        child: Card(
          elevation: 5.0,
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  FutureBuilder<List<Vendor>>(
                      future: DbHelper.getVendor(),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Vendor>> snapshot) {
                        if (!snapshot.hasData) return CircularProgressIndicator();
                        return DropdownButton<Vendor>(
                          items: snapshot.data
                              .map((user) => DropdownMenuItem<Vendor>(
                            child: Text(user.name),
                            value: user,
                          ))
                              .toList(),
                          onChanged: (Vendor value) {
                            setState(() {
                              _currentUser = value;
                              vname = _currentUser.name;
                              vid=_currentUser.id;
                            });
                          },
                          isExpanded: true,
                          //value: _currentUser,
                          hint: vname != null
                              ? Text(vname)
                              : Text("Select Vendor"),
                        );
                      }),
                  Container(
                    padding: EdgeInsets.only(top: 10.0),
                    width: 300,
                    child: OutlineButton(
                        color: Colors.blueAccent,
                        onPressed: () => _selectDate(context),
                        child: formattedDate != null
                            ? Text(
                          formattedDate.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 40.0),
                        )
                            : Text(
                          'Select date',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 40.0),
                        )),
                  ),
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

                  Padding(
                    padding: const EdgeInsets.only(top :20.0),
                    child: FlatButton(
                      onPressed: validate,
                      child: Container(
                        height: 45,
                        width: MediaQuery.of(context).size.width/1.2,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFF0e81d1),
                                Color(0xFF1f96f2)
                              ],
                            ),
                            borderRadius: BorderRadius.all(
                                Radius.circular(50)
                            )
                        ),

                        child: Center(
                          child: Text(isUpdating ? 'Update' : 'Save'.toUpperCase(),
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
