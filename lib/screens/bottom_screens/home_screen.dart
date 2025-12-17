import 'package:flutter/material.dart';
import 'package:ghar_care/widgets/home_header.dart';
import 'package:ghar_care/widgets/offer_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> promo = [
    OfferCard(
      title: "20% OFF",
      description1: "For 1 day",
      description2: "D3T22U",
      imagePath: "assets/images/offer_image.jpg",
    ),
    OfferCard(
      title: "20% OFF",
      description1: "For 1 day",
      description2: "D3T22U",
      imagePath: "assets/images/offer_image.jpg",
    ),
    OfferCard(
      title: "20% OFF",
      description1: "For 1 day",
      description2: "D3T22U",
      imagePath: "assets/images/card_image.png",
    ),
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
                // height: 1000,
                child: Column(
                  children: [
                    SizedBox(
                      height: 190,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: promo.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: promo[index],
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Categories", style: TextStyle(fontSize: 22)),
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
