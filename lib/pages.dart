import 'package:flutter/material.dart';

final List<PageViewModel> pages = [
  const PageViewModel(
      Color(0xFF678FB4),
      'assets/hotels.png',
      'Hotels',
      'All hotels and hostels are sorted by hospitality rating',
      'assets/key.png'),
  const PageViewModel(
      Color(0xFF65B0B4),
      'assets/banks.png',
      'Banks',
      'We carefully verify all banks before adding them into the app',
      'assets/wallet.png'),
  const PageViewModel(
    Color(0xFF9B90BC),
    'assets/stores.png',
    'Store',
    'All local stores are categorized for your convenience',
    'assets/shopping_cart.png',
  ),
];

class Page extends StatelessWidget {
  const Page({
    @required this.viewModel,
    this.percentVisible = 1.0,
  });

  final PageViewModel viewModel;
  final double percentVisible;

  @override
  Widget build(BuildContext context) => Container(
      width: double.infinity,
      color: viewModel.color,
      child: Opacity(
        opacity: percentVisible,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Transform(
            transform:
                Matrix4.translationValues(0, 50.0 * (1.0 - percentVisible), 0),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 25),
              child:
                  Image.asset(viewModel.heroAssetPath, width: 200, height: 200),
            ),
          ),
          Transform(
            transform:
                Matrix4.translationValues(0, 30.0 * (1.0 - percentVisible), 0),
            child: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Text(
                viewModel.title,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'FlamanteRoma',
                  fontSize: 34,
                ),
              ),
            ),
          ),
          Transform(
            transform:
                Matrix4.translationValues(0, 30.0 * (1.0 - percentVisible), 0),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 75),
              child: Text(
                viewModel.body,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ]),
      ));
}

class PageViewModel {
  const PageViewModel(
    this.color,
    this.heroAssetPath,
    this.title,
    this.body,
    this.iconAssetPath,
  );

  final Color color;
  final String heroAssetPath;
  final String title;
  final String body;
  final String iconAssetPath;
}
