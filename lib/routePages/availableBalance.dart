import 'package:flutter/material.dart';
class AvailableBalance extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => AvailableBalanceState();

}
class AvailableBalanceState extends State<AvailableBalance>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Balance'),
      ),
      body: Container(
        child: Text('Available Balance'),
      ),
    );
  }

}