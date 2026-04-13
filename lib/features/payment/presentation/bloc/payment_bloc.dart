import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  PaymentBloc() : super(const PaymentInitial()) {
    on<SelectPaymentMethodEvent>(_onSelectPaymentMethod);
    on<ConfirmPaymentEvent>(_onConfirmPayment);
  }

  void _onSelectPaymentMethod(
    SelectPaymentMethodEvent event,
    Emitter<PaymentState> emit,
  ) {
    emit(
      PaymentInitial(
        selectedMethod: event.method,
      ),
    );
  }

  Future<void> _onConfirmPayment(
    ConfirmPaymentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    if (event.method == null || event.method!.isEmpty) {
      emit(const PaymentError('Pilih metode pembayaran terlebih dahulu.'));
      return;
    }

    emit(PaymentLoading(selectedMethod: event.method));
    await Future<void>.delayed(const Duration(seconds: 2));
    emit(PaymentSuccess(selectedMethod: event.method!));
  }
}
