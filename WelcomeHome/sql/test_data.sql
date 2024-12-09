-- Active: 1733367263268@@127.0.0.1@3306
USE WelcomeHome;

-- After running the schema creation above, run these inserts to populate test data:
-- Insert Categories
INSERT INTO Category (mainCategory, subCategory, catNotes) VALUES
('Furniture', 'Sofa', 'Comfortable seating furniture'),
('Furniture', 'Chair', 'Various types of chairs'),
('Furniture', 'Table', 'Dining and coffee tables'),
('Electronics', 'TV', 'Television sets of various sizes'),
('Electronics', 'Computer', 'Desktops and Laptops'),
('Kitchenware', 'Plates', 'Different sizes and materials'),
('Kitchenware', 'Cups', 'Mugs and tea cups'),
('Kitchenware', 'Utensils', 'Forks, spoons, knives'),
('Textiles', 'Bedding', 'Sheets, blankets, pillows'),
('Textiles', 'Curtains', 'Window curtains'),
('Decor', 'Lamp', 'Table and floor lamps'),
('Decor', 'Rug', 'Floor rugs of various dimensions');

-- Insert People
-- Since we have only two roles: client and staff, we will assign some as clients and others as staff.
-- Passwords and emails are just examples.
INSERT INTO Person (userName, password, fname, lname, email) VALUES
('staff_alex', 'pass123', 'Alex', 'Johnson', 'alex.johnson@example.com'),
('staff_mary', 'pass456', 'Mary', 'Williams', 'mary.williams@example.com'),
('staff_john', 'pass789', 'John', 'Smith', 'john.smith@example.com'),
('staff_linda', 'passabc', 'Linda', 'Brown', 'linda.brown@example.com'),
('staff_george', 'passdef', 'George', 'Miller', 'george.miller@example.com'),
('client_anna', 'cpass123', 'Anna', 'Jones', 'anna.jones@example.com'),
('client_bob', 'cpass456', 'Bob', 'Davis', 'bob.davis@example.com'),
('client_carol', 'cpass789', 'Carol', 'Garcia', 'carol.garcia@example.com'),
('client_dan', 'cpassabc', 'Dan', 'Rodriguez', 'dan.rodriguez@example.com'),
('client_erin', 'cpassdef', 'Erin', 'Martinez', 'erin.martinez@example.com');

-- Insert PersonPhone
INSERT INTO PersonPhone (userName, phone) VALUES
('staff_alex', '555-123-4567'),
('staff_alex', '555-111-2222'),
('staff_mary', '555-234-5678'),
('staff_john', '555-345-6789'),
('staff_linda', '555-456-7890'),
('staff_george', '555-567-8901'),
('client_anna', '555-987-6543'),
('client_bob', '555-876-5432'),
('client_carol', '555-765-4321'),
('client_dan', '555-654-3210'),
('client_erin', '555-543-2109');

-- Roles already inserted:
-- ('staff', '0'), ('client', '1')

-- Insert Act (assigning roles to persons)
INSERT INTO Act (userName, roleID) VALUES
('staff_alex', 'staff'),
('staff_mary', 'staff'),
('staff_john', 'staff'),
('staff_linda', 'staff'),
('staff_george', 'staff'),
('client_anna', 'client'),
('client_bob', 'client'),
('client_carol', 'client'),
('client_dan', 'client'),
('client_erin', 'client');

-- Insert Locations (roomNum, shelfNum, shelf, shelfDescription)
INSERT INTO Location (roomNum, shelfNum, shelf, shelfDescription) VALUES
(101, 1, 'ShelfA', 'Main Storage Shelf'),
(101, 2, 'ShelfB', 'Lower Storage Shelf'),
(102, 1, 'ShelfC', 'Electronics Shelf'),
(102, 2, 'ShelfD', 'Small Item Shelf'),
(103, 1, 'ShelfE', 'Textiles Shelf'),
(103, 2, 'ShelfF', 'Decorations Shelf'),
(104, 1, 'ShelfG', 'Kitchenware Shelf'),
(104, 2, 'ShelfH', 'Miscellaneous Items Shelf');

-- Insert Items
-- We'll create multiple items across categories
INSERT INTO Item (iDescription, photo, color, isNew, material, mainCategory, subCategory) VALUES
('Leather 3-seater sofa', 'sofa1.jpg', 'Brown', TRUE, 'Leather', 'Furniture', 'Sofa'),
('Fabric armchair', 'chair1.jpg', 'Beige', FALSE, 'Fabric', 'Furniture', 'Chair'),
('Wooden dining table', 'table1.jpg', 'Brown', TRUE, 'Wood', 'Furniture', 'Table'),
('LCD Television 42-inch', 'tv1.jpg', 'Black', FALSE, 'Plastic/Metal', 'Electronics', 'TV'),
('Laptop i7 processor', 'comp1.jpg', 'Silver', TRUE, 'Metal/Plastic', 'Electronics', 'Computer'),
('Set of ceramic plates', 'plates1.jpg', 'White', TRUE, 'Ceramic', 'Kitchenware', 'Plates'),
('Porcelain tea cups', 'cups1.jpg', 'White', TRUE, 'Porcelain', 'Kitchenware', 'Cups'),
('Stainless steel utensils set', 'utensils1.jpg', 'Silver', FALSE, 'Stainless Steel', 'Kitchenware', 'Utensils'),
('Queen-size bed sheets', 'bedding1.jpg', 'Blue', TRUE, 'Cotton', 'Textiles', 'Bedding'),
('Pair of linen curtains', 'curtains1.jpg', 'Cream', FALSE, 'Linen', 'Textiles', 'Curtains'),
('Desk lamp', 'lamp1.jpg', 'Black', TRUE, 'Metal', 'Decor', 'Lamp'),
('Woolen rug', 'rug1.jpg', 'Red', FALSE, 'Wool', 'Decor', 'Rug');


