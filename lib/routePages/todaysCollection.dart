import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smartinventory/database/databaseFile.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import '../customerForm.dart';
import '../list2.dart';

class TodayCollection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TodayCollectionState();
}

class TodayCollectionState extends State<TodayCollection> {


  Future<List<Customer>> customer;
  Future<List<TodayCollection>> todayCollection;

  var _currentUser;
  String todayDate;
  TextEditingController controllerAmount = TextEditingController();
  String id;
  int cid;
  String name;
  int amount;
  String date;

  clearName() {
    controllerAmount.text = '';
    _currentUser = null;
    name="";
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
    name="";
    setState(()
    {
      var now = new DateTime.now();
      var formatter = new DateFormat('yyyy-MM-dd');
      todayDate = formatter.format(now);
    });
  }

  refreshList() {
    setState(() {
      customer = DbHelper.getCustomer();
    });
  }

  validate() {
    if(todayDate == null ){
      showToast("Please enter Date");
    }
else if(name==""){
      showToast("Please enter Name");
    }
else
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      TodaysCollection e = TodaysCollection(
        null,
        name,
        amount,
        todayDate,
        cid,
      );
      print(e);
      DbHelper.saveCollection(e);
      showToast("Save Successfully");
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
        title: Text('Today\'s Collection '),
      ),
      body: Column(
        children: <Widget>[
          form(),
        ],
      ),
    );
  }

  form() {
    return Card(
      elevation: 5.0,
      child: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              FutureBuilder<List<Customer>>(
                  future: DbHelper.getCustomer(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Customer>> snapshot) {
                    if (!snapshot.hasData) return CircularProgressIndicator();
                    return DropdownButton<Customer>(
                      items: snapshot.data
                          .map((user) => DropdownMenuItem<Customer>(
                                child: Text(user.name),
                                value: user,
                              ))
                          .toList(),
                      onChanged: (Customer value) {
                        setState(() {
                          _currentUser = value;
                          name = _currentUser.name;
                          cid= _currentUser.id;
                        });
                      },
                      isExpanded: true,
                      //value: _currentUser,
                      hint: _currentUser != null
                          ? Text(_currentUser.name)
                          : Text("Select customer"),
                    );
                  }),
              TextFormField(
                controller: controllerAmount,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: 'Amount'),
                validator: (val) => val.length == 0 ? 'Enter Amount' : null,
                onSaved: (val) => amount = int.parse(val),
              ),
              Container(
                padding: EdgeInsets.only(top: 10.0),
                width: 300,
                child: OutlineButton(
                    color: Colors.blueAccent,
                    child:
                        Text(
                      todayDate.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 40.0),
                          ), onPressed: () {},
                ),
              ),
              Row(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: FlatButton(
                    onPressed: validate,
                    child: Container(
                      height: 45,
                      width: MediaQuery.of(context).size.width / 3,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF0e81d1), Color(0xFF1f96f2)],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: Center(
                        child: Text(
                          'Save'.toUpperCase(),
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  new TodayCollectionList()));
                    },
                    child: Container(
                      height: 45,
                      width: MediaQuery.of(context).size.width / 3,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF0e81d1), Color(0xFF1f96f2)],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: Center(
                        child: Text(
                          'List'.toUpperCase(),
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
