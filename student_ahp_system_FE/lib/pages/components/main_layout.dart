import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'animated_helpers.dart';

class MainLayout extends StatelessWidget {
  final String currentPage;
  final String title;
  final Widget body;

  const MainLayout({
    super.key,
    required this.currentPage,
    required this.title,
    required this.body,
  });

  static const _sidebarColor = Color(0xFF0F172A);
  static const _sidebarSurface = Color(0xFF1E293B);
  static const _accentColor = Color(0xFF3B82F6);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 264,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [_sidebarColor, Color(0xFF0C1322)],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 24,
                  offset: const Offset(4, 0),
                ),
              ],
            ),
            child: Column(
              children: [
                // Logo area
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF3B82F6), Color(0xFF6366F1)],
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: _accentColor.withValues(alpha: 0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.school_rounded, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "DSS",
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "Cảnh Báo Sớm",
                              style: GoogleFonts.inter(
                                color: Colors.white38,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withValues(alpha: 0.0),
                          Colors.white.withValues(alpha: 0.08),
                          Colors.white.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Menu label
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "ĐIỀU HƯỚNG",
                      style: GoogleFonts.inter(
                        color: Colors.white24,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                _SidebarMenuItem(
                  icon: Icons.dashboard_rounded,
                  label: "Dashboard",
                  route: "/dashboard",
                  currentPage: currentPage,
                ),
                _SidebarMenuItem(
                  icon: Icons.balance_rounded,
                  label: "AHP",
                  route: "/ahp",
                  currentPage: currentPage,
                ),
                _SidebarMenuItem(
                  icon: Icons.assessment_rounded,
                  label: "Báo cáo AHP",
                  route: "/ahp-report",
                  currentPage: currentPage,
                ),
                _SidebarMenuItem(
                  icon: Icons.people_alt_rounded,
                  label: "Sinh viên",
                  route: "/students",
                  currentPage: currentPage,
                ),
                _SidebarMenuItem(
                  icon: Icons.psychology_rounded,
                  label: "AI Dự đoán",
                  route: "/ai-predict",
                  currentPage: currentPage,
                ),
                _SidebarMenuItem(
                  icon: Icons.notifications_active_rounded,
                  label: "Thông báo",
                  route: "/notifications",
                  currentPage: currentPage,
                ),
                const Spacer(),
                // Footer
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: _sidebarSurface.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: _accentColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.auto_graph_rounded, color: _accentColor.withValues(alpha: 0.6), size: 16),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "AHP + Decision Tree\nv1.0.0",
                            style: GoogleFonts.inter(
                              color: Colors.white.withValues(alpha: 0.3),
                              fontSize: 10,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Main content
          Expanded(
            child: Column(
              children: [
                // Top bar
                Container(
                  height: 64,
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.inter(
                          color: const Color(0xFF0F172A),
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0FDF4),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: const Color(0xFFBBF7D0)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const PulsingDot(color: Color(0xFF22C55E), size: 8),
                            const SizedBox(width: 8),
                            Text(
                              "Hệ thống hoạt động",
                              style: GoogleFonts.inter(
                                color: const Color(0xFF166534),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Body
                Expanded(child: body),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Stateful menu item with hover animation
class _SidebarMenuItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final String route;
  final String currentPage;

  const _SidebarMenuItem({
    required this.icon,
    required this.label,
    required this.route,
    required this.currentPage,
  });

  @override
  State<_SidebarMenuItem> createState() => _SidebarMenuItemState();
}

class _SidebarMenuItemState extends State<_SidebarMenuItem> {
  bool _hovering = false;

  static const _accentColor = Color(0xFF3B82F6);

  @override
  Widget build(BuildContext context) {
    final active = widget.currentPage == widget.route;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovering = true),
        onExit: (_) => setState(() => _hovering = false),
        child: GestureDetector(
          onTap: () {
            if (!active) {
              Navigator.pushReplacementNamed(context, widget.route);
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
            decoration: BoxDecoration(
              color: active
                  ? _accentColor.withValues(alpha: 0.15)
                  : (_hovering ? Colors.white.withValues(alpha: 0.05) : Colors.transparent),
              borderRadius: BorderRadius.circular(12),
              border: active
                  ? Border.all(color: _accentColor.withValues(alpha: 0.25), width: 1)
                  : null,
            ),
            child: Row(
              children: [
                // Active indicator bar
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 3,
                  height: active ? 20 : 0,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: _accentColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Icon(
                  widget.icon,
                  color: active
                      ? _accentColor
                      : (_hovering ? Colors.white.withValues(alpha: 0.8) : Colors.white.withValues(alpha: 0.4)),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  widget.label,
                  style: GoogleFonts.inter(
                    color: active
                        ? Colors.white
                        : (_hovering ? Colors.white.withValues(alpha: 0.9) : Colors.white.withValues(alpha: 0.5)),
                    fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
                if (active) ...[
                  const Spacer(),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: _accentColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: _accentColor.withValues(alpha: 0.5),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
