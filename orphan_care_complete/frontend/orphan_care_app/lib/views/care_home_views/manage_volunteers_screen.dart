import 'package:flutter/material.dart';

import '../../models/volunteer_model.dart';
import '../../providers/app_provider_scope.dart';
import '../../utils/app_colors.dart';
import 'care_home_light_widgets.dart';

class ManageVolunteersScreen extends StatefulWidget {
  const ManageVolunteersScreen({super.key});

  @override
  State<ManageVolunteersScreen> createState() => _ManageVolunteersScreenState();
}

class _ManageVolunteersScreenState extends State<ManageVolunteersScreen> {
  String _selectedFilter = 'الكل';
  final Map<String, String> _localStatuses = {};

  final List<_VolunteerApplication> _fallbackApplications = const [
    _VolunteerApplication(
      id: 'local-1',
      name: 'أحمد علي الساعدي',
      skill: 'دعم تعليمي',
      summary: 'مدرس لغة إنجليزية، متاح يومي الإثنين والأربعاء بعد العصر.',
      status: 'معلق',
      hours: 24,
      phone: '+218 91 111 2222',
    ),
    _VolunteerApplication(
      id: 'local-2',
      name: 'فاطمة عمر الخويلدي',
      skill: 'دعم نفسي وأنشطة أطفال',
      summary: 'خبرة في تنظيم أنشطة آمنة للأطفال ومتابعة الحالات الحساسة.',
      status: 'معلق',
      hours: 18,
      phone: '+218 91 333 4444',
    ),
    _VolunteerApplication(
      id: 'local-3',
      name: 'محمد فرج التير',
      skill: 'تنظيم زيارات',
      summary: 'يساعد في ترتيب الزيارات والرحلات ومتابعة قوائم الحضور.',
      status: 'مقبول',
      hours: 32,
      phone: '+218 91 555 6666',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final provider = AppProviderScope.of(context);
    final applications = _buildApplications(provider.volunteers);
    final filteredApplications = applications.where((application) {
      if (_selectedFilter == 'الكل') return true;
      return application.currentStatus(_localStatuses) == _selectedFilter;
    }).toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Stack(
              children: [
                const Positioned.fill(child: _VolunteersBackground()),
                SafeArea(
                  child: Column(
                    children: [
                      _Header(
                        onBack: () => Navigator.of(context).pop(),
                        onRate: () => Navigator.of(context)
                            .pushNamed('/care_home_rate_volunteers'),
                      ),
                      _SummaryStrip(applications: applications),
                      _FilterBar(
                        selected: _selectedFilter,
                        onChanged: (value) =>
                            setState(() => _selectedFilter = value),
                      ),
                      Expanded(
                        child: filteredApplications.isEmpty
                            ? const _EmptyState()
                            : ListView.separated(
                                physics: const BouncingScrollPhysics(),
                                padding:
                                    const EdgeInsets.fromLTRB(20, 8, 20, 24),
                                itemCount: filteredApplications.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  final application =
                                      filteredApplications[index];
                                  return _VolunteerApplicationCard(
                                    application: application,
                                    status: application
                                        .currentStatus(_localStatuses),
                                    onAccept: () => _updateApplication(
                                      application,
                                      'مقبول',
                                    ),
                                    onReject: () => _updateApplication(
                                      application,
                                      'مرفوض',
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<_VolunteerApplication> _buildApplications(
      List<VolunteerModel> volunteers) {
    if (volunteers.isEmpty) return _fallbackApplications;

    return volunteers.map((volunteer) {
      return _VolunteerApplication(
        id: 'api-${volunteer.id}',
        name: volunteer.name.isEmpty ? 'متطوع بدون اسم' : volunteer.name,
        skill: volunteer.specialty.isEmpty ? 'تطوع عام' : volunteer.specialty,
        summary:
            volunteer.email ?? volunteer.phone ?? 'طلب تطوع جاهز للمراجعة.',
        status: _normalizeStatus(volunteer.status),
        hours: volunteer.hoursWorked ?? volunteer.points,
        phone: volunteer.phone,
      );
    }).toList();
  }

  String _normalizeStatus(String? value) {
    switch (value) {
      case 'accepted':
      case 'approved':
      case 'مقبول':
        return 'مقبول';
      case 'rejected':
      case 'مرفوض':
        return 'مرفوض';
      default:
        return 'معلق';
    }
  }

  void _updateApplication(_VolunteerApplication application, String status) {
    setState(() => _localStatuses[application.id] = status);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          status == 'مقبول'
              ? 'تم قبول طلب ${application.name}'
              : 'تم رفض طلب ${application.name}',
          style: const TextStyle(fontFamily: 'Tajawal'),
        ),
        backgroundColor:
            status == 'مقبول' ? const Color(0xFF10B981) : AppColors.errorRed,
      ),
    );
  }
}

class _VolunteerApplication {
  final String id;
  final String name;
  final String skill;
  final String summary;
  final String status;
  final int hours;
  final String? phone;

  const _VolunteerApplication({
    required this.id,
    required this.name,
    required this.skill,
    required this.summary,
    required this.status,
    required this.hours,
    this.phone,
  });

  String currentStatus(Map<String, String> localStatuses) {
    return localStatuses[id] ?? status;
  }
}

class _VolunteersBackground extends StatelessWidget {
  const _VolunteersBackground();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.white,
            AppColors.scaffoldBackground,
            AppColors.scaffoldBackground,
          ],
          stops: const [0, 0.58, 1],
        ),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.white,
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onRate;

  const _Header({required this.onBack, required this.onRate});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          _RoundButton(icon: Icons.arrow_back_ios_new_rounded, onTap: onBack),
          const Expanded(
            child: Column(
              children: [
                Text(
                  'طلبات المتطوعين',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textDarkPrimary,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'مراجعة الطلبات واتخاذ القرار',
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 12,
                    color: AppColors.textDarkSecondary,
                  ),
                ),
              ],
            ),
          ),
          _RoundButton(icon: Icons.star_outline_rounded, onTap: onRate),
        ],
      ),
    );
  }
}

class _RoundButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _RoundButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.innerBorder),
        ),
        child: Icon(icon, color: AppColors.textDarkPrimary, size: 19),
      ),
    );
  }
}

