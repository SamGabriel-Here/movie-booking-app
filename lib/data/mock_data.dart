import '../models/movie.dart';
import '../models/cinema.dart';
import '../models/showtime.dart';

final String _todayIsoDate = _isoDate(DateTime.now());

String _isoDate(DateTime date) {
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '${date.year}-$month-$day';
}

final List<Movie> mockMovies = [
  const Movie(
    id: 'm1',
    title: 'Toy Story 5',
    posterUrl: 'https://picsum.photos/seed/toystory5/300/450',
    rating: 8.2,
    synopsis:
        'Woody, Buzz, Jessie and the gang face their biggest challenge yet '
        'when Lilypad, a brand-new tablet device, arrives with disruptive '
        'ideas about what is best for their kid, Bonnie.',
    durationMinutes: 102,
    genres: ['Animation', 'Adventure', 'Comedy'],
  ),
  const Movie(
    id: 'm2',
    title: 'Masters of the Universe',
    posterUrl: 'https://picsum.photos/seed/mastersuniverse/300/450',
    rating: 7.1,
    synopsis:
        'After 15 years apart, the Sword of Power leads Prince Adam back '
        'to Eternia, shattered under Skeletor\'s rule. To save his family '
        'and world, he must embrace his destiny as He-Man.',
    durationMinutes: 141,
    genres: ['Action', 'Adventure', 'Family'],
  ),
  const Movie(
    id: 'm3',
    title: 'Drishyam 3',
    posterUrl: 'https://picsum.photos/seed/drishyam3/300/450',
    rating: 8.6,
    synopsis:
        'Five years after Drishyam 2, Georgekutty\'s carefully built calm '
        'cracks as new, more organized forces close in — turning the '
        'threat inward against his conscience and his family.',
    durationMinutes: 159,
    genres: ['Crime', 'Thriller', 'Malayalam'],
  ),
  const Movie(
    id: 'm4',
    title: 'Engal Thangam',
    posterUrl: 'https://picsum.photos/seed/engalthangam/300/450',
    rating: 6.9,
    synopsis:
        'In a deeply traditional household, a quiet woman struggles for '
        'acceptance while hiding a dark past. When danger from her former '
        'life threatens her new family, she must shed her docile exterior.',
    durationMinutes: 135,
    genres: ['Action', 'Thriller', 'Tamil'],
  ),
  const Movie(
    id: 'm5',
    title: 'Secret of Kalinga',
    posterUrl: 'https://picsum.photos/seed/secretofkalinga/300/450',
    rating: 6.4,
    synopsis:
        'On a college campus near an old forest well sit the remnants of '
        'the former Kalinga kingdom — and the unexpected, eerie things '
        'that happen when a centuries-old spirit emerges.',
    durationMinutes: 122,
    genres: ['Mystery', 'Horror', 'Malayalam'],
  ),
  const Movie(
    id: 'm6',
    title: 'Kaalaghatta',
    posterUrl: 'https://picsum.photos/seed/kaalaghatta/300/450',
    rating: 6.1,
    synopsis:
        'A Kannada drama now running in theaters, directed by K Prakash '
        'Ambale, following its ensemble cast through a pivotal turning '
        'point in their lives.',
    durationMinutes: 128,
    genres: ['Drama', 'Kannada'],
  ),
];

final List<Cinema> mockCinemas = [
  const Cinema(
    id: 'c1',
    name: 'PVR Forum Mall',
    location: 'Koramangala, Bengaluru',
  ),
  const Cinema(
    id: 'c2',
    name: 'INOX Garuda Mall',
    location: 'Magrath Road, Bengaluru',
  ),
  const Cinema(
    id: 'c3',
    name: 'Cinepolis Royal Meenakshi',
    location: 'Bannerghatta Road, Bengaluru',
  ),
];

final List<Showtime> mockShowtimes = [
  for (final movie in mockMovies)
    for (final cinema in mockCinemas)
      for (final time in ['13:30', '16:45', '20:00'])
        Showtime(
          id: '${movie.id}-${cinema.id}-$time',
          movieId: movie.id,
          cinemaId: cinema.id,
          date: _todayIsoDate,
          time: time,
          screenName: 'Screen ${1 + mockCinemas.indexOf(cinema)}',
          pricePerSeat: 280,
        ),
];

List<Showtime> showtimesForMovie(String movieId) {
  return mockShowtimes.where((s) => s.movieId == movieId).toList();
}

Movie movieById(String id) {
  return mockMovies.firstWhere((m) => m.id == id);
}

Cinema cinemaById(String id) {
  return mockCinemas.firstWhere((c) => c.id == id);
}
