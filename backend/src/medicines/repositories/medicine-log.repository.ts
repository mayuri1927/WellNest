import { MedicineLog } from '../entities/medicine-log.entity';

export class MedicineLogRepository {
  private logs: Map<string, MedicineLog> = new Map();

  async create(log: MedicineLog): Promise<MedicineLog> {
    this.logs.set(log.id, log);
    return log;
  }

  async findById(id: string): Promise<MedicineLog | null> {
    return this.logs.get(id) || null;
  }

  async findByMedicineId(medicineId: string): Promise<MedicineLog[]> {
    return Array.from(this.logs.values())
      .filter((log) => log.medicineId === medicineId)
      .sort((a, b) => new Date(b.takenTime).getTime() - new Date(a.takenTime).getTime());
  }

  async delete(id: string): Promise<void> {
    this.logs.delete(id);
  }
}
