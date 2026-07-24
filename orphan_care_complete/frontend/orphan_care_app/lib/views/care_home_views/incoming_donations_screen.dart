import 'package:flutter/material.dart';

import '../../models/donation_model.dart';
import '../../providers/app_provider_scope.dart';
import 'care_home_reference_widgets.dart';

class IncomingDonationsScreen extends StatefulWidget {
  const IncomingDonationsScreen({super.key});

  @override
  State<IncomingDonationsScreen> createState() =>
      _IncomingDonationsScreenState();
}

class _IncomingDonationsScreenState extends State<IncomingDonationsScreen> {
  String _filter = 'all';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppProviderScope.of(context).fetchDonations();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = AppProviderScope.of(context);
    final donations = provider.donations.where(_matchesFilter).toList();

    return CareHomeRefScaffold(
      title: 'سجل التبرعات',
      bottomIndex: 2,
      body: RefreshIndicator(
        color: careHomeRefOrange,
        onRefresh: provider.fetchDonations,
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
                  label: 'مالي',
                  selected: _filter == 'money',
                  onTap: () => setState(() => _filter = 'money'),
                ),
                const SizedBox(width: 8),
                CareHomeRefChip(
                  label: 'عيني',
                  selected: _filter == 'in_kind',
                  onTap: () => setState(() => _filter = 'in_kind'),
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
            else if (donations.isEmpty)
              const CareHomeRefEmpty(title: 'لا توجد تبرعات حاليا')
            else
              ...donations.map((donation) => _DonationTile(donation: donation)),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  bool _matchesFilter(DonationModel donation) {
    if (_filter == 'money') return donation.amount != null;
    if (_filter == 'in_kind') return donation.amount == null;
    return true;
  }
}

class _DonationTile extends StatelessWidget {
  final DonationModel donation;

  const _DonationTile({required this.donation});

  @override
  Widget build(BuildContext context) {
    final provider = AppProviderScope.of(context);
    final isMoney = donation.amount != null;
    final title = isMoney ? 'تبرع مالي' : 'تبرع عيني';
    final subtitle = isMoney
        ? '${donation.amount!.toStringAsFixed(0)} ر.س'
        : careHomeValue(donation.itemType, 'مواد عينية');

    return CareHomeRefCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isMoney
                ? Icons.account_balance_wallet_outlined
                : Icons.inventory_2_outlined,
            color: careHomeRefText,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: careHomeRefBodyStrong),
                const SizedBox(height: 5),
                Text(
                  '${careHomeValue(donation.donorName, 'متبرع')} - $subtitle',
                  style: careHomeRefCaption,
                ),
                const SizedBox(height: 5),
                Text(_date(donation.donationDate ?? donation.createdAt),
                    style: careHomeRefCaption),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _Status(status: donation.status),
              const SizedBox(height: 10),
              if (donation.status != 'received')
                SizedBox(
                  width: 86,
                  height: 34,
                  child: CareHomeRefButton(
                    label: 'استلام',
                    loading: provider.isSaving,
                    onPressed: () =>
                        provider.confirmDonationReceived(donation.id),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Status extends StatelessWidget {
  final String status;

  const _Status({required this.status});

  @override
  Widget build(BuildContext context) {
    final done = status == 'received' || status == 'completed';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (done ? const Color(0xFF2DA56A) : careHomeRefOrange)
            .withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        done ? 'مكتمل' : 'قيد التنفيذ',
        style: careHomeRefCaption.copyWith(
          color: done ? const Color(0xFF2DA56A) : careHomeRefOrange,
        ),
      ),
    );
  }
}

String _date(DateTime? value) {
  if (value == null) return '--/--/----';
  return '${value.day.toString().padLeft(2, '0')}/'
      '${value.month.toString().padLeft(2, '0')}/${value.year}';
}
