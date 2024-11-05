import { Entity, Column, PrimaryGeneratedColumn } from 'typeorm';

@Entity("categories")
export class Category {
    @PrimaryGeneratedColumn()
    id: number

    @Column("varchar", { length: 45, nullable: false })
    name: string
}
