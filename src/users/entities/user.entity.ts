import { Entity, Column, PrimaryGeneratedColumn, PrimaryColumn, Timestamp } from 'typeorm';

@Entity("users")
export class User {
    @PrimaryGeneratedColumn("uuid", {})
    id: string;

    @Column("varchar", { length: 30, default: "CLIENT" })
    role: string;

    @PrimaryColumn("varchar", { length: 50, unique: true, nullable: false })
    username: string;

    @Column("varchar", { length: 50 })
    displayname: string;

    @Column("varchar", { length: 255 })
    description: string;

    @Column("timestamp without time zone", { default: () => "CURRENT_TIMESTAMP" })
    created_at: Timestamp;

    @Column({ default: true })
    isActive: boolean;
}
