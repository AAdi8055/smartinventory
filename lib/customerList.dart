import 'package:flutter/material.dart';
import 'database/databaseFile.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'customerForm.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smartinventory/customerForm.dart';

class NewList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NewListState();
  }
}

class NewListState extends State<NewList> {
  var DbHelper;
  Future<List<Customer>> customer;

  @override
  void initState() {
    super.initState();
    DbHelper = dbHelper();
    refreshList();
  }

  refreshList() {
    setState(() {
      customer = DbHelper.getCustomer();
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer List'),
      ),
      body: FutureBuilder<List<Customer>>(
        future: DbHelper.getCustomerData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          return ListView(
            children: snapshot.data
                .map((customer) => Card(
                      elevation: 5,
                      child: Slidable(
                        actionPane: SlidableBehindActionPane(),
                        actionExtentRatio: 0.25,
                        child: Container(
                          child: ListTile(
                            title: Text(customer.name),
                            subtitle: Text(customer.email),
                            leading: CircleAvatar(
                              backgroundColor: Colors.red,
                              child: Text(customer.name[0],
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.white,
                                  )),
                            ),
                            onTap: (){

                             /* Navigator.of(context).push(new MaterialPageRoute(
                                  builder: (BuildContext context) => new CustomerForm()));
*/
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
                              DbHelper.deleteCustomer(customer.id);
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
          Navigator.of(context)
              .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
            return new CustomerForm();
          }));
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
  void showToast(String msg){
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}
