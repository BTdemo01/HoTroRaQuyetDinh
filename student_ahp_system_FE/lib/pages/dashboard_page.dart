import 'package:dssstudentfe/ViewModels/risk_viewmodel.dart';
import 'package:dssstudentfe/ViewModels/student_viewmodel.dart';
import 'package:dssstudentfe/pages/components/main_layout.dart';
import 'package:dssstudentfe/pages/components/animated_helpers.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RiskViewModel>().loadSummary();
      context.read<RiskViewModel>().loadTopRisk();
      context.read<RiskViewModel>().loadResults();
      context.read<StudentViewModel>().loadStudents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentPage: "/dashboard",
      title: "Dashboard",
      body: Consumer2<RiskViewModel, StudentViewModel>(
        builder: (context, riskVm, studentVm, _) {
          if (riskVm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (riskVm.summary == null) {
            return const Center(child: Text("Chưa có dữ liệu. Hãy tính AHP trước."));
          }

          final total = riskVm.summary!['total'] ?? 0;
          final high = riskVm.summary!['high'] ?? 0;
          final medium = riskVm.summary!['medium'] ?? 0;
          final low = riskVm.summary!['low'] ?? 0;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome header
                FadeSlideIn(
                  delay: 0,
                  child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0F172A), Color(0xFF1E3A5F), Color(0xFF3B82F6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1E3A5F).withValues(alpha: 0.4),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hệ thống Cảnh Báo Sớm DSS",
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Phân tích rủi ro sinh viên bằng AHP & Decision Tree",
                              style: GoogleFonts.inter(
                                color: Colors.white.withValues(alpha: 0.7),
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                "📊 Tổng: $total sinh viên đang theo dõi",
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(Icons.school_rounded, color: Colors.white, size: 56),
                      ),
                    ],
                  ),
                ),
                ),

                const SizedBox(height: 24),

                // Summary cards row
                Row(
                  children: [
                    _buildSummaryCard(
                      icon: Icons.people_rounded,
                      label: "Tổng sinh viên",
                      value: total,
                      color: const Color(0xFF3B82F6),
                      delay: 100,
                    ),
                    const SizedBox(width: 16),
                    _buildSummaryCard(
                      icon: Icons.check_circle_rounded,
                      label: "Rủi ro thấp",
                      value: low,
                      color: const Color(0xFF22C55E),
                      delay: 200,
                    ),
                    const SizedBox(width: 16),
                    _buildSummaryCard(
                      icon: Icons.warning_amber_rounded,
                      label: "Rủi ro TB",
                      value: medium,
                      color: const Color(0xFFF59E0B),
                      delay: 300,
                    ),
                    const SizedBox(width: 16),
                    _buildSummaryCard(
                      icon: Icons.dangerous_rounded,
                      label: "Rủi ro cao",
                      value: high,
                      color: const Color(0xFFEF4444),
                      delay: 400,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Charts row
                FadeSlideIn(
                  delay: 500,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    // Pie chart
                    Expanded(
                      flex: 1,
                      child: _buildChartCard(
                        title: "Phân bổ mức rủi ro",
                        child: SizedBox(
                          height: 260,
                          child: total > 0
                              ? PieChart(
                                  PieChartData(
                                    sectionsSpace: 3,
                                    centerSpaceRadius: 50,
                                    pieTouchData: PieTouchData(enabled: true),
                                    sections: [
                                      PieChartSectionData(
                                        value: low.toDouble(),
                                        title: low > 0 ? "Low\n$low" : "",
                                        color: const Color(0xFF22C55E),
                                        radius: 65,
                                        titleStyle: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12,
                                        ),
                                      ),
                                      PieChartSectionData(
                                        value: medium.toDouble(),
                                        title: medium > 0 ? "Med\n$medium" : "",
                                        color: const Color(0xFFF59E0B),
                                        radius: 65,
                                        titleStyle: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12,
                                        ),
                                      ),
                                      PieChartSectionData(
                                        value: high.toDouble(),
                                        title: high > 0 ? "High\n$high" : "",
                                        color: const Color(0xFFEF4444),
                                        radius: 65,
                                        titleStyle: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : const Center(child: Text("Không có dữ liệu")),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Bar chart
                    Expanded(
                      flex: 1,
                      child: _buildChartCard(
                        title: "Biểu đồ cột rủi ro",
                        child: SizedBox(
                          height: 260,
                          child: BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              maxY: (total > 0 ? total.toDouble() : 10) * 1.2,
                              barTouchData: BarTouchData(
                                enabled: true,
                                touchTooltipData: BarTouchTooltipData(
                                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                    final labels = ["Low Risk", "Medium Risk", "High Risk"];
                                    return BarTooltipItem(
                                      "${labels[group.x]}\n${rod.toY.toInt()} SV",
                                      const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    );
                                  },
                                ),
                              ),
                              titlesData: FlTitlesData(
                                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 30,
                                    getTitlesWidget: (value, meta) {
                                      if (value == value.roundToDouble()) {
                                        return Text("${value.toInt()}", style: const TextStyle(fontSize: 11));
                                      }
                                      return const SizedBox.shrink();
                                    },
                                  ),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      switch (value.toInt()) {
                                        case 0:
                                          return const Text("Low", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12));
                                        case 1:
                                          return const Text("Medium", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12));
                                        case 2:
                                          return const Text("High", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12));
                                      }
                                      return const Text("");
                                    },
                                  ),
                                ),
                              ),
                              borderData: FlBorderData(show: false),
                              gridData: FlGridData(
                                show: true,
                                drawVerticalLine: false,
                                horizontalInterval: 1,
                                getDrawingHorizontalLine: (value) => FlLine(
                                  color: Colors.grey.shade200,
                                  strokeWidth: 1,
                                ),
                              ),
                              barGroups: [
                                BarChartGroupData(x: 0, barRods: [
                                  BarChartRodData(
                                    toY: low.toDouble(),
                                    color: const Color(0xFF22C55E),
                                    width: 40,
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                                  ),
                                ]),
                                BarChartGroupData(x: 1, barRods: [
                                  BarChartRodData(
                                    toY: medium.toDouble(),
                                    color: const Color(0xFFF59E0B),
                                    width: 40,
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                                  ),
                                ]),
                                BarChartGroupData(x: 2, barRods: [
                                  BarChartRodData(
                                    toY: high.toDouble(),
                                    color: const Color(0xFFEF4444),
                                    width: 40,
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                                  ),
                                ]),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                ),

                const SizedBox(height: 24),

                // Top risk students table
                FadeSlideIn(
                  delay: 600,
                  child: _buildChartCard(
                  title: "🔴 Sinh viên nguy cơ cao nhất",
                  child: riskVm.topRisk.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Table(
                            columnWidths: const {
                              0: FixedColumnWidth(60),
                              1: FlexColumnWidth(1.2),
                              2: FlexColumnWidth(2),
                              3: FlexColumnWidth(1.2),
                              4: FlexColumnWidth(1.2),
                              5: FlexColumnWidth(1.4),
                            },
                            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                            border: TableBorder(
                              horizontalInside: BorderSide(color: Colors.grey.shade200, width: 1),
                            ),
                            children: [
                              // Header row
                              TableRow(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Color(0xFF1E293B), Color(0xFF334155)],
                                  ),
                                ),
                                children: [
                                  for (final h in ["STT", "Mã SV", "Họ tên", "Lớp", "Risk Score", "Mức rủi ro"])
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                                      child: Text(h, style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
                                    ),
                                ],
                              ),
                              // Data rows
                              ...List.generate(riskVm.topRisk.length, (i) {
                                final risk = riskVm.topRisk[i];
                                final student = studentVm.students.where((s) => s.id == risk.studentId).firstOrNull;
                                final isHigh = risk.riskLevel == "High Risk";

                                return TableRow(
                                  decoration: BoxDecoration(
                                    color: i % 2 == 0 ? Colors.white : const Color(0xFFF8FAFC),
                                  ),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                                      child: Text("${i + 1}", style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF64748B))),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                                      child: Text(student?.studentCode ?? "-", style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                                      child: Text(student?.name ?? "SV #${risk.studentId}", style: GoogleFonts.inter(fontSize: 13)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                                      child: Text(student?.className ?? "-", style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF64748B))),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                                      child: Text(
                                        risk.riskScore.toStringAsFixed(2),
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                          color: isHigh ? const Color(0xFFEF4444) : const Color(0xFFF59E0B),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: isHigh
                                                  ? [const Color(0xFFEF4444), const Color(0xFFDC2626)]
                                                  : [const Color(0xFFF59E0B), const Color(0xFFD97706)],
                                            ),
                                            borderRadius: BorderRadius.circular(20),
                                            boxShadow: [
                                              BoxShadow(
                                                color: (isHigh ? const Color(0xFFEF4444) : const Color(0xFFF59E0B)).withValues(alpha: 0.3),
                                                blurRadius: 6,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Text(
                                            risk.riskLevel,
                                            style: GoogleFonts.inter(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ],
                          ),
                        )
                      : const Padding(
                          padding: EdgeInsets.all(20),
                          child: Text("Chưa có dữ liệu top risk. Hãy tính AHP trước."),
                        ),
                ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required String label,
    required int value,
    required Color color,
    int delay = 0,
  }) {
    return Expanded(
      child: FadeSlideIn(
        delay: delay,
        child: HoverCard(
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color.withValues(alpha: 0.15), color.withValues(alpha: 0.05)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: color, size: 26),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: GoogleFonts.inter(
                          color: const Color(0xFF94A3B8),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      AnimatedCounter(
                        value: value,
                        style: GoogleFonts.inter(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 4,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color, color.withValues(alpha: 0.3)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChartCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 16, color: const Color(0xFF1E293B)),
          ),
          const SizedBox(height: 4),
          Divider(color: Colors.grey.shade100),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}