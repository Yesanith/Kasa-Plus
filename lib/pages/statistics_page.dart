import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:money_calc_app/providers/history_provider.dart';
import 'package:money_calc_app/providers/settings_provider.dart';
import 'package:money_calc_app/l10n/app_localizations.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final history = Provider.of<HistoryProvider>(context);
    final localizations = AppLocalizations.of(context)!;

    // Filter records by current currency and take last 10
    final currencyRecords = history.records
        .where((r) => r.currency == settings.currency)
        .toList();

    // Sort by date (oldest first for chart)
    // Assuming records are stored new -> old, so we reverse them
    final chartRecords = currencyRecords.take(10).toList().reversed.toList();

    if (chartRecords.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(localizations.statistics)),
        body: Center(
          child: Text(
            localizations.noHistory,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(localizations.statistics)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            localizations.lastRecords(chartRecords.length),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),

          // Difference Chart
          _buildDifferenceChart(context, chartRecords, localizations),

          const SizedBox(height: 24),

          // Net Total Chart
          _buildNetTotalChart(context, chartRecords, localizations),
        ],
      ),
    );
  }

  Widget _buildDifferenceChart(
    BuildContext context,
    List<HistoryRecord> records,
    AppLocalizations localizations,
  ) {
    // Find min/max for Y axis scaling
    double maxY = 0;
    double minY = 0;

    final spots = <FlSpot>[];

    for (int i = 0; i < records.length; i++) {
      final r = records[i];
      // Difference = (Total - InitialCash) - TargetAmount
      final diff = (r.total - r.initialCash) - r.targetAmount;
      if (diff > maxY) maxY = diff;
      if (diff < minY) minY = diff;
      spots.add(FlSpot(i.toDouble(), diff));
    }

    // Add some padding to Y axis
    final yRange = maxY - minY;
    if (yRange == 0) {
      maxY += 10;
      minY -= 10;
    } else {
      maxY += yRange * 0.2;
      minY -= yRange * 0.2;
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.differenceTrend,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 24),
            AspectRatio(
              aspectRatio: 1.7,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    drawVerticalLine: false,
                    horizontalInterval: (maxY - minY) / 5 == 0
                        ? 1
                        : (maxY - minY) / 5,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Theme.of(context).dividerColor,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    rightTitles: const AxisTitles(),
                    topTitles: const AxisTitles(),
                    bottomTitles:
                        const AxisTitles(), // Hide dates for cleaner look or implement simple index
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          if (value == 0) {
                            return const Text(
                              '0',
                              style: TextStyle(fontSize: 10),
                            );
                          }
                          return Text(
                            value.toInt().toString(),
                            style: TextStyle(
                              fontSize: 10,
                              color: Theme.of(context).hintColor,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: (records.length - 1).toDouble(),
                  minY: minY,
                  maxY: maxY,
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: Theme.of(context).colorScheme.primary,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: spot.y >= 0 ? Colors.green : Colors.red,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.1),
                      ),
                    ),
                  ],
                  extraLinesData: ExtraLinesData(
                    horizontalLines: [
                      HorizontalLine(
                        y: 0,
                        color: Theme.of(context).dividerColor,
                        strokeWidth: 1,
                        dashArray: [5, 5],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNetTotalChart(
    BuildContext context,
    List<HistoryRecord> records,
    AppLocalizations localizations,
  ) {
    double maxY = 0;
    double minY = 0;
    final barGroups = <BarChartGroupData>[];

    for (int i = 0; i < records.length; i++) {
      final r = records[i];
      final netTotal = r.total - r.initialCash;
      if (netTotal > maxY) maxY = netTotal;
      if (netTotal < minY) minY = netTotal;

      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: netTotal,
              color: netTotal >= 0
                  ? Theme.of(context).colorScheme.secondary
                  : Colors.red.shade400,
              width: 16,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(netTotal >= 0 ? 4 : 0),
                bottom: Radius.circular(netTotal < 0 ? 4 : 0),
              ),
            ),
          ],
        ),
      );
    }

    if (maxY == 0 && minY == 0) {
      maxY = 100;
    } else {
      if (maxY > 0) maxY *= 1.2;
      if (minY < 0) minY *= 1.2;
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.netTotalTrend,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 24),
            AspectRatio(
              aspectRatio: 1.7,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxY,
                  minY: minY,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (group) => Colors.blueGrey,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          rod.toY.toStringAsFixed(2),
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                  titlesData: const FlTitlesData(
                    bottomTitles: AxisTitles(),
                    leftTitles: AxisTitles(),
                    topTitles: AxisTitles(),
                    rightTitles: AxisTitles(),
                  ),
                  gridData: FlGridData(
                    drawVerticalLine: false,
                    horizontalInterval: (maxY - minY) / 5 == 0
                        ? 1
                        : (maxY - minY) / 5,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Theme.of(context).dividerColor,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: barGroups,
                  extraLinesData: ExtraLinesData(
                    horizontalLines: [
                      HorizontalLine(
                        y: 0,
                        color: Theme.of(context).dividerColor,
                        strokeWidth: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
