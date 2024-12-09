-- Find order items
SELECT 
    i.ItemID,
    i.iDescription AS ItemDescription,
    i.mainCategory,
    i.subCategory,
    p.pieceNum,
    p.pDescription AS PieceDescription,
    p.roomNum,
    p.shelfNum
FROM ItemIn ii
JOIN Item i ON ii.ItemID = i.ItemID
LEFT JOIN Piece p ON i.ItemID = p.ItemID
-- LEFT JOIN 
--     Location l ON p.roomNum = l.roomNum AND p.shelfNum = l.shelfNum
WHERE ii.orderID = :orderID;

select * from Person; 
select * from ordered;

SELECT supervisor, COUNT(*) as task_count
FROM Ordered
WHERE orderDate >= '2020-1-1'
GROUP BY supervisor
ORDER BY task_count DESC;

SELECT o.orderID, o.orderDate, o.status 
FROM Ordered as o
WHERE o.supervisor = 'frank';

select * from category;

select * from Person where userName='frank';

select * from Role
-- User orders
SELECT 
    o.orderID, 
    o.orderDate, 
    d.status, 
FROM Ordered as o
Join Delivered as d on o.orderID = d.orderID
WHERE o.client = %s;

INSERT INTO Act (userName, roleID) VALUES ('frank', 'staff')

