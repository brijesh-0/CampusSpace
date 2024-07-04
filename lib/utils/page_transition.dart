import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class PageTransition extends StatelessWidget {
  final Widget child;

  const PageTransition({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return PageTransitionSwitcher(
      // Replace PageView.builder
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (
        Widget child,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return FadeThroughTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          fillColor: Theme.of(context).colorScheme.surface,
          child: child,
        );
      },
      child: child, // Access current page directly
    );
  }
}
