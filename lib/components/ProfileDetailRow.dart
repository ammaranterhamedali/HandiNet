import 'package:flutter/material.dart';

class ProfileDetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const ProfileDetailRow({
    required this.icon,
    required this.label,
    required this.value,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.teal),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '$label: $value',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    // overflow: TextOverflow.ellipsis,
                    // maxLines: 5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
