USE [master]
GO
/****** Object:  Database [Clinic]    Script Date: 1/24/2022 9:23:38 PM ******/
CREATE DATABASE [Clinic]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Clinic', FILENAME = N'/var/opt/mssql/data/Clinic.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Clinic_log', FILENAME = N'/var/opt/mssql/data/Clinic_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [Clinic] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Clinic].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Clinic] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Clinic] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Clinic] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Clinic] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Clinic] SET ARITHABORT OFF 
GO
ALTER DATABASE [Clinic] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Clinic] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Clinic] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Clinic] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Clinic] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Clinic] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Clinic] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Clinic] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Clinic] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Clinic] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Clinic] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Clinic] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Clinic] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Clinic] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Clinic] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Clinic] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Clinic] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Clinic] SET RECOVERY FULL 
GO
ALTER DATABASE [Clinic] SET  MULTI_USER 
GO
ALTER DATABASE [Clinic] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Clinic] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Clinic] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Clinic] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Clinic] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Clinic] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'Clinic', N'ON'
GO
ALTER DATABASE [Clinic] SET QUERY_STORE = OFF
GO
USE [Clinic]
GO
/****** Object:  UserDefinedFunction [dbo].[getClientGeneratedId]    Script Date: 1/24/2022 9:23:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE   FUNCTION [dbo].[getClientGeneratedId]
(
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @id int;

	-- Add the T-SQL statements to compute the return value here
	SELECT @id = Max(login_id) 
	FROM Login;

	-- Return the result of the function
	RETURN @id;

END
GO
/****** Object:  UserDefinedFunction [dbo].[getClientId]    Script Date: 1/24/2022 9:23:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[getClientId]
(
	-- Add the parameters for the function here
	@username varchar(50)
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @id int;

	-- Add the T-SQL statements to compute the return value here
	SELECT @id = C.client_id FROM Clients C, Login L WHERE  L.login_id = C.login_id
	AND L.username = @username;

	-- Return the result of the function
	RETURN @id 

END
GO
/****** Object:  Table [dbo].[Appointments_History]    Script Date: 1/24/2022 9:23:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Appointments_History](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[client_id] [int] NOT NULL,
	[date] [date] NOT NULL,
	[animal_name] [varchar](50) NOT NULL,
	[service] [varchar](50) NOT NULL,
	[doctor_name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Appointments_History] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[DoctorsFrequence]    Script Date: 1/24/2022 9:23:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[DoctorsFrequence]
(	
	-- Add the parameters for the function here
	@client int
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	SELECT doctor_name AS Doctor_name, COUNT(*) As Freq
	FROM Appointments_History
	WHERE client_id = @client
	GROUP BY doctor_name
)
GO
/****** Object:  Table [dbo].[Animals]    Script Date: 1/24/2022 9:23:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Animals](
	[animal_id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](50) NOT NULL,
	[age] [int] NULL,
	[height] [float] NULL,
	[weight] [float] NULL,
	[client_id] [int] NOT NULL,
 CONSTRAINT [PK_Animals] PRIMARY KEY CLUSTERED 
(
	[animal_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Appointments]    Script Date: 1/24/2022 9:23:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Appointments](
	[appointment_id] [int] IDENTITY(1,1) NOT NULL,
	[data] [datetime] NOT NULL,
	[service_id] [int] NOT NULL,
	[animal_id] [int] NOT NULL,
 CONSTRAINT [PK_Appointments] PRIMARY KEY CLUSTERED 
(
	[appointment_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Clients]    Script Date: 1/24/2022 9:23:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Clients](
	[client_id] [int] IDENTITY(1,1) NOT NULL,
	[first_name] [varchar](20) NULL,
	[last_name] [varchar](25) NOT NULL,
	[CNP] [varchar](15) NOT NULL,
	[login_id] [int] NOT NULL,
 CONSTRAINT [PK_Clients] PRIMARY KEY CLUSTERED 
(
	[client_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Doctors]    Script Date: 1/24/2022 9:23:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Doctors](
	[doctor_id] [int] IDENTITY(1,1) NOT NULL,
	[first_name] [varchar](20) NULL,
	[last_name] [varchar](25) NOT NULL,
	[specialization] [varchar](50) NULL,
 CONSTRAINT [PK_Doctors] PRIMARY KEY CLUSTERED 
(
	[doctor_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Login]    Script Date: 1/24/2022 9:23:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Login](
	[login_id] [int] IDENTITY(1,1) NOT NULL,
	[username] [varchar](50) NOT NULL,
	[password] [varchar](50) NULL,
 CONSTRAINT [PK_Login_1] PRIMARY KEY CLUSTERED 
(
	[login_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Services]    Script Date: 1/24/2022 9:23:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Services](
	[service_id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](50) NOT NULL,
	[doctor_id] [int] NOT NULL,
 CONSTRAINT [PK_Services_1] PRIMARY KEY CLUSTERED 
(
	[service_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Animals] ON 

INSERT [dbo].[Animals] ([animal_id], [name], [age], [height], [weight], [client_id]) VALUES (1, N'Otto', 10, 36, 8.6, 1)
INSERT [dbo].[Animals] ([animal_id], [name], [age], [height], [weight], [client_id]) VALUES (5, N'Happy', 7, 25, 4.2, 4)
INSERT [dbo].[Animals] ([animal_id], [name], [age], [height], [weight], [client_id]) VALUES (16, N'babusca', 2, 50, 16.5, 5)
INSERT [dbo].[Animals] ([animal_id], [name], [age], [height], [weight], [client_id]) VALUES (19, N'Loly', 2, 50, 2, 1)
SET IDENTITY_INSERT [dbo].[Animals] OFF
GO
SET IDENTITY_INSERT [dbo].[Appointments] ON 

INSERT [dbo].[Appointments] ([appointment_id], [data], [service_id], [animal_id]) VALUES (31, CAST(N'2022-07-02T12:00:00.000' AS DateTime), 1, 1)
INSERT [dbo].[Appointments] ([appointment_id], [data], [service_id], [animal_id]) VALUES (42, CAST(N'2022-01-20T20:07:00.000' AS DateTime), 4, 1)
INSERT [dbo].[Appointments] ([appointment_id], [data], [service_id], [animal_id]) VALUES (43, CAST(N'2022-01-21T20:08:00.000' AS DateTime), 11, 1)
INSERT [dbo].[Appointments] ([appointment_id], [data], [service_id], [animal_id]) VALUES (44, CAST(N'2022-01-16T20:09:00.000' AS DateTime), 20, 1)
INSERT [dbo].[Appointments] ([appointment_id], [data], [service_id], [animal_id]) VALUES (51, CAST(N'2022-01-18T22:57:00.000' AS DateTime), 3, 1)
INSERT [dbo].[Appointments] ([appointment_id], [data], [service_id], [animal_id]) VALUES (56, CAST(N'2022-01-18T01:02:00.000' AS DateTime), 4, 1)
INSERT [dbo].[Appointments] ([appointment_id], [data], [service_id], [animal_id]) VALUES (57, CAST(N'2022-01-18T01:02:00.000' AS DateTime), 5, 1)
INSERT [dbo].[Appointments] ([appointment_id], [data], [service_id], [animal_id]) VALUES (58, CAST(N'2022-01-18T01:03:00.000' AS DateTime), 6, 1)
INSERT [dbo].[Appointments] ([appointment_id], [data], [service_id], [animal_id]) VALUES (1043, CAST(N'2022-01-16T11:01:00.000' AS DateTime), 3, 1)
INSERT [dbo].[Appointments] ([appointment_id], [data], [service_id], [animal_id]) VALUES (1044, CAST(N'2022-02-14T00:00:00.000' AS DateTime), 17, 16)
INSERT [dbo].[Appointments] ([appointment_id], [data], [service_id], [animal_id]) VALUES (1045, CAST(N'2022-02-14T11:16:00.000' AS DateTime), 17, 16)
INSERT [dbo].[Appointments] ([appointment_id], [data], [service_id], [animal_id]) VALUES (1046, CAST(N'2022-02-14T11:16:00.000' AS DateTime), 17, 16)
INSERT [dbo].[Appointments] ([appointment_id], [data], [service_id], [animal_id]) VALUES (1049, CAST(N'2022-01-18T19:35:00.000' AS DateTime), 3, 1)
INSERT [dbo].[Appointments] ([appointment_id], [data], [service_id], [animal_id]) VALUES (1065, CAST(N'2022-01-18T20:42:00.000' AS DateTime), 3, 1)
INSERT [dbo].[Appointments] ([appointment_id], [data], [service_id], [animal_id]) VALUES (1066, CAST(N'2022-01-18T20:42:00.000' AS DateTime), 3, 1)
INSERT [dbo].[Appointments] ([appointment_id], [data], [service_id], [animal_id]) VALUES (1067, CAST(N'2022-01-18T20:42:00.000' AS DateTime), 3, 1)
INSERT [dbo].[Appointments] ([appointment_id], [data], [service_id], [animal_id]) VALUES (1068, CAST(N'2022-01-19T20:43:00.000' AS DateTime), 3, 1)
SET IDENTITY_INSERT [dbo].[Appointments] OFF
GO
SET IDENTITY_INSERT [dbo].[Appointments_History] ON 

INSERT [dbo].[Appointments_History] ([id], [client_id], [date], [animal_name], [service], [doctor_name]) VALUES (2, 1, CAST(N'2022-01-29' AS Date), N'Tom', N'deparazitare', N'Radu Calafeteanu')
INSERT [dbo].[Appointments_History] ([id], [client_id], [date], [animal_name], [service], [doctor_name]) VALUES (5, 1, CAST(N'2022-01-22' AS Date), N'Tom', N'igenizare corporala', N'Madalin Vasilescu')
INSERT [dbo].[Appointments_History] ([id], [client_id], [date], [animal_name], [service], [doctor_name]) VALUES (14, 1, CAST(N'2022-03-16' AS Date), N'Kim', N'deparazitare', N'Raluca Radoi')
INSERT [dbo].[Appointments_History] ([id], [client_id], [date], [animal_name], [service], [doctor_name]) VALUES (15, 1, CAST(N'2022-01-29' AS Date), N'Bubu', N'vaccinare', N'Carla Vlase')
INSERT [dbo].[Appointments_History] ([id], [client_id], [date], [animal_name], [service], [doctor_name]) VALUES (25, 1, CAST(N'2022-01-20' AS Date), N'Otto', N'amputatie', N'Ioana Savu')
INSERT [dbo].[Appointments_History] ([id], [client_id], [date], [animal_name], [service], [doctor_name]) VALUES (1011, 5, CAST(N'2022-02-14' AS Date), N'babusca', N'vaccinare', N'Carla Vlase')
INSERT [dbo].[Appointments_History] ([id], [client_id], [date], [animal_name], [service], [doctor_name]) VALUES (1029, 1, CAST(N'2022-01-20' AS Date), N'Otto', N'amputatie', N'Ioana Savu')
INSERT [dbo].[Appointments_History] ([id], [client_id], [date], [animal_name], [service], [doctor_name]) VALUES (1030, 1, CAST(N'2022-01-06' AS Date), N'Otto', N'sterilizare', N'Ioana Savu')
INSERT [dbo].[Appointments_History] ([id], [client_id], [date], [animal_name], [service], [doctor_name]) VALUES (1031, 1, CAST(N'2022-01-25' AS Date), N'Loly', N'amputatie', N'Ioana Marin')
INSERT [dbo].[Appointments_History] ([id], [client_id], [date], [animal_name], [service], [doctor_name]) VALUES (1032, 1, CAST(N'2022-01-29' AS Date), N'Otto', N'proceduri laparoscopice', N'Ioana Marin')
SET IDENTITY_INSERT [dbo].[Appointments_History] OFF
GO
SET IDENTITY_INSERT [dbo].[Clients] ON 

INSERT [dbo].[Clients] ([client_id], [first_name], [last_name], [CNP], [login_id]) VALUES (1, N'Antoniu', N'Bogdan', N'1990611152536', 1)
INSERT [dbo].[Clients] ([client_id], [first_name], [last_name], [CNP], [login_id]) VALUES (3, N'Buga', N'Ioana', N'8967998881089', 3)
INSERT [dbo].[Clients] ([client_id], [first_name], [last_name], [CNP], [login_id]) VALUES (4, N'Capanu', N'Andrei', N'8799898889769', 4)
INSERT [dbo].[Clients] ([client_id], [first_name], [last_name], [CNP], [login_id]) VALUES (5, N'Coman', N'Calin', N'0000000060044', 5)
INSERT [dbo].[Clients] ([client_id], [first_name], [last_name], [CNP], [login_id]) VALUES (8, N'Ana', N'Pop', N'1234567896785', 14)
INSERT [dbo].[Clients] ([client_id], [first_name], [last_name], [CNP], [login_id]) VALUES (13, N'ara', N'preda', N'1233333333333', 14)
INSERT [dbo].[Clients] ([client_id], [first_name], [last_name], [CNP], [login_id]) VALUES (18, N'Rusalda', N'Ioana', N'1098765111121', 28)
INSERT [dbo].[Clients] ([client_id], [first_name], [last_name], [CNP], [login_id]) VALUES (19, N'Stefan', N'Stan', N'1223344556666', 33)
INSERT [dbo].[Clients] ([client_id], [first_name], [last_name], [CNP], [login_id]) VALUES (21, N'Anda', N'Savu', N'2990611152536', 35)
INSERT [dbo].[Clients] ([client_id], [first_name], [last_name], [CNP], [login_id]) VALUES (30, N'Irina', N'Grigore', N'2990611152537', 51)
INSERT [dbo].[Clients] ([client_id], [first_name], [last_name], [CNP], [login_id]) VALUES (31, N'Miruna', N'Maria', N'2990611152539', 52)
SET IDENTITY_INSERT [dbo].[Clients] OFF
GO
SET IDENTITY_INSERT [dbo].[Doctors] ON 

INSERT [dbo].[Doctors] ([doctor_id], [first_name], [last_name], [specialization]) VALUES (1, N'Ioana', N'Savu', N'chirurgie')
INSERT [dbo].[Doctors] ([doctor_id], [first_name], [last_name], [specialization]) VALUES (2, N'Ioana', N'Marin', N'chirurgie')
INSERT [dbo].[Doctors] ([doctor_id], [first_name], [last_name], [specialization]) VALUES (3, N'Miruna', N'Stoin', N'alergologie')
INSERT [dbo].[Doctors] ([doctor_id], [first_name], [last_name], [specialization]) VALUES (4, N'Miruna', N'Stoin', N'alergologie')
INSERT [dbo].[Doctors] ([doctor_id], [first_name], [last_name], [specialization]) VALUES (5, N'Irina', N'Grigore', N'cardiologie')
INSERT [dbo].[Doctors] ([doctor_id], [first_name], [last_name], [specialization]) VALUES (6, N'Madalin', N'Vasilescu', N'dermatologie')
INSERT [dbo].[Doctors] ([doctor_id], [first_name], [last_name], [specialization]) VALUES (7, N'Nicu', N'Grigorie', N'geriatrie')
INSERT [dbo].[Doctors] ([doctor_id], [first_name], [last_name], [specialization]) VALUES (8, N'Paula', N'Andronic', N'imagistica')
INSERT [dbo].[Doctors] ([doctor_id], [first_name], [last_name], [specialization]) VALUES (9, N'Carla', N'Vlase', N'oftalmologie')
INSERT [dbo].[Doctors] ([doctor_id], [first_name], [last_name], [specialization]) VALUES (10, N'Radu', N'Calafeteanu', N'oncologie')
INSERT [dbo].[Doctors] ([doctor_id], [first_name], [last_name], [specialization]) VALUES (11, N'Stefan', N'Troian', N'ortopodie')
INSERT [dbo].[Doctors] ([doctor_id], [first_name], [last_name], [specialization]) VALUES (12, N'Radu', N'Cristea', N'radiologie')
INSERT [dbo].[Doctors] ([doctor_id], [first_name], [last_name], [specialization]) VALUES (13, N'Raluca', N'Radoi', N'stomatologie')
SET IDENTITY_INSERT [dbo].[Doctors] OFF
GO
SET IDENTITY_INSERT [dbo].[Login] ON 

INSERT [dbo].[Login] ([login_id], [username], [password]) VALUES (1, N'antoniu_bogdan', N'12341234')
INSERT [dbo].[Login] ([login_id], [username], [password]) VALUES (2, N'basaraba_adina', N'abcdefg')
INSERT [dbo].[Login] ([login_id], [username], [password]) VALUES (3, N'buga_ioana', N'1234abc')
INSERT [dbo].[Login] ([login_id], [username], [password]) VALUES (4, N'capanu_andrei', N'andrei')
INSERT [dbo].[Login] ([login_id], [username], [password]) VALUES (5, N'coman_calin', N'43bcd')
INSERT [dbo].[Login] ([login_id], [username], [password]) VALUES (6, N'dragomir_dragos', N'dragodDRA')
INSERT [dbo].[Login] ([login_id], [username], [password]) VALUES (7, N'dumbrava_david', N'dumdum')
INSERT [dbo].[Login] ([login_id], [username], [password]) VALUES (8, N'ioana', N'ioana')
INSERT [dbo].[Login] ([login_id], [username], [password]) VALUES (9, N'andrei', N'andrei')
INSERT [dbo].[Login] ([login_id], [username], [password]) VALUES (51, N'IRINA', N'i')
INSERT [dbo].[Login] ([login_id], [username], [password]) VALUES (52, N'miru', N'm')
INSERT [dbo].[Login] ([login_id], [username], [password]) VALUES (53, N'andrei4ff', N'f')
SET IDENTITY_INSERT [dbo].[Login] OFF
GO
SET IDENTITY_INSERT [dbo].[Services] ON 

INSERT [dbo].[Services] ([service_id], [name], [doctor_id]) VALUES (1, N'amputatie', 1)
INSERT [dbo].[Services] ([service_id], [name], [doctor_id]) VALUES (2, N'amputatie', 2)
INSERT [dbo].[Services] ([service_id], [name], [doctor_id]) VALUES (3, N'protezare-ortopedica', 11)
INSERT [dbo].[Services] ([service_id], [name], [doctor_id]) VALUES (4, N'microcipare', 7)
INSERT [dbo].[Services] ([service_id], [name], [doctor_id]) VALUES (5, N'amputatie', 13)
INSERT [dbo].[Services] ([service_id], [name], [doctor_id]) VALUES (6, N'cezariana', 1)
INSERT [dbo].[Services] ([service_id], [name], [doctor_id]) VALUES (7, N'investigatii imagistice', 8)
INSERT [dbo].[Services] ([service_id], [name], [doctor_id]) VALUES (8, N'proceduri laparoscopice', 1)
INSERT [dbo].[Services] ([service_id], [name], [doctor_id]) VALUES (9, N'proceduri laparoscopice', 2)
INSERT [dbo].[Services] ([service_id], [name], [doctor_id]) VALUES (10, N'eutanasiere', 7)
INSERT [dbo].[Services] ([service_id], [name], [doctor_id]) VALUES (11, N'igenizare corporala', 6)
INSERT [dbo].[Services] ([service_id], [name], [doctor_id]) VALUES (12, N'biopsie', 2)
INSERT [dbo].[Services] ([service_id], [name], [doctor_id]) VALUES (13, N'sterilizare', 1)
INSERT [dbo].[Services] ([service_id], [name], [doctor_id]) VALUES (14, N'analize', 3)
INSERT [dbo].[Services] ([service_id], [name], [doctor_id]) VALUES (15, N'deparazitare', 5)
INSERT [dbo].[Services] ([service_id], [name], [doctor_id]) VALUES (16, N'vaccinare', 4)
INSERT [dbo].[Services] ([service_id], [name], [doctor_id]) VALUES (17, N'vaccinare', 9)
INSERT [dbo].[Services] ([service_id], [name], [doctor_id]) VALUES (18, N'deparazitare', 10)
INSERT [dbo].[Services] ([service_id], [name], [doctor_id]) VALUES (19, N'vaccinare', 13)
INSERT [dbo].[Services] ([service_id], [name], [doctor_id]) VALUES (20, N'deparazitare', 13)
INSERT [dbo].[Services] ([service_id], [name], [doctor_id]) VALUES (21, N'deparazitare', 12)
INSERT [dbo].[Services] ([service_id], [name], [doctor_id]) VALUES (22, N'protezare-ortopedica', 11)
INSERT [dbo].[Services] ([service_id], [name], [doctor_id]) VALUES (23, N'microcipare', 7)
INSERT [dbo].[Services] ([service_id], [name], [doctor_id]) VALUES (24, N'deparazitare', 2)
INSERT [dbo].[Services] ([service_id], [name], [doctor_id]) VALUES (25, N'cezariana', 1)
INSERT [dbo].[Services] ([service_id], [name], [doctor_id]) VALUES (26, N'investigatii imagistice', 8)
INSERT [dbo].[Services] ([service_id], [name], [doctor_id]) VALUES (27, N'proceduri laparoscopice', 1)
INSERT [dbo].[Services] ([service_id], [name], [doctor_id]) VALUES (28, N'proceduri laparoscopice', 2)
INSERT [dbo].[Services] ([service_id], [name], [doctor_id]) VALUES (29, N'eutanasiere', 7)
INSERT [dbo].[Services] ([service_id], [name], [doctor_id]) VALUES (30, N'igenizare corporala', 6)
INSERT [dbo].[Services] ([service_id], [name], [doctor_id]) VALUES (31, N'biopsie', 2)
INSERT [dbo].[Services] ([service_id], [name], [doctor_id]) VALUES (32, N'sterilizare', 1)
INSERT [dbo].[Services] ([service_id], [name], [doctor_id]) VALUES (33, N'analize', 3)
INSERT [dbo].[Services] ([service_id], [name], [doctor_id]) VALUES (34, N'deparazitare', 5)
INSERT [dbo].[Services] ([service_id], [name], [doctor_id]) VALUES (35, N'vaccinare', 4)
INSERT [dbo].[Services] ([service_id], [name], [doctor_id]) VALUES (36, N'vaccinare', 9)
INSERT [dbo].[Services] ([service_id], [name], [doctor_id]) VALUES (37, N'deparazitare', 10)
INSERT [dbo].[Services] ([service_id], [name], [doctor_id]) VALUES (38, N'vaccinare', 13)
INSERT [dbo].[Services] ([service_id], [name], [doctor_id]) VALUES (39, N'deparazitare', 13)
INSERT [dbo].[Services] ([service_id], [name], [doctor_id]) VALUES (40, N'deparazitare', 12)
SET IDENTITY_INSERT [dbo].[Services] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [Unique_Clients]    Script Date: 1/24/2022 9:23:38 PM ******/
ALTER TABLE [dbo].[Clients] ADD  CONSTRAINT [Unique_Clients] UNIQUE NONCLUSTERED 
(
	[CNP] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [Unique_Login]    Script Date: 1/24/2022 9:23:38 PM ******/
ALTER TABLE [dbo].[Login] ADD  CONSTRAINT [Unique_Login] UNIQUE NONCLUSTERED 
(
	[username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Services]    Script Date: 1/24/2022 9:23:38 PM ******/
CREATE NONCLUSTERED INDEX [IX_Services] ON [dbo].[Services]
(
	[service_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Animals]  WITH CHECK ADD  CONSTRAINT [FK_Animals_Clients] FOREIGN KEY([client_id])
REFERENCES [dbo].[Clients] ([client_id])
GO
ALTER TABLE [dbo].[Animals] CHECK CONSTRAINT [FK_Animals_Clients]
GO
ALTER TABLE [dbo].[Appointments]  WITH CHECK ADD  CONSTRAINT [FK_Appointments_Animals] FOREIGN KEY([animal_id])
REFERENCES [dbo].[Animals] ([animal_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Appointments] CHECK CONSTRAINT [FK_Appointments_Animals]
GO
ALTER TABLE [dbo].[Appointments]  WITH CHECK ADD  CONSTRAINT [FK_Appointments_Services] FOREIGN KEY([service_id])
REFERENCES [dbo].[Services] ([service_id])
GO
ALTER TABLE [dbo].[Appointments] CHECK CONSTRAINT [FK_Appointments_Services]
GO
ALTER TABLE [dbo].[Services]  WITH CHECK ADD  CONSTRAINT [FK_Services_Doctors] FOREIGN KEY([doctor_id])
REFERENCES [dbo].[Doctors] ([doctor_id])
GO
ALTER TABLE [dbo].[Services] CHECK CONSTRAINT [FK_Services_Doctors]
GO
/****** Object:  StoredProcedure [dbo].[Appointments_Doctor]    Script Date: 1/24/2022 9:23:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[Appointments_Doctor]
	-- Add the parameters for the stored procedure here
	@doctor_id int,
	@date date,
	@count int OUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @AppoimentsCursor CURSOR;
	DECLARE @doctor int;

    SET @AppoimentsCursor = CURSOR
	FOR SELECT 
	S.doctor_id
	FROM dbo.[Services] S JOIN dbo.[Appointments] A
	ON S.service_id = A.service_id
	WHERE CAST(A.data AS DATE) = @date;
	
	OPEN @AppoimentsCursor;
	FETCH NEXT FROM @AppoimentsCursor INTO 
    @doctor;
	SET @count = 0;

	WHILE @@FETCH_STATUS = 0
    BEGIN 
		IF @doctor = @doctor_id
			SET @count = @count + 1;
		FETCH NEXT FROM @AppoimentsCursor INTO @doctor;

	END
END
GO
/****** Object:  StoredProcedure [dbo].[AppointmentsForClient]    Script Date: 1/24/2022 9:23:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[AppointmentsForClient]
	-- Add the parameters for the stored procedure here
	@client int
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @animal_name varchar(50),@animal_id int;
	DECLARE @AppData TABLE (appointment_id int, 
								animal_name varchar(50),
								data date,
								service varchar(50), 
								doctor_name varchar(50))
	DECLARE @AnimalCursor CURSOR;
    SET @AnimalCursor = CURSOR
	FOR SELECT 
	name, animal_id
	FROM Animals
	WHERE client_id = @client;
	
	OPEN @AnimalCursor;

	FETCH NEXT FROM @AnimalCursor INTO 
    @animal_name, @animal_id;

	WHILE @@FETCH_STATUS = 0
    BEGIN 
		INSERT INTO @AppData
		SELECT A.appointment_id , @animal_name animal_name, A.data, S.name, 
				D.first_name + ' ' + D.last_name AS doctor_name
		FROM Appointments A JOIN Services S ON A.service_id = S.service_id,
		Doctors D
		WHERE S.doctor_id = D.doctor_id
		AND 
		A.animal_id = @animal_id;

		FETCH NEXT FROM @AnimalCursor INTO 
		@animal_name, @animal_id;
	END
    CLOSE @AnimalCursor;
	DEALLOCATE @AnimalCursor;

	SELECT * FROM @AppData;
END
GO
/****** Object:  StoredProcedure [dbo].[SignUP]    Script Date: 1/24/2022 9:23:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SignUP]
	-- Add the parameters for the stored procedure here
	@username varchar(50),
	@password varchar(50),
	@error varchar(50) OUT
AS
BEGIN TRY
	IF EXISTS(SELECT * FROM dbo.Login WHERE Username= @username)
		THROW 51002, 'User ID Already Exists. Cannot Insert', 1
	ELSE
		BEGIN TRY
			INSERT INTO dbo.Login( Username, Password)
			VALUES( @username, @password)
		END TRY
		BEGIN CATCH
			SELECT ERROR_MESSAGE() AS Error
		END CATCH
END TRY
BEGIN CATCH
	SELECT ERROR_MESSAGE() AS Error
	SET @error = ERROR_MESSAGE()
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[Sp_Login]    Script Date: 1/24/2022 9:23:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Sp_Login]
	-- Add the parameters for the stored procedure here
	@Admin_id NVARCHAR(100),
	@Password NVARCHAR(100),
	@Isvalid BIT OUT
AS
BEGIN 
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    -- Insert statements for procedure here
SET @Isvalid = (SELECT COUNT(1) FROM dbo.Login WHERE username = @Admin_id AND password = @Password)

SELECT	@Isvalid as N'@Isvalid'
END
GO
/****** Object:  StoredProcedure [dbo].[validCNP]    Script Date: 1/24/2022 9:23:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[validCNP]
	-- Add the parameters for the stored procedure here
	@first_name varchar(25),
	@last_name varchar(25),
	@cnp varchar(50),
	@error varchar(50) OUT
AS
BEGIN TRY
	DECLARE @login_id int
	IF EXISTS(SELECT * FROM dbo.Clients WHERE CNP= @cnp)
		THROW 51002, 'INNCORECT CNP', 1
	ELSE
		BEGIN TRY
			SELECT @login_id = [dbo].[getClientGeneratedId]()
			INSERT INTO dbo.Clients(first_name, last_name, cnp, login_id)
			VALUES (@first_name, @last_name, @cnp, @login_id)
		END TRY
		BEGIN CATCH
			SELECT ERROR_MESSAGE() AS Error
		END CATCH
END TRY
BEGIN CATCH
	SELECT ERROR_MESSAGE() AS Error
	SET @error = ERROR_MESSAGE()
END CATCH
GO
/****** Object:  Trigger [dbo].[Delete_Animal]    Script Date: 1/24/2022 9:23:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[Delete_Animal] ON [dbo].[Animals]
INSTEAD OF DELETE
AS
    SELECT * INTO #DeletedParent -- save the values in a temp table
    FROM [deleted]
    -- have a variable to hold values from each row
    DECLARE @RowValues TABLE (animal_id INT, animal_name VARCHAR(50), client_id int)
    -- iterate through all the deleted records
    WHILE (EXISTS(SELECT TOP 1 * FROM #DeletedParent))
    BEGIN
        -- extract the values you need from the temp table 
        INSERT INTO @RowValues  SELECT TOP 1 [animal_id], [name], [client_id]
        FROM #DeletedParent
        
        DECLARE @id INT
        SELECT  TOP 1 @id = animal_id FROM #DeletedParent
        -- Delete the children
        DELETE FROM Appointments WHERE animal_id = @id

        DELETE FROM Animals WHERE animal_id = @id
       -- delete the row from the temp table
       DELETE FROM #DeletedParent WHERE animal_id = @id
	  END
GO
ALTER TABLE [dbo].[Animals] ENABLE TRIGGER [Delete_Animal]
GO
/****** Object:  Trigger [dbo].[AddHistory]    Script Date: 1/24/2022 9:23:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   TRIGGER [dbo].[AddHistory] ON [dbo].[Appointments]
AFTER DELETE
AS 
BEGIN

	DECLARE @client_id int, 
	@service_name varchar(50),
	@animal_name varchar(50),
	@doctor_name varchar(50);

	--id client a carui programare a fost stearsa
	SELECT @client_id = A.client_id,
	@animal_name = A.name
	FROM deleted JOIN Animals A
	ON deleted.animal_id = A.animal_id;



	SELECT @service_name = S.name, @doctor_name = D.first_name +' '+ D.last_name
	FROM Doctors D,
	deleted JOIN Services S
	ON deleted.service_id = S.service_id
	WHERE D.doctor_id = S.doctor_id;

	INSERT INTO Appointments_History
	SELECT @client_id, D.data , @animal_name, @service_name, @doctor_name
	FROM deleted D;

END
GO
ALTER TABLE [dbo].[Appointments] ENABLE TRIGGER [AddHistory]
GO
/****** Object:  Trigger [dbo].[Delete_client]    Script Date: 1/24/2022 9:23:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  TRIGGER [dbo].[Delete_client] ON [dbo].[Clients]
INSTEAD OF DELETE
AS
    -- note: in some SQL languages # means a comment, in TSQL it's 
    -- a prefix for a temporary table
    SELECT * INTO #DeletedParent -- save the values in a temp table
    FROM [deleted]
    -- have a variable to hold values from each row
    DECLARE @RowValues TABLE (client_id int)
    -- iterate through all the deleted records
    WHILE (EXISTS(SELECT TOP 1 * FROM #DeletedParent))
    BEGIN
        -- extract the values you need from the temp table 
        INSERT INTO @RowValues  SELECT TOP 1 [client_id]
        FROM #DeletedParent
        
        DECLARE @id INT
        SELECT  TOP 1 @id = client_id FROM #DeletedParent
        -- Delete the children
        DELETE FROM Animals WHERE client_id = @id
        DELETE FROM Clients WHERE client_id = @id
       -- delete the row from the temp table
       DELETE FROM #DeletedParent WHERE client_id = @id
    END;
GO
ALTER TABLE [dbo].[Clients] ENABLE TRIGGER [Delete_client]
GO
USE [master]
GO
ALTER DATABASE [Clinic] SET  READ_WRITE 
GO
