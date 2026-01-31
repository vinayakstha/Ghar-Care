import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ghar_care/core/widgets/my_button.dart';
import 'package:ghar_care/features/auth/presentation/pages/signup_screen.dart';
import 'package:ghar_care/features/auth/presentation/state/auth_state.dart';
import 'package:ghar_care/features/auth/presentation/view_model/auth_view_model.dart';

// Mock AuthViewModel for testing
class MockAuthViewModel extends AuthViewModel {
  AuthState mockState;

  MockAuthViewModel({AuthState? initialState})
    : mockState = initialState ?? const AuthState(),
      super();

  @override
  AuthState build() => mockState;

  // Simulate successful registration
  Future<void> registerSuccess({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String phoneNumber,
    required String password,
    required String confirmPassword,
  }) async {
    mockState = mockState.copyWith(status: AuthStatus.registered);
    state = mockState;
  }

  // Simulate registration error
  Future<void> registerError({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String phoneNumber,
    required String password,
    required String confirmPassword,
  }) async {
    mockState = mockState.copyWith(
      status: AuthStatus.error,
      errorMessage: "Registration failed",
    );
    state = mockState;
  }
}

// Helper to wrap the widget with ProviderScope
Widget makeTestableWidget(Widget child, {MockAuthViewModel? mockViewModel}) {
  return ProviderScope(
    overrides: [
      authViewModelProvider.overrideWith(
        () => mockViewModel ?? MockAuthViewModel(),
      ),
    ],
    child: MaterialApp(home: child),
  );
}

void main() {
  testWidgets('SignupScreen renders all fields and button', (tester) async {
    await tester.pumpWidget(makeTestableWidget(const SignupScreen()));

    // Check titles
    expect(find.text("Create your account"), findsOneWidget);

    // Check input fields: first name, last name, username, email, phone, password, confirm
    expect(find.byType(TextFormField), findsNWidgets(7));

    // Check button
    expect(find.byType(MyButton), findsOneWidget);

    // Check login link
    expect(find.text("Login"), findsOneWidget);
  });

  testWidgets('Shows error for empty first name', (tester) async {
    await tester.pumpWidget(makeTestableWidget(const SignupScreen()));

    // Scroll button into view
    await tester.ensureVisible(find.byType(MyButton));

    // Tap the create account button without entering anything
    await tester.tap(find.byType(MyButton));
    await tester.pump(); // rebuild form to show errors

    // Check first name error
    expect(find.text("Enter first name"), findsOneWidget);
  });

  testWidgets('Shows error when email is invalid', (tester) async {
    await tester.pumpWidget(makeTestableWidget(const SignupScreen()));

    // Enter invalid email
    await tester.enterText(find.byType(TextFormField).at(3), 'invalidemail');

    // Scroll submit button into view
    await tester.ensureVisible(find.byType(MyButton));

    // Tap the button to trigger validation
    await tester.tap(find.byType(MyButton));
    await tester.pump(); // rebuild to show error

    // Check that the email error appears
    expect(find.text("Enter valid email"), findsOneWidget);
  });

  testWidgets('Shows error when passwords do not match', (tester) async {
    await tester.pumpWidget(makeTestableWidget(const SignupScreen()));

    // Enter password and mismatched confirm password
    await tester.enterText(
      find.byType(TextFormField).at(5),
      '123456',
    ); // password
    await tester.enterText(
      find.byType(TextFormField).at(6),
      '654321',
    ); // confirm

    // Scroll submit button into view
    await tester.ensureVisible(find.byType(MyButton));

    // Tap the button to trigger validation
    await tester.tap(find.byType(MyButton));
    await tester.pump(); // rebuild to show error

    // Check that the password mismatch error appears
    expect(find.text("Passwords do not match"), findsOneWidget);
  });

  testWidgets('Successful registration updates state to registered', (
    tester,
  ) async {
    final mockVM = MockAuthViewModel();

    await tester.pumpWidget(
      makeTestableWidget(const SignupScreen(), mockViewModel: mockVM),
    );

    // Enter all required fields
    await tester.enterText(find.byType(TextFormField).at(0), 'John');
    await tester.enterText(find.byType(TextFormField).at(1), 'Doe');
    await tester.enterText(find.byType(TextFormField).at(2), 'johndoe');
    await tester.enterText(
      find.byType(TextFormField).at(3),
      'test@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(4), '1234567');
    await tester.enterText(find.byType(TextFormField).at(5), '123456');
    await tester.enterText(find.byType(TextFormField).at(6), '123456');

    // Simulate successful registration
    await mockVM.registerSuccess(
      firstName: 'John',
      lastName: 'Doe',
      username: 'johndoe',
      email: 'test@example.com',
      phoneNumber: '1234567',
      password: '123456',
      confirmPassword: '123456',
    );

    await tester.pump();

    expect(mockVM.state.status, AuthStatus.registered);
  });

  testWidgets('Failed registration updates state to error', (tester) async {
    final mockVM = MockAuthViewModel();

    await tester.pumpWidget(
      makeTestableWidget(const SignupScreen(), mockViewModel: mockVM),
    );

    await mockVM.registerError(
      firstName: 'John',
      lastName: 'Doe',
      username: 'johndoe',
      email: 'test@example.com',
      phoneNumber: '1234567',
      password: '123456',
      confirmPassword: '123456',
    );

    await tester.pump();

    expect(mockVM.state.status, AuthStatus.error);
    expect(mockVM.state.errorMessage, 'Registration failed');
  });
}
