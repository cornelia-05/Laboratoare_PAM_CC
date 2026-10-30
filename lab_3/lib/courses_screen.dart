import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/course_cubit.dart';
import 'cubit/course_state.dart';

const _orange = Color(0xFFFF7000);
const _ink = Color(0xFF292929);
const _grey = Color(0xFF989898);
const _background = Color(0xFFF8FAFF);

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  String _selectedTab = 'lessons';
  bool _showTools = false;
  String _filter = 'all';
  String _sort = 'default';

  void _message(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: _background,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: _background,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: _background,
        body: SafeArea(
          child: BlocBuilder<CourseCubit, CourseState>(
            builder: (context, state) {
              if (state is CourseInitial || state is CourseLoading) {
                return const Center(child: CircularProgressIndicator(color: _orange));
              }
              if (state is CourseError) {
                return _InfoState(
                  text: 'Eroare la încărcarea cursului:\n${state.message}',
                  action: () => context.read<CourseCubit>().loadCourses(),
                );
              }
              if (state is CourseEmpty) {
                return const _InfoState(text: 'Nu există date despre curs.');
              }
              if (state is! CourseSuccess) {
                return const SizedBox.shrink();
              }

              final page = state.data['courseOverviewPage'];
              if (page is! Map<String, dynamic> || page.isEmpty) {
                return const _InfoState(text: 'Nu există date pentru Course Overview.');
              }
              final course = page['course'] as Map<String, dynamic>? ?? {};
              final navigation = page['navigation'] as Map<String, dynamic>? ?? {};
              final actions = page['actions'] as Map<String, dynamic>? ?? {};
              final price = actions['price'] as Map<String, dynamic>? ?? {};
              final enroll = actions['enroll'] as Map<String, dynamic>? ?? {};
              final hero = course['hero'] as Map<String, dynamic>? ?? {};
              final tabs = course['tabs'] as Map<String, dynamic>? ?? {};
              final lessons = (course['lessons'] as List<dynamic>? ?? []);
              final tabItems = (tabs['items'] as List<dynamic>? ?? []);

              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 24, top: 8, right: 20),
                            child: SizedBox(
                              height: 53,
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () => Navigator.of(context).pop(),
                                    child: const SizedBox(
                                      width: 25,
                                      height: 42,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Icon(Icons.arrow_back_ios_new, size: 21, color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    '${navigation['title'] ?? 'Course Overview'}',
                                    style: const TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.w600, color: _ink,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 42),
                          Padding(
                            padding: const EdgeInsets.only(left: 45, right: 28),
                            child: AspectRatio(
                              aspectRatio: 292 / 181,
                              child: GestureDetector(
                                onTap: () => _message('Previzualizare: ${hero['label'] ?? 'Video'}'),
                                child: Image.asset(
                                  'assets/images/course_hero_reference.png',
                                  width: double.infinity,
                                  fit: BoxFit.fill,
                                  errorBuilder: (_, __, ___) => Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      gradient: const LinearGradient(
                                        colors: [Color(0xFF8655F8), Color(0xFFCE9A9B)],
                                        begin: Alignment.topCenter, end: Alignment.bottomCenter,
                                      ),
                                    ),
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text('${hero['label'] ?? ''}',
                                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                          const SizedBox(height: 30),
                                          const CircleAvatar(
                                            radius: 24, backgroundColor: Colors.white,
                                            child: Icon(Icons.play_arrow, color: _orange, size: 30),
                                          ),
                                          const SizedBox(height: 25),
                                          Text('${hero['videoCount'] ?? 0} Videos     ${hero['classCount'] ?? 0} Class',
                                              style: const TextStyle(color: Colors.white, fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),
                          Padding(
                            padding: const EdgeInsets.only(left: 45, right: 28),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${course['title'] ?? ''}',
                                        style: const TextStyle(
                                          fontSize: 17,
                                          color: _ink,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      tooltip: course['isFavorite'] == true
                                          ? 'Elimină din favorite'
                                          : 'Adaugă la favorite',
                                      onPressed: () =>
                                          context.read<CourseCubit>().toggleFavorite(),
                                      icon: Icon(
                                        course['isFavorite'] == true
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: course['isFavorite'] == true
                                            ? Colors.red
                                            : _grey,
                                        size: 23,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 7),
                                Row(
                                  children: [
                                    const Icon(Icons.access_time, size: 13, color: _grey),
                                    const SizedBox(width: 3),
                                    Text('${course['duration'] ?? ''}  ·  ${course['lessonCount'] ?? lessons.length} lessons',
                                        style: const TextStyle(fontSize: 12, color: _grey)),
                                    const Spacer(),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEAF4FF),
                                        borderRadius: BorderRadius.circular(7),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.star, color: Color(0xFFFFB300), size: 15),
                                          Text(' ${course['rating'] ?? ''}',
                                              style: const TextStyle(fontSize: 12, color: _orange)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 19),
                          Padding(
                            padding: const EdgeInsets.only(left: 30, right: 28),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Spacer(),
                                for (final item in tabItems)
                                  _TabButton(
                                    label: '${(item as Map<String, dynamic>)['label'] ?? ''}',
                                    selected: _selectedTab == '${item['id']}',
                                    onTap: () => setState(() => _selectedTab = '${item['id']}'),
                                  ),
                                const Spacer(),
                                IconButton(
                                  tooltip: 'Căutare, filtrare și sortare',
                                  onPressed: () => setState(() => _showTools = !_showTools),
                                  icon: Icon(_showTools ? Icons.close : Icons.tune,
                                      color: _orange, size: 20),
                                ),
                              ],
                            ),
                          ),
                          if (_showTools && _selectedTab == 'lessons')
                            Padding(
                              padding: const EdgeInsets.fromLTRB(45, 10, 28, 10),
                              child: Column(
                                children: [
                                  TextField(
                                    onChanged: context.read<CourseCubit>().searchLessons,
                                    decoration: InputDecoration(
                                      hintText: 'Caută o lecție',
                                      prefixIcon: const Icon(Icons.search),
                                      isDense: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: DropdownButtonFormField<String>(
                                          value: _filter,
                                          isExpanded: true,
                                          decoration: const InputDecoration(
                                            labelText: 'Filtrare', isDense: true,
                                          ),
                                          items: const [
                                            DropdownMenuItem(value: 'all', child: Text('Toate')),
                                            DropdownMenuItem(value: 'available', child: Text('Disponibile')),
                                            DropdownMenuItem(value: 'locked', child: Text('Blocate')),
                                          ],
                                          onChanged: (value) {
                                            if (value == null) return;
                                            setState(() => _filter = value);
                                            context.read<CourseCubit>().filterLessons(value);
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: DropdownButtonFormField<String>(
                                          value: _sort,
                                          isExpanded: true,
                                          decoration: const InputDecoration(
                                            labelText: 'Sortare', isDense: true,
                                          ),
                                          items: const [
                                            DropdownMenuItem(value: 'default', child: Text('Inițială')),
                                            DropdownMenuItem(value: 'shortest', child: Text('Durată ↑')),
                                            DropdownMenuItem(value: 'longest', child: Text('Durată ↓')),
                                          ],
                                          onChanged: (value) {
                                            if (value == null) return;
                                            setState(() => _sort = value);
                                            context.read<CourseCubit>().sortLessons(value);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(height: 15),
                          if (_selectedTab == 'lessons' && lessons.isEmpty)
                            const Padding(
                              padding: EdgeInsets.all(25),
                              child: Center(child: Text('Nu există lecții pentru criteriile alese.')),
                            ),
                          if (_selectedTab == 'lessons')
                            for (final rawLesson in lessons)
                              _LessonRow(
                                lesson: rawLesson as Map<String, dynamic>,
                                onTap: () {
                                  final lesson = rawLesson;
                                  if (lesson['locked'] == true) {
                                    _message('Lecția este blocată');
                                  } else {
                                    _message('Lecția: ${lesson['title']}');
                                  }
                                },
                              )
                          else
                            Padding(
                              padding: const EdgeInsets.fromLTRB(45, 15, 28, 20),
                              child: Text(
                                '${(course['description'] as Map<String, dynamic>?)?['text'] ?? ''}'.trim().isEmpty
                                    ? 'Descrierea cursului nu este disponibilă.'
                                    : '${(course['description'] as Map<String, dynamic>)['text']}',
                                style: const TextStyle(fontSize: 14, color: _grey),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(45, 0, 28, 13),
                    child: Row(
                      children: [
                        Container(
                          width: 60, height: 42,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(11),
                            border: Border.all(color: const Color(0xFFF1F1F1)),
                          ),
                          child: Text('${price['label'] ?? 'Free'}',
                              style: const TextStyle(color: _orange, fontSize: 13, fontWeight: FontWeight.w600)),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: SizedBox(
                            height: 42,
                            child: ElevatedButton(
                              onPressed: enroll['enabled'] == false ? null : () => _message('Înscriere selectată'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _orange,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
                              ),
                              child: Text('${enroll['label'] ?? 'Enroll Now'}',
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TabButton({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 106,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Text(label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: selected ? _orange : const Color(0xFFD0D0D0),
                  )),
            ),
            Container(height: 2, width: 90, color: selected ? _orange : Colors.transparent),
          ],
        ),
      ),
    );
  }
}

class _LessonRow extends StatelessWidget {
  final Map<String, dynamic> lesson;
  final VoidCallback onTap;

  const _LessonRow({required this.lesson, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final locked = lesson['locked'] == true;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 45, right: 28),
        child: SizedBox(
          height: 62,
          child: Row(
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: locked ? Colors.transparent : Colors.white,
                  boxShadow: locked ? null : const [
                    BoxShadow(color: Color(0x0B000000), blurRadius: 10, offset: Offset(0, 4)),
                  ],
                ),
                child: Icon(Icons.play_arrow_rounded,
                    size: 21, color: locked ? const Color(0xFFFFDFCC) : _orange),
              ),
              const SizedBox(width: 21),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${lesson['title'] ?? ''}',
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w500,
                          color: locked ? const Color(0xFFDADADA) : _ink,
                        )),
                    const SizedBox(height: 3),
                    Text('${lesson['duration'] ?? ''} min',
                        style: TextStyle(fontSize: 12,
                            color: locked ? const Color(0xFFEAEAEA) : const Color(0xFFB0B0B0))),
                  ],
                ),
              ),
              Icon(Icons.chevron_right,
                  size: 24, color: locked ? const Color(0xFFFFDFCC) : _orange),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoState extends StatelessWidget {
  final String text;
  final VoidCallback? action;
  const _InfoState({required this.text, this.action});

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(text, textAlign: TextAlign.center),
              if (action != null)
                TextButton(onPressed: action, child: const Text('Reîncearcă')),
            ],
          ),
        ),
      );
}
