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


insert into rejs values(1,1234,'2016-03-04',1,100);
insert into rejs values(2,4328,'2016-03-05',2,100);
insert into rejs values(3,8376,'2016-03-06',3,100);
insert into rejs values(4,3748,'2016-03-07',4,100);
insert into rejs values(5,6492,'2016-03-08',5,100);
insert into rejs values(6,1830,'2016-03-09',6,100);



////////////////////////////////////////////////////////////////


create global temporary table EwidencjaX 
(
nextval integer not null,
id_rejsu numeric(5,0) not null
)

////////////////////////////////////////////////////////////////

create or replace sequence NAZWA_UZYTKOWNNIKA.NAZWA_SEKWENCJI			////// nazwa sekwencji musi byc inna od nazwy sekwencji juz obecnej na serwerze
increment by 1									/// czasem trzeba podaæ nazwe usera przed nazwa sekwencji
start with 1;

////////////////////////////////////////////////////////////////


create or replace TRIGGER "tr_DEL_pozycja_faktury" 
after delete on pozycja_faktury
referencing old as old_rec 
FOR EACH ROW 

BEGIN 

declare v_ilosc_pozycji_faktury integer;
declare v_ilosc_uzyc_biletu integer;

update rejs
set  Liczba_Wolnych_Miejsc = Liczba_Wolnych_Miejsc + 
old_rec.Liczba_miejsc
where ID_rejsu = old_rec.id_rejsu;


update faktura 
set wartosc_faktury = wartosc_faktury + old_rec.cena_zakupu
where id_faktury = old_rec.id_faktury;

set v_ilosc_pozycji_faktury = 
(
select count(*) from pozycja_faktury 
where id_faktury=old_rec.id_faktury
);


set v_ilosc_uzyc_biletu = 
(
select count(*) from pozycja_faktury 
where id_biletu = old_rec.id_biletu
);


if v_ilosc_uzyc_biletu=0 THEN
delete bilet 
where id_biletu=old_rec.id_biletu
end if; 


if v_ilosc_pozycji_faktury=0 THEN
delete faktura 
where id_faktury=old_rec.id_faktury
end if; 


END;

///////////////////////////////////////////////////////////

create or replace TRIGGER "tr_INS_pozycja_faktury" 
before insert on pozycja_faktury
referencing new as new_rec 
FOR EACH ROW 

BEGIN 

declare v_liczba_kupowanych_miejsc integer;
declare v_liczba_wolnych_miejsc integer;

declare v_id integer;
declare v_data integer;
declare v_nr_lotu integer;
declare v_id_linii integer;
declare v_pom integer;

declare v_max_id_biletu integer;
declare v_klasy integer;
declare v_klasy_kopia integer;
declare v_Bilet integer;
declare v_cena_biletu numeric(7,2);
declare v_los_liczba_wolnych_miejsc integer;



set v_los_liczba_wolnych_miejsc = fn_losuj_wartosc(1, 4) * 50;

set v_liczba_kupowanych_miejsc = new_rec.liczba_miejsc;

set v_id = 
(
select max(id_rejsu) from rejs
);

set v_nr_lotu = 
(
select nr_lotu from rejs 
where new_rec.ID_rejsu = rejs.id_rejsu
);

set v_id_linii = 
(
select id_linii from rejs 
where new_rec.ID_rejsu = rejs.id_rejsu
);

set v_data = 
(
select data_lotu from rejs 
where new_rec.id_rejsu = rejs.id_rejsu
);

set v_liczba_wolnych_miejsc = 
(
select liczba_wolnych_miejsc from rejs
where new_rec.id_rejsu = rejs.id_rejsu
);

set v_cena_biletu = fn_losuj_wartosc(50, 300);

if (new_rec.id_biletu = 0) then
set v_klasy = fn_losuj_wartosc(1, 3);
else 
set v_klasy = 
(
select id_klasy from bilet
where id_biletu = new_rec.id_biletu);
end if;
                                                        
if (v_klasy = 2) then
set v_cena_biletu = v_cena_biletu * 2
elseif (v_klasy = 3) then
set v_cena_biletu = v_cena_biletu * 1.5
end if;

set v_max_id_biletu = 
(
select max(id_biletu) from bilet
);

if (v_max_id_biletu IS NULL) then 
set v_max_id_biletu = 0;
end if;

set v_Bilet = 
(
select id_biletu from bilet
where id_klasy = v_klasy and id_rejsu = new_rec.ID_rejsu
);

    if (v_Bilet IS NULL) then 
        insert into bilet values
        (
        v_max_id_biletu+1, v_klasy, new_rec.ID_rejsu, v_cena_biletu
        ); 
        set v_Bilet = v_max_id_biletu+1;
    end if;