INSERT INTO Piece (ItemID, pieceNum, pDescription, length, width, height, roomNum, shelfNum, pNotes) VALUES
(1, 1, 'Main sofa body', 200, 90, 80, 101, 1, 'Leather body'),
(1, 2, 'Cushion set', 50, 50, 20, 101, 2, 'Two cushions');

-- Plates (ItemID=6) - set of 4 plates, identical pieces
INSERT INTO Piece (ItemID, pieceNum, pDescription, length, width, height, roomNum, shelfNum, pNotes) VALUES
(6, 1, 'Plate 1', 25, 25, 2, 104, 1, 'Ceramic plate'),
(6, 2, 'Plate 2', 25, 25, 2, 104, 1, 'Ceramic plate'),
(6, 3, 'Plate 3', 25, 25, 2, 104, 1, 'Ceramic plate'),
(6, 4, 'Plate 4', 25, 25, 2, 104, 1, 'Ceramic plate');

-- Cups (ItemID=7) - set of 6 cups
INSERT INTO Piece (ItemID, pieceNum, pDescription, length, width, height, roomNum, shelfNum, pNotes) VALUES
(7, 1, 'Cup 1', 8, 8, 10, 104, 2, 'Porcelain cup'),
(7, 2, 'Cup 2', 8, 8, 10, 104, 2, 'Porcelain cup'),
(7, 3, 'Cup 3', 8, 8, 10, 104, 2, 'Porcelain cup'),
(7, 4, 'Cup 4', 8, 8, 10, 104, 2, 'Porcelain cup'),
(7, 5, 'Cup 5', 8, 8, 10, 104, 2, 'Porcelain cup'),
(7, 6, 'Cup 6', 8, 8, 10, 104, 2, 'Porcelain cup');

-- Utensils (ItemID=8) - set of fork, spoon, knife (3 pieces)
INSERT INTO Piece (ItemID, pieceNum, pDescription, length, width, height, roomNum, shelfNum, pNotes) VALUES
(8, 1, 'Fork set', 20, 2, 2, 104, 2, '4 forks'),
(8, 2, 'Spoon set', 20, 2, 2, 104, 2, '4 spoons'),
(8, 3, 'Knife set', 20, 2, 2, 104, 2, '4 knives');

-- Items donated by people (DonatedBy)
-- Let's assume staff don't donate; only clients donate. Or we can mix.
INSERT INTO DonatedBy (ItemID, userName, donateDate) VALUES
(1, 'client_anna', '2024-01-10'),
(2, 'client_bob', '2024-02-14'),
(3, 'client_anna', '2024-02-20'),
(4, 'client_carol', '2024-03-05'),
(5, 'client_dan', '2024-04-11'),
(6, 'client_erin', '2024-05-22'),
(7, 'client_bob', '2024-06-30'),
(8, 'client_carol', '2024-07-19'),
(9, 'client_erin', '2024-08-10'),
(10, 'client_anna', '2024-09-01'),
(11, 'client_dan', '2024-09-15'),
(12, 'client_carol', '2024-10-01');

-- Insert Orders
-- Orders must have a supervisor (staff) and a client
INSERT INTO Ordered (orderDate, orderNotes, status, supervisor, client) VALUES
('2024-10-10', 'Urgent order for furnishing', 'pending', 'staff_alex', 'client_anna'),
('2024-10-12', 'Electronics request', 'placed', 'staff_mary', 'client_bob'),
('2024-10-15', 'Kitchenware bundle', 'shipped', 'staff_john', 'client_carol'),
('2024-10-20', 'Textiles order', 'complete', 'staff_linda', 'client_dan'),
('2024-10-25', 'Mixed decor request', 'pending', 'staff_george', 'client_erin'),
('2024-11-01', 'Additional furniture', 'placed', 'staff_alex', 'client_bob'),
('2024-11-05', 'Bed and curtains set', 'shipped', 'staff_mary', 'client_anna');

-- For these orders, we reference existing Items
-- Insert ItemIn (which items are in which order)
-- orderID will increment from 1 upwards
-- Let’s say orderID=1: wants sofa (1), chair(2)
INSERT INTO ItemIn (ItemID, orderID, found) VALUES
(1, 1, TRUE),
(2, 1, FALSE),
(4, 2, TRUE),
(5, 2, TRUE),
(6, 3, TRUE),
(7, 3, TRUE),
(9, 4, TRUE),
(11, 5, FALSE),
(12, 5, FALSE),
(3, 6, TRUE),
(10, 7, TRUE);

