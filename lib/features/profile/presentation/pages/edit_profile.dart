import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghar_care/core/services/storage/user_session_service.dart';
import 'package:ghar_care/core/utils/snackbar_utils.dart';
import 'package:ghar_care/core/widgets/my_button.dart';
import 'package:ghar_care/core/widgets/my_textformfield.dart';
import 'package:ghar_care/features/profile/domain/entities/user_entity.dart';
import 'package:ghar_care/features/profile/presentation/view_model/user_view_model.dart';
import 'package:ghar_care/features/profile/presentation/state/user_state.dart';

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

  @override
  void initState() {
    super.initState();

    // Fetch from SharedPreferences using UserSessionService
    final session = ref.read(userSessionServiceProvider);

    _firstNameController.text = session.getUserFirstName() ?? "";
    _lastNameController.text = session.getUserLastName() ?? "";
    _usernameController.text = session.getUsername() ?? "";
    _phoneController.text = session.getUserPhoneNumber() ?? "";
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
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

              // Show loading indicator if updating
              if (userState.status == UserStatus.loading)
                const CircularProgressIndicator(),

              if (userState.status != UserStatus.loading)
                MyButton(
                  text: "Confirm",
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final userViewModel = ref.read(
                        userViewModelProvider.notifier,
                      );

                      final updatedUser = UserEntity(
                        username: _usernameController.text.trim(),
                        firstName: _firstNameController.text.trim(),
                        lastName: _lastNameController.text.trim(),
                        phoneNumber: _phoneController.text.trim(),
                        userId: '',
                        email: '',
                        role: '',
                      );

                      await userViewModel.updateProfile(updatedUser);

                      final state = ref.read(userViewModelProvider);

                      if (state.status == UserStatus.updated) {
                        // Update SharedPreferences as well
                        final session = ref.read(userSessionServiceProvider);
                        if (state.user != null) {
                          await session.saveUserSession(
                            userId: state.user!.userId,
                            email: state.user!.email,
                            username: state.user!.username,
                            firstName: state.user!.firstName,
                            lastName: state.user!.lastName,
                            phoneNumber: state.user!.phoneNumber,
                            profilePicture: state.user!.profilePicture,
                          );
                        }

                        // Show success snackbar
                        SnackbarUtils.showSuccess(
                          context,
                          "Profile updated successfully",
                        );

                        // Refresh form fields with updated data
                        if (state.user != null) {
                          _usernameController.text = state.user!.username;
                          _firstNameController.text = state.user!.firstName;
                          _lastNameController.text = state.user!.lastName;
                          _phoneController.text = state.user!.phoneNumber;
                        }
                      } else if (state.status == UserStatus.error) {
                        SnackbarUtils.showError(
                          context,
                          state.errorMessage ?? "Failed to update profile",
                        );
                      }
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
