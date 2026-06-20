import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textDarkPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'التنبيهات',
          style: TextStyle(color: AppColors.textDarkPrimary, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.innerBorder),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: AppColors.brandOrange,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: AppColors.brandOrange.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],
              ),
              labelColor: Colors.white,
              unselectedLabelColor: AppColors.textDarkMuted,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
              tabs: const [Tab(text: 'الجديدة'), Tab(text: 'السابقة')],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildNotificationList(true),
          _buildNotificationList(false),
        ],
      ),
    );
  }

  Widget _buildNotificationList(bool isNewList) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemCount: 3,
      itemBuilder: (context, index) => _buildModernNotificationCard(
        title: isNewList ? 'تم قبول طلبك! 🎉' : 'توثيق عمل إنساني 🌟',
        body: 'أماني، لقد تم اعتمادك رسمياً كمتطوعة في دار غريان. شكراً لعطائك المستمر.',
        time: isNewList ? 'منذ 5 دقائق' : 'أمس',
        type: isNewList ? 'success' : 'achievement',
        isNew: isNewList,
      ),
    );
  }

  Widget _buildModernNotificationCard({
    required String title, required String body, required String time, required String type, required bool isNew,
  }) {
    Color color = type == 'success' ? Colors.green : const Color(0xFFFFB300);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.innerBorder),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 6))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(type == 'success' ? Icons.check_circle_outline_rounded : Icons.workspace_premium_rounded, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, fontFamily: 'Tajawal')),
                const SizedBox(height: 4),
                Text(body, style: TextStyle(color: Colors.grey[600], fontSize: 12, fontFamily: 'Tajawal')),
                const SizedBox(height: 8),
                Text(time, style: const TextStyle(color: AppColors.brandOrange, fontSize: 10, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}