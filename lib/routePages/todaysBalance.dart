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
                .map((myBalance) =>
                Card(
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
}