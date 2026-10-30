abstract class CourseState {}

class CourseInitial extends CourseState {}

class CourseLoading extends CourseState {}

class CourseSuccess extends CourseState {
  final Map<String, dynamic> data;

  CourseSuccess(this.data);
}

class CourseEmpty extends CourseState {}

class CourseError extends CourseState {
  final String message;

  CourseError(this.message);
}