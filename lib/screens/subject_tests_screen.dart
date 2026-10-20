import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

import '../theme/app_theme.dart';
import 'subject_quiz_screen.dart';

class SubjectTestsScreen extends StatelessWidget {
  const SubjectTestsScreen({super.key});

  static const _subjects = [
    _Subject(
      title: 'Filosofiýa we edebiýat',
      subtitle: '30 soragdan tötänleýin 10 sanysy',
      assetPath: 'assets/filo_edebiyat.json',
      icon: LucideIcons.bookOpenText,
      color: Color(0xFF7B4DB3),
    ),
    _Subject(
      title: 'Taryh we türkmen dili',
      subtitle: '50 soragdan tötänleýin 10 sanysy',
      assetPath: 'assets/taryh_tn_dili.json',
      icon: LucideIcons.landmark,
      color: Color(0xFFC56A22),
    ),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Container(
      decoration: BoxDecoration(gradient: AppTheme.bgGradient),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
              child: Row(
                children: [
                  IconButton.filledTonal(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ders synaglary',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'Taýýarlanmak üçin bir dersi saýlaň',
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                itemCount: _subjects.length,
                separatorBuilder: (_, _) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final subject = _subjects[index];
                  return _SubjectCard(
                    subject: subject,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SubjectQuizScreen(
                          title: subject.title,
                          assetPath: subject.assetPath,
                          color: subject.color,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _SubjectCard extends StatelessWidget {
  const _SubjectCard({required this.subject, required this.onTap});

  final _Subject subject;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: AppTheme.surface,
    borderRadius: BorderRadius.circular(22),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: subject.color.withValues(alpha: .28)),
          boxShadow: const [
            BoxShadow(
              color: AppTheme.shadowColor,
              blurRadius: 14,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: subject.color.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(17),
              ),
              child: Icon(subject.icon, color: subject.color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subject.title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subject.subtitle,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: subject.color,
              size: 18,
            ),
          ],
        ),
      ),
    ),
  );
}

class _Subject {
  const _Subject({
    required this.title,
    required this.subtitle,
    required this.assetPath,
    required this.icon,
    required this.color,
  });

  final String title;
  final String subtitle;
  final String assetPath;
  final IconData icon;
  final Color color;
}
