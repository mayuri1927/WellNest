import { Medicine } from '../entities/medicine.entity';

export class MedicineRepository {
  private medicines: Map<string, Medicine> = new Map();
  private userIndex: Map<string, string[]> = new Map();

  async create(medicine: Medicine): Promise<Medicine> {
    this.medicines.set(medicine.id, medicine);
    const userMedicines = this.userIndex.get(medicine.userId) || [];
    userMedicines.push(medicine.id);
    this.userIndex.set(medicine.userId, userMedicines);
    return medicine;
  }

  async findById(id: string): Promise<Medicine | null> {
    return this.medicines.get(id) || null;
  }

  async findByUserId(userId: string): Promise<Medicine[]> {
    const medicineIds = this.userIndex.get(userId) || [];
    return medicineIds
      .map((id) => this.medicines.get(id))
      .filter((m): m is Medicine => m !== undefined)
      .sort((a, b) => new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime());
  }

  async update(id: string, data: Partial<Medicine>): Promise<Medicine> {
    const medicine = this.medicines.get(id);
    if (!medicine) throw new Error('Medicine not found');
    const updated = { ...medicine, ...data };
    this.medicines.set(id, updated);
    return updated;
  }

  async delete(id: string): Promise<void> {
    const medicine = this.medicines.get(id);
    if (medicine) {
      const userMedicines = this.userIndex.get(medicine.userId) || [];
      this.userIndex.set(
        medicine.userId,
        userMedicines.filter((mid) => mid !== id),
      );
    }
    this.medicines.delete(id);
  }
}
