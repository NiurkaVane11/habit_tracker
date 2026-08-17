import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

import '../models/habit.dart';
import '../providers/habit_provider.dart';

class HabitDetailScreen extends StatelessWidget {
  final Habit habit;

  const HabitDetailScreen({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HabitProvider>();
    final entradas = provider.entradasDeHabito(habit.id);
    final racha = provider.calcularRacha(habit.id);

    // Mapa fecha -> 1 (completado) para el heatmap
    final Map<DateTime, int> datasets = {
      for (var e in entradas.where((e) => e.completado))
        DateTime(e.fecha.year, e.fecha.month, e.fecha.day): 1,
    };

    // Agrupamos por semana para el gráfico de tendencia (últimas 8 semanas)
    final spots = _calcularTendenciaSemanal(entradas);

    return Scaffold(
      appBar: AppBar(title: Text('${habit.icono} ${habit.nombre}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _statColumn('🔥 Racha actual', '$racha días'),
                  _statColumn(
                    '✅ Total completados',
                    '${entradas.where((e) => e.completado).length}',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Historial',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: HeatMap(
                datasets: datasets,
                startDate: DateTime.now().subtract(const Duration(days: 90)),
                endDate: DateTime.now(),
                colorMode: ColorMode.color,
                showColorTip: false,
                colorsets: const {1: Colors.deepPurple},
                defaultColor: Colors.grey.withOpacity(0.1),
                textColor: Colors.black87,
                size: 18,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Tendencia semanal',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                height: 200,
                child: spots.isEmpty
                    ? const Center(child: Text('Aún no hay suficientes datos'))
                    : LineChart(
                        LineChartData(
                          gridData: const FlGridData(show: true),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 30,
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) => Text(
                                  'S${value.toInt() + 1}',
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          borderData: FlBorderData(show: true),
                          lineBarsData: [
                            LineChartBarData(
                              spots: spots,
                              isCurved: true,
                              color: Colors.deepPurple,
                              barWidth: 3,
                              dotData: const FlDotData(show: true),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statColumn(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  // Cuenta cuántos días completados hubo por semana, últimas 8 semanas
  List<FlSpot> _calcularTendenciaSemanal(List entradas) {
    final hoy = DateTime.now();
    final List<FlSpot> resultado = [];

    for (int semana = 7; semana >= 0; semana--) {
      final inicioSemana = hoy.subtract(
        Duration(days: hoy.weekday - 1 + semana * 7),
      );
      final finSemana = inicioSemana.add(const Duration(days: 6));

      final completadosEnSemana = entradas.where((e) {
        final fecha = e.fecha as DateTime;
        return e.completado == true &&
            !fecha.isBefore(inicioSemana) &&
            !fecha.isAfter(finSemana);
      }).length;

      resultado.add(
        FlSpot((7 - semana).toDouble(), completadosEnSemana.toDouble()),
      );
    }

    return resultado;
  }
}
