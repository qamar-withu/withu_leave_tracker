import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class AppPageWrapper extends StatelessWidget {
  final Widget child;
  final bool canPop;
  final VoidCallback? onBackPressed;

  const AppPageWrapper({
    super.key,
    required this.child,
    this.canPop = true,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (!canPop) {
          return false;
        }

        if (onBackPressed != null) {
          onBackPressed!();
          return false;
        }

        // Use go_router navigation instead of system back
        if (context.canPop()) {
          context.pop();
          return false;
        }

        return true;
      },
      child: CallbackShortcuts(
        bindings: {
          // Disable browser back navigation
          const SingleActivator(LogicalKeyboardKey.browserBack): () {},
          const SingleActivator(LogicalKeyboardKey.browserForward): () {},
        },
        child: child,
      ),
    );
  }
}
