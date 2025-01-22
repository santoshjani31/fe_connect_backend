import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
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
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;
      _journalController =
          Provider.of<JournalController>(context, listen: false);
      _journalController.getJournals(uid);
    }
  }

  Future<void> _refreshJournalList() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;
      await _journalController.getJournals(uid);
    }
  }

  Future<void> _deleteJournalEntry(String journalId) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final uid = user.uid;
        final String baseUrl = 'https://api-rarz3eo25q-uc.a.run.app';
        final String endpoint = '/user/$uid/journal/$journalId';
        final Uri url = Uri.parse(baseUrl + endpoint);

        final response = await http.delete(
          url,
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200 || response.statusCode == 204) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("Journal entry deleted successfully!")),
          );
          await _refreshJournalList();
        } else {
          throw Exception(
              'Failed to delete journal entry: ${response.statusCode}');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User not authenticated")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete journal entry: $e")),
      );
    }
  }

// Show dialog to edit journal entry
  Future<void> _showEditJournalDialog(
      String journalId, String initialTitle, String initialBody) async {
    final _titleController = TextEditingController(text: initialTitle);
    final _descriptionController = TextEditingController(text: initialBody);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Journal Entry"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Title"),
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
                maxLines: 4,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                try {
                  final user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    final uid = user.uid;
                    final journalRef = FirebaseFirestore.instance
                        .collection('users')
                        .doc(uid)
                        .collection('journal')
                        .doc(journalId);

                    await journalRef.update({
                      'title': _titleController.text,
                      'body': _descriptionController.text,
                      'timestamp': FieldValue.serverTimestamp(),
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Journal entry updated!")),
                    );
                    Navigator.pop(context); // Close the dialog
                    await _refreshJournalList(); // Refresh the journal list
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("User not authenticated")),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text("Failed to update journal entry: $e")),
                  );
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
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
              onPressed: () async {
                final isEntryAdded = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddJournalEntryScreen(
                        onEntryAdded: _refreshJournalList),
                  ),
                );

                if (isEntryAdded == true) {
                  await _refreshJournalList();
                }
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
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () async {
                                // Show the edit dialog
                                await _showEditJournalDialog(
                                  journal.id,
                                  journal.title,
                                  journal.body,
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text("Delete Journal Entry"),
                                    content: const Text(
                                        "Are you sure you want to delete this journal entry?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        child: const Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
                                        child: const Text("Delete"),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirm == true) {
                                  await _deleteJournalEntry(journal.id);
                                }
                              },
                            ),
                          ],
                        ),
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
  final VoidCallback onEntryAdded;

  const AddJournalEntryScreen({super.key, required this.onEntryAdded});

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

          // Add the journal entry and get the document reference
          final docRef = await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .collection('journal')
              .add({
            'title': _titleController.text,
            'body': _descriptionController.text,
            'mood': _selectedMood,
            'timestamp': FieldValue.serverTimestamp(),
          });
          print(docRef.id);
          // Update the document with its own ID
          await docRef.set({
            'id': docRef.id, // Set the 'id' field to the document ID
            'title': _titleController.text,
            'body': _descriptionController.text,
            'mood': _selectedMood,
            'timestamp': FieldValue.serverTimestamp(),
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Journal entry added successfully!")),
          );
          Navigator.pop(context, true); // Notify the previous screen of success
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
