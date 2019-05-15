
-----------------------------------------------------------------------------------------------

USE master;
GO

-- Переводим БД в single-user mode
ALTER DATABASE [FilmsDB]
SET SINGLE_USER WITH ROLLBACK IMMEDIATE
GO

-- Меняем кодировку COLLATION
ALTER DATABASE [FilmsDB]
COLLATE Cyrillic_General_CI_AS ;
GO

-- Переводим БД обратно в multi-user mode
ALTER DATABASE [FilmsDB]
SET MULTI_USER WITH ROLLBACK IMMEDIATE;
GO  
 
--Проверяем настройки COLLATION.
SELECT name, collation_name
FROM sys.databases
WHERE name = 'FilmsDB';
GO

-----------------------------------------------------------------------------------------------

CREATE TABLE [dbo].[Actor] (
    [ActorId]   BIGINT         NOT NULL,
    [ActorName] NVARCHAR (100) NOT NULL,
    CONSTRAINT [PK_Actor] PRIMARY KEY CLUSTERED ([ActorId] ASC)
);

INSERT INTO [dbo].[Actor]
VALUES
(1, 'Георгий Вицин'),
(2, 'Юрий Никулин'),
(3, 'Евгений Моргунов'),
(4, 'Мэттью МакКонахи'),
(5, 'Энн Хэтэуэй'),
(6, 'Джессика Честейн');

CREATE TABLE [dbo].[Country] (
    [CountryId]   BIGINT         NOT NULL,
    [CountryName] NVARCHAR (100) NOT NULL,
    CONSTRAINT [PK_Country] PRIMARY KEY CLUSTERED ([CountryId] ASC)
);

INSERT INTO [dbo].[Country]
VALUES
(1, 'Россия'),
(2, 'США'),
(3, 'Франция'),
(4, 'Великобритания'),
(5, 'Германия'),
(6, 'Япония'),
(7, 'Китай');

CREATE TABLE [dbo].[Director] (
    [DirectorId]   BIGINT         NOT NULL,
    [DirectorName] NVARCHAR (100) NOT NULL,
    CONSTRAINT [PK_Director] PRIMARY KEY CLUSTERED ([DirectorId] ASC)
);

INSERT INTO [dbo].[Director]
VALUES
(1, 'Леонид Гайдай'),
(2, 'Кристофер Нолан');

CREATE TABLE [dbo].[Ganre] (
    [GanreId]   BIGINT        NOT NULL,
    [GanreName] NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_Genre] PRIMARY KEY CLUSTERED ([GanreId] ASC)
);

INSERT INTO [dbo].[Ganre]
VALUES
(1, 'Комедия'),
(2, 'Боевик'),
(3, 'Драма'),
(4, 'Мелодрама'),
(5, 'Триллер'),
(6, 'Ужасы'),
(7, 'Фантастика'),
(8, 'Научная фантастика');

CREATE TABLE [dbo].[Film] (
    [FilmId]     BIGINT         IDENTITY (1, 1) NOT NULL,
    [FilmName]   NVARCHAR (100) NOT NULL,
    [Year]       INT            NULL,
    [CountryId]  BIGINT         NULL,
    [DirectorId] BIGINT         NULL,
    [Notice]     NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_Film] PRIMARY KEY CLUSTERED ([FilmId] ASC),
    CONSTRAINT [FK_Film_To_Country] FOREIGN KEY ([CountryId]) REFERENCES [dbo].[Country] ([CountryId]) ON DELETE SET NULL,
    CONSTRAINT [FK_Film_To_Director] FOREIGN KEY ([DirectorId]) REFERENCES [dbo].[Director] ([DirectorId]) ON DELETE SET NULL,
    CHECK ([Year]>(1900) AND [Year]<(2100))
);

INSERT INTO [dbo].[Film]
VALUES
('Кавказская пленница', 1967, 1, 1, 'Комедийный фильм Кавказская пленница'),
('Интерстеллар', 2014, 2, 2, 'Научно-фантастический фильм про космос');

INSERT INTO [dbo].[Film]
VALUES
('Кавказская пленница2', 1969, 1, 1, 'Комедийный фильм Кавказская пленница2');

CREATE TABLE [dbo].[FilmActor] (
    [FilmActorId]      BIGINT IDENTITY (1, 1) NOT NULL,
    [FilmId]  BIGINT NOT NULL,
    [ActorId] BIGINT NOT NULL,
    CONSTRAINT [PK_FilmActor] PRIMARY KEY CLUSTERED ([FilmActorId] ASC),
    CONSTRAINT [FK_FilmActor_To_Film] FOREIGN KEY ([FilmId]) REFERENCES [dbo].[Film] ([FilmId]) ON DELETE CASCADE,
    CONSTRAINT [FK_FilmActor_To_Actor] FOREIGN KEY ([ActorId]) REFERENCES [dbo].[Actor] ([ActorId]) ON DELETE CASCADE
);

INSERT INTO [dbo].[FilmActor]
VALUES
(1, 1),
(1, 2),
(1, 3),
(2, 4),
(2, 5),
(2, 6);

CREATE TABLE [dbo].[FilmGanre] (
    [FilmGanreId]      BIGINT IDENTITY (1, 1) NOT NULL,
    [FilmId]  BIGINT NOT NULL,
    [GanreId] BIGINT NOT NULL,
    CONSTRAINT [PK_FilmGanre] PRIMARY KEY CLUSTERED ([FilmGanreId] ASC),
    CONSTRAINT [FK_FilmGanre_To_Film] FOREIGN KEY ([FilmId]) REFERENCES [dbo].[Film] ([FilmId]) ON DELETE CASCADE,
    CONSTRAINT [FK_FilmGanre_To_Ganre] FOREIGN KEY ([GanreId]) REFERENCES [dbo].[Ganre] ([GanreId]) ON DELETE CASCADE
);

