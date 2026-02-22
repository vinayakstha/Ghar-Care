import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghar_care/features/home/presentation/widgets/category_card.dart';
import 'package:ghar_care/features/home/presentation/view_model/category_view_model.dart';
import 'package:ghar_care/features/home/presentation/widgets/home_header.dart';
import 'package:ghar_care/features/nav/presentation/widgets/upcoming_booking_card.dart';
import 'package:ghar_care/features/home/presentation/state/category_state.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(categoryViewModelProvider.notifier).getAllCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoryState = ref.watch(categoryViewModelProvider);

    return SizedBox.expand(
      child: Column(
        children: [
          const HomeHeader(),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Categories",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text("View More"),
                        ),
                      ],
                    ),
                  ),

                  if (categoryState.status == CategoryStatus.loading)
                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(),
                    ),

                  if (categoryState.status == CategoryStatus.error)
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        categoryState.errorMessage ?? "Something went wrong",
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),

                  if (categoryState.status == CategoryStatus.loaded)
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(12),
                      itemCount: categoryState.categories.length,
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 150,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 0.95,
                          ),
                      itemBuilder: (context, index) {
                        final category = categoryState.categories[index];

                        return CategoryCard(
                          imagePath:
                              'http://192.168.18.3:5050${category.categoryImage}',
                          category: category.categoryName,
                          categoryId: category.categoryId ?? '',
                        );
                      },
                    ),

                  const SizedBox(height: 10),

                  const UpcomingBookingCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
