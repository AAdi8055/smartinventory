import 'package:flutter/material.dart';

import '../customerForm.dart';

class AccountBalance extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AccountBalanceState();
}

class AccountBalanceState extends State<AccountBalance> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Balance'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 10),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Table(
            border: TableBorder.all(),
            defaultVerticalAlignment: TableCellVerticalAlignment.top,
            children: <TableRow>[
              ///First table row with 3 children
              TableRow(children: <Widget>[
                FittedBox(
                  fit: BoxFit.contain,
                  child: Container(
                    margin: EdgeInsets.all(2),
                    width: 50.0,
                    height: 20.0,
                    child: Center(
                      child: Text(
                        "Sr No",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold ,
                          fontSize: 6.0,
                        ),
                      ),
                    ),
                  ),
                ),
                FittedBox(
                  fit: BoxFit.contain,
                  child: Container(
                    margin: EdgeInsets.all(2),
                    width: 50.0,
                    height: 20.0,
                    child: Center(
                      child: Text(
                        "Name",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold ,
                          color: Colors.black,
                          fontSize: 6.0,
                        ),
                      ),
                    ),
                  ),
                ),
                FittedBox(
                  fit: BoxFit.contain,
                  child: Container(
                    margin: EdgeInsets.all(2),
                    width: 50.0,
                    height: 20.0,
                    child: Center(
                      child: Text(
                        "Current Balance",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold ,
                          color: Colors.black,
                          fontSize: 6.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
              TableRow(children: <Widget>[
                FittedBox(
                  fit: BoxFit.contain,
                  child: Container(
                    margin: EdgeInsets.all(2),
                    width: 50.0,
                    height: 20.0,
                    child: Center(
                      child: Text(
                        "1",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 6.0,
                        ),
                      ),
                    ),
                  ),
                ),
                FittedBox(
                  fit: BoxFit.contain,
                  child: Container(
                    margin: EdgeInsets.all(2),
                    width: 50.0,
                    height: 20.0,
                    child: Center(
                      child: Text(
                        "Yogesh Gangadhar Kadam",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 6.0,
                        ),
                      ),
                    ),
                  ),
                ),
                FittedBox(
                  fit: BoxFit.contain,
                  child: Container(
                    margin: EdgeInsets.all(2),
                    width: 50.0,
                    height: 20.0,
                    child: Center(
                      child: Text(
                        "100054 rs",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 6.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
              TableRow(children: <Widget>[
                FittedBox(
                  fit: BoxFit.contain,
                  child: Container(
                    margin: EdgeInsets.all(2),
                    width: 50.0,
                    height: 20.0,
                    child: Center(
                      child: Text(
                        "2",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 6.0,
                        ),
                      ),
                    ),
                  ),
                ),
                FittedBox(
                  fit: BoxFit.contain,
                  child: Container(
                    margin: EdgeInsets.all(2),
                    width: 50.0,
                    height: 20.0,
                    child: Center(
                      child: Text(
                        "SBI Bank (Sukhakarta)",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 6.0,
                        ),
                      ),
                    ),
                  ),
                ),
                FittedBox(
                  fit: BoxFit.contain,
                  child: Container(
                    margin: EdgeInsets.all(2),
                    width: 50.0,
                    height: 20.0,
                    child: Center(
                      child: Text(
                        "661035.78 rs",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 6.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
            return new CustomerForm();
          }));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