INSERT INTO [dbo].[FilmGanre]
VALUES
(1, 1),
(1, 4),
(2, 3),
(2, 7),
(2, 8);

CREATE FUNCTION [dbo].[FilmList](@filmId BIGINT) RETURNS nvarchar(max)
BEGIN
	RETURN (
SELECT f.FilmId,
       f.FilmName,
	   f.Year,
	   f.Notice,
	   f.CountryId,
	   f.DirectorId,

	   JSON_QUERY((
          SELECT TOP 1
		         c.CountryId,
                 c.CountryName
            FROM dbo.Country c
           WHERE c.CountryId = f.CountryId
		     FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
	   )) AS Country,

	   JSON_QUERY((
          SELECT TOP 1
		         d.DirectorId,
                 d.DirectorName
            FROM dbo.Director d
           WHERE d.DirectorId = f.DirectorId
		     FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
	   )) AS Director,

	   JSON_QUERY((
          SELECT g.GanreId,
                 g.GanreName
            FROM dbo.Ganre g
           INNER JOIN dbo.FilmGanre fg ON fg.GanreId = g.GanreId
           WHERE fg.FilmId = f.FilmId
		     FOR JSON PATH
	   )) AS GanreList,

	   JSON_QUERY((
          SELECT a.ActorId,
                 a.ActorName
            FROM dbo.Actor a
           INNER JOIN dbo.FilmActor fa ON fa.ActorId = a.ActorId
           WHERE fa.FilmId = f.FilmId
		     FOR JSON PATH
	   )) AS ActorList

  FROM dbo.Film f
 WHERE f.FilmId = @filmId OR @filmId IS NULL
   FOR JSON PATH
 );  
END


CREATE PROCEDURE [dbo].[FilmDelete] @filmId AS BIGINT
AS
DELETE FROM dbo.Film WHERE FilmId = @filmId;


CREATE PROCEDURE [dbo].[FilmSave] @filmJson NVARCHAR(MAX)
AS
DECLARE
  @filmId BIGINT

IF (ISJSON(@filmJson) > 0)
BEGIN
	-- Добавление
    IF (select JSON_VALUE(@filmJson, '$.FilmId')) = 0
	BEGIN
	    WITH
			a AS (
				SELECT JSON_VALUE(@filmJson, '$.FilmId') AS FilmId,
				       JSON_VALUE(@filmJson, '$.FilmName') AS FilmName,
					   JSON_VALUE(@filmJson, '$.Year') AS [Year],
					   JSON_VALUE(@filmJson, '$.Notice') AS Notice,
					   JSON_VALUE(@filmJson, '$.CountryId') AS CountryId,
					   JSON_VALUE(@filmJson, '$.DirectorId') AS DirectorId
			)
		INSERT INTO dbo.Film (FilmName, Year, CountryId, DirectorId, Notice)
		SELECT FilmName, Year, CountryId, DirectorId, Notice
		  FROM a;

        SET @filmId = SCOPE_IDENTITY();
	END;

	-- Изменение
	ELSE BEGIN
		SET @filmId = JSON_VALUE(@filmJson,'$.FilmId');

		WITH
			a AS (
				SELECT JSON_VALUE(@filmJson, '$.FilmId') AS FilmId,
				       JSON_VALUE(@filmJson, '$.FilmName') AS FilmName,
					   JSON_VALUE(@filmJson, '$.Year') AS [Year],
					   JSON_VALUE(@filmJson, '$.Notice') AS Notice,
					   JSON_VALUE(@filmJson, '$.CountryId') AS CountryId,
					   JSON_VALUE(@filmJson, '$.DirectorId') AS DirectorId
			)
		UPDATE dbo.Film
		   SET FilmName = a.FilmName,
		       Year = a.Year,
			   CountryId = a.CountryId,
			   DirectorId = a.DirectorId,
			   Notice = a.Notice
          FROM a
		 WHERE Film.FilmId = a.FilmId;

		 DELETE FROM dbo.FilmGanre WHERE FilmId = @filmId;
		 DELETE FROM dbo.FilmActor WHERE FilmId = @filmId;		
	END;

	-- Жанры
	WITH
		b AS (
			SELECT @filmId AS FilmId, GanreId  
              FROM OPENJSON(@filmJson)
                   WITH (FilmId BIGINT 'strict $.FilmId', GanreList NVARCHAR(MAX) '$.GanreList' AS JSON)
             OUTER APPLY OPENJSON(GanreList) 
                         WITH (GanreId BIGINT '$.GanreId')
		)
	INSERT INTO dbo.FilmGanre(FilmId, GanreId)
	SELECT FilmId, GanreId
      from b
     where GanreId IS NOT NULL;

	-- Актеры
	with
		c as (
			SELECT @filmId AS FilmId, ActorId
              FROM OPENJSON(@filmJson)
                   WITH (FilmId BIGINT 'strict $.FilmId', ActorList NVARCHAR(max) '$.ActorList' AS JSON)
             OUTER APPLY OPENJSON(ActorList) 
                         WITH (ActorId BIGINT '$.ActorId')
		)
	INSERT INTO dbo.FilmActor(FilmId, ActorId)
	SELECT FilmId, ActorId
      from c
     where ActorId IS NOT NULL;

	RETURN @filmId; 
END;
ELSE BEGIN
	RETURN 0;
END;





