import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  Movie get _featuredMovie =>
      mockMovies.reduce((a, b) => a.rating >= b.rating ? a : b);

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

  bool get _isFiltering =>
      _selectedGenre != _allGenres || _searchController.text.trim().isNotEmpty;

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
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: _TopBar()),
            if (!_isFiltering)
              SliverToBoxAdapter(
                child: _FeaturedHero(
                  movie: _featuredMovie,
                  onBook: () => _openMovie(_featuredMovie),
                ),
              ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  textInputAction: TextInputAction.search,
                  style: const TextStyle(
                    color: AppColors.text,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Search movies or genres',
                    prefixIcon: Icon(Icons.search_rounded),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 60,
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final genre = _genres[index];
                    return _GenrePill(
                      label: genre,
                      selected: genre == _selectedGenre,
                      onTap: () => setState(() => _selectedGenre = genre),
                    );
                  },
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemCount: _genres.length,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 18,
                      decoration: BoxDecoration(
                        gradient: AppColors.crimsonGradient,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Now Showing',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${visibleMovies.length} movies · ${mockCinemas.length} cinemas',
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
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
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
                sliver: SliverLayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.crossAxisExtent;
                    final crossAxisCount = width >= 900
                        ? 4
                        : width >= 620
                        ? 3
                        : 2;

                    return SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: 0.67,
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
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              gradient: AppColors.crimsonGradient,
              borderRadius: BorderRadius.circular(11),
              boxShadow: [
                BoxShadow(
                  color: AppColors.crimson.withValues(alpha: 0.4),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.local_activity_rounded,
              color: Colors.white,
              size: 21,
            ),
          ),
          const SizedBox(width: 11),
          RichText(
            text: TextSpan(
              style: GoogleFonts.outfit(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
              ),
              children: const [
                TextSpan(
                  text: 'Show',
                  style: TextStyle(color: AppColors.text),
                ),
                TextSpan(
                  text: 'Rush',
                  style: TextStyle(color: AppColors.gold),
                ),
              ],
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.glass(0.06),
              borderRadius: BorderRadius.circular(99),
              border: Border.all(color: AppColors.glass(0.12)),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.location_on_rounded,
                  size: 15,
                  color: AppColors.gold,
                ),
                SizedBox(width: 5),
                Text(
                  'Bengaluru',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.text,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturedHero extends StatelessWidget {
  final Movie movie;
  final VoidCallback onBook;

  const _FeaturedHero({required this.movie, required this.onBook});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 620;

          return Container(
            height: wide ? 300 : 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: AppColors.glass(0.1)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.55),
                  blurRadius: 30,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(21),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Blurred poster as ambient backdrop.
                  ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 26, sigmaY: 26),
                    child: Image.asset(
                      movie.posterUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const ColoredBox(color: AppColors.elevated),
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          const Color(0xF20A0C13),
                          const Color(0xCC0A0C13),
                          Colors.black.withValues(alpha: 0.25),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(22),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  gradient: AppColors.goldGradient,
                                  borderRadius: BorderRadius.circular(99),
                                ),
                                child: const Text(
                                  'FEATURED TONIGHT',
                                  style: TextStyle(
                                    color: Color(0xFF201502),
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.4,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                movie.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: wide ? 34 : 26,
                                  fontWeight: FontWeight.w800,
                                  height: 1.05,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star_rounded,
                                    color: AppColors.gold,
                                    size: 17,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    movie.rating.toStringAsFixed(1),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 13.5,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Flexible(
                                    child: Text(
                                      '${movie.genres.take(2).join(' · ')} · ${movie.durationMinutes} min',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.white.withValues(
                                          alpha: 0.7,
                                        ),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),
                              FilledButton.icon(
                                onPressed: onBook,
                                style: FilledButton.styleFrom(
                                  minimumSize: const Size(0, 46),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 22,
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.confirmation_number_rounded,
                                  size: 18,
                                ),
                                label: const Text('Book tickets'),
                              ),
                            ],
                          ),
                        ),
                        if (wide) ...[
                          const SizedBox(width: 22),
                          Transform.rotate(
                            angle: 0.035,
                            child: Container(
                              width: 170,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: AppColors.glass(0.25),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.6),
                                    blurRadius: 24,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(13),
                                child: Image.asset(
                                  movie.posterUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const ColoredBox(
                                        color: AppColors.elevated,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _GenrePill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _GenrePill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: selected ? AppColors.goldGradient : null,
            color: selected ? null : AppColors.glass(0.05),
            borderRadius: BorderRadius.circular(99),
            border: Border.all(
              color: selected ? Colors.transparent : AppColors.glass(0.12),
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: AppColors.gold.withValues(alpha: 0.3),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? const Color(0xFF201502) : AppColors.muted,
              fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
              fontSize: 13.5,
            ),
          ),
        ),
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
            Container(
              width: 74,
              height: 74,
              decoration: BoxDecoration(
                color: AppColors.glass(0.05),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.glass(0.1)),
              ),
              child: const Icon(
                Icons.movie_filter_rounded,
                size: 34,
                color: AppColors.muted,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No matches found',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            const Text(
              'Try a different search or genre',
              style: TextStyle(color: AppColors.muted, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
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
