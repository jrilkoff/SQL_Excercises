/* SQL Stretch Exercise
====================================================================
We will be working with database chinook.db
You can download it here: https://drive.google.com/file/d/0Bz9_0VdXvv9bWUtqM0NBYzhKZ3c/view?usp=sharing&resourcekey=0-7zGUhDz0APEfX58SA8UKog

 The Chinook Database is about an imaginary video and music store. Each track is stored using one of the digital formats and has a genre. The store has also some playlists, where a single track can be part of several playlists. Orders are recorded for customers, but are called invoices. Every customer is assigned a support employee, and Employees report to other employees.
*/


--==================================================================
/* TASK I
How many audio tracks in total were bought by German customers? And what was the total price paid for them?
hint: use subquery to find all of tracks with their prices
*/

SELECT DISTINCT(invoices.BillingCountry), media_types.Name, SUM(invoice_items.Quantity), SUM(invoice_items.UnitPrice)
    FROM invoice_items
        JOIN invoices ON invoice_items.InvoiceId = invoices.InvoiceId
        JOIN tracks ON tracks.TrackId = invoice_items.TrackId
        JOIN media_types ON media_types.MediaTypeId = tracks.MediaTypeId
        WHERE invoices.BillingCountry IN 
            (SELECT customers.Country FROM customers WHERE customers.Country = 'Germany' AND media_types.MediaTypeId != 3)
    GROUP BY media_types.MediaTypeId;

/* TASK II
What is the space, in bytes, occupied by the playlist “Grunge” # 16, and how much would it cost?
(Assume that the cost of a playlist is the sum of the price of its constituent tracks).
*/

SELECT pl.Name, SUM(t.Bytes), SUM(t.UnitPrice)
FROM tracks t
    JOIN playlist_track pt ON pt.TrackID = t.TrackId
    JOIN playlists pl ON pl.PlaylistId = pt.PlaylistId
WHERE pl.Name = 'Grunge'

/* TASK III
List the names and the countries of those customers who are supported by an 
employee who was younger than 35 when hired. 
*/

SELECT * FROM employees;

SELECT c.FirstName, c.LastName, c.Country FROM employees e
    JOIN customers c ON c.SupportRepId = e.EmployeeId
WHERE (e.HireDate - e.BirthDate) < 35 AND e.Title LIKE '%SALES%';
