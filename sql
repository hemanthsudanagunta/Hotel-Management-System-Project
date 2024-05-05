CREATE TRIGGER customer_insert_trigger
BEFORE INSERT ON Customer
FOR EACH ROW
BEGIN
    SET NEW.name = UPPER(NEW.name);
END//



CREATE TRIGGER room_type_check_trigger
BEFORE INSERT ON Room
FOR EACH ROW
BEGIN
    IF NEW.type IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Room type cannot be null';
    ELSEIF NEW.type NOT IN ('deluxe', 'classic') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid room type. Must be either "deluxe" or "classic"';
    END IF;
END//

CREATE TRIGGER check_customerId_not_null_trigger
BEFORE INSERT ON Check_IN_OUT
FOR EACH ROW
BEGIN
    IF NEW.customerId IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Customer ID cannot be null';
    END IF;
END//

CREATE TRIGGER employeeId_not_null_trigger
BEFORE INSERT ON Employee
FOR EACH ROW
BEGIN
    IF NEW.employeeId IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Employee ID cannot be null';
    END IF;
END//

CREATE TRIGGER receptionist_shift_check_trigger
BEFORE INSERT ON Receptionist
FOR EACH ROW
BEGIN
    IF NEW.shift NOT IN ('morning', 'evening') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Shift must be either "morning" or "evening"';
    END IF;
END//

CREATE TRIGGER admin_employeeId_not_null_trigger
BEFORE INSERT ON Admin
FOR EACH ROW
BEGIN
    IF NEW.employeeId IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Please enter ID (cannot be null)';
    END IF;
END//

CREATE TRIGGER reservationId_not_null_trigger
BEFORE INSERT ON Reservation
FOR EACH ROW
BEGIN
    IF NEW.reservationId IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Please update Reservation ID';
    END IF;
END//

CREATE TRIGGER payment_amount_not_null_trigger
AFTER INSERT ON Payment
FOR EACH ROW
BEGIN
    IF NEW.amount IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Amount cannot be null';
    END IF;
END//

CREATE TRIGGER invoiceId_not_null_trigger
BEFORE INSERT ON Invoice
FOR EACH ROW
BEGIN
    IF NEW.invoiceId IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invoice ID cannot be null';
    END IF;
END//

CREATE TRIGGER roomService_roomServiceId_not_null_trigger
BEFORE INSERT ON Room_Service
FOR EACH ROW
BEGIN
    IF NEW.roomServiceId IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Room service ID cannot be null';
    END IF;
END//

CREATE TRIGGER foodItem_not_null_trigger
BEFORE INSERT ON Food
FOR EACH ROW
BEGIN
    IF NEW.foodItem IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Food item cannot be null';
    END IF;
END//

DELIMITER ; 
Relational schema:

Customer (customerId INT PRIMARY KEY, name VARCHAR(255), address VARCHAR(255))
Hotel (hotelId INT PRIMARY KEY, name VARCHAR(255), address VARCHAR(255), phone VARCHAR(15), hotel_type VARCHAR(20))
Room (roomId INT PRIMARY KEY, hotelId INT, type VARCHAR(50), price DECIMAL(10, 2), FOREIGN KEY (hotelId) REFERENCES Hotel(hotelId))
Available_Rooms (roomId INT, dateFrom DATE, dateTo DATE, PRIMARY KEY (roomId, dateFrom), FOREIGN KEY (roomId) REFERENCES Room(roomId))
Check_IN_OUT (customerId INT, roomId INT, checkIn DATE, checkOut DATE, PRIMARY KEY (customerId, roomId), FOREIGN KEY (customerId) REFERENCES Customer(customerId), FOREIGN KEY (roomId) REFERENCES Room(roomId))
Employee (employeeId INT PRIMARY KEY, name VARCHAR(255), position VARCHAR(50), salary DECIMAL(10, 2))
Receptionist (employeeId INT, shift VARCHAR(50), PRIMARY KEY (employeeId, shift), FOREIGN KEY (employeeId) REFERENCES Employee(employeeId))
Admin (employeeId INT, PRIMARY KEY (employeeId), FOREIGN KEY (employeeId) REFERENCES Employee(employeeId))
Reservation (reservationId INT PRIMARY KEY, customerId INT, roomId INT, checkIn DATE, checkOut DATE, FOREIGN KEY (customerId) REFERENCES Customer(customerId), FOREIGN KEY (roomId) REFERENCES Room(roomId))
Payment (paymentId INT PRIMARY KEY, reservationId INT, amount DECIMAL(10, 2), paymentDate DATE, FOREIGN KEY (reservationId) REFERENCES Reservation(reservationId))
Invoice (invoiceId INT PRIMARY KEY, reservationId INT, total DECIMAL(10, 2), issueDate DATE, FOREIGN KEY (reservationId) REFERENCES Reservation(reservationId))
Room_Service (roomServiceId INT PRIMARY KEY, roomId INT, orderDate DATE, FOREIGN KEY (roomId) REFERENCES Room(roomId))
Room_Service_Order (roomServiceId INT, foodItem VARCHAR(255), quantity INT, price DECIMAL(10, 2), PRIMARY KEY (roomServiceId, foodItem), FOREIGN KEY (roomServiceId) REFERENCES Room_Service(roomServiceId))
Food (foodId INT PRIMARY KEY, foodItem VARCHAR(255), roomId INT, food_cost INT, FOREIGN KEY (roomId) REFERENCES Room(roomId))