if (v_liczba_kupowanych_miejsc >= v_liczba_wolnych_miejsc) then 

    update rejs 
    set liczba_wolnych_miejsc = 0
    where new_rec.id_rejsu = rejs.id_rejsu;

    insert into rejs values
    (
    v_id+1, v_nr_lotu, dateadd(dd, 1, v_data),
    v_id_linii, v_los_liczba_wolnych_miejsc
    ); 


        if (v_liczba_kupowanych_miejsc != v_liczba_wolnych_miejsc) then 

            insert into pozycja_faktury values
            (
            new_rec.id_pozycji+1, new_rec.id_faktury, 
            (v_liczba_kupowanych_miejsc - v_liczba_wolnych_miejsc),v_id+1,
            v_Bilet, 0
            );

        end if;


    set new_rec.liczba_miejsc = v_liczba_wolnych_miejsc;


else 
    update rejs 
    set liczba_wolnych_miejsc = liczba_wolnych_miejsc - new_rec.liczba_miejsc 
    where rejs.id_rejsu = new_rec.id_rejsu;
end if;


set new_rec.id_biletu = v_Bilet;
set new_rec.cena_zakupu = new_rec.liczba_miejsc *
(
select cena_biletu from bilet 
where id_biletu = v_Bilet
);



update faktura 
set wartosc_faktury = wartosc_faktury + new_rec.cena_zakupu
where id_faktury = new_rec.id_faktury;


END;


/////////////////////////////////////////////////////////

create or replace TRIGGER "tr_UPD_pozycja_faktury" 
before update on pozycja_faktury
referencing new as new_rec old as old_rec 
FOR EACH ROW 

BEGIN 

declare v_ilosc_uzyc_biletu integer;

update rejs
set  Liczba_Wolnych_Miejsc = Liczba_Wolnych_Miejsc + 
(old_rec.Liczba_miejsc - new_rec.Liczba_miejsc)
where ID_rejsu = new_rec.id_rejsu;


if new_rec.id_biletu != new_rec.id_biletu THEN

    set v_ilosc_uzyc_biletu = 
    (
    select count(*) from pozycja_faktury 
    where id_biletu = old_rec.id_biletu
    );

    if v_ilosc_uzyc_biletu=0 THEN
    delete bilet 
    where id_biletu=old_rec.id_biletu
    end if; 
end if; 



set new_rec.cena_zakupu = new_rec.liczba_miejsc * 
(
select cena_biletu from bilet 
where bilet.id_biletu = new_rec.id_biletu
);



update faktura 
set wartosc_faktury = wartosc_faktury + (new_rec.cena_zakupu - old_rec.cena_zakupu)
where id_faktury = old_rec.id_faktury;

END;


////////////////////////////////////////////////////////////

create view Dochod_kwartal_1 as
select nazwa_linii as 'Linia lotnicza', sum(cena_zakupu) as 'Dochod' from linia_lotnicza, pozycja_faktury, rejs, faktura 
where pozycja_faktury.id_rejsu = rejs.id_rejsu 
and rejs.id_linii =  linia_lotnicza.ID_Linii
and faktura.id_faktury = pozycja_faktury.id_faktury 
and quarter(faktura.data_faktury) = 1
group by nazwa_linii
order by nazwa_linii;

////////////////////////////////////////////////////////////

create materialized view Kupno_kwartal_1 as
select Nazwisko as 'Nazwisko', Imie as 'Imie',
nazwa_kategorii as 'Kategoria klienta',
sum(liczba_miejsc) as 'Liczba kupionych biletow',
sum(cena_zakupu) as 'Koszt'
from kategoria_klienta, klient, faktura, pozycja_faktury,
where faktura.id_faktury = pozycja_faktury.id_faktury
and klient.id_klienta=faktura.id_klienta 
and kategoria_klienta.id_kategorii=klient.id_kategorii
and quarter(faktura.data_faktury) = 1
group by nazwisko, imie, nazwa_kategorii
order by nazwisko;

////////////////////////////////////////////////////////////