class _SummaryStrip extends StatelessWidget {
  final List<_VolunteerApplication> applications;

  const _SummaryStrip({required this.applications});

  @override
  Widget build(BuildContext context) {
    final pending = applications.where((item) => item.status == 'معلق').length;
    final accepted =
        applications.where((item) => item.status == 'مقبول').length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: Row(
        children: [
          Expanded(
            child: _SmallStat(
              label: 'قيد المراجعة',
              value: '$pending',
              icon: Icons.pending_actions_rounded,
              color: AppColors.brandOrange,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _SmallStat(
              label: 'مقبولون',
              value: '$accepted',
              icon: Icons.verified_outlined,
              color: const Color(0xFF34D399),
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _SmallStat({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CareHomeCard(
      padding: const EdgeInsets.all(13),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textDarkPrimary,
                  ),
                ),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 12,
                    color: AppColors.textDarkSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const _FilterBar({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    const filters = ['الكل', 'معلق', 'مقبول', 'مرفوض'];

    return SizedBox(
      height: 48,
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selected == filter;
          return InkWell(
            onTap: () => onChanged(filter),
            borderRadius: BorderRadius.circular(14),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.brandOrange.withOpacity(0.22)
                    : AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected
                      ? AppColors.brandOrange
                      : AppColors.innerBorder,
                ),
              ),
              child: Text(
                filter,
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                  color: isSelected
                      ? AppColors.brandOrange
                      : AppColors.textDarkSecondary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _VolunteerApplicationCard extends StatelessWidget {
  final _VolunteerApplication application;
  final String status;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const _VolunteerApplicationCard({
    required this.application,
    required this.status,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = switch (status) {
      'مقبول' => const Color(0xFF34D399),
      'مرفوض' => AppColors.errorRed,
      _ => AppColors.brandOrange,
    };
    final isPending = status == 'معلق';

    return CareHomeCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.brandOrange.withOpacity(0.13),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.innerBorder),
                ),
                child: const Icon(
                  Icons.person_outline_rounded,
                  color: AppColors.brandOrange,
                  size: 25,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      application.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textDarkPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      application.skill,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 13,
                        color: AppColors.textDarkSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              _StatusPill(label: status, color: statusColor),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            application.summary,
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 13,
              height: 1.45,
              color: AppColors.textDarkSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _MetaChip(
                icon: Icons.access_time_rounded,
                label: '${application.hours} ساعة خبرة',
              ),
              if (application.phone != null && application.phone!.isNotEmpty)
                _MetaChip(
                    icon: Icons.phone_outlined, label: application.phone!),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _DecisionButton(
                  label: 'رفض',
                  icon: Icons.close_rounded,
                  color: AppColors.errorRed,
                  onTap: isPending ? onReject : null,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _DecisionButton(
                  label: 'قبول',
                  icon: Icons.check_rounded,
                  color: const Color(0xFF10B981),
                  onTap: isPending ? onAccept : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusPill({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.45)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Tajawal',
          fontSize: 11.5,
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBackground),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.textDarkSecondary, size: 15),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: AppColors.textDarkSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _DecisionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _DecisionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 180),
        opacity: enabled ? 1 : 0.45,
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            color: color.withOpacity(0.14),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withOpacity(0.45)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: CareHomeCard(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.group_off_outlined,
                color: AppColors.textDarkMuted.withOpacity(0.45),
                size: 52,
              ),
              const SizedBox(height: 12),
              const Text(
                'لا توجد طلبات ضمن هذا التصنيف',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDarkPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'غيّر الفلتر أو راجع الطلبات الجديدة لاحقًا.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 13,
                  color: AppColors.textDarkSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
