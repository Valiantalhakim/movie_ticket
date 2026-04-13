import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../domain/entities/showtime.dart';
import '../bloc/movie_bloc.dart';
import '../widgets/genre_chip.dart';

class MovieDetailPage extends StatefulWidget {
  const MovieDetailPage({super.key, required this.movieId});

  final String movieId;

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  @override
  void initState() {
    super.initState();
    final bloc = context.read<MovieBloc>();
    bloc
      ..add(LoadMovieDetailEvent(widget.movieId))
      ..add(LoadShowtimesEvent(widget.movieId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<MovieBloc, MovieState>(
          builder: (context, state) {
            if (state is MovieError) {
              return AppErrorWidget(
                message: state.message,
                onRetry: () {
                  final bloc = context.read<MovieBloc>();
                  bloc
                    ..add(LoadMovieDetailEvent(widget.movieId))
                    ..add(LoadShowtimesEvent(widget.movieId));
                },
              );
            }

            final isLoading = state is MovieLoading;
            final movie = state is MovieLoaded
                ? state.selectedMovie
                : state is MovieLoading
                    ? state.selectedMovie
                    : null;
            final showtimes = state is MovieLoaded
                ? state.showtimes
                : state is MovieLoading
                    ? state.showtimes
                    : const <Showtime>[];

            if (movie == null && isLoading) {
              return const Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    LoadingWidget(height: 320, borderRadius: 28),
                    SizedBox(height: 20),
                    LoadingWidget(height: 150, borderRadius: 22),
                  ],
                ),
              );
            }

            if (movie == null) {
              return AppErrorWidget(
                message: AppStrings.cacheError,
                onRetry: () {
                  context
                      .read<MovieBloc>()
                      .add(LoadMovieDetailEvent(widget.movieId));
                },
              );
            }

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  expandedHeight: 340,
                  backgroundColor: AppColors.background,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        CachedNetworkImage(
                          imageUrl: movie.poster,
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) => Container(
                            color: AppColors.surface,
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.broken_image_outlined,
                              color: AppColors.textSecondary,
                              size: 44,
                            ),
                          ),
                        ),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.12),
                                AppColors.background,
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(20),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Text(
                          movie.title,
                          style:
                              Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            GenreChip(
                              label: movie.genre,
                              isSelected: true,
                              onTap: () {},
                            ),
                            const SizedBox(width: 12),
                            const Icon(
                              Icons.star_rounded,
                              color: Colors.amber,
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${movie.rating} / 5.0',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: AppColors.textSecondary),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              '${movie.duration} menit',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Sinopsis',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          movie.synopsis,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    height: 1.5,
                                    color: AppColors.textSecondary,
                                  ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Jadwal Tayang',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                        const SizedBox(height: 14),
                        if (isLoading && showtimes.isEmpty)
                          const LoadingWidget(height: 180, borderRadius: 22)
                        else
                          ...showtimes.map(
                            (showtime) =>
                                _buildShowtimeCard(context, movie.title, showtime),
                          ),
                        const SizedBox(height: 28),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildShowtimeCard(
    BuildContext context,
    String movieTitle,
    Showtime showtime,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.surfaceAlt,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                Text(
                  showtime.time,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormatter.formatDate(showtime.date),
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  showtime.cinemaName,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${CurrencyFormatter.formatIdr(showtime.price)} • ${showtime.availableSeats} kursi tersedia',
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 10),
                CustomButton(
                  label: AppStrings.bookNow,
                  onPressed: () {
                    context.push(
                      '${AppRoutes.seatPath}?movieTitle=${Uri.encodeComponent(movieTitle)}',
                      extra: showtime,
                    );
                  },
                  icon: Icons.local_activity_outlined,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
