import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { PuppeteerModule } from './puppeteer/puppeteer.module';

@Module({
  imports: [PuppeteerModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
