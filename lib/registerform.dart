import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartinventory/home.dart';
import 'package:smartinventory/main.dart';



class RegistrationForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RegistrationFormState();
  }
}

enum FormType { login, register }
class RegistrationFormState extends State<RegistrationForm>
{


  var controller = new TextEditingController();
  final formKey = new GlobalKey<FormState>();
  String _email;
  String _password;
  FormType _formType = FormType.register;
  void showToast(String msg){
    Fluttertoast.showToast(msg: msg,
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_SHORT,
        textColor: Colors.white
    );

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
      showToast('Register Successfully');
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
          _onLoading();


          /*SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('email', _email);
          Navigator.of(context).pop();
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) => new HomePage()));*/

        } else {
          FirebaseUser user = (await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
              email: _email, password: _password)).user;
          print('Register ${user.uid}');
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('email', _email);
          formKey.currentState.reset();
          _onLoading();

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
  @override
  Widget build(BuildContext context) {
    var padding = MediaQuery.of(context).padding;
    double height =MediaQuery.of(context).size.height/2.5;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: SingleChildScrollView(
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
                          child: Text('Register',
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
                              child: Text('Regiter'.toUpperCase(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 16,
                              ),
                              child: FlatButton(
                                child: Text('Already have an account Login',
                                  style: TextStyle(
                                      color: Colors.grey
                                  ),
                                ),
                                onPressed: (){
                                  Navigator.of(context).pop();
                                  Navigator.of(context).push(new MaterialPageRoute(
                                      builder: (BuildContext context) => new MyHomePage()));
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}