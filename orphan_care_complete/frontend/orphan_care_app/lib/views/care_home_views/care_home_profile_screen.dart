import 'package:flutter/material.dart';

import '../../providers/app_provider_scope.dart';
import 'care_home_reference_widgets.dart';

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
    final provider = AppProviderScope.of(context);
    final profile = provider.careHomeProfile;
    final name = careHomeValue(profile['name'], 'دار الأمان لرعاية الأيتام');
    final city = careHomeValue(profile['city'], 'بنغازي');

    return CareHomeRefScaffold(
      title: 'ملف الدار',
      bottomIndex: 4,
      body: RefreshIndicator(
        color: careHomeRefOrange,
        onRefresh: provider.fetchCareHomeProfile,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          children: [
            CareHomeRefCard(
              padding: const EdgeInsets.all(0),
              child: Column(
                children: [
                  const CareHomeRefImage(
                    assetPath: 'assets/images/image13.png',
                    height: 150,
                    icon: Icons.home_work_outlined,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      children: [
                        Text(name,
                            textAlign: TextAlign.center,
                            style: careHomeRefTitle),
                        const SizedBox(height: 4),
                        Text(city, style: careHomeRefCaption),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            _ProfileStat(
                              value: provider.needs.length.toString(),
                              label: 'الاحتياجات',
                            ),
                            _ProfileStat(
                              value: careHomeValue(
                                  profile['donations_count'], '120'),
                              label: 'المستفيدون',
                            ),
                            _ProfileStat(
                              value: careHomeValue(profile['rating'], '4.8'),
                              label: 'التقييم',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            CareHomeRefButton(
              label: 'عرض الاحتياجات',
              onPressed: () =>
                  Navigator.of(context).pushNamed('/care_home_needs_list'),
            ),
            const SizedBox(height: 10),
            CareHomeRefButton(
              label: 'تعديل الملف',
              outlined: true,
              onPressed: () async {
                await Navigator.of(context)
                    .pushNamed('/care_home_edit_profile');
                if (context.mounted) provider.fetchCareHomeProfile();
              },
            ),
            const SizedBox(height: 16),
            CareHomeRefRowTile(
              icon: Icons.email_outlined,
              title: 'البريد الإلكتروني',
              subtitle: careHomeValue(profile['email'], 'غير محدد'),
            ),
            CareHomeRefRowTile(
              icon: Icons.phone_iphone_rounded,
              title: 'رقم الهاتف',
              subtitle: careHomeValue(profile['phone'], 'غير محدد'),
            ),
            CareHomeRefRowTile(
              icon: Icons.location_on_outlined,
              title: 'العنوان',
              subtitle: careHomeValue(profile['address'], 'غير محدد'),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String value;
  final String label;

  const _ProfileStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: careHomeRefBodyStrong.copyWith(fontSize: 15)),
          const SizedBox(height: 4),
          Text(label, style: careHomeRefCaption),
        ],
      ),
    );
  }
}