-- Insert Delivered (who delivered which order and when)
-- Usually a staff userName delivering an order
INSERT INTO Delivered (userName, orderID, date) VALUES
('staff_alex', 1, '2024-10-11'),  -- Alex delivered order 1
('staff_john', 3, '2024-10-16'),  -- John delivered order 3
('staff_linda', 4, '2024-10-21'); -- Linda delivered order 4

-- This should provide a comprehensive set of test data.

-- Insert more Roles (Already inserted are 'staff' and 'client', so we skip that)

-- Add many People (both staff and clients)
-- We'll create 15 staff and 20 clients total (including the ones we already inserted previously).
-- Already inserted staff: staff_alex, staff_mary, staff_john, staff_linda, staff_george
-- Already inserted clients: client_anna, client_bob, client_carol, client_dan, client_erin
-- Let's add more staff:
INSERT INTO Person (userName, password, fname, lname, email) VALUES
('staff_henry', 'pass001', 'Henry', 'Adams', 'henry.adams@example.com'),
('staff_irene', 'pass002', 'Irene', 'Baker', 'irene.baker@example.com'),
('staff_james', 'pass003', 'James', 'Carter', 'james.carter@example.com'),
('staff_kate', 'pass004', 'Kate', 'Dunn', 'kate.dunn@example.com'),
('staff_louis', 'pass005', 'Louis', 'Evans', 'louis.evans@example.com'),
('staff_mike', 'pass006', 'Mike', 'Foster', 'mike.foster@example.com'),
('staff_nina', 'pass007', 'Nina', 'Green', 'nina.green@example.com'),
('staff_oliver', 'pass008', 'Oliver', 'Hill', 'oliver.hill@example.com'),
('staff_patricia', 'pass009', 'Patricia', 'Irwin', 'patricia.irwin@example.com'),
('staff_quinn', 'pass010', 'Quinn', 'Jackson', 'quinn.jackson@example.com');

-- Add more clients:
INSERT INTO Person (userName, password, fname, lname, email) VALUES
('client_frank', 'cpass001', 'Frank', 'Nelson', 'frank.nelson@example.com'),
('client_gina', 'cpass002', 'Gina', 'Olson', 'gina.olson@example.com'),
('client_harry', 'cpass003', 'Harry', 'Peterson', 'harry.peterson@example.com'),
('client_ivy', 'cpass004', 'Ivy', 'Quinn', 'ivy.quinn@example.com'),
('client_jade', 'cpass005', 'Jade', 'Reed', 'jade.reed@example.com'),
('client_karl', 'cpass006', 'Karl', 'Stewart', 'karl.stewart@example.com'),
('client_leah', 'cpass007', 'Leah', 'Turner', 'leah.turner@example.com'),
('client_mark', 'cpass008', 'Mark', 'Underwood', 'mark.underwood@example.com'),
('client_nora', 'cpass009', 'Nora', 'Vargas', 'nora.vargas@example.com'),
('client_owen', 'cpass010', 'Owen', 'Walker', 'owen.walker@example.com'),
('client_paula', 'cpass011', 'Paula', 'Xavier', 'paula.xavier@example.com'),
('client_roy', 'cpass012', 'Roy', 'Young', 'roy.young@example.com'),
('client_sara', 'cpass013', 'Sara', 'Zimmer', 'sara.zimmer@example.com'),
('client_tina', 'cpass014', 'Tina', 'Bishop', 'tina.bishop@example.com'),
('client_uma', 'cpass015', 'Uma', 'Caldwell', 'uma.caldwell@example.com');

-- Insert PersonPhone for new people
INSERT INTO PersonPhone (userName, phone) VALUES
('staff_henry', '555-600-0001'),
('staff_irene', '555-600-0002'),
('staff_james', '555-600-0003'),
('staff_kate', '555-600-0004'),
('staff_louis', '555-600-0005'),
('staff_mike', '555-600-0006'),
('staff_nina', '555-600-0007'),
('staff_oliver', '555-600-0008'),
('staff_patricia', '555-600-0009'),
('staff_quinn', '555-600-0010'),
('client_frank', '555-700-0001'),
('client_gina', '555-700-0002'),
('client_harry', '555-700-0003'),
('client_ivy', '555-700-0004'),
('client_jade', '555-700-0005'),
('client_karl', '555-700-0006'),
('client_leah', '555-700-0007'),
('client_mark', '555-700-0008'),
('client_nora', '555-700-0009'),
('client_owen', '555-700-0010'),
('client_paula', '555-700-0011'),
('client_roy', '555-700-0012'),
('client_sara', '555-700-0013'),
('client_tina', '555-700-0014'),
('client_uma', '555-700-0015');

-- Insert Act (role assignments) for the new people
INSERT INTO Act (userName, roleID) VALUES
('staff_henry', 'staff'),
('staff_irene', 'staff'),
('staff_james', 'staff'),
('staff_kate', 'staff'),
('staff_louis', 'staff'),
('staff_mike', 'staff'),
('staff_nina', 'staff'),
('staff_oliver', 'staff'),
('staff_patricia', 'staff'),
('staff_quinn', 'staff'),
('client_frank', 'client'),
('client_gina', 'client'),
('client_harry', 'client'),
('client_ivy', 'client'),
('client_jade', 'client'),
('client_karl', 'client'),
('client_leah', 'client'),
('client_mark', 'client'),
('client_nora', 'client'),
('client_owen', 'client'),
('client_paula', 'client'),
('client_roy', 'client'),
('client_sara', 'client'),
('client_tina', 'client'),
('client_uma', 'client');

