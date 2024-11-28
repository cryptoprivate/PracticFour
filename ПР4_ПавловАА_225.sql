
-- DROP SEQUENCE doctors_id_seq;

CREATE SEQUENCE doctors_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE doctors_id_seq OWNER TO postgres;
GRANT ALL ON SEQUENCE doctors_id_seq TO postgres;

-- DROP SEQUENCE patients_id_seq;

CREATE SEQUENCE patients_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE patients_id_seq OWNER TO postgres;
GRANT ALL ON SEQUENCE patients_id_seq TO postgres;

-- DROP SEQUENCE receptions_id_seq;

CREATE SEQUENCE receptions_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE receptions_id_seq OWNER TO postgres;
GRANT ALL ON SEQUENCE receptions_id_seq TO postgres;
-- public.doctors определение

-- Drop table

-- DROP TABLE doctors;

CREATE TABLE doctors (
	id serial4 NOT NULL,
	surname varchar(100) NOT NULL,
	"name" varchar(100) NOT NULL,
	patronymic varchar(100) NULL,
	specialization varchar(100) NOT NULL,
	price_reception numeric NULL,
	percentage_of_deduction numeric NULL,
	CONSTRAINT doctors_pkey PRIMARY KEY (id)
);

-- Permissions

ALTER TABLE doctors OWNER TO postgres;
GRANT ALL ON TABLE doctors TO postgres;


-- public.patients определение

-- Drop table

-- DROP TABLE patients;

CREATE TABLE patients (
	id serial4 NOT NULL,
	surname varchar(100) NOT NULL,
	"name" varchar(100) NOT NULL,
	patronymic varchar(100) NULL,
	birth_date date NOT NULL,
	address varchar(100) NULL,
	CONSTRAINT patients_pkey PRIMARY KEY (id)
);

-- Permissions

ALTER TABLE patients OWNER TO postgres;
GRANT ALL ON TABLE patients TO postgres;


-- public.receptions определение

-- Drop table

-- DROP TABLE receptions;

CREATE TABLE receptions (
	id serial4 NOT NULL,
	doctor_id int4 NOT NULL,
	patient_id int4 NOT NULL,
	date_reception date NOT NULL,
	salary numeric NULL,
	CONSTRAINT receptions_pkey PRIMARY KEY (id),
	CONSTRAINT receptions_doctor_id_fkey FOREIGN KEY (doctor_id) REFERENCES doctors(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT receptions_patient_id_fkey FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- DROP FUNCTION public.calculate_salary();

CREATE OR REPLACE FUNCTION public.calculate_salary()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
begin 
	new.salary = (select price_reception*percentage_of_deduction / 100 * 0.87 from doctors where id = new.doctor_id);
	return new;
end
$function$
;

-- Table Triggers

create trigger calculate_salary before
insert
    or
update
    on
    public.receptions for each row execute function calculate_salary();

-- Permissions

ALTER TABLE receptions OWNER TO postgres;
GRANT ALL ON TABLE receptions TO postgres;


-- Permissions

ALTER FUNCTION public.calculate_salary() OWNER TO postgres;
GRANT ALL ON FUNCTION public.calculate_salary() TO postgres;


-- Permissions

GRANT ALL ON SCHEMA public TO pg_database_owner;
GRANT USAGE ON SCHEMA public TO public;


INSERT INTO public.doctors (surname,"name",patronymic,specialization,price_reception,percentage_of_deduction) VALUES
	 ('Иванов','Алексей','Сергеевич','Терапевт',1500,50),
	 ('Петров','Максим','Иванович','Кардиолог',2000,60),
	 ('Сидоров','Иван','Николаевич','Хирург',3000,70),
	 ('Кузнецов','Николай','Алексеевич','Невролог',1800,55),
	 ('Смирнов','Дмитрий','Анатольевич','Офтальмолог',2200,65),
	 ('Попов','Сергей','Владимирович','Педиатр',1700,50),
	 ('Васильев','Антон','Семенович','Дерматолог',1900,60),
	 ('Зайцев','Олег','Андреевич','Эндокринолог',2500,75),
	 ('Волков','Григорий','Степанович','Уролог',2400,60),
	 ('Морозов','Андрей','Евгеньевич','Травматолог',2600,55);
INSERT INTO public.patients (surname,"name",patronymic,birth_date,address) VALUES
	 ('Кузьмин','Кирилл','Тимурович','1985-03-15','ул. Ленина, д. 10'),
	 ('Николаев','Игорь','Сергеевич','1992-07-25','пр. Мира, д. 15'),
	 ('Гладков','Артём','Александрович','2000-01-30','ул. Пушкина, д. 8'),
	 ('Захаров','Дмитрий','Николаевич','1988-11-10','ул. Чехова, д. 5'),
	 ('Соловьев','Сергей','Олегович','1995-06-18','ул. Рубинштейна, д. 12'),
	 ('Орлов','Станислав','Петрович','1983-09-21','пр. Космонавтов, д. 7'),
	 ('Петров','Петр','Петрович','1999-02-14','ул. Гагарина, д. 20'),
	 ('Сергеев','Александр','Георгиевич','1975-04-11','ул. Победы, д. 3'),
	 ('Иванов','Иван','Иванович','1987-12-05','ул. Карла Маркса, д. 6'),
	 ('Григорьев','Константин','Аркадьевич','1990-10-29','ул. Школьная, д. 2');
INSERT INTO public.receptions (doctor_id,patient_id,date_reception) VALUES
	 (1,1,'2024-11-01'),
	 (2,2,'2024-11-02'),
	 (3,3,'2024-11-05'),
	 (4,4,'2024-11-10'),
	 (5,5,'2024-11-11'),
	 (6,6,'2024-11-12'),
	 (7,7,'2024-11-13'),
	 (8,8,'2024-11-14'),
	 (9,9,'2024-11-15'),
	 (10,10,'2024-11-16');





