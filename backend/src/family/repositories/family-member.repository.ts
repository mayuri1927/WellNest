import { FamilyMember } from '../entities/family-member.entity';

export class FamilyMemberRepository {
  private members: Map<string, FamilyMember> = new Map();
  private userIndex: Map<string, string[]> = new Map();

  async create(member: FamilyMember): Promise<FamilyMember> {
    this.members.set(member.id, member);
    const userMembers = this.userIndex.get(member.userId) || [];
    userMembers.push(member.id);
    this.userIndex.set(member.userId, userMembers);
    return member;
  }

  async findById(id: string): Promise<FamilyMember | null> {
    return this.members.get(id) || null;
  }

  async findByUserId(userId: string): Promise<FamilyMember[]> {
    const memberIds = this.userIndex.get(userId) || [];
    return memberIds
      .map((id) => this.members.get(id))
      .filter((m): m is FamilyMember => m !== undefined)
      .sort((a, b) => new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime());
  }

  async update(id: string, data: Partial<FamilyMember>): Promise<FamilyMember> {
    const member = this.members.get(id);
    if (!member) throw new Error('Family member not found');
    const updated = { ...member, ...data };
    this.members.set(id, updated);
    return updated;
  }

  async delete(id: string): Promise<void> {
    const member = this.members.get(id);
    if (member) {
      const userMembers = this.userIndex.get(member.userId) || [];
      this.userIndex.set(
        member.userId,
        userMembers.filter((mid) => mid !== id),
      );
    }
    this.members.delete(id);
  }
}
