import 'dart:convert';
import 'package:http/http.dart' as http;

class Activity {
  final String title;
  final String description;
  final String category;
  final String? audioURL;
  final String? imageURL; 
  final List<String> moodTag;

  Activity({
    required this.title,
    required this.description,
    required this.category,
    required this.audioURL,
    required this.imageURL,
    required this.moodTag,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? 'No Description',
      category: json['category'] ?? 'No Category',
      audioURL: json['audioURL'] is String ? json['audioURL'] : null,
      imageURL: json['imageURL'] is String ? json['imageURL'] : null,
      moodTag: List<String>.from(json['moodTag'] ?? []),
    );
  }
}

class ActivityRepository {
  final String baseUrl = 'https://api-rarz3eo25q-uc.a.run.app/activities';

  Future<List<Activity>> fetchActivities(String selectedMood) async {
    try {
      final String apiUrl = '$baseUrl?moodTag=$selectedMood';
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

  Future<Activity> fetchActivityByTitle(String title) async {
    try {
      final String apiUrl = '$baseUrl?title=${Uri.encodeComponent(title)}';
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          return Activity.fromJson(data[0]);
        } else {
          throw Exception('Activity not found');
        }
      } else {
        throw Exception('Failed to fetch activity details. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching activity details: $e');
    }
  }
}
