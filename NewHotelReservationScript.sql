--begin re-runnable statements
SET NOCOUNT ON
GO

USE master
GO
if exists (select * from sysdatabases where name='HotelReservationSystem')
		drop database HotelReservationSystem
go

DECLARE @device_directory NVARCHAR(520)
SELECT @device_directory = SUBSTRING(filename, 1, CHARINDEX(N'master.mdf', LOWER(filename)) - 1)
FROM master.dbo.sysaltfiles WHERE dbid = 1 AND fileid = 1

EXECUTE (N'CREATE DATABASE HOTELRESERVATIONSYSTEM
  ON PRIMARY (NAME = N''HotelReservationSystem'', FILENAME = N''' + @device_directory + N'hotelreservationsystem.mdf'')
  LOG ON (NAME = N''HotelReservationSystem_log'',  FILENAME = N''' + @device_directory + N'hotelreservationsystem.ldf'')')
go

GO

set quoted_identifier on
GO

SET DATEFORMAT mdy
GO

use "HotelReservationSystem"

if exists (select * from sysobjects where id = object_id('dbo.Reservation') and sysstat & 0xf = 3)
	drop table "dbo"."Reservation"
GO
if exists (select * from sysobjects where id = object_id('dbo.Guest') and sysstat & 0xf = 3)
	drop table "dbo"."Guest"
GO
if exists (select * from sysobjects where id = object_id('dbo.ReservationGuest') and sysstat & 0xf = 3)
	drop table "dbo"."ReservationGuest"
GO
if exists (select * from sysobjects where id = object_id('dbo.PromotionCode') and sysstat & 0xf = 3)
	drop table "dbo"."PromotionCode"
GO
if exists (select * from sysobjects where id = object_id('dbo.Room') and sysstat & 0xf = 3)
	drop table "dbo"."Room"
GO
if exists (select * from sysobjects where id = object_id('dbo.RoomType') and sysstat & 0xf = 3)
	drop table "dbo"."RoomType"
GO
if exists (select * from sysobjects where id = object_id('dbo.Rate') and sysstat & 0xf = 3)
	drop table "dbo"."Rate"
GO
if exists (select * from sysobjects where id = object_id('dbo.RoomRate') and sysstat & 0xf = 3)
	drop table "dbo"."RoomRate"
GO

if exists (select * from sysobjects where id = object_id('dbo.Amenity') and sysstat & 0xf = 3)
	drop table "dbo"."Amenity"
GO

if exists (select * from sysobjects where id = object_id('dbo.RoomAmenity') and sysstat & 0xf = 3)
	drop table "dbo"."RoomAmenity"
GO

if exists (select * from sysobjects where id = object_id('dbo.AddOn') and sysstat & 0xf = 3)
	drop table "dbo"."RoomAddOn"
GO

if exists (select * from sysobjects where id = object_id('dbo.RoomRate') and sysstat & 0xf = 3)
	drop table "dbo"."RoomRate"
GO








--end re-runnable statements
use HotelReservationSystem
go

create table Reservation (
ReservationID int identity(1,1) primary key,
ReservationNumber int not null,
BeginDate date not null,
EndDate date not null,
CustomerID int not null,
)
go

create table Guest (
GuestID int identity(1,1) primary key,
FirstName varchar(100) not null,
LastName varchar(100) not null,
StreetAddress varchar(200) not null,
City varchar(100) not null,
[State] varchar(100) not null,
ZipCode varchar(100) not null,
Email varchar(100) null,
Phone varchar(100) not null,
)
go

--create ReservationGuest bridge table

create table ReservationGuest(
ReservationID int not null,
GuestID int not null,
constraint PK_ReservationGuest
	primary key(ReservationID, GuestID),
constraint FK_Guest_ReservationGuest
	foreign key (GuestID)
	references Guest(GuestID),
constraint FK_Reservation_ReservationGuest
	foreign key (ReservationID)
	references Reservation(ReservationID),
)
go

create table PromotionCode(
PromotionCodeID int identity (1,1) primary key,
PromotionName varchar(100) not null,
BeginDate date not null,
EndDate date not null,
[Percentage] decimal(3,3) null,
DollarAmount decimal(5,3) null,
)

go

--add PromotionCode relationship to Reservation table
alter table Reservation add PromotionCodeID int not null
go

alter table Reservation add constraint FK_PromotionCode
foreign key (PromotionCodeID) references PromotionCode(PromotionCodeID)
go

-- create Room table
create table Room(
RoomID int identity (1,1) primary key,
RoomNumber int not null,
[Floor] int  not null,
Occupancy int not null,
[Percentage] decimal(3,3) null,
DollarAmount decimal(5,3) null,
)

--add Room relationship to Reservation table
alter table Reservation add RoomID int not null
go

alter table Reservation add constraint FK_Room
foreign key (RoomID) references Room(RoomID)
go

-- create RoomType table
create table RoomType( 
RoomTypeID int identity(1,1) primary key,
Name varchar(100) not null,
)
go

--add RoomType to Room table
alter table Room add RoomTypeID int not null
go

alter table Room add constraint FK_RoomType
foreign key (RoomTypeID) references RoomType(RoomTypeID)
go

--create Rate table
create table Rate( 
RateID int identity(1,1) primary key,
Rate decimal(6,2) not null,
)
go

--create RoomRate bridge table
create table RoomRate(
RoomID int not null,
RateID int not null,
BeginDate date not null,
EndDate date not null,
constraint PK_RoomRate
	primary key(RoomID, RateID),
constraint FK_Rate_RoomRate
	foreign key (RateID)
	references Rate(RateID),
constraint FK_Room_RoomRate
	foreign key (RoomID)
	references Room(RoomID),
)
go


--create Amenity table
create table Amenity( 
AmenityID int identity(1,1) primary key,
AmenityName varchar(100) not null,
)
go


--create RoomAmmentity bridge table
create table RoomAmenity(
RoomID int not null,
AmenityID int not null,
constraint PK_RoomAmenity
	primary key(RoomID, AmenityID),
constraint FK_Amenity_RoomAmenity
	foreign key (AmenityID)
	references Amenity(AmenityID),
constraint FK_Room_RoomAmenity
	foreign key (RoomID)
	references Room(RoomID),
)
go

--create AddOn table
create table AddOn( 
AddOnID int identity(1,1) primary key,
AddOnName varchar(100) not null,
UnitPrice decimal(8,2) not null,
)
go

--create RoomAddOn bridge table
create table RoomAddOn(
RoomID int not null,
AddOnID int not null,
constraint PK_RoomAddOn
	primary key(RoomID, AddOnID),
constraint FK_AddOn_RoomAddOn
	foreign key (AddOnID)
	references AddOn(AddOnID),
constraint FK_Room_RoomAddOn
	foreign key (RoomID)
	references Room(RoomID),
)
go
