import 'dart:convert';

import 'package:http/http.dart' as http;

class Activity {
  final String title;
  final String description;
  final String category;
  final String? audioUrl;
  final String imageUrl;
  final int duration;
  final String difficulty;
  final List<String> moodTags;

  Activity({
    required this.title,
    required this.description,
    required this.category,
    this.audioUrl,
    required this.imageUrl,
    required this.duration,
    required this.difficulty,
    required this.moodTags,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? 'No Description',
      category: json['category'] ?? 'No Category',
      audioUrl: json['audioURL'] is String
          ? json['audioURL']
          : null, // Handle false values
      imageUrl: json['imageURL'] ?? '',
      duration: json['duration'] ?? 0,
      difficulty: json['difficulty'] ?? 'unknown',
      moodTags: List<String>.from(json['moodTag'] ?? []),
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
        final dynamic jsonData = json.decode(response.body);

        if (jsonData is Map<String, dynamic> &&
            jsonData.containsKey('activities')) {
          final List<dynamic> activitiesList = jsonData['activities'];
          return activitiesList.map((item) => Activity.fromJson(item)).toList();

        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to fetch activities. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching activities: $e');
    }
  } 
}



