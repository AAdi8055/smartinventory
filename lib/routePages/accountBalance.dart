import 'package:flutter/material.dart';
class AccountBalance extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => AccountBalanceState();

}
class AccountBalanceState extends State<AccountBalance>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Balance'),
      ),
      body: Container(
        child: Text('Account Balance'),
      ),
    );
  }

}