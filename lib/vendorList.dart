import 'package:flutter/material.dart';
import 'package:smartinventory/database/databaseFile.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'customerForm.dart';

class VendorList extends StatefulWidget {
  @override
  _VendorListState createState() => _VendorListState();
}

class _VendorListState extends State<VendorList> {
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
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(32.0))),
                                    contentPadding:
                                    EdgeInsets.only(top: 0.0),
                                    content: Container(
                                      width: 300.0,
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          InkWell(
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                  top: 20.0, bottom: 20.0),
                                              decoration: BoxDecoration(
                                                color: Colors.blueAccent,
                                                borderRadius: BorderRadius
                                                    .only(
                                                    topLeft:
                                                    Radius.circular(
                                                        32.0),
                                                    topRight:
                                                    Radius.circular(
                                                        32.0)),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceEvenly,
                                                mainAxisSize:
                                                MainAxisSize.min,
                                                children: <Widget>[
                                                  Text(
                                                    "ALERT",
                                                    style: TextStyle(
                                                        fontSize: 24.0,
                                                        color:
                                                        Colors.white),
                                                    textAlign:
                                                    TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 30.0, right: 30.0),
                                            child: TextField(
                                              decoration: InputDecoration(
                                                hintText:
                                                "Do you want to Edit Daat",
                                                border: InputBorder.none,
                                              ),
                                              textAlign: TextAlign.center,
                                              maxLines: 8,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: <Widget>[
                                              FlatButton(
                                                  child: Text('Yes'),
                                                  onPressed: () {
                                                    setState(() {
                                                      Navigator.pop(
                                                          context);
                                                      Navigator.push(
                                                          context,
                                                          new MaterialPageRoute(
                                                              builder: (BuildContext context) => new CustomerForm(
                                                                  id: customer
                                                                      .id
                                                                      .toString(),
                                                                  name: customer
                                                                      .name,
                                                                  email: customer
                                                                      .email,
                                                                  address:
                                                                  customer
                                                                      .address,
                                                                  contact:
                                                                  customer
                                                                      .contact)));
                                                    });
                                                  }),
                                              Padding(
                                                padding:
                                                const EdgeInsets.only(
                                                    left: 8.0),
                                                child: FlatButton(
                                                    child: Text('no'),
                                                    onPressed: () {
                                                      Navigator.pop(
                                                          context);
                                                    }),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
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
}


