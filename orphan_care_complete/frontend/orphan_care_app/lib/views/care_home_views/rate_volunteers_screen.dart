import 'package:flutter/material.dart';

import '../../providers/app_provider_scope.dart';
import 'care_home_reference_widgets.dart';

class RateVolunteersScreen extends StatefulWidget {
  const RateVolunteersScreen({super.key});

  @override
  State<RateVolunteersScreen> createState() => _RateVolunteersScreenState();
}

class _RateVolunteersScreenState extends State<RateVolunteersScreen> {
  final _notes = TextEditingController();
  int _rating = 5;

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = AppProviderScope.of(context);
    final args = ModalRoute.of(context)?.settings.arguments;
    final request =
        args is Map ? Map<String, dynamic>.from(args) : <String, dynamic>{};
    final id = int.tryParse(request['id']?.toString() ?? '');

    return CareHomeRefScaffold(
      title: 'تقييم المتطوع',
      bodyPadding: EdgeInsets.zero,
      bottomAction: Padding(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
        child: CareHomeRefButton(
          label: 'حفظ التقييم',
          loading: provider.isSaving,
          onPressed: id == null
              ? null
              : () async {
                  final ok = await provider.rateVolunteerRequest(id, {
                    'rating': _rating,
                    'rating_notes': _notes.text.trim(),
                  });
                  if (context.mounted && ok) Navigator.of(context).pop(true);
                },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 92),
        physics: const BouncingScrollPhysics(),
        children: [
          CareHomeRefCard(
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundColor: Color(0xFFFFEFE8),
                  child: Icon(Icons.person_outline_rounded,
                      color: careHomeRefOrange, size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        careHomeValue(request['volunteer_name'], 'متطوع'),
                        style: careHomeRefBodyStrong.copyWith(fontSize: 15),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        careHomeValue(request['title'], 'مشاركة تطوعية'),
                        style: careHomeRefCaption,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text('التقييم', style: careHomeRefBodyStrong),
          const SizedBox(height: 10),
          CareHomeRefCard(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final value = index + 1;
                return IconButton(
                  tooltip: '$value',
                  onPressed: () => setState(() => _rating = value),
                  icon: Icon(
                    value <= _rating
                        ? Icons.star_rounded
                        : Icons.star_border_rounded,
                    color: careHomeRefOrange,
                    size: 34,
                  ),
                );
              }),
            ),
          ),
          Text('ملاحظات التقييم', style: careHomeRefBodyStrong),
          const SizedBox(height: 10),
          TextField(
            controller: _notes,
            maxLines: 5,
            style: careHomeRefBodyStrong,
            decoration: InputDecoration(
              hintText: 'اكتب ملاحظاتك هنا',
              hintStyle: careHomeRefCaption,
              filled: true,
              fillColor: Colors.white,
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
        ],
      ),
    );
  }
}
