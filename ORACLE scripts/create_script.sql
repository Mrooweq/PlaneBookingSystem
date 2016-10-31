CREATE TABLE KATEGORIA_KLIENTA
(
    ID_Kategorii    numeric (5) primary key ,
    Nazwa_kategorii varchar (50) NOT NULL
);




CREATE TABLE KLIENT
  (
    ID_Klienta   numeric (5) primary key,
    Imie         varchar (50) NOT NULL ,
    Nazwisko     varchar (50) NOT NULL ,
    ID_Kategorii numeric (5) NOT NULL
  ) ;

ALTER TABLE KLIENT ADD CONSTRAINT KATEGORIA_KLIENTA_FK FOREIGN KEY ( ID_Kategorii ) REFERENCES KATEGORIA_KLIENTA ( ID_Kategorii ) ;





CREATE TABLE FAKTURA
  (
    ID_Faktury      numeric (5) primary key,
    ID_Klienta      numeric (5) NOT NULL ,
    Data_Faktury    DATE NOT NULL ,
    Wartosc_Faktury numeric (16,2) NOT NULL
  ) ;

ALTER TABLE FAKTURA ADD CONSTRAINT KLIENT_FK FOREIGN KEY ( ID_Klienta ) REFERENCES KLIENT ( ID_Klienta ) ;




CREATE TABLE KLASA
  (
    ID_Klasy    numeric (5) primary key,
    Nazwa_Klasy varchar (20) NOT NULL
  ) ;


CREATE TABLE LINIA_LOTNICZA
  (
    ID_Linii    numeric (5) primary key ,
    Nazwa_Linii varchar (50) NOT NULL
  ) ;




CREATE TABLE REJS
  (
    ID_Rejsu  numeric (5) primary key,
    Nr_Lotu   INTEGER NOT NULL ,
    Data_Lotu DATE NOT NULL ,
    ID_Linii  numeric (5) NOT NULL,
    Liczba_Wolnych_Miejsc integer not null
  ) ;

ALTER TABLE REJS ADD CONSTRAINT LINIA_LOTNICZA_FKv1 FOREIGN KEY ( ID_Linii ) REFERENCES LINIA_LOTNICZA ( ID_Linii ) ;



CREATE TABLE BILET
  (
    ID_Biletu   numeric (5) primary key,
    ID_Klasy    numeric (5) NOT NULL ,
    ID_Rejsu    numeric (5) NOT NULL ,
    Cena_Biletu numeric (9,2) NOT NULL
  ) ;

ALTER TABLE BILET ADD CONSTRAINT KLASA_FK FOREIGN KEY ( ID_Klasy ) REFERENCES KLASA ( ID_Klasy ) ;
ALTER TABLE BILET ADD CONSTRAINT REJS_FKv2 FOREIGN KEY ( ID_Rejsu ) REFERENCES REJS ( ID_Rejsu ) ;




CREATE TABLE POZYCJA_FAKTURY
  (
    ID_Pozycji  numeric (5) not null,
    ID_Faktury  numeric (5)   not null,
    Liczba_Miejsc      INTEGER NOT NULL ,
    ID_Rejsu    numeric (5) NOT NULL ,
    ID_Biletu   numeric (5) NOT NULL ,
    Cena_Zakupu numeric (11,2) NOT NULL,

primary key(ID_pozycji, id_faktury)
  ) ;

ALTER TABLE POZYCJA_FAKTURY ADD CONSTRAINT CENA_FK FOREIGN KEY ( ID_Biletu ) REFERENCES BILET ( ID_Biletu ) ;
ALTER TABLE POZYCJA_FAKTURY ADD CONSTRAINT FAKTURA_FK FOREIGN KEY ( ID_Faktury ) REFERENCES FAKTURA ( ID_Faktury ) ;
ALTER TABLE POZYCJA_FAKTURY ADD CONSTRAINT REJS_FK FOREIGN KEY ( ID_Rejsu ) REFERENCES REJS ( ID_Rejsu ) ;


/////////////////

insert into kategoria_klienta values(1,'Przedstawiciel biura podrozy');
insert into kategoria_klienta values(2,'Dyrektor korporacji');
insert into kategoria_klienta values(3,'Potentant naftowy');
insert into kategoria_klienta values(4,'Urzednik panstwowy');
insert into kategoria_klienta values(5,'Inny');


insert into klient values(1,'Adam','Abacki',1);
insert into klient values(2,'Bernard','Babacki',2);
insert into klient values(
3,'Cecylia','Cabacka',3);
insert into klient values(
4,'Dariusz','Dabacki',5);
insert into klient values(
5,'Eugeniusz','Ebacki',4);
insert into klient values(
6,'Franciszek','Fabacki',3
);
insert into klient values(7,'Grzegorz','Gabacki',4
);
insert into klient values(8,'Halina','Habacka',1);
insert into klient values(
9,'Irena','Ibacka',5);
insert into klient values(
10,'Jan','Jabacki',2
);


insert into faktura values(1,2,'2016-01-29',95158);
insert into faktura values(2,6,'2016-01-29',75206.5);



insert into klasa values(1,'Ekonomiczna'


);
insert into klasa values(2,'VIP'



);
insert into klasa values(3,'Bussiness'


);



insert into linia_lotnicza values(1,'Alfa');
insert into linia_lotnicza values(2,'Beta');
insert into linia_lotnicza values(3,'Gamma');
insert into linia_lotnicza values(4,'Delta');
insert into linia_lotnicza values(5,'Epsilon');
insert into linia_lotnicza values(6,'Omega');


insert into rejs values(1,1234,'2016-03-04',1,88);
insert into rejs values(2,4328,'2016-03-05',2,14);
insert into rejs values(3,8376,'2016-03-06',3,0);
insert into rejs values(4,3748,'2016-03-07',4,0);
insert into rejs values(5,6492,'2016-03-08',5,0);
insert into rejs values(6,1830,'2016-03-09',6,100);
insert into rejs values(7,3748,'2016-03-08',4,47);
insert into rejs values(8,6492,'2016-03-09',5,7);
insert into rejs values(9,8376,'2016-03-07',3,0);
insert into rejs values(10,8376,'2016-03-08',3,62);



insert into bilet values(1,1,4,164);
insert into bilet values(2,1,7,119);
insert into bilet values(3,2,5,230);
insert into bilet values(4,2,8,140);
insert into bilet values(5,2,3,510);
insert into bilet values(6,2,1,340);
insert into bilet values(7,3,7,169.5
);
insert into bilet values(8,3,3,250.5);
insert into bilet values(9,3,9,361.5);
insert into bilet values(10,3,10,174);
insert into bilet values(11,2,2,158);


insert into pozycja_faktury values(2,1,42,7,2,4998
);
insert into pozycja_faktury values(1,1,100,4,1,16400);
insert into pozycja_faktury values(4,1,93,8,4,13020);
insert into pozycja_faktury values(3,1,100,5,3,23000
);
insert into pozycja_faktury values(5,1,66,3,5,33660
);
insert into pozycja_faktury values(6,1,12,1,6,4080
);
insert into pozycja_faktury values(7,2,61,7,7,10339.5
);
insert into pozycja_faktury values(10,2,38,10,10,6612
);
insert into pozycja_faktury values(9,2,100,9,9,36150
);
insert into pozycja_faktury values(8,2,34,3,8,8517
);
insert into pozycja_faktury values(11,2,86,2,11,13588
);