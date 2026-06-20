import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class SearchFilterScreen extends StatefulWidget {
  const SearchFilterScreen({super.key});

  @override
  State<SearchFilterScreen> createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends State<SearchFilterScreen> {
  String _activeUrgencyFilter = 'الكل';
  final List<String> _urgencies = const ['الكل', 'عاجل جداً', 'عاجل', 'متوسط'];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text('البحث الذكي عن الحالات', style: TextStyle(fontFamily: 'Cairo', fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDarkPrimary)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildModernSearchBar(),
              const SizedBox(height: 24),
              const Text('درجة استعجال الحالة:', style: TextStyle(fontFamily: 'Cairo', fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDarkSecondary)),
              const SizedBox(height: 12),
              _buildChipsFilterRow(),
              const SizedBox(height: 32),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off_rounded, size: 54, color: AppColors.textDarkMuted.withOpacity(0.5)),
                    const SizedBox(height: 12),
                    const Text('ابدأ بكتابة كلمات البحث مثل "سلات، كفالة، غريان"', style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5, color: AppColors.textDarkMuted)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernSearchBar() {
    return TextField(
      style: const TextStyle(fontFamily: 'Cairo', fontSize: 14),
      decoration: InputDecoration(
        hintText: 'ابحث عن حالة، دار رعاية، أو نوع احتياج...',
        hintStyle: const TextStyle(color: AppColors.textDarkMuted),
        prefixIcon: const Icon(Icons.search_rounded, color: AppColors.brandOrange),
        filled: true,
        fillColor: AppColors.scaffoldBackground,
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.innerBorder, width: 1.2)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.brandOrange, width: 1.5)),
      ),
    );
  }

  Widget _buildChipsFilterRow() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _urgencies.map((urgency) {
        final bool isSelected = _activeUrgencyFilter == urgency;
        return ChoiceChip(
          label: Text(urgency),
          selected: isSelected,
          selectedColor: AppColors.brandOrange,
          backgroundColor: AppColors.scaffoldBackground,
          labelStyle: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.white : AppColors.textDarkSecondary,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: isSelected ? AppColors.brandOrange : AppColors.innerBorder)),
          onSelected: (bool selected) {
            if (selected) setState(() => _activeUrgencyFilter = urgency);
          },
        );
      }).toList(),
    );
  }
}