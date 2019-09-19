/*
import 'package:flutter/material.dart';
import './database/databaseFile.dart';
import 'database/databaseFile.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'vendorForm1.dart';

class ProductList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ProductListState();
  }
}

class ProductListState extends State<ProductList> {
  var DbHelper;
  Future<List<Vendor>> product;

  @override
  void initState() {
    super.initState();
    DbHelper = dbHelper();
    refreshList();
  }

  refreshList() {
    setState(() {
      product = DbHelper.getProduct();
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Poduct List'),
      ),
      body: FutureBuilder<List<Vendor>>(
        future: DbHelper.getProductData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          return ListView(
            children: snapshot.data
                .map((product) => Card(
                      elevation: 5,
                      child: Slidable(
                        actionPane: SlidableBehindActionPane(),
                        actionExtentRatio: 0.25,
                        child: Container(
                            child: ListTile(
                          title: Text(product.productName),
                          subtitle: Text(product.productDesc),
                              trailing: Text('Cost : '+product.cost+'\n'+'Quantiity : '+product.quantity+product.unit ,),
                          leading: CircleAvatar(
                            backgroundColor: Colors.red,
                            child: Text(product.productName[0],
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.white,
                                )),
                          ),
                          onTap: () {
                           */
/* Navigator.of(context).push(new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    new CustomerForm()));*//*

                          },
                        )),
                        actions: <Widget>[],
                        secondaryActions: <Widget>[
                          IconSlideAction(
                            caption: 'Delete',
                            color: Colors.red,
                            icon: Icons.delete,
                            onTap: () {
                              DbHelper.deleteProduct(product.id);
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
            return new ServiceHistory();
          }));
        },
        child: Icon(Icons.add),
      ),
    );
  }
  void showToast(String msg){
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}
*/
