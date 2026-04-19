import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fot_mob_app/providers/standings_provider.dart';
import 'package:fot_mob_app/widgets/index.dart';

class StandingsScreen extends StatefulWidget {
  const StandingsScreen({Key? key}) : super(key: key);

  @override
  State<StandingsScreen> createState() => _StandingsScreenState();
}

class _StandingsScreenState extends State<StandingsScreen> {
  String _selectedCompetition = 'PL'; // Premier League

  final Map<String, String> competitions = {
    'PL': 'Premier League',
    'LA': 'La Liga',
    'SA': 'Serie A',
    'BL1': 'Bundesliga',
    'FR1': 'Ligue 1',
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StandingsProvider>(context, listen: false)
          .fetchStandings(_selectedCompetition);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.green.shade600,
        title: const Text(
          'League Standings',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Competition Selector
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.green.shade50,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: competitions.entries.map((entry) {
                  final isSelected = entry.key == _selectedCompetition;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(entry.value),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCompetition = entry.key;
                        });
                        Provider.of<StandingsProvider>(context, listen: false)
                            .fetchStandings(entry.key);
                      },
                      backgroundColor: Colors.white,
                      selectedColor: Colors.green.shade600,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey.shade700,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          // Standings List
          Expanded(
            child: Consumer<StandingsProvider>(
              builder: (context, standingsProvider, _) {
                if (standingsProvider.isLoading) {
                  return const LoadingShimmer();
                }

                final standings =
                    standingsProvider.getStandingsByCompetition(_selectedCompetition);

                if (standings.isEmpty) {
                  return Center(
                    child: Text(
                      'No standings data',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => standingsProvider.fetchStandings(_selectedCompetition),
                  child: ListView.builder(
                    itemCount: standings.length,
                    itemBuilder: (context, index) {
                      return StandingRow(standing: standings[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
