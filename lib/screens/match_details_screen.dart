import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fot_mob_app/models/index.dart';

class MatchDetailsScreen extends StatelessWidget {
  final Match match;

  const MatchDetailsScreen({
    Key? key,
    required this.match,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final matchTime = DateTime.parse(match.utcDate);
    final formattedTime = DateFormat('HH:mm, MMM d, yyyy').format(matchTime);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue.shade600,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Match Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Score Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: match.isLive
                      ? [Colors.red.shade400, Colors.red.shade600]
                      : [Colors.blue.shade300, Colors.blue.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  // Competition Badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      match.competition.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Teams and Score
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Home Team
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (match.homeTeam.crest != null)
                              Image.network(
                                match.homeTeam.crest!,
                                width: 60,
                                height: 60,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.sports_soccer,
                                      color: Colors.white,
                                      size: 36,
                                    ),
                                  );
                                },
                              ),
                            const SizedBox(height: 12),
                            Text(
                              match.homeTeam.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      // Score
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            Text(
                              '${match.score.homeGoals} - ${match.score.awayGoals}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                match.isLive
                                    ? '🔴 LIVE'
                                    : (match.isFinished ? 'FINISHED' : 'SCHEDULED'),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Away Team
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (match.awayTeam.crest != null)
                              Image.network(
                                match.awayTeam.crest!,
                                width: 60,
                                height: 60,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.sports_soccer,
                                      color: Colors.white,
                                      size: 36,
                                    ),
                                  );
                                },
                              ),
                            const SizedBox(height: 12),
                            Text(
                              match.awayTeam.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Details Section
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Match Time
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          color: Colors.blue.shade600,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Match Date & Time',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                formattedTime,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Stats Grid
                  if (match.isFinished)
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      children: [
                        _buildStatCard(
                          'Home Goals',
                          match.score.homeGoals.toString(),
                          Colors.blue,
                        ),
                        _buildStatCard(
                          'Away Goals',
                          match.score.awayGoals.toString(),
                          Colors.green,
                        ),
                      ],
                    ),
                  const SizedBox(height: 24),
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Added to favorites!'),
                              ),
                            );
                          },
                          icon: const Icon(Icons.favorite_border),
                          label: const Text('Add to Favorites'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade600,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Notification enabled for this match!'),
                              ),
                            );
                          },
                          icon: const Icon(Icons.notifications_none),
                          label: const Text('Notify Me'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade600,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
