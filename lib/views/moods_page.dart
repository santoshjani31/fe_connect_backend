import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MoodProvider with ChangeNotifier {
  String _selectedMood = "";

  String get selectedMood => _selectedMood;

  void updateMood(String mood) {
    _selectedMood = mood;
    notifyListeners();
  }
}

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
              "How are you feeling today?",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              children: [
                _buildMoodButton(context, 'happy', Colors.yellow.shade300),
                _buildMoodButton(context, 'anxious', Colors.blue.shade200),
                _buildMoodButton(context, 'stressed', Colors.red.shade200),
                _buildMoodButton(context, 'sad', Colors.purple.shade200),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodButton(BuildContext context, String label, Color color) {
    return ElevatedButton(
      onPressed: () {
        Provider.of<MoodProvider>(context, listen: false).updateMood(label);
        Navigator.pushReplacementNamed(context, '/home');
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
