import 'package:flutter/material.dart';
import 'basescreen.dart';

class MoodsPage extends StatelessWidget {
  const MoodsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Select Your Mood'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "How are you feeling today ...",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20), 
            GridView.count(
              crossAxisCount: 2, 
              shrinkWrap: true,
              crossAxisSpacing: 16.0, 
              mainAxisSpacing: 16.0,
              children: [
                _buildMoodButton(
                  context,
                  label: 'Happy',
                  color: Colors.yellow.shade300,
                ),
                _buildMoodButton(
                  context,
                  label: 'Anxious',
                  color: Colors.blue.shade200,
                ),
                _buildMoodButton(
                  context,
                  label: 'Stressed',
                  color: Colors.red.shade200,
                ),
                _buildMoodButton(
                  context,
                  label: 'Sad',
                  color: Colors.purple.shade200,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodButton(BuildContext context,
      {required String label, required Color color}) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const BaseScreen(),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 5,
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}
