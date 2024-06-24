import 'package:flutter/material.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';
import 'package:projekt1/database.dart';
import 'package:projekt1/gloabls.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'local.dart';
import 'main.dart';
import 'package:projekt1/function.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
class Send extends StatelessWidget {
  const Send({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zapis'),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
              _showNoteDialog(context);
              //Navigator.push(context, MaterialPageRoute(builder: (context)=>local()));
              toColud=false;
              },
              child: const Text('Lokalnie'),
            ),
            ElevatedButton(
              onPressed: () {
                //send_to_database(db, poli,Accelerometer_data,Gyroscope_data,context),
                _showNoteDialog(context);
                toColud=true;
                ;
              },
              child: const Text('baza danych'),
            ),
          ],
        ),
      ),
    );
  }
}
 Future<void> _showNoteDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Dodaj notatkę'),
          content: TextField(
            onChanged: (value) {
              
                note= value ;

            },
            decoration: InputDecoration(hintText: 'Wprowadź notatkę'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Anuluj'),
              onPressed: () {
                Navigator.of(context).pop(); // Zamknięcie okna dialogowego bez zapisywania notatki
              },
            ),
            TextButton(
              child: Text('Zapisz'),
              onPressed: () {
                Navigator.of(context).pop(); // Zamknięcie okna dialogowego po zapisaniu notatki
                var now = new DateTime.now();
                var formatter = DateFormat('yyyy-MM-dd');
                String formattedDate = formatter.format(now);
                if(toColud==true){
                send_to_firebase(note,formattedDate);
                }
                if(toColud==false)
                {
                save_local('$note : $formattedDate');
                }
              },
            ),
          ],
        );
      },
    );
  }

