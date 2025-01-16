import 'package:flutter/material.dart';

class JournalScreen extends StatelessWidget {
  const JournalScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Journal")),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              
            },
            child: Text("Add New Entry"),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text("Journal Entry ${index + 1}"),
                  subtitle: Text("Preview of entry text..."),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
