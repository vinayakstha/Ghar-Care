import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghar_care/core/utils/my_snackbar.dart';
import 'package:ghar_care/features/auth/presentation/pages/login_screen.dart';
import 'package:ghar_care/features/auth/presentation/state/auth_state.dart';
import 'package:ghar_care/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:ghar_care/core/widgets/my_button.dart';
import 'package:ghar_care/core/widgets/my_textformfield.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final usernameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();

  bool hideConfirmPassword = true;
  bool hidePassword = true;

  @override
  void dispose() {
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    usernameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    passwordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (_formKey.currentState!.validate()) {
      ref
          .read(authViewModelProvider.notifier)
          .register(
            firstName: firstNameCtrl.text,
            lastName: lastNameCtrl.text,
            username: usernameCtrl.text,
            email: emailCtrl.text,
            phoneNumber: phoneCtrl.text,
            password: passwordCtrl.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);

    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      if (next.status == AuthStatus.error) {
        showSnackBar(
          context: context,
          message: next.errorMessage ?? "Registration failed",
          color: Colors.red,
        );
      } else if (next.status == AuthStatus.registered) {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => LoginScreen()),
        // );
        showSnackBar(
          context: context,
          message: "Registration successful",
          color: Colors.green,
        );
      }
    });

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),

              // Title
              const Text(
                "Create your account",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Inter Bold",
                ),
              ),

              const SizedBox(height: 30),

              // First & Last Name Row
              Row(
                children: [
                  Expanded(
                    child: MyTextformfield(
                      controller: firstNameCtrl,
                      labelText: "First Name",
                      prefixIcon: Icons.person_outline,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter first name";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: MyTextformfield(
                      controller: lastNameCtrl,
                      labelText: "Last Name",
                      prefixIcon: Icons.person_outline,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter last name";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              // Username
              MyTextformfield(
                controller: usernameCtrl,
                labelText: "Username",
                prefixIcon: Icons.account_circle_outlined,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Enter username";
                  return null;
                },
              ),

              const SizedBox(height: 15),

              // Email
              MyTextformfield(
                controller: emailCtrl,
                labelText: "E-Mail",
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Enter email";

                  // Simple email pattern check
                  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                  if (!emailRegex.hasMatch(value)) {
                    return "Enter valid email";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              // Phone Number
              MyTextformfield(
                controller: phoneCtrl,
                labelText: "Phone Number",
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter phone number";
                  }
                  if (value.length < 7) return "Phone number too short";
                  return null;
                },
              ),

              const SizedBox(height: 15),

              // Password
              MyTextformfield(
                controller: passwordCtrl,
                labelText: "Password",
                prefixIcon: Icons.lock_outline,
                obscureText: hidePassword,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Enter password";
                  if (value.length < 6) {
                    return "Password must be at least 6 characters";
                  }
                  return null;
                },
                suffixIcon: IconButton(
                  icon: Icon(
                    hidePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() => hidePassword = !hidePassword);
                  },
                ),
              ),

              const SizedBox(height: 15),

              // Confirm Password
              MyTextformfield(
                controller: confirmPasswordCtrl,
                labelText: "Confirm Password",
                prefixIcon: Icons.lock_outline,
                obscureText: hideConfirmPassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Confirm your password";
                  }
                  if (value != passwordCtrl.text) {
                    return "Passwords do not match";
                  }
                  return null;
                },
                suffixIcon: IconButton(
                  icon: Icon(
                    hideConfirmPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() => hideConfirmPassword = !hideConfirmPassword);
                  },
                ),
              ),
              const SizedBox(height: 15),

              // Create Account Button
              MyButton(text: "Create Account", onPressed: _handleSignup),

              const SizedBox(height: 25),

              // OR Divider
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade400)),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text("Or Sign Up With Google"),
                  ),
                  Expanded(child: Divider(color: Colors.grey.shade400)),
                ],
              ),

              const SizedBox(height: 20),

              Center(
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Image.asset("assets/icons/google.png", height: 28),
                  ),
                ),
              ),
              const SizedBox(width: 25),
            ],
          ),
        ),
      ),
    );
  }
}
