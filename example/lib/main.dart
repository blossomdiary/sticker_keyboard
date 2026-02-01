import 'package:flutter/material.dart';
import 'package:sticker_keyboard_example/pages/custom_ui_example_page.dart';
import 'package:sticker_keyboard_example/pages/default_example_page.dart';
import 'package:sticker_keyboard_example/pages/example_home_page.dart';
import 'package:sticker_keyboard_example/pages/lottie_network_example_page.dart';

void main() {
  runApp(
    const MaterialApp(
      home: ExampleHomePage(),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: _onGenerateRoute,
    ),
  );
}

Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case DefaultExamplePage.routeName:
      return MaterialPageRoute(
        builder: (_) => const DefaultExamplePage(),
        settings: settings,
      );
    case CustomUiExamplePage.routeName:
      return MaterialPageRoute(
        builder: (_) => const CustomUiExamplePage(),
        settings: settings,
      );
    case LottieNetworkExamplePage.routeName:
      return MaterialPageRoute(
        builder: (_) => const LottieNetworkExamplePage(),
        settings: settings,
      );
  }
  return null;
}
