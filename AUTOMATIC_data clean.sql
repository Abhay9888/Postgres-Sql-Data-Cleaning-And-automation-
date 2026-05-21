SET SEARCH_PATH TO cardekho, CARDEKHO;

CREATE OR REPLACE PROCEDURE cardekho.sp_clean_cardekho_data()
LANGUAGE plpgsql
AS $$
BEGIN

UPDATE CAR
SET BRAND = 
CASE
   WHEN BRAND LIKE '%Maru%' then 'Maruti'
   WHEN BRAND LIKE '%Ford%' then 'Ford'
   WHEN BRAND LIKE '%Mahin%' then 'Mahindra'
   WHEN BRAND LIKE '%Hyun%' then 'Hyundai'
   WHEN BRAND LIKE '%Hon%' then 'Honda'
   WHEN BRAND LIKE '%Volk%' then 'Volkswagen'
   WHEN BRAND LIKE '%BMW%' then 'BMW'
   WHEN BRAND LIKE '%Volvo%' then 'Volvo'
   WHEN BRAND LIKE '%Toyo%' then 'Toyota'
   WHEN BRAND LIKE '%Pors%' then 'Porsche'
   WHEN BRAND LIKE '%Tata%' then 'Tata'
   WHEN BRAND LIKE '%Rena%' then 'Renault'
   WHEN BRAND LIKE '%Dats%' then 'Datsun'
   WHEN BRAND LIKE '%Skoda%' then 'Skoda'
ELSE CAST(BRAND AS VARCHAR)
END;

UPDATE CAR
SET MODEL = 
CASE
   WHEN Model LIKE '%City%' then 'City'
   WHEN Model LIKE '%Polo%' then 'Polo'
   WHEN Model LIKE '%KWI%' then 'Kwid'
   WHEN Model LIKE '%Duster%' then 'Duster'
   WHEN Model LIKE '%Balen%' then 'Baleno'
   WHEN Model LIKE '%Cret%' then 'Creta'
   WHEN Model LIKE '%Fortu%' then 'Fortuner'
   WHEN Model LIKE '%Grand%' then 'Grand'
   WHEN Model LIKE '%Hexa%' then 'Hexa'
   WHEN Model LIKE '%i20%' then 'i20'
   WHEN Model LIKE '%Rove%' then 'Rover'
   WHEN Model LIKE '%Scorpio%' then 'Scorpio'
   WHEN Model LIKE '%Tiago%' then 'Tiago'
   WHEN Model LIKE '%Vento%' then 'Vento'
   WHEN Model LIKE '%Verna%' then 'Verna'
   WHEN Model LIKE '%Vitara%' then 'Viata'
   WHEN Model LIKE '%Wagon R%' then 'Wagon R'
   WHEN Model LIKE '%WR-V%' then 'WR-V'
   WHEN Model LIKE '%XUV500%' then 'XUV500'
   WHEN Model LIKE '%Alto%' then 'Alto'
   WHEN Model LIKE '%Swift_Dzire%' then 'Dzire'
   WHEN Model LIKE '%Swift%' then 'Swift'
   WHEN MODEL = 'ajajaxsda' then 'Aura'
   ELSE CAST(Model AS VARCHAR)
END;

UPDATE CAR
SET BRAND = 
CASE
WHEN MODEL IN ('Wagon R','Swift Dzire','S-Presso','Alto','Baleno','Ertiga','Eeco','Ignis','Viata','Ciaz','XL6','Celerio') THEN 'Maruti'
WHEN MODEL IN ('Duster','Kwid','Triber') THEN 'Renault'
WHEN MODEL IN ('Scorpio','Marazzo','Thar','XUV500','XUV300','KUV','Bolero','KUV100') THEN 'Mahindra' 
WHEN MODEL IN ('i20','Verna','Santro','Venue','i10','Elantra','Creta','Aura','Grand') THEN 'Hyundai' 
WHEN MODEL IN ('City','Civic','Jazz','Amaze','CR-V','WR-V') THEN 'Honda' 
WHEN MODEL IN ('Figo','Endeavour','Freestyle','Aspire','Ecosport') THEN 'Ford' 
WHEN MODEL IN ('Vento','Polo') THEN 'Volkswagen' 
WHEN MODEL IN ('X5','7','Z4','5','X1','6','3') THEN 'BMW'
WHEN MODEL IN ('S90','XC') THEN 'Volvo'
WHEN MODEL IN ('Innova','Camry','Yaris' ,'Fortuner') THEN 'Toyota'
WHEN MODEL IN ('Tiago','Hexa','Safari','Nexon','Tigor') THEN 'Tata'
ELSE CAST(BRAND AS VARCHAR)
END;

