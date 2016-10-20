### Chapter 6: Inserting Data

USE test

INSERT INTO books (title)
VALUES('The Big Sleep'),
('Raymond Chandler'),
('1934');

USE rookery

INSERT INTO `bird_orders` VALUES (100,'Anseriformes','Waterfowl',NULL),(101,'Galliformes','Fowl',NULL),(102,'Charadriiformes','Gulls, Button Quails, Plovers',NULL),(103,'Gaviiformes','Loons',NULL),(104,'Podicipediformes','Grebes',NULL),(105,'Procellariiformes','Albatrosses, Petrels',NULL),(106,'Sphenisciformes','Penguins',NULL),(107,'Pelecaniformes','Pelicans',NULL),(108,'Phaethontiformes','Tropicbirds',NULL),(109,'Ciconiiformes','Storks',NULL),(110,'Cathartiformes','New-World Vultures',NULL),(111,'Phoenicopteriformes','Flamingos',NULL),(112,'Falconiformes','Falcons, Eagles, Hawks',NULL),(113,'Gruiformes','Cranes',NULL),(114,'Pteroclidiformes','Sandgrouse',NULL),(115,'Columbiformes','Doves and Pigeons',NULL),(116,'Psittaciformes','Parrots',NULL),(117,'Cuculiformes','Cuckoos and Turacos',NULL),(118,'Opisthocomiformes','Hoatzin',NULL),(119,'Strigiformes','Owls',NULL),(120,'Struthioniformes','Ostriches, Emus, Kiwis',NULL),(121,'Tinamiformes','Tinamous',NULL),(122,'Caprimulgiformes','Nightjars',NULL),(123,'Apodiformes','Swifts and Hummingbirds',NULL),(124,'Coraciiformes','Kingfishers',NULL),(125,'Piciformes','Woodpeckers',NULL),(126,'Trogoniformes','Trogons',NULL),(127,'Coliiformes','Mousebirds',NULL),(128,'Passeriformes','Passerines',NULL);

SELECT order_id FROM bird_orders
WHERE scientific_name = 'Gaviiformes';
