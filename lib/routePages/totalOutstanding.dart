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
      _totalOutstanding = (_totalBalance - _totalCollection);
    }
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Total Outstanding'),
      ),
      body: Center(

        child: Card(
          elevation: 5.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: FlatButton(
                  onPressed: null,
                  child: Container(
                    height: 45,
                    width: MediaQuery.of(context).size.width / 1.5,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF
                          ), Color(0xFF)],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                    child: Center(
                      child: Text(
                        'Total Outstanding'.toUpperCase(),
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0,bottom: 20.0),
                child: FlatButton(
                  onPressed: null,
                  child: Container(
                    height: 45,
                    width: MediaQuery.of(context).size.width / 2.5,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF), Color(0xFF)],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                    child: Center(
                      child: _totalOutstanding != null
                          ? Text(
                              _totalOutstanding.toString(),
                              style: TextStyle(
                                  color: Colors.black, fontWeight: FontWeight.bold),
                            )
                          : Text(
                              "0".toUpperCase(),
                              style: TextStyle(
                                  color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
