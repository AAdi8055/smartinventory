import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smartinventory/database/databaseFile.dart';
import 'package:smartinventory/routePages/availableBalance.dart';

class VendorForm extends StatefulWidget {
  final String id, name, email, address, contact;

  VendorForm(
      {Key key, this.id, this.name, this.email, this.address, this.contact})
      : super(key: key);

  @override
  _VendorFormState createState() => _VendorFormState(
      id: this.id,
      name: this.name,
      email: this.email,
      gstno: this.address,
      contact: this.contact);
}

class _VendorFormState extends State<VendorForm> {
  String id, name, email, gstno, contact;

  _VendorFormState({this.id, this.name, this.email, this.gstno, this.contact});

  String panno;
  String adharno;
  String _selectedLocation;
  String _selectCountry;
  String _selectState;
  Future<List<Customer>> customer;
  var _currentUser;
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerAddress = TextEditingController();
  TextEditingController controllerContact = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();

  @override
  var DbHelper;
  bool isUpdating;
  final formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DbHelper = dbHelper();
    if (id != null) {
      isUpdating = true;
      _currentUser = int.parse(id);
      controllerName.text = name;
      controllerEmail.text = email;
      controllerAddress.text = gstno;
      controllerContact.text = contact;
    } else {
      isUpdating = false;
    }
    refreshList();
  }

  refreshList() {
    setState(() {
      customer = DbHelper.getCustomer();
    });
  }

  clearName() {
    controllerName.text = '';
    controllerEmail.text = '';
    controllerContact.text = '';
    controllerAddress.text = '';
    _currentUser = null;
    name = '';
    email = '';
    contact = '';
    gstno = '';
    id = '';
  }

  validate() {
    if (formKey.currentState.validate()) {
/*      DbHelper.dropTable(employee);*/
      formKey.currentState.save();
      if (isUpdating && id != null) {
        Customer e = Customer(
          _currentUser,
          name,
          gstno,
          contact,
          email,
        );
        DbHelper.updateCustomer(e);
        showToast("Updated Successfully");
        setState(() {
          isUpdating = false;
        });
        clearName();
        newPage();
      } else {
        Customer e = Customer(null, name, gstno, contact, email);
        DbHelper.saveCustomer(e);
        showToast("Save Successfully");
        clearName();
      }

      refreshList();
    }
  }

  void newPage() {
    Navigator.of(context).pop();
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) => new AvailableBalance()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vendor Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  autofocus: true,
                  controller: controllerName,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(labelText: 'Vendor Name'),
                  validator: (val) => val.length == 0 ? 'Enter Name' : null,
                  onSaved: (val) => name = val,
                ),
                Container(
                  height: 50,
                  child: Center(
                    child: new DropdownButton<String>(
                      items: <String>['Vendor', 'Customer'].map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                      // ignore: non_constant_identifier_names
                      onChanged: (Value) {
                        setState(() {
                          _selectedLocation = Value;
                        });
                      },
                      hint: _selectedLocation != null
                          ? Text(_selectedLocation)
                          : Text("No Business Patnar Selected"),
                    ),
                  ),
                ),
                TextFormField(
                  controller: controllerAddress,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(labelText: 'GST No'),
                  validator: (val) => val.length == 0 ? 'Enter Name' : null,
                  onSaved: (val) => gstno = val,
                ),
                TextFormField(
                  controller: controllerAddress,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(labelText: 'Pan No'),
                  validator: (val) => val.length == 0 ? 'Enter Name' : null,
                  onSaved: (val) => panno = val,
                ),
                TextFormField(
                  controller: controllerAddress,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(labelText: 'Adhar No'),
                  validator: (val) => val.length == 0 ? 'Enter Name' : null,
                  onSaved: (val) => adharno = val,
                ),
                TextFormField(
                  controller: controllerAddress,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(labelText: 'Address 1'),
                  validator: (val) => val.length == 0 ? 'Enter Name' : null,
                  /*   onSaved: (val) => address1 = val,*/
                ),
                TextFormField(
                  controller: controllerAddress,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(labelText: 'Address 2'),
                  validator: (val) => val.length == 0 ? 'Enter Name' : null,
                  /* onSaved: (val) => address2 = val,*/
                ),
                Container(
                  height: 50,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 150,
                        child: Center(
                          child: new DropdownButton<String>(
                            items: <String>['India'].map((String value) {
                              return new DropdownMenuItem<String>(
                                value: value,
                                child: new Text(value),
                              );
                            }).toList(),
                            // ignore: non_constant_identifier_names
                            onChanged: (Value) {
                              setState(() {
                                _selectCountry = Value;
                              });
                            },
                            hint: _selectCountry != null
                                ? Text(_selectCountry)
                                : Text("Select Country"),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Container(
                          width: 150,
                          child: Center(
                            child: new DropdownButton<String>(
                              items: <String>['Pune'].map((String value) {
                                return new DropdownMenuItem<String>(
                                  value: value,
                                  child: new Text(value),
                                );
                              }).toList(),
                              // ignore: non_constant_identifier_names
                              onChanged: (Value) {
                                setState(() {
                                  _selectState = Value;
                                });
                              },
                              hint: _selectState != null
                                  ? Text(_selectState)
                                  : Text("Select State"),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                TextFormField(
                  maxLength: 6,
                  controller: controllerContact,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(labelText: 'Pin code'),
                  validator: (val) => val.length == 0 ? 'Enter Name' : null,
                  /*    onSaved: (val) => pinCode = val,*/
                ),
                TextFormField(
                  maxLength: 10,
                  controller: controllerContact,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(labelText: 'Mobile No'),
                  validator: (val) => val.length == 0 ? 'Enter Name' : null,
                  /*onSaved: (val) => pinCode = val,*/
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
                      // ignore: unnecessary_statements
                      onPressed: validate,
                      child: Text(isUpdating ? 'Update' : 'Add'),
                    ),
                    FlatButton(
                      color: Colors.grey,
                      onPressed: () {
                        showToast('Cancle');
                        setState(() {
                          isUpdating = false;
                        });
                        clearName();
                      },
                      child: Text('Cancle'),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
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
}
