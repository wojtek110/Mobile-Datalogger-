
import 'dart:ffi';
import 'main.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_database/ui/firebase_list.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';
import 'package:projekt1/database.dart';
import 'package:projekt1/gloabls.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:projekt1/show_data.dart';
import 'local.dart';
import 'package:projekt1/function.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';


class ReadDatabase extends StatefulWidget {
  const ReadDatabase({Key? key}) : super(key: key);
  @override
  _ReadDatabaseState createState() => _ReadDatabaseState();
}

class _ReadDatabaseState extends State<ReadDatabase> {

final ref=FirebaseDatabase.instance.ref('');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Odczyt baza danych'),
      ),
      body:
      Column( children: [
      Expanded(child: FirebaseAnimatedList(query: ref, itemBuilder: (context,snapshot,animation,index){
        final key=snapshot.key;
        return ListTile(
          title: Text(snapshot.child('name/Opis').value.toString()),
          subtitle: Text(snapshot.child('name/Data').value.toString()),
          onTap: () async {
                    await get_mesurment(snapshot);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ShowData()),
                    );
                  },
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      ref.child('$key').remove();
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
Future <void> get_mesurment(DataSnapshot snapshot) async {
  List<double> lati_read = [];
  List<double> longi_read=[];
  List<double> gyro_x_r=[];
  List<double> gyro_y_r=[];
  List<double> gyro_z_r=[];
  List<double> acc_x_r=[];
  List<double> acc_y_r=[];
  List<double> acc_z_r=[];
  List<double> time_r=[];
  List<double> time_r_a=[];
  accData=[];
  gyroscopeData = [];
  var latitudeData = snapshot.child('GPS/latitude').value;
  var longitudeData= snapshot.child('GPS/longitude').value;
  var gyro_x=snapshot.child('Gyroscope/x').value;
  var gyro_y=snapshot.child('Gyroscope/y').value;
  var gyro_z=snapshot.child('Gyroscope/z').value;
  var acc_x=snapshot.child('Accelerometer/x').value;
  var acc_y=snapshot.child('Accelerometer/y').value;
  var acc_z=snapshot.child('Accelerometer/z').value;
  var time_rr=snapshot.child('Gyroscope/time').value;
  var time_rr_a=snapshot.child('Accelerometer/time').value;

  //Latitude
  if (latitudeData != null) {
    if (latitudeData is List) {
      lati_read = latitudeData.cast<double>();
    } else if (latitudeData is double) {
      lati_read.add(latitudeData);
    }
  }
  //Longitude
  if (longitudeData != null) {
    if (longitudeData is List) {
      longi_read = longitudeData.cast<double>();
    } else if (longitudeData is double) {
      longi_read.add(longitudeData);
    }
  }
  //Gyroscope X
  if (gyro_x != null) {
    if (gyro_x is List) {
      gyro_x_r = List<double>.from(gyro_x.cast<num>().map((e) => e.toDouble()).toList());
    } else if (gyro_x is double) {
      gyro_x_r.add(gyro_x.toDouble());
    }
  }
  //Gyroscope Y
   if (gyro_y != null) {
    if (gyro_y is List) {
      gyro_y_r = List<double>.from(gyro_y.cast<num>().map((e) => e.toDouble()).toList());
    } else if (gyro_y is double) {
      gyro_y_r.add(gyro_y.toDouble());
    }
   }
  //Gyroscope Z
    if (gyro_z != null) {
    if (gyro_z is List) {
      gyro_z_r = List<double>.from(gyro_z.cast<num>().map((e) => e.toDouble()).toList());
    } else if (gyro_z is double) {
      gyro_z_r.add(gyro_z.toDouble());
    }
    }
  //Accelerometer x
    if (acc_x != null) {
  if (acc_x is List) {
    acc_x_r = List<double>.from(acc_x.cast<num>().map((e) => e.toDouble()).toList());
  } else if (acc_x is double) {
    acc_x_r.add(acc_x);
  } else if (acc_x is int) {
    acc_x_r.add(acc_x.toDouble());
  }
}
    // Accelerometer y
    if (acc_y != null) {
    if (acc_y is List) {
      acc_y_r = List<double>.from(acc_y.cast<num>().map((e) => e.toDouble()).toList());
    } else if (acc_y is double) {
      acc_y_r.add(acc_y);
    }else if(acc_y is int)
    {
      acc_y_r.add(acc_y.toDouble());
    }
    }
    //Accelerometer z
    if (acc_z != null) {
    if (acc_z is List) {
      acc_z_r = List<double>.from(acc_z.cast<num>().map((e) => e.toDouble()).toList());
    } else if (acc_z is double) {
      acc_z_r.add(acc_z.toDouble());
    }else if(acc_z is int)
    {
      acc_z_r.add(acc_z.toDouble());
    }
    }
    //time
    if (time_rr != null) {
    if (time_rr is List) {
      time_r = List<double>.from(time_rr.cast<num>().map((e) => e.toDouble()).toList());
    } else if (time_rr is double) {
      time_r.add(time_rr.toDouble());
    }else if(time_rr is int)
    {
      time_r.add(time_rr.toDouble());
    }
    }
    //time acc
    if (time_rr_a != null) {
    if (time_rr_a is List) {
      time_r_a = List<double>.from(time_rr_a.cast<num>().map((e) => e.toDouble()).toList());
    } else if (time_rr_a is double) {
      time_r_a.add(time_rr_a.toDouble());
    } else if(time_rr_a is int)
    {
      time_r_a.add(time_rr_a.toDouble());
    }
  }
polilines={};
  poli=[];
  for (int i = 0; i < lati_read.length && i < longi_read.length; i++) {
    polilines.add(Polyline(
      points: [
        LatLng(lati_read[i], longi_read[i]),

      ],
      color: Colors.blue, 
      width: 3, 
      polylineId: PolylineId('Polilines${polilines.length+1}')
    ));
  poli.add(LatLng(lati_read[i],longi_read[i] ));
  }
   for(int i = 0 ; i<gyro_z_r.length;i++)
   {
    gyroscopeData.add(ChartData(time_r[i],gyro_x_r[i],gyro_y_r[i],gyro_y_r[i]));
   }
   for(int i = 0; i<acc_z_r.length && i<acc_x_r.length && i<acc_y_r.length;i++)
   {
    accData.add(ChartData_acc(time_r_a[i],acc_x_r[i],acc_y_r[i],acc_z_r[i]));
   }
}