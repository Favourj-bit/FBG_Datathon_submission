CREATE OR REPLACE TABLE DFA23RAWDATA.FBG1200.dim_crop (
    crop_id INT AUTOINCREMENT PRIMARY KEY,
    crop_type VARCHAR(20) NOT NULL,
    growth_stage VARCHAR(20),
    pest_issue VARCHAR(20)
);

INSERT INTO DFA23RAWDATA.FBG1200.dim_crop (crop_type, growth_stage, pest_issue)
SELECT CROP_TYPE, GROWTH_STAGE, PEST_ISSUE
FROM DFA23RAWDATA.FBG1200.staging_crop_data
GROUP BY CROP_TYPE, GROWTH_STAGE, PEST_ISSUE;

CREATE OR REPLACE TABLE DFA23RAWDATA.FBG1200.dim_irrigation_method (
    irrigation_method_id INT AUTOINCREMENT PRIMARY KEY,
    irrigation_method VARCHAR(20) NOT NULL,
    water_source VARCHAR(20)
);

INSERT INTO DFA23RAWDATA.FBG1200.dim_irrigation_method (irrigation_method, water_source)
SELECT IRRIGATION_METHOD, WATER_SOURCE
FROM DFA23RAWDATA.FBG1200.staging_irrigation_data
GROUP BY IRRIGATION_METHOD, WATER_SOURCE;

CREATE OR REPLACE TABLE DFA23RAWDATA.FBG1200.dim_pest (
    pest_id INT AUTOINCREMENT PRIMARY KEY,
    pest_type VARCHAR(20) NOT NULL,
    pest_description STRING,
    pest_severity VARCHAR(20)
);

INSERT INTO DFA23RAWDATA.FBG1200.dim_pest (pest_type, pest_description, pest_severity)
SELECT PEST_TYPE, PEST_DESCRIPTION, PEST_SEVERITY
FROM DFA23RAWDATA.FBG1200.staging_pest_data
GROUP BY PEST_TYPE, PEST_DESCRIPTION, PEST_SEVERITY;

CREATE OR REPLACE TABLE DFA23RAWDATA.FBG1200.dim_sensor (
    sensor_id VARCHAR(20) PRIMARY KEY,
    location_name VARCHAR(20),
    latitude FLOAT,
    longitude FLOAT,
    elevation FLOAT,
    region VARCHAR(20)
);

INSERT INTO DFA23RAWDATA.FBG1200.dim_sensor (sensor_id, location_name, latitude, longitude, elevation, region)
SELECT SENSOR_ID, LOCATION_NAME, LATITUDE, LONGITUDE, ELEVATION, REGION
FROM DFA23RAWDATA.FBG1200.staging_location_raw_data
GROUP BY SENSOR_ID, LOCATION_NAME, LATITUDE, LONGITUDE, ELEVATION, REGION;

CREATE OR REPLACE TABLE DFA23RAWDATA.FBG1200.dim_date (
    date_id INT AUTOINCREMENT PRIMARY KEY,
    date TIMESTAMP
);

INSERT INTO DFA23RAWDATA.FBG1200.dim_date (date)
SELECT TIMESTAMP
FROM (
    SELECT TIMESTAMP FROM DFA23RAWDATA.FBG1200.staging_crop_data
    UNION
    SELECT TIMESTAMP FROM DFA23RAWDATA.FBG1200.staging_irrigation_data
    UNION
    SELECT TIMESTAMP FROM DFA23RAWDATA.FBG1200.staging_pest_data
    UNION
    SELECT TIMESTAMP FROM DFA23RAWDATA.FBG1200.staging_sensor_raw_data
    UNION
    SELECT TIMESTAMP FROM DFA23RAWDATA.FBG1200.staging_soil_raw_data
    UNION
    SELECT TIMESTAMP FROM DFA23RAWDATA.FBG1200.staging_weather_raw_data
) AS all_timestamps
GROUP BY TIMESTAMP;

CREATE OR REPLACE TABLE DFA23RAWDATA.FBG1200.fact_crop_yield (
    date_id INT,
    crop_id INT,
    yield FLOAT,
    PRIMARY KEY (date_id, crop_id),
    FOREIGN KEY (date_id) REFERENCES dim_date(date_id),
    FOREIGN KEY (crop_id) REFERENCES dim_crop(crop_id)
);

INSERT INTO DFA23RAWDATA.FBG1200.fact_crop_yield (date_id, crop_id, yield)
SELECT dd.date_id, dc.crop_id, scd.crop_yield
FROM DFA23RAWDATA.FBG1200.staging_crop_data scd
JOIN DFA23RAWDATA.FBG1200.dim_date dd ON scd.TIMESTAMP = dd.date
JOIN DFA23RAWDATA.FBG1200.dim_crop dc ON scd.CROP_TYPE = dc.crop_type;

