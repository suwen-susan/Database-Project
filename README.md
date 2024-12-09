# Database-Project

Suwen Wang: sw6359

Yifei Xu: yx3590

Eduarda Ramos: er3410



#### Languages and frameworks:

Python and flask



#### Changes to the schema:

1. On the Ordered table:

   - it was added status column with a **CHECK** constraint allowing specific values ('pending', 'placed', 'preparing', 'ready for delivery', 'shipped', 'complete', 'returned');

   - supervisor column has a default value of 'unassigned' (we add an 'unassigned' record in Person)

2. On the Delivered table:

   - the status column was removed

3. On the Role table:

   - the check constraint to the roleID was added

4. On the Item table:

   - hasPiece column was deleted (we assume that each item has at least one piece)



#### Main queries:

1. Login & User Session Handling:

   - Register:

     ```sql
     INSERT INTO Person (userName, password, fname, lname,email), 
     VALUES (%s, %s, %s, %s, %s)
     ```

   - Login

     ```sql
     SELECT * FROM Person WHERE userName = %s
     ```

   - Check if a person is staff

     ```sql
     SELECT roleID FROM Act WHERE userName = %s
     ```

2. Find Single Item

   when the user enter an itemID, we return the locations of all pieces of that item

   ```sql
   SELECT p.pieceNum, p.roomNum, p.shelfNum, l.shelfDescription, l.shelf
   FROM Piece p
   JOIN Location l ON (p.roomNum = l.roomNum AND p.shelfNum = l.shelfNum)
   WHERE p.ItemID = %s AND p.shelfNum != -1;
   
   ```

   

3. Find Order Items:

   - If user is not staff

     ```sql
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
     WHERE ii.orderID = %s AND p.shelfNum != -1
     
     ```

   - If user is staff

     ```sql
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
     WHERE ii.orderID = %s;
     ```

4. Accept Donation:

   ```sql
   INSERT INTO Piece (ItemID, pieceNum, pDescription, length, width, height, roomNum, shelfNum, pNotes)
   VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
   ''',
   (
       item_id,
       piece_nums[i],
       pDescriptions[i],
       lengths[i],
       widths[i],
       heights[i],
       roomNums[i],
       shelfNums[i],
       pNotes_list[i] )
   
   ```

5. Start an order:

   - First we check if the user is staff:

     ```sql
     SELECT roleID FROM Act WHERE userName = %s
     ```

   - If it is a staff, it shows the pending orders:

     ```sql
     SELECT 
         o.orderID, 
         o.client,
         o.orderDate, 
         o.status
     FROM Ordered as o
     WHERE o.status = 'pending'
     ```

     And it allows the user to write a userName, check if it exists

     ```sql
     SELECT * FROM person WHERE userName = %s
     ```

   - After checking that, the staff can update the order

     ```sql
     UPDATE Ordered
     SET status = "placed", supervisor = %s
     WHERE orderID = %s
     ```

6. Add to current order:

   - In a session, it shows categories that have item available to order and that are not already added to the shopping bag

     ```sql
     SELECT DISTINCT c.mainCategory 
     FROM Category c
     JOIN Item i ON c.mainCategory = i.mainCategory AND c.subCategory = i.subCategory
     WHERE i.ItemID NOT IN (SELECT ItemID FROM ItemIn) AND i.ItemID NOT IN ({})
                 """.format(",".join(["%s"] * len(selected_items))), selected_items)
     
     ```

     Show subcategories from the chosen category that have item available to order and that are not already added to the shopping bag

     ```sql
     SELECT DISTINCT c.subCategory 
     FROM Category c
     JOIN Item i ON c.mainCategory = i.mainCategory AND c.subCategory = i.subCategory
     WHERE i.ItemID NOT IN (SELECT ItemID FROM ItemIn) AND c.mainCategory = %s AND i.ItemID NOT IN ({})
                     """.format(",".join(["%s"] * len(selected_items))), (selected_category,) + tuple(selected_items))
     
     ```

   - Show items from the subcategory and category chosen that have item available to order and that are not already added to the shopping bag

     ```sql
     SELECT i.ItemID, i.iDescription 
     FROM Item i
     WHERE i.ItemID NOT IN (SELECT ItemID FROM ItemIn) AND i.mainCategory = %s AND i.subCategory = %s AND i.ItemID NOT IN ({})
                     """.format(",".join(["%s"] * len(selected_items))), (selected_category, selected_subcategory) + tuple(selected_items))format(",".join(["%s"] * len(selected_items))), (selected_category,) + tuple(selected_items))
     
     ```

   - After select an Item, we can add it to the Shopping Bag

     In the Shopping Bag we can 

     ```sql
     -- see the items chosen with:
     SELECT ItemID, iDescription, mainCategory, subCategory FROM Item WHERE ItemID IN (%s)
     -- place the order with the items in the Shopping Bag with:
     INSERT INTO Ordered (orderDate, orderNotes, status, client) VALUES (CURDATE(), %s, "pending", %s)
     INSERT INTO ItemIn (orderID, ItemID) VALUES (%s, %s)
     delete Items
     
     ```

     

