import 'package:flutter/material.dart';

import '../../providers/app_provider_scope.dart';
import 'care_home_reference_widgets.dart';

class EditNeedScreen extends StatefulWidget {
  const EditNeedScreen({super.key});

  @override
  State<EditNeedScreen> createState() => _EditNeedScreenState();
}

class _EditNeedScreenState extends State<EditNeedScreen> {
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _quantity = TextEditingController();
  int? _id;
  bool _filled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final routeId = int.tryParse(
      ModalRoute.of(context)?.settings.arguments?.toString() ?? '',
    );
    if (routeId != null && routeId != _id) {
      _id = routeId;
      AppProviderScope.of(context).fetchNeedDetails(routeId);
    }

    final need = AppProviderScope.of(context).selectedNeed;
    if (!_filled && need != null && need.id == _id) {
      _title.text = need.title;
      _description.text = need.description;
      _quantity.text = need.requiredQuantity;
      _filled = true;
    }
  }

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
    final need = provider.selectedNeed;

    return CareHomeRefScaffold(
      title: 'تعديل الاحتياج',
      bodyPadding: EdgeInsets.zero,
      bottomAction: Padding(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
        child: CareHomeRefButton(
          label: 'حفظ التعديلات',
          loading: provider.isSaving,
          onPressed: need == null ? null : () => _submit(context),
        ),
      ),
      body: provider.isLoading || need == null
          ? const Center(
              child: CircularProgressIndicator(color: careHomeRefOrange),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 92),
              physics: const BouncingScrollPhysics(),
              children: [
                CareHomeRefImage(
                  imageUrl: need.imageUrl,
                  height: 136,
                  icon: Icons.image_outlined,
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
                CareHomeRefButton(
                  label: 'أرشفة الاحتياج',
                  outlined: true,
                  icon: Icons.archive_outlined,
                  loading: provider.isSaving,
                  onPressed: _id == null
                      ? null
                      : () async {
                          final ok = await provider.archiveNeed(_id!);
                          if (context.mounted && ok) {
                            Navigator.of(context).pop(true);
                          }
                        },
                ),
              ],
            ),
    );
  }

  Future<void> _submit(BuildContext context) async {
    final provider = AppProviderScope.of(context);
    final need = provider.selectedNeed;
    if (need == null) return;

    final ok = await provider.updateNeed(need.id, {
      'title': _title.text.trim(),
      'description': _description.text.trim(),
      'category': need.category,
      'need_type': need.needType,
      'priority': need.priority,
      'required_quantity': _quantity.text.trim(),
      'status': need.status,
    });
    if (!context.mounted) return;
    if (ok) {
      Navigator.of(context).pop(true);
    }
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
