// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:ghar_care/app/routes/app_routes.dart';
// import 'package:ghar_care/features/auth/presentation/pages/edit_profile.dart';
// import 'package:ghar_care/features/auth/presentation/pages/login_screen.dart';
// import 'package:ghar_care/features/auth/presentation/view_model/auth_view_model.dart';
// import 'package:ghar_care/features/auth/presentation/state/auth_state.dart';
// import 'package:ghar_care/core/utils/snackbar_utils.dart';

// class ProfileScreen extends ConsumerStatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends ConsumerState<ProfileScreen> {
//   // Mock user data (replace with provider data)
//   final String username = "Vinayak";
//   final String email = "vinayak@gmail.com";

//   @override
//   Widget build(BuildContext context) {
//     final String initial = username.isNotEmpty
//         ? username[0].toUpperCase()
//         : "?";

//     Future<void> _showLogoutDialog() async {
//       final shouldLogout = await showDialog<bool>(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text(
//             'Logout',
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           content: const Text('Are you sure you want to logout?'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(false),
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(true),
//               child: const Text('Yes'),
//             ),
//           ],
//         ),
//       );

//       if (shouldLogout == true) {
//         // call logout usecase
//         await ref.read(authViewModelProvider.notifier).logout();

//         final state = ref.read(authViewModelProvider);
//         if (state.status == AuthStatus.unauthenticated) {
//           AppRoutes.pushAndRemoveUntil(context, const LoginScreen());
//           SnackbarUtils.showSuccess(context, 'Logged out successfully');
//         } else if (state.status == AuthStatus.error &&
//             state.errorMessage != null) {
//           SnackbarUtils.showError(context, state.errorMessage!);
//         } else {
//           SnackbarUtils.showError(context, 'Logout failed');
//         }
//       }
//     }

//     return SafeArea(
//       child: Scaffold(
//         // appBar: AppBar(title: const Text("Profile"), centerTitle: true),
//         backgroundColor: Colors.white,
//         body: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               const SizedBox(height: 20),
//               Text(
//                 "My Profile",

//                 style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 20),

//               // Profile Avatar
//               CircleAvatar(
//                 radius: 65,
//                 backgroundColor: const Color(0xFF006BAA),
//                 child: Text(
//                   initial,
//                   style: const TextStyle(
//                     fontSize: 40,
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 14),

//               // Username (bigger & bolder)
//               Text(
//                 username,
//                 style: const TextStyle(
//                   fontSize: 26,
//                   fontWeight: FontWeight.w800,
//                 ),
//               ),

//               const SizedBox(height: 6),

//               // Email (bigger)
//               Text(
//                 email,
//                 style: TextStyle(
//                   fontSize: 17,
//                   color: Colors.grey[700],
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),

//               const SizedBox(height: 36),

//               // Options
//               _profileTile(
//                 icon: Icons.edit_outlined,
//                 title: "Edit Profile",
//                 onTap: () {
//                   AppRoutes.push(context, EditProfileScreen());
//                 },
//               ),

//               _profileTile(
//                 icon: Icons.history,
//                 title: "Booking History",
//                 onTap: () {},
//               ),

//               _profileTile(
//                 icon: Icons.lock_outline,
//                 title: "Change Password",
//                 onTap: () {},
//               ),

//               _profileTile(
//                 icon: Icons.logout,
//                 title: "Logout",
//                 color: Colors.red,
//                 onTap: () => _showLogoutDialog(),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _profileTile({
//     required IconData icon,
//     required String title,
//     Color? color,
//     required VoidCallback onTap,
//   }) {
//     return Card(
//       color: Colors.white,
//       elevation: 2,
//       margin: const EdgeInsets.symmetric(vertical: 10),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//       child: SizedBox(
//         height: 67,
//         child: ListTile(
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: 20,
//             vertical: 6,
//           ),
//           leading: Icon(icon, size: 26, color: color ?? Colors.black),
//           title: Text(
//             title,
//             style: TextStyle(
//               fontSize: 17,
//               // fontWeight: FontWeight.w600,
//               color: color ?? Colors.black,
//             ),
//           ),
//           trailing: const Icon(Icons.chevron_right),
//           onTap: onTap,
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghar_care/app/routes/app_routes.dart';
import 'package:ghar_care/core/api/api_endpoints.dart';
import 'package:ghar_care/features/auth/presentation/pages/edit_profile.dart';
import 'package:ghar_care/features/auth/presentation/pages/login_screen.dart';
import 'package:ghar_care/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:ghar_care/features/auth/presentation/state/auth_state.dart';
import 'package:ghar_care/core/utils/snackbar_utils.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();

    // Fetch current user on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authViewModelProvider.notifier).getCurrentUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    final user = authState.authEntity;

    // Get user data from state
    final username = user?.username ?? "User";
    final email = user?.email ?? "email@example.com";
    final profilePicture = user?.profilePicture;

    // Cache-bust profile image so updated pictures show immediately (without logout/login)
    final imageVersion =
        authState.uploadPhotoName ??
        user?.profilePicture ??
        DateTime.now().millisecondsSinceEpoch.toString();
    final profileImageUrl =
        (profilePicture != null && profilePicture.isNotEmpty)
        ? '${ApiEndpoints.baseUrl.replaceAll('/api', '')}$profilePicture?v=$imageVersion'
        : null;

    final String initial = username.isNotEmpty
        ? username[0].toUpperCase()
        : "?";

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

      if (shouldLogout == true) {
        // call logout usecase
        await ref.read(authViewModelProvider.notifier).logout();

        final state = ref.read(authViewModelProvider);
        if (state.status == AuthStatus.unauthenticated) {
          if (mounted) {
            AppRoutes.pushAndRemoveUntil(context, const LoginScreen());
            SnackbarUtils.showSuccess(context, 'Logged out successfully');
          }
        } else if (state.status == AuthStatus.error &&
            state.errorMessage != null) {
          if (mounted) {
            SnackbarUtils.showError(context, state.errorMessage!);
          }
        } else {
          if (mounted) {
            SnackbarUtils.showError(context, 'Logout failed');
          }
        }
      }
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: authState.status == AuthStatus.loading && user == null
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      "My Profile",
                      style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Profile Avatar with Image (cache-busted URL for immediate UI updates)
                    CircleAvatar(
                      radius: 65,
                      backgroundColor: const Color(0xFF006BAA),
                      backgroundImage: profileImageUrl != null
                          ? NetworkImage(profileImageUrl)
                          : null,
                      child: (profilePicture == null || profilePicture.isEmpty)
                          ? Text(
                              initial,
                              style: const TextStyle(
                                fontSize: 40,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : null,
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
                      onTap: () async {
                        // Navigate and refresh when returning
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditProfileScreen(),
                          ),
                        );
                        // Refresh user data when returning from edit screen
                        if (mounted) {
                          ref
                              .read(authViewModelProvider.notifier)
                              .getCurrentUser();
                        }
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