-- Insert more Categories
-- Already have: Furniture (Sofa, Chair, Table), Electronics (TV, Computer), Kitchenware (Plates, Cups, Utensils), Textiles (Bedding, Curtains), Decor (Lamp, Rug)
-- Add more subcategories to existing main categories and new main categories:

INSERT INTO Category (mainCategory, subCategory, catNotes) VALUES
('Furniture', 'Bed', 'Various sizes of beds'),
('Furniture', 'Desk', 'Work and study desks'),
('Furniture', 'Wardrobe', 'Clothes storage'),
('Furniture', 'Dresser', 'Bedroom dressers'),
('Electronics', 'Phone', 'Smartphones and landlines'),
('Electronics', 'Camera', 'Digital cameras'),
('Kitchenware', 'Pans', 'Cooking pans'),
('Kitchenware', 'Bowls', 'Various bowls'),
('Kitchenware', 'Glasses', 'Drinking glasses'),
('Textiles', 'Towels', 'Bath and kitchen towels'),
('Textiles', 'Tablecloth', 'For dining tables'),
('Decor', 'Vase', 'Decorative vases'),
('Decor', 'Painting', 'Wall art'),
('Appliances', 'Fridge', 'Refrigerators'),
('Appliances', 'Washing Machine', 'For laundry'),
('Appliances', 'Oven', 'Cooking ovens'),
('Garden', 'Outdoor Chair', 'Chairs suitable for outdoor'),
('Garden', 'Outdoor Table', 'Tables for garden/patio'),
('Garden', 'Garden Tool', 'Tools for gardening'),
('Toys', 'Board Game', 'Board games sets'),
('Toys', 'Puzzle', 'Jigsaw puzzles'),
('Toys', 'Doll', 'Dolls and action figures'),
('Toys', 'Stuffed Animal', 'Plush toys'),
('Books', 'Novel', 'Fiction books'),
('Books', 'Textbook', 'Educational textbooks'),
('Books', 'Magazine', 'Periodicals');

-- Insert More Locations
-- Already have (101,1), (101,2), (102,1), (102,2), (103,1), (103,2), (104,1), (104,2)
-- Add more rooms and shelves
INSERT INTO Location (roomNum, shelfNum, shelf, shelfDescription) VALUES
(105, 1, 'ShelfI', 'Appliances Shelf'),
(105, 2, 'ShelfJ', 'Books and Magazines Shelf'),
(106, 1, 'ShelfK', 'Garden Tools Shelf'),
(106, 2, 'ShelfL', 'Toys Shelf'),
(107, 1, 'ShelfM', 'Phones & Cameras Shelf'),
(107, 2, 'ShelfN', 'Extra Electronics Shelf'),
(108, 1, 'ShelfO', 'Linen and Towels Shelf'),
(108, 2, 'ShelfP', 'General Storage'),
(109, 1, 'ShelfQ', 'Decor Overflow Shelf'),
(109, 2, 'ShelfR', 'Furniture Overflow Shelf'),
(110, 1, 'ShelfS', 'Kitchenware Overflow'),
(110, 2, 'ShelfT', 'Textiles Overflow');

