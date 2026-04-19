import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fot_mob_app/models/index.dart';

class MatchCard extends StatelessWidget {
  final Match match;
  final VoidCallback onTap;

  const MatchCard({
    Key? key,
    required this.match,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final matchTime = DateTime.parse(match.utcDate);
    final formattedTime = DateFormat('HH:mm').format(matchTime);
    final formattedDate = DateFormat('MMM d').format(matchTime);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: match.isLive
                ? [Colors.red.shade400, Colors.red.shade600]
                : [Colors.blue.shade300, Colors.blue.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: (match.isLive ? Colors.red : Colors.blue)
                  .withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Background pattern
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Header with date and competition
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            match.competition.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            match.isLive
                                ? '🔴 LIVE'
                                : (match.isFinished ? 'FINISHED' : formattedTime),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Teams and Score
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Home Team
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                match.homeTeam.shortName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              if (match.homeTeam.crest != null)
                                Image.network(
                                  match.homeTeam.crest!,
                                  width: 40,
                                  height: 40,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.sports_soccer,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    );
                                  },
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
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (match.isFinished)
                                const Text(
                                  'FT',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        // Away Team
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                match.awayTeam.shortName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              if (match.awayTeam.crest != null)
                                Image.network(
                                  match.awayTeam.crest!,
                                  width: 40,
                                  height: 40,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.sports_soccer,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    );
                                  },
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Footer
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: Colors.white.withOpacity(0.8),
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          formattedDate,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Live indicator pulse
              if (match.isLive)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.5),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
