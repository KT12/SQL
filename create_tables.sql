### Notes for Learning MySQL and MariaDB Chapter 4

CREATE TABLE `birds_wing_shapes` (
  `wing_id` char(2) COLLATE latin1_bin NOT NULL,
  `wing_shape` char(25) COLLATE latin1_bin DEFAULT NULL,
  `wing_example` blob,
  PRIMARY KEY (`wing_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


CREATE TABLE `birds_body_shapes` (
  `body_id` char(3) COLLATE latin1_bin NOT NULL,
  `body_shape` char(25) COLLATE latin1_bin DEFAULT NULL,
  `body_example` blob,
  PRIMARY KEY (`body_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `birds_bill_shapes` (
  `bill_id` char(3) COLLATE latin1_bin NOT NULL,
  `bill_shape` char(25) COLLATE latin1_bin DEFAULT NULL,
  `bill_example` blob,
  PRIMARY KEY (`bill_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