-- Insert Many Items
-- We'll create about 40 more items (in addition to the 12 already inserted).
-- Remember items must reference existing categories.
-- We'll mix isNew, materials, etc.
INSERT INTO Item (iDescription, photo, color, isNew, material, mainCategory, subCategory) VALUES
('King-size bed', 'bed1.jpg', 'White', TRUE, 'Wood', 'Furniture', 'Bed'),
('Office desk', 'desk1.jpg', 'Brown', FALSE, 'Wood', 'Furniture', 'Desk'),
('Large wardrobe', 'wardrobe1.jpg', 'Brown', TRUE, 'Wood', 'Furniture', 'Wardrobe'),
('Small dresser', 'dresser1.jpg', 'White', TRUE, 'Wood', 'Furniture', 'Dresser'),
('Smartphone iPhone', 'phone1.jpg', 'Black', TRUE, 'Plastic/Metal', 'Electronics', 'Phone'),
('Digital camera', 'camera1.jpg', 'Black', FALSE, 'Plastic/Metal', 'Electronics', 'Camera'),
('Non-stick pan set', 'pans1.jpg', 'Black', TRUE, 'Metal', 'Kitchenware', 'Pans'),
('Glass mixing bowls', 'bowls1.jpg', 'Clear', TRUE, 'Glass', 'Kitchenware', 'Bowls'),
('Set of 6 glasses', 'glasses1.jpg', 'Clear', TRUE, 'Glass', 'Kitchenware', 'Glasses'),
('Set of bath towels', 'towels1.jpg', 'White', TRUE, 'Cotton', 'Textiles', 'Towels'),
('Embroidered tablecloth', 'tablecloth1.jpg', 'Red', TRUE, 'Cotton', 'Textiles', 'Tablecloth'),
('Ceramic vase', 'vase1.jpg', 'Blue', FALSE, 'Ceramic', 'Decor', 'Vase'),
('Landscape painting', 'painting1.jpg', 'Multicolor', FALSE, 'Canvas', 'Decor', 'Painting'),
('Double-door fridge', 'fridge1.jpg', 'Silver', TRUE, 'Metal/Plastic', 'Appliances', 'Fridge'),
('Front-load washing machine', 'washing1.jpg', 'White', FALSE, 'Metal/Plastic', 'Appliances', 'Washing Machine'),
('Gas oven', 'oven1.jpg', 'Steel', TRUE, 'Metal', 'Appliances', 'Oven'),
('Outdoor folding chair', 'outdoorchair1.jpg', 'Green', TRUE, 'Metal/Fabric', 'Garden', 'Outdoor Chair'),
('Outdoor wooden table', 'outdoortable1.jpg', 'Brown', TRUE, 'Wood', 'Garden', 'Outdoor Table'),
('Garden tool set', 'gardentool1.jpg', 'Green', TRUE, 'Metal/Wood', 'Garden', 'Garden Tool'),
('Monopoly board game', 'boardgame1.jpg', 'Multicolor', TRUE, 'Cardboard/Plastic', 'Toys', 'Board Game'),
('1000-piece puzzle', 'puzzle1.jpg', 'Multicolor', TRUE, 'Cardboard', 'Toys', 'Puzzle'),
('Barbie doll', 'doll1.jpg', 'Pink', FALSE, 'Plastic', 'Toys', 'Doll'),
('Teddy bear stuffed animal', 'stuffed1.jpg', 'Brown', FALSE, 'Fabric', 'Toys', 'Stuffed Animal'),
('Classic novel', 'novel1.jpg', 'N/A', FALSE, 'Paper', 'Books', 'Novel'),
('Mathematics textbook', 'textbook1.jpg', 'N/A', TRUE, 'Paper', 'Books', 'Textbook'),
('Fashion magazine', 'magazine1.jpg', 'N/A', TRUE, 'Paper', 'Books', 'Magazine'),
('Leather recliner', 'chair2.jpg', 'Black', FALSE, 'Leather/Wood', 'Furniture', 'Chair'),
('Coffee table', 'table2.jpg', 'Dark Brown', TRUE, 'Wood', 'Furniture', 'Table'),
('Android smartphone', 'phone2.jpg', 'Blue', TRUE, 'Plastic/Metal', 'Electronics', 'Phone'),
('DSLR camera', 'camera2.jpg', 'Black', TRUE, 'Plastic/Metal', 'Electronics', 'Camera'),
('Stainless steel cutlery set', 'utensils2.jpg', 'Silver', TRUE, 'Stainless Steel', 'Kitchenware', 'Utensils'),
('Porcelain dinner plates', 'plates2.jpg', 'White', TRUE, 'Porcelain', 'Kitchenware', 'Plates'),
('Floor lamp', 'lamp2.jpg', 'White', TRUE, 'Metal/Fabric', 'Decor', 'Lamp'),
('Woolen rug large', 'rug2.jpg', 'Gray', TRUE, 'Wool', 'Decor', 'Rug'),
('King-size bedding set', 'bedding2.jpg', 'Cream', TRUE, 'Cotton', 'Textiles', 'Bedding'),
('Silk curtains', 'curtains2.jpg', 'Gold', TRUE, 'Silk', 'Textiles', 'Curtains'),
('Mini fridge', 'fridge2.jpg', 'White', TRUE, 'Metal/Plastic', 'Appliances', 'Fridge'),
('Microwave oven', 'oven2.jpg', 'Black', TRUE, 'Metal/Plastic', 'Appliances', 'Oven');


