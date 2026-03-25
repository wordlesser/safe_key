import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../shared/constants/app_theme.dart';
import '../controller/auth_controller.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<_WelcomeSlide> _buildSlides(AppLocalizations l10n) => [
        _WelcomeSlide(
          icon: Icons.lock_outline_rounded,
          iconColor: AppColors.primary,
          title: l10n.welcomeSlide1Title,
          subtitle: l10n.welcomeSlide1Subtitle,
        ),
        _WelcomeSlide(
          icon: Icons.face_retouching_natural,
          iconColor: AppColors.secondary,
          title: l10n.welcomeSlide2Title,
          subtitle: l10n.welcomeSlide2Subtitle,
        ),
        _WelcomeSlide(
          icon: Icons.security_rounded,
          iconColor: AppColors.success,
          title: l10n.welcomeSlide3Title,
          subtitle: l10n.welcomeSlide3Subtitle,
        ),
      ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final slides = _buildSlides(l10n);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Logo
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: const Icon(
                      Icons.key_rounded,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'SafeKey',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            // 滑动页
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: slides.length,
                itemBuilder: (context, index) =>
                    _SlideView(slide: slides[index]),
              ),
            ),
            // 页码指示器
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                slides.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: i == _currentPage ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: i == _currentPage
                        ? AppColors.primary
                        : AppColors.border,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            // 按钮
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      context.read<AuthController>().proceedToSetup();
                    },
                    child: Text(l10n.getStarted),
                  ),
                  const SizedBox(height: 12),
                  if (_currentPage < slides.length - 1)
                    TextButton(
                      onPressed: () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Text(l10n.nextStep),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _SlideView extends StatelessWidget {
  const _SlideView({required this.slide});

  final _WelcomeSlide slide;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: slide.iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: slide.iconColor.withValues(alpha: 0.2),
                width: 1.5,
              ),
            ),
            child: Icon(slide.icon, color: slide.iconColor, size: 56),
          ),
          const SizedBox(height: 40),
          Text(
            slide.title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            slide.subtitle,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _WelcomeSlide {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;

  const _WelcomeSlide({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });
}