CREATE OR REPLACE TABLE DFA23RAWDATA.FBG1200.fact_irrigation (
    date_id INT,
    sensor_id VARCHAR(20),
    irrigation_method_id INT,
    duration_minutes INT,
    PRIMARY KEY (date_id, sensor_id),
    FOREIGN KEY (date_id) REFERENCES dim_date(date_id),
    FOREIGN KEY (sensor_id) REFERENCES dim_sensor(sensor_id),
    FOREIGN KEY (irrigation_method_id) REFERENCES dim_irrigation_method(irrigation_method_id)
);

INSERT INTO DFA23RAWDATA.FBG1200.fact_irrigation (date_id, sensor_id, irrigation_method_id, duration_minutes)
SELECT dd.date_id, sid.sensor_id, dim.irrigation_method_id, sid.IRRIGATION_DURATION_MIN
FROM DFA23RAWDATA.FBG1200.staging_irrigation_data sid
JOIN DFA23RAWDATA.FBG1200.dim_date dd ON sid.TIMESTAMP = dd.date
JOIN DFA23RAWDATA.FBG1200.dim_sensor ds ON sid.SENSOR_ID = ds.sensor_id
JOIN DFA23RAWDATA.FBG1200.dim_irrigation_method dim ON sid.IRRIGATION_METHOD = dim.irrigation_method;

CREATE OR REPLACE TABLE DFA23RAWDATA.FBG1200.fact_pest_incident (
    date_id INT,
    pest_id INT,
    PRIMARY KEY (date_id, pest_id),
    FOREIGN KEY (date_id) REFERENCES dim_date(date_id),
    FOREIGN KEY (pest_id) REFERENCES dim_pest(pest_id)
);

INSERT INTO DFA23RAWDATA.FBG1200.fact_pest_incident (date_id, pest_id)
SELECT dd.date_id, dp.pest_id
FROM DFA23RAWDATA.FBG1200.staging_pest_data pd
JOIN DFA23RAWDATA.FBG1200.dim_date dd ON pd.TIMESTAMP = dd.date
JOIN DFA23RAWDATA.FBG1200.dim_pest dp ON pd.PEST_TYPE = dp.pest_type;

CREATE OR REPLACE TABLE DFA23RAWDATA.FBG1200.fact_sensor_data (
    date_id INT,
    sensor_id VARCHAR(20),
    temperature FLOAT,
    humidity FLOAT,
    soil_moisture FLOAT,
    light_intensity FLOAT,
    battery_level FLOAT,
    PRIMARY KEY (date_id, sensor_id),
    FOREIGN KEY (date_id) REFERENCES dim_date(date_id),
    FOREIGN KEY (sensor_id) REFERENCES dim_sensor(sensor_id)
);

INSERT INTO DFA23RAWDATA.FBG1200.fact_sensor_data (date_id, sensor_id, temperature, humidity, soil_moisture, light_intensity, battery_level)
SELECT dd.date_id, srd.SENSOR_ID, srd.TEMPERATURE, srd.HUMIDITY, srd.SOIL_MOISTURE, srd.LIGHT_INTENSITY, srd.BATTERY_LEVEL
FROM DFA23RAWDATA.FBG1200.staging_sensor_raw_data srd
JOIN DFA23RAWDATA.FBG1200.dim_date dd ON srd.TIMESTAMP = dd.date;


CREATE OR REPLACE TABLE DFA23RAWDATA.FBG1200.fact_soil_data (
    date_id INT,
    soil_comp FLOAT,
    soil_moisture FLOAT,
    soil_ph FLOAT,
    nitrogen_level FLOAT,
    phosphorus_level FLOAT,
    organic_matter FLOAT,
    PRIMARY KEY (date_id),
    FOREIGN KEY (date_id) REFERENCES dim_date(date_id)
);

INSERT INTO DFA23RAWDATA.FBG1200.fact_soil_data (date_id, soil_comp, soil_moisture, soil_ph, nitrogen_level, phosphorus_level, organic_matter)
SELECT dd.date_id, ssd.SOIL_COMP, ssd.SOIL_MOISTURE, ssd.SOIL_PH, ssd.NITROGEN_LEVEL, ssd.PHOSPHORUS_LEVEL, ssd.ORGANIC_MATTER
FROM DFA23RAWDATA.FBG1200.staging_soil_raw_data ssd
JOIN DFA23RAWDATA.FBG1200.dim_date dd ON ssd.TIMESTAMP = dd.date;

CREATE OR REPLACE TABLE DFA23RAWDATA.FBG1200.fact_weather (
    date_id INT,
    weather_condition VARCHAR(20),
    wind_speed FLOAT,
    precipitation FLOAT,
    PRIMARY KEY (date_id),
    FOREIGN KEY (date_id) REFERENCES dim_date(date_id)
);

INSERT INTO DFA23RAWDATA.FBG1200.fact_weather (date_id, weather_condition, wind_speed, precipitation)
SELECT dd.date_id, swd.WEATHER_CONDITION, swd.WIND_SPEED, swd.PRECIPITATION
FROM DFA23RAWDATA.FBG1200.staging_weather_raw_data swd
JOIN DFA23RAWDATA.FBG1200.dim_date dd ON swd.TIMESTAMP = dd.date;

