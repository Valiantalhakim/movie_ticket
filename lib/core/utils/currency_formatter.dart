class CurrencyFormatter {
  const CurrencyFormatter._();

  static String formatIdr(num amount) {
    final roundedAmount = amount.round();
    final isNegative = roundedAmount.isNegative;
    final digits = roundedAmount.abs().toString();
    final buffer = StringBuffer();

    for (var index = 0; index < digits.length; index++) {
      final reverseIndex = digits.length - index;
      buffer.write(digits[index]);
      if (reverseIndex > 1 && reverseIndex % 3 == 1) {
        buffer.write('.');
      }
    }

    final value = 'Rp${buffer.toString()}';
    return isNegative ? '-$value' : value;
  }
}
