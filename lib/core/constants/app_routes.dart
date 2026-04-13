import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/booking/domain/entities/booking.dart';
import '../../features/booking/presentation/bloc/booking_bloc.dart';
import '../../features/booking/presentation/bloc/seat_bloc.dart';
import '../../features/booking/presentation/pages/booking_summary_page.dart';
import '../../features/booking/presentation/pages/seat_selection_page.dart';
import '../../features/movies/domain/entities/showtime.dart';
import '../../features/movies/presentation/bloc/movie_bloc.dart';
import '../../features/movies/presentation/pages/home_page.dart';
import '../../features/movies/presentation/pages/movie_detail_page.dart';
import '../../features/payment/presentation/bloc/payment_bloc.dart';
import '../../features/payment/presentation/pages/payment_page.dart';
import '../../features/payment/presentation/pages/ticket_page.dart';
import '../di/injection_container.dart';

class AppRoutes {
  const AppRoutes._();

  static const String loginPath = '/';
  static const String registerPath = '/register';
  static const String homePath = '/home';
  static const String movieDetailPath = '/movie/:id';
  static const String seatPath = '/seat';
  static const String summaryPath = '/summary';
  static const String paymentPath = '/payment';
  static const String ticketPath = '/ticket';

  static final GoRouter router = GoRouter(
    initialLocation: loginPath,
    routes: <GoRoute>[
      GoRoute(
        path: loginPath,
        builder: (context, state) => BlocProvider<AuthBloc>(
          create: (_) => sl<AuthBloc>(),
          child: const LoginPage(),
        ),
      ),
      GoRoute(
        path: registerPath,
        builder: (context, state) => BlocProvider<AuthBloc>(
          create: (_) => sl<AuthBloc>(),
          child: const RegisterPage(),
        ),
      ),
      GoRoute(
        path: homePath,
        builder: (context, state) => BlocProvider<MovieBloc>(
          create: (_) => sl<MovieBloc>(),
          child: const HomePage(),
        ),
      ),
      GoRoute(
        path: movieDetailPath,
        builder: (context, state) {
          final movieId = state.pathParameters['id'] ?? '';
          return BlocProvider<MovieBloc>(
            create: (_) => sl<MovieBloc>(),
            child: MovieDetailPage(movieId: movieId),
          );
        },
      ),
      GoRoute(
        path: seatPath,
        builder: (context, state) {
          final showtime = state.extra as Showtime;
          final movieTitle = state.uri.queryParameters['movieTitle'] ?? '';
          return MultiBlocProvider(
            providers: [
              BlocProvider<SeatBloc>(create: (_) => sl<SeatBloc>()),
              BlocProvider<BookingBloc>(create: (_) => sl<BookingBloc>()),
            ],
            child: SeatSelectionPage(
              movieTitle: movieTitle,
              showtimeId: showtime.id,
              cinemaName: showtime.cinemaName,
              showDate: showtime.date,
              showTime: showtime.time,
              pricePerSeat: showtime.price,
            ),
          );
        },
      ),
      GoRoute(
        path: summaryPath,
        builder: (context, state) {
          final booking = state.extra as Booking;
          return BlocProvider<BookingBloc>(
            create: (_) => sl<BookingBloc>(),
            child: BookingSummaryPage(booking: booking),
          );
        },
      ),
      GoRoute(
        path: paymentPath,
        builder: (context, state) {
          final totalPrice = state.extra as int;
          final movieTitle = state.uri.queryParameters['movieTitle'] ?? '';
          final cinemaName = state.uri.queryParameters['cinemaName'] ?? '';
          final showDateParam = state.uri.queryParameters['showDate'] ?? '';
          final showTime = state.uri.queryParameters['showTime'] ?? '';
          final seatLabelsParam = state.uri.queryParameters['seatLabels'] ?? '';
          final showtimeId = state.uri.queryParameters['showtimeId'] ?? '';
          final seatLabels = seatLabelsParam.isEmpty
              ? const <String>[]
              : seatLabelsParam
                  .split(',')
                  .where((value) => value.isNotEmpty)
                  .toList(growable: false);

          return BlocProvider<PaymentBloc>(
            create: (_) => sl<PaymentBloc>(),
            child: PaymentPage(
              totalPrice: totalPrice,
              movieTitle: movieTitle,
              cinemaName: cinemaName,
              showDate: showDateParam.isEmpty
                  ? DateTime.now()
                  : DateTime.parse(showDateParam),
              showTime: showTime,
              showtimeId: showtimeId,
              seatLabels: seatLabels,
            ),
          );
        },
      ),
      GoRoute(
        path: ticketPath,
        builder: (context, state) {
          final booking = state.extra as Booking;
          return TicketPage(booking: booking);
        },
      ),
    ],
  );
}
