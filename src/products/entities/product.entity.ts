import { Post } from 'src/posts/entities/post.entity';
import { Entity, Column, PrimaryGeneratedColumn, RelationId, ManyToOne, JoinColumn } from 'typeorm';

@Entity("products")
export class Product {
    @PrimaryGeneratedColumn()
    id: number

    @Column("varchar", { length: 50, nullable: false })
    name: string

    @Column("text")
    details: string

    @Column("money", { nullable: false })
    price: number

    @Column("varchar", { length: 30 })
    color: string

    @Column("path")
    image_path: string

    @Column("smallint", { default: 0 })
    stock_amount: number

    @ManyToOne(type => Post, { nullable: true })
    @JoinColumn({ name: "post_id" })
    post: Post
}
