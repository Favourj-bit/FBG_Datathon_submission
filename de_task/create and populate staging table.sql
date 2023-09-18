create or replace table DFA23RAWDATA.FBG1200.staging_crop_data(
    TIMESTAMP     timestamp,
    CROP_TYPE    varchar(20),
    CROP_YIELD    float,
    GROWTH_STAGE    varchar(20),
    PEST_ISSUE    varchar(20)
    
);

create or replace table DFA23RAWDATA.FBG1200.staging_irrigation_data(
    SENSOR_ID    varchar(20),
    TIMESTAMP    timestamp,
    IRRIGATION_METHOD	varchar(20),
    WATER_SOURCE	varchar(20),
    IRRIGATION_DURATION_MIN int
);

create or replace table DFA23RAWDATA.FBG1200.staging_pest_data(
    TIMESTAMP    timestamp,
    PEST_TYPE	varchar(20),
    PEST_DESCRIPTION    string,	
    PEST_SEVERITY varchar(20)
);

create or replace table DFA23RAWDATA.FBG1200.staging_sensor_raw_data(
    SENSOR_ID    varchar(20),
    TIMESTAMP    timestamp,
    TEMPERATURE    float,
    HUMIDITY float,
    SOIL_MOISTURE    float,
    LIGHT_INTENSITY float,
    BATTERY_LEVEL    float
);

create or replace table DFA23RAWDATA.FBG1200.staging_soil_raw_data(
    TIMESTAMP   timestamp,
    SOIL_COMP   float,
    SOIL_MOISTURE   float,
    SOIL_PH float,
    NITROGEN_LEVEL  float,
    PHOSPHORUS_LEVEL    float,
    ORGANIC_MATTER  float
);

create or replace table DFA23RAWDATA.FBG1200.staging_weather_raw_data (
    TIMESTAMP timestamp,
    WEATHER_CONDITION varchar(20),
    WIND_SPEED float,
    PRECIPITATION float
);

create or replace table DFA23RAWDATA.FBG1200.staging_location_raw_data (
    SENSOR_ID   varchar(20),
    LOCATION_NAME   varchar(20),
    LATITUDE    float,
    LONGITUDE   float,
    ELEVATION   float,
    REGION  varchar(20)
);




insert into DFA23RAWDATA.FBG1200.staging_crop_data
select 
    TO_TIMESTAMP(TIMESTAMP, 'MM/DD/YYYY HH24:MI'), 
    CROP_TYPE, 
    try_cast(CROP_YIELD as float), 
    GROWTH_STAGE, 
    PEST_ISSUE
from DFA23RAWDATA.RAWDATA.CROPDATARAW;

insert into DFA23RAWDATA.FBG1200.staging_irrigation_data
select 
    SENSOR_ID,
    TO_TIMESTAMP(TIMESTAMP, 'MM/DD/YYYY HH24:MI'),
    IRRIGATION_METHOD,
    WATER_SOURCE,
    try_cast(IRRIGATION_DURATION_MIN as float)
from DFA23RAWDATA.RAWDATA.IRRIGATIONDATARAW;

insert into DFA23RAWDATA.FBG1200.staging_pest_data
select 
    TO_TIMESTAMP(TIMESTAMP, 'MM/DD/YYYY HH24:MI'),
    PEST_TYPE,
    PEST_DESCRIPTION,
    PEST_SEVERITY
from DFA23RAWDATA.RAWDATA.PESTDATARAW;

insert into DFA23RAWDATA.FBG1200.staging_sensor_raw_data
select 
    SENSOR_ID,
    TO_TIMESTAMP(REGEXP_REPLACE(TIMESTAMP, '"', ''), 'YYYY-MM-DD HH24:MI:SS'),
    try_cast(TEMPERATURE as float),
    try_cast(HUMIDITY as float),
    try_cast(SOIL_MOISTURE as float),
    try_cast(LIGHT_INTENSITY as float),
    try_cast(BATTERY_LEVEL as float)
from DFA23RAWDATA.RAWDATA.SENSORDATARAW;

insert into DFA23RAWDATA.FBG1200.staging_soil_raw_data
select 
    TO_TIMESTAMP(TIMESTAMP, 'MM/DD/YYYY HH24:MI'),
    try_cast(SOIL_COMP as float),
    try_cast(SOIL_MOISTURE as float),
    try_cast(SOIL_PH as float),
    try_cast(NITROGEN_LEVEL as float),
    try_cast(PHOSPHORUS_LEVEL as float),
    try_cast(ORGANIC_MATTER as float)
from DFA23RAWDATA.RAWDATA.SOILDATARAW;

insert into DFA23RAWDATA.FBG1200.staging_weather_raw_data
select TO_TIMESTAMP(TIMESTAMP, 'MM/DD/YYYY HH24:MI'),
    WEATHER_CONDITION,
    try_cast(WIND_SPEED as float),
    try_cast(PRECIPITATION as float)
from DFA23RAWDATA.RAWDATA.WEATHERDATARAW;

insert into DFA23RAWDATA.FBG1200.staging_location_raw_data
select SENSOR_ID,
    LOCATION_NAME,
    try_cast(LATITUDE as float),
    try_cast(LONGITUDE as float),
    try_cast(ELEVATION as float),
    REGION
from DFA23RAWDATA.RAWDATA.LOCATIONDATARAW;
