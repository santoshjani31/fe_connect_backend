// import 'package:flutter/material.dart';
// import '../models/activity_model.dart';

// class ActivityDetailPage extends StatelessWidget {
//   final Activity activity;

//   const ActivityDetailPage({super.key, required this.activity});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(activity.title),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               activity.title,
//               style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               "Category: ${activity.category}",
//               style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               activity.description,
//               style: const TextStyle(fontSize: 16),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/activity_model.dart';

class ActivityDetailPage extends StatefulWidget {
  final Activity activity;

  const ActivityDetailPage({super.key, required this.activity});

  @override
  // ignore: library_private_types_in_public_api
  _ActivityDetailPageState createState() => _ActivityDetailPageState();
}

class _ActivityDetailPageState extends State<ActivityDetailPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;

  void _toggleAudio() async {
    if (widget.activity.audioUrl != null) {
      if (isPlaying) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.play(UrlSource(widget.activity.audioUrl!));
      }
      setState(() {
        isPlaying = !isPlaying;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No audio available for this activity")),
      );
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.activity.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image.asset(widget.activity.imageUrl),
            Image.asset('assets/activity_pics/${widget.activity.imageUrl}'),

            const SizedBox(height: 16),
            Text(
              widget.activity.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text("Category: ${widget.activity.category}"),
            Text("Difficulty: ${widget.activity.difficulty}"),
            Text("Duration: ${widget.activity.duration} seconds"),
            const SizedBox(height: 16),
            Text(widget.activity.description),
            const SizedBox(height: 32),
            if (widget.activity.audioUrl != null)
              Center(
                child: ElevatedButton.icon(
                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                  label: Text(isPlaying ? "Pause Audio" : "Play Audio"),
                  onPressed: _toggleAudio,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
