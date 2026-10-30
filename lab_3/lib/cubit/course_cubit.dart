import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/course_service.dart';
import 'course_state.dart';

class CourseCubit extends Cubit<CourseState> {
  final CourseService courseService;
  Map<String, dynamic>? _originalData;

  String _searchQuery = '';
  String _filter = 'all';
  String _sort = 'default';

  CourseCubit(this.courseService) : super(CourseInitial());

  Future<void> loadCourses() async {
    emit(CourseLoading());
    try {
      final data = await courseService.loadData();
      if (data.isEmpty) {
        emit(CourseEmpty());
        return;
      }
      _originalData = data;
      _updateLessons();
    } catch (e) {
      emit(CourseError(e.toString()));
    }
  }

  void searchLessons(String query) {
    _searchQuery = query.toLowerCase().trim();
    _updateLessons();
  }

  void filterLessons(String filter) {
    _filter = filter;
    _updateLessons();
  }

  void sortLessons(String sort) {
    _sort = sort;
    _updateLessons();
  }

  void toggleFavorite() {
    if (_originalData == null) return;

    final data = Map<String, dynamic>.from(_originalData!);
    final page = Map<String, dynamic>.from(data['courseOverviewPage'] as Map);
    final course = Map<String, dynamic>.from(page['course'] as Map);

    course['isFavorite'] = !(course['isFavorite'] == true);
    page['course'] = course;
    data['courseOverviewPage'] = page;
    _originalData = data;

    // Recalculează lecțiile vizibile, fără să piardă căutarea sau filtrele.
    _updateLessons();
  }

  void _updateLessons() {
    if (_originalData == null) return;

    final data = _originalData!;
    final page = Map<String, dynamic>.from(
      data['courseOverviewPage'] as Map,
    );
    final course = Map<String, dynamic>.from(page['course'] as Map);
    final lessons = (course['lessons'] as List)
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();

    final originalCount = lessons.length;
    final visible = lessons.where((lesson) {
      final title = (lesson['title'] as String).toLowerCase();
      final matchesSearch = title.contains(_searchQuery);
      final matchesFilter = switch (_filter) {
        'available' => lesson['locked'] == false,
        'locked' => lesson['locked'] == true,
        _ => true,
      };
      return matchesSearch && matchesFilter;
    }).toList();

    if (_sort == 'shortest') {
      visible.sort((a, b) => (a['durationSeconds'] as int)
          .compareTo(b['durationSeconds'] as int));
    } else if (_sort == 'longest') {
      visible.sort((a, b) => (b['durationSeconds'] as int)
          .compareTo(a['durationSeconds'] as int));
    }

    course['lessons'] = visible;
    page['course'] = course;
    final updatedData = Map<String, dynamic>.from(data);
    updatedData['courseOverviewPage'] = page;

    if (originalCount == 0) {
      emit(CourseEmpty());
    } else {
      emit(CourseSuccess(updatedData));
    }
  }
}
