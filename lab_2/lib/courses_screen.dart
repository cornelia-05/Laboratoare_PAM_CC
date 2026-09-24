import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _ink = Color(0xFF252B43);
const _blue = Color(0xFF3658F6);
const _hint = Color(0xFF9DA4BB);

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  String _query = '';
  int _selectedTab = 0;

  static const _courses = [
    _Course('Product Design v1.0', 'Robertson Connie', '\$190', '16 hours'),
    _Course('Java Development', 'Nguyen Shane', '\$190', '16 hours'),
    _Course('Visual Design', 'Bert Pullman', '\$250', '14 hours'),
  ];

  @override
  Widget build(BuildContext context) {
    final visible = _courses.where((course) =>
    course.title.toLowerCase().contains(_query.toLowerCase()) ||
        course.teacher.toLowerCase().contains(_query.toLowerCase())).toList();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 28),
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back, color: _ink),
                    tooltip: 'Înapoi la Home',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                  ),
                  const SizedBox(width: 6),
                  const Expanded(child: Text('Course', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _ink))),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/avatar.png', width: 48, height: 48, fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const SizedBox(width: 48, height: 48),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                height: 48,
                decoration: BoxDecoration(color: const Color(0xFFF5F5FF), borderRadius: BorderRadius.circular(14)),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    const Icon(Icons.search, size: 20, color: _hint),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        onChanged: (value) => setState(() => _query = value),
                        style: const TextStyle(fontSize: 14, color: _ink),
                        decoration: const InputDecoration(
                          hintText: 'Find Course',
                          hintStyle: TextStyle(fontSize: 14, color: _hint),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                    const Icon(Icons.tune, size: 19, color: _hint),
                  ],
                ),
              ),
              const SizedBox(height: 34),
              Row(
                children: [
                  Expanded(child: _CategoryTile('Language', 'assets/images/category_language.png', const Color(0xFFD5EFFF), _blue)),
                  const SizedBox(width: 14),
                  Expanded(child: _CategoryTile('Painting', 'assets/images/category_painting.png', const Color(0xFFF1DFFF), const Color(0xFF8254A6))),
                ],
              ),
              const SizedBox(height: 37),
              const Text('Choice your course', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: _ink)),
              const SizedBox(height: 14),
              Row(
                children: List.generate(3, (index) {
                  // "Poular" follows the spelling visible in the provided design.
                  final label = ['All', 'Poular', 'New'][index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 13),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTab = index),
                      child: Container(
                        width: 74, height: 30,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _selectedTab == index ? _blue : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(label, style: TextStyle(fontSize: 13, color: _selectedTab == index ? Colors.white : const Color(0xFF747C98))),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),
              for (final course in visible) ...[
                _CourseCard(course),
                const SizedBox(height: 14),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final String label;
  final String image;
  final Color background;
  final Color textColor;

  const _CategoryTile(this.label, this.image, this.background, this.textColor);

  @override
  Widget build(BuildContext context) => Container(
    height: 78,
    decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(14)),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Stack(
        children: [
          Positioned(
            left: 0, top: 0,
            child: Image.asset(image, width: 95, height: 78, fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const SizedBox(width: 95, height: 78)),
          ),
          Positioned(
            right: 5, bottom: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(3)),
              child: Text(label, style: TextStyle(fontSize: 13, color: textColor)),
            ),
          ),
        ],
      ),
    ),
  );
}

class _Course {
  final String title;
  final String teacher;
  final String price;
  final String hours;

  const _Course(this.title, this.teacher, this.price, this.hours);
}

class _CourseCard extends StatelessWidget {
  final _Course course;

  const _CourseCard(this.course);

  @override
  Widget build(BuildContext context) => Container(
    height: 98,
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: const [BoxShadow(color: Color(0x0B242456), blurRadius: 10, offset: Offset(0, 5))],
    ),
    child: Row(
      children: [
        Container(
          width: 69, height: 69,
          decoration: BoxDecoration(color: const Color(0xFFC8C8C8), borderRadius: BorderRadius.circular(9)),
        ),
        const SizedBox(width: 35),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(course.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14, color: _ink)),
              const SizedBox(height: 2),
              Row(
                children: [
                  const Icon(Icons.person, size: 12, color: _hint),
                  const SizedBox(width: 4),
                  Expanded(child: Text(course.teacher, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: _hint))),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(course.price, style: const TextStyle(fontSize: 16, color: _blue, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: const Color(0xFFFFEAF0), borderRadius: BorderRadius.circular(10)),
                    child: Text(course.hours, style: const TextStyle(fontSize: 10, color: Color(0xFFFF6F41))),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