CODE FOR CREATE A TABLE:

drop database hotel_management;
create database hotel_management;
use hotel_management;
CREATE TABLE Customer (
    customerId INT PRIMARY KEY,
    name VARCHAR(255),
    address VARCHAR(255)
);

CREATE TABLE Hotel (
    hotelId INT PRIMARY KEY,
    name VARCHAR(255),
    address VARCHAR(255)
);

CREATE TABLE Room (
    roomId INT PRIMARY KEY,
    hotelId INT,
    type VARCHAR(50),
    price DECIMAL(10, 2),
    FOREIGN KEY (hotelId) REFERENCES Hotel(hotelId)
);


CREATE TABLE Available_Rooms (
    roomId INT,
    dateFrom DATE,
    dateTo DATE,
    PRIMARY KEY (roomId, dateFrom),
    FOREIGN KEY (roomId) REFERENCES Room(roomId)
);

CREATE TABLE Check_IN_OUT (
    customerId INT,
    roomId INT,
    checkIn DATE,
    checkOut DATE,
    PRIMARY KEY (customerId, roomId),
    FOREIGN KEY (customerId) REFERENCES Customer(customerId),
    FOREIGN KEY (roomId) REFERENCES Room(roomId)
);

CREATE TABLE Employee (
    employeeId INT PRIMARY KEY,
    name VARCHAR(255),
    position VARCHAR(50),
    salary DECIMAL(10, 2)
);

CREATE TABLE Receptionist (
    employeeId INT,
    shift VARCHAR(50),
    FOREIGN KEY (employeeId) REFERENCES Employee(employeeId),
    PRIMARY KEY (employeeId, shift)
);

CREATE TABLE Admin (
    employeeId INT,
    PRIMARY KEY (employeeId),
    FOREIGN KEY (employeeId) REFERENCES Employee(employeeId)
);

CREATE TABLE Reservation (
    reservationId INT PRIMARY KEY,
    customerId INT,
    roomId INT,
    checkIn DATE,
    checkOut DATE,
    FOREIGN KEY (customerId) REFERENCES Customer(customerId),
    FOREIGN KEY (roomId) REFERENCES Room(roomId)
);

CREATE TABLE Payment (
    paymentId INT PRIMARY KEY,
    reservationId INT,
    amount DECIMAL(10, 2),
    paymentDate DATE,
    FOREIGN KEY (reservationId) REFERENCES Reservation(reservationId)
);

CREATE TABLE Invoice (
    invoiceId INT PRIMARY KEY,
    reservationId INT,
    total DECIMAL(10, 2),
    issueDate DATE,
    FOREIGN KEY (reservationId) REFERENCES Reservation(reservationId)
);

CREATE TABLE Room_Service (
    roomServiceId INT PRIMARY KEY,
    roomId INT,
    orderDate DATE,
    FOREIGN KEY (roomId) REFERENCES Room(roomId)
);

