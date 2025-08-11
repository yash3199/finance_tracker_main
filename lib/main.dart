import 'package:flutter/material.dart';
import 'sample_data.dart';
import 'report_chart_screen.dart';

void main() {
  runApp(const MyApp());
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _searchMonth = '';
  List<Transaction> _transactions = List.from(sampleTransactions);
  final _monthController = TextEditingController();

  String get currentMonth {
    if (_searchMonth.isNotEmpty) return _searchMonth;
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}';
  }

  Report get monthlyReport {
    final monthTx = _transactions.where((tx) =>
      '${tx.date.year}-${tx.date.month.toString().padLeft(2, '0')}' == currentMonth && tx.type == 'expense'
    ).toList();
    final incomeTx = _transactions.where((tx) =>
      '${tx.date.year}-${tx.date.month.toString().padLeft(2, '0')}' == currentMonth && tx.type == 'income'
    ).toList();
    final categories = sampleCategories.map((cat) => cat.name).toList();
    final breakdown = categories.map((cat) {
      final total = monthTx.where((tx) => tx.category == cat).fold<double>(0, (sum, tx) => sum + tx.amount);
      return CategoryBreakdownItem(categoryName: cat, totalAmount: total);
    }).where((item) => item.totalAmount > 0).toList();
    return Report(
      month: currentMonth,
      totalIncome: incomeTx.fold<double>(0, (sum, tx) => sum + tx.amount),
      totalExpense: monthTx.fold<double>(0, (sum, tx) => sum + tx.amount),
      categoryBreakdown: breakdown,
    );
  }

  void _addExpense() async {
    final result = await showModalBottomSheet<Transaction>(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: AddExpenseForm(),
      ),
    );
    if (result != null) {
      setState(() {
        _transactions.add(result);
      });
    }
  }

  List<Transaction> get filteredTransactions {
    if (_searchMonth.isEmpty) return _transactions;
    return _transactions.where((tx) =>
      '${tx.date.year}-${tx.date.month.toString().padLeft(2, '0')}' == _searchMonth
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finance Tracker Dashboard'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: TextField(
              controller: _monthController,
              decoration: InputDecoration(
                hintText: 'Search by month (e.g. 2025-08)',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                filled: true,
                fillColor: theme.colorScheme.surface,
              ),
              onChanged: (val) {
                setState(() {
                  _searchMonth = val.trim();
                });
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addExpense,
        backgroundColor: theme.colorScheme.primary,
        child: const Icon(Icons.add),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [theme.colorScheme.primary.withOpacity(0.08), theme.colorScheme.secondary.withOpacity(0.08)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 900),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: isWide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _buildLeftColumn(context)),
                          const SizedBox(width: 32),
                          Expanded(child: _buildRightColumn(context)),
                        ],
                      )
                    : Column(
                        children: [
                          _buildLeftColumn(context),
                          const SizedBox(height: 32),
                          _buildRightColumn(context),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLeftColumn(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          color: theme.colorScheme.surface,
          child: ListTile(
            leading: const Icon(Icons.person, size: 36),
            title: Text(sampleUser.name, style: theme.textTheme.titleLarge),
            subtitle: Text(sampleUser.email),
            trailing: Chip(label: Text(sampleUser.currencyPreference)),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          color: theme.colorScheme.surface,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Categories', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                SizedBox(
                  height: 60,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: sampleCategories.map((cat) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Chip(
                        label: Text(cat.name),
                        avatar: Text(cat.icon),
                        backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                      ),
                    )).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          color: theme.colorScheme.surface,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Recent Transactions', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                ...filteredTransactions.take(5).map((tx) => ListTile(
                  leading: CircleAvatar(
                    backgroundColor: tx.type == 'income' ? Colors.green : Colors.red,
                    child: Text(tx.type == 'income' ? '+' : '-', style: const TextStyle(color: Colors.white)),
                  ),
                  title: Text(tx.category),
                  subtitle: Text(tx.description ?? ''),
                  trailing: Text('\u0024${tx.amount.toStringAsFixed(2)}', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                )),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRightColumn(BuildContext context) {
    final theme = Theme.of(context);
    final report = monthlyReport;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          color: theme.colorScheme.surface,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Budgets', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                ...sampleBudgets.map((b) {
                  final cat = sampleCategories.firstWhere((c) => c.id == b.categoryId);
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Text(cat.icon, style: const TextStyle(color: Colors.white)),
                    ),
                    title: Text(cat.name),
                    subtitle: Text('Limit: \u0024${b.limit.toStringAsFixed(2)} | Spent: \u0024${b.spent.toStringAsFixed(2)}'),
                    trailing: Chip(label: Text('${b.alertThreshold.toStringAsFixed(0)}%')),
                  );
                }),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          color: theme.colorScheme.surface,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Monthly Report (${report.month})', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                ListTile(
                  title: Text('Income: \u0024${report.totalIncome.toStringAsFixed(2)}'),
                  subtitle: Text('Expense: \u0024${report.totalExpense.toStringAsFixed(2)}'),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text('View Chart'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReportChartScreen(
                            report: report,
                            title: 'Monthly Report Chart (${report.month})',
                          ),
                        ),
                      );
                    },
                  ),
                ),
                ...report.categoryBreakdown.map((cb) => ListTile(
                  title: Text(cb.categoryName),
                  trailing: Text('\u0024${cb.totalAmount.toStringAsFixed(2)}'),
                )),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          color: theme.colorScheme.surface,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Yearly Report', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                ListTile(
                  title: Text('Income: \u0024${sampleYearlyReport.totalIncome.toStringAsFixed(2)}'),
                  subtitle: Text('Expense: \u0024${sampleYearlyReport.totalExpense.toStringAsFixed(2)}'),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text('View Chart'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReportChartScreen(
                            report: sampleYearlyReport,
                            title: 'Yearly Report Chart',
                          ),
                        ),
                      );
                    },
                  ),
                ),
                ...sampleYearlyReport.categoryBreakdown.map((cb) => ListTile(
                  title: Text(cb.categoryName),
                  trailing: Text('\u0024${cb.totalAmount.toStringAsFixed(2)}'),
                )),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.light),
        useMaterial3: true,
        cardTheme: CardTheme(
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: Colors.deepPurple.withOpacity(0.1),
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}

