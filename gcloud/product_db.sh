#!/bin/bash


cloudsql_master=$1

cloudsql_master_ip=`(gcloud sql instances describe $cloudsql_master | yq eval '.ipAddresses[] | select(.type == "PRIMARY") | .ipAddress')`

mysql -h $cloudsql_master_ip --user=root --password=redis << EOF
CREATE DATABASE IF NOT EXISTS acme;
EOF


mysql -h $cloudsql_master_ip --user=root --password=redis acme << EOF
CREATE TABLE IF NOT EXISTS product (
	id int unsigned COLLATE utf8mb4_unicode_ci NOT NULL AUTO_INCREMENT,
	name varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
	code varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
	image text COLLATE utf8mb4_unicode_ci NOT NULL,
	price double COLLATE utf8mb4_unicode_ci NOT NULL,
	PRIMARY KEY (id)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4;
EOF


mysql -h $cloudsql_master_ip --user=root --password=redis acme << EOF
INSERT INTO product (id, name, code, image, price) VALUES
	(33, 'On Cloud X running shoes ', 'SH01', 'product-images/shoes.jpg', 150.00),
	(84, 'Apple Macbook Pro 13', 'NB04', 'product-images/laptop.jpg', 1500.00),
	(15, 'Canon EOS D5 MARK IV', 'DC01', 'product-images/camera.jpg', 3000.00),
	(26, 'Apple iPhone Pro 13', 'MP01', 'product-images/mobile.jpg', 1200.00),
	(77, 'Rolex Green Submarina', 'Watch01', 'product-images/watch.jpg', 3000.00),
	(82, 'Beats Headphone (Black/Red)', 'HD08', 'product-images/headphone.jpg', 220.00),
	(96, 'Panerai Luminor Ceramica', 'Watch02', 'product-images/pam_watch.png',159.00),
	(21, 'Frank Muller - Cintree Curvex', 'Watch03', 'product-images/frank_watch.png', 3000.00),
	(11, 'Google Pixel 6 Pro (512GB)', 'MP02', 'product-images/pixel6pro_mp.png', 1099.00),
	(52, 'Emporio Armani Sneakers', 'SH02', 'product-images/emporio_shoes.png', 220.00),
	(64, 'Asics Gel Venture 8 Running', 'SH03', 'product-images/asics_shoes.png', 70.00),
	(88, 'Beats Studio Buds (RED)', 'HD04', 'product-images/beats_hs.jpg', 120.00);
EOF
