--DROP DATABASE IF EXISTS "TodoMuebles";

--CREATE DATABASE "TodoMuebles"
--    WITH
--    OWNER = postgres
--    ENCODING = 'UTF8'
--    LC_COLLATE = 'Spanish_Spain.1252'
--    LC_CTYPE = 'Spanish_Spain.1252'
--    LOCALE_PROVIDER = 'libc'
--    TABLESPACE = pg_default
--    CONNECTION LIMIT = -1
--    IS_TEMPLATE = False;

--USE "TodoMuebles";

DROP SCHEMA IF EXISTS public CASCADE;

CREATE SCHEMA IF NOT EXISTS public
    AUTHORIZATION postgres;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;
COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


CREATE TYPE GENDER AS ENUM (
  'NOT_ANSWERED',
  'MALE',
  'FEMALE',
  'TRANSGENDER',
  'NON_BINARY'
);

CREATE TYPE ENCRYPTION_ALGORITHM AS ENUM (
  'Bcrypt',
  'Scrypt',
  'Argon2'
);

CREATE TYPE IVA_STATUS AS ENUM (
  'EXEMPT',
  'RESPONSIBLE',
  'REACHED'
);

CREATE TYPE PAYMENT_STATUS AS ENUM (
  'PENDING',
  'AUTHORIZED',
  'PAID',
  'FAILED',
  'DECLINED',
  'REFUNDED'
);

CREATE TYPE ORDER_STATUS AS ENUM (
  'PENDING',
  'DELAYED',
  'PROCESSING',
  'COMPLETED',
  'CANCELLED'
);

CREATE TYPE SHIPMENT_STATUS AS ENUM (
  'PENDING',
  'DELAYED',
  'SHIPPING',
  'DELIVERED',
  'CANCELLED'
);

CREATE TYPE STREET_ADDRESS AS (
  "name" VARCHAR(35),
  "number" SMALLINT,
  "floor" SMALLINT,
  "unit" VARCHAR(5)
);

CREATE TABLE "users" (
  "id" UUID UNIQUE NOT NULL DEFAULT uuid_generate_v4(),
  "role" VARCHAR(30) DEFAULT 'CLIENT',
  "username" VARCHAR(50) UNIQUE NOT NULL,
  "displayname" VARCHAR(50),
  "description" VARCHAR(255),
  "created_at" TIMESTAMP DEFAULT (CURRENT_TIMESTAMP),
  PRIMARY KEY ("id", "username")
);

