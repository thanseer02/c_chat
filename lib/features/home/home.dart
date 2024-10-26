import 'package:base_project/utls/styles.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static const routeName = '/HomeScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF21262d),
      body: SizedBox.expand(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              child: Image.network(
                'https://i.pinimg.com/736x/18/62/b7/1862b79af07473ded7740d5b943209bf.jpg',
              ),
            ),
            const Positioned(
              top: 400,
              right: 10,
              child: GradientBall(
                size: Size.square(200),
                colors: [Colors.blue, Colors.purple],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.spMin),
              child: BlurryContainer(
                blur: 8,
                height: 240,
                elevation: 6,
                padding: const EdgeInsets.all(32),
                color: Colors.red.withOpacity(0.15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.transparent,
                      backgroundImage: NetworkImage(
                        'https://i.pinimg.com/736x/18/62/b7/1862b79af07473ded7740d5b943209bf.jpg',
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Unpredictable Ninga'.toUpperCase(),
                      style: tsS20W400,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          'UzuMakki Naruto'.toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.w200,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'VALID',
                          style: TextStyle(
                            fontWeight: FontWeight.w200,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '06/24',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GradientBall extends StatelessWidget {
  const GradientBall({
    required this.colors,
    super.key,
    this.size = const Size.square(150),
  });
  final List<Color> colors;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height,
      width: size.width,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: colors,
        ),
      ),
    );
  }
}
