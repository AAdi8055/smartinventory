import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:smartinventory/database/databaseFile.dart';
class DateWiseReport extends StatefulWidget {
  final String date;

  DateWiseReport({ Key key,this.date}): super(key: key);

  @override
  _DateWiseReportState createState() => _DateWiseReportState(date: this.date);
}

class _DateWiseReportState extends State<DateWiseReport> {
  var DbHelper;
  String date;

  _DateWiseReportState({this.date});

  Future<List<CustomerReport>> customerReport;
  @override
  void initState() {
    super.initState();
    DbHelper = dbHelper();
    refreshList();
    if(date==null){
      date=null;
    }
    else{
      date=date;
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
        title: Text('Date Wise Details'),
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
  Widget _buildChild(){
    if(date==null){
     return FutureBuilder<List<CustomerReport>>(
       future: DbHelper.customerWiseReport(),
       builder: (context, snapshot) {
         if (!snapshot.hasData)
           return Center(child: Text('No record Added'));
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
    else{
      return FutureBuilder<List<CustomerReport>>(
        future: DbHelper.dateWiseReport(date),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: Text('No record Added'));
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
      );
    }
  }
  Popup() {
    var DbHelper;
    var date;
    var _currentUser;
    DbHelper = dbHelper();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0))),
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
                            topLeft: Radius.circular(12.0),
                            topRight: Radius.circular(12.0)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            "SELECT DATE",
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
                    child: FutureBuilder<List<CustomerReport>>(
                        future: DbHelper.dateReport(),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<CustomerReport>> snapshot) {
                          if (!snapshot.hasData)
                            return CircularProgressIndicator();
                          return DropdownButton<CustomerReport>(
                            items: snapshot.data
                                .map((user) => DropdownMenuItem<CustomerReport>(
                              child: Text(user.date),
                              value: user,
                            ))
                                .toList(),
                            onChanged: (CustomerReport value) {
                              setState(() {
                                _currentUser = value;
                                date = _currentUser.date;

                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                        new DateWiseReport(
                                          date: date,
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
