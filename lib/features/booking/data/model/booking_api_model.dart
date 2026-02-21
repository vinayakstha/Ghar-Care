import 'package:ghar_care/features/booking/domain/entities/booking_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking_api_model.g.dart';

@JsonSerializable()
class BookingApiModel {
  @JsonKey(name: "_id")
  final String? bookingId;
  final String userId;
  final String serviceId;
  final String bookingDate;
  final String bookingTime;
  final String price;
  final String location;
  final String? status;

  BookingApiModel({
    this.bookingId,
    required this.userId,
    required this.serviceId,
    required this.bookingDate,
    required this.bookingTime,
    required this.price,
    required this.location,
    this.status,
  });

  /// Convert JSON to BookingApiModel
  factory BookingApiModel.fromJson(Map<String, dynamic> json) =>
      _$BookingApiModelFromJson(json);

  /// Convert BookingApiModel to JSON
  Map<String, dynamic> toJson() => _$BookingApiModelToJson(this);

  /// Convert BookingApiModel to Entity
  BookingEntity toEntity() {
    return BookingEntity(
      bookingId: bookingId,
      userId: userId,
      serviceId: serviceId,
      bookingDate: bookingDate,
      bookingTime: bookingTime,
      price: price,
      location: location,
      status: status,
    );
  }

  /// Create API model from Entity
  factory BookingApiModel.fromEntity(BookingEntity entity) {
    return BookingApiModel(
      bookingId: entity.bookingId,
      userId: entity.userId,
      serviceId: entity.serviceId,
      bookingDate: entity.bookingDate,
      bookingTime: entity.bookingTime,
      price: entity.price,
      location: entity.location,
      status: entity.status,
    );
  }

  /// Convert a list of API models to a list of Entities
  static List<BookingEntity?> toEntityList(List<BookingApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
