import '../../core/base/base_model.dart';

class PaymentModel extends BaseModel {
  PaymentModel({
    this.cardHolderName,
    this.cardNumber,
    this.cvv,
    this.month,
    this.year,
  });

  PaymentModel._fromJson(o) {
    cardHolderName = o['cardHolderName'];
    cardNumber = o['cardNumber'];
    cvv = o['cvv'];
    month = o['month'];
    year = o['year'];
  }

  @override
  fromJson(json) => PaymentModel._fromJson(json);

  String? cardHolderName;
  String? cardNumber;
  String? cvv;
  String? month;
  String? year;

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    if (cardHolderName != null) map['cardHolderName'] = cardHolderName;
    if (cardNumber != null) map['cardNumber'] = cardNumber;
    if (cvv != null) map['cvv'] = cvv;
    if (month != null) map['month'] = month;
    if (year != null) map['year'] = year;
    return map;
  }
}
