import { Appointment } from '../entities/appointment.entity';

export class AppointmentRepository {
  private appointments: Map<string, Appointment> = new Map();
  private userIndex: Map<string, string[]> = new Map();

  async create(appointment: Appointment): Promise<Appointment> {
    this.appointments.set(appointment.id, appointment);
    const userAppointments = this.userIndex.get(appointment.userId) || [];
    userAppointments.push(appointment.id);
    this.userIndex.set(appointment.userId, userAppointments);
    return appointment;
  }

  async findById(id: string): Promise<Appointment | null> {
    return this.appointments.get(id) || null;
  }

  async findByUserId(userId: string): Promise<Appointment[]> {
    const appointmentIds = this.userIndex.get(userId) || [];
    return appointmentIds
      .map((id) => this.appointments.get(id))
      .filter((a): a is Appointment => a !== undefined)
      .sort((a, b) => new Date(b.appointmentDate).getTime() - new Date(a.appointmentDate).getTime());
  }

  async update(id: string, data: Partial<Appointment>): Promise<Appointment> {
    const appointment = this.appointments.get(id);
    if (!appointment) throw new Error('Appointment not found');
    const updated = { ...appointment, ...data };
    this.appointments.set(id, updated);
    return updated;
  }

  async delete(id: string): Promise<void> {
    const appointment = this.appointments.get(id);
    if (appointment) {
      const userAppointments = this.userIndex.get(appointment.userId) || [];
      this.userIndex.set(
        appointment.userId,
        userAppointments.filter((aid) => aid !== id),
      );
    }
    this.appointments.delete(id);
  }
}
