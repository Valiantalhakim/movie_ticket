part of 'payment_bloc.dart';

abstract class PaymentState extends Equatable {
  const PaymentState({
    this.selectedMethod,
  });

  final String? selectedMethod;

  @override
  List<Object?> get props => <Object?>[selectedMethod];
}

class PaymentInitial extends PaymentState {
  const PaymentInitial({
    super.selectedMethod,
  });
}

class PaymentLoading extends PaymentState {
  const PaymentLoading({
    super.selectedMethod,
  });
}

class PaymentSuccess extends PaymentState {
  const PaymentSuccess({
    required String selectedMethod,
  }) : super(selectedMethod: selectedMethod);
}

class PaymentError extends PaymentState {
  const PaymentError(
    this.message, {
    super.selectedMethod,
  });

  final String message;

  @override
  List<Object?> get props => <Object?>[message, selectedMethod];
}
