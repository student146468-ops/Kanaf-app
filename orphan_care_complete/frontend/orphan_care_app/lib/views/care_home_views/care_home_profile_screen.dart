import 'package:flutter/material.dart';

import '../../providers/app_provider_scope.dart';
import '../../utils/app_colors.dart';
import 'care_home_light_widgets.dart';

class CareHomeProfileScreen extends StatefulWidget {
  const CareHomeProfileScreen({super.key});

  @override
  State<CareHomeProfileScreen> createState() => _CareHomeProfileScreenState();
}

class _CareHomeProfileScreenState extends State<CareHomeProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppProviderScope.of(context).fetchCareHomeProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWebOrDesktop = size.width > 600;
    final provider = AppProviderScope.of(context);
    final profile = provider.careHomeProfile;

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
                    title: 'ملف الدار',
                    onBack: () => Navigator.of(context).pop(),
                    includeSafeArea: false,
                    actions: [
                      IconButton(
                        onPressed: () async {
                          await Navigator.of(context)
                              .pushNamed('/care_home_edit_profile');
                          if (mounted) provider.fetchCareHomeProfile();
                        },
                        icon: const Icon(Icons.edit_note_rounded,
                            color: AppColors.brandOrange),
                      ),
                    ],
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: provider.fetchCareHomeProfile,
                      child: provider.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: CareHomeSpacing.lg,
                                  vertical: CareHomeSpacing.md),
                              children: [
                                CareHomeCard(
                                  padding:
                                      const EdgeInsets.all(CareHomeSpacing.lg),
                                  child: Column(
                                    children: [
                                      const CareHomeIconBox(
                                          icon: Icons.home_work_rounded,
                                          color: AppColors.brandOrange,
                                          size: 72,
                                          iconSize: 34),
                                      const SizedBox(
                                          height: CareHomeSpacing.md),
                                      Text(
                                          profile['name']?.toString() ??
                                              'دار الرعاية',
                                          textAlign: TextAlign.center,
                                          style: CareHomeTextStyles.title
                                              .copyWith(fontSize: 22)),
                                      if ((profile['description'] ?? '')
                                          .toString()
                                          .isNotEmpty) ...[
                                        const SizedBox(
                                            height: CareHomeSpacing.sm),
                                        Text(profile['description'].toString(),
                                            textAlign: TextAlign.center,
                                            style: CareHomeTextStyles.body),
                                      ],
                                    ],
                                  ),
                                ),
                                const SizedBox(height: CareHomeSpacing.lg),
                                _info(profile),
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

  Widget _info(Map<String, dynamic> profile) {
    return CareHomeCard(
      padding: const EdgeInsets.all(CareHomeSpacing.lg),
      child: Column(
        children: [
          _row('البريد الإلكتروني', profile['email']),
          _row('رقم الهاتف', profile['phone']),
          _row('المدينة', profile['city']),
          _row('العنوان', profile['address']),
          _row('اسم المسؤول', profile['manager_name']),
          _row('رقم الترخيص', profile['license_number']),
          _row('عدد الأطفال', profile['children_count']),
          _row('ساعات الزيارة', profile['visit_hours']),
        ],
      ),
    );
  }

  Widget _row(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(label,
              style: CareHomeTextStyles.body
                  .copyWith(fontWeight: FontWeight.w800)),
          const Spacer(),
          Flexible(
            child: Text(
              value?.toString().isNotEmpty == true ? value.toString() : '-',
              textAlign: TextAlign.end,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: CareHomeTextStyles.body,
            ),
          ),
        ],
      ),
    );
  }
}
