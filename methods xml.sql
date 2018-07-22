
--XML methods
--всё стер к хренам
--branch new_xml_method
/*
select 
	*
from dbo.tArtist
*/

-- метод query
SELECT 
	name
	,xmlData.query('/albums/album[2]/song[1]') AS SecondAlbumLabel
FROM dbo.tArtist;

SELECT 
	name, 
	xmlData.query ('/albums/album/labels[label[contains(., "Capitol")]]') AS ContainsRecord
FROM dbo.tArtist;

SELECT 
	name, 
	xmlData.query ('/albums/album[2]/labels/label[1]') AS ContainsRecord
FROM dbo.tArtist;

--метод value
SELECT 
	name, 
	xmlData.value('/albums[1]/album[2]/labels[1]/label[1]/text()[1]', 'varchar(100)') AS SecondAlbumLabel
FROM dbo.tArtist;

SELECT 
	  name
    , xmlData.value('/albums[1]/album[1]/@title', 'varchar(100)') AS FirstAlbum
    , xmlData.value('/albums[1]/album[1]/song[1]/@title', 'varchar(100)') AS FirstSongTitle
    , xmlData.value('/albums[1]/album[1]/song[1]/@length', 'time(0)') AS FirstSongLength
FROM dbo.tArtist;


SELECT name AS artist
  , xmlData.value('/albums[1]/album[1]/@title', 'varchar(100)') AS FirstAlbum
  , xmlData.value('/albums[1]/album[1]/song[1]/@title', 'varchar(100)') AS FirstSongTitle
  , xmlData.value('concat("00:", /albums[1]/album[1]/song[1]/@length)', 'time(0)') 
AS FirstSongLength
FROM dbo.tArtist;

--метод exist

SELECT 
	name
	, xmlData.exist('/albums[1]/album/song[@title="Garden of Eden"]') AS SongExists
FROM dbo.tArtist;

SELECT name
    , xmlData.exist('
        /albums[1]/album/song/@length[
                                    (
                                    if (string-length(.) = 4)
                                    then xs:time(concat("00:0", .))
                                    else xs:time(concat("00:", .))
                                    )
                                    > xs:time("00:10:00")
                                ]') AS LongSongExists
FROM dbo.tArtist;

--метод modify

SELECT xmlData.query('(/albums/album[@title="OK Computer"]/labels/label/text())[1]') 
AS FirstLabelText
FROM dbo.tArtist 
WHERE name = 'Radiohead';

 
 
SELECT name, 
xmlData.value('(/albums/album[2]/labels/label/text())[2]', 'varchar(100)') AS SecondAlbumLabel
FROM dbo.tArtist;


begin tran
select
	name
	,xmlData.query('(/albums/album[2]/labels/label)[1]')
from dbo.tArtist


update
	dbo.tArtist
set xmlData.modify('delete (/albums/album[2]/labels/label)[1]')
where
	name = 'Guns N'' Roses'

select
	*
from dbo.tArtist
rollback

--метод nodes()
SELECT name AS artist
    , album.query('.') AS album
FROM dbo.tArtist A
CROSS APPLY A.xmlData.nodes('/albums/album[2]/labels/label')col(album);


SELECT 
	name AS artist
	--, song.query('.')
    , song.value('../@title', 'varchar(50)') AS album
    , song.value('@title', 'varchar(100)') AS song
FROM dbo.tArtist A
	CROSS APPLY A.xmlData.nodes('/albums[1]/album[2]/song')col(song)
where
	A.name = 'Radiohead'

SELECT name AS artist
    , album.value('@title', 'varchar(50)') AS album
    , song.value('@title', 'varchar(100)') AS song
FROM dbo.tArtist A
	CROSS APPLY A.xmlData.nodes('/albums[1]/album')c1(album)
	CROSS APPLY c1.album.nodes('song[position()<=2]')c2(song)
where
	A.name = 'Radiohead'
	
--new метод
/*
dfdfdf
dfdfdf*/	
