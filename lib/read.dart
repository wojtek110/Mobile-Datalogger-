import 'package:flutter/material.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';
import 'package:hive/hive.dart';
import 'package:projekt1/database.dart';
import 'package:projekt1/gloabls.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:projekt1/read_local.dart';
import 'local.dart';
import 'main.dart';
import 'package:projekt1/function.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:projekt1/read_database.dart';
class read extends StatelessWidget {
  const read({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: const Text('Odczyt')
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () async{
                  box = await Hive.openBox('myBox');
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ReadLocal()));
              },
              child: const Text('Lokalnie'),
            ),
            ElevatedButton(
              onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ReadDatabase()));
              },
              child: const Text('baza danych'),
            ),
          ],
        ),
      ),
    );
  }
}