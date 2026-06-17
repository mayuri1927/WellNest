import { Injectable, NotFoundException } from '@nestjs/common';
import { v4 as uuidv4 } from 'uuid';
import { Medicine, MedicineStatus } from './entities/medicine.entity';
import { MedicineLog, LogStatus } from './entities/medicine-log.entity';
import { MedicineRepository } from './repositories/medicine.repository';
import { MedicineLogRepository } from './repositories/medicine-log.repository';
import { CreateMedicineDto } from './dto/create-medicine.dto';
import { UpdateMedicineDto } from './dto/update-medicine.dto';

@Injectable()
export class MedicinesService {
  constructor(
    private medicineRepository: MedicineRepository,
    private medicineLogRepository: MedicineLogRepository,
  ) {}

  async create(userId: string, createMedicineDto: CreateMedicineDto): Promise<Medicine> {
    const medicine: Medicine = {
      id: uuidv4(),
      userId,
      familyMemberId: createMedicineDto.familyMemberId,
      medicineName: createMedicineDto.medicineName,
      dosage: createMedicineDto.dosage,
      unit: createMedicineDto.unit,
      frequency: createMedicineDto.frequency,
      startDate: new Date(createMedicineDto.startDate),
      endDate: createMedicineDto.endDate ? new Date(createMedicineDto.endDate) : undefined,
      times: createMedicineDto.times || [],
      instructions: createMedicineDto.instructions,
      status: MedicineStatus.ACTIVE,
      createdAt: new Date(),
      updatedAt: new Date(),
    };

    return this.medicineRepository.create(medicine);
  }

  async findAll(userId: string): Promise<Medicine[]> {
    return this.medicineRepository.findByUserId(userId);
  }

  async findOne(userId: string, medicineId: string): Promise<Medicine> {
    const medicine = await this.medicineRepository.findById(medicineId);
    if (!medicine || medicine.userId !== userId) {
      throw new NotFoundException('Medicine not found');
    }
    return medicine;
  }

  async update(
    userId: string,
    medicineId: string,
    updateMedicineDto: UpdateMedicineDto,
  ): Promise<Medicine> {
    await this.findOne(userId, medicineId);
    const { startDate, endDate, ...rest } = updateMedicineDto;
    const updateData: Partial<Medicine> = { ...rest };
    if (startDate) {
      updateData.startDate = new Date(startDate);
    }
    if (endDate) {
      updateData.endDate = new Date(endDate);
    }
    return this.medicineRepository.update(medicineId, {
      ...updateData,
      updatedAt: new Date(),
    });
  }

  async remove(userId: string, medicineId: string): Promise<void> {
    await this.findOne(userId, medicineId);
    await this.medicineRepository.delete(medicineId);
  }

  async markAsTaken(
    userId: string,
    medicineId: string,
    logStatus: LogStatus,
  ): Promise<MedicineLog> {
    await this.findOne(userId, medicineId);

    const log: MedicineLog = {
      id: uuidv4(),
      medicineId,
      status: logStatus,
      takenTime: new Date(),
      createdAt: new Date(),
    };

    return this.medicineLogRepository.create(log);
  }

  async getMedicineLogs(
    userId: string,
    medicineId: string,
  ): Promise<MedicineLog[]> {
    await this.findOne(userId, medicineId);
    return this.medicineLogRepository.findByMedicineId(medicineId);
  }

  async getAdherenceStats(userId: string, startDate: Date, endDate: Date) {
    const medicines = await this.medicineRepository.findByUserId(userId);
    const medicineIds = medicines.map((m) => m.id);

    let totalDoses = 0;
    let takenDoses = 0;

    for (const medicineId of medicineIds) {
      const logs = await this.medicineLogRepository.findByMedicineId(medicineId);
      const filteredLogs = logs.filter((log) => {
        const logDate = new Date(log.takenTime);
        return logDate >= startDate && logDate <= endDate;
      });

      totalDoses += filteredLogs.length;
      takenDoses += filteredLogs.filter((log) => log.status === LogStatus.TAKEN).length;
    }

    return {
      totalDoses,
      takenDoses,
      missedDoses: totalDoses - takenDoses,
      adherenceRate: totalDoses > 0 ? Math.round((takenDoses / totalDoses) * 100) : 100,
    };
  }
}
