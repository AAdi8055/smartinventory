import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smartinventory/database/databaseFile.dart';

import '../customerForm.dart';

class TotalOutstanding extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TotalOutstandingState();
}

class TotalOutstandingState extends State<TotalOutstanding> {
  int _totalCollection;
  int _totalBalance;
  int _totalOutstanding;
  var DbHelper;

  void _calcTotalCollection() async {
    var total = (await DbHelper.calculateTotalCollection())[0]['Total'];
    print(total);
    setState(() => _totalCollection = total);
  }

  void _calcTotalBalance() async {
    var total = (await DbHelper.calculateTotalBalanceReq())[0]['Total'];
    print(total);
    setState(() => _totalBalance = total);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DbHelper = dbHelper();
    _calcTotalBalance();
    _calcTotalCollection();
  }

  @override
  Widget build(BuildContext context) {
    if (_totalCollection != null && _totalBalance != null) {
      _totalOutstanding = (_totalCollection - _totalBalance);
    }
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Total Outstanding'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top:50.0),
              child: FlatButton(
                onPressed: null,
                child: Text(
                  'Total Outstanding',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            FlatButton(
              onPressed: null,
              child: _totalOutstanding != null
                  ? Text(_totalOutstanding.toString(),style: TextStyle(fontSize: 20),)
                  : Text("Waiting....",style: TextStyle(fontSize: 20)),
            )
          ],
        ),
      ),
    );
  }
}
