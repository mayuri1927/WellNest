import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/firebase_constants.dart';
import '../../core/errors/exceptions.dart';
import '../models/workout_model.dart';
import '../models/meal_model.dart';
import '../models/medicine_model.dart';
import '../models/appointment_model.dart';
import '../models/document_model.dart';
import '../models/family_member_model.dart';

abstract class FirestoreDataSource {
  Future<void> addDocument(String collection, Map<String, dynamic> data);
  Future<void> updateDocument(String collection, String docId, Map<String, dynamic> data);
  Future<void> deleteDocument(String collection, String docId);
  Future<Map<String, dynamic>?> getDocument(String collection, String docId);
  Future<List<Map<String, dynamic>>> getDocuments(String collection, {Map<String, dynamic>? filters});
  Stream<List<Map<String, dynamic>>> streamDocuments(String collection, {Map<String, dynamic>? filters});
}

class FirestoreDataSourceImpl implements FirestoreDataSource {
  final FirebaseFirestore _firestore;

  FirestoreDataSourceImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> addDocument(String collection, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collection).add(data);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> updateDocument(String collection, String docId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collection).doc(docId).update(data);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> deleteDocument(String collection, String docId) async {
    try {
      await _firestore.collection(collection).doc(docId).delete();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>?> getDocument(String collection, String docId) async {
    try {
      final doc = await _firestore.collection(collection).doc(docId).get();
      if (!doc.exists) return null;
      return doc.data();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getDocuments(String collection, {Map<String, dynamic>? filters}) async {
    try {
      Query query = _firestore.collection(collection);
      if (filters != null) {
        filters.forEach((key, value) {
          query = query.where(key, isEqualTo: value);
        });
      }
      final snapshot = await query.get();
      return snapshot.docs.map((doc) {
        final docData = doc.data();
        final Map<String, dynamic> data = docData is Map<String, dynamic> 
            ? Map<String, dynamic>.from(docData)
            : <String, dynamic>{};
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Stream<List<Map<String, dynamic>>> streamDocuments(String collection, {Map<String, dynamic>? filters}) {
    Query query = _firestore.collection(collection);
    if (filters != null) {
      filters.forEach((key, value) {
        query = query.where(key, isEqualTo: value);
      });
    }
    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final docData = doc.data();
        final Map<String, dynamic> data = docData is Map<String, dynamic> 
            ? Map<String, dynamic>.from(docData)
            : <String, dynamic>{};
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }
}

class WorkoutDataSource {
  final FirestoreDataSource _firestoreDataSource;

  WorkoutDataSource({required FirestoreDataSource firestoreDataSource})
      : _firestoreDataSource = firestoreDataSource;

  Future<void> addWorkout(WorkoutModel workout) async {
    await _firestoreDataSource.addDocument(
      FirebaseConstants.workoutsCollection,
      workout.toFirestore(),
    );
  }

  Future<void> updateWorkout(String id, WorkoutModel workout) async {
    await _firestoreDataSource.updateDocument(
      FirebaseConstants.workoutsCollection,
      id,
      workout.toFirestore(),
    );
  }

  Future<void> deleteWorkout(String id) async {
    await _firestoreDataSource.deleteDocument(
      FirebaseConstants.workoutsCollection,
      id,
    );
  }

  Future<List<WorkoutModel>> getWorkouts(String userId) async {
    final docs = await _firestoreDataSource.getDocuments(
      FirebaseConstants.workoutsCollection,
      filters: {'userId': userId},
    );
    return docs.map((doc) => _documentToWorkout(doc)).toList();
  }

  Stream<List<WorkoutModel>> streamWorkouts(String userId) {
    return _firestoreDataSource.streamDocuments(
      FirebaseConstants.workoutsCollection,
      filters: {'userId': userId},
    ).map((docs) => docs.map((doc) => _documentToWorkout(doc)).toList());
  }

  WorkoutModel _documentToWorkout(Map<String, dynamic> doc) {
    return WorkoutModel(
      id: doc['id'] ?? '',
      userId: doc['userId'] ?? '',
      title: doc['title'] ?? '',
      type: doc['type'] ?? '',
      durationMinutes: doc['durationMinutes'] ?? 0,
      caloriesBurned: doc['caloriesBurned'] ?? 0,
      date: doc['date'] != null ? DateTime.parse(doc['date']) : DateTime.now(),
      notes: doc['notes'],
      createdAt: doc['createdAt'] != null ? DateTime.parse(doc['createdAt']) : DateTime.now(),
      updatedAt: doc['updatedAt'] != null ? DateTime.parse(doc['updatedAt']) : DateTime.now(),
    );
  }
}

class MealDataSource {
  final FirestoreDataSource _firestoreDataSource;

  MealDataSource({required FirestoreDataSource firestoreDataSource})
      : _firestoreDataSource = firestoreDataSource;

  Future<void> addMeal(MealModel meal) async {
    await _firestoreDataSource.addDocument(
      FirebaseConstants.mealsCollection,
      meal.toFirestore(),
    );
  }

  Future<void> updateMeal(String id, MealModel meal) async {
    await _firestoreDataSource.updateDocument(
      FirebaseConstants.mealsCollection,
      id,
      meal.toFirestore(),
    );
  }

  Future<void> deleteMeal(String id) async {
    await _firestoreDataSource.deleteDocument(
      FirebaseConstants.mealsCollection,
      id,
    );
  }

  Future<List<MealModel>> getMeals(String userId) async {
    final docs = await _firestoreDataSource.getDocuments(
      FirebaseConstants.mealsCollection,
      filters: {'userId': userId},
    );
    return docs.map((doc) => _documentToMeal(doc)).toList();
  }

  Stream<List<MealModel>> streamMeals(String userId) {
    return _firestoreDataSource.streamDocuments(
      FirebaseConstants.mealsCollection,
      filters: {'userId': userId},
    ).map((docs) => docs.map((doc) => _documentToMeal(doc)).toList());
  }

  MealModel _documentToMeal(Map<String, dynamic> doc) {
    return MealModel(
      id: doc['id'] ?? '',
      userId: doc['userId'] ?? '',
      title: doc['title'] ?? '',
      type: doc['type'] ?? '',
      calories: doc['calories'] ?? 0,
      protein: (doc['protein'] ?? 0).toDouble(),
      carbs: (doc['carbs'] ?? 0).toDouble(),
      fat: (doc['fat'] ?? 0).toDouble(),
      dateTime: doc['dateTime'] != null ? DateTime.parse(doc['dateTime']) : DateTime.now(),
      notes: doc['notes'],
      createdAt: doc['createdAt'] != null ? DateTime.parse(doc['createdAt']) : DateTime.now(),
      updatedAt: doc['updatedAt'] != null ? DateTime.parse(doc['updatedAt']) : DateTime.now(),
    );
  }
}

class MedicineDataSource {
  final FirestoreDataSource _firestoreDataSource;

  MedicineDataSource({required FirestoreDataSource firestoreDataSource})
      : _firestoreDataSource = firestoreDataSource;

  Future<void> addMedicine(MedicineModel medicine) async {
    await _firestoreDataSource.addDocument(
      FirebaseConstants.medicinesCollection,
      medicine.toFirestore(),
    );
  }

  Future<void> updateMedicine(String id, MedicineModel medicine) async {
    await _firestoreDataSource.updateDocument(
      FirebaseConstants.medicinesCollection,
      id,
      medicine.toFirestore(),
    );
  }

  Future<void> deleteMedicine(String id) async {
    await _firestoreDataSource.deleteDocument(
      FirebaseConstants.medicinesCollection,
      id,
    );
  }

  Future<List<MedicineModel>> getMedicines(String userId) async {
    final docs = await _firestoreDataSource.getDocuments(
      FirebaseConstants.medicinesCollection,
      filters: {'userId': userId},
    );
    return docs.map((doc) => _documentToMedicine(doc)).toList();
  }

  Stream<List<MedicineModel>> streamMedicines(String userId) {
    return _firestoreDataSource.streamDocuments(
      FirebaseConstants.medicinesCollection,
      filters: {'userId': userId},
    ).map((docs) => docs.map((doc) => _documentToMedicine(doc)).toList());
  }

  MedicineModel _documentToMedicine(Map<String, dynamic> doc) {
    return MedicineModel(
      id: doc['id'] ?? '',
      userId: doc['userId'] ?? '',
      name: doc['name'] ?? '',
      dosage: doc['dosage'] ?? '',
      unit: doc['unit'] ?? '',
      frequency: doc['frequency'] ?? '',
      timeSlots: List<String>.from(doc['timeSlots'] ?? []),
      startDate: doc['startDate'] != null ? DateTime.parse(doc['startDate']) : DateTime.now(),
      endDate: doc['endDate'] != null ? DateTime.parse(doc['endDate']) : null,
      isActive: doc['isActive'] ?? true,
      notes: doc['notes'],
      createdAt: doc['createdAt'] != null ? DateTime.parse(doc['createdAt']) : DateTime.now(),
      updatedAt: doc['updatedAt'] != null ? DateTime.parse(doc['updatedAt']) : DateTime.now(),
    );
  }
}

class AppointmentDataSource {
  final FirestoreDataSource _firestoreDataSource;

  AppointmentDataSource({required FirestoreDataSource firestoreDataSource})
      : _firestoreDataSource = firestoreDataSource;

  Future<void> addAppointment(AppointmentModel appointment) async {
    await _firestoreDataSource.addDocument(
      FirebaseConstants.appointmentsCollection,
      appointment.toFirestore(),
    );
  }

  Future<void> updateAppointment(String id, AppointmentModel appointment) async {
    await _firestoreDataSource.updateDocument(
      FirebaseConstants.appointmentsCollection,
      id,
      appointment.toFirestore(),
    );
  }

  Future<void> deleteAppointment(String id) async {
    await _firestoreDataSource.deleteDocument(
      FirebaseConstants.appointmentsCollection,
      id,
    );
  }

  Future<List<AppointmentModel>> getAppointments(String userId) async {
    final docs = await _firestoreDataSource.getDocuments(
      FirebaseConstants.appointmentsCollection,
      filters: {'userId': userId},
    );
    return docs.map((doc) => _documentToAppointment(doc)).toList();
  }

  Stream<List<AppointmentModel>> streamAppointments(String userId) {
    return _firestoreDataSource.streamDocuments(
      FirebaseConstants.appointmentsCollection,
      filters: {'userId': userId},
    ).map((docs) => docs.map((doc) => _documentToAppointment(doc)).toList());
  }

  AppointmentModel _documentToAppointment(Map<String, dynamic> doc) {
    return AppointmentModel(
      id: doc['id'] ?? '',
      userId: doc['userId'] ?? '',
      doctorName: doc['doctorName'] ?? '',
      specialty: doc['specialty'] ?? '',
      clinicName: doc['clinicName'],
      address: doc['address'],
      dateTime: doc['dateTime'] != null ? DateTime.parse(doc['dateTime']) : DateTime.now(),
      durationMinutes: doc['durationMinutes'] ?? 30,
      notes: doc['notes'],
      isCompleted: doc['isCompleted'] ?? false,
      reminderSet: doc['reminderSet'] ?? true,
      createdAt: doc['createdAt'] != null ? DateTime.parse(doc['createdAt']) : DateTime.now(),
      updatedAt: doc['updatedAt'] != null ? DateTime.parse(doc['updatedAt']) : DateTime.now(),
    );
  }
}

class DocumentDataSource {
  final FirestoreDataSource _firestoreDataSource;

  DocumentDataSource({required FirestoreDataSource firestoreDataSource})
      : _firestoreDataSource = firestoreDataSource;

  Future<void> addDocument(DocumentModel document) async {
    await _firestoreDataSource.addDocument(
      FirebaseConstants.documentsCollection,
      document.toFirestore(),
    );
  }

  Future<void> updateDocument(String id, DocumentModel document) async {
    await _firestoreDataSource.updateDocument(
      FirebaseConstants.documentsCollection,
      id,
      document.toFirestore(),
    );
  }

  Future<void> deleteDocument(String id) async {
    await _firestoreDataSource.deleteDocument(
      FirebaseConstants.documentsCollection,
      id,
    );
  }

  Future<List<DocumentModel>> getDocuments(String userId) async {
    final docs = await _firestoreDataSource.getDocuments(
      FirebaseConstants.documentsCollection,
      filters: {'userId': userId},
    );
    return docs.map((doc) => _documentToDoc(doc)).toList();
  }

  Stream<List<DocumentModel>> streamDocuments(String userId) {
    return _firestoreDataSource.streamDocuments(
      FirebaseConstants.documentsCollection,
      filters: {'userId': userId},
    ).map((docs) => docs.map((doc) => _documentToDoc(doc)).toList());
  }

  DocumentModel _documentToDoc(Map<String, dynamic> doc) {
    return DocumentModel(
      id: doc['id'] ?? '',
      userId: doc['userId'] ?? '',
      title: doc['title'] ?? '',
      type: doc['type'] ?? '',
      fileUrl: doc['fileUrl'] ?? '',
      fileName: doc['fileName'],
      fileSize: doc['fileSize'],
      mimeType: doc['mimeType'],
      expiryDate: doc['expiryDate'] != null ? DateTime.parse(doc['expiryDate']) : null,
      notes: doc['notes'],
      createdAt: doc['createdAt'] != null ? DateTime.parse(doc['createdAt']) : DateTime.now(),
      updatedAt: doc['updatedAt'] != null ? DateTime.parse(doc['updatedAt']) : DateTime.now(),
    );
  }
}

class FamilyMemberDataSource {
  final FirestoreDataSource _firestoreDataSource;

  FamilyMemberDataSource({required FirestoreDataSource firestoreDataSource})
      : _firestoreDataSource = firestoreDataSource;

  Future<void> addFamilyMember(FamilyMemberModel member) async {
    await _firestoreDataSource.addDocument(
      FirebaseConstants.familyMembersCollection,
      member.toFirestore(),
    );
  }

  Future<void> updateFamilyMember(String id, FamilyMemberModel member) async {
    await _firestoreDataSource.updateDocument(
      FirebaseConstants.familyMembersCollection,
      id,
      member.toFirestore(),
    );
  }

  Future<void> deleteFamilyMember(String id) async {
    await _firestoreDataSource.deleteDocument(
      FirebaseConstants.familyMembersCollection,
      id,
    );
  }

  Future<List<FamilyMemberModel>> getFamilyMembers(String userId) async {
    final docs = await _firestoreDataSource.getDocuments(
      FirebaseConstants.familyMembersCollection,
      filters: {'userId': userId},
    );
    return docs.map((doc) => _documentToFamilyMember(doc)).toList();
  }

  Stream<List<FamilyMemberModel>> streamFamilyMembers(String userId) {
    return _firestoreDataSource.streamDocuments(
      FirebaseConstants.familyMembersCollection,
      filters: {'userId': userId},
    ).map((docs) => docs.map((doc) => _documentToFamilyMember(doc)).toList());
  }

  FamilyMemberModel _documentToFamilyMember(Map<String, dynamic> doc) {
    return FamilyMemberModel(
      id: doc['id'] ?? '',
      userId: doc['userId'] ?? '',
      name: doc['name'] ?? '',
      relationship: doc['relationship'] ?? '',
      dateOfBirth: doc['dateOfBirth'] != null ? DateTime.parse(doc['dateOfBirth']) : null,
      bloodType: doc['bloodType'],
      allergies: doc['allergies'],
      medicalConditions: doc['medicalConditions'],
      emergencyContact: doc['emergencyContact'],
      notes: doc['notes'],
      createdAt: doc['createdAt'] != null ? DateTime.parse(doc['createdAt']) : DateTime.now(),
      updatedAt: doc['updatedAt'] != null ? DateTime.parse(doc['updatedAt']) : DateTime.now(),
    );
  }
}
