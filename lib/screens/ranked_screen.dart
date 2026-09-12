import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:steady_just_study/models/nets_state.dart';
import 'package:steady_just_study/providers/nets_provider.dart';
import 'package:steady_just_study/services/firebase_service.dart';
import 'package:steady_just_study/widgets/nets_widget.dart';

class RankedScreen extends ConsumerStatefulWidget {
  static String routeName = "/ranked";
  const RankedScreen({super.key});

  @override
  ConsumerState<RankedScreen> createState() => _RankedScreenState();
}

class _RankedScreenState extends ConsumerState<RankedScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  late Future<_LeaderboardData> _leaderboardFuture;

  @override
  void initState() {
    super.initState();
    _leaderboardFuture = _loadLeaderboard();
  }

  Future<_LeaderboardData> _loadLeaderboard() async {
    final topUsers = await _firebaseService.getAllUsers(limit: 5);
    final totalUsers = await _firebaseService.getTotalRankedUsers();
    final currentUser = await _firebaseService.getCurrentUserData();

    int currentUserRank = 0;
    if (currentUser != null) {
      currentUserRank = await _firebaseService.getUserRank(
        currentUser['points'] as int,
      );
    }

    return _LeaderboardData(
      topUsers: topUsers,
      totalUsers: totalUsers,
      currentUser: currentUser,
      currentUserRank: currentUserRank,
    );
  }

  Future<void> _refresh() async {
    final data = await _loadLeaderboard();
    if (!mounted) return;
    setState(() {
      _leaderboardFuture = Future.value(data);
    });
  }

  // Matches the wireframe: cyan / gold / orange for #1-#3, grey after that.
  Color _rankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.cyan.shade300;
      case 2:
        return Colors.amber.shade300;
      case 3:
        return Colors.orange.shade300;
      default:
        return Colors.grey.shade300;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Once NetsController reports the payment flow finished, reload the
    // leaderboard so we pick up the freshly-written `paid: true` flag.
    ref.listen<NetsState>(netsProvider, (previous, next) {
      if (previous?.status != "complete" && next.status == "complete") {
        _refresh();
      }
    });

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: FutureBuilder<_LeaderboardData>(
          future: _leaderboardFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('Could not load leaderboard: ${snapshot.error}'),
              );
            }

            final data = snapshot.data!;
            final isPaid = data.currentUser?['paid'] == true;

            if (!isPaid) {
              return NETSWidget();
            }

            return RefreshIndicator(
              onRefresh: _refresh,
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  const Text(
                    'Ranked Study',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      'Friendly competition for students who are aiming '
                      'to be the absolute best',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Leaderboard #Top 5',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: data.topUsers.isEmpty
                        ? const Center(child: Text('No ranked users yet'))
                        : ListView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                            itemCount: data.topUsers.length,
                            itemBuilder: (context, index) {
                              final user = data.topUsers[index];
                              final rank = index + 1;
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(color: Colors.grey.shade300),
                                ),
                                elevation: 0,
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: _rankColor(rank),
                                    child: const Icon(
                                      Icons.emoji_events,
                                      color: Colors.white,
                                    ),
                                  ),
                                  title: Text(
                                    user['username'] as String,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Trophy Points: ${user['points']}',
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  if (data.currentUser != null)
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '#${data.currentUserRank} '
                            '${data.currentUser!['username']}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text('Points : ${data.currentUser!['points']}'),
                          const SizedBox(height: 4),
                          Text(
                            'Your place out of ${data.totalUsers} users',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _LeaderboardData {
  final List<Map<String, dynamic>> topUsers;
  final int totalUsers;
  final Map<String, dynamic>? currentUser;
  final int currentUserRank;

  _LeaderboardData({
    required this.topUsers,
    required this.totalUsers,
    required this.currentUser,
    required this.currentUserRank,
  });
}
