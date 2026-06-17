import { Module } from '@nestjs/common';
import { MedicinesController } from './medicines.controller';
import { MedicinesService } from './medicines.service';
import { MedicineRepository } from './repositories/medicine.repository';
import { MedicineLogRepository } from './repositories/medicine-log.repository';

@Module({
  controllers: [MedicinesController],
  providers: [MedicinesService, MedicineRepository, MedicineLogRepository],
  exports: [MedicinesService],
})
export class MedicinesModule {}
