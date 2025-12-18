import 'package:flutter/material.dart';

class UpcomingBookingCard extends StatelessWidget {
  const UpcomingBookingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      margin: EdgeInsets.fromLTRB(10, 9, 10, 9),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.assignment_outlined,
                  color: Color(0xFF006BAA),
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  "Upcoming Booking",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF006BAA),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Service Title
            const Text(
              "AC Repair",
              style: TextStyle(
                fontSize: 20,
                fontFamily: "Inter Bold",
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),

            // Separator Line
            Divider(color: Colors.grey.shade200, thickness: 1),
            const SizedBox(height: 8),

            Row(
              children: [
                const Icon(
                  Icons.calendar_month_outlined,
                  size: 18,
                  color: Colors.black54,
                ),
                const SizedBox(width: 6),
                const Text(
                  "Wed April 23, 2025",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),

                const Spacer(),

                const Icon(
                  Icons.access_time_outlined,
                  size: 18,
                  color: Colors.black54,
                ),
                const SizedBox(width: 6),
                const Text(
                  "11:30 AM",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
