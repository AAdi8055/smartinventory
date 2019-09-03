import 'package:flutter/material.dart';
class TodaysBalance extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => TodaysBalanceState();

}
class TodaysBalanceState extends State<TodaysBalance>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Todays Balance'),
      ),
      body: Container(
        child: Text('Todays Balance'),
      ),
    );
  }

}