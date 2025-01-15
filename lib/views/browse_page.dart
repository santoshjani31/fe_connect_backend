import 'package:flutter/material.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key}); // Simplified constructor
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Explore")),
      body: GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: 8, // Sample number of activities
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(8),
            child: Center(child: Text("Activity ${index + 1}")),
          );
        },
      ),
    );
  }
}
