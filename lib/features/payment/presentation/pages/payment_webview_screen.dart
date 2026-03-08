import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:ghar_care/core/utils/snackbar_utils.dart';
import 'package:ghar_care/features/booking/presentation/view_model/booking_view_model.dart';
import 'package:ghar_care/features/category/presentation/pages/home_screen.dart';
import 'package:ghar_care/features/payment/presentation/state/payment_state.dart';
import 'package:ghar_care/features/payment/presentation/view_model/payment_view_model.dart';

class PaymentWebviewScreen extends ConsumerStatefulWidget {
  final String paymentUrl;
  final String bookingId;

  const PaymentWebviewScreen({
    super.key,
    required this.paymentUrl,
    required this.bookingId,
  });

  @override
  ConsumerState<PaymentWebviewScreen> createState() =>
      _PaymentWebviewScreenState();
}

class _PaymentWebviewScreenState extends ConsumerState<PaymentWebviewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _verificationHandled = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() => _isLoading = true);

            if (!_verificationHandled &&
                url.contains('/user/booking/verify') &&
                url.contains('pidx=')) {
              final uri = Uri.parse(url);
              final pidx = uri.queryParameters['pidx'];
              if (pidx != null) {
                _verificationHandled = true;
                _handleVerification(pidx);
              }
            }
          },
          onPageFinished: (url) {
            setState(() => _isLoading = false);
          },
          onNavigationRequest: (request) {
            final url = request.url;

            if (!_verificationHandled &&
                url.contains('/user/booking/verify') &&
                url.contains('pidx=')) {
              final uri = Uri.parse(url);
              final pidx = uri.queryParameters['pidx'];
              if (pidx != null) {
                _verificationHandled = true;
                _handleVerification(pidx);
              }
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  void _popToHome() {
    int count = 0;
    Navigator.of(context).popUntil((_) => count++ >= 2);
  }

  Future<void> _handleVerification(String pidx) async {
    final success = await ref
        .read(paymentViewModelProvider.notifier)
        .verifyPayment(pidx);

    if (!mounted) return;

    if (success) {
      SnackbarUtils.showSuccess(context, "Payment successful!");
    } else {
      await ref
          .read(bookingViewModelProvider.notifier)
          .deleteBooking(widget.bookingId);

      if (!mounted) return;
      SnackbarUtils.showError(context, "Payment failed or cancelled.");
    }

    if (!mounted) return;
    _popToHome();
  }

  Future<void> _handleClose() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cancel Payment?"),
        content: const Text(
          "Are you sure you want to cancel? Your booking will be removed.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              "Yes, Cancel",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    await ref
        .read(bookingViewModelProvider.notifier)
        .deleteBooking(widget.bookingId);

    if (!mounted) return;
    SnackbarUtils.showError(context, "Booking cancelled.");
    _popToHome();
  }

  @override
  Widget build(BuildContext context) {
    final paymentState = ref.watch(paymentViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Khalti Payment"),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: _handleClose,
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading || paymentState.status == PaymentStatus.loading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