UPDATE CAR SET MODEL = null  where model in ('N/a','NA','Unknown','UnKNown','UNKNOWN');

UPDATE car c1
SET model = c2.model
FROM car c2
WHERE c1.engine = c2.engine
AND c1.max_power = c2.max_power                                    
AND c1.model IS NULL
AND c2.model IS NOT NULL;

UPDATE CAR SET KM_DRIVEN = REGEXP_REPLACE(KM_DRIVEN, '[^0-9.]','','g');
UPDATE CAR SET VEHICLE_AGE = REGEXP_REPLACE(VEHICLE_AGE, '[^0-9.]', '', 'g');

ALTER TABLE CAR
ALTER COLUMN VEHICLE_AGE TYPE NUMERIC                             
USING VEHICLE_AGE::NUMERIC;

ALTER TABLE CAR
ALTER COLUMN KM_DRIVEN TYPE NUMERIC
USING KM_DRIVEN::NUMERIC;

UPDATE CAR
SET VEHICLE_AGE = ABS(VEHICLE_AGE); 

UPDATE CAR
SET KM_DRIVEN = ABS(KM_DRIVEN);

UPDATE CAR
SET SELLER_TYPE = 
CASE
 WHEN SELLER_TYPE LIKE '%Trustmark_D' THEN 'Trustmark'
 WHEN SELLER_TYPE LIKE '%De%' THEN 'Dealer'
 WHEN SELLER_TYPE LIKE '%DL%' THEN 'Dealer'
 WHEN SELLER_TYPE LIKE '%In%' THEN 'Individual'
 WHEN SELLER_TYPE LIKE '%IN%' THEN 'Individual'
 WHEN SELLER_TYPE LIKE '%Trustmark_D' THEN 'Trustmark-Dealer'
 ELSE CAST(SELLER_TYPE AS VARCHAR)
END;

UPDATE CAR 
SET FUEL_TYPE = 
CASE 
 WHEN FUEL_TYPE LIKE '%D%' THEN 'Diesel'
 WHEN FUEL_TYPE LIKE '%d%' THEN 'Diesel'
 WHEN FUEL_TYPE LIKE '%P%' THEN 'Petrol'
 WHEN FUEL_TYPE LIKE '%p%' THEN 'Petrol'
 ELSE CAST(FUEL_TYPE AS VARCHAR)
END;

UPDATE CAR 
SET TRANSMISSION_TYPE = 
CASE 
 WHEN TRANSMISSION_TYPE LIKE '%Man%' THEN 'Manual'
 WHEN TRANSMISSION_TYPE LIKE '%man%' THEN 'Manual'
 WHEN TRANSMISSION_TYPE LIKE '%Auto%' THEN 'Automatic'
 WHEN TRANSMISSION_TYPE LIKE '%auto%' THEN 'Automatic'
 WHEN TRANSMISSION_TYPE LIKE '%amt%' THEN 'Automatic'
 WHEN TRANSMISSION_TYPE ='mn' THEN 'Manual'
 WHEN TRANSMISSION_TYPE = 'Ma' THEN 'Manual'
 ELSE CAST(TRANSMISSION_TYPE AS VARCHAR)
END; 


UPDATE CAR
SET MILEAGE = ABS(MILEAGE);    

UPDATE CAR 
SET ENGINE = NULL                                                 -- CHANGING WRONG DATA AS NULL VALUE SO THAT MISSING VALUE
WHERE ENGINE IN ('nan', 'NA', 'UNKNOWN', '0');

UPDATE CAR C1
SET ENGINE = C2.ENGINE
FROM CAR C2
WHERE C1.MODEL = C2.MODEL
AND C1.MAX_POWER = C2.MAX_POWER                                   -- USING SELF-JOIN TO FIND MISSING VALUE. 
AND C1.ENGINE IS NULL
AND C2.ENGINE IS NOT NULL;

ALTER TABLE CAR
ALTER COLUMN ENGINE TYPE NUMERIC                                  -- CHANGING DATA TYPE TO NUMERIC.
USING ENGINE::NUMERIC;

UPDATE CAR 
SET MAX_POWER = NULL                                               -- CHANGING WRONG DATA AS NULL VALUE SO THAT MISSING VALUE 
WHERE MAX_POWER IN ('nan', 'NA', 'Unknown');

