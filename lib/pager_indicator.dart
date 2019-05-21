import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:material_page_reveal_published/pages.dart';

class PagerIndicator extends StatelessWidget {
  const PagerIndicator({
    @required this.viewModel,
  });

  final PagerIndicatorViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final bubbles = <PageBubble>[];
    for (var i = 0; i < viewModel.pages.length; ++i) {
      final page = viewModel.pages[i];

      double percentActive;
      if (i == viewModel.activeIndex) {
        percentActive = 1.0 - viewModel.slidePercent;
      } else if (i == viewModel.activeIndex - 1 &&
          viewModel.slideDirection == SlideDirection.leftToRight) {
        percentActive = viewModel.slidePercent;
      } else if (i == viewModel.activeIndex + 1 &&
          viewModel.slideDirection == SlideDirection.rightToLeft) {
        percentActive = viewModel.slidePercent;
      } else {
        percentActive = 0.0;
      }

      final isHollow = i > viewModel.activeIndex ||
          (i == viewModel.activeIndex &&
              viewModel.slideDirection == SlideDirection.leftToRight);

      bubbles.add(
        PageBubble(
          viewModel: PageBubbleViewModel(
            page.iconAssetPath,
            page.color,
            isHollow,
            percentActive,
          ),
        ),
      );
    }

    const bubbleWidth = 55.0;
    final baseTranslation =
        ((viewModel.pages.length * bubbleWidth) / 2) - (bubbleWidth / 2);
    var translation = baseTranslation - (viewModel.activeIndex * bubbleWidth);
    if (viewModel.slideDirection == SlideDirection.leftToRight) {
      translation += bubbleWidth * viewModel.slidePercent;
    } else if (viewModel.slideDirection == SlideDirection.rightToLeft) {
      translation -= bubbleWidth * viewModel.slidePercent;
    }

    return Column(
      children: [
        Expanded(child: Container()),
        Transform(
          transform: Matrix4.translationValues(translation, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: bubbles,
          ),
        ),
      ],
    );
  }
}

enum SlideDirection {
  leftToRight,
  rightToLeft,
  none,
}

class PagerIndicatorViewModel {
  const PagerIndicatorViewModel(
    this.pages,
    this.activeIndex,
    this.slideDirection,
    this.slidePercent,
  );

  final List<PageViewModel> pages;
  final int activeIndex;
  final SlideDirection slideDirection;
  final double slidePercent;
}

class PageBubble extends StatelessWidget {
  const PageBubble({
    @required this.viewModel,
  });

  final PageBubbleViewModel viewModel;

  @override
  Widget build(BuildContext context) => Container(
        width: 55,
        height: 65,
        child: Center(
          child: Container(
            width: ui.lerpDouble(20.0, 45.0, viewModel.activePercent),
            height: ui.lerpDouble(20.0, 45.0, viewModel.activePercent),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: viewModel.isHollow
                  ? const Color(0x88FFFFFF)
                      .withAlpha((0x88 * viewModel.activePercent).round())
                  : const Color(0x88FFFFFF),
              border: Border.all(
                color: viewModel.isHollow
                    ? const Color(0x88FFFFFF).withAlpha(
                        (0x88 * (1.0 - viewModel.activePercent)).round())
                    : Colors.transparent,
                width: 3,
              ),
            ),
            child: Opacity(
              opacity: viewModel.activePercent,
              child: Image.asset(
                viewModel.iconAssetPath,
                color: viewModel.color,
              ),
            ),
          ),
        ),
      );
}

class PageBubbleViewModel {
  const PageBubbleViewModel(
    this.iconAssetPath,
    this.color,
    // ignore: avoid_positional_boolean_parameters
    this.isHollow,
    this.activePercent,
  );

  final String iconAssetPath;
  final Color color;
  final bool isHollow;
  final double activePercent;
}
