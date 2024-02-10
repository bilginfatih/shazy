import '../../core/base/base_model.dart';

class PaymentModel extends BaseModel {
  PaymentModel({
    this.cardHolderName,
    this.cardNumber,
    this.cvv,
    this.month,
    this.year,
    this.uid,
    this.amount,
  });

  PaymentModel._fromJson(o) {
    cardHolderName = o['card_holder_full_name'];
    cardNumber = o['card_number'];
    cvv = o['cvc_number'];
    month = o['exp_month'];
    year = o['exp_year'];
    amount = double.tryParse(o['amount'].toString());
    uid = o['user_id'];
  }

  @override
  fromJson(json) => PaymentModel._fromJson(json);

  double? amount;
  String? cardHolderName;
  String? cardNumber;
  String? cvv;
  String? month;
  String? uid;
  String? year;

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    if (cardHolderName != null) map['card_holder_full_name'] = cardHolderName;
    if (cardNumber != null) map['card_number'] = cardNumber;
    if (cvv != null) map['cvc_number'] = cvv;
    if (month != null) map['exp_month'] = month;
    if (year != null) map['exp_year'] = year;
    if (amount != null) map['amount'] = amount;
    if (uid != null) map['user_id'] = uid;

    return map;
  }
}
