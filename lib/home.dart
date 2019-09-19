import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartinventory/chart.dart';
import 'package:smartinventory/customerForm.dart';
import 'package:smartinventory/newMain.dart';
import 'package:smartinventory/productList.dart';
import 'package:smartinventory/routePages/accountBalance.dart';
import 'package:smartinventory/routePages/availableBalance.dart';
import 'package:smartinventory/routePages/balanceRequestList.dart';
import 'package:smartinventory/routePages/todaysBalance.dart';
import 'package:smartinventory/routePages/todaysCollection.dart';
import 'package:smartinventory/routePages/totalOutstanding.dart';
import 'package:smartinventory/singleCustomerWiseReport.dart';
import 'package:smartinventory/vendorForm1.dart';
import 'package:smartinventory/vendorList.dart';
import './page.dart';
import './profile.dart';
import 'customerWiseReport.dart';
import 'main.dart';
import 'vendorForm1.dart';
import 'list2.dart';
import 'customerList.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => new HomePage(),
        '/todaysBalance': (BuildContext context) => new TodaysBalance(),
        '/todaysCollection': (BuildContext context) => new TodayCollection(),
        '/totalOutStanding': (BuildContext context) => new TotalOutstanding(),
        '/accountBalance': (BuildContext context) => new AccountBalance(),
        '/availableBalance': (BuildContext context) => new AvailableBalance(),
        '/balanceRequest': (BuildContext context) => new BalanceRequestList(),
        '/customerList': (BuildContext context) => new CustomerList(),
        '/vendorList': (BuildContext context) => new VendorList(),
      },
      home: new HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isBackButtonActivated = false;
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

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: FlatButton(
                  child: Text(" No "),
                  onPressed: null,
                ),
              ),
              new GestureDetector(
                onTap: () => SystemNavigator.pop(),
                child: FlatButton(
                  child: Text(" Yes "),
                  onPressed: null,
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: new Scaffold(
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
                  onDetailsPressed: () => null,
                ),
                new ListTile(
                    title: new Text("Vendor"),
//                  trailing: new Icon(Icons.arrow_upward),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) => new VendorList()));
                    }),
                new Divider(),
                new ListTile(
                    title: new Text("Balance Transfer"),
//                trailing: new Icon(Icons.cancel),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              new BalanceRequestList()));
                    }),
                new Divider(),
                new ListTile(
                    title: new Text('Customer'),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              new CustomerList()));
                    }),
                new Divider(),
                new ListTile(
                    title: new Text('Today\'s Balance'),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              new TodaysBalance()));
                    }),
                new Divider(),
                new ListTile(
                    title: new Text('Today\'s COllection'),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              new TodayCollectionList()));
                    }),
                new Divider(),
                new ListTile(
                    title: new Text('Total Outstanding'),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              new TotalOutstanding()));
                    }),
                new Divider(),
                new ListTile(
                    title: new Text('Account Balance'),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              new AccountBalance()));
                    }),
                new Divider(),
                new ListTile(
                    title: new Text('Available Balance'),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              new AvailableBalance()));
                    }),
                new Divider(),

                    ExpansionTile(
                      title: Text("Reports"),
                      children: <Widget>[
                        ListTile(
                            title: new Text('All Customer wise Report'),
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).push(new MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      new CustomerWiseReport()));
                            }),
                        ListTile(
                            title: new Text('Customer wise Report'),
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).push(new MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                  new SelectCustomer()));
                            }),
                      ],
                    ),

                new Divider(),
                new ListTile(
                    title: new Text('Logout'),
                    onTap: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setString('email', null);
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) => new MyHomePage()));
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
                          image: AssetImage("asstes/bg.png"),
                          fit: BoxFit.cover)),
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
                      padding:
                          const EdgeInsets.fromLTRB(16.0, 100.0, 16.0, 16.0),
                      crossAxisCount: 2,
                      children: categoryCard,
                    )),
                  ])),
                )),
          )),
    );
  }
}

List<CategoryCard> categoryCard = [
  CategoryCard(
      "https://img.icons8.com/color/48/000000/buy.png", "Today's Balance"),
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
  CategoryCard("https://img.icons8.com/color/48/000000/gender-neutral-user.png", "Customer"),
  CategoryCard(
      "https://img.icons8.com/color/48/000000/gender-neutral-user.png", "Vendor"),
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
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => new TodaysBalance()));
              } else if (titles == "Today's Collection") {
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => new TodayCollection()));
              } else if (titles == "Total OutStanding") {
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => new TotalOutstanding()));
              } else if (titles == "Account Balance") {
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => new AccountBalance()));
              } else if (titles == "Available Balance") {
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => new AvailableBalance()));
              } else if (titles == "Balance Request") {
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) =>
                        new BalanceRequestList()));
              } else if (titles == "Customer") {
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => new CustomerList()));
              } else if (titles == "Vendor") {
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => new VendorList()));
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
