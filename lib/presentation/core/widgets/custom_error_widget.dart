import 'package:flutter/material.dart';
import 'package:withu_leave_tracker/domain/core/errors/failures.dart';

class CustomErrorWidget extends StatelessWidget {
  const CustomErrorWidget({
    super.key,
    required this.failure,
    this.onRetry,
    this.message,
  });

  final Failure? failure;
  final VoidCallback? onRetry;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message ?? _getErrorMessage(failure),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getErrorMessage(Failure? failure) {
    if (failure == null) return 'An unexpected error occurred';

    return failure.when(
      serverError: (message) => message ?? 'Server error occurred',
      networkError: (message) => message ?? 'Network connection error',
      authenticationFailure: (message) => message ?? 'Authentication failed',
      permissionDenied: (message) => message ?? 'Permission denied',
      notFound: (message) => message ?? 'Resource not found',
      validationError: (message) => message,
      unknownError: (message) => message ?? 'An unknown error occurred',
    );
  }
}
