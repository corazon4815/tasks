import 'package:flutter/material.dart';
import '/models/todo_entity.dart';

class AddToDoSheet extends StatefulWidget {
  const AddToDoSheet({super.key});

  @override
  State<AddToDoSheet> createState() => _AddToDoSheetState();
}

class _AddToDoSheetState extends State<AddToDoSheet> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _titleFocus = FocusNode();

  bool _showDescriptionField = false;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _titleFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _titleFocus.dispose();
    super.dispose();
  }

  bool get _canSave => _titleController.text.trim().isNotEmpty;

  void _save() {
    if (!_canSave) return;
    final todo = ToDoEntity(
      title: _titleController.text.trim(),
      description: _showDescriptionField
          ? _descController.text.trim().isEmpty
              ? null
              : _descController.text.trim()
          : null,
      isFavorite: _isFavorite,
      isDone: false,
    );
    Navigator.of(context).pop<ToDoEntity>(todo);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInsets = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: bottomInsets,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title 입력
            TextField(
              controller: _titleController,
              focusNode: _titleFocus,
              style: const TextStyle(fontSize: 16),
              decoration: const InputDecoration(
                hintText: '새 할 일',
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              onChanged: (_) => setState(() {}),
              // 줄바꿈 대신 저장
              onSubmitted: (_) => _save(),
              textInputAction: TextInputAction.done,
            ),
            // description 입력
            if (_showDescriptionField) ...[
              SingleChildScrollView(
                child: TextField(
                  controller: _descController,
                  style: const TextStyle(fontSize: 14),
                  decoration: const InputDecoration(
                    hintText: '세부정보 추가',
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: null, // 줄바꿈 활성화
                ),
              ),
            ],
            const SizedBox(height: 12),

            // 아이콘 2개 + 저장버튼 Row
            Row(
              children: [
                // 설명(세부정보 추가) 토글
                if (!_showDescriptionField)
                  IconButton(
                    tooltip: '세부정보 추가',
                    icon: const Icon(Icons.short_text_rounded, size: 24),
                    onPressed: () {
                      setState(() => _showDescriptionField = true);
                    },
                  ),

                // 즐겨찾기 토글
                IconButton(
                  tooltip: '즐겨찾기',
                  icon: Icon(
                    _isFavorite ? Icons.star : Icons.star_border,
                    size: 24,
                  ),
                  onPressed: () {
                    setState(() => _isFavorite = !_isFavorite);
                  },
                ),

                const Spacer(),

                // 저장 버튼 (타이틀이 있을 때만 활성)
                TextButton(
                  onPressed: _canSave ? _save : null,
                  style: TextButton.styleFrom(
                    foregroundColor: _canSave
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey,
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text('저장'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
