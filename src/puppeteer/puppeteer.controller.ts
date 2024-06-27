import { Controller, Get, Query } from '@nestjs/common';
import { PuppeteerService } from './puppeteer.service';

@Controller('puppeteer')
export class PuppeteerController {
  constructor(private readonly puppeteerService: PuppeteerService) {}

  @Get()
  async screenshot(@Query('url') url: string) {
    const buffer = await this.puppeteerService.screenshot(url);

    const b64 = Buffer.from(buffer).toString('base64');
    // CHANGE THIS IF THE IMAGE YOU ARE WORKING WITH IS .jpg OR WHATEVER
    const mimeType = 'image/png'; // e.g., image/png

    const img = `<img src="data:${mimeType};base64,${b64}" />`;
    return buffer;
  }
}