CREATE TABLE Room_Service_Order (
    roomServiceId INT,
    foodItem VARCHAR(255),
    quantity INT,
    price DECIMAL(10, 2),
    PRIMARY KEY (roomServiceId, foodItem),
    FOREIGN KEY (roomServiceId) REFERENCES Room_Service(roomServiceId)
);

CREATE TABLE Food (
    foodId INT PRIMARY KEY,
    foodItem VARCHAR(255),
    roomId INT,
    FOREIGN KEY (roomId) REFERENCES Room(roomId)
);
select * from Customer;
select * from Hotel;
select * from Room;
select * from Available_Rooms;
select * from Check_IN_OUT;
select * from Employee;
select * from food;
select * from Room_Service;
select * from Invoice;
select * from payment;
select * from Reservation;
select * from Admin;
alter table food
add (food_cost int);
select * from food;
alter table hotel
add (hotel_type varchar(20));
alter table hotel
ADD COLUMN phone VARCHAR(15);

truncate table Customer;
truncate table Hotel;
truncate table Available_Rooms;
truncate table Room;
truncate table Check_IN_OUT;
truncate table Employee;
truncate table Food;
truncate table Room_Service;
truncate table Invoice;
truncate table Payment;
truncate table Reservation;
truncate table Receptionist;



INSERT INTO Customer (customerId, name, address) VALUES
(1, 'John Doe', '123 Main Street'),
(2, 'Jane Smith', '456 Elm Street');

INSERT INTO Hotel (hotelId, name, address) VALUES
(1, 'Grand Hotel', '789 Broadway'),
(2, 'Luxury Resort', '101 Park Avenue');


INSERT INTO Room (roomId, hotelId, type, price) VALUES
(101, 1, 'deluxe', 100),
(102, 1, 'classic', 150),
(103, 2, 'classic', 300);


INSERT INTO Available_Rooms (roomId, dateFrom, dateTo) VALUES
(101, '2024-04-01', '2024-04-10'),
(102, '2024-04-05', '2024-04-15'),
(103, '2024-04-03', '2024-04-12');


INSERT INTO Check_IN_OUT (customerId, roomId, checkIn, checkOut) VALUES
(1, 101, '2024-04-01', '2024-04-05'),
(2, 102, '2024-04-10', '2024-04-15');


INSERT INTO Employee (employeeId, name, position, salary) VALUES
(1, 'Michael Johnson', 'Manager', 5000),
(2, 'Emily Brown', 'Receptionist', 2500);


INSERT INTO Receptionist (employeeId, shift) VALUES
(2, 'Morning'),
(2, 'Evening');


INSERT INTO Admin (employeeId) VALUES
(1);

INSERT INTO Reservation (reservationId, customerId, roomId, checkIn, checkOut) VALUES
(1001, 1, 101, '2024-04-01', '2024-04-05'),
(1002, 2, 102, '2024-04-10', '2024-04-15');


INSERT INTO Payment (paymentId, reservationId, amount, paymentDate) VALUES
(5001, 1001, 400, '2024-04-01'),
(5002, 1002, 300, '2024-04-10');

INSERT INTO Invoice (invoiceId, reservationId, total, issueDate) VALUES
(6001, 1001, 400, '2024-04-01'),
(6002, 1002, 300, '2024-04-10');


INSERT INTO Room_Service (roomServiceId, roomId, orderDate) VALUES
(2001, 101, '2024-04-01'),
(2002, 102, '2024-04-10');
INSERT INTO Room_Service_Order (roomServiceId, foodItem, quantity, price) VALUES
(2001, 'Breakfast', 2, 20),
(2002, 'Dinner', 3, 50);

INSERT INTO Food (foodId, foodItem, roomId) VALUES
(3001, 'Pizza', 103),
(3002, 'Burger', 103);

drop trigger customer_insert_trigger;
drop trigger hotel_update_address_trigger;
drop trigger room_type_check_trigger;
drop trigger check_customerId_not_null_trigger;



DELIMITER //

CREATE TRIGGER customer_insert_trigger
BEFORE INSERT ON Customer
FOR EACH ROW
BEGIN
    SET NEW.name = UPPER(NEW.name);
END//



