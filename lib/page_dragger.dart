import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:material_page_reveal_published/pager_indicator.dart';

class PageDragger extends StatefulWidget {
  const PageDragger({
    this.canDragLeftToRight,
    this.canDragRightToLeft,
    this.slideUpdateStream,
  });

  final bool canDragLeftToRight;
  final bool canDragRightToLeft;
  final StreamController<SlideUpdate> slideUpdateStream;

  @override
  _PageDraggerState createState() => _PageDraggerState();
}

class _PageDraggerState extends State<PageDragger> {
  static const double fullTransitionPx = 300;

  Offset dragStart;
  SlideDirection slideDirection;
  double slidePercent = 0;

  void onDragStart(DragStartDetails details) {
    dragStart = details.globalPosition;
  }

  void onDragUpdate(DragUpdateDetails details) {
    if (dragStart != null) {
      final newPosition = details.globalPosition;
      final dx = dragStart.dx - newPosition.dx;
      if (dx > 0.0 && widget.canDragRightToLeft) {
        slideDirection = SlideDirection.rightToLeft;
      } else if (dx < 0.0 && widget.canDragLeftToRight) {
        slideDirection = SlideDirection.leftToRight;
      } else {
        slideDirection = SlideDirection.none;
      }

      if (slideDirection != SlideDirection.none) {
        slidePercent = (dx / fullTransitionPx).abs().clamp(0.0, 1.0);
      } else {
        slidePercent = 0.0;
      }

      widget.slideUpdateStream
          .add(SlideUpdate(UpdateType.dragging, slideDirection, slidePercent));
    }
  }

  void onDragEnd(DragEndDetails details) {
    widget.slideUpdateStream.add(const SlideUpdate(
      UpdateType.doneDragging,
      SlideDirection.none,
      0,
    ));

    dragStart = null;
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onHorizontalDragStart: onDragStart,
        onHorizontalDragUpdate: onDragUpdate,
        onHorizontalDragEnd: onDragEnd,
      );
}

class AnimatedPageDragger {
  AnimatedPageDragger({
    this.slideDirection,
    this.transitionGoal,
    slidePercent,
    StreamController<SlideUpdate> slideUpdateStream,
    TickerProvider vsync,
  }) {
    final startSlidePercent = slidePercent;
    double endSlidePercent;
    Duration duration;

    if (transitionGoal == TransitionGoal.open) {
      endSlidePercent = 1.0;
      final slideRemaining = 1.0 - slidePercent;
      duration = Duration(
          milliseconds: (slideRemaining / percentPerMillisecond).round());
    } else {
      endSlidePercent = 0.0;
      duration = Duration(
          milliseconds: (slidePercent / percentPerMillisecond).round());
    }

    completionAnimationController =
        AnimationController(duration: duration, vsync: vsync)
          ..addListener(() {
            slidePercent = lerpDouble(
              startSlidePercent,
              endSlidePercent,
              completionAnimationController.value,
            );

            slideUpdateStream.add(SlideUpdate(
              UpdateType.animating,
              slideDirection,
              slidePercent,
            ));
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              slideUpdateStream.add(SlideUpdate(
                UpdateType.doneAnimating,
                slideDirection,
                endSlidePercent,
              ));
            }
          });
  }

  static const double percentPerMillisecond = 0.005;

  final SlideDirection slideDirection;
  final TransitionGoal transitionGoal;

  AnimationController completionAnimationController;

  void run() {
    completionAnimationController.forward(from: 0);
  }

  void dispose() {
    completionAnimationController.dispose();
  }
}

enum TransitionGoal {
  open,
  close,
}

enum UpdateType {
  dragging,
  doneDragging,
  animating,
  doneAnimating,
}

class SlideUpdate {
  const SlideUpdate(
    this.updateType,
    this.direction,
    this.slidePercent,
  );

  final UpdateType updateType;
  final SlideDirection direction;
  final double slidePercent;
}
