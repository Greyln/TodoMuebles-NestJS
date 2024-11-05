import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { ProductsModule } from './products/products.module';
import { UsersModule } from './users/users.module';
import { PostsModule } from './posts/posts.module';
import { TasksModule } from './tasks/tasks.module';

import { User } from './users/entities/user.entity';
import { Product } from './products/entities/product.entity';
import { Post } from './posts/entities/post.entity';
import { CategoriesModule } from './categories/categories.module';
import { FeedbacksModule } from './feedbacks/feedbacks.module';
import { InvoicesModule } from './invoices/invoices.module';
import { OrdersModule } from './orders/orders.module';
import { ShipmentsModule } from './shipments/shipments.module';
import { ReviewsModule } from './reviews/reviews.module';
import { QuestionsModule } from './questions/questions.module';
import { ResponsesModule } from './responses/responses.module';

function getDBModule() {
  return TypeOrmModule.forRoot({
    type: 'postgres',
    host: 'localhost',
    port: 5432,
    username: 'postgres',
    password: 'admin',
    database: 'postgres',
    applicationName: 'TodoMueblesPG',
    entities: [
      User, Product, Post
    ],
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
    ProductsModule, UsersModule, PostsModule, TasksModule, CategoriesModule, FeedbacksModule, InvoicesModule, OrdersModule, ShipmentsModule, ReviewsModule, QuestionsModule, ResponsesModule
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
