import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class BottomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onItemTapped;

  const BottomNavBar({super.key, required this.currentIndex, required this.onItemTapped});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black.withOpacity(0.1), Colors.black.withOpacity(0.8)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(50), // Kenarları daha yuvarlak yapmak için
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(context, "assets/icons/home.png", 'Anasayfa', 0),
            _buildNavItem(context, "assets/icons/profile.png", 'Profil', 1),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, String name, String label, int index) {
    final bool isActive = widget.currentIndex == index;
    return GestureDetector(
      onTap: () {
        widget.onItemTapped(index);
        if (index == 0) {
          context.go('/home');
        } else if (index == 1) {
          context.go('/profile');
        }
      },
      child: AnimatedContainer(
        height: 40.h,
        width: 125.w,
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: isActive ? Colors.white.withOpacity(0.9) : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          border: isActive ? Border.all(color: Colors.white, width: 1.5) : Border.all(color: Colors.white.withOpacity(0.2),  width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(name, color: isActive ? Colors.black : Colors.white,),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.black : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
