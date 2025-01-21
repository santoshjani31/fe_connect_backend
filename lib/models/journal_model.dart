import 'dart:convert';
import 'package:http/http.dart' as http;

class Journal {
  final String title;

  Journal({
    required this.title,
  });

  factory Journal.fromJson(Map<String, dynamic> json) {
    return Journal(
      title: json['title'] ?? 'No Title',
    );
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
        throw Exception('Failed to fetch journals. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching journals: $e');
    }
  }

}
