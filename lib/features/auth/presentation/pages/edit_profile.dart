import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghar_care/core/api/api_endpoints.dart';
import 'package:ghar_care/core/utils/snackbar_utils.dart';
import 'package:ghar_care/core/widgets/my_button.dart';
import 'package:ghar_care/core/widgets/my_textformfield.dart';
import 'package:ghar_care/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();

  final List<XFile> _selectedMedia = [];
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();

    // Fetch current user on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authViewModelProvider.notifier).getCurrentUser();
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<bool> _askPermission(Permission permission) async {
    final status = await permission.status;
    if (status.isGranted) {
      return true;
    }

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
        title: const Text("Give Permission"),
        content: const Text(
          "This feature requires permission to access your camera or gallery. Please enable it in your device settings.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
            child: const Text("Open Settings"),
          ),
        ],
      ),
    );
  }

  //code for camera
  Future<void> _pickFromCamera() async {
    final hasPermission = await _askPermission(Permission.camera);
    if (!hasPermission) {
      return;
    }

    final XFile? photo = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (photo != null) {
      setState(() {
        _selectedMedia.clear();
        _selectedMedia.add(photo);
      });

      //upload image to server
      await ref
          .read(authViewModelProvider.notifier)
          .uploadImage(File(photo.path));
    }
  }

  //code for gallery
  Future<void> _pickFromGallery({bool allowMultiple = false}) async {
    try {
      if (allowMultiple) {
        final List<XFile> images = await _imagePicker.pickMultiImage(
          imageQuality: 80,
        );

        if (images.isNotEmpty) {
          setState(() {
            _selectedMedia.clear();
            _selectedMedia.addAll(images);
          });
        }
      } else {
        final XFile? image = await _imagePicker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 80,
        );
        if (image != null) {
          setState(() {
            _selectedMedia.clear();
            _selectedMedia.add(image);
          });

          //upload image to server
          await ref
              .read(authViewModelProvider.notifier)
              .uploadImage(File(image.path));
        }
      }
    } catch (e) {
      debugPrint("Gallery error: $e");

      if (mounted) {
        SnackbarUtils.showError(context, "Gallery access denied");
      }
    }
  }

  //code for dialogbox for menu
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

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    final user = authState.authEntity;

    final imageVersion =
        authState.uploadPhotoName ??
        user?.profilePicture ??
        DateTime.now().millisecondsSinceEpoch.toString();

    final profileImageUrl = user?.profilePicture != null
        ? '${ApiEndpoints.baseUrl.replaceAll('/api', '')}${user!.profilePicture}?v=$imageVersion'
        : null;

    // Populate fields when user data is loaded
    if (user != null && _firstNameController.text.isEmpty) {
      _firstNameController.text = user.firstName;
      _lastNameController.text = user.lastName;
      _usernameController.text = user.username;
      _phoneController.text = user.phoneNumber;
    }

    final initial = (user?.username ?? "?")[0].toUpperCase();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Edit Profile"),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 12),

              /// Profile Picture Button
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 65,
                    backgroundColor: const Color(0xFF006BAA),
                    // Priority: 1. Local selection 2. Network image 3. null
                    backgroundImage: _selectedMedia.isNotEmpty
                        ? FileImage(File(_selectedMedia[0].path))
                        : (user?.profilePicture != null
                                  ? NetworkImage(
                                      // '${ApiEndpoints.baseUrl.replaceAll('/api', '')}${user!.profilePicture!}'
                                      profileImageUrl!,
                                    )
                                  : null)
                              as ImageProvider?,
                    child:
                        (_selectedMedia.isEmpty &&
                            (user?.profilePicture == null ||
                                user!.profilePicture!.isEmpty))
                        ? Text(
                            initial,
                            style: const TextStyle(
                              fontSize: 38,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  ),
                  InkWell(
                    onTap: () {
                      _pickMedia();
                    },
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

              const SizedBox(height: 30),

              MyTextformfield(
                controller: _usernameController,
                labelText: "Username",
                prefixIcon: Icons.account_circle_outlined,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Username is required";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              MyTextformfield(
                controller: _firstNameController,
                labelText: "First Name",
                prefixIcon: Icons.person_outline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "First name is required";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              MyTextformfield(
                controller: _lastNameController,
                labelText: "Last Name",
                prefixIcon: Icons.person_outline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Last name is required";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              MyTextformfield(
                controller: _phoneController,
                labelText: "Phone Number",
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Phone number is required";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 40),

              /// Confirm Button
              MyButton(
                text: "Confirm",
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // TODO: submit profile update
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
