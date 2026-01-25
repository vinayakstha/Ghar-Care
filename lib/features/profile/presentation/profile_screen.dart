import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghar_care/app/routes/app_routes.dart';
import 'package:ghar_care/features/profile_edit/presentation/profile_edit.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  // Mock user data (replace with provider data)
  final String username = "Vinayak";
  final String email = "vinayak@gmail.com";

  @override
  Widget build(BuildContext context) {
    final String initial = username.isNotEmpty
        ? username[0].toUpperCase()
        : "?";

    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(title: const Text("Profile"), centerTitle: true),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Profile Avatar
              CircleAvatar(
                radius: 65,
                backgroundColor: Colors.blue,
                child: Text(
                  initial,
                  style: const TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // Username (bigger & bolder)
              Text(
                username,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 6),

              // Email (bigger)
              Text(
                email,
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 36),

              // Options
              _profileTile(
                icon: Icons.edit_outlined,
                title: "Edit Profile",
                onTap: () {
                  AppRoutes.push(context, ProfileEditScreen());
                },
              ),

              _profileTile(
                icon: Icons.history,
                title: "Booking History",
                onTap: () {},
              ),

              _profileTile(
                icon: Icons.lock_outline,
                title: "Change Password",
                onTap: () {},
              ),

              _profileTile(
                icon: Icons.logout,
                title: "Logout",
                color: Colors.red,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileTile({
    required IconData icon,
    required String title,
    Color? color,
    required VoidCallback onTap,
  }) {
    return Card(
      color: Colors.white,
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: SizedBox(
        height: 67,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 6,
          ),
          leading: Icon(icon, size: 26, color: color ?? Colors.black),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 17,
              // fontWeight: FontWeight.w600,
              color: color ?? Colors.black,
            ),
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
      ),
    );
  }
}
