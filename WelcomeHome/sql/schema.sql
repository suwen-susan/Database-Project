-- Active: 1733367263268@@127.0.0.1@3306@welcomehome
DROP SCHEMA IF EXISTS WelcomeHome;
CREATE SCHEMA WelcomeHome;

USE welcomehome;

DROP TABLE IF EXISTS Category;
DROP TABLE IF EXISTS Item;
DROP TABLE IF EXISTS Person;
DROP TABLE IF EXISTS PersonPhone;
DROP TABLE IF EXISTS DonatedBy;
DROP TABLE IF EXISTS Role;
DROP TABLE IF EXISTS Act;
DROP TABLE IF EXISTS Location;
DROP TABLE IF EXISTS Piece;
DROP TABLE IF EXISTS Ordered;
DROP TABLE IF EXISTS ItemIn;
DROP TABLE IF EXISTS Delivered;


CREATE TABLE Category (
    mainCategory VARCHAR(50) NOT NULL,
    subCategory VARCHAR(50) NOT NULL,
    catNotes TEXT,
    PRIMARY KEY (mainCategory, subCategory)
);

CREATE TABLE Item (
    ItemID INT NOT NULL AUTO_INCREMENT,
    iDescription TEXT,
    photo VARCHAR(20), -- BLOB is better here, but for simplicity, we change it to VARCHAR; For p3 implementation, we recommend you to implement as blob
    color VARCHAR(20),
    isNew BOOLEAN DEFAULT TRUE,
    material VARCHAR(50),
    mainCategory VARCHAR(50) NOT NULL,
    subCategory VARCHAR(50) NOT NULL,
    PRIMARY KEY (ItemID),
    FOREIGN KEY (mainCategory, subCategory) REFERENCES Category(mainCategory, subCategory)
);


CREATE TABLE Person (
    userName VARCHAR(50) NOT NULL,
    password VARCHAR(200) NOT NULL,
    fname VARCHAR(50) NOT NULL,
    lname VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    PRIMARY KEY (userName)
);

CREATE TABLE PersonPhone (
    userName VARCHAR(50) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    PRIMARY KEY (userName, phone),
    FOREIGN KEY (userName) REFERENCES Person(userName)
);

CREATE TABLE DonatedBy (
    ItemID INT NOT NULL,
    userName VARCHAR(50) NOT NULL,
    donateDate DATE NOT NULL,
    PRIMARY KEY (ItemID, userName),
    FOREIGN KEY (ItemID) REFERENCES Item(ItemID),
    FOREIGN KEY (userName) REFERENCES Person(userName)
);

CREATE TABLE Role (
    roleID VARCHAR(20) NOT NULL,
    rDescription VARCHAR(100),
    PRIMARY KEY (roleID),
    CHECK (roleID IN ('staff', 'client')));

CREATE TABLE Act (
    userName VARCHAR(50) NOT NULL,
    roleID VARCHAR(20) NOT NULL,
    PRIMARY KEY (userName, roleID),
    FOREIGN KEY (userName) REFERENCES Person(userName),
    FOREIGN KEY (roleID) REFERENCES Role(roleID)
);

CREATE TABLE Location (
    roomNum INT NOT NULL,
    shelfNum INT NOT NULL, -- not a point for deduction
    shelf VARCHAR(20),
    shelfDescription VARCHAR(200),
    PRIMARY KEY (roomNum, shelfNum)
);



CREATE TABLE Piece (
    ItemID INT NOT NULL,
    pieceNum INT NOT NULL,
    pDescription VARCHAR(200),
    length INT NOT NULL, -- for simplicity
    width INT NOT NULL,
    height INT NOT NULL,
    roomNum INT NOT NULL,
    shelfNum INT NOT NULL, 
    pNotes TEXT,
    PRIMARY KEY (ItemID, pieceNum),
    FOREIGN KEY (ItemID) REFERENCES Item(ItemID),
    FOREIGN KEY (roomNum, shelfNum) REFERENCES Location(roomNum, shelfNum)
);

CREATE TABLE Ordered (
    orderID INT NOT NULL AUTO_INCREMENT,
    orderDate DATE NOT NULL,
    orderNotes VARCHAR(200),
    status VARCHAR(20) NOT NULL,
    supervisor VARCHAR(50) NOT NULL DEFAULT 'unassigned',
    client VARCHAR(50) NOT NULL,
    PRIMARY KEY (orderID),
    FOREIGN KEY (supervisor) REFERENCES Person(userName),
    FOREIGN KEY (client) REFERENCES Person(userName),
    CHECK (status IN ('pending', 'placed', 'preparing', 'ready for delivery', 'shipped', 'complete', 'returned'))
);

CREATE TABLE ItemIn (
    ItemID INT NOT NULL,
    orderID INT NOT NULL,
    found BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (ItemID, orderID),
    FOREIGN KEY (ItemID) REFERENCES Item(ItemID),
    FOREIGN KEY (orderID) REFERENCES Ordered(orderID)
);


CREATE TABLE Delivered (
    userName VARCHAR(50) NOT NULL,
    orderID INT NOT NULL,
    date DATE NOT NULL,
    PRIMARY KEY (userName, orderID),
    FOREIGN KEY (userName) REFERENCES Person(userName),
    FOREIGN KEY (orderID) REFERENCES Ordered(orderID)
);

INSERT INTO Location (roomNum, shelfNum, shelfDescription) 
VALUES (0, -1, 'Holding Location');

INSERT INTO Role (roleID, rDescription) VALUES
('staff', '0'),
('client', '1');

insert into Person (userName, password, fname, lname, email) values
('unassigned', '11', 'unknown', 'unknown', 'xxx@gmail.com');