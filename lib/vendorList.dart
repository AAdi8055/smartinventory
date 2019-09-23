import 'package:flutter/material.dart';
import 'package:smartinventory/vendorForm.dart';
import 'package:smartinventory/vendorForm1.dart' as prefix0;
import 'package:smartinventory/vendorForm1.dart';
import 'database/databaseFile.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'customerForm.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smartinventory/customerForm.dart';

class VendorList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return VendorListState();
  }
}

class VendorListState extends State<VendorList> {
  var DbHelper;
  String name, id, address, contact, email;
  Future<List<Vendor>> vendor;

  @override
  void initState() {
    super.initState();
    DbHelper = dbHelper();
    refreshList();
  }

  refreshList() {
    setState(() {
      vendor = DbHelper.getVendor();
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Vendor List'),
      ),
      body: FutureBuilder<List<Vendor>>(
        future: DbHelper.getVendorModelData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: Text('No record Added'));

          return ListView(
            children: snapshot.data
                .map((vendor) => Card(
                      elevation: 5,
                      child: Slidable(
                        actionPane: SlidableBehindActionPane(),
                        actionExtentRatio: 0.25,
                        child: Container(
                            child: ListTile(
                          title: Text(vendor.name),
                          subtitle: Text(vendor.email),
                          leading: CircleAvatar(
                            backgroundColor: Colors.red,
                            child: Text(vendor.name[0],
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.white,
                                )),
                          ),
                          onTap: () {
                            setState(() {
                              name = vendor.name;
                              address = vendor.address;
                              email = vendor.email;
                              contact= vendor.contact;
                              id = vendor.id.toString();
                              Popup();
                            });
                          },
                        )),
                        actions: <Widget>[],
                        secondaryActions: <Widget>[
                          IconSlideAction(
                            caption: 'Delete',
                            color: Colors.red,
                            icon: Icons.delete,
                            onTap: () {
                              DbHelper.deleteVendor(vendor.id);
                              showToast('Delted Successfully');
                              refreshList();
                            },
                          ),
                        ],
                      ),
                    ))
                .toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
            return new prefix0.VendorForm();
          }));
        },
        child: Icon(Icons.add),
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

  Popup() {
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
                            "ALERT",
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
                  Padding(
                    padding: EdgeInsets.only(left: 30.0, right: 30.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Do you want to Edit Daat",
                        border: InputBorder.none,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                          child: Text('Yes'),
                          onPressed: () {
                            setState(() {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          new prefix0.VendorForm(
                                              id: id,
                                              name: name,
                                              email: email,
                                              address: address,
                                              contact: contact)));
                            });
                          }),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: FlatButton(
                            child: Text('no'),
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
