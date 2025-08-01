import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/locator.dart';
import '../../movie/domain/entities/movie_entity.dart';
import '../../../shared/widgets/bottom_nav_bar.dart'; // New import
import 'bloc/home_bloc.dart';
import 'bloc/home_event.dart';
import 'bloc/home_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => locator<HomeBloc>()
        ..add(CheckAuthToken())
        ..add(const GetMoviesEvent()),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HomeLoaded) {
              if (state.movies.isEmpty) {
                return const Center(child: Text('Film bulunamadı.', style: TextStyle(color: Colors.white)));
              }
              return PageView.builder(
                controller: PageController(), // PageView için bir controller gerekli
                itemCount: state.hasReachedMax ? state.movies.length : state.movies.length + 1,
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                onPageChanged: (index) {
                  if (index >= state.movies.length - 1 && !state.hasReachedMax) {
                    context.read<HomeBloc>().add(LoadMoreMovies());
                  }
                },
                itemBuilder: (context, index) {
                  return index >= state.movies.length
                      ? const Center(child: CircularProgressIndicator())
                      : _MoviePageItem(movie: state.movies[index]);
                },
              );
            } else if (state is HomeError) {
              return Center(child: Text('Hata: ${state.message}', style: const TextStyle(color: Colors.white)));
            }
            return const Center(child: Text('Başlangıç.', style: TextStyle(color: Colors.white)));
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) context.read<HomeBloc>().add(LoadMoreMovies());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}


class _MoviePageItem extends StatelessWidget {
  final MovieEntity movie;

  const _MoviePageItem({required this.movie});

  String _sanitizeUrl(String url) {
    if (url.startsWith('http://')) {
      return url.replaceFirst('http://', 'https://');
    }
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _buildBackgroundImage(),
        _buildGradientOverlay(),
        _buildLikeButton(context), // context parametresi eklendi
        _buildUserInfo(),
        BottomNavBar(currentIndex: 0, onItemTapped: (index) { // Yeni widget burada kullanılıyor
          if (index == 1) {
            context.go('/profile');
          }
        }),
      ],
    );
  }

  Widget _buildBackgroundImage() {
    final imageUrl = movie.poster;
    if (imageUrl.isEmpty) {
      return Container(color: Colors.grey[800]);
    }
    return CachedNetworkImage(
      imageUrl: _sanitizeUrl(imageUrl),
      fit: BoxFit.cover,
      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => Container(color: Colors.grey[800], child: const Icon(Icons.error, color: Colors.white)),
    );
  }

  Widget _buildGradientOverlay() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(0.7),
            Colors.black
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.5, 0.8, 1.0],
        ),
      ),
    );
  }

  Widget _buildLikeButton(BuildContext context) { // context parametresi eklendi
    return Positioned(
      bottom: 200,
      right: 20,
      child: Container(
        height: 71.h,
        width: 50.w,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.2),
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        ),
        child: IconButton(
          icon: Icon(
            movie.isFavorite ? Icons.favorite : Icons.favorite_border,
            color: movie.isFavorite ? Colors.red : Colors.white.withOpacity(0.5),
            size: 28,
          ),
          onPressed: () {
            context.read<HomeBloc>().add(ToggleFavoriteEvent(movieId: movie.id));
          },
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Positioned(
      bottom: 95,
      left: 0,
      right: 0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.black.withOpacity(0.2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey[800],
                  child: ClipOval(
                    child: movie.poster.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: _sanitizeUrl(movie.poster),
                            fit: BoxFit.cover,
                            width: 40,
                            height: 40,
                            placeholder: (context, url) => const Center(child: CircularProgressIndicator(strokeWidth: 2.0)),
                            errorWidget: (context, url, error) => const Icon(Icons.person, color: Colors.white),
                          )
                        : const Icon(Icons.person, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        movie.title, // Username
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                      RichText(
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          text: movie.plot.length > 65 ? movie.plot.substring(0, 65) : movie.plot,
                          style: const TextStyle(fontSize: 13, color: Colors.white70, fontWeight: FontWeight.w600),
                          children: [
                            if (movie.plot.length > 65)
                              TextSpan(
                                text: ' Daha Fazlası',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // Tıklama işlevi burada
                                  },
                              ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

