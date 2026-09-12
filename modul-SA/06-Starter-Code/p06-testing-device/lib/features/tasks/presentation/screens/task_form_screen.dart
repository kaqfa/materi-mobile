import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../domain/task.dart';

/// Form tugas. Validasi: title wajib & minimal 3 karakter. Target widget
/// test (P06): submit kosong -> error validasi; submit valid -> callback.
class TaskFormScreen extends StatefulWidget {
  const TaskFormScreen({
    super.key,
    required this.onSubmit,
    this.initial,
    this.onPickAttachment,
    this.attachmentPath,
  });

  /// Dipanggil dengan [Task] baru saat valid. Id/disabled dummy di starter.
  final ValueChanged<Task> onSubmit;
  final Task? initial;
  final VoidCallback? onPickAttachment;
  final String? attachmentPath;

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _description;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.initial?.title ?? '');
    _description =
        TextEditingController(text: widget.initial?.description ?? '');
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  String? _validateTitle(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return AppStrings.errTitleRequired;
    if (v.length < 3) return AppStrings.errTitleTooShort;
    return null;
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final now = DateTime.now();
    final task = Task(
      id: widget.initial?.id ?? 'new-${now.millisecondsSinceEpoch}',
      title: _title.text.trim(),
      description: _description.text.trim(),
      dueDate: widget.initial?.dueDate ?? now.add(const Duration(days: 1)),
      priority: widget.initial?.priority ?? TaskPriority.medium,
      isCompleted: widget.initial?.isCompleted ?? false,
      attachmentPath: widget.attachmentPath,
    );
    widget.onSubmit(task);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initial == null
            ? AppStrings.addTaskTitle
            : AppStrings.editTaskTitle),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              key: const Key('field_title'),
              controller: _title,
              decoration: const InputDecoration(
                labelText: AppStrings.fieldTitle,
                hintText: AppStrings.fieldTitleHint,
              ),
              validator: _validateTitle,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _description,
              decoration: const InputDecoration(
                labelText: AppStrings.fieldDescription,
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            if (widget.onPickAttachment != null)
              Row(
                children: [
                  FilledButton.tonalIcon(
                    onPressed: widget.onPickAttachment,
                    icon: const Icon(Icons.add_a_photo),
                    label: const Text(AppStrings.actionPickPhoto),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.attachmentPath ?? AppStrings.attachNone,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 24),
            FilledButton(
              key: const Key('btn_save'),
              onPressed: _submit,
              child: const Text(AppStrings.actionSave),
            ),
          ],
        ),
      ),
    );
  }
}
