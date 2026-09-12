import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/errors/error_logger.dart';
import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../domain/backup_service.dart';
import '../providers/backup_provider.dart';
import 'plain_text_area.dart';

/// "Sauvegarde" section of the Settings tab (US-074): export the whole
/// backup as a JSON file (shared through `share_plus`, which on web falls
/// back to a browser download — see `docs/ARCHITECTURE.md`, "Backup
/// format") and import one back by pasting its content (no Material file
/// picker UI exists on this widgets-only stack, so a plain paste field is
/// the import path everywhere).
class BackupSection extends ConsumerStatefulWidget {
  const BackupSection({super.key});

  @override
  ConsumerState<BackupSection> createState() => _BackupSectionState();
}

enum _Status { idle, working, success, error }

class _BackupSectionState extends ConsumerState<BackupSection> {
  final TextEditingController _importController = TextEditingController();

  _Status _exportStatus = _Status.idle;
  String? _exportMessage;

  _Status _importStatus = _Status.idle;
  String? _importMessage;

  @override
  void dispose() {
    _importController.dispose();
    super.dispose();
  }

  Future<void> _export() async {
    setState(() {
      _exportStatus = _Status.working;
      _exportMessage = null;
    });
    try {
      final service = ref.read(backupServiceProvider);
      final json = await service.exportJson();
      final now = DateTime.now();
      final fileName =
          'psy-trainer-backup-'
          '${now.year.toString().padLeft(4, '0')}'
          '${now.month.toString().padLeft(2, '0')}'
          '${now.day.toString().padLeft(2, '0')}'
          '.json';
      final bytes = Uint8List.fromList(utf8.encode(json));
      final result = await SharePlus.instance.share(
        ShareParams(
          files: [
            XFile.fromData(bytes, name: fileName, mimeType: 'application/json'),
          ],
          fileNameOverrides: [fileName],
        ),
      );
      if (!mounted) return;
      final cancelled = result.status == ShareResultStatus.dismissed;
      setState(() {
        _exportStatus = cancelled ? _Status.idle : _Status.success;
        _exportMessage = cancelled
            ? context.l10n.backupExportCancelled
            : context.l10n.backupExportSuccess;
      });
    } on Object catch (error, stack) {
      logError(error, stack, context: 'backup export');
      if (!mounted) return;
      setState(() {
        _exportStatus = _Status.error;
        _exportMessage = context.l10n.backupExportError;
      });
    }
  }

  Future<void> _import() async {
    final raw = _importController.text.trim();
    if (raw.isEmpty) {
      setState(() {
        _importStatus = _Status.error;
        _importMessage = context.l10n.backupImportEmpty;
      });
      return;
    }
    setState(() {
      _importStatus = _Status.working;
      _importMessage = null;
    });
    try {
      final service = ref.read(backupServiceProvider);
      final summary = await service.importJson(raw);
      if (!mounted) return;
      setState(() {
        _importStatus = _Status.success;
        _importMessage = context.l10n.backupImportSuccess(
          summary.inserted,
          summary.updated,
          summary.skipped,
        );
      });
      _importController.clear();
    } on BackupFormatException catch (error) {
      if (!mounted) return;
      setState(() {
        _importStatus = _Status.error;
        _importMessage = _messageFor(error.reason);
      });
    } on Object catch (error, stack) {
      logError(error, stack, context: 'backup import');
      if (!mounted) return;
      setState(() {
        _importStatus = _Status.error;
        _importMessage = context.l10n.backupErrorGeneric;
      });
    }
  }

  String _messageFor(BackupErrorReason reason) => switch (reason) {
    BackupErrorReason.invalidJson => context.l10n.backupErrorInvalidJson,
    BackupErrorReason.notAnObject => context.l10n.backupErrorNotAnObject,
    BackupErrorReason.wrongFormat => context.l10n.backupErrorWrongFormat,
    BackupErrorReason.unsupportedVersion =>
      context.l10n.backupErrorUnsupportedVersion,
    BackupErrorReason.missingData => context.l10n.backupErrorMissingData,
    BackupErrorReason.invalidRow => context.l10n.backupErrorInvalidRow,
  };

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(context.l10n.backupExportHint, style: theme.textStyles.caption),
        SizedBox(height: theme.spacing.sm),
        SecondaryButton(
          label: context.l10n.backupExportAction,
          expand: true,
          onPressed: _exportStatus == _Status.working ? null : _export,
        ),
        if (_exportMessage != null) ...[
          SizedBox(height: theme.spacing.xs),
          Text(
            _exportMessage!,
            style: theme.textStyles.caption.copyWith(
              color: _exportStatus == _Status.error
                  ? theme.colors.error
                  : theme.colors.textSecondary,
            ),
          ),
        ],
        SizedBox(height: theme.spacing.lg),
        Text(context.l10n.backupImportTitle, style: theme.textStyles.label),
        SizedBox(height: theme.spacing.sm),
        PlainTextArea(
          controller: _importController,
          hintText: context.l10n.backupImportHint,
          semanticsLabel: context.l10n.backupImportTitle,
        ),
        SizedBox(height: theme.spacing.sm),
        SecondaryButton(
          label: context.l10n.backupImportAction,
          expand: true,
          onPressed: _importStatus == _Status.working ? null : _import,
        ),
        if (_importMessage != null) ...[
          SizedBox(height: theme.spacing.xs),
          Text(
            _importMessage!,
            style: theme.textStyles.caption.copyWith(
              color: _importStatus == _Status.error
                  ? theme.colors.error
                  : theme.colors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}
