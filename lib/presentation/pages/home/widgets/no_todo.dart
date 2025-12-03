import 'package:flutter/material.dart';
import 'package:tap_debouncer/tap_debouncer.dart';

class NoToDo extends StatelessWidget {
  final String appBarTitle;
  final VoidCallback onAddPressed;

  final Color cardColor;

  const NoToDo({
    super.key,
    required this.appBarTitle,
    required this.onAddPressed,
    this.cardColor = const Color.fromARGB(255, 2, 2, 2),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            const _EmptyVisual(),
            const SizedBox(height: 12),
            Text(
              '아직 할 일이 없음',
              style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              '할 일을 추가하고 $appBarTitle에서\n할 일을 추적하세요.',
              style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                    height: 1.5,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // "할 일 추가" 버튼 디바운싱
            TapDebouncer(
              onTap: () async => onAddPressed(),
              cooldown: const Duration(milliseconds: 700),
              builder: (BuildContext context, TapDebouncerFunc? onTap) {
                return ElevatedButton.icon(
                  onPressed: onTap,
                  icon: const Icon(Icons.add),
                  label: const Text('할 일 추가'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}

class _EmptyVisual extends StatelessWidget {
  const _EmptyVisual();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: Image.asset(
        'assets/images/empty.webp',
        fit: BoxFit.contain,
      ),
    );
  }
}