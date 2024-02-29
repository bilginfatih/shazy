import '../../core/base/base_model.dart';

class FinanceModel extends BaseModel {
  FinanceModel({
    this.id,
    this.user_id,
    this.income,
    this.outgone,
    this.created_at,
    this.updated_at,
    this.total_income,
    this.total_expend,
    this.organize_income,
    this.organize_outgone,
    this.organize_income_date,
    this.organize_outgone_date,
  });

  FinanceModel._fromJson(o) {
    id = o['id'];
    user_id = o['user_id'];
    income = o['income'];
    outgone = o['outgone'];
    created_at = o['created_at'];
    updated_at = o['updated_at'];
    total_income = o['total_income'];
    total_expend = o['total_expend'];
    organize_income = o['organize_income'];
    organize_outgone = o['organize_outgone'];
    organize_income_date = o['organize_income_date'];
    organize_outgone_date = o['organize_outgone_date'];
  }

  @override
  fromJson(json) => FinanceModel._fromJson(json);

  String? id;
  String? user_id;
  String? income;
  String? outgone;
  String? created_at;
  String? updated_at;
  int? total_income;
  int? total_expend;
  List? organize_income;
  List? organize_outgone;
  List? organize_income_date;
  List? organize_outgone_date;

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    if (id != null) map['id'] = id;
    if (user_id != null) map['user_id'] = user_id;
    if (income != null) map['income'] = income;
    if (outgone != null) map['outgone'] = outgone;
    if (created_at != null) map['exp_year'] = created_at;
    if (updated_at != null) map['amount'] = updated_at;
    if (total_income != null) map['total_income'] = total_income;
    if (total_expend != null) map['total_expend'] = total_expend;
    if (organize_income != null) map['organize_income'] = organize_income;
    if (organize_outgone != null) map['organize_outgone'] = organize_outgone;
    if (organize_income_date != null) map['organize_income_date'] = organize_income_date;
    if (organize_outgone_date != null) map['organize_outgone_date'] = organize_outgone_date;

    return map;
  }
}
