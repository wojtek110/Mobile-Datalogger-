import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:projekt1/function.dart';
import 'package:projekt1/gloabls.dart';
import 'main.dart';
import 'package:projekt1/show_data.dart';

class ReadLocal extends StatefulWidget {
  @override
  
  _ReadLocalState createState() => _ReadLocalState();
}

class _ReadLocalState extends State<ReadLocal> {

  @override
  void initState(){
  super.initState();
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Odczyt lokalnie'),
    ),
    body: Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final key = box.keyAt(index);
              final value = box.getAt(index);

              return ListTile(
                title: Text(key.toString()),
                onTap: () async{
                  print("key: $key");
                  await get_mesurment_local(key.toString());
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ShowData()));
                },
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    box.delete(key);
                    setState(() {});
                  },
                ),
              );
            },
          ),
        ),
      ],
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () async {
        setState(() async{
          await syn_database();
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context)=>ReadLocal()));
          
        });

      },
      child: Icon(Icons.download),
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
  );
}
  @override
  void dispose() {
    super.dispose();
  }
}

Future<void> syn_database() async
{
final ref = FirebaseDatabase.instance.ref('');
final snapshot = await ref.orderByPriority().get();
final List<String> keys = [];
if (snapshot.value != null && snapshot.value is Map<dynamic, dynamic>) {
  (snapshot.value as Map<dynamic, dynamic>).forEach((key, value) {
    keys.add(key.toString());
  });
}
for(int i=0;i<keys.length;i++)
{
  gyroscopeData = [];
  accData = [];
  poli = [];
  polilines = {};
  get_mesurment_to_sync(snapshot, keys[i]);
  save_local("'$opis : $date'");
}
}


