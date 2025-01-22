import 'dart:convert';
import 'package:http/http.dart' as http;

class Journal {
  final String id; // Add this field for the ID
  final String title;
  final String body;
  final String mood;
  final dynamic timestamp;

  Journal({
    required this.id, // Pass id when creating a Journal object
    required this.title,
    required this.body,
    required this.mood,
    required this.timestamp,
  });

  factory Journal.fromJson(Map<dynamic, dynamic> json) {
    return Journal(
      id: json['id'] ?? '', // Assuming the API sends 'id'
      title: json['title'] ?? 'No Title',
      body: json['body'] ?? 'No Description',
      mood: json['mood'] ?? 'Unknown Mood',
      timestamp: json['timestamp'] ?? 'Unknown Timestamp',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id, // Include 'id' in the JSON payload if needed
      'title': title,
      'body': body,
      'mood': mood,
      'timestamp': timestamp,
    };
  }
}

class JournalRepository {
  final String baseUrl = 'https://api-rarz3eo25q-uc.a.run.app';

  Future<List<Journal>> fetchJournals(String userId) async {
    try {
      final String apiUrl = '$baseUrl/user/$userId/journal';
      final response = await http.get(Uri.parse(apiUrl));
      print('API Response: ${response.body}');

      if (response.statusCode == 200) {
        // Decode the response and extract the "entries" list
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final List<dynamic> entries = jsonData['entries'];
        print('Extracted Entries: $entries');
        // Map the entries list to Journal objects
        return entries.map((item) => Journal.fromJson(item)).toList();
      } else {
        throw Exception(
            'Failed to fetch journals. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching journals: $e');
    }
  }

  Future<void> deleteJournal(String userId, String journalId) async {
    try {
      final String apiUrl = '$baseUrl/user/$userId/journal/$journalId';
      final response = await http.delete(Uri.parse(apiUrl));

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception(
            'Failed to delete journal entry: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting journal: $e');
    }
  }
}
