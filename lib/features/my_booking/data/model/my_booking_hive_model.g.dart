// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_booking_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MyBookingHiveModelAdapter extends TypeAdapter<MyBookingHiveModel> {
  @override
  final int typeId = 3;

  @override
  MyBookingHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MyBookingHiveModel(
      bookingId: fields[0] as String?,
      userId: fields[1] as String,
      serviceId: fields[2] as String,
      serviceName: fields[3] as String,
      serviceImage: fields[4] as String,
      serviceDescription: fields[5] as String,
      serviceCategoryId: fields[6] as String,
      bookingDate: fields[7] as String,
      bookingTime: fields[8] as String,
      price: fields[9] as String,
      location: fields[10] as String,
      status: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MyBookingHiveModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.bookingId)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.serviceId)
      ..writeByte(3)
      ..write(obj.serviceName)
      ..writeByte(4)
      ..write(obj.serviceImage)
      ..writeByte(5)
      ..write(obj.serviceDescription)
      ..writeByte(6)
      ..write(obj.serviceCategoryId)
      ..writeByte(7)
      ..write(obj.bookingDate)
      ..writeByte(8)
      ..write(obj.bookingTime)
      ..writeByte(9)
      ..write(obj.price)
      ..writeByte(10)
      ..write(obj.location)
      ..writeByte(11)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MyBookingHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
