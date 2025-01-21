import 'package:flutter/material.dart';
import '../models/journal_model.dart';

class JournalController extends ChangeNotifier {
  final JournalRepository _repository = JournalRepository();
  List<Journal> journals = [];
  bool isLoading = false;

  Future<void> getJournals(String userId) async {
    debugPrint("Error fetching journals: $userId");
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

}
