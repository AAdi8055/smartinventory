import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:smartinventory/database/databaseFile.dart';

import '../customerForm.dart';

class AccountBalance extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AccountBalanceState();
}

class AccountBalanceState extends State<AccountBalance> {
  var DbHelper;

  @override
  void initState() {
    super.initState();
    DbHelper = dbHelper();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Balance'),
      ),
      body: FutureBuilder<List<BalanceRequest>>(
        future: DbHelper.getBalanceRequest(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: Text('No record Added'));

          return ListView(
            padding: EdgeInsets.only(top: 10),
            children: snapshot.data
                .map((balanceRequest) =>
                Card(
                  elevation: 5,
                  child: Slidable(
                    actionPane: SlidableBehindActionPane(),
                    actionExtentRatio: 0.20,
                    child: Container(
                        child: ListTile(
                          contentPadding: EdgeInsets.all(10.0),
                          title: Text('Name: '+balanceRequest.customerName+'\nBalance : '+balanceRequest.amount.toString()),
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey,
                            child: Text(balanceRequest.customerName[0],
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.black,
                                )),
                          ),
                          onTap: () {

                          },
                        )
                    ),
                    actions: <Widget>[],
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        caption: 'Delete',
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () {
                          /*  id=customer.id.toString();*/

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