7. Prepare order:

   - search for order:


     ```sql
     -- search for orderID
     SELECT * FROM Ordered WHERE orderID = %s
     
     -- search for username
     SELECT * FROM Ordered WHERE client = %s
     
     -- show order information
     SELECT status FROM Ordered WHERE orderID = %s
     
     ```

   - update location:

     ```sql
     UPDATE Piece
                 SET roomNum = %s, shelfNum = %s
                 WHERE ItemID IN (SELECT ItemID FROM ItemIn WHERE orderID = %s);
     
     ```

   - update order status

     ```sql
     UPDATE Ordered
                 SET status = 'ready for delivery'
                 WHERE orderID = %s;
     
     ```

8. User’s tasks:

   - Query to fetch client orders

     ```sql
     SELECT 
                     o.orderID, 
                     o.orderDate, 
                     o.status 
                 FROM Ordered as o
                 WHERE o.client = %s
     
     ```

   - Query to fetch supervisor orders

     ```sql
     SELECT 
                     o.orderID, 
                     o.orderDate, 
                     o.status 
                 FROM Ordered as o
                 WHERE o.supervisor = %s
     
     ```

   - Query to fetch volunteer orders

     ```sql
     SELECT 
                     o.orderID, 
                     o.orderDate, 
                     o.status 
                 FROM Ordered as o
                 Join Delivered as d on o.orderID = d.orderID
                 WHERE d.userName = %s
     
     ```

9.  Rank System:

   ```sql
   SELECT supervisor, COUNT(*) as task_count
               FROM Ordered
               WHERE orderDate >= %s
               GROUP BY supervisor
               ORDER BY task_count DESC
   
   ```

10. Update enabled:

    - Check availability (is current user the supervisor or driver for the order)

      ```sql
       SELECT *
                      FROM Ordered as o
                      WHERE o.supervisor = %s and o.orderID = %s
      
          SELECT *
                      From Delivered as d
                      WHERE d.userName = %s and d.orderID = %s
      
      ```

    - Update status

      ```sql
      UPDATE Ordered
                  SET status = %s WHERE orderID = %s
      
      ```



#### **Difficulties encountered & lessons learned:**

The most difficult part was about session handling, especially the ordering part. At first, we did not understand what a session means and how it works, so we had difficulties about how to order multiple items in one order. We then figured out how to store temporary data in the session, so we created a shopping bag and added features to it.

We also learned that we should first set up coding standards before each person begins to write their parts. When we finished developing, we found that though the code works separately, the merging was hard as we used different ways to store data and to organize folders. We had to rewrite some parts and delete some front-end codes to make it work.



#### Details of division:

**Suwen Wang:**

- 1.Login & User Session Handling
- 3.Find Order Items
- 8.User’s tasks
- 10.Update enabled
- Cooperated in Confirm Order
- Cooperated in session handling (shopping bag etc.)
- Cooperated in merging the code
- Cooperated in User interface design
- Cooperated in creating test data 

**Yifei Xu:**

- 4.Accept Donation
- 7.Prepare order

- 9.Rank System
- Cooperated in Access Control

- Cooperated in merging the code
- Cooperated in creating test data 

**Eduarda Ramos:**

- 2.Find Single Item
- 5.Start an order
- 6.Shopping / Add item to shopping baf
- Cooperated in User interface design
- Cooperated in creating test data 
