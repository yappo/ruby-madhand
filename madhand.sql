CREATE TABLE madhand_binlog (
    id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    log_type   TINYINT UNSIGNED NOT NULL, -- 1=load 2=delete
    table_name VARCHAR(255) NOT NULL,
    log        BLOB NOT NULL,
    created_at INT UNSIGNED NOT NULL,

    PRIMARY KEY(id)
) ENGINE=InnoDB;
