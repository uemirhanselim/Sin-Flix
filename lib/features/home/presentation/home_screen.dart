import 'dart:async';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dating_app/core/themes/app_theme.dart';
import 'package:dating_app/shared/widgets/lottie_extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/locator.dart';
import '../../movie/domain/entities/movie_entity.dart';
import '../../../shared/widgets/bottom_nav_bar.dart';
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

  Future<void> _onRefresh(BuildContext context) async {
    final completer = Completer();
    final bloc = context.read<HomeBloc>();
    bloc.add(const GetMoviesEvent());

    StreamSubscription? subscription;
    subscription = bloc.stream.listen((state) {
      if (state is HomeLoaded || state is HomeError) {
        if (!completer.isCompleted) {
          completer.complete();
          subscription?.cancel();
        }
      }
    });
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              locator<HomeBloc>()
                ..add(CheckAuthToken())
                ..add(const GetMoviesEvent()),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return Center(
                child: LottieAnimation(
                  "assets/lottie/loading.json",
                  width: 70.w,
                  height: 70.h,
                ),
              );
            } else if (state is HomeLoaded) {
              if (state.movies.isEmpty) {
                return Center(
                  child: Text(
                    tr("movieNotFound"),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: () => _onRefresh(context),
                child: PageView.builder(
                  controller:
                      PageController(), // PageView için bir controller gerekli
                  itemCount:
                      state.hasReachedMax
                          ? state.movies.length
                          : state.movies.length + 1,
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(),
                  onPageChanged: (index) {
                    if (index >= state.movies.length - 1 &&
                        !state.hasReachedMax) {
                      context.read<HomeBloc>().add(LoadMoreMovies());
                    }
                  },
                  itemBuilder: (context, index) {
                    return index >= state.movies.length
                        ? Center(
                          child: LottieAnimation(
                            "assets/lottie/loading.json",
                            width: 70.w,
                            height: 70.h,
                          ),
                        )
                        : _MoviePageItem(movie: state.movies[index]);
                  },
                ),
              );
            } else if (state is HomeError) {
              return Center(
                child: Text(
                  '${tr("error")}: ${state.message}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: AppColors.primary),
                ),
              );
            }
            return Center(
              child: Text('---', style: Theme.of(context).textTheme.bodyLarge),
            );
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
        _buildUserInfo(context),
        BottomNavBar(
          currentIndex: 0,
          onItemTapped: (index) {
            // Yeni widget burada kullanılıyor
            if (index == 1) {
              context.go('/profile');
            }
          },
        ),
      ],
    );
  }

  Widget _buildBackgroundImage() {
    final imageUrl = movie.poster;
    if (imageUrl.isEmpty) {
      return Container(color: AppColors.grey);
    }
    return CachedNetworkImage(
      imageUrl: _sanitizeUrl(imageUrl),
      fit: BoxFit.cover,
      placeholder:
          (context, url) => Center(
            child: LottieAnimation(
              "assets/lottie/loading.json",
              width: 70.w,
              height: 70.h,
            ),
          ),
      errorWidget:
          (context, url, error) => Container(
            color: AppColors.grey,
            child: const Icon(Icons.error, color: AppColors.text),
          ),
    );
  }

  Widget _buildGradientOverlay() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            AppColors.background.withOpacity(0.7),
            AppColors.background,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.5, 0.8, 1.0],
        ),
      ),
    );
  }

  Widget _buildLikeButton(BuildContext context) {
    // context parametresi eklendi
    return Positioned(
      bottom: 200,
      right: 20,
      child: Container(
        height: 71.h,
        width: 50.w,
        decoration: BoxDecoration(
          color: AppColors.background.withOpacity(0.2),
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: AppColors.text.withOpacity(0.2), width: 1),
        ),
        child: IconButton(
          icon: Icon(
            movie.isFavorite ? Icons.favorite : Icons.favorite_border,
            color:
                movie.isFavorite
                    ? AppColors.primary
                    : AppColors.text.withOpacity(0.5),
            size: 28,
          ),
          onPressed: () {
            context.read<HomeBloc>().add(
              ToggleFavoriteEvent(movieId: movie.id),
            );
          },
        ),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
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
            color: AppColors.background.withOpacity(0.2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.grey,
                  child: ClipOval(
                    child:
                        movie.poster.isNotEmpty
                            ? CachedNetworkImage(
                              imageUrl: _sanitizeUrl(movie.poster),
                              fit: BoxFit.cover,
                              width: 40,
                              height: 40,
                              placeholder:
                                  (context, url) => Center(
                                    child: LottieAnimation(
                                      "assets/lottie/loading.json",
                                      width: 70.w,
                                      height: 70.h,
                                    ),
                                  ),
                              errorWidget:
                                  (context, url, error) => const Icon(
                                    Icons.person,
                                    color: AppColors.text,
                                  ),
                            )
                            : const Icon(Icons.person, color: AppColors.text),
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
                        style: textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 4),
                      RichText(
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          text:
                              movie.plot.length > 65
                                  ? movie.plot.substring(0, 65)
                                  : movie.plot,
                          style: textTheme.bodyMedium,
                          children: [
                            if (movie.plot.length > 65)
                              TextSpan(
                                text: " ${tr("more")}",
                                style: textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer:
                                    TapGestureRecognizer()
                                      ..onTap = () {
                                        // Tıklama işlevi burada
                                      },
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
        ),
      ),
    );
  }
}
