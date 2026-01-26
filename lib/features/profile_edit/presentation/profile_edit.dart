import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghar_care/core/utils/snackbar_utils.dart';
import 'package:ghar_care/core/widgets/my_button.dart';
import 'package:ghar_care/core/widgets/my_textformfield.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController(text: "Vinayak");
  final _lastNameController = TextEditingController(text: "Shrestha");
  final _usernameController = TextEditingController(text: "Vinayak");
  final _phoneController = TextEditingController(text: "98XXXXXXXX");

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  final List<XFile> _selectedMedia = [];
  final ImagePicker _imagePicker = ImagePicker();

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
        title: Text("Give Permission"),
        actions: [
          TextButton(onPressed: () {}, child: Text("Cancle")),
          TextButton(onPressed: () {}, child: Text("Open Settings")),
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
            setState(() {
              _selectedMedia.clear();
              _selectedMedia.add(image);
            });
          });
        }
      }
    } catch (e) {
      debugPrint("Gallery error");

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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera),
                title: Text("Open Camera"),
                onTap: () {
                  Navigator.pop(context);
                  _pickFromCamera();
                },
              ),

              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text("Open Gallery"),
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
    final initial = _usernameController.text.isNotEmpty
        ? _usernameController.text[0].toUpperCase()
        : "?";

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
                    backgroundImage: _selectedMedia.isNotEmpty
                        ? FileImage(File(_selectedMedia[0].path))
                        : null,
                    child: _selectedMedia.isNotEmpty
                        ? null
                        : Text(
                            initial,
                            style: const TextStyle(
                              fontSize: 38,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                  InkWell(
                    onTap: () {
                      _pickMedia();
                    },
                    child: const CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.camera_alt,
                        size: 18,
                        color: const Color(0xFF006BAA),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

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
