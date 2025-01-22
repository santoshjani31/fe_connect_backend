import 'package:flutter/material.dart';
import '../models/journal_model.dart';

class JournalController extends ChangeNotifier {
  final JournalRepository _repository = JournalRepository();
  List<Journal> journals = [];
  bool isLoading = false;

  Future<void> getJournals(String userId) async {
    debugPrint("Fetching journals for user: $userId");
    isLoading = true;
    notifyListeners();
    try {
      journals = await _repository.fetchJournals(userId);
    } catch (error) {
      journals = []; // Ensure the list is empty in case of an error
      debugPrint("Error fetching journals: $error");
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteJournal(String userId, String journalId) async {
    try {
      await _repository.deleteJournal(userId, journalId);
      journals.removeWhere(
          (journal) => journal.id == journalId); // Remove from list
      notifyListeners(); // Notify UI to update
    } catch (e) {
      throw Exception("Error deleting journal entry: $e");
    }
  }
}
