import 'package:flutter/material.dart';
import 'package:smartinventory/productList.dart';
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
          title: new Text("Home Page"),
          backgroundColor: Colors.blueAccent,
        ),
        drawer: new Drawer(
          child: new ListView(
            children: <Widget>[
              new UserAccountsDrawerHeader(
                accountEmail: new Text("kakadedhiraj58@gmail.com"),
                accountName: new Text("Dhiraj Kakade"),
                currentAccountPicture: new GestureDetector(
                  child: new CircleAvatar(
                    backgroundImage: new NetworkImage(currentProfilePic),
                  ),
                  onTap: () => print("This is your current account."),
                ),
                otherAccountsPictures: <Widget>[
                  new GestureDetector(
                    child: new CircleAvatar(
                      backgroundImage: new NetworkImage(otherProfilePic),
                    ),
                    onTap: () => switchAccounts(),
                  ),
                ],
                decoration: new BoxDecoration(
                    image: new DecorationImage(
                        image: new NetworkImage(
                            "https://img00.deviantart.net/35f0/i/2015/018/2/6/low_poly_landscape__the_river_cut_by_bv_designs-d8eib00.jpg"),
                        fit: BoxFit.fill)),
                onDetailsPressed: () => Navigator.of(context).push(
                    new MaterialPageRoute(
                        builder: (BuildContext context) => new Profile())),
              ),
              new ListTile(
                  title: new Text("Home"),
//                  trailing: new Icon(Icons.arrow_upward),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (BuildContext context) => new Page("Home")));
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
                        builder: (BuildContext context) => new Page("Home")));
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
              ),
            ],
          ),
        ),
        body: Scaffold(
          body: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    expandedHeight: 200.0,
                    floating: false,
                    pinned: false,
                    backgroundColor: Colors.blueAccent,
                    automaticallyImplyLeading: false,
                    flexibleSpace: FlexibleSpaceBar(
                        background: Center(
                          child: Text(
                              "Menu",style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          )

                          ),
                        )),

                  ),
                ];
              },
              body: (Stack(children: <Widget>[
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
                      physics: const NeverScrollableScrollPhysics(),
                      primary: false,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                      crossAxisCount: 2,
                      children: categoryCard,
                    )),
              ]))),
        ));
  }
}

List<CategoryCard> categoryCard = [
  CategoryCard(
      "https://img.icons8.com/color/48/000000/tear-off-calendar.png", "Product Count"),
  CategoryCard(
      "https://img.icons8.com/color/48/000000/message-squared.png", "Payment"),
  CategoryCard("https://img.icons8.com/color/48/000000/service.png", "OutStanding"),
  CategoryCard(
      "https://img.icons8.com/bubbles/50/000000/product.png", "Total Bill"),
  CategoryCard("https://img.icons8.com/bubbles/50/000000/about.png", "About"),
  CategoryCard(
      "https://img.icons8.com/cute-clipart/64/000000/feedback.png", "Feedback"),
];

class CategoryCard extends StatelessWidget {
  final String images, titles;

  CategoryCard(this.images, this.titles);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      color: Colors.white,
      elevation: 4.0,
      child: new InkWell(
          onTap: () {
//            print("tapped");
            if (titles == "Event") {
              Navigator.of(context).pushNamed('/event');
            } else if (titles == "Post") {
              Navigator.of(context).pushNamed('/post');
            } else if (titles == "Service") {
              Navigator.of(context).pushNamed('/service');
            } else if (titles == "Product") {
              Navigator.of(context).pushNamed('/product');
            } else if (titles == "About") {
              Navigator.of(context).pushNamed('/about');
            } else if (titles == "Feedback") {
              Navigator.of(context).pushNamed('/addfeedback');
            }
          },
          child: Padding(
            padding: new EdgeInsets.fromLTRB(16.0, 28.0, 16.0, 16.0),
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
                  ),
                )
              ],
            ),
          )),
    );

  }
}
