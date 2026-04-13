import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../bloc/movie_bloc.dart';
import '../widgets/genre_chip.dart';
import '../widgets/movie_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedGenre = 'All';

  static const List<String> _genres = <String>[
    'All',
    'Action',
    'Drama',
    'Horror',
    'Comedy',
    'Sci-Fi',
  ];

  @override
  void initState() {
    super.initState();
    context.read<MovieBloc>().add(const LoadMoviesEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.homeTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.homeSubtitle,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              const SizedBox(height: 18),
              TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  hintText: AppStrings.searchHint,
                  prefixIcon: Icon(Icons.search_rounded),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 42,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final genre = _genres[index];
                    return GenreChip(
                      label: genre,
                      isSelected: _selectedGenre == genre,
                      onTap: () {
                        setState(() {
                          _selectedGenre = genre;
                        });
                      },
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemCount: _genres.length,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: BlocBuilder<MovieBloc, MovieState>(
                  builder: (context, state) {
                    if (state is MovieLoading &&
                        state.movies.isEmpty &&
                        state.selectedMovie == null) {
                      return GridView.builder(
                        itemCount: 6,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.58,
                        ),
                        itemBuilder: (_, __) => const LoadingWidget(
                          height: double.infinity,
                          borderRadius: 24,
                        ),
                      );
                    }

                    if (state is MovieError) {
                      return AppErrorWidget(
                        message: state.message,
                        onRetry: () {
                          context
                              .read<MovieBloc>()
                              .add(const LoadMoviesEvent());
                        },
                      );
                    }

                    final loadedState = state is MovieLoaded
                        ? state
                        : state is MovieLoading
                            ? MovieLoaded(movies: state.movies)
                            : const MovieLoaded();
                    final query = _searchController.text.trim().toLowerCase();
                    final filteredMovies = loadedState.movies.where((movie) {
                      final matchesQuery =
                          movie.title.toLowerCase().contains(query);
                      final matchesGenre = _selectedGenre == 'All' ||
                          movie.genre == _selectedGenre;
                      return matchesQuery && matchesGenre;
                    }).toList(growable: false);

                    if (filteredMovies.isEmpty) {
                      return Center(
                        child: Text(
                          AppStrings.emptyState,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                        ),
                      );
                    }

                    return GridView.builder(
                      itemCount: filteredMovies.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.58,
                      ),
                      itemBuilder: (context, index) {
                        final movie = filteredMovies[index];
                        return MovieCard(
                          movie: movie,
                          onTap: () {
                            context.push('/movie/${movie.id}');
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
