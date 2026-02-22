import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghar_care/features/favourite/presentation/view_model/favourite_view_model.dart';
import 'package:ghar_care/features/favourite/presentation/state/favourite_state.dart';
import 'package:ghar_care/features/service/presentation/widgets/service_card.dart';
import 'package:ghar_care/features/booking/presentation/pages/booking_screen.dart';

class FavouriteScreen extends ConsumerStatefulWidget {
  const FavouriteScreen({super.key});

  @override
  ConsumerState<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends ConsumerState<FavouriteScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(favouriteViewModelProvider.notifier).getFavouritesByUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final favouriteState = ref.watch(favouriteViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("My Favourites"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Builder(
          builder: (_) {
            if (favouriteState.status == FavouriteStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (favouriteState.status == FavouriteStatus.error) {
              return Center(
                child: Text(
                  favouriteState.errorMessage ?? "Something went wrong",
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            if (favouriteState.favourites.isEmpty) {
              return const Center(child: Text("No favourites yet ❤️"));
            }

            return ListView.separated(
              itemCount: favouriteState.favourites.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final favourite = favouriteState.favourites[index];
                final service = favourite.service;

                return ServiceCard(
                  imageUrl: "http://192.168.18.3:5050${service.serviceImage}",
                  serviceName: service.serviceName,
                  price: "Rs. ${service.price}",
                  isFavourite: true,

                  /// Navigate to booking
                  onCardTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            BookingScreen(serviceId: service.serviceId ?? ""),
                      ),
                    );
                  },

                  /// Remove from favourite
                  onFavorite: () async {
                    await ref
                        .read(favouriteViewModelProvider.notifier)
                        .deleteFavourite(
                          favouriteId: favourite.favouriteId ?? "",
                        );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
