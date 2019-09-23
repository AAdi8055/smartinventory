import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:smartinventory/database/databaseFile.dart';
class HistoryReport extends StatefulWidget {
  final String name;

  HistoryReport({Key key,this.name}):super(key:key);

  @override
  _HistoryReportState createState() => _HistoryReportState(name: this.name);
}

class _HistoryReportState extends State<HistoryReport> {
  String name;

  _HistoryReportState({Key key,this.name});

  var DbHelper;
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
        title: Text("History Report"),
      ),
      body: _buildBody(),

    );
  }
  Widget _buildBody(){
    if (name==null){
      return FutureBuilder<List<HistoryReport1>>(
        future: DbHelper.historyReport(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: Text('No record Added'));
          return ListView(
            children: snapshot.data
                .map((historyReport) => Card(
              elevation: 5,
              child: Slidable(
                actionPane: SlidableBehindActionPane(),
                actionExtentRatio: 0.25,
                child: Container(
                    child: ListTile(
                      title: Text(historyReport.customerName),
                      subtitle: Text(
                          historyReport.amount.toString()),
                      leading: CircleAvatar(
                        backgroundColor: Colors.red,
                        child: Text(historyReport.customerName[0],
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
    else{
      return FutureBuilder<List<HistoryReport1>>(
        future: DbHelper.historyReportInvividual(name),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: Text('No record Added'));
          return ListView(
            children: snapshot.data
                .map((historyReport) => Card(
              elevation: 5,
              child: Slidable(
                actionPane: SlidableBehindActionPane(),
                actionExtentRatio: 0.25,
                child: Container(
                    child: ListTile(
                      title: Text(historyReport.customerName),
                      subtitle: Text(
                          historyReport.amount.toString()),
                      leading: CircleAvatar(
                        backgroundColor: Colors.red,
                        child: Text(historyReport.customerName[0],
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
  Popup() {
    var DbHelper;
    var name;
    var _currentUser;
    DbHelper = dbHelper();
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
                            "SELECT Name",
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
                    child: FutureBuilder<List<HistoryReport1>>(
                        future: DbHelper.historyReport(),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<HistoryReport1>> snapshot) {
                          if (!snapshot.hasData)
                            return CircularProgressIndicator();
                          return DropdownButton<HistoryReport1>(
                            items: snapshot.data
                                .map((user) => DropdownMenuItem<HistoryReport1>(
                              child: Text(user.customerName),
                              value: user,
                            ))
                                .toList(),
                            onChanged: (HistoryReport1 value) {
                              setState(() {
                                _currentUser = value;
                                name = _currentUser.customerName;

                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                        new HistoryReport(
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
