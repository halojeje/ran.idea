import 'package:flutter/material.dart';
import 'package:ran_idea_flutter/day_20/views/dashboardpage.dart';
import 'package:ran_idea_flutter/day_20/views/favoritpage.dart';
import 'package:ran_idea_flutter/day_20/views/katalogpage.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    Dashboardpage(),
    Katalogpage(),
    Favoritpage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // MENGGUNAKAN INDEXEDSTACK AGAR STATE SETIAP PAGE TETAP TERSIMPAN
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: Container(
        height: 65,
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.black, width: 2)),
        ),
        child: Row(
          children: [
            _buildNavItem(
              index: 0,
              label: 'GENERATOR',
              icon: Icons.auto_awesome,
              backgroundColor: const Color(0xFFFFC107),
            ),
            _buildNavItem(
              index: 1,
              label: 'KATALOG',
              icon: Icons.grid_view,
              backgroundColor: const Color(0xFFFFC107),
            ),
            _buildNavItem(
              index: 2,
              label: 'FAVORIT',
              icon: Icons.favorite,
              backgroundColor: const Color(0xFFFFC107),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String label,
    required IconData icon,
    required Color backgroundColor,
  }) {
    final bool isSelected = _selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFFFFC107)
                : const Color(0xFFE0E0E0),
            border: Border(
              right: index < 2
                  ? const BorderSide(color: Colors.black, width: 1.5)
                  : BorderSide.none,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.black, size: 22),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontFamily:
                      (label == 'GENERATOR' ||
                          label == 'KATALOG' ||
                          label == 'FAVORIT')
                      ? 'Montserrat-Regular'
                      : null,
                  color: Colors.black,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
