import 'package:ghar_care/features/booking/domain/entities/booking_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking_api_model.g.dart';

@JsonSerializable()
class BookingApiModel {
  @JsonKey(name: "_id")
  final String? bookingId;

  @JsonKey(fromJson: _idFromJson)
  final String userId;

  @JsonKey(fromJson: _idFromJson)
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

  // Handles both plain string and nested object
  static String _idFromJson(dynamic value) {
    if (value is String) return value;
    if (value is Map<String, dynamic>) return value['_id'] as String? ?? '';
    return '';
  }

  factory BookingApiModel.fromJson(Map<String, dynamic> json) =>
      _$BookingApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$BookingApiModelToJson(this);

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

  static List<BookingEntity?> toEntityList(List<BookingApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
