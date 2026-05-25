import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../models/repo_filter_state.dart';

class RepoFilterBottomSheet extends StatefulWidget {
  final RepoFilterState initialState;

  const RepoFilterBottomSheet({
    super.key,
    required this.initialState,
  });

  @override
  State<RepoFilterBottomSheet> createState() => _RepoFilterBottomSheetState();
}

class _RepoFilterBottomSheetState extends State<RepoFilterBottomSheet> {
  late RepoFilterState _state;

  static const _sortOptions = [
    (value: null, labelKey: 'relevance'),
    (value: 'alpha', labelKey: 'alphabetical'),
    (value: 'created', labelKey: 'newest'),
    (value: 'updated', labelKey: 'recentlyUpdated'),
    (value: 'stars', labelKey: 'mostStars'),
    (value: 'size', labelKey: 'largest'),
  ];

  @override
  void initState() {
    super.initState();
    _state = widget.initialState;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return SafeArea(
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 32,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                l10n.filters,
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionTitle(title: l10n.sort),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _sortOptions.map((option) {
                        final isSelected = _state.sort == option.value;
                        return FilterChip(
                          label: Text(_getSortLabel(option.labelKey, l10n)),
                          selected: isSelected,
                          onSelected: (_) => setState(() => _state = _state.copyWith(
                            sort: option.value,
                            clearSort: option.value == null,
                          )),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    _SectionTitle(title: l10n.order),
                    const SizedBox(height: 8),
                    SegmentedButton<String?>(
                      segments: [
                        ButtonSegment(value: null, label: Text(l10n.default_)),
                        ButtonSegment(value: 'asc', label: Text(l10n.ascending)),
                        ButtonSegment(value: 'desc', label: Text(l10n.descending)),
                      ],
                      selected: {_state.order},
                      onSelectionChanged: (set) => setState(() => _state = _state.copyWith(
                        order: set.first,
                        clearOrder: set.first == null,
                      )),
                    ),
                    const SizedBox(height: 16),
                    CheckboxListTile(
                      title: Text(l10n.privateReposOnly),
                      value: _state.private ?? false,
                      onChanged: (v) => setState(() => _state = _state.copyWith(private: v)),
                      contentPadding: EdgeInsets.zero,
                    ),
                    CheckboxListTile(
                      title: Text(l10n.includeArchived),
                      value: _state.archived ?? false,
                      onChanged: (v) => setState(() => _state = _state.copyWith(archived: v)),
                      contentPadding: EdgeInsets.zero,
                    ),
                    CheckboxListTile(
                      title: Text(l10n.templatesOnly),
                      value: _state.template ?? false,
                      onChanged: (v) => setState(() => _state = _state.copyWith(template: v)),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, const RepoFilterState()),
                      child: Text(l10n.reset),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => Navigator.pop(context, _state),
                      child: Text(l10n.apply),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
    );
  }

  String _getSortLabel(String key, AppLocalizations l10n) {
    return switch (key) {
      'relevance' => l10n.relevance,
      'alphabetical' => l10n.alphabetical,
      'newest' => l10n.newest,
      'recentlyUpdated' => l10n.recentlyUpdated,
      'mostStars' => l10n.mostStars,
      'largest' => l10n.largest,
      _ => key,
    };
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}
