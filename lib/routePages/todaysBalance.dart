import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smartinventory/database/databaseFile.dart';

import '../customerForm.dart';

class TodaysBalance extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TodaysBalanceState();
}

class TodaysBalanceState extends State<TodaysBalance> {
  Future<List<MyBalance>> myBalance;
  var _currentUser;

  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerAddress = TextEditingController();
  TextEditingController controllerContact = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  String id;
  String name;
  String address;
  String contact;
  String email;

  clearName() {
    controllerName.text = '';
    controllerEmail.text = '';
    controllerContact.text = '';
    controllerAddress.text = '';
    _currentUser = null;
  }

  int curUserId;
  bool ascending;
  var DbHelper;
  final formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    DbHelper = dbHelper();
    refreshList();
    ascending = true;
  }

  refreshList() {
    setState(() {
      myBalance = DbHelper.getMyBalance();
    });
  }

  validate() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      Customer e = Customer(
        curUserId,
        name,
        address,
        contact,
        email,
      );
      DbHelper.updateCustomer(e);
      showToast("Updated Successfully");
      setState(() {
        list();
      });
      clearName();
      refreshList();
    }
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
        title: Text('Today\'s Balance'),
      ),
      body: FutureBuilder<List<MyBalance>>(
        future: DbHelper.getMyBalance(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          return ListView(
            padding: EdgeInsets.only(top: 10),
            children: snapshot.data
                .map((myBalance) => Card(
                      elevation: 5,
                      child: Slidable(
                        actionPane: SlidableBehindActionPane(),
                        actionExtentRatio: 0.20,
                        child: Container(
                            child: ListTile(
                          contentPadding: EdgeInsets.all(10.0),
                          title: Text('Date: ' +
                              myBalance.date +
                              '\nAmount : ' +
                              myBalance.amount.toString() +
                              '\nBalance : ' +
                              myBalance.balance.toString()),
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey,
                            child: Text(myBalance.date[0],
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.black,
                                )),
                          ),
                          onTap: () {

                          },
                        )),
                        actions: <Widget>[],
                        secondaryActions: <Widget>[
                          IconSlideAction(
                            caption: 'Delete',
                            color: Colors.red,
                            icon: Icons.delete,
                            onTap: () {
                              DbHelper.deleteMybalance(myBalance.id);
                              showToast('Delted Successfully');
                              refreshList();
                            },
                          ),
                        ],
                      ),
                    ))
                .toList(),
          );
        },
      ),
    );
  }

  SingleChildScrollView dataTable(List<MyBalance> myBalance) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: DataTable(
            columnSpacing: 8,
            sortAscending: ascending,
            sortColumnIndex: 1,
            columns: [
              DataColumn(
                label: Text('Sr no'),
              ),
              DataColumn(
                label: Text('Date'),
                numeric: false,
                onSort: (i, b) {
                  print("$i $b");
                  setState(() {
                    if (ascending) {
                      myBalance.sort((a, b) => b.date.compareTo(a.date));
                      /*customer.sort((a, b) => b.id.compareTo(a.id));*/
                      ascending = false;
                    } else {
                      myBalance.sort((a, b) => a.date.compareTo(b.date));
                      /*customer.sort((a, b) => a.id.compareTo(b.id));*/
                      ascending = true;
                    }
                  });
                },
              ),
              DataColumn(
                label: Text('Amount'),
              ),
              DataColumn(
                label: Text('Balance'),
              ),
            ],
            rows: myBalance
                .map(
                  (myBalance) => DataRow(cells: [
                    DataCell(
                      FittedBox(
                          fit: BoxFit.contain,
                          child: Container(
                            width: 20.0,
                            child: Center(child: Text(myBalance.id.toString())),
                          )),
                    ),
                    DataCell(
                      Text(myBalance.date),
                      onTap: () {
                        setState(() {});
                      },
                      placeholder: false,
                    ),
                    DataCell(
                      Text(myBalance.amount.toString()),
                      onTap: () {
                        setState(() {});
                      },
                      placeholder: false,
                    ),
                    DataCell(
                      Text(myBalance.balance.toString()),
                      onTap: () {
                        setState(() {});
                      },
                      placeholder: false,
                    ),
                  ]),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  list() {
    return Expanded(
      child: FutureBuilder(
          future: myBalance,
          // ignore: missing_return
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return dataTable(snapshot.data);
            }
            if (null == snapshot.data || snapshot.data.lenght == 0) {
              return Text("No Data found");
            }
            return CircularProgressIndicator();
          }),
    );
  }
}
