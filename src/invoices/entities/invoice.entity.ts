import { User } from 'src/users/entities/user.entity';
import { Entity, Column, PrimaryGeneratedColumn, Timestamp, ManyToOne, JoinColumn } from 'typeorm';

export enum PaymentStatus {
    'PENDING',
    'AUTHORIZED',
    'PAID',
    'FAILED',
    'DECLINED',
    'REFUNDED'
}

export class Invoice {}
