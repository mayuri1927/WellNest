import { User } from '../entities/user.entity';

/**
 * In-memory user repository for MVP
 * In production, this would be replaced with Firestore or TypeORM
 */
export class UserRepository {
  private users: Map<string, User> = new Map();
  private emailIndex: Map<string, string> = new Map(); // email -> userId

  async create(user: User): Promise<User> {
    this.users.set(user.id, user);
    this.emailIndex.set(user.email.toLowerCase(), user.id);
    return user;
  }

  async findById(id: string): Promise<User | null> {
    return this.users.get(id) || null;
  }

  async findByEmail(email: string): Promise<User | null> {
    const userId = this.emailIndex.get(email.toLowerCase());
    if (!userId) return null;
    return this.users.get(userId) || null;
  }

  async update(id: string, data: Partial<User>): Promise<User> {
    const user = this.users.get(id);
    if (!user) throw new Error('User not found');

    const updatedUser = { ...user, ...data };
    this.users.set(id, updatedUser);
    return updatedUser;
  }

  async delete(id: string): Promise<void> {
    const user = this.users.get(id);
    if (user) {
      this.emailIndex.delete(user.email.toLowerCase());
    }
    this.users.delete(id);
  }

  async findAll(): Promise<User[]> {
    return Array.from(this.users.values());
  }
}
