import 'package:equatable/equatable.dart';
import 'package:ghar_care/features/service/domain/entities/service_entity.dart';

class FavouriteEntity extends Equatable {
  final String? favouriteId;
  final String userId;
  final ServiceEntity service;

  const FavouriteEntity({
    this.favouriteId,
    required this.userId,
    required this.service,
  });

  @override
  List<Object?> get props => [favouriteId, userId, service];
}
