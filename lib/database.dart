
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mysql1/mysql1.dart';
import 'package:projekt1/data.dart';
import 'package:projekt1/function.dart';
import 'package:projekt1/gloabls.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tuple/tuple.dart';
import 'package:projekt1/main.dart';
class Mysql {
  static String host = "eu-cdbr-west-03.cleardb.net",
      user = 'b043a9e357f7ec',
      password = '50dbc994',
      db = "heroku_3e854011cd3536a";
  static int port = 3306;
  Mysql();
  Future<MySqlConnection> getConnection() async {
    var setings = new ConnectionSettings(
        host: host, port: port, user: user, password: password, db: db);
    return await MySqlConnection.connect(setings);
  }
}

void zapytanie(baza) {
  baza.getConnection().then((conn) {
    String sql =
        "SELECT * FROM heroku_3e854011cd3536a.gps;";
    conn.query(sql).then((results) {
      for (var row in results) {
        print('wiersz w bazie latitude: ${row[0]}, longitude: ${row[1]} event: ${row[2]}');
      }
    });
  });
}
Future<int> get_last_event(baza) async {
  int event = 0;
  var conn = await baza.getConnection();
  
  try {
    var results = await conn.query(
      'SELECT event FROM heroku_3e854011cd3536a.gps ORDER BY event DESC LIMIT 1;',
    );
    
    for (var row in results) {
      event = row[0] + 1;
    }
  } finally {
    await conn.close();
  }
  
  return event;
}
void send_to_firebase(String not, String data) {
  DatabaseReference ref = FirebaseDatabase.instance.ref('$not');
  convert_measurement();
  
  ref.child('name').set(
    {
      'Opis': not,
      'Data': data,
    }
  );

  ref.child('GPS').set({
    'latitude': cord_lati,
    'longitude': cord_long,
  });
  ref.child("Accelerometer").set({
    'x': x_acc,
    'y': y_acc,
    'z': z_acc,
    'time': time_a_acc,
  });
  ref.child("Gyroscope").set({
    'x': x_gyro,
    'y': y_gyro,
    'z': z_gyro,
    'time': time_a_gyro,
  });
}
void send_to_database(baza,coordinates,accelerometer,gyroscope,BuildContext context) async
{
  send_flag=true;
  showSendDialog(context);
  int event=await get_last_event(baza);
  baza.getConnection().then((conn) async {
    for (var coord in coordinates){
        double lati=coord.latitude;
        double longi=coord.longitude;
        String sql="INSERT INTO heroku_3e854011cd3536a.gps VALUES($lati, $longi,$event); ";
        await conn.query(sql);
    }
    for (var acceele in accelerometer){
        double x=acceele.x;
        double y=acceele.y;
        double z= acceele.z;
        String sql="INSERT INTO heroku_3e854011cd3536a.accelerometer VALUES($event,$x,$y,$z); ";
        await conn.query(sql);
    }
    for(var gyro in gyroscope)
    {
      double x=gyro.x;
      double y=gyro.y;
      double z=gyro.z;
      String sql="INSERT INTO heroku_3e854011cd3536a.gyroscope VALUES($event,$x,$y,$z);";
      await conn.query(sql);
    }
      conn.close();
  });
  send_flag=false; 
  showSendDialog(context);
}
var db=Mysql();