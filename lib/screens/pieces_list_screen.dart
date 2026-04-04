import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pottery_diary/providers/providers.dart';
import 'package:pottery_diary/screens/create_piece_screen.dart';
import 'package:pottery_diary/widgets/piece_card.dart';

class PiecesListScreen extends ConsumerWidget {
  const PiecesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final piecesAsync = ref.watch(piecesProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F4F0),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: const Color(0xFFF7F4F0),
            surfaceTintColor: Colors.transparent,
            floating: true,
            titleSpacing: 20,
            title: Row(
              children: [
                Text(
                  'Pottery Diary',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF5C4A3A),
                      ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  child: const Text('Edit'),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'COLLECTION',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.grey.shade500,
                          letterSpacing: 1.2,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Handcrafted\nPieces',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF2C2218),
                          height: 1.1,
                        ),
                  ),
                ],
              ),
            ),
          ),
          piecesAsync.when(
            data: (pieces) {
              if (pieces.isEmpty) {
                return const SliverFillRemaining(child: _EmptyState());
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, i) => PieceCard(piece: pieces[i]),
                  childCount: pieces.length,
                ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute<void>(builder: (_) => const CreatePieceScreen()),
        ),
        backgroundColor: const Color(0xFFCC4A2A),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: const _BottomNav(selectedIndex: 0),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.selectedIndex});

  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      backgroundColor: Colors.white,
      selectedItemColor: const Color(0xFF5C4A3A),
      unselectedItemColor: Colors.grey.shade400,
      selectedLabelStyle: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w600,
      ),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.grid_view_rounded),
          label: 'MY PIECES',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'SEARCH',
        ),
      ],
    );
  }
}

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
