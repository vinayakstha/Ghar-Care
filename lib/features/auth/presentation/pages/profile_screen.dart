import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghar_care/app/routes/app_routes.dart';
import 'package:ghar_care/features/profile/presentation/pages/edit_profile.dart';
import 'package:ghar_care/features/auth/presentation/pages/login_screen.dart';
import 'package:ghar_care/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:ghar_care/features/auth/presentation/state/auth_state.dart';
import 'package:ghar_care/core/services/storage/user_session_service.dart';
import 'package:ghar_care/core/utils/snackbar_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final List<XFile> _selectedMedia = [];
  final ImagePicker _imagePicker = ImagePicker();

  Future<bool> _askPermission(Permission permission) async {
    final status = await permission.status;
    if (status.isGranted) return true;

    if (status.isDenied) {
      final result = await permission.request();
      return result.isGranted;
    }

    if (status.isPermanentlyDenied) {
      _showPermissionDeniedDialog();
      return false;
    }
    return false;
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Permission Required"),
        content: const Text("Please allow access from app settings."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text("Open Settings"),
          ),
        ],
      ),
    );
  }

  Future<void> _pickFromCamera() async {
    final hasPermission = await _askPermission(Permission.camera);
    if (!hasPermission) return;

    final XFile? photo = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (photo != null) {
      setState(() {
        _selectedMedia.clear();
        _selectedMedia.add(photo);
      });

      await ref
          .read(authViewModelProvider.notifier)
          .uploadImage(File(photo.path));
    }
  }

  Future<void> _pickFromGallery() async {
    final hasPermission = await _askPermission(Permission.photos);
    if (!hasPermission) return;

    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _selectedMedia.clear();
          _selectedMedia.add(image);
        });

        await ref
            .read(authViewModelProvider.notifier)
            .uploadImage(File(image.path));
      }
    } catch (e) {
      if (mounted) {
        SnackbarUtils.showError(context, "Gallery access denied");
      }
    }
  }

  Future<void> _pickMedia() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Take Photo"),
                onTap: () {
                  Navigator.pop(context);
                  _pickFromCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Select From Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  _pickFromGallery();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showLogoutDialog() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Logout',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (!mounted) return;

    if (shouldLogout == true) {
      await ref.read(authViewModelProvider.notifier).logout();

      if (!mounted) return;

      final state = ref.read(authViewModelProvider);
      if (state.status == AuthStatus.unauthenticated) {
        AppRoutes.pushAndRemoveUntil(context, const LoginScreen());
        SnackbarUtils.showSuccess(context, 'Logged out successfully');
      } else if (state.status == AuthStatus.error &&
          state.errorMessage != null) {
        SnackbarUtils.showError(context, state.errorMessage!);
      } else {
        SnackbarUtils.showError(context, 'Logout failed');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(userSessionServiceProvider);
    final username = session.getUsername() ?? "User";
    final email = session.getUserEmail() ?? "example@gmail.com";
    final profileImage = session.getUserProfilePicture();

    final String initial = username.isNotEmpty
        ? username[0].toUpperCase()
        : "?";

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                "My Profile",
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              /// Profile Avatar with edit button
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 65,
                    backgroundColor: const Color(0xFF006BAA),
                    child: _selectedMedia.isNotEmpty
                        ? ClipOval(
                            child: Image.file(
                              File(_selectedMedia[0].path),
                              width: 130,
                              height: 130,
                              fit: BoxFit.cover,
                            ),
                          )
                        : profileImage != null
                        ? ClipOval(
                            child: Image.network(
                              "http://192.168.18.3:5050$profileImage",
                              width: 130,
                              height: 130,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Text(
                                    initial,
                                    style: const TextStyle(
                                      fontSize: 40,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                            ),
                          )
                        : Text(
                            initial,
                            style: const TextStyle(
                              fontSize: 40,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                  InkWell(
                    onTap: _pickMedia,
                    child: const CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.edit,
                        size: 18,
                        color: Color(0xFF006BAA),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              /// Username
              Text(
                username,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 6),

              /// Email
              Text(
                email,
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 36),

              /// Edit Profile
              _profileTile(
                icon: Icons.edit_outlined,
                title: "Edit Profile",
                onTap: () {
                  AppRoutes.push(context, const EditProfileScreen());
                  print(profileImage);
                },
              ),

              /// Logout
              _profileTile(
                icon: Icons.logout,
                title: "Logout",
                color: Colors.red,
                onTap: () => _showLogoutDialog(),
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
            style: TextStyle(fontSize: 17, color: color ?? Colors.black),
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
      ),
    );
  }
}
