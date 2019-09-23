import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smartinventory/registerform.dart';
import 'package:smartinventory/routePages/accountBalance.dart';
import 'package:smartinventory/routePages/availableBalance.dart';
import 'package:smartinventory/routePages/balanceRequestForm.dart';
import 'package:smartinventory/routePages/balanceRequestList.dart';
import 'package:smartinventory/routePages/todaysBalance.dart';
import 'package:smartinventory/routePages/todaysCollection.dart';
import 'package:smartinventory/routePages/totalOutstanding.dart';
import 'home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';



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
      },
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}
enum FormType { login, register }

class _MyHomePageState extends State<MyHomePage> {


  var controller = new TextEditingController();
  final formKey = new GlobalKey<FormState>();
  String _email;
  String _password;
  FormType _formType = FormType.login;
  void showToast(String msg){
    Fluttertoast.showToast(msg: msg,
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_SHORT,
        textColor: Colors.white
    );

  }
  void _onLoading() {
      showDialog(
        context: context,
        barrierDismissible: false,
        child: Center(
          child: new Container(
            width: 40,
            height: 40,
            child:
            new CircularProgressIndicator(),
          ),
        ),
      );
      new Future.delayed(new Duration(seconds: 3), () async {
        Navigator.pop(context); //pop dialog
        showToast('Login Successfully');
        Navigator.of(context).pop();
        Navigator.of(context).push(new MaterialPageRoute(
            builder: (BuildContext context) => new HomePage()));
      });
  }
  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }


  void validateAndSubmit() async {
    if (validateAndSave()) {
      String userId = "";
      try {
        if (_formType == FormType.login) {

          FirebaseUser user = (await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: _email, password: _password)) .user ;
          print('Sign in ${user.uid}');
          formKey.currentState.reset();
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('email', _email);
          _onLoading();


          /*
          Navigator.of(context).pop();
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) => new HomePage()));*/

        } else {
          FirebaseUser user = (await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
              email: _email, password: _password)).user;
          print('Register ${user.uid}');
          showToast('Signup Successfully');
          formKey.currentState.reset();
        }
      } catch (e) {
        print('Error $e');
        Fluttertoast.showToast(msg: "Please Enter vaild Email and Password");
        controller.text="";

      }
    }
  }
  void loginUser() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
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
            child: FlatButton( child: Text(" NO "),onPressed: null,),
          ),
          new GestureDetector(
            onTap: () => SystemNavigator.pop(),
            child: FlatButton( child: Text(" Yes "),onPressed: null,),
          ),
        ],
      ),
    ) ??
        false;
  }
  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }
  Widget roundedButton(String buttonLabel, Color bgColor, Color textColor) {
    var loginBtn = new Container(
      padding: EdgeInsets.all(5.0),
      alignment: FractionalOffset.center,
      decoration: new BoxDecoration(
        color: bgColor,
        borderRadius: new BorderRadius.all(const Radius.circular(10.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: const Color(0xFF696969),
            offset: Offset(1.0, 6.0),
            blurRadius: 0.001,
          ),
        ],
      ),
      child: Text(
        buttonLabel,
        style: new TextStyle(
            color: textColor, fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
    );
    return loginBtn;
  }
  /*@override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 100.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                        child: Text('',
                            style: TextStyle(
                                fontSize: 80.0, fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 175.0, 0.0, 0.0),
                          child: Center(
                            child: Text('Login',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 80.0, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            decoration: InputDecoration(
                                labelText: 'EMAIL',
                                labelStyle: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.blueAccent))),
                            validator: (val) => val.isEmpty ? 'please enter email' : null,
                            onSaved: (val) => _email = val,
                            autofocus: true,
                          ),
                          SizedBox(height: 20.0),
                          TextFormField(
                            decoration: InputDecoration(
                                labelText: 'PASSWORD',
                                labelStyle: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.blueAccent))),
                            obscureText: true,
                            validator: (val) => val.isEmpty ? 'please enter password' : null,
                            onSaved: (val) => _password = val,
                            controller: controller,
                          ),
                          SizedBox(height: 5.0),
                          Container(
                            alignment: Alignment(1.0, 0.0),
                            padding: EdgeInsets.only(top: 15.0, left: 20.0),
                            child: InkWell(
                              child: Text(
                                'Forgot Password',
                                style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat',
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                          ),
                          SizedBox(height: 40.0),
                          Container(
                            height: 40.0,
                            child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              shadowColor: Colors.blueAccent,
                              color: Colors.blueAccent,
                              elevation: 7.0,
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).pushNamed('/home');
                                },
                                child: Center(
                                  child: Container(
                                    width: 200,
                                    child: FlatButton(

                                      child: Text(
                                        'LOGIN',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Montserrat'),
                                      ),
                                      onPressed: _onLoading,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.0),
//                    Container(
//                      height: 40.0,
//                      color: Colors.transparent,
//                      child: Container(
//                        decoration: BoxDecoration(
//                            border: Border.all(
//                                color: Colors.black,
//                                style: BorderStyle.solid,
//                                width: 1.0),
//                            color: Colors.transparent,
//                            borderRadius: BorderRadius.circular(20.0)),
//
//                        child: Row(
//                          mainAxisAlignment: MainAxisAlignment.center,
//                          children: <Widget>[
////                            Center(
////                              child:
////                              ImageIcon(
////                                  AssetImage('assets/facebook.png')
////                              ),
////                            ),
//                            SizedBox(width: 10.0),
//                            Center(
//                              child: Text('Log in with facebook',
//                                  style: TextStyle(
//                                      fontWeight: FontWeight.bold,
//                                      fontFamily: 'Montserrat')),
//                            )
//                          ],
//                        ),
//
//                      ),
//                    )
                        ],
                      ),
                    )),
                SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'New to Flutter ?',
                      style: TextStyle(fontFamily: 'Montserrat'),
                    ),
                    SizedBox(width: 5.0),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed('/signup');
                      },
                      child: Text(
                        'Register',
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline),
                      ),q1
                    )
                  ],
                )
              ],
            ),
          ),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
       );*/

  @override
  Widget build(BuildContext context) {
    var padding = MediaQuery.of(context).padding;
double height =MediaQuery.of(context).size.height/2.5;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: SingleChildScrollView(
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: height - padding.top,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFF0e81d1),
                            Color(0xFF1f96f2)
                          ],
                        ),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(90)
                        )
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Spacer(),
                        Align(
                          alignment: Alignment.center,
                          child: Icon(Icons.person,
                            size: 90,
                            color: Colors.white,
                          ),
                        ),
                        Spacer(),

                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                bottom: 32,
                                right: 32
                            ),
                            child: Text('Login',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Form(
                    key: formKey,
                    child: Container(

                      height: MediaQuery.of(context).size.height/2,

                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(top: 62),
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width/1.2,
                            height: 60,
                            padding: EdgeInsets.only(
                                top: 7,left: 16, right: 16, bottom: 4
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(50)
                                ),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 5
                                  )
                                ]
                            ),
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                icon: Icon(Icons.email,
                                  color: Colors.grey,
                                ),
                                hintText: 'Email',
                              ),
                              validator: validateEmail,
                              onSaved: (val) => _email = val,
                              autofocus: true,
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width/1.2,
                            height: 60,
                            margin: EdgeInsets.only(top: 32),
                            padding: EdgeInsets.only(
                                top: 7,left: 16, right: 16, bottom: 4
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(50)
                                ),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 5
                                  )
                                ]
                            ),
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                icon: Icon(Icons.vpn_key,
                                  color: Colors.grey,
                                ),
                                hintText: 'Password',
                              ),
                              obscureText: true,
                              validator: (val) => val.isEmpty ? 'please enter password' : null,
                              onSaved: (val) => _password = val,
                              controller: controller,
                            ),
                          ),


                          Spacer(),

                          FlatButton(
                            onPressed: validateAndSubmit,
                            child: Container(
                              height: 45,
                              width: MediaQuery.of(context).size.width/1.2,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF0e81d1),
                                      Color(0xFF1f96f2)
                                    ],
                                  ),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(50)
                                  )
                              ),

                              child: Center(
                                  child: Text('Login'.toUpperCase(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top:15.0),
                            child: FlatButton(
                              onPressed: (){
                                Navigator.of(context).pop();
                                Navigator.of(context).push(new MaterialPageRoute(
                                    builder: (BuildContext context) => new RegistrationForm()));
                              },
                              child: Container(
                                height: 45,
                                width: MediaQuery.of(context).size.width/1.2,
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFF0e81d1),
                                        Color(0xFF1f96f2)
                                      ],
                                    ),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(50)
                                    )
                                ),

                                child: Center(
                                  child: Text('Register'.toUpperCase(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }
}
