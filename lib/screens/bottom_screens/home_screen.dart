import 'package:flutter/material.dart';
import 'package:ghar_care/widgets/category_card.dart';
import 'package:ghar_care/widgets/home_header.dart';
import 'package:ghar_care/widgets/offer_card.dart';
import 'package:ghar_care/widgets/upcoming_booking_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> promo = [
    OfferCard(
      title: "GET 20% OFF",
      description: "On all Services",
      imagePath: "assets/images/offer_image.jpg",
    ),
    OfferCard(
      title: "GET 20% OFF",
      description: "On all Services",
      imagePath: "assets/images/offer_image.jpg",
    ),
  ];

  List<Widget> categories = [
    CategoryCard(imagePath: "assets/icons/plumbing.png", category: "Plumbing"),
    CategoryCard(
      imagePath: "assets/icons/electrician.png",
      category: "Electrical",
    ),
    CategoryCard(imagePath: "assets/icons/cleaning.png", category: "Cleaning"),
    CategoryCard(imagePath: "assets/icons/painting.png", category: "Painting"),
    CategoryCard(
      imagePath: "assets/icons/appliance.png",
      category: "Appliance Repair",
    ),
    CategoryCard(imagePath: "assets/icons/pest.png", category: "Pest Control"),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Column(
        children: [
          HomeHeader(),

          Expanded(
            child: SingleChildScrollView(
              child: SizedBox(
                child: Column(
                  children: [
                    SizedBox(
                      height: 190,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: promo.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 9),
                            child: promo[index],
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Categories",
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: "Inter bold",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              "View More",
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      padding: const EdgeInsets.all(12),
                      children: categories,
                    ),
                    UpcomingBookingCard(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
