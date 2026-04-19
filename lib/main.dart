import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fot_mob_app/screens/index.dart';
import 'package:fot_mob_app/providers/index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase here (once you set it up)
  // await FirebaseService().initializeFirebase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MatchesProvider()),
        ChangeNotifierProvider(create: (_) => StandingsProvider()),
      ],
      child: MaterialApp(
        title: 'Football Live',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
          appBarTheme: AppBarTheme(
            elevation: 0,
            centerTitle: false,
            iconTheme: const IconThemeData(color: Colors.white),
            titleTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          scaffoldBackgroundColor: Colors.grey.shade50,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.dark,
          ),
          scaffoldBackgroundColor: Colors.grey.shade900,
        ),
        home: const MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const StandingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: Colors.white,
          indicatorColor: Colors.blue.shade100,
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Matches',
            ),
            NavigationDestination(
              icon: Icon(Icons.bar_chart_outlined),
              selectedIcon: Icon(Icons.bar_chart),
              label: 'Standings',
            ),
          ],
        ),
      ),
    );
  }
}
