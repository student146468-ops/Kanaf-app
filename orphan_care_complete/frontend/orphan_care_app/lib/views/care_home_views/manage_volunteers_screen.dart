import 'package:flutter/material.dart';

import '../../providers/app_provider_scope.dart';
import 'care_home_reference_widgets.dart';

class ManageVolunteersScreen extends StatefulWidget {
  const ManageVolunteersScreen({super.key});

  @override
  State<ManageVolunteersScreen> createState() => _ManageVolunteersScreenState();
}

class _ManageVolunteersScreenState extends State<ManageVolunteersScreen> {
  String _filter = 'all';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppProviderScope.of(context).fetchVolunteerRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = AppProviderScope.of(context);
    final requests = provider.volunteerRequests.where(_matchesFilter).toList();

    return CareHomeRefScaffold(
      title: 'إدارة المتطوعين',
      bottomIndex: 3,
      body: RefreshIndicator(
        color: careHomeRefOrange,
        onRefresh: provider.fetchVolunteerRequests,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          children: [
            Row(
              children: [
                CareHomeRefChip(
                  label: 'الكل',
                  selected: _filter == 'all',
                  onTap: () => setState(() => _filter = 'all'),
                ),
                const SizedBox(width: 8),
                CareHomeRefChip(
                  label: 'بانتظار المراجعة',
                  selected: _filter == 'pending',
                  onTap: () => setState(() => _filter = 'pending'),
                ),
                const SizedBox(width: 8),
                CareHomeRefChip(
                  label: 'مقبول',
                  selected: _filter == 'accepted',
                  onTap: () => setState(() => _filter = 'accepted'),
                ),
              ],
            ),
            const SizedBox(height: 14),
            if (provider.isLoading)
              const Padding(
                padding: EdgeInsets.all(28),
                child: Center(
                  child: CircularProgressIndicator(color: careHomeRefOrange),
                ),
              )
            else if (requests.isEmpty)
              const CareHomeRefEmpty(title: 'لا توجد طلبات تطوع حاليا')
            else
              ...requests.map((request) => _VolunteerTile(request: request)),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  bool _matchesFilter(Map<String, dynamic> request) {
    if (_filter == 'pending') return request['status'] == 'pending';
    if (_filter == 'accepted') return request['status'] == 'accepted';
    return true;
  }
}

class _VolunteerTile extends StatelessWidget {
  final Map<String, dynamic> request;

  const _VolunteerTile({required this.request});

  @override
  Widget build(BuildContext context) {
    final provider = AppProviderScope.of(context);
    final id = int.tryParse(request['id']?.toString() ?? '');
    final status = careHomeValue(request['status'], 'pending');
    final accepted = status == 'accepted';
    final pending = status == 'pending';

    return CareHomeRefCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundColor: Color(0xFFFFEFE8),
                child: Icon(Icons.person_outline_rounded,
                    color: careHomeRefOrange),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      careHomeValue(request['volunteer_name'], 'متطوع جديد'),
                      style: careHomeRefBodyStrong,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      careHomeValue(request['title'], 'طلب مشاركة'),
                      style: careHomeRefCaption,
                    ),
                  ],
                ),
              ),
              _StatusBadge(status: status),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            careHomeValue(request['message'], 'لا توجد ملاحظات إضافية'),
            style: careHomeRefCaption.copyWith(height: 1.6),
          ),
          const SizedBox(height: 14),
          if (pending)
            Row(
              children: [
                Expanded(
                  child: CareHomeRefButton(
                    label: 'قبول',
                    loading: provider.isSaving,
                    onPressed: id == null
                        ? null
                        : () => provider.acceptVolunteerRequest(id),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CareHomeRefButton(
                    label: 'رفض',
                    outlined: true,
                    loading: provider.isSaving,
                    onPressed: id == null
                        ? null
                        : () => provider.rejectVolunteerRequest(id),
                  ),
                ),
              ],
            )
          else if (accepted)
            CareHomeRefButton(
              label: 'تقييم المتطوع',
              outlined: true,
              icon: Icons.star_border_rounded,
              onPressed: () => Navigator.of(context)
                  .pushNamed('/care_home_rate_volunteers', arguments: request),
            ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final label = switch (status) {
      'accepted' => 'مقبول',
      'rejected' => 'مرفوض',
      _ => 'معلق',
    };
    final color = switch (status) {
      'accepted' => const Color(0xFF2DA56A),
      'rejected' => const Color(0xFFE54848),
      _ => careHomeRefOrange,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label, style: careHomeRefCaption.copyWith(color: color)),
    );
  }
}
