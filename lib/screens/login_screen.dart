import 'package:flutter/material.dart';
import 'package:ghar_care/common/my_snackbar.dart';
import 'package:ghar_care/screens/navigation_screen.dart';
import 'package:ghar_care/screens/signup_screen.dart';
import 'package:ghar_care/widgets/my_button.dart';
import 'package:ghar_care/widgets/my_textformfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  bool hidePassword = true;

  @override
  void dispose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NavigationScreen()),
      );
      showSnackBar(context: context, message: "Login Successfull!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),

                // Title
                const Text(
                  "Welcome back!",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Inter bold",
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Get your household tasks done quickly and easily.",
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),

                const SizedBox(height: 40),

                // Email
                MyTextformfield(
                  controller: emailCtrl,
                  labelText: "E-Mail",
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Enter email";

                    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                    if (!emailRegex.hasMatch(value)) {
                      return "Enter a valid email address";
                    }
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
                      color: Colors.grey.shade600,
                    ),
                    onPressed: () {
                      setState(() => hidePassword = !hidePassword);
                    },
                  ),
                ),

                const SizedBox(height: 10),

                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Login Button
                MyButton(text: "Login", onPressed: _handleLogin),

                const SizedBox(height: 30),

                // OR Divider
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey.shade400)),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text("Or Login With Google"),
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
                      child: Image.asset(
                        "assets/icons/google.png",
                        height: 28,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.g_mobiledata,
                              size: 28,
                              color: Colors.blue,
                            ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Link to Signup Screen
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignupScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
