import { User } from 'src/users/entities/user.entity';
import { Entity, Column, PrimaryGeneratedColumn, Timestamp, ManyToOne, JoinColumn } from 'typeorm';

export enum OrderStatus {
    'PENDING',
    'DELAYED',
    'PROCESSING',
    'COMPLETED',
    'CANCELLED'
}

@Entity("orders")
export class Order {
    @PrimaryGeneratedColumn()
    id: number

    @ManyToOne(type => User, { nullable: false, onDelete: null, onUpdate: "CASCADE" })
    @JoinColumn({ name: "user_id" })
    user: User

    @Column({
        type: "enum",
        enum: OrderStatus,
        default: OrderStatus.PENDING
    })
    order_status: OrderStatus

    @Column("jsonb")
    discount_codes: object

    @Column("timestamp", { default: () => "CURRENT_TIMESTAMP" })
    created_at: Timestamp
}
