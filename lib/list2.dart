import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'database/databaseFile.dart';

class TodayCollectionList extends StatefulWidget {
  @override
  _TodayCollectionListState createState() => _TodayCollectionListState();
}

class _TodayCollectionListState extends State<TodayCollectionList> {
  var DbHelper;

  @override
  void initState() {
    super.initState();
    DbHelper = dbHelper();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Today\'s collection List'),
      ),
      body: FutureBuilder<List<TodaysCollection>>(
        future: DbHelper.getTodaysCollection(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          return ListView(
            children: snapshot.data
                .map((todaysCollection) =>
                Card(
                  elevation: 5,
                  child: Slidable(
                    actionPane: SlidableBehindActionPane(),
                    actionExtentRatio: 0.20,
                    child: Container(
                        child: ListTile(
                          contentPadding: EdgeInsets.all(5.0),
                          title: Text('Name: '+todaysCollection.customerName),
                          subtitle: Text( 'Contact : '+todaysCollection.amount.toString() +'\nAddress: '+ todaysCollection.date),
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey,
                            child: Text(todaysCollection.customerName[0],
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.black,
                                )),
                          ),
                          onTap: () {

                          },
                        )
                    ),
                    actions: <Widget>[],
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        caption: 'Delete',
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () {
                        /*  id=customer.id.toString();*/

                        },
                      ),
                    ],
                  ),
                ))
                .toList(),
          );
        },
      ),
    );
  }
}