UPDATE CAR C1
SET MAX_POWER = C2.MAX_POWER
FROM CAR C2
WHERE C1.MODEL = C2.MODEL                                          -- USING SELF-JOIN TO FIND MISSING VALUE.
AND C1.ENGINE = C2.ENGINE
AND C1.MAX_POWER IS NULL
AND C2.MAX_POWER IS NOT NULL;

ALTER TABLE CAR 
ALTER COLUMN MAX_POWER TYPE FLOAT                                  -- CHANGING DATA TYPE TO FLOAT.
USING MAX_POWER::FLOAT;

UPDATE CAR 
SET SELLING_PRICE = '0'
WHERE SELLING_PRICE IN ('nan', 'n?a', 'unknown', 'NAN', 'n/A', 'NA','\');

UPDATE CAR 
SET SELLING_PRICE = COALESCE(SELLING_PRICE, '0');

UPDATE CAR 
SET SELLING_PRICE = REGEXP_REPLACE(SELLING_PRICE,'[^0-9.]','', 'g');

ALTER TABLE CAR
ALTER COLUMN SELLING_PRICE TYPE NUMERIC                                     -- CHANGING DATA TYPE TO NUMERIC. 
USING SELLING_PRICE::NUMERIC;

UPDATE CAR 
SET ACTUAL_PRICE = '0'
WHERE ACTUAL_PRICE IN ('nan', 'n?a', 'unknown', 'NAN', 'n/A', 'NA','\','UNKNOWN');

UPDATE CAR 
SET ACTUAL_PRICE = REGEXP_REPLACE(ACTUAL_PRICE,'[^0-9.]','', 'g');

UPDATE CAR 
SET ACTUAL_PRICE = COALESCE(ACTUAL_PRICE, '0');

ALTER TABLE CAR
ALTER COLUMN ACTUAL_PRICE TYPE NUMERIC
USING ACTUAL_PRICE::NUMERIC;

UPDATE CAR 
SET FIXED_PROFIT = '0'
WHERE FIXED_PROFIT IN ( 'iiiii', 'n/A', 'N/A', 'nan', 'NAN', 'nil','UNKNOWN');


UPDATE CAR 
SET FIXED_PROFIT = COALESCE(FIXED_PROFIT, '0');

UPDATE CAR 
SET FIXED_PROFIT = REGEXP_REPLACE(FIXED_PROFIT,'[^0-9.]','', 'g');

ALTER TABLE CAR
ALTER COLUMN FIXED_PROFIT TYPE NUMERIC
USING FIXED_PROFIT::NUMERIC;


UPDATE CAR
SET SELLING_PRICE = 
CASE
 WHEN SELLING_PRICE = '0' THEN ACTUAL_PRICE + FIXED_PROFIT                -- USING CASE FUCTION COMBINED WITH ARITHMETIC FUNTION TO FIND MISSING VALUES. 
 ELSE CAST(SELLING_PRICE AS NUMERIC)
 END;


UPDATE CAR
SET ACTUAL_PRICE = 
CASE
WHEN ACTUAL_PRICE = '0' THEN SELLING_PRICE - FIXED_PROFIT                 -- USING CASE FUCTION COMBINED WITH ARITHMETIC FUNTION TO FIND MISSING VALUES.
ELSE CAST(ACTUAL_PRICE AS NUMERIC)
END;

UPDATE CAR
SET FIXED_PROFIT = 
CASE
WHEN FIXED_PROFIT = '0' THEN  SELLING_PRICE - ACTUAL_PRICE                -- USING CASE FUCTION COMBINED WITH ARITHMETIC FUNTION TO FIND MISSING VALUES.
ELSE CAST(FIXED_PROFIT AS NUMERIC)
END;

WITH DUP_CAR AS
(
    SELECT 
        ctid,
        ROW_NUMBER() OVER
        (
            PARTITION BY 
                BRAND,
                MODEL,
                VEHICLE_AGE,
                KM_DRIVEN,
                SELLER_TYPE,
                FUEL_TYPE,
                TRANSMISSION_TYPE,
                ENGINE,
                MILEAGE,
                SELLING_PRICE
            ORDER BY ctid
        ) AS RN
    FROM CAR
)

DELETE FROM CAR
WHERE ctid IN
(
    SELECT ctid
    FROM DUP_CAR
    WHERE RN > 1
);

END;
$$;


call sp_clean_cardekho_data()


