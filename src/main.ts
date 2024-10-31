import { NestFactory } from '@nestjs/core';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import { AppModule } from './app.module';

function getDocumentCFG() {
  return new DocumentBuilder()
    .setTitle('TodoMuebles RestAPI')
    .setDescription('The NestJS REST API documentation')
    .setVersion('1.0')
    .build();
}

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  const config = getDocumentCFG();

  const documentFactory = () => SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api', app, documentFactory);

  await app.listen(process.env.PORT ?? 3000);
}
bootstrap();
