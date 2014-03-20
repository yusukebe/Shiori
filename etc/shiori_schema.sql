CREATE TABLE bookmark (
    id INT UNSIGNED AUTO_INCREMENT,
    url TEXT NOT NULL,
    created_at DATETIME NOT NULL,
    updated_at DATETIME NOT NULL,
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET 'utf8' engine=InnoDB;
