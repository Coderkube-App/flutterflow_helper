import 'package:flutter/material.dart';
import 'screens.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterFlow Helpers Playground',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF818CF8), // Indigo 400
          secondary: Color(0xFF38BDF8), // Slate 900
          surface: Color(0xFF1E293B), // Slate 800
        ),
        useMaterial3: true,
        fontFamily: 'monospace', // Ideal for a developer tool
      ),
      home: const DemoHome(),
    );
  }
}

class DemoHome extends StatefulWidget {
  const DemoHome({super.key});

  @override
  State<DemoHome> createState() => _DemoHomeState();
}

class _DemoHomeState extends State<DemoHome> {
  int _page = 0;

  static const _pages = ['Safe Parsing Playground', 'Crash Simulator'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Premium High-Contrast Slate
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B), // Dark Slate AppBar
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF312E81), // Indigo 900
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFF4F46E5), width: 1),
              ),
              child: const Text(
                '🛡️ FF_HELPERS',
                style: TextStyle(
                  color: Color(0xFFC7D2FE),
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                  letterSpacing: 0.8,
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Playground',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF065F46), // Emerald 800
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'v1.0.0',
              style: TextStyle(
                color: Color(0xFFA7F3D0),
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: const Color(0xFF1E293B),
            child: Row(
              children: List.generate(_pages.length, (i) {
                final selected = i == _page;
                return Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _page = i),
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: selected
                                ? const Color(0xFF818CF8) // Glowing Indicator
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _pages[i].toUpperCase(),
                        style: TextStyle(
                          color: selected
                              ? Colors.white
                              : const Color(
                                  0xFF94A3B8), // High contrast selected vs unselected
                          fontWeight:
                              selected ? FontWeight.w900 : FontWeight.w500,
                          fontSize: 11,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
      body: IndexedStack(
        index: _page,
        children: const [
          SafeParsingScreen(),
          CrashPreventionScreen(),
        ],
      ),
    );
  }
}
