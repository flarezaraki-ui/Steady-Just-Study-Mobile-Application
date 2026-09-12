import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import 'package:steady_just_study/models/tasks.dart';
import 'package:steady_just_study/providers/firebase_provider.dart'
    show taskProvider;

class AssessmentKey {
  final String module;
  final String projectName;
  final DateTime dueDate;
  const AssessmentKey(this.module, this.projectName, this.dueDate);

  @override
  bool operator ==(Object other) =>
      other is AssessmentKey &&
      other.module == module &&
      other.projectName == projectName &&
      other.dueDate == dueDate;

  @override
  int get hashCode => Object.hash(module, projectName, dueDate);
}

class FirebaseService {
  Future<void> _saveUserToFirestore(UserCredential credential) async {
    final user = getCurrentUser();
    if (user == null) {
      return;
    }
    final userDocRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid);

    await userDocRef.set({
      'username': user.displayName ?? user.email?.split('@').first ?? 'User',
      'email': user.email ?? '',
    }, SetOptions(merge: true));
  }

  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn(
      clientId:
          '210571538877-sjhgph51t8q6qsi9ea8sour3obc62d2j.apps.googleusercontent.com',
    ).signIn();

    if (googleUser == null) return null;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await FirebaseAuth.instance.signInWithCredential(
      credential,
    );
    await _saveUserToFirestore(userCredential);
    return userCredential;
  }

  Future<UserCredential?> signInWithMicrosoft() async {
    try {
      final provider = OAuthProvider('microsoft.com');
      UserCredential userCredential;

      if (kIsWeb) {
        userCredential = await FirebaseAuth.instance.signInWithPopup(provider);
      } else {
        userCredential = await FirebaseAuth.instance.signInWithProvider(
          provider,
        );
      }
      await _saveUserToFirestore(userCredential);

      return userCredential;
    } catch (e) {
      print("Microsoft Sign-In Error: $e");
      return null;
    }
  }

  Future<void> register(String Username, String email, String password) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user!.uid)
        .set({'username': Username, 'email': email});
  }

  Future<UserCredential> login(String Username, String password) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: Username)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        throw Exception("Username not found.");
      }
      var user = getCurrentUser();

      if (user != null && !user.emailVerified) {
        throw Exception("Email not verified");
      } else {
        String email = snapshot.docs.first.data()['email'];

        return await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      }
    } on FirebaseAuthException catch (e) {
      rethrow;
    }
  }

  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  Future<void> logOut() {
    return FirebaseAuth.instance.signOut();
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    final user = getCurrentUser();

    if (user != null && user.email != null) {
      final email = user.email!;
      final credential = EmailAuthProvider.credential(
        email: email,
        password: oldPassword,
      );

      try {
        await user.reauthenticateWithCredential(credential);
        await user.updatePassword(newPassword);
      } on FirebaseAuthException catch (e) {
        throw Exception("Error changing password: ${e.message}");
      }
    } else {
      throw Exception("No user is currently signed in.");
    }
  }

  Future<void> sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
    } catch (error) {
      print("Error $error");
    }
  }

  Future<void> forgotPassword(String email) async {
    return FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  Future<void> addTask(
    String name,
    DateTime dueDate,
    String module,
    String projectName,
    double progress,
    bool reminderOn,
  ) {
    return FirebaseFirestore.instance.collection('tasks').add({
      'name': name,
      'dueDate': dueDate,
      'module': module,
      'projectName': projectName,
      'progress': progress,
      'reminderOn': reminderOn,
      'email': getCurrentUser()?.email,
    });
  }

  Future<void> updateTask(
    String id,
    String name,
    DateTime dueDate,
    String module,
    String projectName,
    double progress,
    bool reminderOn,
  ) {
    return FirebaseFirestore.instance.collection('tasks').doc(id).update({
      'name': name,
      'dueDate': dueDate,
      'module': module,
      'projectName': projectName,
      'progress': progress,
      'reminderOn': reminderOn,
    });
  }

  Future<void> deleteTask(String id) {
    return FirebaseFirestore.instance.collection('tasks').doc(id).delete();
  }

  Future<void> _logPointsEarned(int points) async {
    final user = getCurrentUser();
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('pointsLog')
        .add({'points': points, 'timestamp': FieldValue.serverTimestamp()});
  }

  Future<void> addPoints(int points) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(getCurrentUser()?.uid)
        .update({"points": points});
    await _logPointsEarned(points);
  }

  Future<void> incrementPoints(int points) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(getCurrentUser()?.uid)
        .update({"points": FieldValue.increment(points)});
    await _logPointsEarned(points);
  }

  Future<void> completeTask(String id) {
    return FirebaseFirestore.instance.collection("tasks").doc(id).update({
      "completion_status": true,
    });
  }

  //to check if users have points if not created a new field
  Future<void> checkPoints(int points, String id) async {
    final authUser = getCurrentUser();

    if (authUser == null) return;

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(authUser.uid)
        .get();

    final data = userDoc.data();
    if (data != null && data.containsKey("points")) {
      incrementPoints(points);
      completeTask(id);
    } else {
      addPoints(points);
      completeTask(id);
    }
  }

  Future<void> getDueDates() {
    return FirebaseFirestore.instance
        .collection("users")
        .where(
          "dueDate",
          isEqualTo: DateTime.now().add(const Duration(days: 7)),
        )
        .get();
  }

  Future<void> checkReminders() {
    return FirebaseFirestore.instance
        .collection("users")
        .where("reminderOn", isEqualTo: true)
        .where(
          "dueDate",
          isLessThanOrEqualTo: DateTime.now().add(const Duration(days: 7)),
        )
        .where("dueDate", isGreaterThanOrEqualTo: DateTime.now())
        .get();
  }

  Future displayRank() {
    return FirebaseFirestore.instance
        .collection("users")
        .where("points", isNotEqualTo: null)
        .where("points", isGreaterThan: 0)
        .count()
        .get();
  }

  /// Returns the top-ranked users (highest points first) as plain maps.
  Future<List<Map<String, dynamic>>> getAllUsers({int? limit = 5}) async {
    Query<Map<String, dynamic>> query = FirebaseFirestore.instance
        .collection("users")
        .where("points", isNotEqualTo: null)
        .where("points", isGreaterThan: 0)
        .orderBy("points", descending: true);

    if (limit != null) {
      query = query.limit(limit);
    }

    final snapshot = await query.get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'uid': doc.id,
        'username': data['username'] ?? 'User',
        'points': data['points'] ?? 0,
      };
    }).toList();
  }

  // Total number of users who have a ranked score (points > 0).
  Future<int> getTotalRankedUsers() async {
    final snapshot = await FirebaseFirestore.instance
        .collection("users")
        .where("points", isGreaterThan: 0)
        .count()
        .get();
    return snapshot.count ?? 0;
  }

  // Rank (1-based) for a user with the given points — counts how many users have strictly more points, then adds 1.
  Future<int> getUserRank(int points) async {
    final snapshot = await FirebaseFirestore.instance
        .collection("users")
        .where("points", isGreaterThan: points)
        .count()
        .get();
    return (snapshot.count ?? 0) + 1;
  }

  // The currently signed-in user's own username + points, for the "your place" card on the leaderboard.
  Future<Map<String, dynamic>?> getCurrentUserData() async {
    final user = getCurrentUser();
    if (user == null) return null;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!doc.exists) return null;

    final data = doc.data()!;
    return {
      'uid': doc.id,
      'username': data['username'] ?? 'User',
      'points': data['points'] ?? 0,
      'paid': data['paid'] ?? false,
    };
  }

  //for the chart feature to help display the points earned by the user in a week
  Future<Map<DateTime, int>> getWeeklyPoints() async {
    final user = getCurrentUser();
    if (user == null) return {};

    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);
    final startDate = startOfToday.subtract(const Duration(days: 6));

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('pointsLog')
        .where(
          'timestamp',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
        )
        .get();

    final Map<DateTime, int> dailyTotals = {
      for (int i = 0; i < 7; i++) startDate.add(Duration(days: i)): 0,
    };

    for (final doc in snapshot.docs) {
      final data = doc.data();
      final ts = data['timestamp'];
      if (ts is! Timestamp) continue;
      final day = DateTime(
        ts.toDate().year,
        ts.toDate().month,
        ts.toDate().day,
      );
      final points = (data['points'] as num?)?.toInt() ?? 0;
      if (dailyTotals.containsKey(day)) {
        dailyTotals[day] = (dailyTotals[day] ?? 0) + points;
      }
    }

    return dailyTotals;
  }

  //to apply the paid status to the user
  Future<void> markUserAsPaid() async {
    final user = getCurrentUser();
    if (user == null) return;

    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'paid': true,
    }, SetOptions(merge: true));
  }
}