INSERT INTO Piece (ItemID, pieceNum, pDescription, length, width, height, roomNum, shelfNum, pNotes) VALUES
-- Wardrobe (15) has pieces: assume 3 pieces (main body, 2 drawers)
(15, 1, 'Wardrobe main body', 200, 60, 220, 109, 2, ''),
(15, 2, 'Top drawer', 60, 50, 20, 109, 2, ''),
(15, 3, 'Bottom drawer', 60, 50, 20, 109, 2, ''),
(19, 1, 'Small pan', 20, 20, 5, 110, 1, ''),
(19, 2, 'Medium pan', 25, 25, 5, 110, 1, ''),
(19, 3, 'Large pan', 30, 30, 5, 110, 1, ''),
(20, 1, 'Small bowl', 15, 15, 10, 110, 1, ''),
(20, 2, 'Medium bowl', 20, 20, 12, 110, 1, ''),
(20, 3, 'Large bowl', 25, 25, 15, 110, 1, ''),
(21, 1, 'Glass 1', 8, 8, 12, 110, 2, ''),
(21, 2, 'Glass 2', 8, 8, 12, 110, 2, ''),
(21, 3, 'Glass 3', 8, 8, 12, 110, 2, ''),
(21, 4, 'Glass 4', 8, 8, 12, 110, 2, ''),
(21, 5, 'Glass 5', 8, 8, 12, 110, 2, ''),
(21, 6, 'Glass 6', 8, 8, 12, 110, 2, ''),
(22, 1, 'Towel 1', 100, 50, 1, 108, 1, ''),
(22, 2, 'Towel 2', 100, 50, 1, 108, 1, ''),
(22, 3, 'Towel 3', 100, 50, 1, 108, 1, ''),
(22, 4, 'Towel 4', 100, 50, 1, 108, 1, ''),
(31, 1, 'Garden spade', 30, 10, 5, 106, 1, ''),
(31, 2, 'Garden rake', 100, 30, 10, 106, 1, ''),
(31, 3, 'Garden shears', 25, 5, 5, 106, 1, ''),
(31, 4, 'Garden hoe', 110, 20, 10, 106, 1, ''),
(32, 1, 'Game board', 50, 50, 3, 106, 2, ''),
(32, 2, 'Set of cards', 10, 10, 5, 106, 2, ''),
(32, 3, 'Tokens and dice', 5, 5, 3, 106, 2, ''),
(33, 1, 'Puzzle box', 30, 20, 10, 106, 2, 'Contains all puzzle pieces'),
(43, 1, 'Forks (4)', 20, 2, 2, 104, 2, ''),
(43, 2, 'Spoons (4)', 20, 2, 2, 104, 2, ''),
(43, 3, 'Knives (4)', 20, 2, 2, 104, 2, ''),
(43, 4, 'Teaspoons (4)', 10, 2, 2, 104, 2, ''),
(44, 1, 'Plate 1', 25, 25, 2, 104, 1, ''),
(44, 2, 'Plate 2', 25, 25, 2, 104, 1, ''),
(44, 3, 'Plate 3', 25, 25, 2, 104, 1, ''),
(44, 4, 'Plate 4', 25, 25, 2, 104, 1, ''),
(47, 1, 'Bedsheet', 200, 180, 1, 108, 1, ''),
(47, 2, 'Pillowcase 1', 50, 30, 1, 108, 1, ''),
(47, 3, 'Pillowcase 2', 50, 30, 1, 108, 1, ''),
(47, 4, 'Duvet', 200, 180, 10, 108, 1, '');

-- Insert DonatedBy (assume a variety of clients donate items)
-- We have many items now, we can randomize donors and dates
INSERT INTO DonatedBy (ItemID, userName, donateDate) VALUES
(13, 'client_anna', '2024-03-01'),
(14, 'client_bob', '2024-03-05'),
(15, 'client_carol', '2024-03-10'),
(16, 'client_dan', '2024-03-15'),
(17, 'client_erin', '2024-03-20'),
(18, 'client_frank', '2024-03-25'),
(19, 'client_gina', '2024-03-30'),
(20, 'client_harry', '2024-04-01'),
(21, 'client_ivy', '2024-04-05'),
(22, 'client_jade', '2024-04-10'),
(23, 'client_karl', '2024-04-15'),
(24, 'client_leah', '2024-04-20'),
(25, 'client_mark', '2024-04-25'),
(26, 'client_nora', '2024-04-30'),
(27, 'client_owen', '2024-05-05'),
(28, 'client_paula', '2024-05-10'),
(29, 'client_roy', '2024-05-15'),
(30, 'client_sara', '2024-05-20'),
(31, 'client_tina', '2024-05-25'),
(32, 'client_uma', '2024-05-30'),
(33, 'client_anna', '2024-06-01'),
(34, 'client_bob', '2024-06-05'),
(35, 'client_carol', '2024-06-10'),
(36, 'client_dan', '2024-06-15'),
(37, 'client_erin', '2024-06-20'),
(38, 'client_frank', '2024-06-25'),
(39, 'client_gina', '2024-07-01'),
(40, 'client_harry', '2024-07-05'),
(41, 'client_ivy', '2024-07-10'),
(42, 'client_jade', '2024-07-15'),
(43, 'client_karl', '2024-07-20'),
(44, 'client_leah', '2024-07-25'),
(45, 'client_mark', '2024-07-30'),
(46, 'client_nora', '2024-08-01'),
(47, 'client_owen', '2024-08-05'),
(48, 'client_paula', '2024-08-10'),
(49, 'client_roy', '2024-08-15'),
(50, 'client_sara', '2024-08-20');

-- Insert more Orders
-- We'll create about 15 orders total (7 were already inserted, so let's add 8 more):
INSERT INTO Ordered (orderDate, orderNotes, status, supervisor, client) VALUES
('2024-11-10', 'Need bedding and towels urgently', 'pending', 'staff_irene', 'client_tina'),
('2024-11-12', 'Request for electronics', 'placed', 'staff_james', 'client_uma'),
('2024-11-14', 'Kitchenware set', 'shipped', 'staff_kate', 'client_sara'),
('2024-11-16', 'Books and magazines order', 'shipped', 'staff_louis', 'client_nora'),
('2024-11-18', 'Garden tools needed', 'pending', 'staff_mike', 'client_ivy'),
('2024-11-20', 'Furniture for living room', 'placed', 'staff_nina', 'client_harry'),
('2024-11-22', 'Decor items request', 'shipped', 'staff_oliver', 'client_gina'),
('2024-11-24', 'Appliances for kitchen', 'complete', 'staff_patricia', 'client_leah');

