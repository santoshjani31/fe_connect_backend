import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final uid = user.uid;
    super.initState();
    _journalController = Provider.of<JournalController>(context, listen: false);
    _journalController.getJournals(uid); // Replace "0" with the actual user ID if needed
  }
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
                // Navigate to the form screen for creating a journal entry
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddJournalEntryScreen(),
                  ),
                );
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
                        subtitle: Text(journal.mood),
                        onTap: () {
                          // Define the behavior when a journal is tapped
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

class AddJournalEntryScreen extends StatefulWidget {
  const AddJournalEntryScreen({super.key});

  @override
  State<AddJournalEntryScreen> createState() => _AddJournalEntryScreenState();
}

class _AddJournalEntryScreenState extends State<AddJournalEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedMood = "happy";

  Future<void> _submitJournalEntry() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final uid = user.uid;
          print("The authenticated userid is: $uid");

          await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .collection('journal')
              .add({
            'title': _titleController.text,
            'body': _descriptionController.text,
            'mood': _selectedMood,
            'timestamp': FieldValue.serverTimestamp(),
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Journal entry added successfully!")),
          );
          Navigator.pop(context); // Go back to the journal list
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("User not authenticated")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to add journal entry: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Journal Entry"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Title"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a title";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a description";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: _selectedMood,
                onChanged: (value) {
                  setState(() {
                    _selectedMood = value!;
                  });
                },
                items: const [
                  DropdownMenuItem(
                    value: "happy",
                    child: Text("Happy"),
                  ),
                  DropdownMenuItem(
                    value: "anxious",
                    child: Text("Anxious"),
                  ),
                  DropdownMenuItem(
                    value: "stressed",
                    child: Text("Stressed"),
                  ),
                  DropdownMenuItem(
                    value: "sad",
                    child: Text("Sad"),
                  ),
                ],
                decoration: const InputDecoration(labelText: "Mood"),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _submitJournalEntry,
                child: const Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
