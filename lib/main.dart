import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'services/wallet_service.dart';
import 'screens/home/home_screen.dart';
import 'screens/transactions/transaction_history_screen.dart';
import 'screens/qr/qr_pay_screen.dart';
import 'screens/profile/profile_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => WalletService(),
      child: const BonePayApp(),
    ),
  );
}

class BonePayApp extends StatelessWidget {
  const BonePayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BonePay Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1565C0),
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F9FC),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      home: const BonePayShell(),
    );
  }
}

class BonePayShell extends StatefulWidget {
  const BonePayShell({super.key});

  @override
  State<BonePayShell> createState() => _BonePayShellState();
}

class _BonePayShellState extends State<BonePayShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    TransactionHistoryScreen(),
    QrPayScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Transactions',
          ),
          NavigationDestination(
            icon: Icon(Icons.qr_code_2),
            label: 'QR Pay',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}