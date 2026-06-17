import { Injectable, NotFoundException } from '@nestjs/common';
import { v4 as uuidv4 } from 'uuid';
import { FamilyMember } from './entities/family-member.entity';
import { FamilyMemberRepository } from './repositories/family-member.repository';
import { CreateFamilyMemberDto } from './dto/create-family-member.dto';
import { UpdateFamilyMemberDto } from './dto/update-family-member.dto';

@Injectable()
export class FamilyService {
  constructor(private familyMemberRepository: FamilyMemberRepository) {}

  async create(userId: string, createFamilyMemberDto: CreateFamilyMemberDto): Promise<FamilyMember> {
    const member: FamilyMember = {
      id: uuidv4(),
      userId,
      name: createFamilyMemberDto.name,
      relation: createFamilyMemberDto.relation,
      dateOfBirth: createFamilyMemberDto.dateOfBirth ? new Date(createFamilyMemberDto.dateOfBirth) : undefined,
      bloodGroup: createFamilyMemberDto.bloodGroup,
      gender: createFamilyMemberDto.gender,
      height: createFamilyMemberDto.height,
      weight: createFamilyMemberDto.weight,
      medicalConditions: createFamilyMemberDto.medicalConditions,
      allergies: createFamilyMemberDto.allergies,
      notes: createFamilyMemberDto.notes,
      createdAt: new Date(),
      updatedAt: new Date(),
    };

    return this.familyMemberRepository.create(member);
  }

  async findAll(userId: string): Promise<FamilyMember[]> {
    return this.familyMemberRepository.findByUserId(userId);
  }

  async findOne(userId: string, memberId: string): Promise<FamilyMember> {
    const member = await this.familyMemberRepository.findById(memberId);
    if (!member || member.userId !== userId) {
      throw new NotFoundException('Family member not found');
    }
    return member;
  }

  async update(
    userId: string,
    memberId: string,
    updateFamilyMemberDto: UpdateFamilyMemberDto,
  ): Promise<FamilyMember> {
    await this.findOne(userId, memberId);
    const { dateOfBirth, ...rest } = updateFamilyMemberDto;
    const updateData: Partial<FamilyMember> = { ...rest };
    if (dateOfBirth) {
      updateData.dateOfBirth = new Date(dateOfBirth);
    }
    return this.familyMemberRepository.update(memberId, {
      ...updateData,
      updatedAt: new Date(),
    });
  }

  async remove(userId: string, memberId: string): Promise<void> {
    await this.findOne(userId, memberId);
    await this.familyMemberRepository.delete(memberId);
  }
}
