import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class InkindDonationScreen extends StatefulWidget {
  const InkindDonationScreen({super.key});

  @override
  State<InkindDonationScreen> createState() => _InkindDonationScreenState();
}

class _InkindDonationScreenState extends State<InkindDonationScreen> {
  String _selectedType = '';

  final List<Map<String, dynamic>> _donationTypes = [
    {'id': 'food', 'title': 'مواد غذائية وتموينية', 'desc': 'سلات غذائية، لحوم، حليب أطفال، معلبات', 'icon': Icons.restaurant_rounded},
    {'id': 'clothes', 'title': 'ملابس وكسوة شتوية/صيفية', 'desc': 'ملابس جديدة، أحذية، بطانيات، أغطية', 'icon': Icons.checkroom_rounded},
    {'id': 'school', 'title': 'مستلزمات وقرطاسية دراسية', 'desc': 'حقائب مدرسية، دفاتر، أقلام، أجهزة تعليمية', 'icon': Icons.school_rounded},
    {'id': 'health', 'title': 'رعاية صحية ومستلزمات طبية', 'desc': 'أدوية أطفال، حفاضات، كراسي متحركة، إسعافات', 'icon': Icons.medical_services_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textDarkPrimary, size: 18),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text('تبرع عيني بالمواد', style: TextStyle(fontFamily: 'Cairo', fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDarkPrimary)),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                itemCount: _donationTypes.length,
                itemBuilder: (context, index) {
                  final type = _donationTypes[index];
                  final bool isSelected = _selectedType == type['id'];

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: isSelected ? AppColors.brandOrange : AppColors.innerBorder, width: isSelected ? 1.6 : 1.2),
                    ),
                    child: InkWell(
                      onTap: () => setState(() => _selectedType = type['id']),
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.brandOrangeLight : AppColors.scaffoldBackground,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(type['icon'], color: isSelected ? AppColors.brandOrange : AppColors.textDarkSecondary, size: 24),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    type['title'],
                                    style: TextStyle(fontFamily: 'Cairo', fontSize: 14, fontWeight: FontWeight.bold, color: isSelected ? AppColors.brandOrangeDark : AppColors.textDarkPrimary),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    type['desc'],
                                    style: const TextStyle(fontFamily: 'Cairo', fontSize: 11.5, color: AppColors.textDarkMuted),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            _buildNextButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    bool hasSelection = _selectedType.isNotEmpty;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
      decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: AppColors.innerBorder))),
      child: Container(
        height: 52,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: hasSelection ? const LinearGradient(colors: AppColors.orangeGradient) : null,
          color: hasSelection ? null : AppColors.innerBorder,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
          onPressed: hasSelection
              ? () {
                  // 💎 تم استبدال التعليق وربطه بصفحة النجاح مباشرة لإتمام الإجراء محاكاةً
                  Navigator.pushNamed(context, '/donation_success');
                }
              : null,
          child: Text(
            'متابعة تفاصيل التبرع',
            style: TextStyle(fontFamily: 'Cairo', fontSize: 14, fontWeight: FontWeight.bold, color: hasSelection ? Colors.white : AppColors.textDarkMuted),
          ),
        ),
      ),
    );
  }
}