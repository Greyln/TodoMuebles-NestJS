import { User } from 'src/users/entities/user.entity';
import { Entity, Column, PrimaryGeneratedColumn, Timestamp, ManyToOne, JoinColumn } from 'typeorm';

@Entity("orders")
export class Order {
    @PrimaryGeneratedColumn()
    id: number

    @ManyToOne(type => User, { nullable: false })
    @JoinColumn({ name: "user_id" })
    user: User

    @Column()
    order_status: null

    @Column()
    discount_codes: null

    @Column("timestamp", { default: () => "CURRENT_TIMESTAMP" })
    created_at: Timestamp
}
