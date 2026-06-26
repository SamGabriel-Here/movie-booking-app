import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/movie.dart';
import '../theme/app_theme.dart';
import '../widgets/movie_card.dart';
import 'movie_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _allGenres = 'All';

  final _searchController = TextEditingController();
  String _selectedGenre = _allGenres;

  List<String> get _genres => [
    _allGenres,
    ...{
      for (final movie in mockMovies)
        for (final genre in movie.genres) genre,
    },
  ];

  List<Movie> get _visibleMovies {
    final query = _searchController.text.trim().toLowerCase();

    return mockMovies.where((movie) {
      final matchesGenre =
          _selectedGenre == _allGenres || movie.genres.contains(_selectedGenre);
      final searchableText = [
        movie.title,
        ...movie.genres,
        movie.synopsis,
      ].join(' ').toLowerCase();
      final matchesSearch = query.isEmpty || searchableText.contains(query);

      return matchesGenre && matchesSearch;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openMovie(Movie movie) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => MovieDetailsScreen(movie: movie)));
  }

  void _clearFilters() {
    setState(() {
      _selectedGenre = _allGenres;
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final visibleMovies = _visibleMovies;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ShowRush'),
        actions: const [
          Padding(padding: EdgeInsets.only(right: 16), child: _LocationBadge()),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _HomeHeader(
              controller: _searchController,
              movieCount: visibleMovies.length,
              onChanged: (_) => setState(() {}),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 58,
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final genre = _genres[index];
                  return ChoiceChip(
                    label: Text(genre),
                    selected: genre == _selectedGenre,
                    onSelected: (_) => setState(() => _selectedGenre = genre),
                  );
                },
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemCount: _genres.length,
              ),
            ),
          ),
          if (visibleMovies.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: _EmptyMovieState(onReset: _clearFilters),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              sliver: SliverLayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.crossAxisExtent;
                  final crossAxisCount = width >= 900
                      ? 4
                      : width >= 620
                      ? 3
                      : 2;
                  final aspectRatio = width < 380 ? 0.56 : 0.62;

                  return SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: aspectRatio,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                    ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final movie = visibleMovies[index];
                      return MovieCard(
                        movie: movie,
                        onTap: () => _openMovie(movie),
                      );
                    }, childCount: visibleMovies.length),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  final TextEditingController controller;
  final int movieCount;
  final ValueChanged<String> onChanged;

  const _HomeHeader({
    required this.controller,
    required this.movieCount,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.ink,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: 0.14),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.local_activity_rounded,
                  color: AppColors.gold,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bengaluru tonight',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$movieCount movies across ${mockCinemas.length} cinemas',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.72),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: controller,
            onChanged: onChanged,
            textInputAction: TextInputAction.search,
            decoration: const InputDecoration(
              hintText: 'Search movies or genres',
              prefixIcon: Icon(Icons.search_rounded),
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationBadge extends StatelessWidget {
  const _LocationBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.softRed,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.location_on_rounded,
            size: 16,
            color: AppColors.districtRed,
          ),
          SizedBox(width: 4),
          Text(
            'Bengaluru',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _EmptyMovieState extends StatelessWidget {
  final VoidCallback onReset;

  const _EmptyMovieState({required this.onReset});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.movie_filter_rounded,
              size: 48,
              color: AppColors.muted,
            ),
            const SizedBox(height: 12),
            Text(
              'No matches found',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: onReset,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Reset filters'),
            ),
          ],
        ),
      ),
    );
  }
}
