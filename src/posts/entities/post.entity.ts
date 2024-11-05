import { Entity, Column, PrimaryGeneratedColumn, ManyToOne, JoinColumn } from 'typeorm';

@Entity("posts")
export class Post {
    @PrimaryGeneratedColumn()
    id: number

    @Column("varchar", { length: 40, nullable: false })
    title: string

    @Column("text")
    description: string

    @Column("jsonb")
    features: {}

    @Column("money", { default: 0 })
    discount: number

    @Column("integer", { default: 0 })
    total_sales: number

    @Column("boolean", { default: false })
    is_dayoffer: boolean

    @Column("boolean", { default: true })
    is_new: boolean

    @Column("date", { default: () => "CURRENT_DATE" })
    date: Date
}
