import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pottery_diary/database/app_database.dart';
import 'package:pottery_diary/models/stage_status.dart';
import 'package:pottery_diary/models/stage_type.dart';
import 'package:pottery_diary/providers/providers.dart';
import 'package:pottery_diary/screens/create_piece_screen.dart' show showCreatePieceSheet;
import 'package:pottery_diary/widgets/piece_card.dart';

// null = All, StageType = in that stage, _kFinished = done with all
const _kFinished = 'finished';

// Tab definitions: label + color
const _kTabs = [
  (label: 'All', color: Color(0xFFB8A898), filter: null),
  (label: 'Formed', color: Color(0xFFD4A574), filter: StageType.formed),
  (label: 'Trimmed', color: Color(0xFFC4956A), filter: StageType.trimmed),
  (label: 'Bisqued', color: Color(0xFF9B7355), filter: StageType.bisqued),
  (label: 'Glazed', color: Color(0xFF7A5C42), filter: StageType.glazed),
  (label: 'Finished', color: Color(0xFF5C4A3A), filter: _kFinished),
];

class PiecesListScreen extends ConsumerStatefulWidget {
  const PiecesListScreen({super.key});

  @override
  ConsumerState<PiecesListScreen> createState() => _PiecesListScreenState();
}

class _PiecesListScreenState extends ConsumerState<PiecesListScreen> {
  bool _isGridView = true;
  bool _isSearching = false;
  String _query = '';
  Object? _filter; // null | StageType | _kFinished
  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchFocus.addListener(_onSearchFocusChange);
  }

  @override
  void dispose() {
    _searchFocus.removeListener(_onSearchFocusChange);
    _searchFocus.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchFocusChange() {
    if (!_searchFocus.hasFocus && _query.isEmpty) {
      setState(() => _isSearching = false);
    }
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _query = '';
        _searchFocus.unfocus();
      }
    });
  }

  void _dismissSearch() {
    _searchFocus.unfocus();
    if (_query.isEmpty) setState(() => _isSearching = false);
  }

  // The background color for the currently active filter tab
  Color get _activeColor {
    final tab = _kTabs.firstWhere(
      (t) => t.filter == _filter,
      orElse: () => _kTabs.first,
    );
    return tab.color;
  }

  @override
  Widget build(BuildContext context) {
    final piecesAsync = ref.watch(piecesProvider);

    return GestureDetector(
      onTap: _dismissSearch,
      behavior: HitTestBehavior.translucent,
      child: Scaffold(
        backgroundColor: Color.lerp(const Color(0xFFF7F4F0), _activeColor, 0.18)!,
        body: Stack(
          children: [
            // Main content
            NotificationListener<ScrollStartNotification>(
              onNotification: (_) {
                _searchFocus.unfocus();
                return false;
              },
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: Colors.transparent,
                    surfaceTintColor: Colors.transparent,
                    floating: true,
                    titleSpacing: 0,
                    toolbarHeight: 64,
                    title: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Text(
                            'My Pieces',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF2C2218),
                              letterSpacing: -0.5,
                            ),
                          ),
                          const Spacer(),
                          _IconBtn(
                            icon: Icons.search_rounded,
                            active: _isSearching,
                            onPressed: _toggleSearch,
                          ),
                          const SizedBox(width: 4),
                          _IconBtn(
                            icon: _isGridView
                                ? Icons.view_list_rounded
                                : Icons.grid_view_rounded,
                            onPressed: () =>
                                setState(() => _isGridView = !_isGridView),
                          ),
                          const SizedBox(width: 0),
                        ],
                      ),
                    ),
                  ),

                  // Search bar
                  if (_isSearching)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 4, 88, 12),
                        child: TextField(
                          controller: _searchController,
                          focusNode: _searchFocus,
                          autofocus: true,
                          textCapitalization: TextCapitalization.sentences,
                          onChanged: (v) => setState(() => _query = v),
                          decoration: InputDecoration(
                            hintText: 'Search pieces…',
                            prefixIcon: const Icon(Icons.search, size: 20),
                            suffixIcon: _query.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear, size: 18),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() => _query = '');
                                    },
                                  )
                                : null,
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ),

                  piecesAsync.when(
                    data: (pieces) {
                      final textFiltered = _query.isEmpty
                          ? pieces
                          : pieces
                              .where((p) => p.title
                                  .toLowerCase()
                                  .contains(_query.toLowerCase()))
                              .toList();

                      if (textFiltered.isEmpty) {
                        return const SliverFillRemaining(child: _EmptyState());
                      }

                      return _FilteredContent(
                        pieces: textFiltered,
                        filter: _filter,
                        isGridView: _isGridView,
                      );
                    },
                    loading: () => const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (e, _) => SliverFillRemaining(
                      child: Center(child: Text('Error: $e')),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),
            ),

            // Bookmark tabs on the right
            Positioned(
              right: 0,
              top: 120,
              child: _BookmarkTabs(
                currentFilter: _filter,
                onSelect: (f) => setState(() => _filter = f),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => showCreatePieceSheet(context),
          backgroundColor: const Color(0xFFCC4A2A),
          foregroundColor: Colors.white,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Icon button helper
// ---------------------------------------------------------------------------

class _IconBtn extends StatelessWidget {
  const _IconBtn({required this.icon, required this.onPressed, this.active = false});

  final IconData icon;
  final VoidCallback onPressed;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: active ? const Color(0xFFCC4A2A) : const Color(0xFFEDE5DA),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(18),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 18,
          color: active ? Colors.white : const Color(0xFF8B6B4A),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Bookmark tabs
// ---------------------------------------------------------------------------

class _BookmarkTabs extends StatelessWidget {
  const _BookmarkTabs({required this.currentFilter, required this.onSelect});

  final Object? currentFilter;
  final ValueChanged<Object?> onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: _kTabs.map((tab) {
        final isSelected = tab.filter == currentFilter;
        return _BookmarkTab(
          label: tab.label,
          color: tab.color,
          isSelected: isSelected,
          onTap: () => onSelect(tab.filter),
        );
      }).toList(),
    );
  }
}

class _BookmarkTab extends StatelessWidget {
  const _BookmarkTab({
    required this.label,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        margin: EdgeInsets.only(
          bottom: 3,
          // Unselected: pushed 10px right (tucked toward edge); selected: flush left, extends out
          left: isSelected ? 0 : 10,
        ),
        width: isSelected ? 52 : 42,
        height: isSelected ? 76 : 60,
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            bottomLeft: Radius.circular(10),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(isSelected ? 50 : 20),
              blurRadius: isSelected ? 8 : 3,
              offset: const Offset(-2, 1),
            ),
          ],
        ),
        child: Center(
          child: RotatedBox(
            quarterTurns: 3,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: isSelected ? 11 : 9,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Filtered content
// ---------------------------------------------------------------------------

class _FilteredContent extends ConsumerWidget {
  const _FilteredContent({
    required this.pieces,
    required this.filter,
    required this.isGridView,
  });

  final List<Piece> pieces;
  final Object? filter;
  final bool isGridView;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filtered = filter == null
        ? pieces
        : pieces.where((p) {
            final stages =
                ref.watch(stagesForPieceProvider(p.id)).valueOrNull ?? [];

            StageStatus statusOf(StageType t) {
              final s = stages.where((s) => s.stageType == t.name).firstOrNull;
              return s == null
                  ? StageStatus.notDone
                  : StageStatus.fromString(s.status);
            }

            if (filter == _kFinished) {
              return statusOf(StageType.finished) == StageStatus.done;
            }
            return switch (filter as StageType) {
              StageType.formed =>
                statusOf(StageType.formed) == StageStatus.notDone,
              StageType.trimmed =>
                statusOf(StageType.formed) == StageStatus.done &&
                    statusOf(StageType.trimmed) == StageStatus.notDone,
              StageType.bisqued =>
                statusOf(StageType.trimmed) == StageStatus.done &&
                    statusOf(StageType.bisqued) == StageStatus.notDone,
              StageType.glazed =>
                statusOf(StageType.bisqued) == StageStatus.done &&
                    statusOf(StageType.glazed) == StageStatus.notDone,
              StageType.finished =>
                statusOf(StageType.glazed) == StageStatus.done &&
                    statusOf(StageType.finished) == StageStatus.notDone,
            };
          }).toList();

    if (filtered.isEmpty) {
      return const SliverFillRemaining(child: _EmptyState());
    }

    if (isGridView) {
      return SliverPadding(
        padding: const EdgeInsets.only(left: 16, right: 60, top: 0),
        sliver: SliverGrid(
          delegate: SliverChildBuilderDelegate(
            (_, i) => PieceCard(piece: filtered[i], gridMode: true),
            childCount: filtered.length,
          ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.78,
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.only(right: 60),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (_, i) => PieceCard(piece: filtered[i]),
          childCount: filtered.length,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Empty state
// ---------------------------------------------------------------------------

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.spa_outlined, size: 72, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              'No pieces yet',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap + to start documenting your first piece.',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }
}
