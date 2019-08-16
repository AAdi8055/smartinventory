import 'package:flutter/material.dart';
import './database/employee.dart';
import 'package:async/async.dart';
import 'package:sqflite/sqflite.dart';
import 'customerForm.dart';

class ServiceHistory extends StatefulWidget {
  @override
  _ServiceHistoryState createState() => _ServiceHistoryState();
}

class _ServiceHistoryState extends State<ServiceHistory> {
  Future<List<Product>> product;
  var _currentUser;
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerDesc = TextEditingController();
  TextEditingController controllerCost = TextEditingController();
  TextEditingController controllerUnit = TextEditingController();
  TextEditingController controllerQuantity = TextEditingController();
  String productName;
  String productDesc;
  String cost;
  String unit;
  String quantity;

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
      product = DbHelper.getProduct();
    });
  }

  clearName() {
    controllerName.text = '';
    controllerDesc.text = '';
    controllerCost.text = '';
    controllerQuantity.text = '';
    controllerUnit.text = '';
    _currentUser = null;
  }

  validate() {
    if (formKey.currentState.validate()) {
/*      DbHelper.dropTable(employee);*/
      formKey.currentState.save();
      if (isUpdating) {
        Product e = Product(
          curUserId,
          productName,
          productDesc,
          cost,
          unit,
          quantity,
        );
        DbHelper.update(e);
        setState(() {
          isUpdating = false;
        });
      } else {
        Product e = Product(
          null,
          productName,
          productDesc,
          cost,
          unit,
          quantity,
        );
        DbHelper.saveProduct(e);
      }
      clearName();
      refreshList();
    }
  }

  /*String validateMobile(String value) {
    String patttern = r'(^(?:[0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length != 10) {
      return 'Please enter mobile number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return null;
  }*/

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
              autofocus: true,
              controller: controllerName,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: 'Product Name'),
              validator: (val) => val.length == 0 ? 'Enter Product Name' : null,
              onSaved: (val) => productName = val,
            ),
            TextFormField(
              autofocus: true,
              controller: controllerDesc,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: 'Product Decscribtion'),
              validator: (val) =>
                  val.length == 0 ? 'Enter Product Decscribtion' : null,
              onSaved: (val) => productDesc = val,
            ),
            TextFormField(
              controller: controllerCost,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: 'Product cost'),
              validator: (val) => val.length == 0 ? 'Enter Product Name' : null,
              onSaved: (val) => cost = val,
            ),
            TextFormField(
              controller: controllerUnit,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: 'Product Unit'),
              validator: (val) => val.length == 0 ? 'Enter Product Name' : null,
              onSaved: (val) => unit = val,
            ),
            TextFormField(
              controller: controllerQuantity,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: 'Product Quantity'),
              validator: (val) => val.length == 0 ? 'Enter Product Name' : null,
              onSaved: (val) => quantity = val,
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
            FutureBuilder<List<Product>>(
                future: DbHelper.getUserModelData(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Product>> snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  return DropdownButton<Product>(
                    items: snapshot.data
                        .map((product) => DropdownMenuItem<Product>(
                              child: Text(product.productName),
                              value: product,
                            ))
                        .toList(),
                    onChanged: (Product itemValue) {
                      controllerName.text = itemValue.productName;
                      controllerDesc.text = itemValue.productDesc;
                      _dropdownItemSelected(itemValue);

                      /*setState(() {
                          isUpdating = true;
                          FlatButton(
                            color: Colors.grey,
                            onPressed: validate,
                            child: Text(isUpdating ? 'Update' : 'Add'),
                          );
                        });*/
                    },
                    isExpanded: false,
                    //value: _currentUser,
                    hint: _currentUser != null
                        ? Text(_currentUser.name)
                        : Text("No Name Selected"),
                  );
                }),
            /*SizedBox(height: 20.0),
              _currentUser != null
                  ? Text("Name: " + _currentUser.name)
                  : Text("No Name Selected"),*/
          ],
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names

  SingleChildScrollView dataTable(List<Product> product) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(
              label: Text('Product Name'),
            ),
            DataColumn(
              label: Text('Product Desc'),
            ),
            DataColumn(
              label: Text('Cost'),
            ),
            DataColumn(
              label: Text('Unit'),
            ),
            DataColumn(
              label: Text('Quantity'),
            ),
            DataColumn(
              label: Text('Delete'),
            ),
          ],
          rows: product
              .map(
                (product) => DataRow(cells: [
                  DataCell(
                    Text(
                      product.productName,
                    ),
                    onTap: () {
                      setState(() {
                        isUpdating = true;
                        curUserId = product.id;
                      });
                      controllerName.text = product.productName;
                      controllerDesc.text = product.productDesc;
                      controllerUnit.text = product.unit;
                      controllerQuantity.text = product.quantity;
                      controllerCost.text = product.cost;
                    },
                    placeholder: false,
                  ),
                  DataCell(
                    Text(product.productDesc),
                    onTap: () {
                      setState(() {
                        isUpdating = true;
                        curUserId = product.id;
                      });
                      controllerName.text = product.productName;
                      controllerDesc.text = product.productDesc;
                      controllerUnit.text = product.unit;
                      controllerQuantity.text = product.quantity;
                      controllerCost.text = product.cost;
                    },
                  ),
                  DataCell(
                    Text(product.cost),
                    onTap: () {
                      setState(() {
                        isUpdating = true;
                        curUserId = product.id;
                      });
                      controllerName.text = product.productName;
                      controllerDesc.text = product.productDesc;
                      controllerUnit.text = product.unit;
                      controllerQuantity.text = product.quantity;
                      controllerCost.text = product.cost;
                    },
                  ),
                  DataCell(
                    Text(product.unit),
                    onTap: () {
                      setState(() {
                        isUpdating = true;
                        curUserId = product.id;
                      });
                      controllerName.text = product.productName;
                      controllerDesc.text = product.productDesc;
                      controllerUnit.text = product.unit;
                      controllerQuantity.text = product.quantity;
                      controllerCost.text = product.cost;
                    },
                  ),
                  DataCell(
                    Text(product.quantity),
                    onTap: () {
                      setState(() {
                        isUpdating = true;
                        curUserId = product.id;
                      });
                      controllerName.text = product.productName;
                      controllerDesc.text = product.productDesc;
                      controllerUnit.text = product.unit;
                      controllerQuantity.text = product.quantity;
                      controllerCost.text = product.cost;
                    },
                  ),
                  DataCell(
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        DbHelper.delete(product.id);
                        refreshList();
                      },
                    ),
                  ),
                ]),
              )
              .toList(),
        ),
      ),
    );
  }

  list() {
    return Expanded(
      child: FutureBuilder(
          future: product,
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
        title: Text('Product Details'),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
            return new CustomerForm();
          }));
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  void _dropdownItemSelected(Product itemValue) {
    setState(() {
      this._currentUser = itemValue;
    });
  }
}
