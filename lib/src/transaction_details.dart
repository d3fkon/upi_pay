import 'package:decimal/decimal.dart';
import 'package:upi_pay/src/applications.dart';
import 'package:upi_pay/src/exceptions.dart';

class TransactionDetails {
  static const String _currency = 'INR';
  static const int _maxAmount = 100000;

  final UpiApplication upiApplication;
  final String payeeAddress;
  final String payeeName;
  final String transactionRef;
  final String currency;
  final Decimal? amount;
  final String? url;
  final String merchantCode;
  final String? transactionNote;
  final String? sign;

  TransactionDetails({
    required this.upiApplication,
    required this.payeeAddress,
    required this.payeeName,
    required this.transactionRef,
    this.currency: TransactionDetails._currency,
    required String amount,
    this.url,
    this.merchantCode: '',
    this.transactionNote: 'UPI Transaction',
    this.sign,
  }) {
    if (!_checkIfUpiAddressIsValid(payeeAddress)) {
      throw InvalidUpiAddressException();
    }
 
  }

  Map<String, dynamic> toJson() {
    return {
      'app': upiApplication.toString(),
      'pa': payeeAddress,
      'pn': payeeName,
      'tr': transactionRef,
      'cu': currency,
      'am': amount.toString(),
      'url': url,
      'mc': merchantCode,
      'tn': transactionNote,
      'sign': sign,
    };
  }

  String toString() {
    String uri = 'upi://pay?pa=$payeeAddress'
        '&pn=${Uri.encodeComponent(payeeName)}'
        '&tr=$transactionRef'
        '&tn=${Uri.encodeComponent(transactionNote!)}'
        // '&am=${amount.toString()}'
        '&cu=$currency';
    if (sign != null && sign!.isNotEmpty) {
      uri += '&url=${sign}';
    }
    if (url != null && url!.isNotEmpty) {
      uri += '&url=${Uri.encodeComponent(url!)}';
    }
    if (merchantCode.isNotEmpty) {
      uri += '&mc=${Uri.encodeComponent(merchantCode)}';
    }
    return uri;
  }
}

bool _checkIfUpiAddressIsValid(String upiAddress) {
  return upiAddress.split('@').length == 2;
}
