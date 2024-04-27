import '../../core/base/base_model.dart';

class FinanceModel extends BaseModel {
  FinanceModel({
    this.id,
    this.userId,
    this.income,
    this.outgone,
    this.createdAt,
    this.updatedAt,
    this.totalIncome,
    this.totalExpend,
    this.organizeIncome,
    this.organizeOutgone,
    this.organizeIncomeDate,
    this.organizeOutgoneDate,
  });

  FinanceModel._fromJson(o) {
    id = o['id'];
    userId = o['user_id'];
    income = o['income'];
    outgone = o['outgone'];
    createdAt = o['created_at'];
    updatedAt = o['updated_at'];
    totalIncome = o['total_income'];
    totalExpend = o['total_expend'];
    organizeIncome = o['organize_income'];
    organizeOutgone = o['organize_outgone'];
    organizeIncomeDate = o['organize_income_date'];
    organizeOutgoneDate = o['organize_outgone_date'];
    userName = '${o['user_name']} ${o['user_surname']}';
  }

  @override
  fromJson(json) => FinanceModel._fromJson(json);

  String? id;
  String? userId;
  String? income;
  String? outgone;
  String? createdAt;
  String? updatedAt;
  int? totalIncome;
  int? totalExpend;
  List? organizeIncome;
  List? organizeOutgone;
  List? organizeIncomeDate;
  List? organizeOutgoneDate;
  String? userName;

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    if (id != null) map['id'] = id;
    if (userId != null) map['user_id'] = userId;
    if (income != null) map['income'] = income;
    if (outgone != null) map['outgone'] = outgone;
    if (createdAt != null) map['exp_year'] = createdAt;
    if (updatedAt != null) map['amount'] = updatedAt;
    if (totalIncome != null) map['total_income'] = totalIncome;
    if (totalExpend != null) map['total_expend'] = totalExpend;
    if (organizeIncome != null) map['organize_income'] = organizeIncome;
    if (organizeOutgone != null) map['organize_outgone'] = organizeOutgone;
    if (organizeIncomeDate != null) {
      map['organize_income_date'] = organizeIncomeDate;
    }
    if (organizeOutgoneDate != null) {
      map['organize_outgone_date'] = organizeOutgoneDate;
    }

    return map;
  }
}
