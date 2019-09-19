import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:smartinventory/database/databaseFile.dart';
class SingleCustomerWiseReport extends StatefulWidget {
  final String name;

  SingleCustomerWiseReport({ Key key,this.name}): super(key: key);

  @override
  _SingleCustomerWiseReportState createState() => _SingleCustomerWiseReportState(name: this.name);
}

class _SingleCustomerWiseReportState extends State<SingleCustomerWiseReport> {
  var DbHelper;
  final String name;

  _SingleCustomerWiseReportState({this.name});

  Future<List<CustomerReport>> customerReport;
  @override
  void initState() {
    super.initState();
    DbHelper = dbHelper();
    refreshList();
  }

  refreshList() {
    setState(() {
      customerReport = DbHelper.customerWiseReport();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Single Customer Wise Details'),
      ),
      body: FutureBuilder<List<CustomerReport>>(
        future: DbHelper.customerSingleWiseReport(name),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          return ListView(
            children: snapshot.data
                .map((customerReport) => Card(
              elevation: 5,
              child: Slidable(
                actionPane: SlidableBehindActionPane(),
                actionExtentRatio: 0.25,
                child: Container(
                    child: ListTile(
                      title: Text(customerReport.customerName),
                      subtitle: Text(customerReport.date+"\n" +customerReport.amount.toString()),
                      leading: CircleAvatar(
                        backgroundColor: Colors.red,
                        child: Text(customerReport.customerName[0],
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                            )),
                      ),
                      onTap: () {
                      },
                    )),
                actions: <Widget>[],
                secondaryActions: <Widget>[],
              ),
            ))
                .toList(),
          );
        },
      ),
    );
  }
}
class SelectCustomer extends StatefulWidget {
  @override
  _SelectCustomerState createState() => _SelectCustomerState();
}

class _SelectCustomerState extends State<SelectCustomer> {
  var DbHelper;
  var name;
  var _currentUser;
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Customer'),
      ),
      body: FutureBuilder<List<Customer>>(
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
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (BuildContext context) =>
                          new SingleCustomerWiseReport(name: name,)));
                });
              },
              isExpanded: true,
              //value: _currentUser,
              hint: _currentUser != null
                  ? Text(_currentUser.name)
                  : Text("Select customer"),
            );
          }),
    );
  }
}