create view Kupno2_kwartal_1 as
select Nazwisko as 'Nazwisko', Imie as 'Imie',
nazwa_kategorii as 'Kategoria klienta', nazwa_linii as 'Linia lotnicza',
nazwa_klasy as 'Klasa', sum(liczba_miejsc) as 'Liczba kupionych biletow',
sum(cena_zakupu) as 'Koszt'
from kategoria_klienta, klient, faktura, pozycja_faktury, linia_lotnicza, klasa, bilet, rejs
where faktura.id_faktury = pozycja_faktury.id_faktury
and klient.id_klienta=faktura.id_klienta 
and kategoria_klienta.id_kategorii=klient.id_kategorii
and klasa.id_klasy=bilet.id_klasy 
and linia_lotnicza.id_linii=rejs.id_linii
and pozycja_faktury.id_biletu=bilet.id_biletu
and pozycja_faktury.id_rejsu=rejs.id_rejsu
and quarter(faktura.data_faktury) = 1
group by nazwisko, imie, nazwa_kategorii, nazwa_linii, nazwa_klasy
order by nazwisko;

////////////////////////////////////////////////////////////

create materialized view Sprzedaz_kwartal_1 as
select nazwa_linii as 'Linia lotnicza', nazwa_klasy  as 'Klasa',
sum(liczba_miejsc)  as 'Sprzedane bilety', sum(cena_zakupu) as 'Dochod'
from faktura, pozycja_faktury, bilet, rejs, linia_lotnicza, klasa 
where faktura.id_faktury = pozycja_faktury.id_faktury
and pozycja_faktury.id_biletu = bilet.id_biletu
and pozycja_faktury.id_rejsu = rejs.id_rejsu 
and bilet.id_klasy = klasa.id_klasy 
and linia_lotnicza.id_linii = rejs.id_linii
and quarter(faktura.data_faktury) = 1
group by nazwa_linii, nazwa_klasy
order by nazwa_linii;


////////////////////////////////////////////////////////////

create or replace FUNCTION "fn_losuj_wartosc" 
(v_min integer, v_max integer)
returns integer
begin

declare v_wylosowana_wartosc integer;
set v_wylosowana_wartosc = 

round(v_min+(v_max-v_min)*rand(),0);
 
return v_wylosowana_wartosc;
end;

////////////////////////////////////////////////////////////

create or replace PROCEDURE "generuj_transakcje"()
begin

declare cnt integer;
declare v_liczba_iteracji integer;
declare v_max_id_faktury integer;
declare v_wartosc_faktury numeric(9,2);

declare v_max_id_rejsu integer;
declare v_max_id_pozycji integer;
declare v_los_rejs integer;
declare v_max_nextval integer;
declare v_max_id_klienta integer;
declare v_id_klienta integer;
declare v_liczba_miejsc integer;
declare v_los integer;

set v_wartosc_faktury = 0;

set v_max_id_klienta = (
select max(id_klienta) from klient 
);

set v_id_klienta = fn_losuj_wartosc(1, v_max_id_klienta);

set v_liczba_iteracji = fn_losuj_wartosc(1, 10);

set v_max_id_faktury = (
select max(id_faktury) from faktura
);

if (v_max_id_faktury is null) then
 set v_max_id_faktury = 0;
end if;

insert into faktura values 
(
 v_max_id_faktury+1, v_id_klienta, current date, 0 
);

set cnt = 1;
petla:
loop

///////////////////////////////////////   wnetrze petli

 alter sequence NAZWA_SEKWENCJI	restart with 1;

delete ewidencjax;
insert into EwidencjaX 
select NAZWA_SEKWENCJI.nextval, id_rejsu from rejs
  where liczba_wolnych_miejsc != 0;

set v_max_nextval   = (
select NAZWA_SEKWENCJI.currval
);

set v_los = fn_losuj_wartosc(1, v_max_nextval);

set v_los_rejs = (
select id_Rejsu from ewidencjax
where nextval = 
(
v_los
)
);


set v_liczba_miejsc = fn_losuj_wartosc(1, 200);


set v_max_id_pozycji = (
select max(id_pozycji) from pozycja_faktury
);

if (v_max_id_pozycji is null) then
 set v_max_id_pozycji = 0;
end if;


insert into pozycja_faktury values 
(
v_max_id_pozycji+1, v_max_id_faktury+1, v_liczba_miejsc,
v_los_rejs, 0, 0
);

///////////////////////////////////////
                       
set cnt = cnt + 1;
if cnt > v_liczba_iteracji THEN 
leave petla
end if;
end loop petla;



refresh materialized view Sprzedaz_kwartal_1;
refresh materialized view Kupno_kwartal_1;

end;

////////////////////////////////////////////////////////////

create or replace PROCEDURE "pr_generowanie_transakcji"()
 begin

call generuj_transakcje;

commit


 end;

////////////////////////////////////////////////////////////


refresh materialized view Sprzedaz_kwartal_1;
refresh materialized view Kupno_kwartal_1;