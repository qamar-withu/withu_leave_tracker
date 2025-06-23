import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:withu_leave_tracker/infrastructure/auth/dto/user_dto.dart';

@injectable
class UserService {
  final FirebaseFirestore _firestore;

  UserService(this._firestore);

  Future<Map<String, String>> getUserNamesMap(List<String> userIds) async {
    if (userIds.isEmpty) return {};

    final userNamesMap = <String, String>{};

    try {
      // Get users in batches of 10 (Firestore 'whereIn' limit)
      for (int i = 0; i < userIds.length; i += 10) {
        final batch = userIds.skip(i).take(10).toList();

        final querySnapshot = await _firestore
            .collection('users')
            .where(FieldPath.documentId, whereIn: batch)
            .get();

        for (var doc in querySnapshot.docs) {
          if (doc.exists) {
            final data = doc.data();
            final firstName = data['firstName'] as String? ?? '';
            final lastName = data['lastName'] as String? ?? '';
            userNamesMap[doc.id] = '$firstName $lastName'.trim();
          }
        }
      }
    } catch (e) {
      // Return empty map on error
      return {};
    }

    return userNamesMap;
  }

  Future<String> getUserName(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();

      if (doc.exists) {
        final data = doc.data()!;
        final firstName = data['firstName'] as String? ?? '';
        final lastName = data['lastName'] as String? ?? '';
        return '$firstName $lastName'.trim();
      }
    } catch (e) {
      // Return userId as fallback
    }

    return 'User $userId';
  }
}
