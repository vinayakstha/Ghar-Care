import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ghar_care/core/widgets/my_button.dart';
import 'package:ghar_care/features/auth/presentation/pages/login_screen.dart';
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

  // Simulate successful login
  @override
  Future<void> login({required String email, required String password}) async {
    mockState = mockState.copyWith(status: AuthStatus.authenticated);
    state = mockState;
  }

  // Simulate failed login
  Future<void> loginWithError() async {
    mockState = mockState.copyWith(
      status: AuthStatus.error,
      errorMessage: "Login failed",
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
  testWidgets('LoginScreen renders correctly', (tester) async {
    await tester.pumpWidget(makeTestableWidget(const LoginScreen()));

    expect(find.text("Welcome back!"), findsOneWidget);
    expect(
      find.text("Get your household tasks done quickly and easily."),
      findsOneWidget,
    );
    expect(find.byType(TextFormField), findsNWidgets(2)); // Email + Password
    expect(find.byType(MyButton), findsOneWidget);
    expect(find.text("Sign Up"), findsOneWidget);
  });

  testWidgets('Shows error when email is invalid', (tester) async {
    await tester.pumpWidget(makeTestableWidget(const LoginScreen()));

    await tester.enterText(find.byType(TextFormField).first, 'invalidemail');
    await tester.tap(find.byType(MyButton));
    await tester.pump();

    expect(find.text("Enter a valid email address"), findsOneWidget);
  });

  testWidgets('Shows error when password is too short', (tester) async {
    await tester.pumpWidget(makeTestableWidget(const LoginScreen()));

    await tester.enterText(find.byType(TextFormField).last, '123');
    await tester.tap(find.byType(MyButton));
    await tester.pump();

    expect(find.text("Password must be at least 6 characters"), findsOneWidget);
  });

  testWidgets('Successful login updates state to authenticated', (
    tester,
  ) async {
    final mockVM = MockAuthViewModel();

    await tester.pumpWidget(
      makeTestableWidget(const LoginScreen(), mockViewModel: mockVM),
    );

    await tester.enterText(
      find.byType(TextFormField).first,
      'test@example.com',
    );
    await tester.enterText(find.byType(TextFormField).last, '123456');

    await tester.tap(find.byType(MyButton));
    await tester.pump(); // triggers login

    expect(mockVM.state.status, AuthStatus.authenticated);
  });

  testWidgets('Failed login updates state to error', (tester) async {
    final mockVM = MockAuthViewModel();
    await tester.pumpWidget(
      makeTestableWidget(const LoginScreen(), mockViewModel: mockVM),
    );

    await mockVM.loginWithError();
    await tester.pump();

    expect(mockVM.state.status, AuthStatus.error);
    expect(mockVM.state.errorMessage, "Login failed");
  });
}
