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
  DateTime selectedDate = DateTime.now();
  String formattedDate;
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null || picked != selectedDate)
      setState(() {
        selectedDate = picked;
        formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
        date = formattedDate;
        print(formattedDate);
      });

  }


  Future<List<Customer>> customer;
  Future<List<TodayCollection>> todayCollection;

  var _currentUser;

  TextEditingController controllerAmount = TextEditingController();
  String id;
  String name;
  int amount;
  String date;

  clearName() {
    controllerAmount.text = '';
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
      TodaysCollection e = TodaysCollection(
        null,
        name,
        amount,
        date,
      );
      print(e);
      DbHelper.saveCollection(e);
      showToast("Save Successfully");
      clearName();
      refreshList();
      formattedDate = null;
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
    return Form(
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
              child: RaisedButton(

                color: Colors.white30,
                  onPressed: () => _selectDate(context),
                  child: formattedDate != null
                      ? Text(formattedDate.toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: 40.0),)
                      : Text('Select date',textAlign: TextAlign.center,style: TextStyle(fontSize: 40.0),)),
            ),

            RaisedButton(
              onPressed: validate,
              child: Text('Save'),
            ),
            RaisedButton(
              onPressed: (){
                Navigator.pop(
                    context);
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) => new TodayCollectionList()));
              },
              child: Text('List'),
            ),
          ],
        ),
      ),
    );

  }
}
