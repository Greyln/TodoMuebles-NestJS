import { Entity, Column, PrimaryGeneratedColumn, Timestamp } from 'typeorm';

@Entity()
export class User {
    @PrimaryGeneratedColumn()
    id: number;

    @Column()
    username: string;

    @Column()
    displayname: string;

    @Column()
    description: string;

    @Column()
    created_at: Timestamp;

    @Column({ default: true })
    isActive: boolean;
}
