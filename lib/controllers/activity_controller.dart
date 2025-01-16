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
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}


