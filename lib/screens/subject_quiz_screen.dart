import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/study_question.dart';
import '../theme/app_theme.dart';

class SubjectQuizScreen extends StatefulWidget {
  const SubjectQuizScreen({
    super.key,
    required this.title,
    required this.assetPath,
    required this.color,
  });

  final String title;
  final String assetPath;
  final Color color;

  @override
  State<SubjectQuizScreen> createState() => _SubjectQuizScreenState();
}

class _SubjectQuizScreenState extends State<SubjectQuizScreen> {
  static const int _questionsPerTest = 10;

  List<StudyQuestion> _questions = const [];
  List<String> _options = const [];
  int _index = 0;
  int _correct = 0;
  String? _selected;
  bool _loading = true;
  Object? _error;

  StudyQuestion get _current => _questions[_index];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final raw = await rootBundle.loadString(widget.assetPath);
      final items =
          (jsonDecode(raw) as List<dynamic>)
              .map(
                (item) => StudyQuestion.fromJson(item as Map<String, dynamic>),
              )
              .where(
                (item) => item.question.isNotEmpty && item.options.isNotEmpty,
              )
              .toList()
            ..shuffle(Random());
      final testQuestions = items.take(_questionsPerTest).toList();
      if (!mounted) return;
      setState(() {
        _questions = testQuestions;
        _loading = false;
        _shuffleOptions();
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error;
        _loading = false;
      });
    }
  }

  void _shuffleOptions() {
    if (_questions.isEmpty) return;
    _options = List<String>.from(_current.options)..shuffle(Random());
  }

  void _select(String option) {
    if (_selected != null) return;
    setState(() {
      _selected = option;
      if (option == _current.answer) _correct++;
    });
  }

  void _continue() {
    if (_index == _questions.length - 1) {
      _showResult();
      return;
    }
    setState(() {
      _index++;
      _selected = null;
      _shuffleOptions();
    });
  }

  void _showResult() {
    final percent = (_correct / _questions.length * 100).round();
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        icon: Icon(
          Icons.workspace_premium_rounded,
          color: widget.color,
          size: 52,
        ),
        title: const Text('Synag tamamlandy!', textAlign: TextAlign.center),
        content: Text(
          '$_correct / ${_questions.length} dogry jogap\n$percent%',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.pop(context);
            },
            child: const Text('Derslere dolan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_error != null || _questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Soraglary ýükläp bolmady.')),
      );
    }

    final progress = (_index + 1) / _questions.length;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.bgGradient),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 10, 20, 12),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 7),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 6,
                              color: widget.color,
                              backgroundColor: AppTheme.surfaceContainerHigh,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    Text(
                      '${_index + 1}/${_questions.length}',
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(22),
                        decoration: AppTheme.cardDecoration,
                        child: Text(
                          _current.question,
                          style: const TextStyle(
                            fontSize: 21,
                            height: 1.4,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      ..._options.map(_answerTile),
                    ],
                  ),
                ),
              ),
              if (_selected != null)
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
                  decoration: const BoxDecoration(
                    color: AppTheme.surface,
                    border: Border(top: BorderSide(color: AppTheme.cardBorder)),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: widget.color,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: _continue,
                      child: Text(
                        _index == _questions.length - 1
                            ? 'NETIJÄNI GÖR'
                            : 'DOWAM ET',
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _answerTile(String option) {
    final answered = _selected != null;
    final correct = option == _current.answer;
    final selected = option == _selected;
    final color = answered && correct
        ? AppTheme.correct
        : answered && selected
        ? AppTheme.wrong
        : AppTheme.cardBorder;
    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: InkWell(
        onTap: () => _select(option),
        borderRadius: BorderRadius.circular(17),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 16),
          decoration: BoxDecoration(
            color: answered && (correct || selected)
                ? color.withValues(alpha: .09)
                : AppTheme.surface,
            borderRadius: BorderRadius.circular(17),
            border: Border.all(color: color, width: 1.5),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  option,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (answered && correct)
                const Icon(Icons.check_circle_rounded, color: AppTheme.correct)
              else if (answered && selected)
                const Icon(Icons.cancel_rounded, color: AppTheme.wrong),
            ],
          ),
        ),
      ),
    );
  }
}
