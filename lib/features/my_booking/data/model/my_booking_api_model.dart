// import 'package:ghar_care/features/my_booking/domain/entities/my_booking_entity.dart';
// import 'package:ghar_care/features/service/data/model/service_api_model.dart';
// import 'package:json_annotation/json_annotation.dart';

// part 'my_booking_api_model.g.dart';

// @JsonSerializable()
// class MyBookingApiModel {
//   @JsonKey(name: "_id")
//   final String? bookingId;
//   final String userId;
//   final ServiceApiModel serviceId;
//   final String bookingDate;
//   final String bookingTime;
//   final String price;
//   final String location;
//   final String? status;

//   MyBookingApiModel({
//     this.bookingId,
//     required this.userId,
//     required this.serviceId,
//     required this.bookingDate,
//     required this.bookingTime,
//     required this.price,
//     required this.location,
//     this.status,
//   });

//   /// JSON -> API model
//   factory MyBookingApiModel.fromJson(Map<String, dynamic> json) =>
//       _$MyBookingApiModelFromJson(json);

//   /// API model -> JSON
//   Map<String, dynamic> toJson() => _$MyBookingApiModelToJson(this);

//   /// Convert API model -> Entity
//   MyBookingEntity toEntity() {
//     return MyBookingEntity(
//       bookingId: bookingId,
//       userId: userId,
//       service: serviceId.toEntity(),
//       bookingDate: bookingDate,
//       bookingTime: bookingTime,
//       price: price,
//       location: location,
//       status: status,
//     );
//   }

//   /// Convert list of API models -> list of entities
//   static List<MyBookingEntity> toEntityList(List<MyBookingApiModel> models) {
//     return models.map((model) => model.toEntity()).toList();
//   }
// }
import 'package:ghar_care/features/my_booking/domain/entities/my_booking_entity.dart';
import 'package:ghar_care/features/service/data/model/service_api_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'my_booking_api_model.g.dart';

@JsonSerializable()
class MyBookingApiModel {
  @JsonKey(name: "_id")
  final String? bookingId;
  final String userId;

  // ⚡ Important: use `fromJson` for nested object
  @JsonKey(fromJson: ServiceApiModel.fromJson, toJson: _serviceToJson)
  final ServiceApiModel serviceId;

  final String bookingDate;
  final String bookingTime;
  final String price;
  final String location;
  final String? status;

  MyBookingApiModel({
    this.bookingId,
    required this.userId,
    required this.serviceId,
    required this.bookingDate,
    required this.bookingTime,
    required this.price,
    required this.location,
    this.status,
  });

  /// JSON -> API model
  factory MyBookingApiModel.fromJson(Map<String, dynamic> json) =>
      _$MyBookingApiModelFromJson(json);

  /// API model -> JSON
  Map<String, dynamic> toJson() => _$MyBookingApiModelToJson(this);

  /// Convert API model -> Entity
  MyBookingEntity toEntity() {
    return MyBookingEntity(
      bookingId: bookingId,
      userId: userId,
      service: serviceId.toEntity(),
      bookingDate: bookingDate,
      bookingTime: bookingTime,
      price: price,
      location: location,
      status: status,
    );
  }

  static List<MyBookingEntity> toEntityList(List<MyBookingApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }

  /// Helper to convert ServiceApiModel back to JSON
  static Map<String, dynamic> _serviceToJson(ServiceApiModel service) =>
      service.toJson();
}
