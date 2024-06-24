import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:projekt1/data.dart';
import 'package:projekt1/database.dart';
import 'package:projekt1/gloabls.dart';
import 'dart:async';

class local extends StatefulWidget {
  @override
  State<local> createState() => _localState();
}

class _localState extends State<local> {
  final Box<dynamic> _myBox=Hive.box("dane");

  // void getAllData(){
  //   final x=_myBox.
  // }

  //List<double> w=_myBox.get(1);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Moja aplikacja'),
      ),
      body: Center(
        child: ListView(
          children:[
            Text("${_myBox.get(1)}")
            ],
        ),
      ),
    );
  }
}