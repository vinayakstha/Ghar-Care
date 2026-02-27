import 'package:dartz/dartz.dart';
import 'package:ghar_care/core/error/failures.dart';
import 'package:ghar_care/features/payment/domain/entities/payment_entity.dart';

abstract interface class IPaymentRepository {
  Future<Either<Failure, PaymentEntity>> initiatePayment(String bookingId);
  Future<Either<Failure, bool>> verifyPayment(String pidx);
}
