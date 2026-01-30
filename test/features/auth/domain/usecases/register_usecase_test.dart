import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ghar_care/core/error/failures.dart';
import 'package:ghar_care/features/auth/domain/entities/auth_entity.dart';
import 'package:ghar_care/features/auth/domain/repositories/auth_repository.dart';
import 'package:ghar_care/features/auth/domain/usecases/register_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late RegisterUsecase usecase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = RegisterUsecase(authRepository: mockRepository);
  });

  setUpAll(() {
    registerFallbackValue(
      const AuthEntity(
        firstName: "test",
        lastName: 'test',
        username: 'testuser',
        email: 'test@gmail.com',
        phoneNumber: '9999999999',
        password: 'password123',
      ),
    );
  });

  const tFirstName = 'Test';
  const tLastName = 'Test';
  const tEmail = 'test@example.com';
  const tUsername = 'testuser';
  const tPassword = 'password123';
  const tPhoneNumber = '1234567890';
  const tConfirmPassword = 'password123';

  group('RegisterUsecase', () {
    test('should return true when registration is successful', () async {
      //arrange
      when(
        () => mockRepository.register(any()),
      ).thenAnswer((_) async => const Right(true));

      //act
      final result = await usecase(
        const RegisterUsecaseParams(
          firstName: tFirstName,
          lastName: tLastName,
          username: tUsername,
          email: tEmail,
          phoneNumber: tPhoneNumber,
          password: tPassword,
          confirmPassword: tConfirmPassword,
        ),
      );

      //assert
      expect(result, const Right(true));
      verify(() => mockRepository.register(any())).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should pass AuthEntity with correct values to repository', () async {
      // Arrange
      AuthEntity? capturedEntity;
      when(() => mockRepository.register(any())).thenAnswer((invocation) {
        capturedEntity = invocation.positionalArguments[0] as AuthEntity;
        return Future.value(const Right(true));
      });

      // Act
      await usecase(
        const RegisterUsecaseParams(
          firstName: tFirstName,
          lastName: tLastName,
          email: tEmail,
          username: tUsername,
          password: tPassword,
          confirmPassword: tConfirmPassword,
          phoneNumber: tPhoneNumber,
        ),
      );

      // Assert
      expect(capturedEntity?.firstName, tFirstName);
      expect(capturedEntity?.lastName, tLastName);
      expect(capturedEntity?.email, tEmail);
      expect(capturedEntity?.username, tUsername);
      expect(capturedEntity?.password, tPassword);
      expect(capturedEntity?.confirmPassword, tConfirmPassword);
      expect(capturedEntity?.phoneNumber, tPhoneNumber);
    });

    test('should return failure when registration fails', () async {
      // Arrange
      const failure = ApiFailure(message: 'Email already exists');
      when(
        () => mockRepository.register(any()),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(
        const RegisterUsecaseParams(
          firstName: tFirstName,
          lastName: tLastName,
          email: tEmail,
          username: tUsername,
          password: tPassword,
          confirmPassword: tConfirmPassword,
          phoneNumber: tPhoneNumber,
        ),
      );

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.register(any())).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return NetworkFailure when there is no internet', () async {
      // Arrange
      const failure = NetworkFailure();
      when(
        () => mockRepository.register(any()),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(
        const RegisterUsecaseParams(
          firstName: tFirstName,
          lastName: tLastName,
          email: tEmail,
          username: tUsername,
          password: tPassword,
          confirmPassword: tConfirmPassword,
          phoneNumber: tPhoneNumber,
        ),
      );

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.register(any())).called(1);
    });
  });

  group('RegisterParams', () {
    test('should have correct props with all values', () {
      // Arrange
      const params = RegisterUsecaseParams(
        firstName: tFirstName,
        lastName: tLastName,
        email: tEmail,
        username: tUsername,
        phoneNumber: tPhoneNumber,
        password: tPassword,
        confirmPassword: tConfirmPassword,
      );

      // Assert
      expect(params.props, [
        tFirstName,
        tLastName,
        tUsername,
        tEmail,
        tPhoneNumber,
        tPassword,
        tConfirmPassword,
      ]);
    });

    test('two params with same values should be equal', () {
      // Arrange
      const params1 = RegisterUsecaseParams(
        firstName: tFirstName,
        lastName: tLastName,
        email: tEmail,
        username: tUsername,
        password: tPassword,
        confirmPassword: tConfirmPassword,
        phoneNumber: tPhoneNumber,
      );
      const params2 = RegisterUsecaseParams(
        firstName: tFirstName,
        lastName: tLastName,
        email: tEmail,
        username: tUsername,
        password: tPassword,
        confirmPassword: tConfirmPassword,
        phoneNumber: tPhoneNumber,
      );

      // Assert
      expect(params1, params2);
    });
  });
}
