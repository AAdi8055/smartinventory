import 'package:flutter/material.dart';
class TotalOutstanding extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => TotalOutstandingState();

}
class TotalOutstandingState extends State<TotalOutstanding>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Total Outstanding'),
      ),
      body: Container(
        child: Text('Total Outstanding'),
      ),
    );
  }

}