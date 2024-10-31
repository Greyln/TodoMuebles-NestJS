import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { ItemsModule } from './items/items.module';
import { ProductsModule } from './products/products.module';
import { UsersModule } from './users/users.module';
import { PostsModule } from './posts/posts.module';
import { TasksModule } from './tasks/tasks.module';

function getDBModule() {
  return TypeOrmModule.forRoot({
    type: 'postgres',
    host: 'localhost',
    port: 5432,
    username: 'postgres',
    password: 'admin',
    database: 'postgres',
    applicationName: 'TodoMueblesPG',
    entities: [],
    subscribers: [],
    migrations: [],
    synchronize: true, // Remove on prod
    logging: true,
    logNotifications: true,
    retryAttempts: 10,
    retryDelay: 3000,
    autoLoadEntities: false,
  })

  return TypeOrmModule.forRoot({
    type: 'postgres',
    host: 'falteringly-brief-hyena.data-1.use1.tembo.io',
    port: 5432,
    username: 'postgres',
    password: 'aAe0xzuZybAoB3UB',
    database: 'postgres',
    schema: 'public ',
    applicationName: 'TodoMueblesPG',
    entities: [],
    subscribers: [],
    migrations: [],
    synchronize: true, // Remove on prod
    logging: true,
    logNotifications: true,
    retryAttempts: 10,
    retryDelay: 3000,
    autoLoadEntities: false,
  })
}


@Module({
  imports: [
    getDBModule(),
    ItemsModule, ProductsModule, UsersModule, PostsModule, TasksModule
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