CREATE TABLE "users_passwords" (
  "id" SERIAL NOT NULL,
  "user_id" UUID NOT NULL,
  "password_hash" VARCHAR(255) NOT NULL,
  "salt" VARCHAR(150) NOT NULL,
  "encryption_algorithm" ENCRYPTION_ALGORITHM NOT NULL,
  PRIMARY KEY ("id"),
  UNIQUE ("user_id"),
  FOREIGN KEY ("user_id") REFERENCES "users" ("id")
	ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE "users_data" (
  "id" SERIAL NOT NULL,
  "user_id" UUID NOT NULL,
  "theme" VARCHAR(20),
  "language" VARCHAR(5) NOT NULL DEFAULT 'en-US',
  "time_zone" VARCHAR(20),
  "followed_posts" JSONB,
  "favorited_posts" JSONB,
  "saved_lists" JSONB,
  PRIMARY KEY ("id"),
  UNIQUE ("user_id"),
  FOREIGN KEY ("user_id") REFERENCES "users" ("id")
	ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE "users_personal_data" (
  "id" SERIAL NOT NULL,
  "user_id" UUID NOT NULL,
  "email" VARCHAR(255) NOT NULL,
  "phonenumber" VARCHAR(255),
  "firstnames" VARCHAR(255) NOT NULL,
  "surnames" VARCHAR(255) NOT NULL,
  "birthdate" DATE NOT NULL,
  "gender" GENDER,
  PRIMARY KEY ("id"),
  UNIQUE ("user_id", "email"),
  FOREIGN KEY ("user_id") REFERENCES "users" ("id")
	ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE "users_tax_info" (
  "id" SERIAL NOT NULL,
  "user_id" UUID NOT NULL,
  "is_monotributist" BOOLEAN DEFAULT false,
  "monotributist_category" CHAR,
  "iva_status" IVA_STATUS,
  "iva_rate" NUMERIC,
  PRIMARY KEY ("id"),
  UNIQUE ("user_id"),
  FOREIGN KEY ("user_id") REFERENCES "users" ("id")
	ON DELETE CASCADE ON UPDATE CASCADE
);

COMMENT ON COLUMN "users_tax_info"."iva_status" IS 'Reached: Indica que una entidad ha superado el umbral para ser considerada responsable de IVA.
Exempt: Indica que una entidad está exenta de pagar IVA, es decir, no está sujeta al impuesto.
Responsible: Indica que una entidad es responsable de cobrar y pagar IVA.';

CREATE TABLE "users_addresses" (
  "id" SERIAL NOT NULL,
  "user_id" UUID NOT NULL,
  "street_address" STREET_ADDRESS,
  "city" VARCHAR(100),
  "area" VARCHAR(150),
  "province" VARCHAR(100),
  "country" VARCHAR(100),
  "postal_code" VARCHAR(20),
  "created_at" TIMESTAMP DEFAULT (CURRENT_TIMESTAMP),
  PRIMARY KEY ("id"),
  FOREIGN KEY ("user_id") REFERENCES "users" ("id")
	ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE "users_payment_methods" (
  "id" SERIAL NOT NULL,
  "user_id" UUID NOT NULL,
  "payment_method" VARCHAR(50),
  "token" VARCHAR(255),
  "card_holder_name" VARCHAR(100),
  "card_number" VARCHAR(16),
  "card_expiration_date" date,
  "billing_address" TEXT,
  "created_at" TIMESTAMP DEFAULT (CURRENT_TIMESTAMP),
  PRIMARY KEY ("id"),
  FOREIGN KEY ("user_id") REFERENCES "users" ("id")
	ON DELETE CASCADE ON UPDATE CASCADE
);

COMMENT ON COLUMN "users_payment_methods"."payment_method" IS 'credit_card, debit_card, paypal, etc.';
COMMENT ON COLUMN "users_payment_methods"."token" IS 'Encrypted or tokenized payment data';
COMMENT ON COLUMN "users_payment_methods"."card_holder_name" IS 'For credit/debit cards';
COMMENT ON COLUMN "users_payment_methods"."card_number" IS 'Stored encrypted or tokenized';

CREATE TABLE "posts" (
  "id" SERIAL NOT NULL,
  "title" VARCHAR(40) NOT NULL,
  "description" TEXT,
  "features" JSONB,
  "discount" MONEY DEFAULT 0,
  "total_sales" INTEGER DEFAULT 0,
  "is_dayoffer" BOOLEAN DEFAULT false,
  "is_new" BOOLEAN DEFAULT true,
  "date" DATE DEFAULT (CURRENT_DATE),
  PRIMARY KEY ("id")
);

CREATE TABLE "post_questions" (
  "id" SERIAL NOT NULL,
  "user_id" UUID NOT NULL,
  "post_id" SERIAL NOT NULL,
  "content" VARCHAR(255) NOT NULL,
  "created_at" TIMESTAMP DEFAULT (CURRENT_TIMESTAMP),
  PRIMARY KEY ("id"),
  FOREIGN KEY ("user_id") REFERENCES "users" ("id")
	ON DELETE NO ACTION ON UPDATE CASCADE,
  FOREIGN KEY ("post_id") REFERENCES "posts" ("id")
	ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE "post_responses" (
  "id" SERIAL NOT NULL,
  "user_id" UUID NOT NULL,
  "question_id" SERIAL NOT NULL,
  "content" VARCHAR(255) NOT NULL,
  "created_at" TIMESTAMP DEFAULT (CURRENT_TIMESTAMP),
  PRIMARY KEY ("id"),
  FOREIGN KEY ("user_id") REFERENCES "users" ("id")
	ON DELETE NO ACTION ON UPDATE CASCADE,
  FOREIGN KEY ("question_id") REFERENCES "post_questions" ("id")
	ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE "post_reviews" (
  "id" SERIAL NOT NULL,
  "user_id" UUID NOT NULL,
  "post_id" SERIAL NOT NULL,
  "rating" SMALLINT NOT NULL,
  "content" VARCHAR(255) NOT NULL,
  "created_at" TIMESTAMP DEFAULT (CURRENT_TIMESTAMP),
  PRIMARY KEY ("id"),
  FOREIGN KEY ("user_id") REFERENCES "users" ("id")
	ON DELETE NO ACTION ON UPDATE CASCADE,
  FOREIGN KEY ("post_id") REFERENCES "posts" ("id")
	ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE "post_feedbacks" (
  "id" SERIAL NOT NULL,
  "user_id" UUID NOT NULL,
  "review_id" SERIAL NOT NULL,
  "content" VARCHAR(255),
  "value" BOOLEAN NOT NULL,
  PRIMARY KEY ("id"),
  FOREIGN KEY ("user_id") REFERENCES "users" ("id")
	ON DELETE NO ACTION ON UPDATE CASCADE,
  FOREIGN KEY ("review_id") REFERENCES "post_reviews" ("id")
	ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE "categories" (
  "id" SERIAL NOT NULL,
  "name" VARCHAR(45) NOT NULL,
  PRIMARY KEY ("id")
);

CREATE TABLE "products" (
  "id" SERIAL NOT NULL,
  "name" VARCHAR(50) NOT NULL,
  "details" TEXT,
  "price" MONEY NOT NULL,
  "color" VARCHAR(30),
  "image_path" PATH,
  "stock_amount" SMALLINT DEFAULT 0,
  "post_id" SERIAL,
  PRIMARY KEY ("id"),
  FOREIGN KEY ("post_id") REFERENCES "posts" ("id")
	ON DELETE NO ACTION ON UPDATE CASCADE
);

CREATE TABLE "orders" (
  "id" SERIAL NOT NULL,
  "user_id" UUID NOT NULL,
  "order_status" ORDER_STATUS NOT NULL DEFAULT ('PENDING'::order_status),
  "discount_codes" JSONB,
  "created_at" TIMESTAMP DEFAULT (CURRENT_TIMESTAMP),
  PRIMARY KEY ("id"),
  FOREIGN KEY ("user_id") REFERENCES "users" ("id")
	ON DELETE NO ACTION ON UPDATE CASCADE
);

CREATE TABLE "invoices" (
  "id" SERIAL NOT NULL,
  "user_id" UUID NOT NULL,
  "order_id" SERIAL NOT NULL,
  "date" DATE DEFAULT (CURRENT_DATE),
  "due_date" DATE NOT NULL,
  "payment_status" PAYMENT_STATUS NOT NULL DEFAULT ('PENDING'::payment_status),
  PRIMARY KEY ("id"),
  FOREIGN KEY ("user_id") REFERENCES "users" ("id")
	ON DELETE NO ACTION ON UPDATE CASCADE,
  FOREIGN KEY ("order_id") REFERENCES "orders" ("id")
	ON DELETE NO ACTION ON UPDATE CASCADE
);

CREATE TABLE "shipments" (
  "id" SERIAL NOT NULL,
  "order_id" SERIAL NOT NULL,
  "shipment_status" SHIPMENT_STATUS DEFAULT ('PENDING'::shipment_status),
  "tracking_number" VARCHAR(50),
  "shipping_date" DATE,
  "shipping_address" JSONB,
  "created_at" TIMESTAMP DEFAULT (CURRENT_TIMESTAMP),
  PRIMARY KEY ("id"),
  FOREIGN KEY ("order_id") REFERENCES "orders" ("id")
	ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE "order_items" (
  "id" SERIAL NOT NULL,
  "order_id" SERIAL NOT NULL,
  "product_id" SERIAL NOT NULL,
  "quantity" SMALLINT DEFAULT 1,
  PRIMARY KEY ("id"),
  FOREIGN KEY ("order_id") REFERENCES "orders" ("id")
	ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY ("product_id") REFERENCES "products" ("id")
	ON DELETE NO ACTION ON UPDATE CASCADE
);

CREATE TABLE "product_category" (
  "id" SERIAL NOT NULL,
  "product_id" SERIAL NOT NULL,
  "category_id" SERIAL NOT NULL,
  PRIMARY KEY ("id"),
  FOREIGN KEY ("product_id") REFERENCES "products" ("id")
	ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY ("category_id") REFERENCES "categories" ("id")
	ON DELETE CASCADE ON UPDATE CASCADE
);

