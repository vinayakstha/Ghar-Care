import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghar_care/core/error/failures.dart';
import 'package:ghar_care/core/services/connectivity/network_info.dart';
import 'package:ghar_care/features/payment/data/datasource/payment_datasource.dart';
import 'package:ghar_care/features/payment/data/datasource/remote/payment_remote_datasource.dart';
import 'package:ghar_care/features/payment/domain/entities/payment_entity.dart';
import 'package:ghar_care/features/payment/domain/repository/payment_repository.dart';

final paymentRepositoryProvider = Provider<IPaymentRepository>((ref) {
  return PaymentRepository(
    remoteDataSource: ref.read(paymentRemoteDataSourceProvider),
    networkInfo: ref.read(networkInfoProvider),
  );
});

class PaymentRepository implements IPaymentRepository {
  final IPaymentRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  PaymentRepository({
    required IPaymentRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, PaymentEntity>> initiatePayment(
    String bookingId,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _remoteDataSource.initiatePayment(bookingId);
        if (result == null || result.paymentUrl == null) {
          return Left(ApiFailure(message: "Failed to initiate payment"));
        }
        return Right(result.toEntity());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return Left(ApiFailure(message: "No internet connection"));
    }
  }

  @override
  Future<Either<Failure, bool>> verifyPayment(String pidx) async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _remoteDataSource.verifyPayment(pidx);
        return Right(result['success'] == true);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return Left(ApiFailure(message: "No internet connection"));
    }
  }
}
