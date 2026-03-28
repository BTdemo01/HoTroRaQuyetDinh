import 'package:dssstudentfe/pages/ahp_report_page.dart';
import 'package:dssstudentfe/pages/components/animated_helpers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Services/ahp_service.dart';

class FinalResultPage extends StatefulWidget {
  const FinalResultPage({super.key});

  @override
  State<FinalResultPage> createState() => _FinalResultPageState();
}

class _FinalResultPageState extends State<FinalResultPage> {

  Map<String,dynamic>? result;

  List<Map<String, dynamic>> alternatives = [
    {
      "name": "Nguy cơ cao",
      "desc": "Sinh viên có nguy cơ học kém / rớt môn",
      "icon": Icons.warning_rounded,
      "color": const Color(0xFFEF4444),
    },
    {
      "name": "Nguy cơ trung bình",
      "desc": "Sinh viên có nguy cơ trung bình",
      "icon": Icons.info_rounded,
      "color": const Color(0xFFF59E0B),
    },
    {
      "name": "An toàn",
      "desc": "Sinh viên học ổn",
      "icon": Icons.check_circle_rounded,
      "color": const Color(0xFF22C55E),
    },
  ];

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    try {
      final service = AhpService();
      final data = await service.getFinalResult();
      setState(() {
        result = data;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Lỗi tải kết quả: $e")),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {

    if(result == null){
      return Scaffold(
        backgroundColor: const Color(0xFFF1F5F9),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    List<double> scores = [
      result!["a1"],
      result!["a2"],
      result!["a3"]
    ];

    int bestIndex = scores.indexOf(scores.reduce((a,b)=>a>b?a:b));

    return Scaffold(

      backgroundColor: const Color(0xFFF1F5F9),

      appBar: AppBar(
        title: Text("Kết quả đánh giá rủi ro",
          style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF1E293B),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),

      body: Center(

        child: Container(

          width: 600,
          padding: const EdgeInsets.all(28),

          child: SingleChildScrollView(
            child: Column(

            children: [

              FadeSlideIn(
                delay: 0,
                child: Text(
                  "Kết quả AHP",
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0F172A),
                  ),
                ),
              ),

              const SizedBox(height: 6),

              FadeSlideIn(
                delay: 100,
                child: Text(
                  "Trọng số ưu tiên của từng phương án đánh giá rủi ro",
                  style: GoogleFonts.inter(color: const Color(0xFF94A3B8), fontSize: 14),
                ),
              ),

              const SizedBox(height: 24),

              for(int i=0;i<alternatives.length;i++)
                FadeSlideIn(
                  delay: 200 + i * 120,
                  child: HoverCard(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(18),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: (alternatives[i]["color"] as Color).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              alternatives[i]["icon"] as IconData,
                              color: alternatives[i]["color"] as Color,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      alternatives[i]["name"] as String,
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                      ),
                                    ),
                                    if (i == bestIndex) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF22C55E),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          "ƯU TIÊN",
                                          style: GoogleFonts.inter(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  alternatives[i]["desc"] as String,
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFF94A3B8),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            scores[i].toStringAsFixed(3),
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w800,
                              fontSize: 20,
                              color: i == bestIndex
                                  ? const Color(0xFF22C55E)
                                  : const Color(0xFF475569),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 20),

              FadeSlideIn(
                delay: 600,
                child: Container(

                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF22C55E).withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),

                child: Row(
                  children: [
                    const Icon(Icons.emoji_events_rounded, color: Colors.white, size: 32),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Kết luận",
                            style: GoogleFonts.inter(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            alternatives[bestIndex]["name"] as String,
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                ),
              ),

              const SizedBox(height: 32),

              FadeSlideIn(
                delay: 700,
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>AhpReportPage()));
                  },
                  icon: const Icon(Icons.description_rounded, size: 20),
                  label: Text(
                    "Lưu & Xem báo cáo AHP",
                    style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                  ),
                ),
                ),
              ),

            ],
          ),
          ),
        ),
      ),
    );
  }
}