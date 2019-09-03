import 'package:flutter/material.dart';
class TodayCollection extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => TodayCollectionState();

}
class TodayCollectionState extends State<TodayCollection>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Todays Collection'),
      ),
      body: Container(
        child: Text('Todays Collection'),
      ),
    );
  }

}