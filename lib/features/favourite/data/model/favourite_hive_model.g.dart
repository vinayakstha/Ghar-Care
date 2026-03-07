// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favourite_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavouriteHiveModelAdapter extends TypeAdapter<FavouriteHiveModel> {
  @override
  final int typeId = 4;

  @override
  FavouriteHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavouriteHiveModel(
      favouriteId: fields[0] as String?,
      userId: fields[1] as String,
      serviceId: fields[2] as String,
      serviceName: fields[3] as String,
      serviceImage: fields[4] as String,
      serviceDescription: fields[5] as String,
      serviceCategoryId: fields[6] as String,
      servicePrice: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FavouriteHiveModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.favouriteId)
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
      ..write(obj.servicePrice);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavouriteHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
