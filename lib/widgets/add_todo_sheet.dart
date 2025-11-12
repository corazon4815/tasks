import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // ← 추가!
import '/models/todo_model.dart';

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

  Future<void> _save() async {
    if (!_canSave) {
      Navigator.of(context).pop<ToDoModel?>(null);
      return;
    }
    final todo = ToDoModel(
      title: _titleController.text.trim(),
      description: _showDescriptionField
          ? (_descController.text.trim().isEmpty
              ? null
              : _descController.text.trim())
          : null,
      isFavorite: _isFavorite,
      isDone: false,
      createdAt: DateTime.now(),
    );
    
    Navigator.of(context).pop<ToDoModel>(todo); //
  }

  @override
  Widget build(BuildContext context) {
    final bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    final scheme = Theme.of(context).colorScheme;

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
              onSubmitted: (_) => _save(),
              textInputAction: TextInputAction.done,
            ),

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
                  maxLines: null,
                ),
              ),
            ],
            const SizedBox(height: 12),

            Row(
              children: [
                if (!_showDescriptionField)
                  IconButton(
                    tooltip: '세부정보 추가',
                    icon: const Icon(Icons.short_text_rounded, size: 24),
                    onPressed: () {
                      setState(() => _showDescriptionField = true);
                    },
                  ),

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

                TextButton(
                  onPressed: _save,
                  style: TextButton.styleFrom(
                    foregroundColor: _canSave
                        ? scheme.primary
                        : scheme.onSurface.withOpacity(0.4),
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
