import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateService {
  static const int currentVersion = 1; // رقم النسخة الحالية للتطبيق

  static Future<void> checkForUpdates(BuildContext context) async {
    try {
      final supabase = Supabase.instance.client;
      final update = await supabase
          .from('app_updates')
          .select()
          .eq('is_enabled', true)
          .gt('version_code', currentVersion)
          .order('version_code', ascending: false)
          .limit(1)
          .maybeSingle();

      if (update != null && context.mounted) {
        final bool isMandatory = update['is_mandatory'] ?? false;
        final String title = update['title'] ?? 'تحديث جديد متوفر';
        final String description =
            update['description'] ??
            'هناك نسخة جديدة من التطبيق متوفرة للتحميل.';
        final String downloadUrl = update['download_url'];

        showDialog(
          context: context,
          barrierDismissible:
              !isMandatory, // لا يمكن إغلاقها بالنقر خارجاً إذا كان التحديث إجباياً
          builder: (context) => PopScope(
            canPop:
                !isMandatory, // منع الرجوع بالزر الخلفي إذا كان التحديث إجبارياً
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Icon(
                    isMandatory
                        ? Icons.system_update_rounded
                        : Icons.update_rounded,
                    color: Colors.blue.shade700,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(description),
                  if (isMandatory) ...[
                    const SizedBox(height: 15),
                    const Text(
                      'هذا التحديث ضروري لمتابعة استخدام التطبيق.',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ],
              ),
              actions: [
                if (!isMandatory)
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'لاحقاً',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    final url = Uri.parse(downloadUrl);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(
                        url,
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  },
                  child: const Text('تحديث الآن'),
                ),
              ],
            ),
          ),
        );
      }
    } catch (e) {
      if (e is PostgrestException && e.code == 'PGRST205') {
        // Table not found: ignore in environments where app_updates isn't set up.
        return;
      }
      debugPrint('Error checking for updates: $e');
    }
  }
}