CREATE TRIGGER room_type_check_trigger
BEFORE INSERT ON Room
FOR EACH ROW
BEGIN
    IF NEW.type IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Room type cannot be null';
    ELSEIF NEW.type NOT IN ('deluxe', 'classic') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid room type. Must be either "deluxe" or "classic"';
    END IF;
END//

CREATE TRIGGER check_customerId_not_null_trigger
BEFORE INSERT ON Check_IN_OUT
FOR EACH ROW
BEGIN
    IF NEW.customerId IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Customer ID cannot be null';
    END IF;
END//

CREATE TRIGGER employeeId_not_null_trigger
BEFORE INSERT ON Employee
FOR EACH ROW
BEGIN
    IF NEW.employeeId IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Employee ID cannot be null';
    END IF;
END//

CREATE TRIGGER receptionist_shift_check_trigger
BEFORE INSERT ON Receptionist
FOR EACH ROW
BEGIN
    IF NEW.shift NOT IN ('morning', 'evening') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Shift must be either "morning" or "evening"';
    END IF;
END//

CREATE TRIGGER admin_employeeId_not_null_trigger
BEFORE INSERT ON Admin
FOR EACH ROW
BEGIN
    IF NEW.employeeId IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Please enter ID (cannot be null)';
    END IF;
END//

CREATE TRIGGER reservationId_not_null_trigger
BEFORE INSERT ON Reservation
FOR EACH ROW
BEGIN
    IF NEW.reservationId IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Please update Reservation ID';
    END IF;
END//

CREATE TRIGGER payment_amount_not_null_trigger
AFTER INSERT ON Payment
FOR EACH ROW
BEGIN
    IF NEW.amount IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Amount cannot be null';
    END IF;
END//

CREATE TRIGGER invoiceId_not_null_trigger
BEFORE INSERT ON Invoice
FOR EACH ROW
BEGIN
    IF NEW.invoiceId IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invoice ID cannot be null';
    END IF;
END//

CREATE TRIGGER roomService_roomServiceId_not_null_trigger
BEFORE INSERT ON Room_Service
FOR EACH ROW
BEGIN
    IF NEW.roomServiceId IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Room service ID cannot be null';
    END IF;
END//

CREATE TRIGGER foodItem_not_null_trigger
BEFORE INSERT ON Food
FOR EACH ROW
BEGIN
    IF NEW.foodItem IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Food item cannot be null';
    END IF;
END//

DELIMITER ;

DELIMITER //

CREATE TRIGGER hotel_update_address_trigger
BEFORE UPDATE ON Hotel
FOR EACH ROW
BEGIN
    IF NEW.address IS NULL THEN
        SET NEW.address = 'Please update our address';
    END IF;
END//

DELIMITER ;

DELIMITER //

CREATE PROCEDURE InsertCustomer(
    IN p_customerId INT,
    IN p_name VARCHAR(255),
    IN p_address VARCHAR(255)
)
BEGIN
    -- Check if the customer already exists
    IF EXISTS (SELECT * FROM Customer WHERE customerId = p_customerId) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Customer ID already exists';
    ELSE
        -- Insert the new customer
        INSERT INTO Customer (customerId, name, address) VALUES (p_customerId, p_name, p_address);
        SELECT 'Customer inserted successfully' AS message;
    END IF;
END//

DELIMITER ;
CALL InsertCustomer(3, 'sai', '190 street ');

DELIMITER //

CREATE PROCEDURE InsertHotel(
    IN p_hotelId INT,
    IN p_name VARCHAR(255),
    IN p_address VARCHAR(255)
)
BEGIN
    -- Check if the hotel already exists
    IF EXISTS (SELECT * FROM Hotel WHERE hotelId = p_hotelId) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Hotel ID already exists';
    ELSE
        -- Insert the new hotel
        INSERT INTO Hotel (hotelId, name, address) VALUES (p_hotelId, p_name, p_address);
        SELECT 'Hotel inserted successfully' AS message;
    END IF;
END//

DELIMITER ;
CALL InsertHotel(3, 'motel', 'delhi');

DELIMITER //

