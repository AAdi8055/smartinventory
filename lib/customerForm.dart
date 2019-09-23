import 'package:flutter/material.dart';
import 'package:smartinventory/customerList.dart';
import 'package:smartinventory/database/databaseFile.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smartinventory/routePages/availableBalance.dart';

class CustomerForm extends StatefulWidget {
  final String id, name, email, address, contact;

  CustomerForm(
      {Key key, this.id, this.name, this.email, this.address, this.contact})
      : super(key: key);

  CustomerFormState createState() => new CustomerFormState(
      id: this.id,
      name: this.name,
      email: this.email,
      address: this.address,
      contact: this.contact);
}

class CustomerFormState extends State<CustomerForm> {
  String id, name, email, address, contact;

  CustomerFormState(
      {this.id, this.name, this.email, this.address, this.contact});

  Future<List<Customer>> customer;
  var _currentUser;
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerAddress = TextEditingController();
  TextEditingController controllerContact = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();

  /*String id;
  String name;
  String address;
  String contact;
  String email;*/

/*  String _mobile;*/
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
      controllerAddress.text = address;
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
    name='';
    email='';
    contact='';
    address='';
    id='';
  }

  validate() {
    if (formKey.currentState.validate()) {
/*      DbHelper.dropTable(employee);*/
      formKey.currentState.save();
      if (isUpdating && id != null) {
        Customer e = Customer(
          _currentUser,
          name,
          address,
          contact,
          email,
        );
        DbHelper.updateCustomer(e);
        DbHelper.balanceCustomerupdate(e);
        DbHelper.collectionCustomerupdate(e);
        showToast("Updated Successfully");
        setState(() {
          isUpdating = false;
        });
        clearName();
        newPage();
      } else {
        Customer e = Customer(null, name, address, contact, email);
        DbHelper.saveCustomer(e);
        showToast("Save Successfully");
        clearName();
      }

      refreshList();
    }
  }
  String validateMobile(String value) {
// Indian Mobile number are of 10 digit only
    if (value.length != 10)
      return 'Mobile Number must be of 10 digit';
    else
      return null;
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

void newPage()  {
  Navigator.of(context).pop();
  Navigator.of(context).push(new MaterialPageRoute(
  builder: (BuildContext context) => new CustomerList()));
}

  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Details'),
      ),
      body: SingleChildScrollView(
        child: Card(
          elevation: 5.0,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: formKey,
              child: Column(
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
                    validator: validateMobile,
                    onSaved: (val) => contact = val,
                  ),
                  TextFormField(
                    controller: controllerEmail,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: 'Email'),
                    validator: validateEmail,
                    onSaved: (val) => email = val,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top :20.0),
                        child: FlatButton(
                          onPressed: validate,
                          child: Container(
                            height: 45,
                            width: MediaQuery.of(context).size.width/3,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF0e81d1),
                                    Color(0xFF1f96f2)
                                  ],
                                ),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(50)
                                )
                            ),

                            child: Center(
                              child: Text(isUpdating ? 'Update' : 'Save'.toUpperCase(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top :20.0),
                        child: FlatButton(
                          onPressed: () {
                            showToast('Cancle');
                            setState(() {
                              isUpdating = false;
                            });
                            clearName();
                            newPage();
                          },
                          child: Container(
                            height: 45,
                            width: MediaQuery.of(context).size.width/3,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF0e81d1),
                                    Color(0xFF1f96f2)
                                  ],
                                ),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(50)
                                )
                            ),

                            child: Center(
                              child: Text('Cancle'.toUpperCase(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
