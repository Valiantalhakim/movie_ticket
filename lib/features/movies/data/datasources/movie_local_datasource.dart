import '../../../../core/error/exceptions.dart';
import '../models/movie_model.dart';
import '../models/showtime_model.dart';

abstract class MovieLocalDataSource {
  Future<List<MovieModel>> getNowPlaying();
  Future<MovieModel> getMovieDetail(String id);
  Future<List<ShowtimeModel>> getShowtimes(String movieId);
}

class MovieLocalDataSourceImpl implements MovieLocalDataSource {
  static final List<MovieModel> _movies = <MovieModel>[
    const MovieModel(
      id: 'mv_1',
      title: 'Black Adams',
      genre: 'Action',
      rating: 4.7,
      poster:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTXN8DxiLqRnpF5bAZQneuDsg1xhYFxLaGL2Q&s',
      synopsis:
          'Seorang mantan agen rahasia harus kembali ke lapangan untuk menghentikan sindikat internasional sebelum sebuah kota besar lumpuh dalam satu malam.',
      duration: 128,
    ),
    const MovieModel(
      id: 'mv_2',
      title: 'Sherina',
      genre: 'Drama',
      rating: 4.5,
      poster:
          'https://upload.wikimedia.org/wikipedia/en/thumb/3/34/Petualangan_Sherina_2.jpg/250px-Petualangan_Sherina_2.jpg',
      synopsis:
          'Dua sahabat lama dipertemukan kembali oleh serangkaian surat yang membuka rahasia keluarga dan luka masa lalu yang belum selesai.',
      duration: 116,
    ),
    const MovieModel(
      id: 'mv_3',
      title: 'KKN Desa Penari',
      genre: 'Horror',
      rating: 4.3,
      poster:
          'https://upload.wikimedia.org/wikipedia/en/thumb/2/24/Grave_Torture_2024_poster.jpg/250px-Grave_Torture_2024_poster.jpg',
      synopsis:
          'Sekelompok kreator konten menginap di rumah kosong terpencil dan mendapati bahwa setiap ruangan menyimpan teror yang berbeda.',
      duration: 104,
    ),
    const MovieModel(
      id: 'mv_4',
      title: 'Agak Laen',
      genre: 'Comedy',
      rating: 4.2,
      poster:
          'https://upload.wikimedia.org/wikipedia/en/thumb/9/91/Agak_Laen_film_poster.jpg/250px-Agak_Laen_film_poster.jpg',
      synopsis:
          'Hari pertama seorang manajer baru berubah kacau ketika seluruh kantor mencoba menyembunyikan kesalahan besar sebelum audit datang.',
      duration: 101,
    ),
    const MovieModel(
      id: 'mv_5',
      title: 'Gundala',
      genre: 'Sci-Fi',
      rating: 4.8,
      poster:
          'https://upload.wikimedia.org/wikipedia/en/thumb/d/de/Gundala_%282019%29_poster.jpg/250px-Gundala_%282019%29_poster.jpg',
      synopsis:
          'Awak pesawat antarbintang menemukan koloni manusia yang hilang dan harus memilih antara pulang ke Bumi atau membangun peradaban baru.',
      duration: 136,
    ),
    const MovieModel(
      id: 'mv_6',
      title: 'The Raid',
      genre: 'Action',
      rating: 4.6,
      poster:
          'https://upload.wikimedia.org/wikipedia/en/9/9a/The_Raid_2011_poster.jpg',
      synopsis:
          'Seorang analis intelijen muda mengungkap operasi gelap di dalam organisasinya sendiri dan menjadi target perburuan global.',
      duration: 124,
    ),
  ];

  static final List<ShowtimeModel> _showtimes = <ShowtimeModel>[
    ShowtimeModel(
      id: 'st_1',
      movieId: 'mv_1',
      date: DateTime(2026, 4, 10),
      time: '13:00',
      cinemaName: 'Cinema XXI Panakkukang',
      price: 50000,
      availableSeats: 34,
    ),
    ShowtimeModel(
      id: 'st_2',
      movieId: 'mv_1',
      date: DateTime(2026, 4, 10),
      time: '19:45',
      cinemaName: 'CGV Nipah Mall',
      price: 70000,
      availableSeats: 18,
    ),
    ShowtimeModel(
      id: 'st_3',
      movieId: 'mv_2',
      date: DateTime(2026, 4, 11),
      time: '14:20',
      cinemaName: 'XXI Mall Ratu Indah',
      price: 55000,
      availableSeats: 27,
    ),
    ShowtimeModel(
      id: 'st_4',
      movieId: 'mv_2',
      date: DateTime(2026, 4, 11),
      time: '20:00',
      cinemaName: 'Cinepolis Phinisi Point',
      price: 85000,
      availableSeats: 11,
    ),
    ShowtimeModel(
      id: 'st_5',
      movieId: 'mv_3',
      date: DateTime(2026, 4, 10),
      time: '21:10',
      cinemaName: 'CGV Panakkukang Square',
      price: 65000,
      availableSeats: 9,
    ),
    ShowtimeModel(
      id: 'st_6',
      movieId: 'mv_3',
      date: DateTime(2026, 4, 12),
      time: '16:30',
      cinemaName: 'XXI Trans Studio Mall',
      price: 60000,
      availableSeats: 21,
    ),
    ShowtimeModel(
      id: 'st_7',
      movieId: 'mv_4',
      date: DateTime(2026, 4, 10),
      time: '12:15',
      cinemaName: 'Cinepolis Panakkukang',
      price: 50000,
      availableSeats: 42,
    ),
    ShowtimeModel(
      id: 'st_8',
      movieId: 'mv_4',
      date: DateTime(2026, 4, 12),
      time: '18:40',
      cinemaName: 'CGV Nipah Mall',
      price: 65000,
      availableSeats: 25,
    ),
    ShowtimeModel(
      id: 'st_9',
      movieId: 'mv_5',
      date: DateTime(2026, 4, 11),
      time: '15:00',
      cinemaName: 'IMAX Trans Studio',
      price: 85000,
      availableSeats: 14,
    ),
    ShowtimeModel(
      id: 'st_10',
      movieId: 'mv_5',
      date: DateTime(2026, 4, 12),
      time: '20:30',
      cinemaName: 'XXI Mall Panakkukang',
      price: 80000,
      availableSeats: 16,
    ),
    ShowtimeModel(
      id: 'st_11',
      movieId: 'mv_6',
      date: DateTime(2026, 4, 10),
      time: '17:20',
      cinemaName: 'XXI Panakkukang',
      price: 70000,
      availableSeats: 22,
    ),
    ShowtimeModel(
      id: 'st_12',
      movieId: 'mv_6',
      date: DateTime(2026, 4, 11),
      time: '21:00',
      cinemaName: 'CGV Nipah Mall',
      price: 75000,
      availableSeats: 13,
    ),
  ];

  @override
  Future<List<MovieModel>> getNowPlaying() async {
    return List<MovieModel>.from(_movies);
  }

  @override
  Future<MovieModel> getMovieDetail(String id) async {
    try {
      return _movies.firstWhere((movie) => movie.id == id);
    } catch (_) {
      throw const CacheException('Movie detail not found');
    }
  }

  @override
  Future<List<ShowtimeModel>> getShowtimes(String movieId) async {
    final result = _showtimes
        .where((showtime) => showtime.movieId == movieId)
        .toList(growable: false);

    if (result.isEmpty) {
      throw const CacheException('Showtimes not found');
    }

    return result;
  }
}
