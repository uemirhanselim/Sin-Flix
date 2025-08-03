import 'package:cached_network_image/cached_network_image.dart';
import 'package:dating_app/core/themes/app_theme.dart';
import 'package:dating_app/features/profile/presentation/widgets/premium_offer_bottom_sheet.dart';
import 'package:dating_app/shared/widgets/lottie_extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/bottom_nav_bar.dart';
import '../../favorites/presentation/bloc/favorite_movies_bloc.dart';
import '../../favorites/presentation/bloc/favorite_movies_event.dart';
import '../../favorites/presentation/bloc/favorite_movies_state.dart';
import '../../movie/domain/entities/movie_entity.dart';
import '../../../core/services/locator.dart';
import '../../user/presentation/bloc/user_bloc.dart'; // New import
import '../../user/presentation/bloc/user_event.dart'; // New import
import '../../user/presentation/bloc/user_state.dart'; // New import

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) =>
                  locator<FavoriteMoviesBloc>()..add(GetFavoriteMoviesEvent()),
        ),
        BlocProvider(
          create:
              (context) =>
                  locator<UserBloc>()
                    ..add(LoadUserProfile()), // Load user profile
        ),
      ],
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: _appBar(context),
          body: SizedBox.expand(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 44.h),
                      _buildProfileSection(context),
                      SizedBox(height: 40.h),
                      _buildLikedMoviesSection(context),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: BottomNavBar(
                    currentIndex: 1,
                    onItemTapped: (index) {
                      if (index == 0) {
                        context.go('/home');
                      } else if (index == 1) {
                        // Already on profile screen
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return AppBar(
      backgroundColor: Colors.transparent,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () => context.go('/home'),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF2a2a2a),
              border: Border.all(color: Colors.grey.withOpacity(0.5)),
            ),
            child: Image.asset("assets/icons/back_arrow.png"),
          ),
        ),
      ),
      title: Text(tr('profileDetail'), style: textTheme.titleLarge),
      centerTitle: true,
      actions: [
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => const PremiumOfferBottomSheet(),
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
            margin: EdgeInsets.only(right: 16.w),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              children: [
                Image.asset("assets/icons/diamond.png"),
                SizedBox(width: 6.w),
                Text(
                  tr("limitedOffer"),
                  style: textTheme.bodySmall!.copyWith(color: AppColors.text),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoading) {
          return Center(
            child: LottieAnimation(
              "assets/lottie/loading.json",
              width: 70.w,
              height: 70.h,
            ),
          );
        } else if (state is UserProfileLoaded) {
          final user = state.user;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25.r,
                  backgroundImage:
                      user.photoUrl != null && user.photoUrl!.isNotEmpty
                          ? CachedNetworkImageProvider(user.photoUrl!)
                              as ImageProvider
                          : const AssetImage(
                            'assets/icons/default_avatar.png',
                          ), // Varsayılan avatar
                ),
                SizedBox(width: 8.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name ?? 'Kullanıcı Adı',
                      style: textTheme.titleLarge,
                    ),
                    SizedBox(height: 4.h),
                    SizedBox(
                      width: 150.w,
                      child: Text(
                        'ID: ${user.id}',
                        style: textTheme.bodySmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    context.push("/profile-detail");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 6.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    tr("addPhoto"),
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (state is UserError) {
          return Center(
            child: Text(
              '${tr("error")}: ${state.message}',
              style: textTheme.bodyLarge?.copyWith(color: AppColors.primary),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildLikedMoviesSection(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocBuilder<FavoriteMoviesBloc, FavoriteMoviesState>(
      builder: (context, state) {
        if (state is FavoriteMoviesLoading) {
          return Center(
            child: LottieAnimation(
              "assets/lottie/loading.json",
              width: 70.w,
              height: 70.h,
            ),
          );
        } else if (state is FavoriteMoviesLoaded) {
          if (state.movies.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.only(top: 50.h),
                child: Text(
                  tr("dontHaveFavoriteMovie"),
                  style: textTheme.headlineSmall,
                ),
              ),
            );
          }
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tr("likedMovies"),
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.text,
                  ),
                ),
                SizedBox(height: 16.h),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 1.w,
                    mainAxisSpacing: 8.h,
                    childAspectRatio: 0.6,
                  ),
                  itemCount: state.movies.length,
                  itemBuilder: (context, index) {
                    final movie = state.movies[index];
                    return _FilmCard(movie: movie);
                  },
                ),
              ],
            ),
          );
        } else if (state is FavoriteMoviesError) {
          return Center(
            child: Text(
              '${tr("error")}: ${state.message}',
              style: textTheme.bodyLarge?.copyWith(color: AppColors.primary),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _FilmCard extends StatelessWidget {
  final MovieEntity movie;

  const _FilmCard({required this.movie});

  String _sanitizeUrl(String url) {
    if (url.startsWith('http://')) {
      return url.replaceFirst('http://', 'https://');
    }
    return url;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            height: 213.h,
            width: 153.w,
            child: CachedNetworkImage(
              imageUrl: _sanitizeUrl(movie.poster),
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
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
            ),
          ),
        ),
        SizedBox(height: 4.h),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              movie.title,
              style: textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.text,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              movie.year,
              style: textTheme.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ],
    );
  }
}
