import 'dart:convert';
import 'package:http/http.dart' as http;

class Activity {
  final String title;
  final String description;
  final String category;

  Activity({
    required this.title,
    required this.description,
    required this.category,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? 'No Description',
      category: json['category'] ?? 'No Category',
    );
  }
}

class ActivityRepository {
  final String baseUrl = 'https://api-rarz3eo25q-uc.a.run.app/activities';

  Future<List<Activity>> fetchActivities(String selectedMood) async {
    try {
      final String apiUrl = '$baseUrl?moodTag=$selectedMood';
      //ignore: avoid_print
      print(selectedMood);
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final List<dynamic> activitiesList = jsonData['activities'];
        return activitiesList.map((item) => Activity.fromJson(item)).toList();
      } else {
        throw Exception('Failed to fetch activities. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching activities: $e');
    }
  }
}
