import 'package:flutter/material.dart';
//import 'home_page.dart';
import 'basescreen.dart';

class MoodsPage extends StatelessWidget {
  const MoodsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Your Mood')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BaseScreen(),
                  ),
                );
              },
              child: const Text('Happy'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const BaseScreen()),
                );
              },
              child: const Text('Anxious'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BaseScreen(),
                  ),
                );
              },
              child: const Text('Stressed'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BaseScreen(),
                  ),
                );
              },
              child: const Text('Sad'),
            ),
          ],
        ),
      ),
    );
  }
}
