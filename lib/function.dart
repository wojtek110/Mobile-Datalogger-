
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:projekt1/data.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';
import 'gloabls.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tuple/tuple.dart';
import 'main.dart';

void changeName()
{
  istracking=!istracking;
  isvisible=!isvisible;
  flag++;
  if(flag==1)
  {
    nazwa="Stop";
  }
  if(flag==2)
  {
    nazwa="Start";
    flag=0;
  }
}

Future <void> checkPermission() async
{
var status = Permission.location.request();
  if(status ==  PermissionStatus.denied)
    {
      print("uprawnienia nie są przyznane");
      status =  Permission.location.request();
    }
  if(status == PermissionStatus.granted) 
    {
      print("uprawnienia są przyznane");
    } 
  if (status == PermissionStatus.permanentlyDenied) 
    {
      print("uprawnienia są pernamentnie zablokoawne");
      openAppSettings();
    }
}
void showProgressDialog(BuildContext context) {
  if(isLoading)
  {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: const [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Pobieranie danych..."),
            ],
          ),
        );
      },
    );
  }
  else
  {
    Navigator.of(context).pop();
  }
}
void showSendDialog(BuildContext context) {
  if(send_flag)
  {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: const [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Wysyłam do bazy danych..."),
            ],
          ),
        );
      },
    );
  }
  else
  {
    Navigator.of(context).pop();
  }
}

Tuple2<List<double>,List<double>> convert_GPS()
{
List<double> polix=[];
List<double> poliy=[];
  for(int i =0;i<poli.length;i++)
  {
    polix.add(poli[i].latitude);
    poliy.add(poli[i].longitude);
  }
  return Tuple2(polix,poliy);
}
Tuple3<List<double>,List<double>,List<double>> convert_accelerometr()
{
List<double> x=[];
List<double> y=[];
List<double> z=[];
  for(int i =0;i<accData.length;i++)
  {
    x.add(accData[i].x.toDouble());
    y.add(accData[i].y.toDouble());
    z.add(accData[i].z.toDouble());
  }
  return Tuple3(x,y,z);
}
Tuple2<List<double>,List<double>> convert_time()
{
  List<double>time_acc=[];
  List<double>time_gyro=[];
  for(int i=0;i<gyroscopeData.length;i++)
  {
    time_gyro.add(gyroscopeData[i].time.toDouble());
  }
   for(int i=0;i<accData.length;i++)
  {
    time_acc.add(accData[i].time.toDouble());
  }
  return Tuple2(time_acc,time_gyro);
}
Tuple3<List<double>,List<double>,List<double>> convert_gyroscope()
{
List<double> x=[];
List<double> y=[];
List<double> z=[];
  for(int i =0;i<gyroscopeData.length;i++)
  {
    x.add(gyroscopeData[i].x.toDouble());
    y.add(gyroscopeData[i].y.toDouble());
    z.add(gyroscopeData[i].z.toDouble());
  }
  return Tuple3(x,y,z);
}
void convert_measurement()
{
Tuple2<List<double>,List<double>> gps_result=convert_GPS();
 cord_lati=gps_result.item1;
 cord_long=gps_result.item2;

Tuple3<List<double>,List<double>,List<double>> acc_result=convert_accelerometr();
 x_acc=acc_result.item1;
 y_acc=acc_result.item2;
 z_acc=acc_result.item3;

Tuple3<List<double>,List<double>,List<double>> gyro_result=convert_gyroscope();
 x_gyro=gyro_result.item1;
 y_gyro=gyro_result.item2;
 z_gyro=gyro_result.item3;
Tuple2<List<double>, List<double>> time_all=convert_time();
time_a_acc=time_all.item1;
time_a_gyro=time_all.item2;

for (int i = 0; i < cord_long.length; i++) {
  latLngList.add([cord_lati[i], cord_long[i]]);
  }
}
void save_local(String not) async
{
  box = await Hive.openBox('myBox');
  Map<String, dynamic> notatki = {
    'gyroscopeData': gyroscopeData,
    'accData': accData,
    'poli': poli,
  };
  box.put(not, notatki);
}