import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../models/issue_filter_state.dart';

class IssueFilterBottomSheet extends StatefulWidget {
  final IssueFilterState initialState;
  final List<String> availableLabels;
  final List<String> availableMilestones;
  final bool showAssigneeFilters;

  const IssueFilterBottomSheet({
    super.key,
    required this.initialState,
    required this.availableLabels,
    required this.availableMilestones,
    this.showAssigneeFilters = true,
  });

  @override
  State<IssueFilterBottomSheet> createState() => _IssueFilterBottomSheetState();
}

class _IssueFilterBottomSheetState extends State<IssueFilterBottomSheet> {
  late IssueFilterState _state;

  @override
  void initState() {
    super.initState();
    _state = widget.initialState;
  }

  void _toggleLabel(String label) {
    final labels = Set<String>.from(_state.labels);
    if (labels.contains(label)) {
      labels.remove(label);
    } else {
      labels.add(label);
    }
    setState(() => _state = _state.copyWith(labels: labels));
  }

  void _toggleMilestone(String milestone) {
    final milestones = Set<String>.from(_state.milestones);
    if (milestones.contains(milestone)) {
      milestones.remove(milestone);
    } else {
      milestones.add(milestone);
    }
    setState(() => _state = _state.copyWith(milestones: milestones));
  }

  void _setType(String? type) {
    setState(() => _state = _state.copyWith(type: type, clearType: type == null));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomPadding),
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
                    if (widget.availableLabels.isNotEmpty) ...[
                      _SectionTitle(title: l10n.labels),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: widget.availableLabels.map((label) {
                          final isSelected = _state.labels.contains(label);
                          return FilterChip(
                            label: Text(label),
                            selected: isSelected,
                            onSelected: (_) => _toggleLabel(label),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                    ] else ...[
                      _SectionTitle(title: l10n.labels),
                      const SizedBox(height: 8),
                      Text(
                        l10n.noLabelsAvailable,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    if (widget.availableMilestones.isNotEmpty) ...[
                      _SectionTitle(title: l10n.milestones),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: widget.availableMilestones.map((m) {
                          final isSelected = _state.milestones.contains(m);
                          return FilterChip(
                            label: Text(m),
                            selected: isSelected,
                            onSelected: (_) => _toggleMilestone(m),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                    ] else ...[
                      _SectionTitle(title: l10n.milestones),
                      const SizedBox(height: 8),
                      Text(
                        l10n.noMilestonesAvailable,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    _SectionTitle(title: l10n.type),
                    const SizedBox(height: 8),
                    SegmentedButton<String?>(
                      segments: [
                        ButtonSegment(value: null, label: Text(l10n.all)),
                        ButtonSegment(value: 'issues', label: Text(l10n.issues)),
                        ButtonSegment(value: 'pulls', label: Text(l10n.pullRequests)),
                      ],
                      selected: {_state.type},
                      onSelectionChanged: (set) => _setType(set.first),
                    ),
                    const SizedBox(height: 16),
                    if (widget.showAssigneeFilters) ...[
                      CheckboxListTile(
                        title: Text(l10n.assignedToMe),
                        value: _state.assignedToMe,
                        onChanged: (v) => setState(() => _state = _state.copyWith(assignedToMe: v)),
                        contentPadding: EdgeInsets.zero,
                      ),
                      CheckboxListTile(
                        title: Text(l10n.createdByMe),
                        value: _state.createdByMe,
                        onChanged: (v) => setState(() => _state = _state.copyWith(createdByMe: v)),
                        contentPadding: EdgeInsets.zero,
                      ),
                      CheckboxListTile(
                        title: Text(l10n.mentionedMe),
                        value: _state.mentionedMe,
                        onChanged: (v) => setState(() => _state = _state.copyWith(mentionedMe: v)),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ],
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
                      onPressed: () => Navigator.pop(context, const IssueFilterState()),
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
      ),
    );
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
