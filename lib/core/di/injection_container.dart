import 'package:get_it/get_it.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/booking/data/datasources/booking_local_datasource.dart';
import '../../features/booking/data/repositories/booking_repository_impl.dart';
import '../../features/booking/domain/repositories/booking_repository.dart';
import '../../features/booking/domain/usecases/create_booking.dart';
import '../../features/booking/domain/usecases/get_available_seats.dart';
import '../../features/booking/presentation/bloc/booking_bloc.dart';
import '../../features/booking/presentation/bloc/seat_bloc.dart';
import '../../features/movies/data/datasources/movie_local_datasource.dart';
import '../../features/movies/data/repositories/movie_repository_impl.dart';
import '../../features/movies/domain/repositories/movie_repository.dart';
import '../../features/movies/domain/usecases/get_movie_detail.dart';
import '../../features/movies/domain/usecases/get_now_playing.dart';
import '../../features/movies/domain/usecases/get_showtimes.dart';
import '../../features/movies/presentation/bloc/movie_bloc.dart';
import '../../features/payment/presentation/bloc/payment_bloc.dart';
import '../network/network_info.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  if (!sl.isRegistered<NetworkInfo>()) {
    sl.registerLazySingleton<NetworkInfo>(() => const NetworkInfoImpl());
  }

  if (!sl.isRegistered<MovieLocalDataSource>()) {
    sl.registerLazySingleton<MovieLocalDataSource>(
      () => MovieLocalDataSourceImpl(),
    );
  }

  if (!sl.isRegistered<BookingLocalDataSource>()) {
    sl.registerLazySingleton<BookingLocalDataSource>(
      () => BookingLocalDataSourceImpl(),
    );
  }

  if (!sl.isRegistered<MovieRepository>()) {
    sl.registerLazySingleton<MovieRepository>(
      () => MovieRepositoryImpl(localDataSource: sl(), networkInfo: sl()),
    );
  }

  if (!sl.isRegistered<BookingRepository>()) {
    sl.registerLazySingleton<BookingRepository>(
      () => BookingRepositoryImpl(localDataSource: sl()),
    );
  }

  if (!sl.isRegistered<GetNowPlaying>()) {
    sl.registerLazySingleton<GetNowPlaying>(() => GetNowPlaying(sl()));
  }

  if (!sl.isRegistered<GetMovieDetail>()) {
    sl.registerLazySingleton<GetMovieDetail>(() => GetMovieDetail(sl()));
  }

  if (!sl.isRegistered<GetShowtimes>()) {
    sl.registerLazySingleton<GetShowtimes>(() => GetShowtimes(sl()));
  }

  if (!sl.isRegistered<GetAvailableSeats>()) {
    sl.registerLazySingleton<GetAvailableSeats>(
      () => GetAvailableSeats(sl()),
    );
  }

  if (!sl.isRegistered<CreateBooking>()) {
    sl.registerLazySingleton<CreateBooking>(() => CreateBooking(sl()));
  }

  if (!sl.isRegistered<MovieBloc>()) {
    sl.registerFactory<MovieBloc>(
      () => MovieBloc(
        getNowPlaying: sl(),
        getMovieDetail: sl(),
        getShowtimes: sl(),
      ),
    );
  }

  if (!sl.isRegistered<SeatBloc>()) {
    sl.registerFactory<SeatBloc>(
      () => SeatBloc(
        getAvailableSeats: sl(),
      ),
    );
  }

  if (!sl.isRegistered<BookingBloc>()) {
    sl.registerFactory<BookingBloc>(
      () => BookingBloc(
        createBooking: sl(),
      ),
    );
  }

  if (!sl.isRegistered<PaymentBloc>()) {
    sl.registerFactory<PaymentBloc>(() => PaymentBloc());
  }

  if (!sl.isRegistered<AuthBloc>()) {
    sl.registerFactory<AuthBloc>(() => AuthBloc());
  }
}
