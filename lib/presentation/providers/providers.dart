import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/datasources/auth_datasource.dart';
import '../../data/datasources/firestore_datasource.dart';
import '../../data/datasources/storage_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/workout_repository_impl.dart';
import '../../data/repositories/meal_repository_impl.dart';
import '../../data/repositories/medicine_repository_impl.dart';
import '../../data/repositories/appointment_repository_impl.dart';
import '../../data/repositories/document_repository_impl.dart';
import '../../data/repositories/family_member_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/workout_repository.dart';
import '../../domain/repositories/meal_repository.dart';
import '../../domain/repositories/medicine_repository.dart';
import '../../domain/repositories/appointment_repository.dart';
import '../../domain/repositories/document_repository.dart';
import '../../domain/repositories/family_member_repository.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final authDataSourceProvider = Provider<AuthDataSource>((ref) {
  return AuthDataSourceImpl(firebaseAuth: ref.read(firebaseAuthProvider));
});

final firestoreDataSourceProvider = Provider<FirestoreDataSource>((ref) {
  return FirestoreDataSourceImpl();
});

final storageDataSourceProvider = Provider<StorageDataSource>((ref) {
  return StorageDataSourceImpl();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(authDataSource: ref.read(authDataSourceProvider));
});

final workoutDataSourceProvider = Provider<WorkoutDataSource>((ref) {
  return WorkoutDataSource(firestoreDataSource: ref.read(firestoreDataSourceProvider));
});

final mealDataSourceProvider = Provider<MealDataSource>((ref) {
  return MealDataSource(firestoreDataSource: ref.read(firestoreDataSourceProvider));
});

final medicineDataSourceProvider = Provider<MedicineDataSource>((ref) {
  return MedicineDataSource(firestoreDataSource: ref.read(firestoreDataSourceProvider));
});

final appointmentDataSourceProvider = Provider<AppointmentDataSource>((ref) {
  return AppointmentDataSource(firestoreDataSource: ref.read(firestoreDataSourceProvider));
});

final documentDataSourceProvider = Provider<DocumentDataSource>((ref) {
  return DocumentDataSource(firestoreDataSource: ref.read(firestoreDataSourceProvider));
});

final familyMemberDataSourceProvider = Provider<FamilyMemberDataSource>((ref) {
  return FamilyMemberDataSource(firestoreDataSource: ref.read(firestoreDataSourceProvider));
});

final workoutRepositoryProvider = Provider<WorkoutRepository>((ref) {
  return WorkoutRepositoryImpl(workoutDataSource: ref.read(workoutDataSourceProvider));
});

final mealRepositoryProvider = Provider<MealRepository>((ref) {
  return MealRepositoryImpl(mealDataSource: ref.read(mealDataSourceProvider));
});

final medicineRepositoryProvider = Provider<MedicineRepository>((ref) {
  return MedicineRepositoryImpl(medicineDataSource: ref.read(medicineDataSourceProvider));
});

final appointmentRepositoryProvider = Provider<AppointmentRepository>((ref) {
  return AppointmentRepositoryImpl(appointmentDataSource: ref.read(appointmentDataSourceProvider));
});

final documentRepositoryProvider = Provider<DocumentRepository>((ref) {
  return DocumentRepositoryImpl(
    documentDataSource: ref.read(documentDataSourceProvider),
    storageDataSource: ref.read(storageDataSourceProvider),
  );
});

final familyMemberRepositoryProvider = Provider<FamilyMemberRepository>((ref) {
  return FamilyMemberRepositoryImpl(familyMemberDataSource: ref.read(familyMemberDataSourceProvider));
});
