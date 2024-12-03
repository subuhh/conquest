import 'package:flutter/material.dart' hide Visibility;
import 'package:get/get.dart';
import '../../../core/Controllers/community_controller/category_controller.dart';
import '../../../core/model/community/post_model.dart';

class CategoryFilterBottomSheet extends StatelessWidget {
  final controller = Get.put(CategoryFilterController());

  CategoryFilterBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.99,
      minChildSize: 0.6,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 10,
                offset: Offset(0, -3),
              ),
            ],
          ),
          child: ListView(
            controller: scrollController,
            padding: EdgeInsets.zero,
            children: [
              _buildHeader(),
              _buildFilterSection(
                title: 'Search',
                child: _buildSearchBar(),
              ),
              _buildFilterSection(
                title: 'Categories',
                child: _buildCategoryFilter(),
              ),
              // _buildFilterSection(
              //   title: 'Visibility',
              //   child: _buildVisibilityFilter(),
              // ),
              _buildFilterSection(
                title: 'Date Range',
                child: _buildDateRangeFilter(),
              ),
              _buildFilterSection(
                title: 'Engagement Filters',
                child: _buildEngagementFilter(),
              ),
              _buildActionButtons(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterSection({
    required String title,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Filter Posts',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.black54,
              size: 26,
            ),
            onPressed: () => Get.back(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: controller.searchController,
      decoration: InputDecoration(
        hintText: 'Search posts...',
        hintStyle: TextStyle(color: Colors.grey),
        prefixIcon: Icon(Icons.search, color: Colors.grey),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Get.theme.primaryColor, width: 1.5),
        ),
      ),
      cursorColor: Get.theme.primaryColor,
    );
  }

  Widget _buildCategoryFilter() {
    return Obx(() => Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: Category.values.map((category) {
            return FilterChip(
              label: Text(
                category.toString().split('.').last.capitalize!,
                style: TextStyle(
                  color: controller.selectedCategories.contains(category)
                      ? Colors.white
                      : Colors.black87,
                ),
              ),
              selected: controller.selectedCategories.contains(category),
              onSelected: (_) => controller.toggleCategory(category),
              selectedColor: Get.theme.primaryColor,
              backgroundColor: Colors.grey.shade200,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            );
          }).toList(),
        ));
  }

  Widget _buildVisibilityFilter() {
    return Obx(() => Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: Visibility.values.map((visibility) {
            return FilterChip(
              label: Text(
                visibility.toString().split('.').last.capitalize!,
                style: TextStyle(
                  color: controller.selectedVisibility.contains(visibility)
                      ? Colors.white
                      : Colors.black87,
                ),
              ),
              selected: controller.selectedVisibility.contains(visibility),
              onSelected: (_) => controller.toggleVisibility(visibility),
              selectedColor: Get.theme.primaryColor,
              backgroundColor: Colors.grey.shade200,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            );
          }).toList(),
        ));
  }

  Widget _buildDateRangeFilter() {
    return Obx(() {
      final dateRange = controller.selectedDateRange.value;
      return Container(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: controller.selectDateRange,
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Colors.grey.shade300),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dateRange == null
                    ? 'Select Date Range'
                    : '${dateRange.start.toLocal()}'.split(' ')[0] +
                        ' - ' +
                        '${dateRange.end.toLocal()}'.split(' ')[0],
                style: TextStyle(
                  color: dateRange == null ? Colors.grey : Colors.black87,
                ),
              ),
              Icon(Icons.calendar_today, color: Colors.grey),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildEngagementFilter() {
    return Column(
      children: [
        _buildSliderFilter(
          label: 'Likes',
          value: controller.minLikes,
          max: 1000,
          divisions: 100,
        ),
        SizedBox(height: 10),
        _buildSliderFilter(
          label: 'Comments',
          value: controller.minComments,
          max: 500,
          divisions: 50,
        ),
      ],
    );
  }

  Widget _buildSliderFilter({
    required String label,
    required RxInt value,
    required double max,
    required int divisions,
  }) {
    return Obx(() => Row(
          children: [
            Expanded(
              flex: 3,
              child: Slider(
                value: value.value.toDouble(),
                min: 0,
                max: max,
                divisions: divisions,
                label: 'Min $label: ${value.value}',
                activeColor: Get.theme.primaryColor,
                inactiveColor: Colors.grey.shade300,
                onChanged: (double newValue) {
                  value.value = newValue.toInt();
                },
              ),
            ),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ));
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade200,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed: controller.resetFilters,
              child: Text(
                'Reset',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Get.theme.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed: controller.applyFilters,
              child: Text(
                'Apply',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
