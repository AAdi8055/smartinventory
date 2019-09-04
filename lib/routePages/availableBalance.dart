import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smartinventory/customerForm.dart';
import 'package:smartinventory/database/databaseFile.dart';
import 'package:meta/meta.dart';

class AvailableBalance extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AvailableBalanceState();
}

class AvailableBalanceState extends State<AvailableBalance> {
  Future<List<Customer>> customer;
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

/*  String _mobile;*/
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
      customer = DbHelper.getCustomer();
    });
  }

  validate() {
    if (formKey.currentState.validate()) {
/*      DbHelper.dropTable(employee);*/
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
        title: Text('AVF'),
      ),
      body: Column(
        children: <Widget>[
          list(),
        ],
      ),
    );
  }

  SingleChildScrollView dataTable(List<Customer> customer) {
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
                label: Text('Name'),
                numeric: false,
                onSort: (i, b) {
                  print("$i $b");
                  setState(() {
                    if (ascending) {
                      customer.sort((a, b) => b.name.compareTo(a.name));
                      /*customer.sort((a, b) => b.id.compareTo(a.id));*/
                      ascending = false;
                    } else {
                      customer.sort((a, b) => a.name.compareTo(b.name));
                      /*customer.sort((a, b) => a.id.compareTo(b.id));*/
                      ascending = true;
                    }
                  });
                },
              ),
              DataColumn(
                label: Text('Address'),
              ),
              DataColumn(
                label: Text('Contact'),
              ),
              DataColumn(
                label: Text('Email'),

              ),
              DataColumn(
                label: Text('Edit /Delete'),
              ),
            ],
            rows: customer
                .map(
                  (customer) => DataRow(cells: [
                    DataCell(
                      FittedBox(
                          fit: BoxFit.contain,
                          child: Container(
                            width: 20.0,
                            child: Center(child: Text(customer.id.toString())),
                          )),
                    ),
                    DataCell(
                      Text(customer.name),
                      onTap: () {
                        setState(() {
                          curUserId = customer.id;
                        });
                      },
                      placeholder: false,
                    ),
                    DataCell(
                      Text(customer.address),
                      onTap: () {
                        setState(() {
                          curUserId = customer.id;
                        });
                      },
                      placeholder: false,
                    ),
                    DataCell(
                      Text(customer.contact),
                      onTap: () {
                        setState(() {
                          curUserId = customer.id;
                        });
                      },
                      placeholder: false,
                    ),
                    DataCell(
                      FittedBox(
                          fit: BoxFit.contain,
                          child: Container(
                              width: 80.0,
                              child: Center(child: Text(customer.email)))),
                    ),
                    DataCell(
                      SingleChildScrollView(
                        child: Row(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    // ignore: missing_return
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                          content: Center(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Text('Do you want to edit data'),
                                            RaisedButton(
                                                child: Text('Yes'),
                                                onPressed: () {
                                                  setState(() {
                                                    Navigator.pop(context);
                                                    Navigator.push(
                                                        context,
                                                        new MaterialPageRoute(
                                                            builder: (BuildContext context) => new CustomerForm(
                                                                id: customer.id
                                                                    .toString(),
                                                                name: customer
                                                                    .name,
                                                                email: customer
                                                                    .email,
                                                                address: customer
                                                                    .address,
                                                                contact: customer
                                                                    .contact)));
                                                  });

                                                }),
                                            RaisedButton(
                                                child: Text('no'),
                                                onPressed: () {
                                                  list();
                                                })
                                          ],
                                        ),
                                      ));
                                    });
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                DbHelper.deleteCustomer(customer.id);
                                refreshList();
                              },
                            ),
                          ],
                        ),
                      ),
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
          future: customer,
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

  Widget form() {
    return Form(
      key: formKey,
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            TextFormField(
              autofocus: true,
              controller: controllerName,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: 'Customer Name'),
              validator: (val) => val.length == 0 ? 'Enter Name' : null,
              onSaved: (val) => name = val,
            ),
            TextFormField(
              controller: controllerAddress,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: 'Address'),
              validator: (val) => val.length == 0 ? 'Enter Name' : null,
              onSaved: (val) => address = val,
            ),
            TextFormField(
              maxLength: 10,
              controller: controllerContact,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: 'Contact'),
              validator: (val) => val.length == 0 ? 'Enter Name' : null,
              onSaved: (val) => contact = val,
            ),
            TextFormField(
              controller: controllerEmail,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: 'Email'),
              validator: (val) => val.length == 0 ? 'Enter Name' : null,
              onSaved: (val) => email = val,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  color: Colors.grey,
                  onPressed: validate,
                  child: Text('Update'),
                ),
                FlatButton(
                  color: Colors.grey,
                  onPressed: () {
                    clearName();
                  },
                  child: Text('Cancle'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
