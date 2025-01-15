import 'package:flutter/material.dart';
import 'home_page.dart';
import 'browse_page.dart';
import 'journal_page.dart';

class BaseScreen extends StatefulWidget {
  final int selectedIndex;

  const BaseScreen({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.selectedIndex;
  }

  void _onItemTapped(int index) {
    if (index != _currentIndex) {
      switch (index) {
        case 0:
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const MyHomePage()));
          break;
        case 1:
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) => const ExploreScreen()));
          break;
        case 2:
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) => const JournalScreen()));
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          MyHomePage(),
          ExploreScreen(),
          JournalScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type:
            BottomNavigationBarType.fixed, // Ensures navigation items are fixed
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Browse',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Journal',
          ),
        ],
      ),
    );
  }
}
