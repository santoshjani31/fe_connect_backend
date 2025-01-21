import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/journal_controller.dart';


class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  late JournalController _journalController;

  @override
  void initState() {
    super.initState();
    _journalController = Provider.of<JournalController>(context, listen: false);
    _journalController.getJournals("0"); // Replace "0" with the actual user ID if needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Journal"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Navigate to a new screen for creating a journal entry
                Navigator.pushNamed(context, '/add_journal');
              },
              child: const Text("Add New Entry"),
            ),
          ),
          Expanded(
            child: Consumer<JournalController>(
              builder: (context, controller, child) {
                if (controller.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (controller.journals.isEmpty) {
                  return const Center(
                    child: Text("No journal entries available"),
                  );
                }

                return ListView.builder(
                  itemCount: controller.journals.length,
                  itemBuilder: (context, index) {
                    final journal = controller.journals[index];
                    return Card(
                      margin: const EdgeInsets.all(8),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        title: Text(
                          journal.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: const Text("Tap to view details"),
                        onTap: () {
                          // Define the behavior when a journal is tapped, e.g., navigate to a detail page
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}