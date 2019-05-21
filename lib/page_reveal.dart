import 'dart:math';

import 'package:flutter/material.dart';

class PageReveal extends StatelessWidget {
  const PageReveal({
    @required this.revealPercent,
    this.child,
  });

  final double revealPercent;
  final Widget child;

  @override
  Widget build(BuildContext context) => ClipOval(
        clipper: CircleRevealClipper(revealPercent),
        child: child,
      );
}

class CircleRevealClipper extends CustomClipper<Rect> {
  const CircleRevealClipper(
    this.revealPercent,
  );

  final double revealPercent;

  @override
  Rect getClip(Size size) {
    final epicenter = Offset(size.width / 2, size.height * 0.9);

    // Calculate distance from epicenter to the top left corner to
    // make sure we fill the screen.
    final theta = atan(epicenter.dy / epicenter.dx);
    final distanceToCorner = epicenter.dy / sin(theta);

    final radius = distanceToCorner * revealPercent;
    final diameter = 2 * radius;

    return Rect.fromLTWH(
        epicenter.dx - radius, epicenter.dy - radius, diameter, diameter);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => true;
}
