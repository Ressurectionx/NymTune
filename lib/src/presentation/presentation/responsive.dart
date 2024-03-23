import 'package:flutter/material.dart';
import 'package:nymtune/src/core/theme/app_colors.dart';

class ResponsiveWidget extends StatelessWidget {
  final Widget child;
  final double breakpoint; // Define a breakpoint for webview layout
  final double maxWidth; // Define a max width for the webview layout

  const ResponsiveWidget({
    Key? key,
    required this.child,
    this.breakpoint = 400.0,
    this.maxWidth = 700.0, // Default value for maxWidth
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > breakpoint) {
          return _WebviewLayout(
            child: child,
            maxWidth: maxWidth, // Pass the maxWidth to the webview layout
          ); // Use a custom webview layout
        } else {
          return child; // Use the original layout for mobile
        }
      },
    );
  }
}

class _WebviewLayout extends StatelessWidget {
  final Widget child;
  final double maxWidth; // Accept the maxWidth parameter

  const _WebviewLayout({
    Key? key,
    required this.child,
    required this.maxWidth, // Require the maxWidth parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xff000000),
      child: Center(
        child: Container(
          constraints:
              BoxConstraints(maxWidth: maxWidth), // Use the passed maxWidth
          child: child,
        ),
      ),
    );
  }
}