CREATE PROCEDURE InsertRoom(
    IN p_roomId INT,
    IN p_hotelId INT,
    IN p_type VARCHAR(50),
    IN p_price DECIMAL(10, 2)
)
BEGIN
    -- Check if the hotelId exists in the Hotel table
    IF NOT EXISTS (SELECT * FROM Hotel WHERE hotelId = p_hotelId) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Hotel ID does not exist';
    ELSE
        -- Insert the new room
        INSERT INTO Room (roomId, hotelId, type, price) VALUES (p_roomId, p_hotelId, p_type, p_price);
        SELECT 'Room inserted successfully' AS message;
    END IF;
END//

DELIMITER ;
CALL InsertRoom(105, 1, 'Deluxe', 150.00);

DELIMITER //

CREATE PROCEDURE InsertAvailableRoom(
    IN p_roomId INT,
    IN p_dateFrom DATE,
    IN p_dateTo DATE
)
BEGIN
    -- Check if the roomId exists in the Room table
    IF NOT EXISTS (SELECT * FROM Room WHERE roomId = p_roomId) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Room ID does not exist';
    ELSE
        -- Check if the room is already available for the given date range
        IF EXISTS (SELECT * FROM Available_Rooms WHERE roomId = p_roomId AND p_dateFrom BETWEEN dateFrom AND dateTo) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Room is already available for the given date range';
        ELSE
            -- Insert the new available room entry
            INSERT INTO Available_Rooms (roomId, dateFrom, dateTo) VALUES (p_roomId, p_dateFrom, p_dateTo);
            SELECT 'Available room inserted successfully' AS message;
        END IF;
    END IF;
END//

DELIMITER ;
CALL InsertAvailableRoom(103, '2024-04-01', '2024-04-10');
CALL InsertAvailableRoom(1, '2024-04-01', '2024-04-10');

DELIMITER //

CREATE PROCEDURE CheckInOut(
    IN p_customerId INT,
    IN p_roomId INT,
    IN p_checkIn DATE,
    IN p_checkOut DATE
)
BEGIN
    -- Check if the customerId exists in the Customer table
    IF NOT EXISTS (SELECT * FROM Customer WHERE customerId = p_customerId) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Customer ID does not exist';
    ELSE
        -- Check if the roomId exists in the Room table
        IF NOT EXISTS (SELECT * FROM Room WHERE roomId = p_roomId) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Room ID does not exist';
        ELSE
            -- Insert the new check-in/check-out record
            INSERT INTO Check_IN_OUT (customerId, roomId, checkIn, checkOut) VALUES (p_customerId, p_roomId, p_checkIn, p_checkOut);
            SELECT 'Check-in/check-out record inserted successfully' AS message;
        END IF;
    END IF;
END//

DELIMITER ;
CALL CheckInOut(1, 103, '2024-04-01', '2024-04-05');

DELIMITER //

CREATE PROCEDURE InsertEmployee(
    IN p_employeeId INT,
    IN p_name VARCHAR(255),
    IN p_position VARCHAR(50),
    IN p_salary DECIMAL(10, 2)
)
BEGIN
    -- Check if the employeeId already exists
    IF EXISTS (SELECT * FROM Employee WHERE employeeId = p_employeeId) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Employee ID already exists';
    ELSE
        -- Insert the new employee
        INSERT INTO Employee (employeeId, name, position, salary) VALUES (p_employeeId, p_name, p_position, p_salary);
        SELECT 'Employee inserted successfully' AS message;
    END IF;
END//

DELIMITER ;
CALL InsertEmployee(3, 'sai', 'Manager', 50000.00);

DELIMITER //

CREATE PROCEDURE InsertReceptionist(
    IN p_employeeId INT,
    IN p_shift VARCHAR(50)
)
BEGIN
    -- Check if the employeeId exists in the Employee table
    IF NOT EXISTS (SELECT * FROM Employee WHERE employeeId = p_employeeId) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Employee ID does not exist';
    ELSE
        -- Insert the new receptionist
        INSERT INTO Receptionist (employeeId, shift) VALUES (p_employeeId, p_shift);
        SELECT 'Receptionist inserted successfully' AS message;
    END IF;
END//

DELIMITER ;
CALL InsertReceptionist(1, 'Morning');

DELIMITER //

