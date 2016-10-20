### Chapter 6: Inserting Data

USE test

INSERT INTO books (title)
VALUES('The Big Sleep'),
('Raymond Chandler'),
('1934');

USE rookery

INSERT INTO `bird_orders`
VALUES
(100,'Anseriformes','Waterfowl',NULL),
(101,'Galliformes','Fowl',NULL),
(102,'Charadriiformes','Gulls, Button Quails, Plovers',NULL),
(103,'Gaviiformes','Loons',NULL),
(104,'Podicipediformes','Grebes',NULL),
(105,'Procellariiformes','Albatrosses, Petrels',NULL),
(106,'Sphenisciformes','Penguins',NULL),
(107,'Pelecaniformes','Pelicans',NULL),
(108,'Phaethontiformes','Tropicbirds',NULL),
(109,'Ciconiiformes','Storks',NULL),
(110,'Cathartiformes','New-World Vultures',NULL),
(111,'Phoenicopteriformes','Flamingos',NULL),
(112,'Falconiformes','Falcons, Eagles, Hawks',NULL),
(113,'Gruiformes','Cranes',NULL),
(114,'Pteroclidiformes','Sandgrouse',NULL),
(115,'Columbiformes','Doves and Pigeons',NULL),
(116,'Psittaciformes','Parrots',NULL),
(117,'Cuculiformes','Cuckoos and Turacos',NULL),
(118,'Opisthocomiformes','Hoatzin',NULL),
(119,'Strigiformes','Owls',NULL),
(120,'Struthioniformes','Ostriches, Emus, Kiwis',NULL),
(121,'Tinamiformes','Tinamous',NULL),
(122,'Caprimulgiformes','Nightjars',NULL),
(123,'Apodiformes','Swifts and Hummingbirds',NULL),
(124,'Coraciiformes','Kingfishers',NULL),
(125,'Piciformes','Woodpeckers',NULL),
(126,'Trogoniformes','Trogons',NULL),
(127,'Coliiformes','Mousebirds',NULL),
(128,'Passeriformes','Passerines',NULL);

SELECT order_id FROM bird_orders
WHERE scientific_name = 'Gaviiformes';

DESCRIBE bird_families;

# Enter a new family into bird_families table

INSERT INTO bird_families
VALUES
(100, 'Gavilidae', "Loons or divers are aquatic birds found mainly 
    in the Northern Hemisphere.", 103);
# family_id increments automatically, but since the above statement 
# sets family_id to 100, it will increment starting at 101 next

SELECT * FROM bird_families;

# Next statement inserts data out of order, will generate ERROR
INSERT INTO bird_families
VALUES
('Anatidae', "This family includes ducks, geese, and swans.", NULL, 103);

SELECT * FROM bird_families \G

INSERT INTO bird_families
(scientific_name, order_id, brief_description)
VALUES('Anatidae', 103, "This family includes ducks, geese, and swans.");

SELECT order_id, scientific_name FROM bird_orders;

# Insert bird families into table

INSERT INTO bird_families
(scientific_name, order_id)
VALUES
('Charadriidae', 109),
('Laridae', 102),
('Sternidae', 102),
('Caprimulgidae', 122),
('Sittidae', 128),
('Picidae', 125),
('Accipitridae', 112),
('Tyrannidae', 128),
('Formicariidae', 128),
('Laniidae', 128);

SELECT family_id, scientific_name
FROM bird_families
ORDER BY scientific_name;

SHOW COLUMNS FROM birds;

SHOW COLUMNS FROM birds LIKE '%id';

INSERT INTO birds
(common_name, scientific_name, family_id, conservation_status_id)
VALUES
('Mountain Plover', 'Charadrius montanus', 103, 7);


INSERT INTO birds
(common_name, scientific_name, family_id, conservation_status_id)
VALUES
('Snowy Plover', 'Charadrius alexandrinus', 103, 7),
('Black-bellied Plover', 'Pluvialis squatarola', 103, 7),
('Pacific Golden Plover', 'Pluvialis fulva', 103, 7);

# Connecting a few tables through SELECT statement

SELECT common_name AS 'Bird',
    birds.scientific_name AS 'Scientific Name',
    bird_families.sicentific_name AS 'Family',
    bird_orders.scientific_name AS 'Order'
FROM birds,
    bird_families,
    bird_orders
WHERE birds.family_id = bird_families.family_id
AND bird_families.order_id = bird_orders.order_id;
