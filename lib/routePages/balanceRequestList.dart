import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smartinventory/database/databaseFile.dart';
import 'package:smartinventory/routePages/balanceRequestForm.dart';
import '../myBalanceAdd.dart';

class BalanceRequestList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BalanceRequestListState();
}

class BalanceRequestListState extends State<BalanceRequestList> {
  Future<List<BalanceRequest>> balanceRequest;

  var _currentUser;

  String id;
  String name;
  String amount;
  String balance;
  String paidAmount;
  String date;

  clearName() {
    _currentUser = null;
  }

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
      balanceRequest = DbHelper.getBalanceRequest();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Balance Request'),
      ),
      body: FutureBuilder<List<BalanceRequest>>(
        future: DbHelper.getBalanceRequest(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child:Text('No record Added'));

          return ListView(
            padding: EdgeInsets.only(top: 10),
            children: snapshot.data
                .map((balanceRequest) => Card(
              elevation: 5,
              child: Slidable(
                actionPane: SlidableBehindActionPane(),
                actionExtentRatio: 0.20,
                child: Container(
                    child: ListTile(
                      contentPadding: EdgeInsets.all(10.0),
                      title: Text('Name : ' +
                          balanceRequest.customerName
                          ),
                      subtitle: Text('Date : ' +
                          balanceRequest.date +'\nAmount : ' +
                          balanceRequest.amount.toString() +
                          '\nBalance : ' +
                          balanceRequest.balance.toString() +
                          '\nPaid Amounr : ' +
                          balanceRequest.paidAmount.toString() ),
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey,
                        child: Text(balanceRequest.customerName[0],
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.black,
                            )),
                      ),
                      onTap: () {
                        _currentUser = balanceRequest.id;
                        name= balanceRequest.customerName;
                        paidAmount= balanceRequest.paidAmount.toString();
                        amount = balanceRequest.amount.toString();
                        balance = balanceRequest.balance.toString();
                        date=balanceRequest.date;

                        Popup();
                      },
                    )),
                actions: <Widget>[],
                secondaryActions: <Widget>[
                  IconSlideAction(
                    caption: 'Delete',
                    color: Colors.red,
                    icon: Icons.delete,
                    onTap: () {
                      DbHelper.deleteBalanceRequest(balanceRequest.id);
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop();
          Navigator.of(context)
              .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
            return new BalanceRequestForm();
          }));
        },
        child: Icon(Icons.add),
      ),
    );
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
  SingleChildScrollView dataTable(List<BalanceRequest> balanceRequest) {
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
                      balanceRequest.sort((a, b) => b.customerName.compareTo(a.customerName));
                      /*customer.sort((a, b) => b.id.compareTo(a.id));*/
                      ascending = false;
                    } else {
                      balanceRequest.sort((a, b) => a.customerName.compareTo(b.customerName));
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
              DataColumn(
                label: Text('Paid Amount'),
              ),
            ],
            rows: balanceRequest
                .map(
                  (balanceRequest) => DataRow(cells: [
                DataCell(
                  FittedBox(
                      fit: BoxFit.contain,
                      child: Container(
                        width: 20.0,
                        child: Center(child: Text(balanceRequest.id.toString())),
                      )),
                ),
                DataCell(
                  Text(balanceRequest.customerName),
                  onTap: () {
                    setState(() {
                      _currentUser = balanceRequest.id;
                      name= balanceRequest.customerName;
                      paidAmount= balanceRequest.paidAmount.toString();
                      amount = balanceRequest.amount.toString();
                      balance = balanceRequest.balance.toString();
                      Popup();
                    });
                  },
                  placeholder: false,
                ),
                DataCell(
                  Text(balanceRequest.amount.toString()),
                  onTap: () {
                    setState(() {
                      _currentUser = balanceRequest.id;
                      name= balanceRequest.customerName;
                      paidAmount= balanceRequest.paidAmount.toString();
                      amount = balanceRequest.amount.toString();
                      balance = balanceRequest.balance.toString();
                      Popup();
                    });
                  },
                  placeholder: false,
                ),
                DataCell(
                  Text(balanceRequest.balance.toString()),
                  onTap: () {
                    setState(() {
                      _currentUser = balanceRequest.id;
                      name= balanceRequest.customerName;
                      paidAmount= balanceRequest.paidAmount.toString();
                      amount = balanceRequest.amount.toString();
                      balance = balanceRequest.balance.toString();
                      Popup();
                    });
                  },
                  placeholder: false,
                ),
                    DataCell(
                      Text(balanceRequest.paidAmount.toString()),
                      onTap: () {
                        setState(() {
                          _currentUser = balanceRequest.id;
                          name= balanceRequest.customerName;
                          paidAmount= balanceRequest.paidAmount.toString();
                          amount = balanceRequest.amount.toString();
                          balance = balanceRequest.balance.toString();
                          Popup();
                        });
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
          future: balanceRequest,
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

  // ignore: non_constant_identifier_names
  Popup() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            contentPadding: EdgeInsets.only(top: 0.0),
            content: Container(
              width: 300.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  InkWell(
                    child: Container(
                      padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(32.0),
                            topRight: Radius.circular(32.0)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            "ALERT",
                            style:
                            TextStyle(fontSize: 24.0, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30.0, right: 30.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Do you want to Edit Daat",
                        border: InputBorder.none,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                          child: Text('Yes'),
                          onPressed: () {
                            setState(() {
                              Navigator.pop(context);Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                      new BalanceRequestForm(
                                        id: _currentUser.toString(),
                                        customerName: name,
                                        amount: amount,
                                        balance: balance,
                                        paidAmount: paidAmount,
                                        date: date,
                                      )));
                            });
                          }),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: FlatButton(
                            child: Text('no'),
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