-- The existing orders had IDs 1 through 7. These new ones will be 8 through 15.
-- Insert ItemIn for these new orders
-- Order 8: Needs bedding (9), towels (22)
INSERT INTO ItemIn (ItemID, orderID, found) VALUES
(9, 8, TRUE),
(22, 8, FALSE),
(17, 9, TRUE),
(18, 9, TRUE),
(5, 9, TRUE),
(19, 10, TRUE),
(20, 10, TRUE),
(8, 10, FALSE),
(36, 11, TRUE),
(37, 11, TRUE),
(38, 11, TRUE),
(31, 12, TRUE),
(1, 13, TRUE),
(40, 13, FALSE),
(2, 13, TRUE),
(11, 14, TRUE),
(25, 14, TRUE),
(12, 14, TRUE),
(14, 15, TRUE),
(28, 15, FALSE),
(27, 15, TRUE);

INSERT INTO Delivered (userName, orderID, date) VALUES
('staff_irene', 8, '2024-11-11'),
('staff_kate', 10, '2024-11-15'),
('staff_louis', 11, '2024-11-17'),
('staff_patricia', 15, '2024-11-25');

INSERT INTO Ordered (orderDate, orderNotes, status, supervisor, client) VALUES
('2024-12-01', 'Holiday furniture request', 'pending', 'staff_alex', 'client_bob'),
('2024-12-02', 'Electronics for office', 'placed', 'staff_mary', 'client_anna'),
('2024-12-03', 'Kitchenware for party', 'shipped', 'staff_john', 'client_carol'),
('2024-12-04', 'Textiles restock', 'complete', 'staff_linda', 'client_dan'),
('2024-12-05', 'Decor items for event', 'pending', 'staff_george', 'client_erin'),
('2024-12-06', 'Appliances for new home', 'placed', 'staff_henry', 'client_uma'),
('2024-12-07', 'Garden furniture set', 'shipped', 'staff_irene', 'client_sara'),
('2024-12-08', 'Toys and games for daycare', 'shipped', 'staff_james', 'client_harry'),
('2024-12-09', 'Books for library', 'pending', 'staff_kate', 'client_nora'),
('2024-12-10', 'Mix of various items', 'placed', 'staff_louis', 'client_leah');



INSERT INTO ItemIn (ItemID, orderID, found) VALUES
(1, 16, TRUE),
(40, 16, FALSE),
(17, 17, TRUE),
(42, 17, TRUE),
(19, 18, TRUE),
(20, 18, TRUE),
(47, 19, TRUE),
(22, 19, TRUE),
(45, 20, TRUE),
(24, 20, TRUE),
(25, 20, FALSE),
(14, 21, TRUE),
(16, 21, FALSE),
(50, 21, TRUE),
(17, 22, FALSE),
(18, 22, TRUE),
(32, 23, TRUE),
(33, 23, FALSE),
(35, 23, TRUE),
(36, 24, TRUE),
(37, 24, TRUE),
(38, 24, TRUE),
(39, 25, TRUE),
(41, 25, TRUE),
(44, 25, FALSE);

INSERT INTO Delivered (userName, orderID, date) VALUES
('staff_linda', 19, '2024-12-04'),   -- Textiles restock delivered by Linda
('staff_james', 23, '2024-12-08');   -- Toys and games delivered by James


USE WelcomeHome;

-- Previously we had inserted orders up to orderID=25.
-- Let's add 20 more orders (orderID=26 through 45) for further testing.
-- We'll vary the staff, clients, order notes, and statuses extensively.

INSERT INTO Ordered (orderDate, orderNotes, status, supervisor, client) VALUES
('2024-12-11', 'Extra bedding request', 'pending', 'staff_mike', 'client_anna'),
('2024-12-12', 'Need more kitchen utensils', 'placed', 'staff_nina', 'client_bob'),
('2024-12-13', 'Electronics replacement', 'shipped', 'staff_oliver', 'client_carol'),
('2024-12-14', 'Decorative items for holiday', 'complete', 'staff_patricia', 'client_dan'),
('2024-12-15', 'Garden tools expansion', 'pending', 'staff_quinn', 'client_erin'),
('2024-12-16', 'Additional furniture for lounge', 'placed', 'staff_alex', 'client_frank'),
('2024-12-17', 'Textiles for guest room', 'shipped', 'staff_mary', 'client_gina'),
('2024-12-18', 'Magazines and books for library', 'complete', 'staff_john', 'client_harry'),
('2024-12-19', 'Toys and games for children center', 'pending', 'staff_linda', 'client_ivy'),
('2024-12-20', 'Large appliances order', 'placed', 'staff_george', 'client_jade'),
('2024-12-21', 'Outdoor furniture refresh', 'shipped', 'staff_henry', 'client_karl'),
('2024-12-22', 'Rugs and lamps for office', 'complete', 'staff_irene', 'client_leah'),
('2024-12-23', 'Phones and cameras upgrade', 'pending', 'staff_james', 'client_mark'),
('2024-12-24', 'Plates and bowls for restaurant', 'placed', 'staff_kate', 'client_nora'),
('2024-12-25', 'Pans and utensils set needed', 'shipped', 'staff_louis', 'client_owen'),
('2024-12-26', 'Wardrobe and dresser for bedroom', 'complete', 'staff_mike', 'client_paula'),
('2024-12-27', 'Bed and curtains restock', 'pending', 'staff_nina', 'client_roy'),
('2024-12-28', 'Multiple decor items', 'placed', 'staff_oliver', 'client_sara'),
('2024-12-29', 'Electronics and appliances combo', 'shipped', 'staff_patricia', 'client_tina'),
('2024-12-30', 'Garden and toys bundle', 'complete', 'staff_quinn', 'client_uma');



