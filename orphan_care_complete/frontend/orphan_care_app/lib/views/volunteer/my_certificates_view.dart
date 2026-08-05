import 'package:flutter/material.dart';

import '../../providers/app_provider_scope.dart';
import 'volunteer_ui.dart';

const Color _certificateOrange = Color(0xFFFF8C42);
const Color _certificateText = Color(0xFF1F2937);
const Color _certificateMuted = Color(0xFF6B7280);
const Color _certificateBackground = Color(0xFFF7F7F7);
const Color _certificateCream = Color(0xFFFFFCF6);

class MyCertificatesView extends StatefulWidget {
  const MyCertificatesView({super.key});

  @override
  State<MyCertificatesView> createState() => _MyCertificatesViewState();
}

class _MyCertificatesViewState extends State<MyCertificatesView> {
  bool _hasLoadedData = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_hasLoadedData) return;
    _hasLoadedData = true;
    final provider = AppProviderScope.of(context);
    provider.fetchCurrentUser();
    provider.fetchVolunteerApplications(notifyLoading: false);
  }

  @override
  Widget build(BuildContext context) {
    final provider = AppProviderScope.of(context);
    final userName = provider.currentUser['username']?.toString() ?? '';
    final certificates = provider.volunteerApplications
        .where((item) =>
            item['status'] == 'accepted' || item['status'] == 'approved')
        .toList();
    final certificate = certificates.isEmpty ? null : certificates.first;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: VolunteerMobileFrame(
        child: Scaffold(
          backgroundColor: _certificateBackground,
          appBar: const PreferredSize(
            preferredSize: Size.fromHeight(volunteerAppBarHeight),
            child: VolunteerTopBar(title: 'شهاداتي'),
          ),
          body: SafeArea(
            top: false,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(22, 28, 22, 32),
              child: Column(
                children: [
                  _CertificatePreviewCard(
                    userName: userName,
                    application: certificate,
                  ),
                  const SizedBox(height: 28),
                  _CertificateActionButton(
                    label: 'تحميل الشهادة',
                    icon: Icons.download_rounded,
                    filled: true,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'سيتم تفعيل تحميل الشهادة عند ربط ملفات الشهادات.',
                          ),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 14),
                  _CertificateActionButton(
                    label: 'مشاركة الشهادة',
                    icon: Icons.ios_share_rounded,
                    filled: false,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('مشاركة الشهادة قريبًا'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
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

class _CertificatePreviewCard extends StatelessWidget {
  final String userName;
  final Map<String, dynamic>? application;

  const _CertificatePreviewCard({
    required this.userName,
    required this.application,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 500),
        decoration: BoxDecoration(
          color: _certificateCream,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFF1E5D6)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Stack(
          children: [
            const PositionedDirectional(
              top: -52,
              start: -44,
              child: _SoftOrangeCircle(size: 130, opacity: 0.13),
            ),
            const PositionedDirectional(
              top: 28,
              start: 24,
              child: _SoftOrangeCircle(size: 34, opacity: 0.30),
            ),
            const PositionedDirectional(
              bottom: -46,
              end: -40,
              child: _SoftOrangeCircle(size: 128, opacity: 0.13),
            ),
            const PositionedDirectional(
              bottom: 30,
              end: 30,
              child: _SoftOrangeCircle(size: 30, opacity: 0.28),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 44, 24, 34),
              child: Column(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: _certificateOrange.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.workspace_premium_rounded,
                      color: _certificateOrange,
                      size: 34,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'شهادة تطوع',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Vazirmatn',
                      color: _certificateText,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'تمنح هذه الشهادة إلى',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Vazirmatn',
                      color: _certificateMuted,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userName.isEmpty ? 'غير محدد' : userName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Vazirmatn',
                      color: _certificateOrange,
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Container(
                    width: 72,
                    height: 2,
                    decoration: BoxDecoration(
                      color: _certificateOrange.withOpacity(0.45),
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    application == null
                        ? 'لا توجد شهادة متاحة من الخادم حاليًا.'
                        : 'وذلك تقديرًا لمشاركتك في ${application!['opportunity_title'] ?? ''}.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Vazirmatn',
                      color: _certificateText,
                      fontSize: 15,
                      height: 1.75,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'تاريخ الإصدار: ${_dateLabel(application?['created_at'])}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Vazirmatn',
                      color: _certificateMuted,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    width: 74,
                    height: 74,
                    decoration: BoxDecoration(
                      color: _certificateOrange.withOpacity(0.10),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _certificateOrange.withOpacity(0.28),
                      ),
                    ),
                    child: const Icon(
                      Icons.military_tech_rounded,
                      color: _certificateOrange,
                      size: 42,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _dateLabel(dynamic value) {
    final date = DateTime.tryParse(value?.toString() ?? '');
    if (date == null) return 'غير محدد';
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

class _SoftOrangeCircle extends StatelessWidget {
  final double size;
  final double opacity;

  const _SoftOrangeCircle({required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: _certificateOrange.withOpacity(opacity),
        shape: BoxShape.circle,
      ),
    );
  }
}

class _CertificateActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool filled;
  final VoidCallback onPressed;

  const _CertificateActionButton({
    required this.label,
    required this.icon,
    required this.filled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: filled
          ? ElevatedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, size: 20),
              label: Text(label),
              style: ElevatedButton.styleFrom(
                backgroundColor: _certificateOrange,
                foregroundColor: Colors.white,
                elevation: 0,
                textStyle: const TextStyle(
                  fontFamily: 'Vazirmatn',
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17),
                ),
              ),
            )
          : OutlinedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, size: 20),
              label: Text(label),
              style: OutlinedButton.styleFrom(
                foregroundColor: _certificateOrange,
                side: const BorderSide(color: _certificateOrange, width: 1.4),
                textStyle: const TextStyle(
                  fontFamily: 'Vazirmatn',
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17),
                ),
              ),
            ),
    );
  }
}
