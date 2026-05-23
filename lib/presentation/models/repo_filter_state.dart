class RepoFilterState {
  final String? sort;
  final String? order;
  final bool? private;
  final bool? archived;
  final bool? template;

  const RepoFilterState({
    this.sort,
    this.order,
    this.private,
    this.archived,
    this.template,
  });

  bool get hasFilters =>
      sort != null ||
      order != null ||
      private != null ||
      archived != null ||
      template != null;

  RepoFilterState copyWith({
    String? sort,
    String? order,
    bool? private,
    bool? archived,
    bool? template,
    bool clearSort = false,
    bool clearOrder = false,
  }) {
    return RepoFilterState(
      sort: clearSort ? null : (sort ?? this.sort),
      order: clearOrder ? null : (order ?? this.order),
      private: private ?? this.private,
      archived: archived ?? this.archived,
      template: template ?? this.template,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RepoFilterState &&
          runtimeType == other.runtimeType &&
          sort == other.sort &&
          order == other.order &&
          private == other.private &&
          archived == other.archived &&
          template == other.template;

  @override
  int get hashCode =>
      sort.hashCode ^
      order.hashCode ^
      private.hashCode ^
      archived.hashCode ^
      template.hashCode;
}