INSERT INTO ItemIn (ItemID, orderID, found) VALUES
(9, 26, TRUE),
(47, 26, FALSE),
(43, 27, TRUE),
(19, 27, TRUE),
(17, 28, TRUE),
(41, 28, FALSE),
(42, 28, TRUE),
(24, 29, TRUE),
(45, 29, TRUE),
(46, 29, TRUE),
(31, 30, TRUE),
(17, 30, FALSE),
(18, 30, TRUE),
(39, 31, TRUE),
(40, 31, TRUE),
(15, 31, FALSE),
(48, 32, TRUE),
(22, 32, TRUE),
(23, 32, TRUE),
(38, 33, TRUE),
(36, 33, TRUE),
(37, 33, TRUE),
(32, 34, FALSE),
(33, 34, TRUE),
(35, 34, TRUE),
(14, 35, TRUE),
(16, 35, TRUE),
(27, 35, TRUE),
(18, 36, TRUE),
(17, 36, TRUE),
(46, 37, FALSE),
(45, 37, TRUE),
(11, 37, TRUE),
(17, 38, TRUE),
(18, 38, TRUE),
(42, 38, FALSE),
(44, 39, TRUE),
(20, 39, FALSE),
(19, 40, TRUE),
(43, 40, TRUE),
(8, 40, TRUE),
(15, 41, TRUE),
(16, 41, FALSE),
(13, 42, TRUE),
(48, 42, TRUE),
(24, 43, TRUE),
(25, 43, TRUE),
(45, 43, TRUE),
(12, 43, FALSE),
(17, 44, TRUE),
(14, 44, TRUE),
(50, 44, FALSE),
(31, 45, TRUE),
(34, 45, TRUE),
(35, 45, TRUE);

INSERT INTO Delivered (userName, orderID, date) VALUES
('staff_patricia', 29, '2024-12-14'),
('staff_john', 33, '2024-12-18'),
('staff_irene', 37, '2024-12-22'),
('staff_mike', 41, '2024-12-26'),
('staff_quinn', 45, '2024-12-30');

INSERT INTO Piece (ItemID, pieceNum, pDescription, length, width, height, roomNum, shelfNum, pNotes) VALUES
(2, 1, 'Base component', 50, 50, 50, 101, 1, ''),
(3, 1, 'Base component', 50, 50, 50, 101, 1, ''),
(4, 1, 'Base component', 50, 50, 50, 101, 1, ''),
(5, 1, 'Base component', 50, 50, 50, 101, 1, ''),
(9, 1, 'Base component', 50, 50, 50, 101, 1, ''),
(10, 1, 'Base component', 50, 50, 50, 101, 1, ''),
(11, 1, 'Base component', 50, 50, 50, 101, 1, ''),
(12, 1, 'Base component', 50, 50, 50, 101, 1, ''),
(13, 1, 'Base component', 50, 50, 50, 101, 1, ''),
(14, 1, 'Base component', 50, 50, 50, 101, 1, ''),
(16, 1, 'Base component', 50, 50, 50, 101, 1, ''),
(17, 1, 'Base component', 50, 50, 50, 101, 1, ''),
(18, 1, 'Base component', 50, 50, 50, 101, 1, ''),
(23, 1, 'Base component', 50, 50, 50, 101, 1, ''),
(24, 1, 'Base component', 50, 50, 50, 101, 1, ''),
(25, 1, 'Base component', 50, 50, 50, 101, 1, ''),
(26, 1, 'Base component', 50, 50, 50, 101, 1, ''),
(27, 1, 'Base component', 50, 50, 50, 101, 1, ''),
(28, 1, 'Base component', 50, 50, 50, 101, 1, ''),
(29, 1, 'Base component', 50, 50, 50, 101, 1, ''),
(30, 1, 'Base component', 50, 50, 50, 101, 1, ''),
(34, 1, 'Base component', 50, 50, 50, 101, 1, ''),
(35, 1, 'Base component', 50, 50, 50, 101, 1, ''),
(36, 1, 'Base component', 50, 50, 50, 101, 1, ''),
(37, 1, 'Base component', 50, 50, 50, 101, 1, ''),
(38, 1, 'Base component', 50, 50, 50, 101, 1, ''),
(39, 1, 'Base component', 50, 50, 50, 101, 1, ''),
(40, 1, 'Base component', 50, 50, 50, 101, 1, ''),
(41, 1, 'Base component', 50, 50, 50, 101, 1, ''),
(42, 1, 'Base component', 50, 50, 50, 101, 1, ''),
(45, 1, 'Base component', 50, 50, 50, 101, 1, ''),
(46, 1, 'Base component', 50, 50, 50, 101, 1, ''),
(48, 1, 'Base component', 50, 50, 50, 101, 1, ''),
(49, 1, 'Base component', 50, 50, 50, 101, 1, ''),
(50, 1, 'Base component', 50, 50, 50, 101, 1, '');