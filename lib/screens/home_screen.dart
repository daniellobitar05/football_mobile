import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fot_mob_app/providers/index.dart';
import 'package:fot_mob_app/widgets/index.dart';
import 'match_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MatchesProvider>(context, listen: false).fetchMatches();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.blue.shade600,
          title: const Text(
            'Football Live',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: '🔴 LIVE'),
              Tab(text: '📅 SCHEDULED'),
              Tab(text: '✅ FINISHED'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildMatchTab('LIVE'),
            _buildMatchTab('SCHEDULED'),
            _buildMatchTab('FINISHED'),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchTab(String status) {
    return Consumer<MatchesProvider>(
      builder: (context, matchesProvider, _) {
        if (matchesProvider.error != null) {
          return _buildErrorState(context, matchesProvider);
        }

        if (matchesProvider.isLoading) {
          return const LoadingShimmer();
        }

        final matches = matchesProvider.getMatchesByStatus(status);

        if (matches.isEmpty) {
          return _buildEmptyState(context, status);
        }

        return RefreshIndicator(
          onRefresh: () => matchesProvider.fetchMatches(),
          child: ListView.builder(
            itemCount: matches.length,
            itemBuilder: (context, index) {
              final match = matches[index];
              return MatchCard(
                match: match,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MatchDetailsScreen(match: match),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildErrorState(BuildContext context, MatchesProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
          const SizedBox(height: 16),
          Text(
            'Error Loading Matches',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              provider.error ?? 'Unknown error',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => provider.fetchMatches(),
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String status) {
    IconData icon;
    String text;
    
    switch (status) {
      case 'LIVE':
        icon = Icons.sports_soccer;
        text = 'No live matches';
        break;
      case 'SCHEDULED':
        icon = Icons.calendar_today;
        text = 'No scheduled matches';
        break;
      default:
        icon = Icons.check_circle;
        text = 'No finished matches';
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            text,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Provider.of<MatchesProvider>(context, listen: false)
                  .fetchMatches();
            },
            child: const Text('Load Matches'),
          ),
        ],
      ),
    );
  }
}
