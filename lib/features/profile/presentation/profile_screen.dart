import 'package:cached_network_image/cached_network_image.dart';
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
          create: (context) => locator<FavoriteMoviesBloc>()..add(GetFavoriteMoviesEvent()),
        ),
        BlocProvider(
          create: (context) => locator<UserBloc>()..add(LoadUserProfile()), // Load user profile
        ),
      ],
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFF000000),
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
                      _buildLikedMoviesSection(),
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
    return AppBar(
        backgroundColor: const Color(0xFF000000),
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
          title: Text(tr('profileDetail'), style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500,
          color: Colors.white,
          )),
          centerTitle: true,
          actions: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
              margin: EdgeInsets.only(right: 16.w),
              decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(20.r)),
              child: Row(
                children: [
                  Image.asset("assets/icons/diamond.png"),
                  SizedBox(width: 6.w),
                  Text(
                    'Sınırlı Teklif',
                    style: TextStyle(color: Colors.white, fontSize: 14.sp),
                  ),
                ],
              ),
            ),
          ],
      );
  }

  Widget _buildProfileSection(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is UserProfileLoaded) {
          final user = state.user;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25.r,
                  backgroundImage: user.photoUrl != null && user.photoUrl!.isNotEmpty
                      ? CachedNetworkImageProvider(user.photoUrl!) as ImageProvider
                      : const AssetImage('assets/icons/default_avatar.png'), // Varsayılan avatar
                ),
                SizedBox(width: 8.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name ?? 'Kullanıcı Adı',
                      style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                    SizedBox(height: 4.h),
                    SizedBox(
                      width: 150.w,
                      child: Text(
                        'ID: ${user.id}',
                        style: TextStyle(fontSize: 12.sp, color: Colors.white.withOpacity(0.5), fontWeight: FontWeight.w400),
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
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Fotoğraf Ekle',
                    style: TextStyle(color: Colors.white, fontSize: 13.sp, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
        } else if (state is UserError) {
          return Center(child: Text('Hata: ${state.message}', style: const TextStyle(color: Colors.white)));
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildLikedMoviesSection() {
    return BlocBuilder<FavoriteMoviesBloc, FavoriteMoviesState>(
      builder: (context, state) {
        if (state is FavoriteMoviesLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is FavoriteMoviesLoaded) {
          if (state.movies.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.only(top: 50.h),
                child: Text(
                  'Favori filminiz yok.',
                  style: TextStyle(color: Colors.white, fontSize: 16.sp),
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
                  'Beğendiğim Filmler',
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700, color: Colors.white),
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
          return Center(child: Text('Hata: ${state.message}', style: const TextStyle(color: Colors.white)));
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
              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Container(color: Colors.grey[800], child: const Icon(Icons.error, color: Colors.white)),
            ),
          ),
        ),
        SizedBox(height: 4.h,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              movie.title,
              style: TextStyle(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.w500),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              movie.year,
              style: TextStyle(color: Colors.grey[400], fontSize: 12.sp,fontWeight: FontWeight.w400),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ],
    );
  }
}
