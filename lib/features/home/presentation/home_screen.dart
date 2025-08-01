import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/locator.dart';
import 'bloc/home_bloc.dart';
import 'bloc/home_event.dart';
import 'bloc/home_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String sanitizePosterUrl(String url) {
    if (url.startsWith('http://')) {
      return url.replaceFirst('http://', 'https://');
    }
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => locator<HomeBloc>()
        ..add(CheckAuthToken())
        ..add(const GetMoviesEvent(page: 1)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Ana Sayfa'),
        ),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HomeLoaded) {
              return ListView.builder(
                itemCount: state.movies.length,
                itemBuilder: (context, index) {
                  final movie = state.movies[index];
                  return ListTile(
                    leading: movie.poster.isNotEmpty
                        ? Image.network(sanitizePosterUrl(movie.poster))
                        : const Icon(Icons.movie),
                    title: Text(movie.title),
                    subtitle: Text(movie.year),
                  );
                },
              );
            } else if (state is HomeError) {
              return Center(child: Text('Hata: ${state.message}'));
            }
            return const Center(child: Text('Film bulunamadı.'));
          },
        ),
      ),
    );
  }
}
