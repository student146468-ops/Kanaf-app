import 'package:flutter/material.dart';

import '../../providers/app_provider_scope.dart';
import '../../utils/app_colors.dart';
import 'care_home_light_widgets.dart';

class RateVolunteersScreen extends StatefulWidget {
  const RateVolunteersScreen({super.key});

  @override
  State<RateVolunteersScreen> createState() => _RateVolunteersScreenState();
}

class _RateVolunteersScreenState extends State<RateVolunteersScreen> {
  final _notesController = TextEditingController();
  int _rating = 5;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWebOrDesktop = size.width > 600;
    final provider = AppProviderScope.of(context);
    final args = ModalRoute.of(context)?.settings.arguments;
    final request =
        args is Map ? Map<String, dynamic>.from(args) : <String, dynamic>{};
    final id = int.tryParse(request['id']?.toString() ?? '');

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: Center(
          child: Container(
            width: isWebOrDesktop ? 430 : double.infinity,
            height: double.infinity,
            color: Colors.white,
            child: SafeArea(
              child: Column(
                children: [
                  CareHomeTopBar(
                    title: 'تقييم المتطوع',
                    onBack: () => Navigator.of(context).pop(),
                    includeSafeArea: false,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: CareHomeSpacing.lg,
                          vertical: CareHomeSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CareHomeCard(
                            padding: const EdgeInsets.all(CareHomeSpacing.lg),
                            child: Row(
                              children: [
                                const CareHomeIconBox(
                                    icon: Icons.person_outline_rounded,
                                    color: AppColors.brandOrange),
                                const SizedBox(width: CareHomeSpacing.md),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          request['volunteer_name']
                                                  ?.toString() ??
                                              'متطوع',
                                          style:
                                              CareHomeTextStyles.sectionTitle),
                                      Text(request['title']?.toString() ?? '',
                                          style: CareHomeTextStyles.muted),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: CareHomeSpacing.xl),
                          Text('التقييم',
                              style: CareHomeTextStyles.sectionTitle
                                  .copyWith(fontSize: 15)),
                          const SizedBox(height: CareHomeSpacing.sm),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(5, (index) {
                              final value = index + 1;
                              return IconButton(
                                onPressed: () =>
                                    setState(() => _rating = value),
                                icon: Icon(
                                  value <= _rating
                                      ? Icons.star_rounded
                                      : Icons.star_border_rounded,
                                  color: AppColors.brandOrange,
                                  size: 34,
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: CareHomeSpacing.lg),
                          CareHomeInputField(
                            controller: _notesController,
                            label: '',
                            hint: 'ملاحظات التقييم',
                            icon: Icons.notes_rounded,
                            maxLines: 4,
                          ),
                          const SizedBox(height: CareHomeSpacing.xl),
                          CareHomePrimaryButton(
                            label: 'حفظ التقييم',
                            loading: provider.isSaving,
                            onPressed: id == null
                                ? null
                                : () async {
                                    final success = await provider
                                        .rateVolunteerRequest(id, {
                                      'rating': _rating,
                                      'rating_notes':
                                          _notesController.text.trim(),
                                    });
                                    if (!context.mounted) return;
                                    if (success) {
                                      Navigator.of(context).pop(true);
                                    }
                                  },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
