import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense_model.dart';
import '../l10n/l10n_ext.dart';

class SummaryCard extends StatelessWidget {
  final ExpenseModel expense;
  const SummaryCard({super.key, required this.expense});

  NumberFormat _moneyFmt(BuildContext context) {
    final lc = Localizations.localeOf(context).languageCode;
    final name = lc == 'vi' ? 'vi_VN' : 'en_US';
    return NumberFormat.currency(locale: name, symbol: '₫', decimalDigits: 0);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.l10n;
    final fmt = _moneyFmt(context);
    final now = DateTime.now();

    double todayIncome = 0, todayExpense = 0;
    double monthIncome = 0, monthExpense = 0;

    for (final tr in expense.transactions) {
      final isToday = tr.date.day == now.day &&
          tr.date.month == now.month &&
          tr.date.year == now.year;
      final isMonth = tr.date.month == now.month && tr.date.year == now.year;

      if (isToday) {
        if (tr.type == 'income') {
          todayIncome += tr.amount;
        } else {
          todayExpense += tr.amount;
        }
      }
      if (isMonth) {
        if (tr.type == 'income') {
          monthIncome += tr.amount;
        } else {
          monthExpense += tr.amount;
        }
      }
    }

    final todayNet = todayIncome - todayExpense;
    final monthNet = monthIncome - monthExpense;

    Widget rowLine(String label, double inc, double exp, double net) {
      final netColor = net >= 0 ? Colors.green : Colors.redAccent;
      final netIcon =
          net >= 0 ? Icons.trending_up_rounded : Icons.trending_down_rounded;

      return Row(
        children: [
          Expanded(
            child: Text(label,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ),
          Row(
            children: [
              const Icon(Icons.south_west, color: Colors.green, size: 18),
              const SizedBox(width: 4),
              Text('+ ${fmt.format(inc)}',
                  style: const TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(width: 12),
          Row(
            children: [
              const Icon(Icons.north_east, color: Colors.redAccent, size: 18),
              const SizedBox(width: 4),
              Text('- ${fmt.format(exp)}',
                  style: const TextStyle(
                      color: Colors.redAccent, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
                color: netColor.withOpacity(0.10),
                borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                Icon(netIcon, color: netColor, size: 16),
                const SizedBox(width: 4),
                Text(fmt.format(net),
                    style: TextStyle(
                        color: netColor, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.grey.shade50, Colors.blue.withOpacity(0.04)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.analytics_rounded,
                      color: Colors.blueAccent, size: 20),
                  const SizedBox(width: 8),
                  Text(t.summaryTitle,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 12),
              rowLine(t.today, todayIncome, todayExpense, todayNet),
              const SizedBox(height: 10),
              const Divider(height: 1),
              const SizedBox(height: 10),
              rowLine(t.thisMonth, monthIncome, monthExpense, monthNet),
            ],
          ),
        ),
      ),
    );
  }
}
