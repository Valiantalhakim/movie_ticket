part of 'payment_bloc.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class SelectPaymentMethodEvent extends PaymentEvent {
  const SelectPaymentMethodEvent(this.method);

  final String method;

  @override
  List<Object?> get props => <Object?>[method];
}

class ConfirmPaymentEvent extends PaymentEvent {
  const ConfirmPaymentEvent(this.method);

  final String? method;

  @override
  List<Object?> get props => <Object?>[method];
}