CREATE PROCEDURE InsertAdmin(
    IN p_employeeId INT
)
BEGIN
    -- Check if the employeeId exists in the Employee table
    IF NOT EXISTS (SELECT * FROM Employee WHERE employeeId = p_employeeId) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Employee ID does not exist';
    ELSE
        -- Insert the new admin
        INSERT INTO Admin (employeeId) VALUES (p_employeeId);
        SELECT 'Admin inserted successfully' AS message;
    END IF;
END//

DELIMITER ;
CALL InsertAdmin(2);

DELIMITER //

CREATE PROCEDURE InsertReservation(
    IN p_reservationId INT,
    IN p_customerId INT,
    IN p_roomId INT,
    IN p_checkIn DATE,
    IN p_checkOut DATE
)
BEGIN
    -- Check if the customerId exists in the Customer table
    IF NOT EXISTS (SELECT * FROM Customer WHERE customerId = p_customerId) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Customer ID does not exist';
    ELSE
        -- Check if the roomId exists in the Room table
        IF NOT EXISTS (SELECT * FROM Room WHERE roomId = p_roomId) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Room ID does not exist';
        ELSE
            -- Insert the new reservation
            INSERT INTO Reservation (reservationId, customerId, roomId, checkIn, checkOut)
            VALUES (p_reservationId, p_customerId, p_roomId, p_checkIn, p_checkOut);
            SELECT 'Reservation inserted successfully' AS message;
        END IF;
    END IF;
END//

DELIMITER ;
CALL InsertReservation(1003, 1, 103, '2024-04-01', '2024-04-05');

DELIMITER //

CREATE PROCEDURE InsertPayment(
    IN p_paymentId INT,
    IN p_reservationId INT,
    IN p_amount DECIMAL(10, 2),
    IN p_paymentDate DATE
)
BEGIN
    -- Check if the reservationId exists in the Reservation table
    IF NOT EXISTS (SELECT * FROM Reservation WHERE reservationId = p_reservationId) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Reservation ID does not exist';
    ELSE
        -- Insert the new payment
        INSERT INTO Payment (paymentId, reservationId, amount, paymentDate)
        VALUES (p_paymentId, p_reservationId, p_amount, p_paymentDate);
        SELECT 'Payment inserted successfully' AS message;
    END IF;
END//

DELIMITER ;

CALL InsertPayment(1, 1003, 100.00, '2024-04-01');

DELIMITER //

CREATE PROCEDURE InsertInvoice(
    IN p_invoiceId INT,
    IN p_reservationId INT,
    IN p_total DECIMAL(10, 2),
    IN p_issueDate DATE
)
BEGIN
    -- Check if the reservationId exists in the Reservation table
    IF NOT EXISTS (SELECT * FROM Reservation WHERE reservationId = p_reservationId) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Reservation ID does not exist';
    ELSE
        -- Insert the new invoice
        INSERT INTO Invoice (invoiceId, reservationId, total, issueDate)
        VALUES (p_invoiceId, p_reservationId, p_total, p_issueDate);
        SELECT 'Invoice inserted successfully' AS message;
    END IF;
END//

DELIMITER ;
CALL InsertInvoice(1, 1003, 200.00, '2024-04-01');

DELIMITER //

CREATE PROCEDURE InsertRoomService(
    IN p_roomServiceId INT,
    IN p_roomId INT,
    IN p_orderDate DATE
)
BEGIN
    -- Check if the roomId exists in the Room table
    IF NOT EXISTS (SELECT * FROM Room WHERE roomId = p_roomId) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Room ID does not exist';
    ELSE
        -- Insert the new room service entry
        INSERT INTO Room_Service (roomServiceId, roomId, orderDate)
        VALUES (p_roomServiceId, p_roomId, p_orderDate);
        SELECT 'Room service inserted successfully' AS message;
    END IF;
END//

DELIMITER ;
CALL InsertRoomService(1, 103, '2024-04-01');

DELIMITER //

