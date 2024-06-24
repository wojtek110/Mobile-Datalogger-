
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
import 'package:projekt1/data.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(ChartDataAdapter());
  Hive.registerAdapter(ChartDataAccAdapter());
  Hive.registerAdapter(LatLngAdapter());
  box = await Hive.openBox('myBox');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<StatefulWidget> createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
late GoogleMapController mapController;

final List<Widget> _pages = [
    MyStatefulWidget(),
    Send(),
    read(),
  ];
 int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: 
      GNav(
        backgroundColor: Colors.black,
        color: Colors.white,
        activeColor: Colors.white,
        tabs: 
        [
          GButton(icon: Icons.home,
          text: "Datalogger",
          ),
          GButton(icon: Icons.save,
          text: "Zapis",
          ),
          GButton(icon: Icons.read_more,
          text: "Odczyt",
          ),
        ],
        selectedIndex: _selectedIndex,
        onTabChange: (index) {
          setState(() {
            _selectedIndex = index;
         });
        },
      ),
      body: _pages[_selectedIndex],
    );
  }
}
late List<ChartData> gyroscopeData;
late List<ChartData_acc> accData;
class MyStatefulWidget extends StatefulWidget {
  @override

  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
late GoogleMapController mapController;
StreamSubscription<GeoPosition.Position>? positionStreamSubscription;


  void initState() 
 {
    super.initState();
    checkPermission();
    accData=[];
    gyroscopeData = [];
    setState(() {
      polilines = {};
      poli=[];
    });

}
Completer<GoogleMapController> _controller = Completer();
void add_polilines(){
  setState(() {
  polilines.add(
    Polyline(polylineId: PolylineId('Polilines${polilines.length+1}'),
    color: Colors.blue,
    points: [LatLng(lati, longi)]
    ),
  );
});
}
void start_tracking() async
{
  if(istracking==false)
  {
    positionStreamSubscription?.cancel(); 
    positionStreamSubscription=null;
  }
  else
  {
  positionStreamSubscription=Geolocator.getPositionStream().listen((GeoPosition.Position position) {
      setState(() {
        LatLng newLatLng = LatLng(position.latitude, position.longitude);
        poli.add(newLatLng);
        print("coordinates: $poli");
        mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(position.latitude,position.longitude),zoom: 15)));
        print("latlng: $newLatLng");
        update_poli();
      });
    });
  }
}

void start_accelerometer()
{
  if(istracking==false)
  {
    accelerometerSubscription?.cancel();
    accelerometerSubscription=null;
    Stopwatch().stop();
  }
  else
  {
    stopwatch.start();
    accelerometerSubscription= accelerometerEvents.listen((AccelerometerEvent event) {
    Accelerometer_data.add(event);
    setState(() {
    int elapsedTimeMilliseconds1 = stopwatch.elapsedMilliseconds;
    accData.add(ChartData_acc(elapsedTimeMilliseconds1/1000, event.x.toDouble(), event.y.toDouble(), event.z.toDouble()));
    });
  });
  }
}
void start_gyroscope()
{
if(istracking==false)
{
    gyroscopeSubscription?.cancel();
    gyroscopeSubscription=null;
    Stopwatch().stop();
}
else
{
    gyroscopeSubscription=gyroscopeEvents.listen((GyroscopeEvent event) { 
    Gyroscope_data.add(event);
    setState(() {
    stopwatch.start();
    int elapsedTimeMilliseconds = stopwatch.elapsedMilliseconds;
    gyroscopeData.add(ChartData(elapsedTimeMilliseconds/1000, event.x.toDouble(), event.y.toDouble(), event.z.toDouble()));
    });
    });
}
}
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
void datalogger() async
{
isLoading=true;
showProgressDialog(context);
GeoPosition.Position position=await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
setState(() {
  lati=position.latitude;
  longi=position.longitude;
  mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(lati, longi),zoom: 15)));
  isLoading=false;
  add_polilines();
  start_tracking();
  start_accelerometer();
  start_gyroscope();
  showProgressDialog(context);
});
isLoading=false;
}

  @override
  Widget build(BuildContext context) {
    return Container(
      child:  Stack(children: [
        GoogleMap(
          onMapCreated: (controller){
              mapController = controller;
          },
          polylines: polilines,
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(target: LatLng(lati, longi), zoom: 15),
        ),
        Align(
          alignment: AlignmentDirectional.topEnd,
          child:  SizedBox(
            height: 100,
            width: 100,
            child:  FittedBox(
              child: ElevatedButton(
                onPressed: () async {
                  setState(() 
                    {
                      changeName();
                      datalogger();
                    });
              ;
          },child: Text('$nazwa'),
          ),

          ),
          ),
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
class ChartData
{
late final double time;
late final double x;
late final double y;
late final double z;
ChartData(this.time, this.x, this.y, this.z);

  static fromJson(item) {}
}
class ChartData_acc
{
  late final double time;
  late final double x; 
  late final double y;
  late final double z; 
  ChartData_acc(this.time, this.x, this.y, this.z);
}