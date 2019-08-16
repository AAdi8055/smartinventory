import 'package:flutter/material.dart';
import 'package:smartinventory/database/employee.dart';

class CustomerForm extends StatefulWidget {
  @override
  CustomerFormState createState() => new CustomerFormState();
}

class CustomerFormState extends State<CustomerForm> {
  Future<List<Customer>> company;
  var _currentUser;
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerAddress = TextEditingController();
  TextEditingController controllerContact = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  String name;
  String address;
  String contact;
  String email;

/*  String _mobile;*/
  int curUserId;
  @override
  var DbHelper;
  bool isUpdating;
  final formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DbHelper = dbHelper();
    isUpdating = false;
    refreshList();
  }

  refreshList() {
    setState(() {
      company = DbHelper.getCompany();
    });
  }

  clearName() {
    controllerName.text = '';
    _currentUser = null;
  }

  validate() {
    if (formKey.currentState.validate()) {
/*      DbHelper.dropTable(employee);*/
      formKey.currentState.save();
      if (isUpdating) {
        Customer e = Customer(
          curUserId,
          name,
          address,
          contact,
          email,
        );
        DbHelper.updateCompany(e);
        setState(() {
          isUpdating = false;
        });
      } else {
        Customer e = Customer(
          null,
          name,
          address,
          contact,
          email
        );
        DbHelper.saveCompany(e);
      }
      clearName();
      refreshList();
    }
  }

  form() {
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
                  child: Text(isUpdating ? 'Update' : 'Add'),
                ),
                FlatButton(
                  color: Colors.grey,
                  onPressed: () {
                    setState(() {
                      isUpdating = false;
                    });
                    clearName();
                  },
                  child: Text('Cancle'),
                )
              ],
            ),
            /*FutureBuilder<List<Company>>(
                future: DbHelper.getUserModelData(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Company>> snapshot) {
                  if (!snapshot.hasData) return Text("No Name Selected");
                  return DropdownButton<Company>(
                    items: snapshot.data
                        .map((company) => DropdownMenuItem<Company>(
                      child: Text(company.name),
                      value: company,
                    ))
                        .toList(),
                    onChanged: (Company itemValue) {
                      controller.text= itemValue.name;
                      _dropdownItemSelected(itemValue);
                    },
                    isExpanded: false,
                    //value: _currentUser,
                    hint: _currentUser != null
                        ? Text( _currentUser.name)
                        : Text("No Name Selected"),
                  );
                }),*/
            /*SizedBox(height: 20.0),
            _currentUser != null
                ? Text("Name: " + _currentUser.name)
                : Text("No Name Selected"),*/
          ],
        ),
      ),
    );
  }

  SingleChildScrollView dataTable(List<Customer> company) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: DataTable(
            columns: [
              DataColumn(
                label: Text('Name'),
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
                label: Text('Delete'),
              ),
            ],
            rows: company
                .map(
                  (company) => DataRow(cells: [
                    DataCell(
                      Text(company.name),
                      onTap: () {
                        setState(() {
                          isUpdating = true;
                          curUserId = company.id;
                        });
                        controllerName.text = company.name;
                      },
                      placeholder: false,
                    ),
                    DataCell(
                      Text(company.address),
                      onTap: () {
                        setState(() {
                          isUpdating = true;
                          curUserId = company.id;
                        });
                        controllerName.text = company.name;
                      },
                      placeholder: false,
                    ),
                    DataCell(
                      Text(company.contact),
                      onTap: () {
                        setState(() {
                          isUpdating = true;
                          curUserId = company.id;
                        });
                        controllerName.text = company.name;
                      },
                      placeholder: false,
                    ),
                    DataCell(
                      Text(company.email),
                      onTap: () {
                        setState(() {
                          isUpdating = true;
                          curUserId = company.id;
                        });
                        controllerName.text = company.name;
                      },
                      placeholder: false,
                    ),
                    DataCell(
                      SingleChildScrollView(
                        child: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            DbHelper.deleteCustomer(company.id);
                            refreshList();
                          },
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
          future: company,
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

  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Details'),
      ),
      body: new Container(
          child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        verticalDirection: VerticalDirection.down,
        children: <Widget>[
          form(),
          list(),
        ],
      )),
    );
  }

  void _dropdownItemSelected(Customer itemValue) {
    setState(() {
      this._currentUser = itemValue;
    });
  }
}
