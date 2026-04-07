import 'dart:io';
import 'package:flutter/material.dart';

class AppErrorWidget extends StatelessWidget {
  final dynamic error;
  final VoidCallback onRetry;
  final String? message;

  const AppErrorWidget({
    super.key,
    required this.error,
    required this.onRetry,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    bool isNoInternet = error is SocketException || 
                       error.toString().contains('SocketException') ||
                       error.toString().contains('network_error');

    return Center(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isNoInternet ? Icons.wifi_off_rounded : Icons.error_outline_rounded,
            size: 80,
            color: const Color(0xFFBC0006).withOpacity(0.5),
          ),
          const SizedBox(height: 24),
          Text(
            isNoInternet ? 'No Internet Connection' : 'Something went wrong',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF370002),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            message ?? _getErrorMessage(error),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: const Color(0xFF653D1E).withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Try Again'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5E0006),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getErrorMessage(dynamic error) {
    if (error is SocketException) {
      return 'Please check your internet connection and try again.';
    }
    if (error.toString().contains('permission-denied')) {
      return 'You do not have permission to access this data.';
    }
    return 'We encountered an error while loading the data. Please try again later.';
  }
}