class AddExpenseForm extends StatefulWidget {
  const AddExpenseForm({Key? key}) : super(key: key);

  @override
  State<AddExpenseForm> createState() => _AddExpenseFormState();
}

class _AddExpenseFormState extends State<AddExpenseForm> {
  final _formKey = GlobalKey<FormState>();
  String _selectedCategory = sampleCategories.first.name;
  String _month = '';
  double _amount = 0;
  String _description = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Add Expense', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              items: sampleCategories.map((cat) => DropdownMenuItem(
                value: cat.name,
                child: Text(cat.name),
              )).toList(),
              onChanged: (val) => setState(() => _selectedCategory = val ?? sampleCategories.first.name),
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Month (e.g. 2025-08)'),
              validator: (val) => val == null || val.isEmpty ? 'Enter month' : null,
              onChanged: (val) => _month = val,
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
              validator: (val) => val == null || double.tryParse(val) == null ? 'Enter valid amount' : null,
              onChanged: (val) => _amount = double.tryParse(val) ?? 0,
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Description (optional)'),
              onChanged: (val) => _description = val,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  final parts = _month.split('-');
                  final date = DateTime(
                    int.tryParse(parts[0]) ?? DateTime.now().year,
                    parts.length > 1 ? int.tryParse(parts[1]) ?? DateTime.now().month : DateTime.now().month,
                  );
                  Navigator.pop(context, Transaction(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    type: 'expense',
                    amount: _amount,
                    category: _selectedCategory,
                    date: date,
                    description: _description,
                  ));
                }
              },
              child: const Text('Add Expense'),
            ),
          ],
        ),
      ),
    );
  }
}
