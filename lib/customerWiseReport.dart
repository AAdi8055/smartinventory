import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:smartinventory/database/databaseFile.dart';

class CustomerWiseReport extends StatefulWidget {
  final String name;

  CustomerWiseReport({Key key, this.name}) : super(key: key);

  @override
  _CustomerWiseReportState createState() =>
      _CustomerWiseReportState(name: this.name);
}

class _CustomerWiseReportState extends State<CustomerWiseReport> {
   String name;

  _CustomerWiseReportState({Key key, this.name});

  var DbHelper;
  Future<List<BalanceRequest>> balanceRequest;
  Future<List<TodaysCollection>> todaysColletion;
  Future<List<CustomerReport>> customerReport;

  @override
  void initState() {
    super.initState();
    DbHelper = dbHelper();
    refreshList();
    if(name==null){
      name=null;
    }
    else{
      name=name;
    }
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
        title: Text('All Customer Wise Details'),
      ),
      body: _buildChild(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Popup();

        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildChild() {
    if (name == null) {
      return FutureBuilder<List<CustomerReport>>(
        future: DbHelper.customerWiseReport(),
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
                      subtitle: Text(customerReport.date +
                          "\n" +
                          customerReport.amount.toString()),
                      leading: CircleAvatar(
                        backgroundColor: Colors.red,
                        child: Text(customerReport.customerName[0],
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                            )),
                      ),
                      onTap: () {},
                    )),
                actions: <Widget>[],
                secondaryActions: <Widget>[],
              ),
            ))
                .toList(),
          );
        },
      );
    } else {
      return FutureBuilder<List<CustomerReport>>(
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
                      subtitle: Text(customerReport.date +
                          "\n" +
                          customerReport.amount.toString()),
                      leading: CircleAvatar(
                        backgroundColor: Colors.red,
                        child: Text(customerReport.customerName[0],
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                            )),
                      ),
                      onTap: () {},
                    )),
                actions: <Widget>[],
                secondaryActions: <Widget>[],
              ),
            ))
                .toList(),
          );
        },
      );
    }
  }

  NameFilter() {

  }

  Popup() {
    var DbHelper;
    var name;
    var _currentUser;
    DbHelper = dbHelper();
    Future<List<Customer>> customer;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            contentPadding: EdgeInsets.only(top: 0.0),
            content: Container(
              width: 300.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  InkWell(
                    child: Container(
                      padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(32.0),
                            topRight: Radius.circular(32.0)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            "SELECT CUSTOMER",
                            style:
                                TextStyle(fontSize: 24.0, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    children: <Widget>[
                      Text(""),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30.0, right: 30.0),
                    child: FutureBuilder<List<Customer>>(
                        future: DbHelper.getCustomer(),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<Customer>> snapshot) {
                          if (!snapshot.hasData)
                            return CircularProgressIndicator();
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

                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            new CustomerWiseReport(
                                              name: name,
                                            )));
                              });
                            },
                            isExpanded: true,
                            //value: _currentUser,
                            hint: _currentUser != null
                                ? Text(_currentUser.name)
                                : Text("Select Customer"),
                          );
                        }),
                  ),
                  Row(
                    children: <Widget>[
                      Text(""),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(""),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
