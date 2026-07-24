import 'package:flutter/material.dart';

import '../../providers/app_provider_scope.dart';
import 'care_home_reference_widgets.dart';

class AddNeedScreen extends StatefulWidget {
  const AddNeedScreen({super.key});

  @override
  State<AddNeedScreen> createState() => _AddNeedScreenState();
}

class _AddNeedScreenState extends State<AddNeedScreen> {
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _quantity = TextEditingController();
  String _category = 'education';
  String _priority = 'urgent';

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _quantity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = AppProviderScope.of(context);

    return CareHomeRefScaffold(
      title: 'إضافة احتياج',
      bodyPadding: EdgeInsets.zero,
      bottomAction: Padding(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
        child: CareHomeRefButton(
          label: 'نشر الاحتياج',
          loading: provider.isSaving,
          onPressed: () => _submit(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 92),
        physics: const BouncingScrollPhysics(),
        children: [
          const CareHomeRefImage(
            height: 136,
            icon: Icons.add_photo_alternate_outlined,
          ),
          const SizedBox(height: 14),
          Text('نوع الاحتياج', style: careHomeRefBodyStrong),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              CareHomeRefChip(
                label: 'تعليم',
                selected: _category == 'education',
                onTap: () => setState(() => _category = 'education'),
              ),
              CareHomeRefChip(
                label: 'ملابس',
                selected: _category == 'clothes',
                onTap: () => setState(() => _category = 'clothes'),
              ),
              CareHomeRefChip(
                label: 'غذاء',
                selected: _category == 'food',
                onTap: () => setState(() => _category = 'food'),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _Field(
              controller: _title,
              hint: 'عنوان الاحتياج',
              icon: Icons.title_rounded),
          _Field(
            controller: _quantity,
            hint: 'الكمية المطلوبة',
            icon: Icons.numbers_rounded,
            keyboardType: TextInputType.number,
          ),
          _Field(
            controller: _description,
            hint: 'وصف مختصر',
            icon: Icons.notes_rounded,
            maxLines: 4,
          ),
          const SizedBox(height: 4),
          Text('الأولوية', style: careHomeRefBodyStrong),
          const SizedBox(height: 10),
          Row(
            children: [
              CareHomeRefChip(
                label: 'عاجل',
                selected: _priority == 'urgent',
                onTap: () => setState(() => _priority = 'urgent'),
              ),
              const SizedBox(width: 8),
              CareHomeRefChip(
                label: 'معتدل',
                selected: _priority == 'medium',
                onTap: () => setState(() => _priority = 'medium'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _submit(BuildContext context) async {
    final provider = AppProviderScope.of(context);
    final ok = await provider.createNeed({
      'title': _title.text.trim(),
      'description': _description.text.trim(),
      'category': _category,
      'need_type': 'in_kind',
      'priority': _priority,
      'required_quantity': _quantity.text.trim(),
      'status': 'active',
    });
    if (!context.mounted) return;
    if (ok) Navigator.of(context).pop(true);
  }
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final int maxLines;
  final TextInputType? keyboardType;

  const _Field({
    required this.controller,
    required this.hint,
    required this.icon,
    this.maxLines = 1,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: careHomeRefBodyStrong,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: careHomeRefCaption,
          prefixIcon: Icon(icon, color: const Color(0xFF9AA1AD), size: 20),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: careHomeRefLine),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: careHomeRefOrange),
          ),
        ),
      ),
    );
  }
}
