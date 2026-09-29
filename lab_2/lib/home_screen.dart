import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'courses_screen.dart';

// Culorile folosite în ecranul Home.
const _blue = Color(0xFF3D5CFF);
const _ink = Color(0xFF1F1F39);
const _muted = Color(0xFF858597);

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Deschide pagina Courses.
  void _openCourses(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const CoursesScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    // Bara de stare a telefonului, albastră pe ecranul Home.
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Antetul albastru și cardul alb „Learned today”.
                SizedBox(
                  height: 230 + topPadding,
                  child: Stack(
                    children: [
                      // Dreptunghiul albastru: extins și sub bara de stare.
                      Container(height: 183 + topPadding, color: _blue),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            SizedBox(height: 16 + topPadding),

                            // Salutul și avatarul din partea de sus.
                            Row(
                              children: [
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Hi, Kristin',
                                        style: TextStyle(
                                          fontSize: 23,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        "Let's start learning",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ClipOval(
                                  child: _art(
                                    'assets/images/avatar.png',
                                    width: 36,
                                    height: 49.98,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            // Cardul alb: timpul învățat și bara de progres.
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: _cardDecoration(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // „Learned today” și „My courses”.
                                  Row(
                                    children: [
                                      const Expanded(
                                        child: Text(
                                          'Learned today',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: _muted,
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () => _openCourses(context),
                                        child: const Text(
                                          'My courses',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: _blue,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 5),

                                  // Numărul de minute.
                                  const Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '46min',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: _ink,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 4),
                                        child: Text(
                                          ' / 60min',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: _muted,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 6),

                                  // Bara de progres cu gradient:
                                  // 46 din 60 de minute sunt completate.
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: LayoutBuilder(
                                      builder: (context, constraints) => Stack(
                                        children: [
                                          Container(
                                            width: constraints.maxWidth,
                                            height: 5,
                                            color: const Color(0xFFF4F3FD),
                                          ),
                                          Container(
                                            width:
                                            constraints.maxWidth * 46 / 60,
                                            height: 5,
                                            decoration: const BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Color(0x00FFFFFF),
                                                  Color(0xFFFF5106),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 17),

                // 2. Bannerele albastre, derulate orizontal.
                SizedBox(
                  height: 154,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      _learningBanner(context),
                      const SizedBox(width: 12),
                      _nextBanner(),
                    ],
                  ),
                ),

                const SizedBox(height: 27),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 3. Titlul și cardul „Learning Plan”.
                      const Text(
                        'Learning Plan',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: _ink,
                        ),
                      ),
                      const SizedBox(height: 13),
                      Container(
                        height: 122,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 15,
                        ),
                        decoration: _cardDecoration(),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _PlanRow('Packaging Design', 40, 48),
                            _PlanRow('Product Design', 6, 24),
                          ],
                        ),
                      ),

                      const SizedBox(height: 15),

                      // 4. Cardul mov „Meetup”.
                      Container(
                        height: 120,
                        decoration: _cardDecoration(
                          color: const Color(0xFFEFE0FF),
                        ),
                        child: Stack(
                          children: [
                            const Positioned(
                              left: 22,
                              top: 32,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Meetup',
                                    style: TextStyle(
                                      fontSize: 24.36,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF440687),
                                    ),
                                  ),
                                  Text(
                                    'Off-line exchange of learning experience',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF440687),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              right: 12,
                              top: 10,
                              child: _art(
                                'assets/images/meetup.png',
                                width: 100,
                                height: 100,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Primul banner: text, personaj și butonul „Get Started”.
  Widget _learningBanner(BuildContext context) => Container(
    width: 250,
    decoration: BoxDecoration(
      color: const Color(0xFFCEECFE),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          right: 0,
          bottom: 0,
          child: _art(
            'assets/images/home_learning.png',
            width: 128,
            height: 150,
          ),
        ),
        const Positioned(
          left: 18,
          top: 25,
          child: SizedBox(
            width: 277,
            child: Text(
              'What do you want to learn today?',
              maxLines: 1,
              softWrap: false,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _ink,
              ),
            ),
          ),
        ),
        Positioned(
          left: 18,
          bottom: 18,
          child: GestureDetector(
            onTap: () => _openCourses(context),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 9,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6D1B),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'Get Started',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );

  // Al doilea banner, vizibil parțial lângă primul.
  Widget _nextBanner() => Container(
    width: 250,
    decoration: BoxDecoration(
      color: const Color(0xFFDBF2FF),
      borderRadius: BorderRadius.circular(16),
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            bottom: 0,
            child: _art(
              'assets/images/home_learning_more.png',
              width: 128,
              height: 150,
            ),
          ),
        ],
      ),
    ),
  );
}

// Un rând din „Learning Plan”: cerc, titlu și progres numeric.
class _PlanRow extends StatelessWidget {
  final String name;
  final int done;
  final int total;

  const _PlanRow(this.name, this.done, this.total);

  @override
  Widget build(BuildContext context) => Row(
    children: [
      SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          value: done / total,
          strokeWidth: 2.5,
          backgroundColor: const Color(0xFFEEF0FF),
          valueColor: const AlwaysStoppedAnimation(
            Color(0xFF737F81),
          ),
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Text(
          name,
          style: const TextStyle(fontSize: 14, color: _ink),
        ),
      ),
      Text(
        '$done',
        style: const TextStyle(fontSize: 14, color: _ink),
      ),
      Text(
        '/$total',
        style: const TextStyle(fontSize: 14, color: _muted),
      ),
    ],
  );
}

// Aspectul comun al cardurilor albe și al cardului Meetup.
BoxDecoration _cardDecoration({Color color = Colors.white}) => BoxDecoration(
  color: color,
  borderRadius: BorderRadius.circular(14),
  boxShadow: const [
    BoxShadow(
      color: Color(0x100F2055),
      blurRadius: 12,
      offset: Offset(0, 5),
    ),
  ],
);

// Încarcă o imagine din assets/images/.
Widget _art(
    String path, {
      required double width,
      required double height,
    }) =>
    Image.asset(
      path,
      width: width,
      height: height,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => SizedBox(
        width: width,
        height: height,
      ),
    );