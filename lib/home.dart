import 'package:flutter/material.dart';
import 'package:smartinventory/chart.dart';
import 'package:smartinventory/customerForm.dart';
import 'package:smartinventory/newMain.dart';
import 'package:smartinventory/productList.dart';
import 'package:smartinventory/vendorForm.dart';
import './page.dart';
import './profile.dart';
import 'productForm.dart';
import 'list2.dart';
import 'customerList.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String currentProfilePic =
      "https://avatars3.githubusercontent.com/u/16825392?s=460&v=4";
  String otherProfilePic =
      "https://yt3.ggpht.com/-2_2skU9e2Cw/AAAAAAAAAAI/AAAAAAAAAAA/6NpH9G8NWf4/s900-c-k-no-mo-rj-c0xffffff/photo.jpg";

  void switchAccounts() {
    String picBackup = currentProfilePic;
    this.setState(() {
      currentProfilePic = otherProfilePic;
      otherProfilePic = picBackup;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Home"),
          backgroundColor: Colors.blueAccent,
        ),
        drawer: new Drawer(
          child: new ListView(
            children: <Widget>[
              new UserAccountsDrawerHeader(
                accountEmail: new Text("Sukhakarta@gmail.com"),
                accountName: new Text("Sukhakarta"),
                currentAccountPicture: new GestureDetector(
                  child: new CircleAvatar(
                    backgroundImage: new AssetImage("asstes/aadi.JPG"),
                  ),
                  onTap: () => print("This is your current account."),
                ),
                decoration: new BoxDecoration(
                    image: new DecorationImage(
                        image: AssetImage("asstes/background.jpg"),
                        fit: BoxFit.fill)),
                onDetailsPressed: () => Navigator.of(context).push(
                    new MaterialPageRoute(
                        builder: (BuildContext context) => new Profile())),
              ),
              ExpansionTile(
                backgroundColor: Color(0xFFD6D6D6),
                title: Text("Master"),
                children: <Widget>[
                  new Divider(),
                  new ListTile(
                      title: new Text("Vendor"),
//                  trailing: new Icon(Icons.arrow_upward),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (BuildContext context) => new VendorForm()));
                      }),
                  new Divider(),
                  new ListTile(
                      title: new Text("Customer with user"),
//                  trailing: new Icon(Icons.arrow_upward),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (BuildContext context) => new NewMain()));
                      }),
                ],
              ),
              ExpansionTile(
                backgroundColor: Color(0xFFD6D6D6),
                title: Text("Sales Transaction"),
                children: <Widget>[
                  new Divider(),
                  new ListTile(
                      title: new Text("Sales Invoice"),
//                  trailing: new Icon(Icons.arrow_upward),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (BuildContext context) => new NewMain()));
                      }),
                ],
              ),
              ExpansionTile(
                  backgroundColor: Color(0xFFD6D6D6),
                  title: Text('Account Transaction'),
                  children: <Widget>[
                    new Divider(),
                    new ListTile(
                        title: new Text("Customer Payment"),
//                  trailing: new Icon(Icons.arrow_upward),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(new MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  new NewMain()));
                        }),
                    new Divider(),
                    new ListTile(
                        title: new Text("Vendor Payment"),
//                  trailing: new Icon(Icons.arrow_right),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(new MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  new ProductList()));
                        }),
                    new Divider(),
                    new ListTile(
                        title: new Text("Fund Transfer"),
//                  trailing: new Icon(Icons.arrow_upward),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(new MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  new Page("Home")));
                        }),
                    new Divider(),
                    new ListTile(
                        title: new Text("Incone/Expenses"),
//                  trailing: new Icon(Icons.arrow_upward),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(new MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  new Page("Home")));
                        }),
                    new Divider(),
                    new ListTile(
                        title: new Text("Cash/Bank Book"),
//                  trailing: new Icon(Icons.arrow_upward),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(new MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  new ChartPage()));
                        }),
                    new Divider(),
                    new ListTile(
                        title: new Text("Customer Statement"),
//                  trailing: new Icon(Icons.arrow_right),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(new MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  new NewList()));
                        }),
                    new Divider(),
                    new ListTile(
                      title: new Text("Balance Transfer"),
//                trailing: new Icon(Icons.cancel),
                      onTap: () => Navigator.pop(context),
                    ),
                  ]),
              ExpansionTile(
                  backgroundColor: Color(0xFFD6D6D6),
                  title: Text('Reports'),
                  children: <Widget>[
                    new Divider(),
                    new ListTile(
                      title: new Text('Sales & Collection'),
                      onTap: () => Navigator.pop(context),
                    ),
                    new Divider(),
                    new ListTile(
                      title: new Text('Outstanding Report'),
                      onTap: () => Navigator.pop(context),
                    ),
                    new Divider(),
                    new ListTile(
                      title: new Text('Sales Details Report'),
                      onTap: () => Navigator.pop(context),
                    ),
                    new Divider(),
                    new ListTile(
                      title: new Text('Daily Cash Report'),
                      onTap: () => Navigator.pop(context),
                    ),
                    new Divider(),
                    new ListTile(
                      title: new Text('Sales Register'),
                      onTap: () => Navigator.pop(context),
                    ),
                  ]),
              new ListTile(
                  title: new Text('Balance Request'),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (BuildContext context) => new CustomerForm()));
                  }),

              /* new ListTile(
                  title: new Text("Home"),
//                  trailing: new Icon(Icons.arrow_upward),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (BuildContext context) => new NewMain()));
                  }),
              new Divider(),
              new ListTile(
                  title: new Text("Product"),
//                  trailing: new Icon(Icons.arrow_right),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (BuildContext context) => new ProductList()));
                  }),
              new Divider(),
              new ListTile(
                  title: new Text("Invoice"),
//                  trailing: new Icon(Icons.arrow_upward),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (BuildContext context) => new Page("Home")));
                  }),
              new Divider(),
              new ListTile(
                  title: new Text("Product Stack"),
//                  trailing: new Icon(Icons.arrow_upward),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (BuildContext context) => new Page("Home")));
                  }),
              new Divider(),
              new ListTile(
                  title: new Text("Account"),
//                  trailing: new Icon(Icons.arrow_upward),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (BuildContext context) => new ChartPage()));
                  }),
              new Divider(),
              new ListTile(
                  title: new Text("Customer"),
//                  trailing: new Icon(Icons.arrow_right),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (BuildContext context) => new NewList()));
                  }),
              new Divider(),
              new ListTile(
                title: new Text("Logout"),
//                trailing: new Icon(Icons.cancel),
                onTap: () => Navigator.pop(context),
              ),*/
            ],
          ),
        ),
        body: Scaffold(
          body: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[];
              },
              body: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("asstes/bg.png"), fit: BoxFit.cover)),
                child: (Stack(children: <Widget>[
                  /*Positioned(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(16.0, 32.0, 32.0, 64.0),
                      color: Colors.blueAccent,
                      width: double.infinity,
                      alignment: AlignmentDirectional.center,
                      height: 150,
                      child: Text(
                        "I am looking for an opportunity to...",
                        style: TextStyle(
                            color: Colors.black12,
                            fontWeight: FontWeight.bold,
                            fontSize: 24),
                      ),
                    ),*/
                  Positioned(
                      /*  top: -10.0,*/
                      child: GridView.count(
                    primary: false,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    padding: const EdgeInsets.fromLTRB(16.0, 150.0, 16.0, 16.0),
                    crossAxisCount: 2,
                    children: categoryCard,
                  )),
                ])),
              )),
        ));
  }
}

