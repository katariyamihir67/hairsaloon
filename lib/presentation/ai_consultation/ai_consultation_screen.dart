import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/app_drawer.dart';

class AiConsultationScreen extends StatefulWidget {
  const AiConsultationScreen({super.key});

  @override
  State<AiConsultationScreen> createState() => _AiConsultationScreenState();
}

class _AiConsultationScreenState extends State<AiConsultationScreen> {
  bool _isGenerating = false;
  bool _isResultReady = false;

  void _generateStyle() async {
    setState(() {
      _isGenerating = true;
      _isResultReady = false;
    });

    // Simulate AI API delay
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      setState(() {
        _isGenerating = false;
        _isResultReady = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('AI Hair Consultation'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Upload your photo and let our AI suggest the perfect premium style for you.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
            ),
            const SizedBox(height: 24),
            
            if (!_isResultReady) ...[
              // Upload Placeholder
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.goldAccent.withOpacity(0.5), width: 1),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt, size: 48, color: AppColors.goldAccent),
                    SizedBox(height: 16),
                    Text('Tap to Take or Upload Photo', style: TextStyle(color: AppColors.textPrimary)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isGenerating ? null : _generateStyle,
                child: _isGenerating
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: AppColors.background, strokeWidth: 2)),
                          SizedBox(width: 12),
                          Text('ANALYZING FEATURES...'),
                        ],
                      )
                    : const Text('GENERATE STYLE'),
              ),
            ] else ...[
              // Result View
              const Text('Recommended Style', style: TextStyle(color: AppColors.goldAccent, fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/ai_preview.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(height: 300, color: AppColors.surface, child: const Center(child: Icon(Icons.broken_image, color: AppColors.textSecondary))),
                ),
              ),
              const SizedBox(height: 16),
              const Card(
                color: AppColors.surface,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Modern Balayage Layered Cut', style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text('Why it suits you:', style: TextStyle(color: AppColors.textSecondary)),
                      Text('• Complements your face shape\n• Enhances volume\n• Low maintenance coloring', style: TextStyle(color: AppColors.textPrimary)),
                      SizedBox(height: 16),
                      Text('Required Services:', style: TextStyle(color: AppColors.textSecondary)),
                      Text('Signature Haircut + Balayage Color', style: TextStyle(color: AppColors.goldAccent, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {},
                child: const Text('BOOK THIS STYLE'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => setState(() => _isResultReady = false),
                child: const Text('Try Another Style', style: TextStyle(color: AppColors.textSecondary)),
              )
            ]
          ],
        ),
      ),
    );
  }
}