CREATE PROCEDURE InsertRoomServiceOrder(
    IN p_roomServiceId INT,
    IN p_foodItem VARCHAR(255),
    IN p_quantity INT,
    IN p_price DECIMAL(10, 2)
)
BEGIN
    -- Check if the roomServiceId exists in the Room_Service table
    IF NOT EXISTS (SELECT * FROM Room_Service WHERE roomServiceId = p_roomServiceId) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Room service ID does not exist';
    ELSE
        -- Insert the new room service order
        INSERT INTO Room_Service_Order (roomServiceId, foodItem, quantity, price)
        VALUES (p_roomServiceId, p_foodItem, p_quantity, p_price);
        SELECT 'Room service order inserted successfully' AS message;
    END IF;
END//

DELIMITER ;

CALL InsertRoomServiceOrder(2002, 'Breakfast', 2, 20.00);

DELIMITER //

CREATE PROCEDURE InsertFood(
    IN p_foodId INT,
    IN p_foodItem VARCHAR(255),
    IN p_roomId INT
)
BEGIN
    -- Check if the roomId exists in the Room table
    IF NOT EXISTS (SELECT * FROM Room WHERE roomId = p_roomId) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Room ID does not exist';
    ELSE
        -- Insert the new food item
        INSERT INTO Food (foodId, foodItem, roomId)
        VALUES (p_foodId, p_foodItem, p_roomId);
        SELECT 'Food item inserted successfully' AS message;
    END IF;
END//

DELIMITER ;

CALL InsertFood(1, 'Pizza', 101);

DELIMITER //

CREATE PROCEDURE IterateCustomerTable()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE customerId INT;
    DECLARE name VARCHAR(255);
    DECLARE address VARCHAR(255);
    DECLARE cur CURSOR FOR SELECT customerId, name, address FROM Customer;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO customerId, name, address;
        IF done THEN
            LEAVE read_loop;
        END IF;
        -- Process each row here (for example, print out the values)
        SELECT customerId, name, address;
    END LOOP;
    CLOSE cur;
END//
delimiter ;
CALL IterateCustomerTable();

delimiter //
CREATE PROCEDURE IterateHotelTable()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE hotelId INT;
    DECLARE name VARCHAR(255);
    DECLARE address VARCHAR(255);
    DECLARE cur CURSOR FOR SELECT hotelId, name, address FROM Hotel;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO hotelId, name, address;
        IF done THEN
            LEAVE read_loop;
        END IF;
        -- Process each row here (for example, print out the values)
        SELECT hotelId, name, address;
    END LOOP;
    CLOSE cur;
END//

-- Similarly, you can create procedures for other tables

DELIMITER ;
CALL IterateHotelTable();

CREATE VIEW view1 AS
SELECT * FROM Customer
UNION 
SELECT * FROM Hotel;
select * from view1;

CREATE VIEW Customer_Reservation_View AS
SELECT c.customerId, c.name AS customer_name, c.address,
       r.reservationId, r.roomId, r.checkIn, r.checkOut
FROM Customer c
INNER JOIN Reservation r ON c.customerId = r.customerId;
select * from Customer_Reservation_View;

CREATE VIEW Room_Availability_View AS
SELECT r.roomId, r.hotelId, r.type, r.price,
       ar.dateFrom, ar.dateTo
FROM Room r
LEFT JOIN Available_Rooms ar ON r.roomId = ar.roomId;
select * from Room_Availability_View;

CREATE VIEW Reservation_Payment_View AS
SELECT r.reservationId, r.customerId, r.roomId, r.checkIn, r.checkOut,
       p.amount, p.paymentDate
FROM Reservation r
LEFT JOIN Payment p ON r.reservationId = p.reservationId;
select * from Reservation_Payment_View;

CREATE VIEW Room_Service_View AS
SELECT r.roomId, r.type, r.price,
       rs.roomServiceId, rs.orderDate
FROM Room r
LEFT JOIN Room_Service rs ON r.roomId = rs.roomId;

select * from Room_Service_View;

CREATE VIEW Food_Room_Service_View AS
SELECT f.foodId, f.foodItem, f.roomId,
       r.type AS room_type, r.price AS room_price,
       rs.roomServiceId, rs.orderDate
FROM Food f
LEFT JOIN Room r ON f.roomId = r.roomId
LEFT JOIN Room_Service rs ON r.roomId = rs.roomId;
select * from Food_Room_Service_View;
