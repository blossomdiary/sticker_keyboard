import 'package:flutter/material.dart';
import 'package:sticker_keyboard_example/pages/custom_ui_example_page.dart';
import 'package:sticker_keyboard_example/pages/default_example_page.dart';

class ExampleHomePage extends StatelessWidget {
  const ExampleHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Sticker Keyboard Examples'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(DefaultExamplePage.routeName);
                  },
                  child: const Text('Default Example'),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(CustomUiExamplePage.routeName);
                  },
                  child: const Text('UI Custom Example'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
