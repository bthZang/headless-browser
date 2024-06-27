import { Controller, Get } from '@nestjs/common';
import { PuppeteerService } from './puppeteer.service';

@Controller('puppeteer')
export class PuppeteerController {
  constructor(private readonly puppeteerService: PuppeteerService) {}

  @Get()
  async screenshot(url: string): Promise<Buffer> {
    return await this.puppeteerService.screenshot(url);
  }
}
