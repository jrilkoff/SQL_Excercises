/* SQL Exercise
====================================================================
We will be working with database chinook.db
You can download it here: https://drive.google.com/file/d/0Bz9_0VdXvv9bWUtqM0NBYzhKZ3c/view?usp=sharing&resourcekey=0-7zGUhDz0APEfX58SA8UKog

 The Chinook Database is about an imaginary video and music store. Each track is stored using one of the digital formats and has a genre. 
 The store has also some playlists, where a single track can be part of several playlists. Orders are recorded for customers, but are called invoices. 
 Every customer is assigned a support employee, and Employees report to other employees.
*/


-- MAKE YOURSELF FAIMLIAR WITH THE DATABASE AND TABLES HERE





--==================================================================
/* TASK I
Which artists did not make any albums at all? Include their names in your answer.
*/

SELECT DISTINCT(artists.Name), albums.AlbumId FROM artists
    LEFT OUTER JOIN albums ON albums.ArtistId = artists.ArtistId
    WHERE albums.AlbumId IS NULL;
    
/* TASK II
Which artists recorded any tracks of the Latin genre?
GOOD*/

SELECT DISTINCT(artists.Name) FROM artists
    JOIN albums ON albums.ArtistId = artists.ArtistId
    JOIN tracks ON albums.AlbumID = tracks.AlbumId
    JOIN genres ON genres.GenreID = tracks.GenreID
    WHERE genres.Name LIKE 'Latin';

/* TASK III
Which video track has the longest length?
*/

SELECT tracks.Name, Milliseconds FROM tracks
    JOIN media_types ON media_types.MediaTypeId = tracks.MediaTypeId
    WHERE media_types.MediaTypeId = 3
    ORDER BY Milliseconds DESC LIMIT 1;

/* TASK IV
Find the names of customers who live in the same city as the top employee (The one not managed by anyone).
*/

SELECT customers.FirstName, customers.LastName FROM customers
    JOIN employees ON employees.EmployeeId = customers.SupportRepId
    WHERE customers.City IN (SELECT employees.City FROM employees WHERE employees.ReportsTo IS NULL);

/* TASK V
Find the managers of employees supporting Brazilian customers.
*/

SELECT DISTINCT(manager.EmployeeId), manager.FirstName, manager.LastName FROM employees
    JOIN employees manager ON employees.ReportsTo = manager.ReportsTo
    WHERE manager.EmployeeId IN 
        (SELECT employees.ReportsTo FROM employees WHERE employees.EmployeeId IN 
            (SELECT customers.SupportRepId FROM customers WHERE customers.Country LIKE 'Brazil'));


/* TASK VI
Which playlists have no Latin tracks?
*/

SELECT DISTINCT(playlists.Name) FROM playlists
    JOIN playlist_track ON playlist_track.PlaylistId = playlists.PlaylistId
    JOIN tracks ON playlist_track.TrackId = tracks.TrackId
    JOIN genres ON genres.GenreId = tracks.GenreId
    WHERE genres.Name NOT LIKE 'Latin';