List<CategoryCard> categoryCard = [
  CategoryCard(
      "https://img.icons8.com/ios-filled/72/paid.png", "Today's Balance"),
  CategoryCard("https://img.icons8.com/color/48/000000/message-squared.png",
      "Today's Collection"),
  CategoryCard("https://img.icons8.com/color/48/000000/service.png",
      "Total OutStanding"),
  CategoryCard("https://img.icons8.com/bubbles/50/000000/product.png",
      "Account Balance"),
  CategoryCard("https://img.icons8.com/bubbles/50/000000/about.png",
      "Available Balance"),
  CategoryCard("https://img.icons8.com/cute-clipart/64/000000/feedback.png",
      "Balance Request"),
];

class CategoryCard extends StatelessWidget {
  final String images, titles;

  CategoryCard(this.images, this.titles);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        color: Colors.white,
        elevation: 10.0,
        child: new InkWell(
            onTap: () {
//            print("tapped");
              if (titles == "Today's Balance") {
                Navigator.of(context).pushNamed('/todaysBalance');
              } else if (titles == "Today's Collection") {
                Navigator.of(context).pushNamed('/todaysCollection');
              } else if (titles == "Total OutStanding") {
                Navigator.of(context).pushNamed('/totalOutStanding');
              } else if (titles == "Account Balance") {
                Navigator.of(context).pushNamed('/accountBalance');
              } else if (titles == "Available Balance") {
                Navigator.of(context).pushNamed('/availableBalance');
              } else if (titles == "Balance Request") {
                Navigator.of(context).pushNamed('/balanceRequest');
              }
            },
            child: Padding(
              padding: new EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
              child: Column(
                children: <Widget>[
                  Image(
                    image: new NetworkImage(images),
                    fit: BoxFit.cover,
                    height: 80,
                    width: 80,
                  ),
                  Expanded(
                    child: Text(
                      titles,
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
