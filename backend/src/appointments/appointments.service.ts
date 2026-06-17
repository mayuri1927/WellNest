import { Injectable, NotFoundException } from '@nestjs/common';
import { v4 as uuidv4 } from 'uuid';
import { Appointment, AppointmentStatus } from './entities/appointment.entity';
import { AppointmentRepository } from './repositories/appointment.repository';
import { CreateAppointmentDto } from './dto/create-appointment.dto';
import { UpdateAppointmentDto } from './dto/update-appointment.dto';

@Injectable()
export class AppointmentsService {
  constructor(private appointmentRepository: AppointmentRepository) {}

  async create(userId: string, createAppointmentDto: CreateAppointmentDto): Promise<Appointment> {
    const appointment: Appointment = {
      id: uuidv4(),
      userId,
      familyMemberId: createAppointmentDto.familyMemberId,
      doctorName: createAppointmentDto.doctorName,
      specialty: createAppointmentDto.specialty,
      hospital: createAppointmentDto.hospital,
      location: createAppointmentDto.location,
      appointmentDate: new Date(createAppointmentDto.appointmentDate),
      notes: createAppointmentDto.notes,
      status: AppointmentStatus.SCHEDULED,
      reminders: createAppointmentDto.reminders || [],
      createdAt: new Date(),
      updatedAt: new Date(),
    };

    return this.appointmentRepository.create(appointment);
  }

  async findAll(userId: string): Promise<Appointment[]> {
    return this.appointmentRepository.findByUserId(userId);
  }

  async findOne(userId: string, appointmentId: string): Promise<Appointment> {
    const appointment = await this.appointmentRepository.findById(appointmentId);
    if (!appointment || appointment.userId !== userId) {
      throw new NotFoundException('Appointment not found');
    }
    return appointment;
  }

  async findUpcoming(userId: string): Promise<Appointment[]> {
    const appointments = await this.appointmentRepository.findByUserId(userId);
    const now = new Date();
    return appointments
      .filter((apt) => new Date(apt.appointmentDate) >= now && apt.status === AppointmentStatus.SCHEDULED)
      .sort((a, b) => new Date(a.appointmentDate).getTime() - new Date(b.appointmentDate).getTime());
  }

  async update(
    userId: string,
    appointmentId: string,
    updateAppointmentDto: UpdateAppointmentDto,
  ): Promise<Appointment> {
    await this.findOne(userId, appointmentId);
    const { appointmentDate, ...rest } = updateAppointmentDto;
    const updateData: Partial<Appointment> = { ...rest };
    if (appointmentDate) {
      updateData.appointmentDate = new Date(appointmentDate);
    }
    return this.appointmentRepository.update(appointmentId, {
      ...updateData,
      updatedAt: new Date(),
    });
  }

  async remove(userId: string, appointmentId: string): Promise<void> {
    await this.findOne(userId, appointmentId);
    await this.appointmentRepository.delete(appointmentId);
  }

  async updateStatus(
    userId: string,
    appointmentId: string,
    status: AppointmentStatus,
  ): Promise<Appointment> {
    const appointment = await this.findOne(userId, appointmentId);
    return this.appointmentRepository.update(appointmentId, {
      status,
      updatedAt: new Date(),
    });
  }
}
