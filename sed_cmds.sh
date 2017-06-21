#!/bin/bash

# Customize - it says so IN THE SOURCE CODE!
sudo sed -i "s|US/Pacific|$(date +%Z)|g" ./WhereHows/data-model/DDL/ETL_DDL/kafka_tracking.sql

# JUNK! - NOT EVEN VALID CONSTAINTS!!!
sudo sed -i "s|\`owner_type\`      VARCHAR(50) DEFAULT NULL COMMENT 'which acl file this owner is in'|\`owner_type\`      VARCHAR(50) NOT NULL COMMENT 'which acl file this owner is in'|" ./WhereHows/data-model/DDL/ETL_DDL/git_metadata.sql
sudo sed -i "s|\`owner_name\`      VARCHAR(50) DEFAULT NULL COMMENT 'one owner name'|\`owner_name\`      VARCHAR(50) NOT NULL COMMENT 'one owner name'|" ./WhereHows/data-model/DDL/ETL_DDL/git_metadata.sql
sudo sed -i "s|PRIMARY KEY (\`dataset\`,\`cluster\`,\`partition_name\`,\`log_event_time\`)|PRIMARY KEY (\`dataset\`,\`cluster\`,\`log_event_time\`)|" ./WhereHows/data-model/DDL/ETL_DDL/kafka_tracking.sql
sudo sed -i "s|\`datacenter\`      VARCHAR(20)        DEFAULT NULL,|\`datacenter\`      VARCHAR(20)        NOT NULL,|" ./WhereHows/data-model/DDL/ETL_DDL/dataset_info_metadata.sql
