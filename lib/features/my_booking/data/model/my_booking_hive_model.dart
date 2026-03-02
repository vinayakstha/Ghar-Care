import 'package:ghar_care/core/constants/hive_table_constant.dart';
import 'package:ghar_care/features/my_booking/data/model/my_booking_api_model.dart';
import 'package:ghar_care/features/my_booking/domain/entities/my_booking_entity.dart';
import 'package:ghar_care/features/service/domain/entities/service_entity.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'my_booking_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.myBookingTypeId)
class MyBookingHiveModel extends HiveObject {
  @HiveField(0)
  final String bookingId;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String serviceId;

  @HiveField(3)
  final String serviceName;

  @HiveField(4)
  final String serviceImage;

  @HiveField(5)
  final String serviceDescription;

  @HiveField(6)
  final String serviceCategoryId;

  @HiveField(7)
  final String bookingDate;

  @HiveField(8)
  final String bookingTime;

  @HiveField(9)
  final String price;

  @HiveField(10)
  final String location;

  @HiveField(11)
  final String? status;

  MyBookingHiveModel({
    String? bookingId,
    required this.userId,
    required this.serviceId,
    required this.serviceName,
    required this.serviceImage,
    required this.serviceDescription,
    required this.serviceCategoryId,
    required this.bookingDate,
    required this.bookingTime,
    required this.price,
    required this.location,
    this.status,
  }) : bookingId = bookingId ?? const Uuid().v4();

  /// Hive model -> Entity
  MyBookingEntity toEntity() {
    return MyBookingEntity(
      bookingId: bookingId,
      userId: userId,
      service: ServiceEntity(
        serviceId: serviceId,
        serviceName: serviceName,
        serviceImage: serviceImage,
        serviceDescription: serviceDescription,
        categoryId: serviceCategoryId,
        price: price,
      ),
      bookingDate: bookingDate,
      bookingTime: bookingTime,
      price: price,
      location: location,
      status: status,
    );
  }

  /// Entity -> Hive model
  factory MyBookingHiveModel.fromEntity(MyBookingEntity entity) {
    return MyBookingHiveModel(
      bookingId: entity.bookingId,
      userId: entity.userId,
      serviceId: entity.service.serviceId ?? '',
      serviceName: entity.service.serviceName,
      serviceImage: entity.service.serviceImage,
      serviceDescription: entity.service.serviceDescription,
      serviceCategoryId: entity.service.categoryId,
      bookingDate: entity.bookingDate,
      bookingTime: entity.bookingTime,
      price: entity.price,
      location: entity.location,
      status: entity.status,
    );
  }

  static List<MyBookingEntity> toEntityList(List<MyBookingHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }

  /// API model -> Hive model
  factory MyBookingHiveModel.fromApiModel(MyBookingApiModel apiModel) {
    return MyBookingHiveModel(
      bookingId: apiModel.bookingId,
      userId: apiModel.userId,
      serviceId: apiModel.serviceId.id ?? '',
      serviceName: apiModel.serviceId.serviceName,
      serviceImage: apiModel.serviceId.serviceImage,
      serviceDescription: apiModel.serviceId.serviceDescription,
      serviceCategoryId: apiModel.serviceId.categoryId,
      bookingDate: apiModel.bookingDate,
      bookingTime: apiModel.bookingTime,
      price: apiModel.price,
      location: apiModel.location,
      status: apiModel.status,
    );
  }

  static List<MyBookingHiveModel> fromApiModelList(
    List<MyBookingApiModel> apiModels,
  ) {
    return apiModels
        .map((model) => MyBookingHiveModel.fromApiModel(model))
        .toList();
  }
}