Future<void> get_mesurment_local(dynamic key) async {
  gyroscopeData = [];
  accData = [];
  poli = [];
  polilines = {};
List<double> xList_gyro = [];
List<double> yList_gyro=[];
List<double> zList_gyro=[];
List<double> timeList_gyro=[];

List<double> xList_acc=[];
List<double> yList_acc=[];
List<double> zList_acc=[];
List<double> timeList_acc=[];

List<double> lati_l=[];
List<double> longi_l=[];
  box = await Hive.openBox('myBox');
  Map<dynamic, dynamic>? notatki = box.get(key);
if (notatki != null) {
  // Gyroscope x
  if (notatki.containsKey('gyroscopeData')) {
    List<dynamic>? gyroscopeDataList = notatki['gyroscopeData'];
    if (gyroscopeDataList != null && gyroscopeDataList.isNotEmpty) {
      gyroscopeDataList.forEach((element) {
        if (element is ChartData && element.x != null) {
          xList_gyro.add(element.x);
        }
      });
    } 
  }
  // Gyroscope y
  if (notatki.containsKey('gyroscopeData')) {
    List<dynamic>? gyroscopeDataList = notatki['gyroscopeData'];
    if (gyroscopeDataList != null && gyroscopeDataList.isNotEmpty) {
      gyroscopeDataList.forEach((element) {
        if (element is ChartData && element.y != null) {
          yList_gyro.add(element.y);
        }
      });
    } 
  }
  // Gyroscope z
  if (notatki.containsKey('gyroscopeData')) {
    List<dynamic>? gyroscopeDataList = notatki['gyroscopeData'];
    if (gyroscopeDataList != null && gyroscopeDataList.isNotEmpty) {
      gyroscopeDataList.forEach((element) {
        if (element is ChartData && element.z != null) {
          zList_gyro.add(element.z);
        }
      });
    } 
  }
    // Gyroscope time
  if (notatki.containsKey('gyroscopeData')) {
    List<dynamic>? gyroscopeDataList = notatki['gyroscopeData'];
    if (gyroscopeDataList != null && gyroscopeDataList.isNotEmpty) {
      gyroscopeDataList.forEach((element) {
        if (element is ChartData && element.time != null) {
          timeList_gyro.add(element.time);
        }
      });
    } 
  }
      // acc x
  if (notatki.containsKey('accData')) {
    List<dynamic>? accDataList = notatki['accData'];
    if (accDataList != null && accDataList.isNotEmpty) {
      accDataList.forEach((element) {
        if (element is ChartData_acc && element.x != null) {
          xList_acc.add(element.x);
        }
      });
    } 
  }
        // acc y
  if (notatki.containsKey('accData')) {
    List<dynamic>? accDataList = notatki['accData'];
    if (accDataList != null && accDataList.isNotEmpty) {
      accDataList.forEach((element) {
        if (element is ChartData_acc && element.y != null) {
          yList_acc.add(element.y);
        }
      });
    } 
  }
        // acc z
  if (notatki.containsKey('accData')) {
    List<dynamic>? accDataList = notatki['accData'];
    if (accDataList != null && accDataList.isNotEmpty) {
      accDataList.forEach((element) {
        if (element is ChartData_acc && element.z != null) {
          zList_acc.add(element.z);
        }
      });
    } 
  }
        // acc time
  if (notatki.containsKey('accData')) {
    List<dynamic>? accDataList = notatki['accData'];
    if (accDataList != null && accDataList.isNotEmpty) {
      accDataList.forEach((element) {
        if (element is ChartData_acc && element.time != null) {
          timeList_acc.add(element.time);
        }
      });
    } 
  }
        // poli lati
  if (notatki.containsKey('poli')) {
    List<dynamic>? poliData = notatki['poli'];
    if (poliData != null && poliData.isNotEmpty) {
      poliData.forEach((element) {
        if (element is LatLng && element.latitude != null) {
          lati_l.add(element.latitude);
        }
      });
    } 
  }
   if (notatki.containsKey('poli')) {
    List<dynamic>? poliData = notatki['poli'];
    if (poliData != null && poliData.isNotEmpty) {
      poliData.forEach((element) {
        if (element is LatLng && element.longitude != null) {
          longi_l.add(element.longitude);
        }
      });
    } 
  }

   for(int i = 0 ; i<xList_gyro.length;i++)
   {
    gyroscopeData.add(ChartData(timeList_gyro[i],xList_gyro[i],yList_gyro[i],zList_gyro[i]));
   }
   for(int i = 0; i<xList_acc.length;i++)
   {
    accData.add(ChartData_acc(timeList_acc[i],xList_acc[i],yList_acc[i],zList_acc[i]));
   }
   print("poli lati: ${lati_l}\n");
   print("poli lati: ${longi_l}\n");
     for (int i = 0; i < lati_l.length && i < longi_l.length; i++) {
    polilines.add(Polyline(
      points: [
        LatLng(lati_l[i], longi_l[i]),

      ],
      color: Colors.blue, 
      width: 3, 
      polylineId: PolylineId('Polilines${polilines.length+1}')
    ));
  poli.add(LatLng(lati_l[i],longi_l[i] ));
  }
} 
}

Future <void> get_mesurment_to_sync(DataSnapshot snapshot,String child) async {
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
  var latitudeData = snapshot.child('${child}/GPS/latitude').value;
  var longitudeData= snapshot.child('${child}/GPS/longitude').value;
  var gyro_x=snapshot.child('${child}/Gyroscope/x').value;
  var gyro_y=snapshot.child('${child}/Gyroscope/y').value;
  var gyro_z=snapshot.child('${child}/Gyroscope/z').value;
  var acc_x=snapshot.child('${child}/Accelerometer/x').value;
  var acc_y=snapshot.child('${child}/Accelerometer/y').value;
  var acc_z=snapshot.child('${child}/Accelerometer/z').value;
  var time_rr=snapshot.child('${child}/Gyroscope/time').value;
  var time_rr_a=snapshot.child('${child}/Accelerometer/time').value;
opis=snapshot.child('${child}/name/Opis').value.toString();
date=snapshot.child('${child}/name/Data').value.toString();
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