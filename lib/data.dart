import 'package:hive/hive.dart';
import 'main.dart'; // Importuj klasę ChartData
import 'package:google_maps_flutter/google_maps_flutter.dart'; // Importuj klasę LatLng

class ChartDataAdapter extends TypeAdapter<ChartData> {
  @override
  final int typeId = 0; // Unikalne ID adaptera

  @override
  ChartData read(BinaryReader reader) {
    final time = reader.readDouble();
    final x = reader.readDouble();
    final y = reader.readDouble();
    final z = reader.readDouble();
    return ChartData(time, x, y, z);
  }

  @override
  void write(BinaryWriter writer, ChartData obj) {
    writer.writeDouble(obj.time);
    writer.writeDouble(obj.x);
    writer.writeDouble(obj.y);
    writer.writeDouble(obj.z);
  }
}

class ChartDataAccAdapter extends TypeAdapter<ChartData_acc> {
  @override
  final int typeId = 1; // Unikalne ID adaptera

  @override
  ChartData_acc read(BinaryReader reader) {
    final time = reader.readDouble();
    final x = reader.readDouble();
    final y = reader.readDouble();
    final z = reader.readDouble();
    return ChartData_acc(time, x, y, z);
  }

  @override
  void write(BinaryWriter writer, ChartData_acc obj) {
    writer.writeDouble(obj.time);
    writer.writeDouble(obj.x);
    writer.writeDouble(obj.y);
    writer.writeDouble(obj.z);
  }
}

class LatLngAdapter extends TypeAdapter<LatLng> {
  @override
  final int typeId = 2; // Unikalne ID adaptera

  @override
  LatLng read(BinaryReader reader) {
    final lat = reader.readDouble();
    final lng = reader.readDouble();
    return LatLng(lat, lng);
  }

  @override
  void write(BinaryWriter writer, LatLng obj) {
    writer.writeDouble(obj.latitude);
    writer.writeDouble(obj.longitude);
  }
}
void registerHiveAdapters() {
  Hive.registerAdapter(ChartDataAdapter());
  Hive.registerAdapter(ChartDataAccAdapter());
  Hive.registerAdapter(LatLngAdapter());
}
