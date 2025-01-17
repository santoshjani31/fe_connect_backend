import 'package:flutter/material.dart';
import '../models/activity_model.dart';

class ActivityController extends ChangeNotifier {
  final ActivityRepository _repository = ActivityRepository();
  List<Activity> activities = [];
  bool isLoading = false;
  bool _hasLoadedActivities = false;

  bool get hasLoadedActivities => _hasLoadedActivities;

  Future<void> getActivities(String selectedMood) async {
    isLoading = true;
    notifyListeners();
    try {
      activities = await _repository.fetchActivities(selectedMood);
      _hasLoadedActivities = true;
    } catch (error) {
      _hasLoadedActivities = false;
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
