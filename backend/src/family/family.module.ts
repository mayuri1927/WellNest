import { Module } from '@nestjs/common';
import { FamilyController } from './family.controller';
import { FamilyService } from './family.service';
import { FamilyMemberRepository } from './repositories/family-member.repository';

@Module({
  controllers: [FamilyController],
  providers: [FamilyService, FamilyMemberRepository],
  exports: [FamilyService],
})
export class FamilyModule {}
