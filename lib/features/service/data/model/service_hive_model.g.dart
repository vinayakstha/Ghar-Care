// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ServiceHiveModelAdapter extends TypeAdapter<ServiceHiveModel> {
  @override
  final int typeId = 2;

  @override
  ServiceHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ServiceHiveModel(
      serviceId: fields[0] as String?,
      serviceName: fields[1] as String,
      serviceImage: fields[2] as String,
      serviceDescription: fields[3] as String,
      categoyId: fields[4] as String,
      price: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ServiceHiveModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.serviceId)
      ..writeByte(1)
      ..write(obj.serviceName)
      ..writeByte(2)
      ..write(obj.serviceImage)
      ..writeByte(3)
      ..write(obj.serviceDescription)
      ..writeByte(4)
      ..write(obj.categoyId)
      ..writeByte(5)
      ..write(obj.price);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
