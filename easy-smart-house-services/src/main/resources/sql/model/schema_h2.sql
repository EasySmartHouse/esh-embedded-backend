CREATE TABLE IF NOT EXISTS
	IMAGES (
		ID BIGINT AUTO_INCREMENT PRIMARY KEY,
		FILE_NAME VARCHAR NOT NULL,
		FILE_CONTENT BLOB NOT NULL,
		UNIQUE KEY FILE_NAME_UNIQUE (FILE_NAME)
	);
CREATE INDEX IF NOT EXISTS IMAGES_FILE_NAME ON IMAGES(FILE_NAME);

CREATE TABLE IF NOT EXISTS
	SPACES (
		ID BIGINT AUTO_INCREMENT PRIMARY KEY,
		NAME VARCHAR(30) NOT NULL,
		IMAGE BIGINT NOT NULL,
		FOREIGN KEY(IMAGE) REFERENCES IMAGES(ID)
	);

CREATE ALIAS IF NOT EXISTS FT_INIT FOR "org.h2.fulltext.FullText.init";
CALL FT_INIT();

CREATE TABLE IF NOT EXISTS
	SENSORS (
		ID BIGINT AUTO_INCREMENT PRIMARY KEY,
		ADDRESS VARCHAR(30) NOT NULL,
		LABEL VARCHAR(30) NOT NULL,
		DESCRIPTION VARCHAR,
		ENABLED BOOLEAN NOT NULL,
		SENSOR_TYPE VARCHAR(20) NOT NULL,
		SPACE_ID BIGINT NOT NULL,
		FOREIGN KEY(SPACE_ID) REFERENCES SPACES(ID)
	);
CREATE INDEX IF NOT EXISTS SENSORS_ADDRESS ON SENSORS(ADDRESS);
CREATE INDEX IF NOT EXISTS SENSORS_LABEL ON SENSORS(LABEL);
CALL FT_CREATE_INDEX('PUBLIC', 'SENSORS', NULL);

CREATE TABLE IF NOT EXISTS
	ACTUATORS (
		ID BIGINT AUTO_INCREMENT PRIMARY KEY,
		ADDRESS VARCHAR(30) NOT NULL,
		LABEL VARCHAR(30) NOT NULL,
		DESCRIPTION VARCHAR,
		ENABLED BOOLEAN NOT NULL,
		ACTUATOR_TYPE VARCHAR(20) NOT NULL,
		SPACE_ID BIGINT NOT NULL,
        FOREIGN KEY(SPACE_ID) REFERENCES SPACES(ID)
	);
CREATE INDEX IF NOT EXISTS ACTUATORS_ADDRESS ON ACTUATORS(ADDRESS);
CREATE INDEX IF NOT EXISTS ACTUATORS_LABEL ON ACTUATORS(LABEL);
CALL FT_CREATE_INDEX('PUBLIC', 'ACTUATORS', NULL);

CREATE TABLE IF NOT EXISTS
	ADJUSTABLE_ACTUATORS (
		ACTUATOR BIGINT NOT NULL,
		MIN_VALUE DOUBLE NOT NULL,
		MAX_VALUE DOUBLE NOT NULL,
		CHANGE_STEP DOUBLE NOT NULL,
		DEFAULT_VALUE DOUBLE NOT NULL,
		FOREIGN KEY(ACTUATOR) REFERENCES ACTUATORS(ID),
		SPACE_ID BIGINT NOT NULL,
        FOREIGN KEY(SPACE_ID) REFERENCES SPACES(ID)
	);

CREATE TABLE IF NOT EXISTS
	SIGNALING_ELEMENT (
		ID BIGINT AUTO_INCREMENT PRIMARY KEY,
		DEVICE_ADDRESS VARCHAR(30) NOT NULL,
		ACTUATOR_ADDRESS VARCHAR(30),
		LABEL VARCHAR(30) NOT NULL,
		ENABLED BOOLEAN NOT NULL,
		SPACE_ID BIGINT NOT NULL,
        FOREIGN KEY(SPACE_ID) REFERENCES SPACES(ID)
	);
CREATE INDEX IF NOT EXISTS SIGNALING_ELEMENT_ADDRESS ON SIGNALING_ELEMENT(DEVICE_ADDRESS);
CALL FT_CREATE_INDEX('PUBLIC', 'SIGNALING_ELEMENT', NULL);

CREATE TABLE IF NOT EXISTS
	TRIGGER_CONDITION (
		ID BIGINT AUTO_INCREMENT PRIMARY KEY,
		EXPRESSION VARCHAR NOT NULL
	);

CREATE TABLE IF NOT EXISTS
	ACTUATOR_TRIGGER (
		ID BIGINT AUTO_INCREMENT PRIMARY KEY,
		NAME VARCHAR(30) NOT NULL,
		ENABLED BOOLEAN NOT NULL,
        ACTUATOR_ADDRESS VARCHAR(30) NOT NULL,
        ACTUATOR_VALUE BOOLEAN NOT NULL,
        CONDITION BIGINT NOT NULL,
        FOREIGN KEY(CONDITION) REFERENCES TRIGGER_CONDITION(ID),
        SPACE_ID BIGINT NOT NULL,
        FOREIGN KEY(SPACE_ID) REFERENCES SPACES(ID)
	);

CREATE TABLE IF NOT EXISTS
	USERS (
		ID BIGINT AUTO_INCREMENT PRIMARY KEY,
		USERNAME VARCHAR(50) NOT NULL,
		PASSWORD VARCHAR(60) NOT NULL,
		ENABLED BOOLEAN NOT NULL,
        FIRST_NAME VARCHAR(50) NOT NULL,
        LAST_NAME VARCHAR(50) NOT NULL,
        EMAIL VARCHAR(50) NOT NULL,
        UNIQUE KEY USERNAME_UNIQUE (USERNAME),
        UNIQUE KEY EMAIL_UNIQUE (EMAIL)
	);

CREATE TABLE IF NOT EXISTS AUTHORITIES (
     USER_ID BIGINT NOT NULL,
     ROLE VARCHAR(10) NOT NULL,
     FOREIGN KEY(USER_ID) REFERENCES USERS(ID),
     UNIQUE KEY USER_ROLE_UNIQUE (USER_ID, ROLE)
);

CREATE TABLE IF NOT EXISTS VERIFICATION_TOKEN (
     ID BIGINT AUTO_INCREMENT PRIMARY KEY,
     TOKEN VARCHAR(40) NOT NULL,
     EXPIRY_DATE TIMESTAMP NOT NULL,
     USER_ID BIGINT NOT NULL,
     FOREIGN KEY(USER_ID) REFERENCES USERS(ID)
);






