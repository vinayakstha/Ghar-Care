import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ghar_care/core/error/failures.dart';
import 'package:ghar_care/features/auth/domain/repositories/auth_repository.dart';
import 'package:ghar_care/features/auth/domain/usecases/upload_image_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late UploadImageUsecase usecase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = UploadImageUsecase(repository: mockRepository);
  });

  final tFile = File('test/assets/test_image.png');
  const tFileName = 'uploaded_image.png';

  test('should return file name when upload is successful', () async {
    // Arrange
    when(
      () => mockRepository.uploadImage(tFile),
    ).thenAnswer((_) async => const Right(tFileName));

    // Act
    final result = await usecase(tFile);

    // Assert
    expect(result, const Right(tFileName));
    verify(() => mockRepository.uploadImage(tFile)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return failure when upload fails', () async {
    // Arrange
    const failure = ApiFailure(message: 'Upload failed');
    when(
      () => mockRepository.uploadImage(tFile),
    ).thenAnswer((_) async => const Left(failure));

    // Act
    final result = await usecase(tFile);

    // Assert
    expect(result, const Left(failure));
    verify(() => mockRepository.uploadImage(tFile)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return NetworkFailure when there is no internet', () async {
    // Arrange
    const failure = NetworkFailure();
    when(
      () => mockRepository.uploadImage(tFile),
    ).thenAnswer((_) async => const Left(failure));

    // Act
    final result = await usecase(tFile);

    // Assert
    expect(result, const Left(failure));
    verify(() => mockRepository.uploadImage(tFile)).called(1);
  });
}
