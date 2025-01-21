import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/activity_model.dart';

class ActivityDetailPage extends StatefulWidget {
  final Activity activity;

  const ActivityDetailPage({super.key, required this.activity});

  @override
  _ActivityDetailPageState createState() => _ActivityDetailPageState();
}

class _ActivityDetailPageState extends State<ActivityDetailPage> {
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;
  Activity? activity;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _fetchActivityDetails(widget.activity.title);
  }

  Future<void> _fetchActivityDetails(String title) async {
    final String apiUrl =
        'https://api-rarz3eo25q-uc.a.run.app/activities/${Uri.encodeComponent(title)}';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        if (jsonResponse.containsKey('activity')) {
          final Map<String, dynamic> activityData = jsonResponse['activity'];

          setState(() {
            activity = Activity.fromJson(activityData);
            print(activityData);
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = 'Activity data not found in response';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Failed to fetch activity details';
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        errorMessage = 'Error fetching activity details: $error';
        isLoading = false;
      });
    }
  }

  void _toggleAudio() async {
    if (activity == null || activity!.audioURL == null) return;
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(UrlSource(activity!.audioURL!));
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.activity.title)),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : activity == null
                  ? const Center(child: Text('Activity not found.'))
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: activity!.imageURL != null
                                  ? Image.network(
                                      activity!.imageURL!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: 200,
                                    )
                                  : Image.network(
                                      'https://via.placeholder.com/400x200?text=No+Image+Available',
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: 200,
                                    ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              activity!.title,
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Category: ${activity!.category}",
                              style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              activity!.description,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 8.0,
                              children: activity!.moodTag.map((mood) {
                                return Chip(
                                  label: Text(mood),
                                  backgroundColor: Colors.blue.withOpacity(0.2),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 16),
                            if (activity!.audioURL != null)
                              Column(
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: _toggleAudio,
                                    icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                                    label: Text(isPlaying ? "Pause Audio" : "Play Audio"),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
    );
  }
}
