import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// SEC-014: Guard for file downloads — check file extension / MIME type
/// before launching a download URL, and warn the user about dangerous
/// file types (executables, scripts, installers).
///
/// Usage:
/// ```dart
/// if (await DownloadGuard.confirmIfDangerous(context, url)) {
///   launchUrl(...);
/// }
/// ```

/// File extensions considered potentially dangerous on desktop/mobile.
const Set<String> _dangerousExtensions = {
  '.exe', '.msi', '.bat', '.cmd', '.com', '.scr', '.pif',
  '.dmg', '.pkg', '.apk', '.xapk', '.ipa',
  '.sh', '.bash', '.zsh', '.ps1', '.vbs', '.js', '.jse',
  '.wsf', '.wsh', '.jar', '.reg', '.lnk', '.app',
};

/// Extract the file extension (lowercased) from a URL path.
String? _extensionOf(String url) {
  try {
    final uri = Uri.parse(url);
    final path = uri.path;
    final lastSegment = path.split('/').last;
    final dot = lastSegment.lastIndexOf('.');
    if (dot < 0 || dot == lastSegment.length - 1) return null;
    return lastSegment.substring(dot).toLowerCase();
  } catch (_) {
    return null;
  }
}

/// Returns true if the URL points to a potentially dangerous file type.
bool isDangerousUrl(String url) {
  final ext = _extensionOf(url);
  return ext != null && _dangerousExtensions.contains(ext);
}

/// If [url] points to a dangerous file type, shows a confirmation dialog
/// warning the user. Returns true if the download should proceed
/// (URL is safe, or user confirmed), false if the user cancelled.
Future<bool> confirmIfDangerous(BuildContext context, String url) async {
  if (!isDangerousUrl(url)) return true;

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('⚠️ 危险文件警告'),
      content: const Text(
        '该文件类型可能是可执行文件或脚本（.exe/.apk/.sh 等），'
        '来自不受信任的来源可能包含恶意代码。\n\n确定要继续下载吗？',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: const Text('仍然下载'),
        ),
      ],
    ),
  );

  return confirmed ?? false;
}

/// Launch a download URL in the external browser, guarded by the
/// dangerous-file warning. Returns true if the URL was opened.
Future<bool> launchDownloadUrl(BuildContext context, String url) async {
  if (!await confirmIfDangerous(context, url)) return false;
  final uri = Uri.tryParse(url);
  if (uri == null) return false;
  return launchUrl(uri, mode: LaunchMode.externalApplication);
}
