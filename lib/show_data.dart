
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:projekt1/read.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator_platform_interface/src/models/position.dart' as GeoPosition;
import 'package:projekt1/send.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'gloabls.dart';
import 'function.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:projekt1/firebase_options.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'main.dart';
import 'package:projekt1/read_database.dart';
class ShowData extends StatefulWidget {
  @override

  ShowDataState createState() => ShowDataState();
}

class ShowDataState extends State<ShowData> {
  @override
  void update_poli() async
{
  Polyline polyline = Polyline(
      polylineId: PolylineId('tracking'),
      color: Colors.blue,
      points: poli,
      width: 5,);

      setState(() {
      polilines.add(polyline);

    });
}
  late GoogleMapController mapController;
    void initState() 
 {
    super.initState();
    checkPermission();
    //print_data();
    setState(() {
    update_poli();
    });
}
    Widget build(BuildContext context) {
    return Container(
      child:  Stack(children: [
        GoogleMap(
          onMapCreated: (controller){
              mapController = controller;
          },
          polylines: polilines,
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(target: LatLng(poli[0].latitude,poli[0].longitude), zoom: 15),
        ),
        Align(alignment: AlignmentDirectional.bottomStart,
        child:SizedBox( 
        height: 100,
        width: 100,
        child:FittedBox(
        )
        )
        ),
        // FittedBox(
        //   alignment: AlignmentDirectional.topCenter,
        //   child: Text("Acelerometer: x- $a_x, y- $a_y, z- $a_z \n Gyroscope: x- $g_x, y- $g_y, z-$g_z \n GPS: Latitude- $lati, Longitude- $longi"),
        // ),
        SlidingUpPanel(
        panel:
        Stack(
          children: [
        
        Positioned(child: 
        Text("Żyroskop",style:TextStyle(fontWeight: FontWeight.bold, fontSize: 26) ,),
        top: 20,
        ),
        Positioned(child:
        Text("Składowa X:", style: TextStyle(fontSize: 20)),
        top: 60
        ),
        Positioned(
          top: 80,
          child:
         Container(
          height: 130,
          child: SfCartesianChart(
        margin: EdgeInsets.all(15),
        primaryXAxis: CategoryAxis(
        title: AxisTitle(text: 't(s)'), 
        ),
        primaryYAxis: NumericAxis(
        title: AxisTitle(text: '(rad/s)'), 
        ),
        series: <LineSeries<ChartData, double>>[
          LineSeries<ChartData, double>(
            dataSource: gyroscopeData,
            xValueMapper: (ChartData data, _) => data.time,
            yValueMapper: (ChartData data, _) => data.x,
          ),
        ],
      ),
        ),
        ),
        Positioned(child:
        Text("Składowa Y:", style: TextStyle(fontSize: 20)),
        top: 190
        ),
Positioned(
          top: 210,
          child:
         Container(
          height: 130,
          child: SfCartesianChart(
        margin: EdgeInsets.all(15),
        primaryXAxis: CategoryAxis(
        title: AxisTitle(text: 't(s)'), 
        ),
        primaryYAxis: NumericAxis(
        title: AxisTitle(text: '(rad/s)'),
        ),
        series: <LineSeries<ChartData, double>>[
          LineSeries<ChartData, double>(
            dataSource: gyroscopeData,
            xValueMapper: (ChartData data, _) => data.time,
            yValueMapper: (ChartData data, _) => data.y,
          ),
        ],
      ),
        ),
        ),
        Positioned(child:
        Text("Składowa Z:", style: TextStyle(fontSize: 20)),
        top: 320
        ),
Positioned(
          top: 340,
          child:
         Container(
          height: 130,
          child: SfCartesianChart(
        margin: EdgeInsets.all(15),
        primaryXAxis: CategoryAxis(
        title: AxisTitle(text: 't(s)'),
        ),
        primaryYAxis: NumericAxis(
        title: AxisTitle(text: '(rad/s)'), 
        ),
        series: <LineSeries<ChartData, double>>[
          LineSeries<ChartData, double>(
            dataSource: gyroscopeData,
            xValueMapper: (ChartData data, _) => data.time,
            yValueMapper: (ChartData data, _) => data.z,
          ),
        ],
      ),
        ),
        ),
        Positioned(child: 
        Text("Akcelerometr",style:TextStyle(fontWeight: FontWeight.bold, fontSize: 26) ,),
        top: 440,
        ),
        
        Positioned(child:
        Text("Składowa X:", style: TextStyle(fontSize: 20)),
        top: 470
        ),
  Positioned(
          top: 490,
          child:
         Container(
          height: 130,
          child: SfCartesianChart(
        margin: EdgeInsets.all(15),
        primaryXAxis: CategoryAxis(
        title: AxisTitle(text: 't(s)'),
        ),
        primaryYAxis: NumericAxis(
        title: AxisTitle(text: '(m/s^2)'), 
        ),
        series: <LineSeries<ChartData_acc, double>>[
          LineSeries<ChartData_acc, double>(
            dataSource: accData,
            xValueMapper: (ChartData_acc data, _) => data.time,
            yValueMapper: (ChartData_acc data, _) => data.x,
          ),
        ],
      ),
        ),
        ),
        Positioned(child:
        Text("Składowa y:", style: TextStyle(fontSize: 20)),
        top: 580
        ),
  Positioned(
          top: 600,
          child:
         Container(
          height: 130,
          child: SfCartesianChart(
        margin: EdgeInsets.all(15),
  primaryXAxis: CategoryAxis(
        title: AxisTitle(text: 't(s)'),
        ),
        primaryYAxis: NumericAxis(
        title: AxisTitle(text: '(m/s^2)'), 
        ),
        series: <LineSeries<ChartData_acc, double>>[
          LineSeries<ChartData_acc, double>(
            dataSource: accData,
            xValueMapper: (ChartData_acc data, _) => data.time,
            yValueMapper: (ChartData_acc data, _) => data.y,
          ),
        ],
      ),
        ),
        ),
        Positioned(child:
        Text("Składowa Z:", style: TextStyle(fontSize: 20)),
        top: 690
        ),
  Positioned(
          top: 705,
          child:
         Container(
          height: 130,
          child: SfCartesianChart(
        margin: EdgeInsets.all(15),
  primaryXAxis: CategoryAxis(
        title: AxisTitle(text: 't(s)'), 
        ),
        primaryYAxis: NumericAxis(
        title: AxisTitle(text: '(m/s^2)'), 
        ),
        series: <LineSeries<ChartData_acc, double>>[
          LineSeries<ChartData_acc, double>(
            dataSource: accData,
            xValueMapper: (ChartData_acc data, _) => data.time,
            yValueMapper: (ChartData_acc data, _) => data.z,
          ),
        ],
      ),
        ),
        ),
          ]
        ),
        maxHeight: 1000,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        
        )
        ]
        ),
    );
  }
}
void print_data()
{
  for(int i = 0; i<gyroscopeData.length;i++)
  {
    // print("gyro x: ${gyroscopeData[i].x}");
    // print("gyro y: ${gyroscopeData[i].y}");
    // print("gyro z: ${gyroscopeData[i].z}");
    // print("gyro time: ${gyroscopeData[i].time}");
    print("gyro: ${gyroscopeData[i]}");
  }
  for(int i = 0; i<accData.length;i++)
  {
    print("acc: ${accData[i]}");
    // print("acc x: ${accData[i].x}");
    // print("acc y: ${accData[i].y}");
    // print("acc z: ${accData[i].z}");
    // print("acc time: ${accData[i].time}");
  }
}
