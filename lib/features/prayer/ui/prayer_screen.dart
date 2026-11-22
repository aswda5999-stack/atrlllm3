import 'package:shared_preferences/shared_preferences.dart';
import 'azan_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:adhan/adhan.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/islamic_pattern_background.dart';

/// صفحة مواقيت الصلاة
class PrayerScreen extends StatefulWidget {
  const PrayerScreen({super.key});

  @override
  State<PrayerScreen> createState() => _PrayerScreenState();
}

class _PrayerScreenState extends State<PrayerScreen> {
  bool _isLoading = true;
  String _errorMessage = '';
  PrayerTimes? _prayerTimes;
  String _locationName = 'جارٍ تحديد الموقع...';

  @override
  void initState() {
    super.initState();
    _loadPrayerTimes();
  }

  /// جلب الموقع وحساب المواقيت
  Future<void> _loadPrayerTimes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // 1. التحقق من خدمة الموقع
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _errorMessage = 'خدمة الموقع غير مفعلة، يرجى تفعيلها من الإعدادات.';
          _isLoading = false;
        });
        return;
      }

      // 2. التحقق من الصلاحيات
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _errorMessage = 'تم رفض صلاحية الموقع.';
            _isLoading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _errorMessage = 'صلاحية الموقع مرفوضة نهائياً. يرجى تفعيلها من إعدادات الجهاز.';
          _isLoading = false;
        });
        return;
      }

      // 3. الحصول على الموقع الحالي
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // 4. حساب مواقيت الصلاة وفق الإعدادات المحفوظة
      final prefs = await SharedPreferences.getInstance();
      final methodKey = prefs.getString('prayer_calc_method') ?? 'umm_al_qura';
      final madhabKey = prefs.getString('prayer_madhab') ?? 'shafi';
      CalculationMethod method;
      switch (methodKey) {
        case 'muslim_world_league':
          method = CalculationMethod.muslim_world_league;
          break;
        case 'egyptian':
          method = CalculationMethod.egyptian;
          break;
        case 'karachi':
          method = CalculationMethod.karachi;
          break;
        case 'north_america':
          method = CalculationMethod.north_america;
          break;
        default:
          method = CalculationMethod.umm_al_qura;
      }
      final coordinates = Coordinates(position.latitude, position.longitude);
      final params = method.getParameters();
      params.madhab = madhabKey == 'hanafi' ? Madhab.hanafi : Madhab.shafi;
      final prayerTimes = PrayerTimes.today(coordinates, params);

      setState(() {
        _prayerTimes = prayerTimes;
        _locationName =
            '${position.latitude.toStringAsFixed(2)}, ${position.longitude.toStringAsFixed(2)}';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'حدث خطأ أثناء تحديد الموقع: $e';
        _isLoading = false;
      });
    }
  }

  /// تنسيق الوقت للعرض
  String _formatTime(DateTime? time) {
    if (time == null) return '--:--';
    final hour = time.hour > 12 ? time.hour - 12 : time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'م' : 'ص';
    return '${hour == 0 ? 12 : hour}:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IslamicPatternBackground(
        child: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage.isNotEmpty
                  ? _ErrorView(
                      message: _errorMessage,
                      onRetry: _loadPrayerTimes,
                    )
                  : _PrayerContent(
                      prayerTimes: _prayerTimes!,
                      locationName: _locationName,
                      formatTime: _formatTime,
                      onRefresh: _loadPrayerTimes,
                    ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════
//  محتوى المواقيت
// ══════════════════════════════════════════════════════

class _PrayerContent extends StatelessWidget {
  final PrayerTimes prayerTimes;
  final String locationName;
  final String Function(DateTime?) formatTime;
  final VoidCallback onRefresh;

  const _PrayerContent({
    required this.prayerTimes,
    required this.locationName,
    required this.formatTime,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final prayers = [
      {'name': 'الفجر', 'time': prayerTimes.fajr, 'icon': Icons.wb_twilight_rounded},
      {'name': 'الشروق', 'time': prayerTimes.sunrise, 'icon': Icons.wb_sunny_rounded},
      {'name': 'الظهر', 'time': prayerTimes.dhuhr, 'icon': Icons.wb_sunny_outlined},
      {'name': 'العصر', 'time': prayerTimes.asr, 'icon': Icons.wb_cloudy_rounded},
      {'name': 'المغرب', 'time': prayerTimes.maghrib, 'icon': Icons.wb_twilight_rounded},
      {'name': 'العشاء', 'time': prayerTimes.isha, 'icon': Icons.nights_stay_rounded},
    ];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── العنوان + الموقع ─────────────────────
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.mosque_rounded,
                    color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('مواقيت الصلاة',
                        style: AppTextStyles.headline.copyWith(fontSize: 22)),
                    Row(
                      children: [
                        const Icon(Icons.location_on_rounded,
                            size: 14, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            locationName,
                            style: AppTextStyles.tiny,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onRefresh,
                icon: const Icon(Icons.refresh_rounded,
                    color: AppColors.skyDark),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── بطاقة الصلاة القادمة (اختياري) ──────
          _NextPrayerBanner(prayerTimes: prayerTimes, formatTime: formatTime),
          const SizedBox(height: 20),

          // ── قائمة المواقيت ──────────────────────
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: prayers.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final prayer = prayers[index];
              return _PrayerCard(
                name: prayer['name'] as String,
                time: formatTime(prayer['time'] as DateTime?),
                icon: prayer['icon'] as IconData,
                isNext: index == 0, // يمكن تحسينها لاحقاً لحساب الصلاة القادمة
              );
            },
          ),
          const SizedBox(height: 20),

          // ── زر إعدادات الأذان ───────────────────
          _AzanSettingsButton(),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════
//  مكونات مساعدة
// ══════════════════════════════════════════════════════

class _PrayerCard extends StatelessWidget {
  final String name;
  final String time;
  final IconData icon;
  final bool isNext;

  const _PrayerCard({
    required this.name,
    required this.time,
    required this.icon,
    this.isNext = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isNext ? AppColors.skyLight : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isNext ? AppColors.skyPrimary : AppColors.divider,
          width: isNext ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isNext ? AppColors.skyPrimary : AppColors.skyLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isNext ? Colors.white : AppColors.skyDark,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              name,
              style: AppTextStyles.title.copyWith(fontSize: 16),
            ),
          ),
          Text(
            time,
            style: AppTextStyles.title.copyWith(
              fontSize: 16,
              color: isNext ? AppColors.skyDark : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _NextPrayerBanner extends StatelessWidget {
  final PrayerTimes prayerTimes;
  final String Function(DateTime?) formatTime;

  const _NextPrayerBanner({
    required this.prayerTimes,
    required this.formatTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.access_time_filled_rounded,
              color: Colors.white, size: 36),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الصلاة القادمة',
                  style: AppTextStyles.captionOnDark.copyWith(fontSize: 12),
                ),
                Text(
                  'الفجر',
                  style: AppTextStyles.titleOnDark.copyWith(fontSize: 20),
                ),
              ],
            ),
          ),
          Text(
            formatTime(prayerTimes.fajr),
            style: AppTextStyles.titleOnDark.copyWith(fontSize: 24),
          ),
        ],
      ),
    );
  }
}

class _AzanSettingsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AzanSettingsScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            const Icon(Icons.volume_up_rounded,
                color: AppColors.skyDark, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'إعدادات الأذان',
                style: AppTextStyles.title.copyWith(fontSize: 15),
              ),
            ),
            const Icon(Icons.arrow_back_ios_new_rounded,
                size: 16, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_off_rounded,
                size: 64, color: AppColors.textSecondary),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.body,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
}
