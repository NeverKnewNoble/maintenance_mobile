import 'package:flutter/material.dart';
import 'package:ex_maintenance/components/app_colors.dart';
import 'package:ex_maintenance/intro_pages/login.dart';

class LeftNavigation extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const LeftNavigation({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: AppColors.coolGreen,
      child: Column(
        children: [
          const SizedBox(height: 40),
          // App Logo or Title
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Ex Maintenance',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const SizedBox(height: 20),
          // Navigation Items
          _buildNavItem(
            context,
            0,
            'Home',
            Icons.home,
            selectedIndex == 0,
          ),
          _buildNavItem(
            context,
            1,
            'Ex Work Order',
            Icons.work,
            selectedIndex == 1,
          ),
          const Spacer(), // This will push the logout button to the bottom
          _buildNavItem(
            context,
            2,
            'Logout',
            Icons.logout,
            selectedIndex == 2,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    int index,
    String title,
    IconData icon,
    bool isSelected,
  ) {
    return InkWell(
      onTap: () {
        if (index == 2) {
          // Handle logout
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (route) => false,
          );
        } else {
          onItemSelected(index);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
