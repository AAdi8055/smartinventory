import 'package:flutter/material.dart';
import './database/employee.dart';
import 'package:async/async.dart';
import 'package:sqflite/sqflite.dart';

class ServiceHistory extends StatefulWidget {
  @override
  _ServiceHistoryState createState() => _ServiceHistoryState();
}

class _ServiceHistoryState extends State<ServiceHistory> {
  Future<List<Employee>> employee;
  var _currentUser;

  Future<List<Employee>> employeeName;
  TextEditingController controller = TextEditingController();
  TextEditingController controller1 = TextEditingController();
  String name;
  String number;

/*  String _mobile;*/
  int curUserId;

  final formKey = new GlobalKey<FormState>();

  // ignore: non_constant_identifier_names
  var DbHelper;
  bool isUpdating;

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
      employee = DbHelper.getEmployees();
    });
  }

  clearName() {
    controller.text = '';
    controller1.text = '';
    controller.selection;
    _currentUser= null;
  }

  validate() {
    if (formKey.currentState.validate()) {
/*      DbHelper.dropTable(employee);*/
      formKey.currentState.save();
      if (isUpdating) {
        Employee e = Employee(curUserId, name, number);
        DbHelper.update(e);
        setState(() {
          isUpdating = false;
        });
      } else {
        Employee e = Employee(null, name, number);
        DbHelper.save(e);
      }
      clearName();
      refreshList();
    }
  }

  String validateMobile(String value) {
    String patttern = r'(^(?:[0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length != 10) {
      return 'Please enter mobile number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return null;
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
              controller: controller,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: 'Name'),
              validator: (val) => val.length == 0 ? 'Enter Name' : null,
              onSaved: (val) => name = val,
            ),
            TextFormField(
              controller: controller1,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: 'Number'),
              validator: validateMobile,
              onSaved: (val) => number = val,
              /*
              onSaved: (String val) {
                number = val;
              },*/
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
            FutureBuilder<List<Employee>>(
                future: DbHelper.getUserModelData(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Employee>> snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  return DropdownButton<Employee>(
                    items: snapshot.data
                        .map((employee) => DropdownMenuItem<Employee>(
                              child: Text(employee.name),
                              value: employee,
                            ))
                        .toList(),
                    onChanged: (Employee itemValue) {
                      _dropdownItemSelected(itemValue);
                    },
                    isExpanded: false,
                    //value: _currentUser,
                    hint: Text('Select Name'),
                  );
                }),
            SizedBox(height: 20.0),
            _currentUser != null
                ? Text("Name: " + _currentUser.name)
                : Text("No Name Selected"),
          ],
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names

  SingleChildScrollView dataTable(List<Employee> employee) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        dataRowHeight: 10.0,
        columns: [
          DataColumn(
            label: Text('Name'),
          ),
          DataColumn(
            label: Text('Number'),
          ),
          DataColumn(
            label: Text('Update/ Delete'),
          ),
          /*DataColumn(
            label: Text('Price'),
          )*/
        ],
        rows: employee
            .map(
              (employee) => DataRow(cells: [
                DataCell(
                  Text(employee.name),
                  onTap: () {
                    setState(() {
                      isUpdating = true;
                      curUserId = employee.id;
                    });
                    controller.text = employee.name;
                    controller1.text = employee.number;
                  },
                ),
                DataCell(
                  Text(employee.number),
                  onTap: () {
                    setState(() {
                      isUpdating = true;
                      curUserId = employee.id;
                    });
                    controller.text = employee.name;
                    controller1.text = employee.number;
                  },
                ),
                DataCell(SingleChildScrollView(
                  child: Row(children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        DbHelper.delete(employee.id);
                        refreshList();
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        DbHelper.delete(employee.id);
                        refreshList();
                      },
                    ),
                  ]),
                )),
                /*DataCell(IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    DbHelper.delete(employee.id);
                    refreshList();
                  },
                ),
                )*/
                /*DataCell(Text('')),
            */
              ]),
            )
            .toList(),
      ),
    );
  }

  list() {
    return Expanded(
      child: FutureBuilder(
          future: employee,
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: new AppBar(
        title: Text('Database'),
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

  void _dropdownItemSelected(Employee itemValue) {
    setState(() {
      this._currentUser = itemValue;
    });
  }
}
