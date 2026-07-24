import 'package:flutter/material.dart';

import '../../providers/app_provider_scope.dart';
import 'care_home_reference_widgets.dart';

class VisitHoursScreen extends StatefulWidget {
  const VisitHoursScreen({super.key});

  @override
  State<VisitHoursScreen> createState() => _VisitHoursScreenState();
}

class _VisitHoursScreenState extends State<VisitHoursScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppProviderScope.of(context).fetchVisitHours();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = AppProviderScope.of(context);
    final slots = provider.visitHours;

    return CareHomeRefScaffold(
      title: 'مواعيد الزيارة',
      body: RefreshIndicator(
        color: careHomeRefOrange,
        onRefresh: provider.fetchVisitHours,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          children: [
            const CareHomeRefImage(
              height: 120,
              icon: Icons.calendar_month_outlined,
            ),
            const SizedBox(height: 14),
            if (provider.isLoading)
              const Padding(
                padding: EdgeInsets.all(28),
                child: Center(
                  child: CircularProgressIndicator(color: careHomeRefOrange),
                ),
              )
            else if (slots.isEmpty)
              const CareHomeRefEmpty(title: 'لم يتم تحديد مواعيد الزيارة بعد')
            else
              ...slots.map((slot) => CareHomeRefRowTile(
                    icon: Icons.schedule_rounded,
                    title: careHomeValue(slot['day'], 'اليوم'),
                    subtitle:
                        '${careHomeValue(slot['start_time'], '--:--')} - ${careHomeValue(slot['end_time'], '--:--')}',
                    trailing: IconButton(
                      tooltip: 'حذف',
                      icon: const Icon(Icons.delete_outline_rounded,
                          color: Color(0xFFE54848), size: 20),
                      onPressed: () {
                        final id = int.tryParse(slot['id']?.toString() ?? '');
                        if (id != null) provider.deleteVisitHour(id);
                      },
                    ),
                  )),
            const SizedBox(height: 8),
            CareHomeRefButton(
              label: 'إضافة موعد زيارة',
              icon: Icons.add_rounded,
              onPressed: () => _showSheet(context, provider),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showSheet(BuildContext context, dynamic provider) async {
    final day = TextEditingController();
    final start = TextEditingController();
    final end = TextEditingController();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      showDragHandle: true,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            6,
            16,
            MediaQuery.viewInsetsOf(context).bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('موعد جديد', style: careHomeRefBodyStrong),
              const SizedBox(height: 12),
              _Field(controller: day, hint: 'اليوم'),
              _Field(controller: start, hint: 'وقت البداية'),
              _Field(controller: end, hint: 'وقت النهاية'),
              CareHomeRefButton(
                label: 'حفظ',
                loading: provider.isSaving,
                onPressed: () async {
                  final ok = await provider.createVisitHour({
                    'day': day.text.trim(),
                    'start_time': start.text.trim(),
                    'end_time': end.text.trim(),
                  });
                  if (context.mounted && ok) Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String hint;

  const _Field({required this.controller, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        style: careHomeRefBodyStrong,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: careHomeRefCaption,
          filled: true,
          fillColor: careHomeRefSoft,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
