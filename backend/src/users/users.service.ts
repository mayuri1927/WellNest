import { Injectable, NotFoundException } from '@nestjs/common';
import { v4 as uuidv4 } from 'uuid';
import { User } from './entities/user.entity';
import { UserRepository } from './repositories/user.repository';
import { UpdateUserDto } from './dto/update-user.dto';

@Injectable()
export class UsersService {
  constructor(private userRepository: UserRepository) {}

  /**
   * Create a new user
   */
  async create(data: Partial<User>): Promise<User> {
    const user: User = {
      id: uuidv4(),
      name: data.name || '',
      email: data.email || '',
      password: data.password || '',
      phone: data.phone,
      profileImage: data.profileImage,
      height: data.height,
      weight: data.weight,
      fitnessGoal: data.fitnessGoal,
      createdAt: new Date(),
      updatedAt: new Date(),
    };

    return this.userRepository.create(user);
  }

  /**
   * Find user by ID
   */
  async findById(id: string): Promise<User | null> {
    return this.userRepository.findById(id);
  }

  /**
   * Find user by email
   */
  async findByEmail(email: string): Promise<User | null> {
    return this.userRepository.findByEmail(email);
  }

  /**
   * Update user
   */
  async update(id: string, updateUserDto: UpdateUserDto): Promise<User> {
    const user = await this.findById(id);
    
    if (!user) {
      throw new NotFoundException('User not found');
    }

    return this.userRepository.update(id, {
      ...updateUserDto,
      updatedAt: new Date(),
    });
  }

  /**
   * Update user password
   */
  async updatePassword(id: string, hashedPassword: string): Promise<void> {
    await this.userRepository.update(id, {
      password: hashedPassword,
      updatedAt: new Date(),
    });
  }

  /**
   * Delete user
   */
  async delete(id: string): Promise<void> {
    await this.userRepository.delete(id);
  }
}
