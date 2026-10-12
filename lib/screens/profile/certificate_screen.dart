import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_provider.dart';
import '../../services/progress_service.dart';
import 'dart:math' as math;

class CertificateScreen extends StatelessWidget {
  const CertificateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final progressProvider = Provider.of<ProgressProvider>(context, listen: false);
    
    final String name = authProvider.userName ?? 'Студент';
    final String level = progressProvider.progress.levelName;
    final int xp = progressProvider.progress.totalXp;
    
    // Generate a pseudo-random serial number based on name and xp
    final String serialNumber = 'SQL-${name.length.toString().padLeft(2, '0')}-${xp.toString().padLeft(4, '0')}-${DateTime.now().year}';

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text('Сіздің сертификатыңыз'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'Бөлісу (жақында)',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Веб-нұсқада экраннан скриншот жасаңыз!')),
              );
            },
          )
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: AspectRatio(
            aspectRatio: 1.414, // A4 landscape aspect ratio approx
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(100),
                    blurRadius: 20,
                    spreadRadius: 5,
                  )
                ],
                border: Border.all(color: Colors.amber[700]!, width: 8),
              ),
              child: Stack(
                children: [
                  // Corner decorations
                  Positioned(
                    top: 0, left: 0,
                    child: _buildCorner(math.pi / 2),
                  ),
                  Positioned(
                    top: 0, right: 0,
                    child: _buildCorner(math.pi),
                  ),
                  Positioned(
                    bottom: 0, left: 0,
                    child: _buildCorner(0),
                  ),
                  Positioned(
                    bottom: 0, right: 0,
                    child: _buildCorner(-math.pi / 2),
                  ),
                  
                  // Watermark
                  Center(
                    child: Opacity(
                      opacity: 0.05,
                      child: Icon(Icons.security, size: 300, color: Colors.blue[900]),
                    ),
                  ),
                  
                  // Content
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'СЕРТИФИКАТ',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A237E),
                            letterSpacing: 8,
                            fontFamily: 'serif',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'КУРСТЫ СӘТТІ АЯҚТАҒАНЫ ТУРАЛЫ',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 32),
                        const Text(
                          'Осы сертификат мына тұлғаның:',
                          style: TextStyle(fontSize: 14, color: Colors.black87, fontStyle: FontStyle.italic),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          name.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontFamily: 'serif',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'тақырыбы бойынша оқу мен тәжірибені сәтті өткенін растайды:',
                          style: TextStyle(fontSize: 14, color: Colors.black87, fontStyle: FontStyle.italic),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'РЕЛЯЦИЯЛЫҚ ДЕРЕКҚОРЛАР ЖӘНЕ SQL',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A237E),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text('Деңгей: $level', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
                                Text('Тәжірибе: $xp XP', style: const TextStyle(fontSize: 14, color: Colors.black54)),
                              ],
                            ),
                            Container(
                              width: 80,
                              height: 80,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.amber,
                              ),
                              child: const Icon(Icons.star, color: Colors.white, size: 50),
                            ),
                            Column(
                              children: [
                                Text('Күні: ${DateTime.now().day.toString().padLeft(2, '0')}.${DateTime.now().month.toString().padLeft(2, '0')}.${DateTime.now().year}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
                                Text('ID: $serialNumber', style: const TextStyle(fontSize: 10, color: Colors.black54)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCorner(double angle) {
    return Transform.rotate(
      angle: angle,
      child: Container(
        width: 100,
        height: 100,
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFF1A237E), width: 8),
            left: BorderSide(color: Color(0xFF1A237E), width: 8),
          ),
        ),
      ),
    );
  }
}
