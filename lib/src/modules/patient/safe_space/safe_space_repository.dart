import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'safe_space_model.dart';
import 'safe_space_post_model.dart';

class SafeSpaceRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addSafeSpace(SafeSpaceModel safeSpace) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception("User is not logged in");
      }

      DocumentReference safeSpaceRef =
          await _firestore.collection('safe_space').add({
        'spaceName': safeSpace.safeSpaceName,
        'description': safeSpace.description,
        'creatorId': user.uid,
        'timestamp': safeSpace.createdTime,
        'safeSpaceImage': safeSpace.safeSpaceImage,
      });

      String safeSpaceId = safeSpaceRef.id;

      await _firestore.collection('safe_space').doc(safeSpaceId).update({
        'safeSpaceId': safeSpaceId,
      });

      await _firestore
          .collection('safe_space')
          .doc(safeSpaceId)
          .collection('safe_space_member')
          .add({
        'memberId': user.uid,
      });

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('enrolled_safe_space')
          .doc(safeSpaceId)
          .set({
        'safeSpaceId': safeSpaceId,
        'spaceName': safeSpace.safeSpaceName,
        'description': safeSpace.description,
        'creatorId': user.uid,
        'timestamp': safeSpace.createdTime,
        'safeSpaceImage': safeSpace.safeSpaceImage,
      });
    } catch (e) {
      print(e);
    }
  }

  Stream<List<SafeSpaceModel>> getSafeSpaces() {
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception("User is not logged in");
    }
    // print('getting safe space list');
    return _firestore.collection('safe_space').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => SafeSpaceModel.fromDocument(doc))
          .toList();
    });
  }

  Stream<List<SafeSpaceModel>> getEnrolledSafeSpaces() {
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception("User is not logged in");
    }
    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('enrolled_safe_space')
        .snapshots()
        .asyncMap((snapshot) async {
      // Fetch document IDs from enrolled_safe_space
      List<String> enrolledSafeSpaceIds =
          snapshot.docs.map((doc) => doc.id).toList();
      // Fetch each SafeSpaceModel by ID from safe_space collection
      List<SafeSpaceModel> safeSpaces = [];
      for (String id in enrolledSafeSpaceIds) {
        var docSnapshot =
            await _firestore.collection('safe_space').doc(id).get();
        if (docSnapshot.exists) {
          // Check if the document exists
          SafeSpaceModel safeSpace = SafeSpaceModel.fromDocument(docSnapshot);
          safeSpaces.add(safeSpace);
        } else {
          // Handle the case where the document does not exist
          print(
              "Document with ID $id does not exist in 'safe_space' collection.");
        }
      }
      return safeSpaces;
    });
  }

  Future<void> addSharing(safeSpaceId, sharing) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception("User is not logged in");
      }
      DocumentReference postRef = await _firestore
          .collection('safe_space')
          .doc(safeSpaceId)
          .collection('safespace_post')
          .add({
        'content': sharing,
        'userId': user.uid,
        'timestamp': DateTime.now(),
      });
      String postId = postRef.id;

      await _firestore
          .collection('safe_space')
          .doc(safeSpaceId)
          .collection('safespace_post')
          .doc(postId)
          .update({
        'postId': postId,
      });
    } catch (e) {
      print(e);
    }
  }

  Stream<List<SafeSpacePostModel>> getSafeSpacePosts(String safeSpaceId) {
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception("User is not logged in");
    }
    // print('getting safe space post list');
    return _firestore
        .collection('safe_space')
        .doc(safeSpaceId)
        .collection('safespace_post')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => SafeSpacePostModel.fromDocument(doc))
          .toList();
    });
  }

  Future<void> joinSafeSpace(safeSpaceId) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception("User is not logged in");
      }
      await _firestore
          .collection('safe_space')
          .doc(safeSpaceId)
          .collection('safe_space_member')
          .add({
        'memberId': user.uid,
      });

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('enrolled_safe_space')
          .doc(safeSpaceId)
          .set({
        'safeSpaceId': safeSpaceId,
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> leaveSafeSpace(safeSpace) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception("User is not logged in");
      }

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('enrolled_safe_space')
          .doc(safeSpace)
          .delete();
    } catch (e) {
      print(e);
    }
  }
}
