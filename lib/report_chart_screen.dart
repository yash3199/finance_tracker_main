import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'sample_data.dart';

class ReportChartScreen extends StatelessWidget {
  final Report report;
  final String title;

  const ReportChartScreen({Key? key, required this.report, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final total = report.categoryBreakdown.fold<double>(0, (sum, item) => sum + item.totalAmount);
    final isWide = MediaQuery.of(context).size.width > 600;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [theme.colorScheme.primary.withOpacity(0.1), theme.colorScheme.secondary.withOpacity(0.1)],
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
                        Expanded(child: _buildChart(context, total)),
                        const SizedBox(width: 32),
                        Expanded(child: _buildLegend(context)),
                      ],
                    )
                  : Column(
                      children: [
                        _buildChart(context, total),
                        const SizedBox(height: 32),
                        _buildLegend(context),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChart(BuildContext context, double total) {
    final theme = Theme.of(context);
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      color: theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text('Category Breakdown', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            SizedBox(
              height: 280,
              child: PieChart(
                PieChartData(
                  sections: report.categoryBreakdown.map((item) {
                    final percent = total == 0 ? 0 : (item.totalAmount / total) * 100;
                    return PieChartSectionData(
                      value: item.totalAmount,
                      title: percent > 7 ? '${item.categoryName}\n${percent.toStringAsFixed(1)}%' : '',
                      color: _getColor(item.categoryName),
                      radius: 90,
                      titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                    );
                  }).toList(),
                  sectionsSpace: 3,
                  centerSpaceRadius: 60,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Total: \u0024${total.toStringAsFixed(2)}', style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary)),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      color: theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Details', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ...report.categoryBreakdown.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: _getColor(item.categoryName),
                        radius: 14,
                        child: Text(item.categoryName[0], style: const TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(width: 16),
                      Expanded(child: Text(item.categoryName, style: theme.textTheme.titleMedium)),
                      Text(
                        '\u0024${item.totalAmount.toStringAsFixed(2)}',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Color _getColor(String category) {
    switch (category) {
      case 'Food': return Colors.orange;
      case 'Rent': return Colors.blue;
      case 'Salary': return Colors.green;
      case 'Bills': return Colors.purple;
      case 'Shopping': return Colors.pink;
      default: return Colors.grey;
    }
  }
}
