import 'package:flutter/material.dart';
import 'package:ghar_care/screens/signup_screen.dart';
import 'package:ghar_care/widgets/my_onboarding.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Widget> _pages = [
    MyOnboarding(
      title: "Book Services Easily",
      description:
          "Find trusted professionals for cleaning, plumbing, electrical work and more with just a few taps.",
      imagePath: "assets/images/onboarding1.png",
    ),
    MyOnboarding(
      title: "Fast & Reliable",
      description:
          "Get verified and experienced service providers at yout doorstep. Quick, sage and hassle free.",
      imagePath: "assets/images/onboarding2.png",
    ),
    MyOnboarding(
      title: "Secure & Easy Payments",
      description: "Enjoy transparent pricing and make secure online payments.",
      imagePath: "assets/images/onboarding3.png",
    ),
  ];

  void _skip() {
    _pageController.animateToPage(
      _pages.length - 1,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _next() {
    if (_currentIndex < _pages.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  void _finish() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignupScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) => _pages[index],
          ),
          _currentIndex == _pages.length - 1
              ? SizedBox.shrink()
              : Positioned(
                  bottom: 40,
                  left: 20,
                  child: TextButton(
                    onPressed: _skip,
                    child: Text(
                      "Skip",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
          Positioned(
            bottom: 40,
            right: 20,
            child: TextButton(
              onPressed: _next,
              child: Text(
                _currentIndex == _pages.length - 1 ? "Finish" : "Next",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 50,
            child: Center(
              child: SmoothPageIndicator(
                controller: _pageController,
                count: _pages.length,
                effect: WormEffect(
                  dotHeight: 12,
                  dotWidth: 12,
                  activeDotColor: Colors.blue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
