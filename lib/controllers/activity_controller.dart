import 'package:flutter/material.dart';
import '../models/activity_model.dart';

class ActivityController extends ChangeNotifier {
  final ActivityRepository _repository = ActivityRepository();
  List<Activity> activities = [];
  bool isLoading = false;

  Future<void> getActivities() async {
    isLoading = true;
    notifyListeners();
    try {
      activities = await _repository.fetchActivities();
    } catch (e) {
      // Handle errors (logging can be added here)
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
