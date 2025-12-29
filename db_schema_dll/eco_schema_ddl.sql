-- DDL схемы eco
-- Сгенерировано: 2025-12-28 17:14:42.780702

CREATE SCHEMA IF NOT EXISTS eco;


-- Таблица: eco.avr_cities_meteo_day
-- Комментарий: Среднесуточные значения метеоинформации по городам
CREATE TABLE eco.avr_cities_meteo_day (cities_id integer(32,0), date date, value json);
COMMENT ON TABLE eco.avr_cities_meteo_day IS 'Среднесуточные значения метеоинформации по городам';
COMMENT ON COLUMN eco.avr_cities_meteo_day.cities_id IS 'Идентификатор города';
COMMENT ON COLUMN eco.avr_cities_meteo_day.date IS 'Дата суток информации';
COMMENT ON COLUMN eco.avr_cities_meteo_day.value IS 'Среднесуточные значения';
CREATE UNIQUE INDEX avr_cities_meteo_day_cities_id_idx ON eco.avr_cities_meteo_day USING btree (cities_id, date);
CREATE INDEX avr_cities_meteo_day_date_idx ON eco.avr_cities_meteo_day USING btree (date);

-- Таблица: eco.his_cities_ability_index
-- Комментарий: Историческая таблица для свойства [ability_index] сущности [cities]
CREATE TABLE eco.his_cities_ability_index (cities_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_cities_ability_index IS 'Историческая таблица для свойства [ability_index] сущности [cities]';
COMMENT ON COLUMN eco.his_cities_ability_index.cities_id IS 'Ссылка на объект сущности [cities]';
COMMENT ON COLUMN eco.his_cities_ability_index.dt IS 'Время значения свойства [ability_index] сущности [cities]';
COMMENT ON COLUMN eco.his_cities_ability_index.value IS 'Значение свойства [ability_index] сущности [cities]';
ALTER TABLE eco.his_cities_ability_index ADD CONSTRAINT pk_eco_his_cities_ability_index PRIMARY KEY (cities_id, dt);

-- Таблица: eco.his_cities_affordability_index
-- Комментарий: Историческая таблица для свойства [affordability_index] сущности [cities]
CREATE TABLE eco.his_cities_affordability_index (cities_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_cities_affordability_index IS 'Историческая таблица для свойства [affordability_index] сущности [cities]';
COMMENT ON COLUMN eco.his_cities_affordability_index.cities_id IS 'Ссылка на объект сущности [cities]';
COMMENT ON COLUMN eco.his_cities_affordability_index.dt IS 'Время значения свойства [affordability_index] сущности [cities]';
COMMENT ON COLUMN eco.his_cities_affordability_index.value IS 'Значение свойства [affordability_index] сущности [cities]';
ALTER TABLE eco.his_cities_affordability_index ADD CONSTRAINT pk_eco_his_cities_affordability_index PRIMARY KEY (cities_id, dt);

-- Таблица: eco.his_cities_area
-- Комментарий: Историческая таблица для свойства [area] сущности [cities]
CREATE TABLE eco.his_cities_area (cities_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_cities_area IS 'Историческая таблица для свойства [area] сущности [cities]';
COMMENT ON COLUMN eco.his_cities_area.cities_id IS 'Ссылка на объект сущности [cities]';
COMMENT ON COLUMN eco.his_cities_area.dt IS 'Время значения свойства [area] сущности [cities]';
COMMENT ON COLUMN eco.his_cities_area.value IS 'Значение свойства [area] сущности [cities]';
ALTER TABLE eco.his_cities_area ADD CONSTRAINT pk_eco_his_cities_area PRIMARY KEY (cities_id, dt);

-- Таблица: eco.his_cities_climate_index
-- Комментарий: Историческая таблица для свойства [climate_index] сущности [cities]
CREATE TABLE eco.his_cities_climate_index (cities_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_cities_climate_index IS 'Историческая таблица для свойства [climate_index] сущности [cities]';
COMMENT ON COLUMN eco.his_cities_climate_index.cities_id IS 'Ссылка на объект сущности [cities]';
COMMENT ON COLUMN eco.his_cities_climate_index.dt IS 'Время значения свойства [climate_index] сущности [cities]';
COMMENT ON COLUMN eco.his_cities_climate_index.value IS 'Значение свойства [climate_index] сущности [cities]';
ALTER TABLE eco.his_cities_climate_index ADD CONSTRAINT pk_eco_his_cities_climate_index PRIMARY KEY (cities_id, dt);

-- Таблица: eco.his_cities_cost_index
-- Комментарий: Историческая таблица для свойства [cost_index] сущности [cities]
CREATE TABLE eco.his_cities_cost_index (cities_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_cities_cost_index IS 'Историческая таблица для свойства [cost_index] сущности [cities]';
COMMENT ON COLUMN eco.his_cities_cost_index.cities_id IS 'Ссылка на объект сущности [cities]';
COMMENT ON COLUMN eco.his_cities_cost_index.dt IS 'Время значения свойства [cost_index] сущности [cities]';
COMMENT ON COLUMN eco.his_cities_cost_index.value IS 'Значение свойства [cost_index] сущности [cities]';
ALTER TABLE eco.his_cities_cost_index ADD CONSTRAINT pk_eco_his_cities_cost_index PRIMARY KEY (cities_id, dt);

-- Таблица: eco.his_cities_crime_index
-- Комментарий: Историческая таблица для свойства [crime_index] сущности [cities]
CREATE TABLE eco.his_cities_crime_index (cities_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_cities_crime_index IS 'Историческая таблица для свойства [crime_index] сущности [cities]';
COMMENT ON COLUMN eco.his_cities_crime_index.cities_id IS 'Ссылка на объект сущности [cities]';
COMMENT ON COLUMN eco.his_cities_crime_index.dt IS 'Время значения свойства [crime_index] сущности [cities]';
COMMENT ON COLUMN eco.his_cities_crime_index.value IS 'Значение свойства [crime_index] сущности [cities]';
ALTER TABLE eco.his_cities_crime_index ADD CONSTRAINT pk_eco_his_cities_crime_index PRIMARY KEY (cities_id, dt);

-- Таблица: eco.his_cities_gr_yield_cc
-- Комментарий: Историческая таблица для свойства [gr_yield_cc] сущности [cities]
CREATE TABLE eco.his_cities_gr_yield_cc (cities_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_cities_gr_yield_cc IS 'Историческая таблица для свойства [gr_yield_cc] сущности [cities]';
COMMENT ON COLUMN eco.his_cities_gr_yield_cc.cities_id IS 'Ссылка на объект сущности [cities]';
COMMENT ON COLUMN eco.his_cities_gr_yield_cc.dt IS 'Время значения свойства [gr_yield_cc] сущности [cities]';
COMMENT ON COLUMN eco.his_cities_gr_yield_cc.value IS 'Значение свойства [gr_yield_cc] сущности [cities]';
ALTER TABLE eco.his_cities_gr_yield_cc ADD CONSTRAINT pk_eco_his_cities_gr_yield_cc PRIMARY KEY (cities_id, dt);

-- Таблица: eco.his_cities_gr_yield_co
-- Комментарий: Историческая таблица для свойства [gr_yield_co] сущности [cities]
CREATE TABLE eco.his_cities_gr_yield_co (cities_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_cities_gr_yield_co IS 'Историческая таблица для свойства [gr_yield_co] сущности [cities]';
COMMENT ON COLUMN eco.his_cities_gr_yield_co.cities_id IS 'Ссылка на объект сущности [cities]';
COMMENT ON COLUMN eco.his_cities_gr_yield_co.dt IS 'Время значения свойства [gr_yield_co] сущности [cities]';
COMMENT ON COLUMN eco.his_cities_gr_yield_co.value IS 'Значение свойства [gr_yield_co] сущности [cities]';
ALTER TABLE eco.his_cities_gr_yield_co ADD CONSTRAINT pk_eco_his_cities_gr_yield_co PRIMARY KEY (cities_id, dt);

-- Таблица: eco.his_cities_health_index
-- Комментарий: Историческая таблица для свойства [health_index] сущности [cities]
CREATE TABLE eco.his_cities_health_index (cities_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_cities_health_index IS 'Историческая таблица для свойства [health_index] сущности [cities]';
COMMENT ON COLUMN eco.his_cities_health_index.cities_id IS 'Ссылка на объект сущности [cities]';
COMMENT ON COLUMN eco.his_cities_health_index.dt IS 'Время значения свойства [health_index] сущности [cities]';
COMMENT ON COLUMN eco.his_cities_health_index.value IS 'Значение свойства [health_index] сущности [cities]';
ALTER TABLE eco.his_cities_health_index ADD CONSTRAINT pk_eco_his_cities_health_index PRIMARY KEY (cities_id, dt);

-- Таблица: eco.his_cities_life_index
-- Комментарий: Историческая таблица для свойства [life_index] сущности [cities]
CREATE TABLE eco.his_cities_life_index (cities_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_cities_life_index IS 'Историческая таблица для свойства [life_index] сущности [cities]';
COMMENT ON COLUMN eco.his_cities_life_index.cities_id IS 'Ссылка на объект сущности [cities]';
COMMENT ON COLUMN eco.his_cities_life_index.dt IS 'Время значения свойства [life_index] сущности [cities]';
COMMENT ON COLUMN eco.his_cities_life_index.value IS 'Значение свойства [life_index] сущности [cities]';
ALTER TABLE eco.his_cities_life_index ADD CONSTRAINT pk_eco_his_cities_life_index PRIMARY KEY (cities_id, dt);

-- Таблица: eco.his_cities_meteo
-- Комментарий: Историческая таблица для свойства [meteo] сущности [cities]
CREATE TABLE eco.his_cities_meteo (cities_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value json);
COMMENT ON TABLE eco.his_cities_meteo IS 'Историческая таблица для свойства [meteo] сущности [cities]';
COMMENT ON COLUMN eco.his_cities_meteo.cities_id IS 'Ссылка на объект сущности [cities]';
COMMENT ON COLUMN eco.his_cities_meteo.dt IS 'Время значения свойства [meteo] сущности [cities]';
COMMENT ON COLUMN eco.his_cities_meteo.value IS 'Значение свойства [meteo] сущности [cities]';
ALTER TABLE eco.his_cities_meteo ADD CONSTRAINT pk_eco_his_cities_meteo PRIMARY KEY (cities_id, dt);

-- Таблица: eco.his_cities_mortgage_per_income
-- Комментарий: Историческая таблица для свойства [mortgage_per_income] сущности [cities]
CREATE TABLE eco.his_cities_mortgage_per_income (cities_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_cities_mortgage_per_income IS 'Историческая таблица для свойства [mortgage_per_income] сущности [cities]';
COMMENT ON COLUMN eco.his_cities_mortgage_per_income.cities_id IS 'Ссылка на объект сущности [cities]';
COMMENT ON COLUMN eco.his_cities_mortgage_per_income.dt IS 'Время значения свойства [mortgage_per_income] сущности [cities]';
COMMENT ON COLUMN eco.his_cities_mortgage_per_income.value IS 'Значение свойства [mortgage_per_income] сущности [cities]';
ALTER TABLE eco.his_cities_mortgage_per_income ADD CONSTRAINT pk_eco_his_cities_mortgage_per_income PRIMARY KEY (cities_id, dt);

-- Таблица: eco.his_cities_pollution_index
-- Комментарий: Историческая таблица для свойства [pollution_index] сущности [cities]
CREATE TABLE eco.his_cities_pollution_index (cities_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_cities_pollution_index IS 'Историческая таблица для свойства [pollution_index] сущности [cities]';
COMMENT ON COLUMN eco.his_cities_pollution_index.cities_id IS 'Ссылка на объект сущности [cities]';
COMMENT ON COLUMN eco.his_cities_pollution_index.dt IS 'Время значения свойства [pollution_index] сущности [cities]';
COMMENT ON COLUMN eco.his_cities_pollution_index.value IS 'Значение свойства [pollution_index] сущности [cities]';
ALTER TABLE eco.his_cities_pollution_index ADD CONSTRAINT pk_eco_his_cities_pollution_index PRIMARY KEY (cities_id, dt);

-- Таблица: eco.his_cities_polution_index
-- Комментарий: Историческая таблица для свойства [polution_index] сущности [cities]
CREATE TABLE eco.his_cities_polution_index (cities_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_cities_polution_index IS 'Историческая таблица для свойства [polution_index] сущности [cities]';
COMMENT ON COLUMN eco.his_cities_polution_index.cities_id IS 'Ссылка на объект сущности [cities]';
COMMENT ON COLUMN eco.his_cities_polution_index.dt IS 'Время значения свойства [polution_index] сущности [cities]';
COMMENT ON COLUMN eco.his_cities_polution_index.value IS 'Значение свойства [polution_index] сущности [cities]';
ALTER TABLE eco.his_cities_polution_index ADD CONSTRAINT pk_eco_his_cities_polution_index PRIMARY KEY (cities_id, dt);

-- Таблица: eco.his_cities_pops
-- Комментарий: Историческая таблица для свойства [pops] сущности [cities]
CREATE TABLE eco.his_cities_pops (cities_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value integer(32,0));
COMMENT ON TABLE eco.his_cities_pops IS 'Историческая таблица для свойства [pops] сущности [cities]';
COMMENT ON COLUMN eco.his_cities_pops.cities_id IS 'Ссылка на объект сущности [cities]';
COMMENT ON COLUMN eco.his_cities_pops.dt IS 'Время значения свойства [pops] сущности [cities]';
COMMENT ON COLUMN eco.his_cities_pops.value IS 'Значение свойства [pops] сущности [cities]';
ALTER TABLE eco.his_cities_pops ADD CONSTRAINT pk_eco_his_cities_pops PRIMARY KEY (cities_id, dt);

-- Таблица: eco.his_cities_pp_to_income_ratio
-- Комментарий: Историческая таблица для свойства [pp_to_income_ratio] сущности [cities]
CREATE TABLE eco.his_cities_pp_to_income_ratio (cities_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_cities_pp_to_income_ratio IS 'Историческая таблица для свойства [pp_to_income_ratio] сущности [cities]';
COMMENT ON COLUMN eco.his_cities_pp_to_income_ratio.cities_id IS 'Ссылка на объект сущности [cities]';
COMMENT ON COLUMN eco.his_cities_pp_to_income_ratio.dt IS 'Время значения свойства [pp_to_income_ratio] сущности [cities]';
COMMENT ON COLUMN eco.his_cities_pp_to_income_ratio.value IS 'Значение свойства [pp_to_income_ratio] сущности [cities]';
ALTER TABLE eco.his_cities_pp_to_income_ratio ADD CONSTRAINT pk_eco_his_cities_pp_to_income_ratio PRIMARY KEY (cities_id, dt);

-- Таблица: eco.his_cities_price_to_income
-- Комментарий: Историческая таблица для свойства [price_to_income] сущности [cities]
CREATE TABLE eco.his_cities_price_to_income (cities_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_cities_price_to_income IS 'Историческая таблица для свойства [price_to_income] сущности [cities]';
COMMENT ON COLUMN eco.his_cities_price_to_income.cities_id IS 'Ссылка на объект сущности [cities]';
COMMENT ON COLUMN eco.his_cities_price_to_income.dt IS 'Время значения свойства [price_to_income] сущности [cities]';
COMMENT ON COLUMN eco.his_cities_price_to_income.value IS 'Значение свойства [price_to_income] сущности [cities]';
ALTER TABLE eco.his_cities_price_to_income ADD CONSTRAINT pk_eco_his_cities_price_to_income PRIMARY KEY (cities_id, dt);

-- Таблица: eco.his_cities_price_to_rent_cc
-- Комментарий: Историческая таблица для свойства [price_to_rent_cc] сущности [cities]
CREATE TABLE eco.his_cities_price_to_rent_cc (cities_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_cities_price_to_rent_cc IS 'Историческая таблица для свойства [price_to_rent_cc] сущности [cities]';
COMMENT ON COLUMN eco.his_cities_price_to_rent_cc.cities_id IS 'Ссылка на объект сущности [cities]';
COMMENT ON COLUMN eco.his_cities_price_to_rent_cc.dt IS 'Время значения свойства [price_to_rent_cc] сущности [cities]';
COMMENT ON COLUMN eco.his_cities_price_to_rent_cc.value IS 'Значение свойства [price_to_rent_cc] сущности [cities]';
ALTER TABLE eco.his_cities_price_to_rent_cc ADD CONSTRAINT pk_eco_his_cities_price_to_rent_cc PRIMARY KEY (cities_id, dt);

-- Таблица: eco.his_cities_price_to_rent_co
-- Комментарий: Историческая таблица для свойства [price_to_rent_co] сущности [cities]
CREATE TABLE eco.his_cities_price_to_rent_co (cities_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_cities_price_to_rent_co IS 'Историческая таблица для свойства [price_to_rent_co] сущности [cities]';
COMMENT ON COLUMN eco.his_cities_price_to_rent_co.cities_id IS 'Ссылка на объект сущности [cities]';
COMMENT ON COLUMN eco.his_cities_price_to_rent_co.dt IS 'Время значения свойства [price_to_rent_co] сущности [cities]';
COMMENT ON COLUMN eco.his_cities_price_to_rent_co.value IS 'Значение свойства [price_to_rent_co] сущности [cities]';
ALTER TABLE eco.his_cities_price_to_rent_co ADD CONSTRAINT pk_eco_his_cities_price_to_rent_co PRIMARY KEY (cities_id, dt);

-- Таблица: eco.his_cities_safety_index
-- Комментарий: Историческая таблица для свойства [safety_index] сущности [cities]
CREATE TABLE eco.his_cities_safety_index (cities_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_cities_safety_index IS 'Историческая таблица для свойства [safety_index] сущности [cities]';
COMMENT ON COLUMN eco.his_cities_safety_index.cities_id IS 'Ссылка на объект сущности [cities]';
COMMENT ON COLUMN eco.his_cities_safety_index.dt IS 'Время значения свойства [safety_index] сущности [cities]';
COMMENT ON COLUMN eco.his_cities_safety_index.value IS 'Значение свойства [safety_index] сущности [cities]';
ALTER TABLE eco.his_cities_safety_index ADD CONSTRAINT pk_eco_his_cities_safety_index PRIMARY KEY (cities_id, dt);

-- Таблица: eco.his_cities_trafic_time_index
-- Комментарий: Историческая таблица для свойства [trafic_time_index] сущности [cities]
CREATE TABLE eco.his_cities_trafic_time_index (cities_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_cities_trafic_time_index IS 'Историческая таблица для свойства [trafic_time_index] сущности [cities]';
COMMENT ON COLUMN eco.his_cities_trafic_time_index.cities_id IS 'Ссылка на объект сущности [cities]';
COMMENT ON COLUMN eco.his_cities_trafic_time_index.dt IS 'Время значения свойства [trafic_time_index] сущности [cities]';
COMMENT ON COLUMN eco.his_cities_trafic_time_index.value IS 'Значение свойства [trafic_time_index] сущности [cities]';
ALTER TABLE eco.his_cities_trafic_time_index ADD CONSTRAINT pk_eco_his_cities_trafic_time_index PRIMARY KEY (cities_id, dt);

-- Таблица: eco.his_countries_ability_index
-- Комментарий: Историческая таблица для свойства [ability_index] сущности [countries]
CREATE TABLE eco.his_countries_ability_index (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_ability_index IS 'Историческая таблица для свойства [ability_index] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_ability_index.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_ability_index.dt IS 'Время значения свойства [ability_index] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_ability_index.value IS 'Значение свойства [ability_index] сущности [countries]';
ALTER TABLE eco.his_countries_ability_index ADD CONSTRAINT pk_eco_his_countries_ability_index PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_affordability_index
-- Комментарий: Историческая таблица для свойства [affordability_index] сущности [countries]
CREATE TABLE eco.his_countries_affordability_index (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_affordability_index IS 'Историческая таблица для свойства [affordability_index] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_affordability_index.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_affordability_index.dt IS 'Время значения свойства [affordability_index] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_affordability_index.value IS 'Значение свойства [affordability_index] сущности [countries]';
ALTER TABLE eco.his_countries_affordability_index ADD CONSTRAINT pk_eco_his_countries_affordability_index PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_ag_con_fert_pt_zs
-- Комментарий: Историческая таблица для свойства [ag_con_fert_pt_zs] сущности [countries]
CREATE TABLE eco.his_countries_ag_con_fert_pt_zs (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_ag_con_fert_pt_zs IS 'Историческая таблица для свойства [ag_con_fert_pt_zs] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_ag_con_fert_pt_zs.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_ag_con_fert_pt_zs.dt IS 'Время значения свойства [ag_con_fert_pt_zs] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_ag_con_fert_pt_zs.value IS 'Значение свойства [ag_con_fert_pt_zs] сущности [countries]';
ALTER TABLE eco.his_countries_ag_con_fert_pt_zs ADD CONSTRAINT pk_eco_his_countries_ag_con_fert_pt_zs PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_ag_lnd_arbl_ha_pc
-- Комментарий: Историческая таблица для свойства [ag_lnd_arbl_ha_pc] сущности [countries]
CREATE TABLE eco.his_countries_ag_lnd_arbl_ha_pc (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_ag_lnd_arbl_ha_pc IS 'Историческая таблица для свойства [ag_lnd_arbl_ha_pc] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_ag_lnd_arbl_ha_pc.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_ag_lnd_arbl_ha_pc.dt IS 'Время значения свойства [ag_lnd_arbl_ha_pc] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_ag_lnd_arbl_ha_pc.value IS 'Значение свойства [ag_lnd_arbl_ha_pc] сущности [countries]';
ALTER TABLE eco.his_countries_ag_lnd_arbl_ha_pc ADD CONSTRAINT pk_eco_his_countries_ag_lnd_arbl_ha_pc PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_ag_lnd_crel_ha
-- Комментарий: Историческая таблица для свойства [ag_lnd_crel_ha] сущности [countries]
CREATE TABLE eco.his_countries_ag_lnd_crel_ha (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_ag_lnd_crel_ha IS 'Историческая таблица для свойства [ag_lnd_crel_ha] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_ag_lnd_crel_ha.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_ag_lnd_crel_ha.dt IS 'Время значения свойства [ag_lnd_crel_ha] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_ag_lnd_crel_ha.value IS 'Значение свойства [ag_lnd_crel_ha] сущности [countries]';
ALTER TABLE eco.his_countries_ag_lnd_crel_ha ADD CONSTRAINT pk_eco_his_countries_ag_lnd_crel_ha PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_ag_lnd_crop_zs
-- Комментарий: Историческая таблица для свойства [ag_lnd_crop_zs] сущности [countries]
CREATE TABLE eco.his_countries_ag_lnd_crop_zs (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_ag_lnd_crop_zs IS 'Историческая таблица для свойства [ag_lnd_crop_zs] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_ag_lnd_crop_zs.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_ag_lnd_crop_zs.dt IS 'Время значения свойства [ag_lnd_crop_zs] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_ag_lnd_crop_zs.value IS 'Значение свойства [ag_lnd_crop_zs] сущности [countries]';
ALTER TABLE eco.his_countries_ag_lnd_crop_zs ADD CONSTRAINT pk_eco_his_countries_ag_lnd_crop_zs PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_ag_lnd_irig_ag_zs
-- Комментарий: Историческая таблица для свойства [ag_lnd_irig_ag_zs] сущности [countries]
CREATE TABLE eco.his_countries_ag_lnd_irig_ag_zs (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_ag_lnd_irig_ag_zs IS 'Историческая таблица для свойства [ag_lnd_irig_ag_zs] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_ag_lnd_irig_ag_zs.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_ag_lnd_irig_ag_zs.dt IS 'Время значения свойства [ag_lnd_irig_ag_zs] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_ag_lnd_irig_ag_zs.value IS 'Значение свойства [ag_lnd_irig_ag_zs] сущности [countries]';
ALTER TABLE eco.his_countries_ag_lnd_irig_ag_zs ADD CONSTRAINT pk_eco_his_countries_ag_lnd_irig_ag_zs PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_ag_lnd_totl_ru_k2
-- Комментарий: Историческая таблица для свойства [ag_lnd_totl_ru_k2] сущности [countries]
CREATE TABLE eco.his_countries_ag_lnd_totl_ru_k2 (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_ag_lnd_totl_ru_k2 IS 'Историческая таблица для свойства [ag_lnd_totl_ru_k2] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_ag_lnd_totl_ru_k2.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_ag_lnd_totl_ru_k2.dt IS 'Время значения свойства [ag_lnd_totl_ru_k2] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_ag_lnd_totl_ru_k2.value IS 'Значение свойства [ag_lnd_totl_ru_k2] сущности [countries]';
ALTER TABLE eco.his_countries_ag_lnd_totl_ru_k2 ADD CONSTRAINT pk_eco_his_countries_ag_lnd_totl_ru_k2 PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_ag_lnd_trac_zs
-- Комментарий: Историческая таблица для свойства [ag_lnd_trac_zs] сущности [countries]
CREATE TABLE eco.his_countries_ag_lnd_trac_zs (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_ag_lnd_trac_zs IS 'Историческая таблица для свойства [ag_lnd_trac_zs] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_ag_lnd_trac_zs.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_ag_lnd_trac_zs.dt IS 'Время значения свойства [ag_lnd_trac_zs] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_ag_lnd_trac_zs.value IS 'Значение свойства [ag_lnd_trac_zs] сущности [countries]';
ALTER TABLE eco.his_countries_ag_lnd_trac_zs ADD CONSTRAINT pk_eco_his_countries_ag_lnd_trac_zs PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_agr_arable_land
-- Комментарий: Историческая таблица для свойства [agr_arable_land] сущности [countries]
CREATE TABLE eco.his_countries_agr_arable_land (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_agr_arable_land IS 'Историческая таблица для свойства [agr_arable_land] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_agr_arable_land.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_agr_arable_land.dt IS 'Время значения свойства [agr_arable_land] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_agr_arable_land.value IS 'Значение свойства [agr_arable_land] сущности [countries]';
ALTER TABLE eco.his_countries_agr_arable_land ADD CONSTRAINT pk_eco_his_countries_agr_arable_land PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_agr_arable_land_percent
-- Комментарий: Историческая таблица для свойства [agr_arable_land_percent] сущности [countries]
CREATE TABLE eco.his_countries_agr_arable_land_percent (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_agr_arable_land_percent IS 'Историческая таблица для свойства [agr_arable_land_percent] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_agr_arable_land_percent.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_agr_arable_land_percent.dt IS 'Время значения свойства [agr_arable_land_percent] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_agr_arable_land_percent.value IS 'Значение свойства [agr_arable_land_percent] сущности [countries]';
ALTER TABLE eco.his_countries_agr_arable_land_percent ADD CONSTRAINT pk_eco_his_countries_agr_arable_land_percent PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_agr_avr_prec_depth
-- Комментарий: Историческая таблица для свойства [agr_avr_prec_depth] сущности [countries]
CREATE TABLE eco.his_countries_agr_avr_prec_depth (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value integer(32,0));
COMMENT ON TABLE eco.his_countries_agr_avr_prec_depth IS 'Историческая таблица для свойства [agr_avr_prec_depth] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_agr_avr_prec_depth.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_agr_avr_prec_depth.dt IS 'Время значения свойства [agr_avr_prec_depth] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_agr_avr_prec_depth.value IS 'Значение свойства [agr_avr_prec_depth] сущности [countries]';
ALTER TABLE eco.his_countries_agr_avr_prec_depth ADD CONSTRAINT pk_eco_his_countries_agr_avr_prec_depth PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_agr_cereal_production
-- Комментарий: Историческая таблица для свойства [agr_cereal_production] сущности [countries]
CREATE TABLE eco.his_countries_agr_cereal_production (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value integer(32,0));
COMMENT ON TABLE eco.his_countries_agr_cereal_production IS 'Историческая таблица для свойства [agr_cereal_production] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_agr_cereal_production.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_agr_cereal_production.dt IS 'Время значения свойства [agr_cereal_production] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_agr_cereal_production.value IS 'Значение свойства [agr_cereal_production] сущности [countries]';
ALTER TABLE eco.his_countries_agr_cereal_production ADD CONSTRAINT pk_eco_his_countries_agr_cereal_production PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_agr_cereal_yield
-- Комментарий: Историческая таблица для свойства [agr_cereal_yield] сущности [countries]
CREATE TABLE eco.his_countries_agr_cereal_yield (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value integer(32,0));
COMMENT ON TABLE eco.his_countries_agr_cereal_yield IS 'Историческая таблица для свойства [agr_cereal_yield] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_agr_cereal_yield.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_agr_cereal_yield.dt IS 'Время значения свойства [agr_cereal_yield] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_agr_cereal_yield.value IS 'Значение свойства [agr_cereal_yield] сущности [countries]';
ALTER TABLE eco.his_countries_agr_cereal_yield ADD CONSTRAINT pk_eco_his_countries_agr_cereal_yield PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_agr_employment_percent
-- Комментарий: Историческая таблица для свойства [agr_employment_percent] сущности [countries]
CREATE TABLE eco.his_countries_agr_employment_percent (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_agr_employment_percent IS 'Историческая таблица для свойства [agr_employment_percent] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_agr_employment_percent.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_agr_employment_percent.dt IS 'Время значения свойства [agr_employment_percent] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_agr_employment_percent.value IS 'Значение свойства [agr_employment_percent] сущности [countries]';
ALTER TABLE eco.his_countries_agr_employment_percent ADD CONSTRAINT pk_eco_his_countries_agr_employment_percent PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_agr_empoyment_percent
-- Комментарий: Историческая таблица для свойства [agr_empoyment_percent] сущности [countries]
CREATE TABLE eco.his_countries_agr_empoyment_percent (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_agr_empoyment_percent IS 'Историческая таблица для свойства [agr_empoyment_percent] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_agr_empoyment_percent.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_agr_empoyment_percent.dt IS 'Время значения свойства [agr_empoyment_percent] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_agr_empoyment_percent.value IS 'Значение свойства [agr_empoyment_percent] сущности [countries]';
ALTER TABLE eco.his_countries_agr_empoyment_percent ADD CONSTRAINT pk_eco_his_countries_agr_empoyment_percent PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_agr_machinery
-- Комментарий: Историческая таблица для свойства [agr_machinery] сущности [countries]
CREATE TABLE eco.his_countries_agr_machinery (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value integer(32,0));
COMMENT ON TABLE eco.his_countries_agr_machinery IS 'Историческая таблица для свойства [agr_machinery] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_agr_machinery.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_agr_machinery.dt IS 'Время значения свойства [agr_machinery] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_agr_machinery.value IS 'Значение свойства [agr_machinery] сущности [countries]';
ALTER TABLE eco.his_countries_agr_machinery ADD CONSTRAINT pk_eco_his_countries_agr_machinery PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_agr_pop_percent
-- Комментарий: Историческая таблица для свойства [agr_pop_percent] сущности [countries]
CREATE TABLE eco.his_countries_agr_pop_percent (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_agr_pop_percent IS 'Историческая таблица для свойства [agr_pop_percent] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_agr_pop_percent.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_agr_pop_percent.dt IS 'Время значения свойства [agr_pop_percent] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_agr_pop_percent.value IS 'Значение свойства [agr_pop_percent] сущности [countries]';
ALTER TABLE eco.his_countries_agr_pop_percent ADD CONSTRAINT pk_eco_his_countries_agr_pop_percent PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_agr_population
-- Комментарий: Историческая таблица для свойства [agr_population] сущности [countries]
CREATE TABLE eco.his_countries_agr_population (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value integer(32,0));
COMMENT ON TABLE eco.his_countries_agr_population IS 'Историческая таблица для свойства [agr_population] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_agr_population.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_agr_population.dt IS 'Время значения свойства [agr_population] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_agr_population.value IS 'Значение свойства [agr_population] сущности [countries]';
ALTER TABLE eco.his_countries_agr_population ADD CONSTRAINT pk_eco_his_countries_agr_population PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_agr_square
-- Комментарий: Историческая таблица для свойства [agr_square] сущности [countries]
CREATE TABLE eco.his_countries_agr_square (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_agr_square IS 'Историческая таблица для свойства [agr_square] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_agr_square.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_agr_square.dt IS 'Время значения свойства [agr_square] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_agr_square.value IS 'Значение свойства [agr_square] сущности [countries]';
ALTER TABLE eco.his_countries_agr_square ADD CONSTRAINT pk_eco_his_countries_agr_square PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_agr_square_percent
-- Комментарий: Историческая таблица для свойства [agr_square_percent] сущности [countries]
CREATE TABLE eco.his_countries_agr_square_percent (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_agr_square_percent IS 'Историческая таблица для свойства [agr_square_percent] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_agr_square_percent.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_agr_square_percent.dt IS 'Время значения свойства [agr_square_percent] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_agr_square_percent.value IS 'Значение свойства [agr_square_percent] сущности [countries]';
ALTER TABLE eco.his_countries_agr_square_percent ADD CONSTRAINT pk_eco_his_countries_agr_square_percent PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_air_pass_carry
-- Комментарий: Историческая таблица для свойства [air_pass_carry] сущности [countries]
CREATE TABLE eco.his_countries_air_pass_carry (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value integer(32,0));
COMMENT ON TABLE eco.his_countries_air_pass_carry IS 'Историческая таблица для свойства [air_pass_carry] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_air_pass_carry.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_air_pass_carry.dt IS 'Время значения свойства [air_pass_carry] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_air_pass_carry.value IS 'Значение свойства [air_pass_carry] сущности [countries]';
ALTER TABLE eco.his_countries_air_pass_carry ADD CONSTRAINT pk_eco_his_countries_air_pass_carry PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_arg_fertilizer
-- Комментарий: Историческая таблица для свойства [arg_fertilizer] сущности [countries]
CREATE TABLE eco.his_countries_arg_fertilizer (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value integer(32,0));
COMMENT ON TABLE eco.his_countries_arg_fertilizer IS 'Историческая таблица для свойства [arg_fertilizer] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_arg_fertilizer.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_arg_fertilizer.dt IS 'Время значения свойства [arg_fertilizer] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_arg_fertilizer.value IS 'Значение свойства [arg_fertilizer] сущности [countries]';
ALTER TABLE eco.his_countries_arg_fertilizer ADD CONSTRAINT pk_eco_his_countries_arg_fertilizer PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_av_age
-- Комментарий: Историческая таблица для свойства [av_age] сущности [countries]
CREATE TABLE eco.his_countries_av_age (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_av_age IS 'Историческая таблица для свойства [av_age] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_av_age.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_av_age.dt IS 'Время значения свойства [av_age] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_av_age.value IS 'Значение свойства [av_age] сущности [countries]';
ALTER TABLE eco.his_countries_av_age ADD CONSTRAINT pk_eco_his_countries_av_age PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_av_age_man
-- Комментарий: Историческая таблица для свойства [av_age_man] сущности [countries]
CREATE TABLE eco.his_countries_av_age_man (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_av_age_man IS 'Историческая таблица для свойства [av_age_man] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_av_age_man.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_av_age_man.dt IS 'Время значения свойства [av_age_man] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_av_age_man.value IS 'Значение свойства [av_age_man] сущности [countries]';
ALTER TABLE eco.his_countries_av_age_man ADD CONSTRAINT pk_eco_his_countries_av_age_man PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_av_age_women
-- Комментарий: Историческая таблица для свойства [av_age_women] сущности [countries]
CREATE TABLE eco.his_countries_av_age_women (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_av_age_women IS 'Историческая таблица для свойства [av_age_women] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_av_age_women.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_av_age_women.dt IS 'Время значения свойства [av_age_women] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_av_age_women.value IS 'Значение свойства [av_age_women] сущности [countries]';
ALTER TABLE eco.his_countries_av_age_women ADD CONSTRAINT pk_eco_his_countries_av_age_women PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_av_day_of_stay
-- Комментарий: Историческая таблица для свойства [av_day_of_stay] сущности [countries]
CREATE TABLE eco.his_countries_av_day_of_stay (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_av_day_of_stay IS 'Историческая таблица для свойства [av_day_of_stay] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_av_day_of_stay.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_av_day_of_stay.dt IS 'Время значения свойства [av_day_of_stay] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_av_day_of_stay.value IS 'Значение свойства [av_day_of_stay] сущности [countries]';
ALTER TABLE eco.his_countries_av_day_of_stay ADD CONSTRAINT pk_eco_his_countries_av_day_of_stay PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_av_salary_net
-- Комментарий: Историческая таблица для свойства [av_salary_net] сущности [countries]
CREATE TABLE eco.his_countries_av_salary_net (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_av_salary_net IS 'Историческая таблица для свойства [av_salary_net] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_av_salary_net.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_av_salary_net.dt IS 'Время значения свойства [av_salary_net] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_av_salary_net.value IS 'Значение свойства [av_salary_net] сущности [countries]';
ALTER TABLE eco.his_countries_av_salary_net ADD CONSTRAINT pk_eco_his_countries_av_salary_net PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_bm_dollar_price
-- Комментарий: Историческая таблица для свойства [bm_dollar_price] сущности [countries]
CREATE TABLE eco.his_countries_bm_dollar_price (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_bm_dollar_price IS 'Историческая таблица для свойства [bm_dollar_price] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_bm_dollar_price.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_bm_dollar_price.dt IS 'Время значения свойства [bm_dollar_price] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_bm_dollar_price.value IS 'Значение свойства [bm_dollar_price] сущности [countries]';
ALTER TABLE eco.his_countries_bm_dollar_price ADD CONSTRAINT pk_eco_his_countries_bm_dollar_price PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_bm_gsr_mrch_cd
-- Комментарий: Историческая таблица для свойства [bm_gsr_mrch_cd] сущности [countries]
CREATE TABLE eco.his_countries_bm_gsr_mrch_cd (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_bm_gsr_mrch_cd IS 'Историческая таблица для свойства [bm_gsr_mrch_cd] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_bm_gsr_mrch_cd.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_bm_gsr_mrch_cd.dt IS 'Время значения свойства [bm_gsr_mrch_cd] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_bm_gsr_mrch_cd.value IS 'Значение свойства [bm_gsr_mrch_cd] сущности [countries]';
ALTER TABLE eco.his_countries_bm_gsr_mrch_cd ADD CONSTRAINT pk_eco_his_countries_bm_gsr_mrch_cd PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_bm_index_dollar
-- Комментарий: Историческая таблица для свойства [bm_index_dollar] сущности [countries]
CREATE TABLE eco.his_countries_bm_index_dollar (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_bm_index_dollar IS 'Историческая таблица для свойства [bm_index_dollar] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_bm_index_dollar.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_bm_index_dollar.dt IS 'Время значения свойства [bm_index_dollar] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_bm_index_dollar.value IS 'Значение свойства [bm_index_dollar] сущности [countries]';
ALTER TABLE eco.his_countries_bm_index_dollar ADD CONSTRAINT pk_eco_his_countries_bm_index_dollar PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_bm_klt_dinv_cd_wd
-- Комментарий: Историческая таблица для свойства [bm_klt_dinv_cd_wd] сущности [countries]
CREATE TABLE eco.his_countries_bm_klt_dinv_cd_wd (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_bm_klt_dinv_cd_wd IS 'Историческая таблица для свойства [bm_klt_dinv_cd_wd] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_bm_klt_dinv_cd_wd.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_bm_klt_dinv_cd_wd.dt IS 'Время значения свойства [bm_klt_dinv_cd_wd] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_bm_klt_dinv_cd_wd.value IS 'Значение свойства [bm_klt_dinv_cd_wd] сущности [countries]';
ALTER TABLE eco.his_countries_bm_klt_dinv_cd_wd ADD CONSTRAINT pk_eco_his_countries_bm_klt_dinv_cd_wd PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_bm_local_price
-- Комментарий: Историческая таблица для свойства [bm_local_price] сущности [countries]
CREATE TABLE eco.his_countries_bm_local_price (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_bm_local_price IS 'Историческая таблица для свойства [bm_local_price] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_bm_local_price.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_bm_local_price.dt IS 'Время значения свойства [bm_local_price] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_bm_local_price.value IS 'Значение свойства [bm_local_price] сущности [countries]';
ALTER TABLE eco.his_countries_bm_local_price ADD CONSTRAINT pk_eco_his_countries_bm_local_price PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_bn_klt_dinv_cd
-- Комментарий: Историческая таблица для свойства [bn_klt_dinv_cd] сущности [countries]
CREATE TABLE eco.his_countries_bn_klt_dinv_cd (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_bn_klt_dinv_cd IS 'Историческая таблица для свойства [bn_klt_dinv_cd] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_bn_klt_dinv_cd.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_bn_klt_dinv_cd.dt IS 'Время значения свойства [bn_klt_dinv_cd] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_bn_klt_dinv_cd.value IS 'Значение свойства [bn_klt_dinv_cd] сущности [countries]';
ALTER TABLE eco.his_countries_bn_klt_dinv_cd ADD CONSTRAINT pk_eco_his_countries_bn_klt_dinv_cd PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_bx_klt_dinv_cd_wd
-- Комментарий: Историческая таблица для свойства [bx_klt_dinv_cd_wd] сущности [countries]
CREATE TABLE eco.his_countries_bx_klt_dinv_cd_wd (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_bx_klt_dinv_cd_wd IS 'Историческая таблица для свойства [bx_klt_dinv_cd_wd] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_bx_klt_dinv_cd_wd.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_bx_klt_dinv_cd_wd.dt IS 'Время значения свойства [bx_klt_dinv_cd_wd] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_bx_klt_dinv_cd_wd.value IS 'Значение свойства [bx_klt_dinv_cd_wd] сущности [countries]';
ALTER TABLE eco.his_countries_bx_klt_dinv_cd_wd ADD CONSTRAINT pk_eco_his_countries_bx_klt_dinv_cd_wd PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_bx_klt_dinv_wd_gd_zs
-- Комментарий: Историческая таблица для свойства [bx_klt_dinv_wd_gd_zs] сущности [countries]
CREATE TABLE eco.his_countries_bx_klt_dinv_wd_gd_zs (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_bx_klt_dinv_wd_gd_zs IS 'Историческая таблица для свойства [bx_klt_dinv_wd_gd_zs] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_bx_klt_dinv_wd_gd_zs.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_bx_klt_dinv_wd_gd_zs.dt IS 'Время значения свойства [bx_klt_dinv_wd_gd_zs] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_bx_klt_dinv_wd_gd_zs.value IS 'Значение свойства [bx_klt_dinv_wd_gd_zs] сущности [countries]';
ALTER TABLE eco.his_countries_bx_klt_dinv_wd_gd_zs ADD CONSTRAINT pk_eco_his_countries_bx_klt_dinv_wd_gd_zs PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_cars1000
-- Комментарий: Историческая таблица для свойства [cars1000] сущности [countries]
CREATE TABLE eco.his_countries_cars1000 (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value integer(32,0));
COMMENT ON TABLE eco.his_countries_cars1000 IS 'Историческая таблица для свойства [cars1000] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_cars1000.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_cars1000.dt IS 'Время значения свойства [cars1000] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_cars1000.value IS 'Значение свойства [cars1000] сущности [countries]';
ALTER TABLE eco.his_countries_cars1000 ADD CONSTRAINT pk_eco_his_countries_cars1000 PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_cel_sets
-- Комментарий: Историческая таблица для свойства [cel_sets] сущности [countries]
CREATE TABLE eco.his_countries_cel_sets (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value integer(32,0));
COMMENT ON TABLE eco.his_countries_cel_sets IS 'Историческая таблица для свойства [cel_sets] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_cel_sets.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_cel_sets.dt IS 'Время значения свойства [cel_sets] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_cel_sets.value IS 'Значение свойства [cel_sets] сущности [countries]';
ALTER TABLE eco.his_countries_cel_sets ADD CONSTRAINT pk_eco_his_countries_cel_sets PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_cgd_percent
-- Комментарий: Историческая таблица для свойства [cgd_percent] сущности [countries]
CREATE TABLE eco.his_countries_cgd_percent (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value double precision);
COMMENT ON TABLE eco.his_countries_cgd_percent IS 'Историческая таблица для свойства [cgd_percent] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_cgd_percent.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_cgd_percent.dt IS 'Время значения свойства [cgd_percent] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_cgd_percent.value IS 'Значение свойства [cgd_percent] сущности [countries]';
ALTER TABLE eco.his_countries_cgd_percent ADD CONSTRAINT pk_eco_his_countries_cgd_percent PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_climate_index
-- Комментарий: Историческая таблица для свойства [climate_index] сущности [countries]
CREATE TABLE eco.his_countries_climate_index (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_climate_index IS 'Историческая таблица для свойства [climate_index] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_climate_index.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_climate_index.dt IS 'Время значения свойства [climate_index] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_climate_index.value IS 'Значение свойства [climate_index] сущности [countries]';
ALTER TABLE eco.his_countries_climate_index ADD CONSTRAINT pk_eco_his_countries_climate_index PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_consumption
-- Комментарий: Историческая таблица для свойства [consumption] сущности [countries]
CREATE TABLE eco.his_countries_consumption (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_consumption IS 'Историческая таблица для свойства [consumption] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_consumption.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_consumption.dt IS 'Время значения свойства [consumption] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_consumption.value IS 'Значение свойства [consumption] сущности [countries]';
ALTER TABLE eco.his_countries_consumption ADD CONSTRAINT pk_eco_his_countries_consumption PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_corporate_tax_rate
-- Комментарий: Историческая таблица для свойства [corporate_tax_rate] сущности [countries]
CREATE TABLE eco.his_countries_corporate_tax_rate (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_corporate_tax_rate IS 'Историческая таблица для свойства [corporate_tax_rate] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_corporate_tax_rate.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_corporate_tax_rate.dt IS 'Время значения свойства [corporate_tax_rate] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_corporate_tax_rate.value IS 'Значение свойства [corporate_tax_rate] сущности [countries]';
ALTER TABLE eco.his_countries_corporate_tax_rate ADD CONSTRAINT pk_eco_his_countries_corporate_tax_rate PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_corruption_index
-- Комментарий: Историческая таблица для свойства [corruption_index] сущности [countries]
CREATE TABLE eco.his_countries_corruption_index (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_corruption_index IS 'Историческая таблица для свойства [corruption_index] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_corruption_index.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_corruption_index.dt IS 'Время значения свойства [corruption_index] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_corruption_index.value IS 'Значение свойства [corruption_index] сущности [countries]';
ALTER TABLE eco.his_countries_corruption_index ADD CONSTRAINT pk_eco_his_countries_corruption_index PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_cost_hd
-- Комментарий: Историческая таблица для свойства [cost_hd] сущности [countries]
CREATE TABLE eco.his_countries_cost_hd (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_cost_hd IS 'Историческая таблица для свойства [cost_hd] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_cost_hd.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_cost_hd.dt IS 'Время значения свойства [cost_hd] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_cost_hd.value IS 'Значение свойства [cost_hd] сущности [countries]';
ALTER TABLE eco.his_countries_cost_hd ADD CONSTRAINT pk_eco_his_countries_cost_hd PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_cost_index
-- Комментарий: Историческая таблица для свойства [cost_index] сущности [countries]
CREATE TABLE eco.his_countries_cost_index (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_cost_index IS 'Историческая таблица для свойства [cost_index] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_cost_index.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_cost_index.dt IS 'Время значения свойства [cost_index] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_cost_index.value IS 'Значение свойства [cost_index] сущности [countries]';
ALTER TABLE eco.his_countries_cost_index ADD CONSTRAINT pk_eco_his_countries_cost_index PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_count_tourists
-- Комментарий: Историческая таблица для свойства [count_tourists] сущности [countries]
CREATE TABLE eco.his_countries_count_tourists (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value integer(32,0));
COMMENT ON TABLE eco.his_countries_count_tourists IS 'Историческая таблица для свойства [count_tourists] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_count_tourists.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_count_tourists.dt IS 'Время значения свойства [count_tourists] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_count_tourists.value IS 'Значение свойства [count_tourists] сущности [countries]';
ALTER TABLE eco.his_countries_count_tourists ADD CONSTRAINT pk_eco_his_countries_count_tourists PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_count_tourists_countries
CREATE TABLE eco.his_countries_count_tourists_countries (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value integer(32,0), country integer(32,0) NOT NULL);
ALTER TABLE eco.his_countries_count_tourists_countries ADD CONSTRAINT pk_eco_his_countries_count_tourists_countries PRIMARY KEY (countries_id, dt, country);

-- Таблица: eco.his_countries_cpi
-- Комментарий: Историческая таблица для свойства [cpi] сущности [countries]
CREATE TABLE eco.his_countries_cpi (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_cpi IS 'Историческая таблица для свойства [cpi] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_cpi.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_cpi.dt IS 'Время значения свойства [cpi] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_cpi.value IS 'Значение свойства [cpi] сущности [countries]';
ALTER TABLE eco.his_countries_cpi ADD CONSTRAINT pk_eco_his_countries_cpi PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_crime
-- Комментарий: Историческая таблица для свойства [crime] сущности [countries]
CREATE TABLE eco.his_countries_crime (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_crime IS 'Историческая таблица для свойства [crime] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_crime.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_crime.dt IS 'Время значения свойства [crime] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_crime.value IS 'Значение свойства [crime] сущности [countries]';
ALTER TABLE eco.his_countries_crime ADD CONSTRAINT pk_eco_his_countries_crime PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_death_rate
-- Комментарий: Историческая таблица для свойства [death_rate] сущности [countries]
CREATE TABLE eco.his_countries_death_rate (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_death_rate IS 'Историческая таблица для свойства [death_rate] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_death_rate.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_death_rate.dt IS 'Время значения свойства [death_rate] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_death_rate.value IS 'Значение свойства [death_rate] сущности [countries]';
ALTER TABLE eco.his_countries_death_rate ADD CONSTRAINT pk_eco_his_countries_death_rate PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_deposit_rate
-- Комментарий: Историческая таблица для свойства [deposit_rate] сущности [countries]
CREATE TABLE eco.his_countries_deposit_rate (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_deposit_rate IS 'Историческая таблица для свойства [deposit_rate] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_deposit_rate.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_deposit_rate.dt IS 'Время значения свойства [deposit_rate] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_deposit_rate.value IS 'Значение свойства [deposit_rate] сущности [countries]';
ALTER TABLE eco.his_countries_deposit_rate ADD CONSTRAINT pk_eco_his_countries_deposit_rate PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_eggs
-- Комментарий: Историческая таблица для свойства [eggs] сущности [countries]
CREATE TABLE eco.his_countries_eggs (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_eggs IS 'Историческая таблица для свойства [eggs] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_eggs.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_eggs.dt IS 'Время значения свойства [eggs] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_eggs.value IS 'Значение свойства [eggs] сущности [countries]';
ALTER TABLE eco.his_countries_eggs ADD CONSTRAINT pk_eco_his_countries_eggs PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_fert_coeff
-- Комментарий: Историческая таблица для свойства [fert_coeff] сущности [countries]
CREATE TABLE eco.his_countries_fert_coeff (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_fert_coeff IS 'Историческая таблица для свойства [fert_coeff] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_fert_coeff.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_fert_coeff.dt IS 'Время значения свойства [fert_coeff] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_fert_coeff.value IS 'Значение свойства [fert_coeff] сущности [countries]';
ALTER TABLE eco.his_countries_fert_coeff ADD CONSTRAINT pk_eco_his_countries_fert_coeff PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_fert_inf
-- Комментарий: Историческая таблица для свойства [fert_inf] сущности [countries]
CREATE TABLE eco.his_countries_fert_inf (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value integer(32,0));
COMMENT ON TABLE eco.his_countries_fert_inf IS 'Историческая таблица для свойства [fert_inf] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_fert_inf.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_fert_inf.dt IS 'Время значения свойства [fert_inf] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_fert_inf.value IS 'Значение свойства [fert_inf] сущности [countries]';
ALTER TABLE eco.his_countries_fert_inf ADD CONSTRAINT pk_eco_his_countries_fert_inf PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_forest_square
-- Комментарий: Историческая таблица для свойства [forest_square] сущности [countries]
CREATE TABLE eco.his_countries_forest_square (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_forest_square IS 'Историческая таблица для свойства [forest_square] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_forest_square.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_forest_square.dt IS 'Время значения свойства [forest_square] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_forest_square.value IS 'Значение свойства [forest_square] сущности [countries]';
ALTER TABLE eco.his_countries_forest_square ADD CONSTRAINT pk_eco_his_countries_forest_square PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_forest_square_percent
-- Комментарий: Историческая таблица для свойства [forest_square_percent] сущности [countries]
CREATE TABLE eco.his_countries_forest_square_percent (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_forest_square_percent IS 'Историческая таблица для свойства [forest_square_percent] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_forest_square_percent.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_forest_square_percent.dt IS 'Время значения свойства [forest_square_percent] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_forest_square_percent.value IS 'Значение свойства [forest_square_percent] сущности [countries]';
ALTER TABLE eco.his_countries_forest_square_percent ADD CONSTRAINT pk_eco_his_countries_forest_square_percent PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_gasoline_price
-- Комментарий: Историческая таблица для свойства [gasoline_price] сущности [countries]
CREATE TABLE eco.his_countries_gasoline_price (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_gasoline_price IS 'Историческая таблица для свойства [gasoline_price] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_gasoline_price.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_gasoline_price.dt IS 'Время значения свойства [gasoline_price] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_gasoline_price.value IS 'Значение свойства [gasoline_price] сущности [countries]';
ALTER TABLE eco.his_countries_gasoline_price ADD CONSTRAINT pk_eco_his_countries_gasoline_price PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_gdp_agriculture
-- Комментарий: Историческая таблица для свойства [gdp_agriculture] сущности [countries]
CREATE TABLE eco.his_countries_gdp_agriculture (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_gdp_agriculture IS 'Историческая таблица для свойства [gdp_agriculture] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_gdp_agriculture.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_gdp_agriculture.dt IS 'Время значения свойства [gdp_agriculture] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_gdp_agriculture.value IS 'Значение свойства [gdp_agriculture] сущности [countries]';
ALTER TABLE eco.his_countries_gdp_agriculture ADD CONSTRAINT pk_eco_his_countries_gdp_agriculture PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_gdp_building
-- Комментарий: Историческая таблица для свойства [gdp_building] сущности [countries]
CREATE TABLE eco.his_countries_gdp_building (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_gdp_building IS 'Историческая таблица для свойства [gdp_building] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_gdp_building.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_gdp_building.dt IS 'Время значения свойства [gdp_building] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_gdp_building.value IS 'Значение свойства [gdp_building] сущности [countries]';
ALTER TABLE eco.his_countries_gdp_building ADD CONSTRAINT pk_eco_his_countries_gdp_building PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_gdp_export
-- Комментарий: Историческая таблица для свойства [gdp_export] сущности [countries]
CREATE TABLE eco.his_countries_gdp_export (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_gdp_export IS 'Историческая таблица для свойства [gdp_export] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_gdp_export.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_gdp_export.dt IS 'Время значения свойства [gdp_export] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_gdp_export.value IS 'Значение свойства [gdp_export] сущности [countries]';
ALTER TABLE eco.his_countries_gdp_export ADD CONSTRAINT pk_eco_his_countries_gdp_export PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_gdp_finance
-- Комментарий: Историческая таблица для свойства [gdp_finance] сущности [countries]
CREATE TABLE eco.his_countries_gdp_finance (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_gdp_finance IS 'Историческая таблица для свойства [gdp_finance] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_gdp_finance.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_gdp_finance.dt IS 'Время значения свойства [gdp_finance] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_gdp_finance.value IS 'Значение свойства [gdp_finance] сущности [countries]';
ALTER TABLE eco.his_countries_gdp_finance ADD CONSTRAINT pk_eco_his_countries_gdp_finance PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_gdp_growth
-- Комментарий: Историческая таблица для свойства [gdp_growth] сущности [countries]
CREATE TABLE eco.his_countries_gdp_growth (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_gdp_growth IS 'Историческая таблица для свойства [gdp_growth] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_gdp_growth.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_gdp_growth.dt IS 'Время значения свойства [gdp_growth] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_gdp_growth.value IS 'Значение свойства [gdp_growth] сущности [countries]';
ALTER TABLE eco.his_countries_gdp_growth ADD CONSTRAINT pk_eco_his_countries_gdp_growth PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_gdp_growth_per_percent
-- Комментарий: Историческая таблица для свойства [gdp_growth_per_percent] сущности [countries]
CREATE TABLE eco.his_countries_gdp_growth_per_percent (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_gdp_growth_per_percent IS 'Историческая таблица для свойства [gdp_growth_per_percent] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_gdp_growth_per_percent.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_gdp_growth_per_percent.dt IS 'Время значения свойства [gdp_growth_per_percent] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_gdp_growth_per_percent.value IS 'Значение свойства [gdp_growth_per_percent] сущности [countries]';
ALTER TABLE eco.his_countries_gdp_growth_per_percent ADD CONSTRAINT pk_eco_his_countries_gdp_growth_per_percent PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_gdp_import
-- Комментарий: Историческая таблица для свойства [gdp_import] сущности [countries]
CREATE TABLE eco.his_countries_gdp_import (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_gdp_import IS 'Историческая таблица для свойства [gdp_import] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_gdp_import.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_gdp_import.dt IS 'Время значения свойства [gdp_import] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_gdp_import.value IS 'Значение свойства [gdp_import] сущности [countries]';
ALTER TABLE eco.his_countries_gdp_import ADD CONSTRAINT pk_eco_his_countries_gdp_import PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_gdp_market
-- Комментарий: Историческая таблица для свойства [gdp_market] сущности [countries]
CREATE TABLE eco.his_countries_gdp_market (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_gdp_market IS 'Историческая таблица для свойства [gdp_market] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_gdp_market.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_gdp_market.dt IS 'Время значения свойства [gdp_market] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_gdp_market.value IS 'Значение свойства [gdp_market] сущности [countries]';
ALTER TABLE eco.his_countries_gdp_market ADD CONSTRAINT pk_eco_his_countries_gdp_market PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_gdp_pop
-- Комментарий: Историческая таблица для свойства [gdp_pop] сущности [countries]
CREATE TABLE eco.his_countries_gdp_pop (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_gdp_pop IS 'Историческая таблица для свойства [gdp_pop] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_gdp_pop.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_gdp_pop.dt IS 'Время значения свойства [gdp_pop] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_gdp_pop.value IS 'Значение свойства [gdp_pop] сущности [countries]';
ALTER TABLE eco.his_countries_gdp_pop ADD CONSTRAINT pk_eco_his_countries_gdp_pop PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_gdp_pop_rate
-- Комментарий: Историческая таблица для свойства [gdp_pop_rate] сущности [countries]
CREATE TABLE eco.his_countries_gdp_pop_rate (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_gdp_pop_rate IS 'Историческая таблица для свойства [gdp_pop_rate] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_gdp_pop_rate.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_gdp_pop_rate.dt IS 'Время значения свойства [gdp_pop_rate] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_gdp_pop_rate.value IS 'Значение свойства [gdp_pop_rate] сущности [countries]';
ALTER TABLE eco.his_countries_gdp_pop_rate ADD CONSTRAINT pk_eco_his_countries_gdp_pop_rate PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_gdp_tnrr_percent
-- Комментарий: Историческая таблица для свойства [gdp_tnrr_percent] сущности [countries]
CREATE TABLE eco.his_countries_gdp_tnrr_percent (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_gdp_tnrr_percent IS 'Историческая таблица для свойства [gdp_tnrr_percent] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_gdp_tnrr_percent.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_gdp_tnrr_percent.dt IS 'Время значения свойства [gdp_tnrr_percent] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_gdp_tnrr_percent.value IS 'Значение свойства [gdp_tnrr_percent] сущности [countries]';
ALTER TABLE eco.his_countries_gdp_tnrr_percent ADD CONSTRAINT pk_eco_his_countries_gdp_tnrr_percent PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_gdpp
-- Комментарий: Историческая таблица для свойства [gdpp] сущности [countries]
CREATE TABLE eco.his_countries_gdpp (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_gdpp IS 'Историческая таблица для свойства [gdpp] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_gdpp.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_gdpp.dt IS 'Время значения свойства [gdpp] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_gdpp.value IS 'Значение свойства [gdpp] сущности [countries]';
ALTER TABLE eco.his_countries_gdpp ADD CONSTRAINT pk_eco_his_countries_gdpp PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_gnp_person
-- Комментарий: Историческая таблица для свойства [gnp_person] сущности [countries]
CREATE TABLE eco.his_countries_gnp_person (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value integer(32,0));
COMMENT ON TABLE eco.his_countries_gnp_person IS 'Историческая таблица для свойства [gnp_person] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_gnp_person.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_gnp_person.dt IS 'Время значения свойства [gnp_person] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_gnp_person.value IS 'Значение свойства [gnp_person] сущности [countries]';
ALTER TABLE eco.his_countries_gnp_person ADD CONSTRAINT pk_eco_his_countries_gnp_person PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_gr_yield_cc
-- Комментарий: Историческая таблица для свойства [gr_yield_cc] сущности [countries]
CREATE TABLE eco.his_countries_gr_yield_cc (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_gr_yield_cc IS 'Историческая таблица для свойства [gr_yield_cc] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_gr_yield_cc.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_gr_yield_cc.dt IS 'Время значения свойства [gr_yield_cc] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_gr_yield_cc.value IS 'Значение свойства [gr_yield_cc] сущности [countries]';
ALTER TABLE eco.his_countries_gr_yield_cc ADD CONSTRAINT pk_eco_his_countries_gr_yield_cc PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_gr_yield_co
-- Комментарий: Историческая таблица для свойства [gr_yield_co] сущности [countries]
CREATE TABLE eco.his_countries_gr_yield_co (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_gr_yield_co IS 'Историческая таблица для свойства [gr_yield_co] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_gr_yield_co.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_gr_yield_co.dt IS 'Время значения свойства [gr_yield_co] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_gr_yield_co.value IS 'Значение свойства [gr_yield_co] сущности [countries]';
ALTER TABLE eco.his_countries_gr_yield_co ADD CONSTRAINT pk_eco_his_countries_gr_yield_co PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_hdi
-- Комментарий: Историческая таблица для свойства [hdi] сущности [countries]
CREATE TABLE eco.his_countries_hdi (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_hdi IS 'Историческая таблица для свойства [hdi] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_hdi.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_hdi.dt IS 'Время значения свойства [hdi] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_hdi.value IS 'Значение свойства [hdi] сущности [countries]';
ALTER TABLE eco.his_countries_hdi ADD CONSTRAINT pk_eco_his_countries_hdi PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_health_index
-- Комментарий: Историческая таблица для свойства [health_index] сущности [countries]
CREATE TABLE eco.his_countries_health_index (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_health_index IS 'Историческая таблица для свойства [health_index] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_health_index.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_health_index.dt IS 'Время значения свойства [health_index] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_health_index.value IS 'Значение свойства [health_index] сущности [countries]';
ALTER TABLE eco.his_countries_health_index ADD CONSTRAINT pk_eco_his_countries_health_index PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_home_ownership_rate
-- Комментарий: Историческая таблица для свойства [home_ownership_rate] сущности [countries]
CREATE TABLE eco.his_countries_home_ownership_rate (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_home_ownership_rate IS 'Историческая таблица для свойства [home_ownership_rate] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_home_ownership_rate.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_home_ownership_rate.dt IS 'Время значения свойства [home_ownership_rate] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_home_ownership_rate.value IS 'Значение свойства [home_ownership_rate] сущности [countries]';
ALTER TABLE eco.his_countries_home_ownership_rate ADD CONSTRAINT pk_eco_his_countries_home_ownership_rate PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_ibrd
-- Комментарий: Историческая таблица для свойства [ibrd] сущности [countries]
CREATE TABLE eco.his_countries_ibrd (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_ibrd IS 'Историческая таблица для свойства [ibrd] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_ibrd.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_ibrd.dt IS 'Время значения свойства [ibrd] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_ibrd.value IS 'Значение свойства [ibrd] сущности [countries]';
ALTER TABLE eco.his_countries_ibrd ADD CONSTRAINT pk_eco_his_countries_ibrd PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_income_tax_rate
-- Комментарий: Историческая таблица для свойства [income_tax_rate] сущности [countries]
CREATE TABLE eco.his_countries_income_tax_rate (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_income_tax_rate IS 'Историческая таблица для свойства [income_tax_rate] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_income_tax_rate.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_income_tax_rate.dt IS 'Время значения свойства [income_tax_rate] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_income_tax_rate.value IS 'Значение свойства [income_tax_rate] сущности [countries]';
ALTER TABLE eco.his_countries_income_tax_rate ADD CONSTRAINT pk_eco_his_countries_income_tax_rate PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_inet_user_per
-- Комментарий: Историческая таблица для свойства [inet_user_per] сущности [countries]
CREATE TABLE eco.his_countries_inet_user_per (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value integer(32,0));
COMMENT ON TABLE eco.his_countries_inet_user_per IS 'Историческая таблица для свойства [inet_user_per] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_inet_user_per.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_inet_user_per.dt IS 'Время значения свойства [inet_user_per] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_inet_user_per.value IS 'Значение свойства [inet_user_per] сущности [countries]';
ALTER TABLE eco.his_countries_inet_user_per ADD CONSTRAINT pk_eco_his_countries_inet_user_per PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_inflation
-- Комментарий: Историческая таблица для свойства [inflation] сущности [countries]
CREATE TABLE eco.his_countries_inflation (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_inflation IS 'Историческая таблица для свойства [inflation] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_inflation.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_inflation.dt IS 'Время значения свойства [inflation] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_inflation.value IS 'Значение свойства [inflation] сущности [countries]';
ALTER TABLE eco.his_countries_inflation ADD CONSTRAINT pk_eco_his_countries_inflation PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_it_net_mln
-- Комментарий: Историческая таблица для свойства [it_net_mln] сущности [countries]
CREATE TABLE eco.his_countries_it_net_mln (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value integer(32,0));
COMMENT ON TABLE eco.his_countries_it_net_mln IS 'Историческая таблица для свойства [it_net_mln] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_it_net_mln.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_it_net_mln.dt IS 'Время значения свойства [it_net_mln] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_it_net_mln.value IS 'Значение свойства [it_net_mln] сущности [countries]';
ALTER TABLE eco.his_countries_it_net_mln ADD CONSTRAINT pk_eco_his_countries_it_net_mln PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_it_net_secr
-- Комментарий: Историческая таблица для свойства [it_net_secr] сущности [countries]
CREATE TABLE eco.his_countries_it_net_secr (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value integer(32,0));
COMMENT ON TABLE eco.his_countries_it_net_secr IS 'Историческая таблица для свойства [it_net_secr] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_it_net_secr.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_it_net_secr.dt IS 'Время значения свойства [it_net_secr] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_it_net_secr.value IS 'Значение свойства [it_net_secr] сущности [countries]';
ALTER TABLE eco.his_countries_it_net_secr ADD CONSTRAINT pk_eco_his_countries_it_net_secr PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_life_index
-- Комментарий: Историческая таблица для свойства [life_index] сущности [countries]
CREATE TABLE eco.his_countries_life_index (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_life_index IS 'Историческая таблица для свойства [life_index] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_life_index.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_life_index.dt IS 'Время значения свойства [life_index] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_life_index.value IS 'Значение свойства [life_index] сущности [countries]';
ALTER TABLE eco.his_countries_life_index ADD CONSTRAINT pk_eco_his_countries_life_index PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_loan_rate
-- Комментарий: Историческая таблица для свойства [loan_rate] сущности [countries]
CREATE TABLE eco.his_countries_loan_rate (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_loan_rate IS 'Историческая таблица для свойства [loan_rate] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_loan_rate.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_loan_rate.dt IS 'Время значения свойства [loan_rate] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_loan_rate.value IS 'Значение свойства [loan_rate] сущности [countries]';
ALTER TABLE eco.his_countries_loan_rate ADD CONSTRAINT pk_eco_his_countries_loan_rate PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_military_gdp_per
-- Комментарий: Историческая таблица для свойства [military_gdp_per] сущности [countries]
CREATE TABLE eco.his_countries_military_gdp_per (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_military_gdp_per IS 'Историческая таблица для свойства [military_gdp_per] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_military_gdp_per.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_military_gdp_per.dt IS 'Время значения свойства [military_gdp_per] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_military_gdp_per.value IS 'Значение свойства [military_gdp_per] сущности [countries]';
ALTER TABLE eco.his_countries_military_gdp_per ADD CONSTRAINT pk_eco_his_countries_military_gdp_per PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_military_total
-- Комментарий: Историческая таблица для свойства [military_total] сущности [countries]
CREATE TABLE eco.his_countries_military_total (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value integer(32,0));
COMMENT ON TABLE eco.his_countries_military_total IS 'Историческая таблица для свойства [military_total] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_military_total.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_military_total.dt IS 'Время значения свойства [military_total] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_military_total.value IS 'Значение свойства [military_total] сущности [countries]';
ALTER TABLE eco.his_countries_military_total ADD CONSTRAINT pk_eco_his_countries_military_total PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_mort_rate_inf
-- Комментарий: Историческая таблица для свойства [mort_rate_inf] сущности [countries]
CREATE TABLE eco.his_countries_mort_rate_inf (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value integer(32,0));
COMMENT ON TABLE eco.his_countries_mort_rate_inf IS 'Историческая таблица для свойства [mort_rate_inf] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_mort_rate_inf.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_mort_rate_inf.dt IS 'Время значения свойства [mort_rate_inf] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_mort_rate_inf.value IS 'Значение свойства [mort_rate_inf] сущности [countries]';
ALTER TABLE eco.his_countries_mort_rate_inf ADD CONSTRAINT pk_eco_his_countries_mort_rate_inf PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_mortage_per
-- Комментарий: Историческая таблица для свойства [mortage_per] сущности [countries]
CREATE TABLE eco.his_countries_mortage_per (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_mortage_per IS 'Историческая таблица для свойства [mortage_per] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_mortage_per.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_mortage_per.dt IS 'Время значения свойства [mortage_per] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_mortage_per.value IS 'Значение свойства [mortage_per] сущности [countries]';
ALTER TABLE eco.his_countries_mortage_per ADD CONSTRAINT pk_eco_his_countries_mortage_per PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_mortgage_per_income
-- Комментарий: Историческая таблица для свойства [mortgage_per_income] сущности [countries]
CREATE TABLE eco.his_countries_mortgage_per_income (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_mortgage_per_income IS 'Историческая таблица для свойства [mortgage_per_income] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_mortgage_per_income.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_mortgage_per_income.dt IS 'Время значения свойства [mortgage_per_income] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_mortgage_per_income.value IS 'Значение свойства [mortgage_per_income] сущности [countries]';
ALTER TABLE eco.his_countries_mortgage_per_income ADD CONSTRAINT pk_eco_his_countries_mortgage_per_income PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_png
-- Комментарий: Историческая таблица для свойства [png] сущности [countries]
CREATE TABLE eco.his_countries_png (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_png IS 'Историческая таблица для свойства [png] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_png.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_png.dt IS 'Время значения свойства [png] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_png.value IS 'Значение свойства [png] сущности [countries]';
ALTER TABLE eco.his_countries_png ADD CONSTRAINT pk_eco_his_countries_png PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_pollution_index
-- Комментарий: Историческая таблица для свойства [pollution_index] сущности [countries]
CREATE TABLE eco.his_countries_pollution_index (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_pollution_index IS 'Историческая таблица для свойства [pollution_index] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_pollution_index.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_pollution_index.dt IS 'Время значения свойства [pollution_index] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_pollution_index.value IS 'Значение свойства [pollution_index] сущности [countries]';
ALTER TABLE eco.his_countries_pollution_index ADD CONSTRAINT pk_eco_his_countries_pollution_index PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_pop_dnst
-- Комментарий: Историческая таблица для свойства [pop_dnst] сущности [countries]
CREATE TABLE eco.his_countries_pop_dnst (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value integer(32,0));
COMMENT ON TABLE eco.his_countries_pop_dnst IS 'Историческая таблица для свойства [pop_dnst] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_pop_dnst.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_pop_dnst.dt IS 'Время значения свойства [pop_dnst] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_pop_dnst.value IS 'Значение свойства [pop_dnst] сущности [countries]';
ALTER TABLE eco.his_countries_pop_dnst ADD CONSTRAINT pk_eco_his_countries_pop_dnst PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_pop_man_percent
-- Комментарий: Историческая таблица для свойства [pop_man_percent] сущности [countries]
CREATE TABLE eco.his_countries_pop_man_percent (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_pop_man_percent IS 'Историческая таблица для свойства [pop_man_percent] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_pop_man_percent.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_pop_man_percent.dt IS 'Время значения свойства [pop_man_percent] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_pop_man_percent.value IS 'Значение свойства [pop_man_percent] сущности [countries]';
ALTER TABLE eco.his_countries_pop_man_percent ADD CONSTRAINT pk_eco_his_countries_pop_man_percent PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_pop_women_percent
-- Комментарий: Историческая таблица для свойства [pop_women_percent] сущности [countries]
CREATE TABLE eco.his_countries_pop_women_percent (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_pop_women_percent IS 'Историческая таблица для свойства [pop_women_percent] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_pop_women_percent.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_pop_women_percent.dt IS 'Время значения свойства [pop_women_percent] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_pop_women_percent.value IS 'Значение свойства [pop_women_percent] сущности [countries]';
ALTER TABLE eco.his_countries_pop_women_percent ADD CONSTRAINT pk_eco_his_countries_pop_women_percent PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_pops
-- Комментарий: Историческая таблица для свойства [pops] сущности [countries]
CREATE TABLE eco.his_countries_pops (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value integer(32,0));
COMMENT ON TABLE eco.his_countries_pops IS 'Историческая таблица для свойства [pops] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_pops.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_pops.dt IS 'Время значения свойства [pops] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_pops.value IS 'Значение свойства [pops] сущности [countries]';
ALTER TABLE eco.his_countries_pops ADD CONSTRAINT pk_eco_his_countries_pops PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_population_change
-- Комментарий: Историческая таблица для свойства [population_change] сущности [countries]
CREATE TABLE eco.his_countries_population_change (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value integer(32,0));
COMMENT ON TABLE eco.his_countries_population_change IS 'Историческая таблица для свойства [population_change] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_population_change.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_population_change.dt IS 'Время значения свойства [population_change] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_population_change.value IS 'Значение свойства [population_change] сущности [countries]';
ALTER TABLE eco.his_countries_population_change ADD CONSTRAINT pk_eco_his_countries_population_change PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_pp_to_income_ratio
-- Комментарий: Историческая таблица для свойства [pp_to_income_ratio] сущности [countries]
CREATE TABLE eco.his_countries_pp_to_income_ratio (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_pp_to_income_ratio IS 'Историческая таблица для свойства [pp_to_income_ratio] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_pp_to_income_ratio.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_pp_to_income_ratio.dt IS 'Время значения свойства [pp_to_income_ratio] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_pp_to_income_ratio.value IS 'Значение свойства [pp_to_income_ratio] сущности [countries]';
ALTER TABLE eco.his_countries_pp_to_income_ratio ADD CONSTRAINT pk_eco_his_countries_pp_to_income_ratio PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_ppg
-- Комментарий: Историческая таблица для свойства [ppg] сущности [countries]
CREATE TABLE eco.his_countries_ppg (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_ppg IS 'Историческая таблица для свойства [ppg] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_ppg.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_ppg.dt IS 'Время значения свойства [ppg] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_ppg.value IS 'Значение свойства [ppg] сущности [countries]';
ALTER TABLE eco.his_countries_ppg ADD CONSTRAINT pk_eco_his_countries_ppg PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_price_sm_acc
-- Комментарий: Историческая таблица для свойства [price_sm_acc] сущности [countries]
CREATE TABLE eco.his_countries_price_sm_acc (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_price_sm_acc IS 'Историческая таблица для свойства [price_sm_acc] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_price_sm_acc.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_price_sm_acc.dt IS 'Время значения свойства [price_sm_acc] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_price_sm_acc.value IS 'Значение свойства [price_sm_acc] сущности [countries]';
ALTER TABLE eco.his_countries_price_sm_acc ADD CONSTRAINT pk_eco_his_countries_price_sm_acc PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_price_sm_aoc
-- Комментарий: Историческая таблица для свойства [price_sm_aoc] сущности [countries]
CREATE TABLE eco.his_countries_price_sm_aoc (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_price_sm_aoc IS 'Историческая таблица для свойства [price_sm_aoc] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_price_sm_aoc.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_price_sm_aoc.dt IS 'Время значения свойства [price_sm_aoc] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_price_sm_aoc.value IS 'Значение свойства [price_sm_aoc] сущности [countries]';
ALTER TABLE eco.his_countries_price_sm_aoc ADD CONSTRAINT pk_eco_his_countries_price_sm_aoc PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_price_to_income
-- Комментарий: Историческая таблица для свойства [price_to_income] сущности [countries]
CREATE TABLE eco.his_countries_price_to_income (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_price_to_income IS 'Историческая таблица для свойства [price_to_income] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_price_to_income.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_price_to_income.dt IS 'Время значения свойства [price_to_income] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_price_to_income.value IS 'Значение свойства [price_to_income] сущности [countries]';
ALTER TABLE eco.his_countries_price_to_income ADD CONSTRAINT pk_eco_his_countries_price_to_income PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_price_to_rent_cc
-- Комментарий: Историческая таблица для свойства [price_to_rent_cc] сущности [countries]
CREATE TABLE eco.his_countries_price_to_rent_cc (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_price_to_rent_cc IS 'Историческая таблица для свойства [price_to_rent_cc] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_price_to_rent_cc.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_price_to_rent_cc.dt IS 'Время значения свойства [price_to_rent_cc] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_price_to_rent_cc.value IS 'Значение свойства [price_to_rent_cc] сущности [countries]';
ALTER TABLE eco.his_countries_price_to_rent_cc ADD CONSTRAINT pk_eco_his_countries_price_to_rent_cc PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_price_to_rent_co
-- Комментарий: Историческая таблица для свойства [price_to_rent_co] сущности [countries]
CREATE TABLE eco.his_countries_price_to_rent_co (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_price_to_rent_co IS 'Историческая таблица для свойства [price_to_rent_co] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_price_to_rent_co.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_price_to_rent_co.dt IS 'Время значения свойства [price_to_rent_co] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_price_to_rent_co.value IS 'Значение свойства [price_to_rent_co] сущности [countries]';
ALTER TABLE eco.his_countries_price_to_rent_co ADD CONSTRAINT pk_eco_his_countries_price_to_rent_co PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_rezerv
-- Комментарий: Историческая таблица для свойства [rezerv] сущности [countries]
CREATE TABLE eco.his_countries_rezerv (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_rezerv IS 'Историческая таблица для свойства [rezerv] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_rezerv.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_rezerv.dt IS 'Время значения свойства [rezerv] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_rezerv.value IS 'Значение свойства [rezerv] сущности [countries]';
ALTER TABLE eco.his_countries_rezerv ADD CONSTRAINT pk_eco_his_countries_rezerv PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_safety_index
-- Комментарий: Историческая таблица для свойства [safety_index] сущности [countries]
CREATE TABLE eco.his_countries_safety_index (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_safety_index IS 'Историческая таблица для свойства [safety_index] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_safety_index.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_safety_index.dt IS 'Время значения свойства [safety_index] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_safety_index.value IS 'Значение свойства [safety_index] сущности [countries]';
ALTER TABLE eco.his_countries_safety_index ADD CONSTRAINT pk_eco_his_countries_safety_index PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_sale_house
-- Комментарий: Историческая таблица для свойства [sale_house] сущности [countries]
CREATE TABLE eco.his_countries_sale_house (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value integer(32,0));
COMMENT ON TABLE eco.his_countries_sale_house IS 'Историческая таблица для свойства [sale_house] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_sale_house.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_sale_house.dt IS 'Время значения свойства [sale_house] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_sale_house.value IS 'Значение свойства [sale_house] сущности [countries]';
ALTER TABLE eco.his_countries_sale_house ADD CONSTRAINT pk_eco_his_countries_sale_house PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_sale_house_month
-- Комментарий: Историческая таблица для свойства [sale_house_month] сущности [countries]
CREATE TABLE eco.his_countries_sale_house_month (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value integer(32,0));
COMMENT ON TABLE eco.his_countries_sale_house_month IS 'Историческая таблица для свойства [sale_house_month] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_sale_house_month.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_sale_house_month.dt IS 'Время значения свойства [sale_house_month] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_sale_house_month.value IS 'Значение свойства [sale_house_month] сущности [countries]';
ALTER TABLE eco.his_countries_sale_house_month ADD CONSTRAINT pk_eco_his_countries_sale_house_month PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_sales_tax_rate
-- Комментарий: Историческая таблица для свойства [sales_tax_rate] сущности [countries]
CREATE TABLE eco.his_countries_sales_tax_rate (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_sales_tax_rate IS 'Историческая таблица для свойства [sales_tax_rate] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_sales_tax_rate.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_sales_tax_rate.dt IS 'Время значения свойства [sales_tax_rate] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_sales_tax_rate.value IS 'Значение свойства [sales_tax_rate] сущности [countries]';
ALTER TABLE eco.his_countries_sales_tax_rate ADD CONSTRAINT pk_eco_his_countries_sales_tax_rate PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_sh_xpd_chex_gd_zs
-- Комментарий: Историческая таблица для свойства [sh_xpd_chex_gd_zs] сущности [countries]
CREATE TABLE eco.his_countries_sh_xpd_chex_gd_zs (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_sh_xpd_chex_gd_zs IS 'Историческая таблица для свойства [sh_xpd_chex_gd_zs] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_sh_xpd_chex_gd_zs.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_sh_xpd_chex_gd_zs.dt IS 'Время значения свойства [sh_xpd_chex_gd_zs] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_sh_xpd_chex_gd_zs.value IS 'Значение свойства [sh_xpd_chex_gd_zs] сущности [countries]';
ALTER TABLE eco.his_countries_sh_xpd_chex_gd_zs ADD CONSTRAINT pk_eco_his_countries_sh_xpd_chex_gd_zs PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_sh_xpd_chex_pc_cd
-- Комментарий: Историческая таблица для свойства [sh_xpd_chex_pc_cd] сущности [countries]
CREATE TABLE eco.his_countries_sh_xpd_chex_pc_cd (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_sh_xpd_chex_pc_cd IS 'Историческая таблица для свойства [sh_xpd_chex_pc_cd] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_sh_xpd_chex_pc_cd.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_sh_xpd_chex_pc_cd.dt IS 'Время значения свойства [sh_xpd_chex_pc_cd] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_sh_xpd_chex_pc_cd.value IS 'Значение свойства [sh_xpd_chex_pc_cd] сущности [countries]';
ALTER TABLE eco.his_countries_sh_xpd_chex_pc_cd ADD CONSTRAINT pk_eco_his_countries_sh_xpd_chex_pc_cd PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_social_security_rate
-- Комментарий: Историческая таблица для свойства [social_security_rate] сущности [countries]
CREATE TABLE eco.his_countries_social_security_rate (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_social_security_rate IS 'Историческая таблица для свойства [social_security_rate] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_social_security_rate.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_social_security_rate.dt IS 'Время значения свойства [social_security_rate] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_social_security_rate.value IS 'Значение свойства [social_security_rate] сущности [countries]';
ALTER TABLE eco.his_countries_social_security_rate ADD CONSTRAINT pk_eco_his_countries_social_security_rate PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_social_security_rate_for_companies
-- Комментарий: Историческая таблица для свойства [social_security_rate_for_companies] сущности [countries]
CREATE TABLE eco.his_countries_social_security_rate_for_companies (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_social_security_rate_for_companies IS 'Историческая таблица для свойства [social_security_rate_for_companies] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_social_security_rate_for_companies.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_social_security_rate_for_companies.dt IS 'Время значения свойства [social_security_rate_for_companies] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_social_security_rate_for_companies.value IS 'Значение свойства [social_security_rate_for_companies] сущности [countries]';
ALTER TABLE eco.his_countries_social_security_rate_for_companies ADD CONSTRAINT pk_eco_his_countries_social_security_rate_for_companies PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_social_security_rate_for_empl
-- Комментарий: Историческая таблица для свойства [social_security_rate_for_empl] сущности [countries]
CREATE TABLE eco.his_countries_social_security_rate_for_empl (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_social_security_rate_for_empl IS 'Историческая таблица для свойства [social_security_rate_for_empl] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_social_security_rate_for_empl.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_social_security_rate_for_empl.dt IS 'Время значения свойства [social_security_rate_for_empl] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_social_security_rate_for_empl.value IS 'Значение свойства [social_security_rate_for_empl] сущности [countries]';
ALTER TABLE eco.his_countries_social_security_rate_for_empl ADD CONSTRAINT pk_eco_his_countries_social_security_rate_for_empl PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_sp_dyn_amrt_fe
-- Комментарий: Историческая таблица для свойства [sp_dyn_amrt_fe] сущности [countries]
CREATE TABLE eco.his_countries_sp_dyn_amrt_fe (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value integer(32,0));
COMMENT ON TABLE eco.his_countries_sp_dyn_amrt_fe IS 'Историческая таблица для свойства [sp_dyn_amrt_fe] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_sp_dyn_amrt_fe.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_sp_dyn_amrt_fe.dt IS 'Время значения свойства [sp_dyn_amrt_fe] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_sp_dyn_amrt_fe.value IS 'Значение свойства [sp_dyn_amrt_fe] сущности [countries]';
ALTER TABLE eco.his_countries_sp_dyn_amrt_fe ADD CONSTRAINT pk_eco_his_countries_sp_dyn_amrt_fe PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_sp_dyn_amrt_ma
-- Комментарий: Историческая таблица для свойства [sp_dyn_amrt_ma] сущности [countries]
CREATE TABLE eco.his_countries_sp_dyn_amrt_ma (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value integer(32,0));
COMMENT ON TABLE eco.his_countries_sp_dyn_amrt_ma IS 'Историческая таблица для свойства [sp_dyn_amrt_ma] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_sp_dyn_amrt_ma.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_sp_dyn_amrt_ma.dt IS 'Время значения свойства [sp_dyn_amrt_ma] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_sp_dyn_amrt_ma.value IS 'Значение свойства [sp_dyn_amrt_ma] сущности [countries]';
ALTER TABLE eco.his_countries_sp_dyn_amrt_ma ADD CONSTRAINT pk_eco_his_countries_sp_dyn_amrt_ma PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_sp_dyn_cbrt_in
-- Комментарий: Историческая таблица для свойства [sp_dyn_cbrt_in] сущности [countries]
CREATE TABLE eco.his_countries_sp_dyn_cbrt_in (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value integer(32,0));
COMMENT ON TABLE eco.his_countries_sp_dyn_cbrt_in IS 'Историческая таблица для свойства [sp_dyn_cbrt_in] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_sp_dyn_cbrt_in.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_sp_dyn_cbrt_in.dt IS 'Время значения свойства [sp_dyn_cbrt_in] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_sp_dyn_cbrt_in.value IS 'Значение свойства [sp_dyn_cbrt_in] сущности [countries]';
ALTER TABLE eco.his_countries_sp_dyn_cbrt_in ADD CONSTRAINT pk_eco_his_countries_sp_dyn_cbrt_in PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_sp_dyn_conm_zs
-- Комментарий: Историческая таблица для свойства [sp_dyn_conm_zs] сущности [countries]
CREATE TABLE eco.his_countries_sp_dyn_conm_zs (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_sp_dyn_conm_zs IS 'Историческая таблица для свойства [sp_dyn_conm_zs] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_sp_dyn_conm_zs.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_sp_dyn_conm_zs.dt IS 'Время значения свойства [sp_dyn_conm_zs] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_sp_dyn_conm_zs.value IS 'Значение свойства [sp_dyn_conm_zs] сущности [countries]';
ALTER TABLE eco.his_countries_sp_dyn_conm_zs ADD CONSTRAINT pk_eco_his_countries_sp_dyn_conm_zs PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_sp_dyn_le00_fe_in
-- Комментарий: Историческая таблица для свойства [sp_dyn_le00_fe_in] сущности [countries]
CREATE TABLE eco.his_countries_sp_dyn_le00_fe_in (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value integer(32,0));
COMMENT ON TABLE eco.his_countries_sp_dyn_le00_fe_in IS 'Историческая таблица для свойства [sp_dyn_le00_fe_in] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_sp_dyn_le00_fe_in.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_sp_dyn_le00_fe_in.dt IS 'Время значения свойства [sp_dyn_le00_fe_in] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_sp_dyn_le00_fe_in.value IS 'Значение свойства [sp_dyn_le00_fe_in] сущности [countries]';
ALTER TABLE eco.his_countries_sp_dyn_le00_fe_in ADD CONSTRAINT pk_eco_his_countries_sp_dyn_le00_fe_in PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_sp_dyn_le00_ma_in
-- Комментарий: Историческая таблица для свойства [sp_dyn_le00_ma_in] сущности [countries]
CREATE TABLE eco.his_countries_sp_dyn_le00_ma_in (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value integer(32,0));
COMMENT ON TABLE eco.his_countries_sp_dyn_le00_ma_in IS 'Историческая таблица для свойства [sp_dyn_le00_ma_in] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_sp_dyn_le00_ma_in.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_sp_dyn_le00_ma_in.dt IS 'Время значения свойства [sp_dyn_le00_ma_in] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_sp_dyn_le00_ma_in.value IS 'Значение свойства [sp_dyn_le00_ma_in] сущности [countries]';
ALTER TABLE eco.his_countries_sp_dyn_le00_ma_in ADD CONSTRAINT pk_eco_his_countries_sp_dyn_le00_ma_in PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_sp_dyn_to65_fe_zs
-- Комментарий: Историческая таблица для свойства [sp_dyn_to65_fe_zs] сущности [countries]
CREATE TABLE eco.his_countries_sp_dyn_to65_fe_zs (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value integer(32,0));
COMMENT ON TABLE eco.his_countries_sp_dyn_to65_fe_zs IS 'Историческая таблица для свойства [sp_dyn_to65_fe_zs] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_sp_dyn_to65_fe_zs.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_sp_dyn_to65_fe_zs.dt IS 'Время значения свойства [sp_dyn_to65_fe_zs] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_sp_dyn_to65_fe_zs.value IS 'Значение свойства [sp_dyn_to65_fe_zs] сущности [countries]';
ALTER TABLE eco.his_countries_sp_dyn_to65_fe_zs ADD CONSTRAINT pk_eco_his_countries_sp_dyn_to65_fe_zs PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_sp_dyn_to65_ma_zs
-- Комментарий: Историческая таблица для свойства [sp_dyn_to65_ma_zs] сущности [countries]
CREATE TABLE eco.his_countries_sp_dyn_to65_ma_zs (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value integer(32,0));
COMMENT ON TABLE eco.his_countries_sp_dyn_to65_ma_zs IS 'Историческая таблица для свойства [sp_dyn_to65_ma_zs] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_sp_dyn_to65_ma_zs.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_sp_dyn_to65_ma_zs.dt IS 'Время значения свойства [sp_dyn_to65_ma_zs] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_sp_dyn_to65_ma_zs.value IS 'Значение свойства [sp_dyn_to65_ma_zs] сущности [countries]';
ALTER TABLE eco.his_countries_sp_dyn_to65_ma_zs ADD CONSTRAINT pk_eco_his_countries_sp_dyn_to65_ma_zs PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_sp_dyn_wfrt
-- Комментарий: Историческая таблица для свойства [sp_dyn_wfrt] сущности [countries]
CREATE TABLE eco.his_countries_sp_dyn_wfrt (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value integer(32,0));
COMMENT ON TABLE eco.his_countries_sp_dyn_wfrt IS 'Историческая таблица для свойства [sp_dyn_wfrt] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_sp_dyn_wfrt.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_sp_dyn_wfrt.dt IS 'Время значения свойства [sp_dyn_wfrt] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_sp_dyn_wfrt.value IS 'Значение свойства [sp_dyn_wfrt] сущности [countries]';
ALTER TABLE eco.his_countries_sp_dyn_wfrt ADD CONSTRAINT pk_eco_his_countries_sp_dyn_wfrt PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_sp_pop_0014_to_zs
-- Комментарий: Историческая таблица для свойства [sp_pop_0014_to_zs] сущности [countries]
CREATE TABLE eco.his_countries_sp_pop_0014_to_zs (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value integer(32,0));
COMMENT ON TABLE eco.his_countries_sp_pop_0014_to_zs IS 'Историческая таблица для свойства [sp_pop_0014_to_zs] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_sp_pop_0014_to_zs.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_sp_pop_0014_to_zs.dt IS 'Время значения свойства [sp_pop_0014_to_zs] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_sp_pop_0014_to_zs.value IS 'Значение свойства [sp_pop_0014_to_zs] сущности [countries]';
ALTER TABLE eco.his_countries_sp_pop_0014_to_zs ADD CONSTRAINT pk_eco_his_countries_sp_pop_0014_to_zs PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_sp_pop_1564_to_zs
-- Комментарий: Историческая таблица для свойства [sp_pop_1564_to_zs] сущности [countries]
CREATE TABLE eco.his_countries_sp_pop_1564_to_zs (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value integer(32,0));
COMMENT ON TABLE eco.his_countries_sp_pop_1564_to_zs IS 'Историческая таблица для свойства [sp_pop_1564_to_zs] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_sp_pop_1564_to_zs.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_sp_pop_1564_to_zs.dt IS 'Время значения свойства [sp_pop_1564_to_zs] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_sp_pop_1564_to_zs.value IS 'Значение свойства [sp_pop_1564_to_zs] сущности [countries]';
ALTER TABLE eco.his_countries_sp_pop_1564_to_zs ADD CONSTRAINT pk_eco_his_countries_sp_pop_1564_to_zs PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_sp_pop_65up_to_zs
-- Комментарий: Историческая таблица для свойства [sp_pop_65up_to_zs] сущности [countries]
CREATE TABLE eco.his_countries_sp_pop_65up_to_zs (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value integer(32,0));
COMMENT ON TABLE eco.his_countries_sp_pop_65up_to_zs IS 'Историческая таблица для свойства [sp_pop_65up_to_zs] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_sp_pop_65up_to_zs.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_sp_pop_65up_to_zs.dt IS 'Время значения свойства [sp_pop_65up_to_zs] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_sp_pop_65up_to_zs.value IS 'Значение свойства [sp_pop_65up_to_zs] сущности [countries]';
ALTER TABLE eco.his_countries_sp_pop_65up_to_zs ADD CONSTRAINT pk_eco_his_countries_sp_pop_65up_to_zs PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_taxrevenue_per
-- Комментарий: Историческая таблица для свойства [taxrevenue_per] сущности [countries]
CREATE TABLE eco.his_countries_taxrevenue_per (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_taxrevenue_per IS 'Историческая таблица для свойства [taxrevenue_per] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_taxrevenue_per.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_taxrevenue_per.dt IS 'Время значения свойства [taxrevenue_per] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_taxrevenue_per.value IS 'Значение свойства [taxrevenue_per] сущности [countries]';
ALTER TABLE eco.his_countries_taxrevenue_per ADD CONSTRAINT pk_eco_his_countries_taxrevenue_per PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_taxtotal_per
-- Комментарий: Историческая таблица для свойства [taxtotal_per] сущности [countries]
CREATE TABLE eco.his_countries_taxtotal_per (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_taxtotal_per IS 'Историческая таблица для свойства [taxtotal_per] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_taxtotal_per.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_taxtotal_per.dt IS 'Время значения свойства [taxtotal_per] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_taxtotal_per.value IS 'Значение свойства [taxtotal_per] сущности [countries]';
ALTER TABLE eco.his_countries_taxtotal_per ADD CONSTRAINT pk_eco_his_countries_taxtotal_per PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_total_air
-- Комментарий: Историческая таблица для свойства [total_air] сущности [countries]
CREATE TABLE eco.his_countries_total_air (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value integer(32,0));
COMMENT ON TABLE eco.his_countries_total_air IS 'Историческая таблица для свойства [total_air] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_total_air.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_total_air.dt IS 'Время значения свойства [total_air] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_total_air.value IS 'Значение свойства [total_air] сущности [countries]';
ALTER TABLE eco.his_countries_total_air ADD CONSTRAINT pk_eco_his_countries_total_air PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_total_railway
-- Комментарий: Историческая таблица для свойства [total_railway] сущности [countries]
CREATE TABLE eco.his_countries_total_railway (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value integer(32,0));
COMMENT ON TABLE eco.his_countries_total_railway IS 'Историческая таблица для свойства [total_railway] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_total_railway.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_total_railway.dt IS 'Время значения свойства [total_railway] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_total_railway.value IS 'Значение свойства [total_railway] сущности [countries]';
ALTER TABLE eco.his_countries_total_railway ADD CONSTRAINT pk_eco_his_countries_total_railway PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_total_sale_house
-- Комментарий: Историческая таблица для свойства [total_sale_house] сущности [countries]
CREATE TABLE eco.his_countries_total_sale_house (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value integer(32,0));
COMMENT ON TABLE eco.his_countries_total_sale_house IS 'Историческая таблица для свойства [total_sale_house] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_total_sale_house.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_total_sale_house.dt IS 'Время значения свойства [total_sale_house] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_total_sale_house.value IS 'Значение свойства [total_sale_house] сущности [countries]';
ALTER TABLE eco.his_countries_total_sale_house ADD CONSTRAINT pk_eco_his_countries_total_sale_house PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_total_sale_house_first
-- Комментарий: Историческая таблица для свойства [total_sale_house_first] сущности [countries]
CREATE TABLE eco.his_countries_total_sale_house_first (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value integer(32,0));
COMMENT ON TABLE eco.his_countries_total_sale_house_first IS 'Историческая таблица для свойства [total_sale_house_first] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_total_sale_house_first.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_total_sale_house_first.dt IS 'Время значения свойства [total_sale_house_first] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_total_sale_house_first.value IS 'Значение свойства [total_sale_house_first] сущности [countries]';
ALTER TABLE eco.his_countries_total_sale_house_first ADD CONSTRAINT pk_eco_his_countries_total_sale_house_first PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_total_sale_house_first_month
-- Комментарий: Историческая таблица для свойства [total_sale_house_first_month] сущности [countries]
CREATE TABLE eco.his_countries_total_sale_house_first_month (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value integer(32,0));
COMMENT ON TABLE eco.his_countries_total_sale_house_first_month IS 'Историческая таблица для свойства [total_sale_house_first_month] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_total_sale_house_first_month.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_total_sale_house_first_month.dt IS 'Время значения свойства [total_sale_house_first_month] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_total_sale_house_first_month.value IS 'Значение свойства [total_sale_house_first_month] сущности [countries]';
ALTER TABLE eco.his_countries_total_sale_house_first_month ADD CONSTRAINT pk_eco_his_countries_total_sale_house_first_month PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_total_sale_house_month
-- Комментарий: Историческая таблица для свойства [total_sale_house_month] сущности [countries]
CREATE TABLE eco.his_countries_total_sale_house_month (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value integer(32,0));
COMMENT ON TABLE eco.his_countries_total_sale_house_month IS 'Историческая таблица для свойства [total_sale_house_month] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_total_sale_house_month.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_total_sale_house_month.dt IS 'Время значения свойства [total_sale_house_month] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_total_sale_house_month.value IS 'Значение свойства [total_sale_house_month] сущности [countries]';
ALTER TABLE eco.his_countries_total_sale_house_month ADD CONSTRAINT pk_eco_his_countries_total_sale_house_month PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_total_sale_house_mortage
-- Комментарий: Историческая таблица для свойства [total_sale_house_mortage] сущности [countries]
CREATE TABLE eco.his_countries_total_sale_house_mortage (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value integer(32,0));
COMMENT ON TABLE eco.his_countries_total_sale_house_mortage IS 'Историческая таблица для свойства [total_sale_house_mortage] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_total_sale_house_mortage.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_total_sale_house_mortage.dt IS 'Время значения свойства [total_sale_house_mortage] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_total_sale_house_mortage.value IS 'Значение свойства [total_sale_house_mortage] сущности [countries]';
ALTER TABLE eco.his_countries_total_sale_house_mortage ADD CONSTRAINT pk_eco_his_countries_total_sale_house_mortage PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_total_sale_house_mortage_month
-- Комментарий: Историческая таблица для свойства [total_sale_house_mortage_month] сущности [countries]
CREATE TABLE eco.his_countries_total_sale_house_mortage_month (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value integer(32,0));
COMMENT ON TABLE eco.his_countries_total_sale_house_mortage_month IS 'Историческая таблица для свойства [total_sale_house_mortage_month] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_total_sale_house_mortage_month.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_total_sale_house_mortage_month.dt IS 'Время значения свойства [total_sale_house_mortage_month] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_total_sale_house_mortage_month.value IS 'Значение свойства [total_sale_house_mortage_month] сущности [countries]';
ALTER TABLE eco.his_countries_total_sale_house_mortage_month ADD CONSTRAINT pk_eco_his_countries_total_sale_house_mortage_month PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_total_sale_house_other
-- Комментарий: Историческая таблица для свойства [total_sale_house_other] сущности [countries]
CREATE TABLE eco.his_countries_total_sale_house_other (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value integer(32,0));
COMMENT ON TABLE eco.his_countries_total_sale_house_other IS 'Историческая таблица для свойства [total_sale_house_other] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_total_sale_house_other.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_total_sale_house_other.dt IS 'Время значения свойства [total_sale_house_other] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_total_sale_house_other.value IS 'Значение свойства [total_sale_house_other] сущности [countries]';
ALTER TABLE eco.his_countries_total_sale_house_other ADD CONSTRAINT pk_eco_his_countries_total_sale_house_other PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_total_sale_house_other_month
-- Комментарий: Историческая таблица для свойства [total_sale_house_other_month] сущности [countries]
CREATE TABLE eco.his_countries_total_sale_house_other_month (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value integer(32,0));
COMMENT ON TABLE eco.his_countries_total_sale_house_other_month IS 'Историческая таблица для свойства [total_sale_house_other_month] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_total_sale_house_other_month.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_total_sale_house_other_month.dt IS 'Время значения свойства [total_sale_house_other_month] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_total_sale_house_other_month.value IS 'Значение свойства [total_sale_house_other_month] сущности [countries]';
ALTER TABLE eco.his_countries_total_sale_house_other_month ADD CONSTRAINT pk_eco_his_countries_total_sale_house_other_month PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_total_sale_house_second
-- Комментарий: Историческая таблица для свойства [total_sale_house_second] сущности [countries]
CREATE TABLE eco.his_countries_total_sale_house_second (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value integer(32,0));
COMMENT ON TABLE eco.his_countries_total_sale_house_second IS 'Историческая таблица для свойства [total_sale_house_second] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_total_sale_house_second.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_total_sale_house_second.dt IS 'Время значения свойства [total_sale_house_second] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_total_sale_house_second.value IS 'Значение свойства [total_sale_house_second] сущности [countries]';
ALTER TABLE eco.his_countries_total_sale_house_second ADD CONSTRAINT pk_eco_his_countries_total_sale_house_second PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_total_sale_house_second_month
-- Комментарий: Историческая таблица для свойства [total_sale_house_second_month] сущности [countries]
CREATE TABLE eco.his_countries_total_sale_house_second_month (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value integer(32,0));
COMMENT ON TABLE eco.his_countries_total_sale_house_second_month IS 'Историческая таблица для свойства [total_sale_house_second_month] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_total_sale_house_second_month.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_total_sale_house_second_month.dt IS 'Время значения свойства [total_sale_house_second_month] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_total_sale_house_second_month.value IS 'Значение свойства [total_sale_house_second_month] сущности [countries]';
ALTER TABLE eco.his_countries_total_sale_house_second_month ADD CONSTRAINT pk_eco_his_countries_total_sale_house_second_month PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_tourism_gdp_per
-- Комментарий: Историческая таблица для свойства [tourism_gdp_per] сущности [countries]
CREATE TABLE eco.his_countries_tourism_gdp_per (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_tourism_gdp_per IS 'Историческая таблица для свойства [tourism_gdp_per] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_tourism_gdp_per.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_tourism_gdp_per.dt IS 'Время значения свойства [tourism_gdp_per] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_tourism_gdp_per.value IS 'Значение свойства [tourism_gdp_per] сущности [countries]';
ALTER TABLE eco.his_countries_tourism_gdp_per ADD CONSTRAINT pk_eco_his_countries_tourism_gdp_per PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_trafic_time_index
-- Комментарий: Историческая таблица для свойства [trafic_time_index] сущности [countries]
CREATE TABLE eco.his_countries_trafic_time_index (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_trafic_time_index IS 'Историческая таблица для свойства [trafic_time_index] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_trafic_time_index.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_trafic_time_index.dt IS 'Время значения свойства [trafic_time_index] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_trafic_time_index.value IS 'Значение свойства [trafic_time_index] сущности [countries]';
ALTER TABLE eco.his_countries_trafic_time_index ADD CONSTRAINT pk_eco_his_countries_trafic_time_index PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_unemployment
-- Комментарий: Историческая таблица для свойства [unemployment] сущности [countries]
CREATE TABLE eco.his_countries_unemployment (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value double precision);
COMMENT ON TABLE eco.his_countries_unemployment IS 'Историческая таблица для свойства [unemployment] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_unemployment.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_unemployment.dt IS 'Время значения свойства [unemployment] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_unemployment.value IS 'Значение свойства [unemployment] сущности [countries]';
ALTER TABLE eco.his_countries_unemployment ADD CONSTRAINT pk_eco_his_countries_unemployment PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_urb_lcty
-- Комментарий: Историческая таблица для свойства [urb_lcty] сущности [countries]
CREATE TABLE eco.his_countries_urb_lcty (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_urb_lcty IS 'Историческая таблица для свойства [urb_lcty] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_urb_lcty.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_urb_lcty.dt IS 'Время значения свойства [urb_lcty] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_urb_lcty.value IS 'Значение свойства [urb_lcty] сущности [countries]';
ALTER TABLE eco.his_countries_urb_lcty ADD CONSTRAINT pk_eco_his_countries_urb_lcty PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_urb_mln_procent
-- Комментарий: Историческая таблица для свойства [urb_mln_procent] сущности [countries]
CREATE TABLE eco.his_countries_urb_mln_procent (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_urb_mln_procent IS 'Историческая таблица для свойства [urb_mln_procent] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_urb_mln_procent.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_urb_mln_procent.dt IS 'Время значения свойства [urb_mln_procent] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_urb_mln_procent.value IS 'Значение свойства [urb_mln_procent] сущности [countries]';
ALTER TABLE eco.his_countries_urb_mln_procent ADD CONSTRAINT pk_eco_his_countries_urb_mln_procent PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_urb_total
-- Комментарий: Историческая таблица для свойства [urb_total] сущности [countries]
CREATE TABLE eco.his_countries_urb_total (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value integer(32,0));
COMMENT ON TABLE eco.his_countries_urb_total IS 'Историческая таблица для свойства [urb_total] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_urb_total.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_urb_total.dt IS 'Время значения свойства [urb_total] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_urb_total.value IS 'Значение свойства [urb_total] сущности [countries]';
ALTER TABLE eco.his_countries_urb_total ADD CONSTRAINT pk_eco_his_countries_urb_total PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_urb_total_percent
-- Комментарий: Историческая таблица для свойства [urb_total_percent] сущности [countries]
CREATE TABLE eco.his_countries_urb_total_percent (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_urb_total_percent IS 'Историческая таблица для свойства [urb_total_percent] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_urb_total_percent.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_urb_total_percent.dt IS 'Время значения свойства [urb_total_percent] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_urb_total_percent.value IS 'Значение свойства [urb_total_percent] сущности [countries]';
ALTER TABLE eco.his_countries_urb_total_percent ADD CONSTRAINT pk_eco_his_countries_urb_total_percent PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_vc_ihr_psrc_p5
-- Комментарий: Историческая таблица для свойства [vc_ihr_psrc_p5] сущности [countries]
CREATE TABLE eco.his_countries_vc_ihr_psrc_p5 (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_vc_ihr_psrc_p5 IS 'Историческая таблица для свойства [vc_ihr_psrc_p5] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_vc_ihr_psrc_p5.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_vc_ihr_psrc_p5.dt IS 'Время значения свойства [vc_ihr_psrc_p5] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_vc_ihr_psrc_p5.value IS 'Значение свойства [vc_ihr_psrc_p5] сущности [countries]';
ALTER TABLE eco.his_countries_vc_ihr_psrc_p5 ADD CONSTRAINT pk_eco_his_countries_vc_ihr_psrc_p5 PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_water
-- Комментарий: Историческая таблица для свойства [water] сущности [countries]
CREATE TABLE eco.his_countries_water (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_water IS 'Историческая таблица для свойства [water] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_water.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_water.dt IS 'Время значения свойства [water] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_water.value IS 'Значение свойства [water] сущности [countries]';
ALTER TABLE eco.his_countries_water ADD CONSTRAINT pk_eco_his_countries_water PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_countries_water15
-- Комментарий: Историческая таблица для свойства [water15] сущности [countries]
CREATE TABLE eco.his_countries_water15 (countries_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_countries_water15 IS 'Историческая таблица для свойства [water15] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_water15.countries_id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.his_countries_water15.dt IS 'Время значения свойства [water15] сущности [countries]';
COMMENT ON COLUMN eco.his_countries_water15.value IS 'Значение свойства [water15] сущности [countries]';
ALTER TABLE eco.his_countries_water15 ADD CONSTRAINT pk_eco_his_countries_water15 PRIMARY KEY (countries_id, dt);

-- Таблица: eco.his_currencies_course
-- Комментарий: Историческая таблица для свойства [course] сущности [currencies]
CREATE TABLE eco.his_currencies_course (currencies_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE eco.his_currencies_course IS 'Историческая таблица для свойства [course] сущности [currencies]';
COMMENT ON COLUMN eco.his_currencies_course.currencies_id IS 'Ссылка на объект сущности [currencies]';
COMMENT ON COLUMN eco.his_currencies_course.dt IS 'Время значения свойства [course] сущности [currencies]';
COMMENT ON COLUMN eco.his_currencies_course.value IS 'Значение свойства [course] сущности [currencies]';
ALTER TABLE eco.his_currencies_course ADD CONSTRAINT pk_eco_his_currencies_course PRIMARY KEY (currencies_id, dt);

-- Таблица: eco.his_emails_hist
-- Комментарий: Историческая таблица для свойства [hist] сущности [emails]
CREATE TABLE eco.his_emails_hist (emails_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value text);
COMMENT ON TABLE eco.his_emails_hist IS 'Историческая таблица для свойства [hist] сущности [emails]';
COMMENT ON COLUMN eco.his_emails_hist.emails_id IS 'Ссылка на объект сущности [emails]';
COMMENT ON COLUMN eco.his_emails_hist.dt IS 'Время значения свойства [hist] сущности [emails]';
COMMENT ON COLUMN eco.his_emails_hist.value IS 'Значение свойства [hist] сущности [emails]';
ALTER TABLE eco.his_emails_hist ADD CONSTRAINT pk_eco_his_emails_hist PRIMARY KEY (emails_id, dt);

-- Таблица: eco.his_guests_page
-- Комментарий: Историческая таблица для свойства [page] сущности [guests]
CREATE TABLE eco.his_guests_page (guests_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value character varying);
COMMENT ON TABLE eco.his_guests_page IS 'Историческая таблица для свойства [page] сущности [guests]';
COMMENT ON COLUMN eco.his_guests_page.guests_id IS 'Ссылка на объект сущности [guests]';
COMMENT ON COLUMN eco.his_guests_page.dt IS 'Время значения свойства [page] сущности [guests]';
COMMENT ON COLUMN eco.his_guests_page.value IS 'Значение свойства [page] сущности [guests]';
ALTER TABLE eco.his_guests_page ADD CONSTRAINT pk_eco_his_guests_page PRIMARY KEY (guests_id, dt);

-- Таблица: eco.his_provinces_area
-- Комментарий: Историческая таблица для свойства [area] сущности [provinces]
CREATE TABLE eco.his_provinces_area (provinces_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value integer(32,0));
COMMENT ON TABLE eco.his_provinces_area IS 'Историческая таблица для свойства [area] сущности [provinces]';
COMMENT ON COLUMN eco.his_provinces_area.provinces_id IS 'Ссылка на объект сущности [provinces]';
COMMENT ON COLUMN eco.his_provinces_area.dt IS 'Время значения свойства [area] сущности [provinces]';
COMMENT ON COLUMN eco.his_provinces_area.value IS 'Значение свойства [area] сущности [provinces]';
ALTER TABLE eco.his_provinces_area ADD CONSTRAINT pk_eco_his_provinces_area PRIMARY KEY (provinces_id, dt);

-- Таблица: eco.his_provinces_pops
-- Комментарий: Историческая таблица для свойства [pops] сущности [provinces]
CREATE TABLE eco.his_provinces_pops (provinces_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value integer(32,0));
COMMENT ON TABLE eco.his_provinces_pops IS 'Историческая таблица для свойства [pops] сущности [provinces]';
COMMENT ON COLUMN eco.his_provinces_pops.provinces_id IS 'Ссылка на объект сущности [provinces]';
COMMENT ON COLUMN eco.his_provinces_pops.dt IS 'Время значения свойства [pops] сущности [provinces]';
COMMENT ON COLUMN eco.his_provinces_pops.value IS 'Значение свойства [pops] сущности [provinces]';
ALTER TABLE eco.his_provinces_pops ADD CONSTRAINT pk_eco_his_provinces_pops PRIMARY KEY (provinces_id, dt);

-- Таблица: eco.link_cities
-- Комментарий: Таблица хранения ссылок исторических параметров сущности [cities на параметры КСВД
CREATE TABLE eco.link_cities (id integer(32,0) NOT NULL, param_id integer(32,0) NOT NULL, parameter_id character varying, equipment_id character varying, type_his USER-DEFINED, discret integer(32,0));
COMMENT ON TABLE eco.link_cities IS 'Таблица хранения ссылок исторических параметров сущности [cities на параметры КСВД';
COMMENT ON COLUMN eco.link_cities.id IS 'Ссылка на объект сущности [cities]';
COMMENT ON COLUMN eco.link_cities.param_id IS 'Ссылка на тип параметров МДМ';
COMMENT ON COLUMN eco.link_cities.parameter_id IS 'Идентификатор параметра КСВД';
COMMENT ON COLUMN eco.link_cities.equipment_id IS 'Идентификатор устройства КСВД';
COMMENT ON COLUMN eco.link_cities.type_his IS 'Тип временного ряда';
COMMENT ON COLUMN eco.link_cities.discret IS 'Дискретность информации в секундах';
ALTER TABLE eco.link_cities ADD CONSTRAINT pk_nsi_link_cities PRIMARY KEY (id, param_id);

-- Таблица: eco.link_countries
-- Комментарий: Таблица хранения ссылок исторических параметров сущности [countries на параметры КСВД
CREATE TABLE eco.link_countries (id integer(32,0) NOT NULL, param_id integer(32,0) NOT NULL, parameter_id character varying, equipment_id character varying, type_his USER-DEFINED, discret integer(32,0));
COMMENT ON TABLE eco.link_countries IS 'Таблица хранения ссылок исторических параметров сущности [countries на параметры КСВД';
COMMENT ON COLUMN eco.link_countries.id IS 'Ссылка на объект сущности [countries]';
COMMENT ON COLUMN eco.link_countries.param_id IS 'Ссылка на тип параметров МДМ';
COMMENT ON COLUMN eco.link_countries.parameter_id IS 'Идентификатор параметра КСВД';
COMMENT ON COLUMN eco.link_countries.equipment_id IS 'Идентификатор устройства КСВД';
COMMENT ON COLUMN eco.link_countries.type_his IS 'Тип временного ряда';
COMMENT ON COLUMN eco.link_countries.discret IS 'Дискретность информации в секундах';
ALTER TABLE eco.link_countries ADD CONSTRAINT pk_nsi_link_countries PRIMARY KEY (id, param_id);

-- Таблица: eco.link_currencies
-- Комментарий: Таблица хранения ссылок исторических параметров сущности [currencies на параметры КСВД
CREATE TABLE eco.link_currencies (id integer(32,0) NOT NULL, param_id integer(32,0) NOT NULL, parameter_id character varying, equipment_id character varying, type_his USER-DEFINED, discret integer(32,0));
COMMENT ON TABLE eco.link_currencies IS 'Таблица хранения ссылок исторических параметров сущности [currencies на параметры КСВД';
COMMENT ON COLUMN eco.link_currencies.id IS 'Ссылка на объект сущности [currencies]';
COMMENT ON COLUMN eco.link_currencies.param_id IS 'Ссылка на тип параметров МДМ';
COMMENT ON COLUMN eco.link_currencies.parameter_id IS 'Идентификатор параметра КСВД';
COMMENT ON COLUMN eco.link_currencies.equipment_id IS 'Идентификатор устройства КСВД';
COMMENT ON COLUMN eco.link_currencies.type_his IS 'Тип временного ряда';
COMMENT ON COLUMN eco.link_currencies.discret IS 'Дискретность информации в секундах';
ALTER TABLE eco.link_currencies ADD CONSTRAINT pk_nsi_link_currencies PRIMARY KEY (id, param_id);

-- Таблица: eco.link_emails
-- Комментарий: Таблица хранения ссылок исторических параметров сущности [emails на параметры КСВД
CREATE TABLE eco.link_emails (id integer(32,0) NOT NULL, param_id integer(32,0) NOT NULL, parameter_id character varying, equipment_id character varying, type_his USER-DEFINED, discret integer(32,0));
COMMENT ON TABLE eco.link_emails IS 'Таблица хранения ссылок исторических параметров сущности [emails на параметры КСВД';
COMMENT ON COLUMN eco.link_emails.id IS 'Ссылка на объект сущности [emails]';
COMMENT ON COLUMN eco.link_emails.param_id IS 'Ссылка на тип параметров МДМ';
COMMENT ON COLUMN eco.link_emails.parameter_id IS 'Идентификатор параметра КСВД';
COMMENT ON COLUMN eco.link_emails.equipment_id IS 'Идентификатор устройства КСВД';
COMMENT ON COLUMN eco.link_emails.type_his IS 'Тип временного ряда';
COMMENT ON COLUMN eco.link_emails.discret IS 'Дискретность информации в секундах';
ALTER TABLE eco.link_emails ADD CONSTRAINT pk_nsi_link_emails PRIMARY KEY (id, param_id);

-- Таблица: eco.link_guests
-- Комментарий: Таблица хранения ссылок исторических параметров сущности [guests на параметры КСВД
CREATE TABLE eco.link_guests (id integer(32,0) NOT NULL, param_id integer(32,0) NOT NULL, parameter_id character varying, equipment_id character varying, type_his USER-DEFINED, discret integer(32,0));
COMMENT ON TABLE eco.link_guests IS 'Таблица хранения ссылок исторических параметров сущности [guests на параметры КСВД';
COMMENT ON COLUMN eco.link_guests.id IS 'Ссылка на объект сущности [guests]';
COMMENT ON COLUMN eco.link_guests.param_id IS 'Ссылка на тип параметров МДМ';
COMMENT ON COLUMN eco.link_guests.parameter_id IS 'Идентификатор параметра КСВД';
COMMENT ON COLUMN eco.link_guests.equipment_id IS 'Идентификатор устройства КСВД';
COMMENT ON COLUMN eco.link_guests.type_his IS 'Тип временного ряда';
COMMENT ON COLUMN eco.link_guests.discret IS 'Дискретность информации в секундах';
ALTER TABLE eco.link_guests ADD CONSTRAINT pk_nsi_link_guests PRIMARY KEY (id, param_id);

-- Таблица: eco.link_provinces
-- Комментарий: Таблица хранения ссылок исторических параметров сущности [provinces на параметры КСВД
CREATE TABLE eco.link_provinces (id integer(32,0) NOT NULL, param_id integer(32,0) NOT NULL, parameter_id character varying, equipment_id character varying, type_his USER-DEFINED, discret integer(32,0));
COMMENT ON TABLE eco.link_provinces IS 'Таблица хранения ссылок исторических параметров сущности [provinces на параметры КСВД';
COMMENT ON COLUMN eco.link_provinces.id IS 'Ссылка на объект сущности [provinces]';
COMMENT ON COLUMN eco.link_provinces.param_id IS 'Ссылка на тип параметров МДМ';
COMMENT ON COLUMN eco.link_provinces.parameter_id IS 'Идентификатор параметра КСВД';
COMMENT ON COLUMN eco.link_provinces.equipment_id IS 'Идентификатор устройства КСВД';
COMMENT ON COLUMN eco.link_provinces.type_his IS 'Тип временного ряда';
COMMENT ON COLUMN eco.link_provinces.discret IS 'Дискретность информации в секундах';
ALTER TABLE eco.link_provinces ADD CONSTRAINT pk_nsi_link_provinces PRIMARY KEY (id, param_id);

-- Таблица: eco.list_start_metric
-- Комментарий: Список метрик сервисов для принудительного разового заполнения из источника
CREATE TABLE eco.list_start_metric (sh_name character varying, indicator character varying);
COMMENT ON TABLE eco.list_start_metric IS 'Список метрик сервисов для принудительного разового заполнения из источника';
COMMENT ON COLUMN eco.list_start_metric.sh_name IS 'Имя функции парсера, который нужно запустить для чтения данных метрики';
COMMENT ON COLUMN eco.list_start_metric.indicator IS 'Индикатор метрики у источника информации';
CREATE UNIQUE INDEX list_start_metric_sh_name_idx ON eco.list_start_metric USING btree (sh_name, indicator);

-- Таблица: eco.logs
CREATE TABLE eco.logs (id integer(32,0) NOT NULL, at_date_time timestamp without time zone, level character varying, source character varying, td real, page integer(32,0), law_id character varying, file_name character varying, comment character varying);
ALTER TABLE eco.logs ADD CONSTRAINT pk_sozd_logs PRIMARY KEY (id);

-- Таблица: eco.nsi_chapter_countries
-- Комментарий: Список разделов для формирования вывода метрик по странам
CREATE TABLE eco.nsi_chapter_countries (id integer(32,0) NOT NULL, sh_name character varying(200), name_rus character varying(50), code character varying(50));
COMMENT ON TABLE eco.nsi_chapter_countries IS 'Список разделов для формирования вывода метрик по странам';
COMMENT ON COLUMN eco.nsi_chapter_countries.id IS 'Идентификатор объекта';
COMMENT ON COLUMN eco.nsi_chapter_countries.sh_name IS 'Наименование раздела метрик стран (англ)';
COMMENT ON COLUMN eco.nsi_chapter_countries.name_rus IS 'Наименование раздела метрик стран на русском языке';
COMMENT ON COLUMN eco.nsi_chapter_countries.code IS 'Код раздела (для связи с метриками)';
ALTER TABLE eco.nsi_chapter_countries ADD CONSTRAINT pk_eco_nsi_chapter_countries PRIMARY KEY (id);
CREATE UNIQUE INDEX nsi_chapter_countries_idx ON eco.nsi_chapter_countries USING btree (code);

-- Таблица: eco.nsi_cities
-- Комментарий: Города мира с большим населением 
CREATE TABLE eco.nsi_cities (id integer(32,0) NOT NULL, sh_name character varying(50), name_rus character varying(50), population integer(32,0), square real, country integer(32,0), province integer(32,0), lat real, lon real, need_meteo boolean, name_own character varying(50), characteristic text);
COMMENT ON TABLE eco.nsi_cities IS 'Города мира с большим населением ';
COMMENT ON COLUMN eco.nsi_cities.id IS 'Идентификатор объекта';
COMMENT ON COLUMN eco.nsi_cities.sh_name IS 'Наименование города на английском языке';
COMMENT ON COLUMN eco.nsi_cities.name_rus IS 'Название города на русском языке';
COMMENT ON COLUMN eco.nsi_cities.population IS 'Последние данные по численности населения города';
COMMENT ON COLUMN eco.nsi_cities.square IS 'Последние данные по площади города (кв. км)';
COMMENT ON COLUMN eco.nsi_cities.country IS 'Страна , в которой находится город';
COMMENT ON COLUMN eco.nsi_cities.province IS 'Провинция, штат, субъект федерации и т.п.';
COMMENT ON COLUMN eco.nsi_cities.lat IS 'Географическая широта города';
COMMENT ON COLUMN eco.nsi_cities.lon IS 'Географическая широта города';
COMMENT ON COLUMN eco.nsi_cities.need_meteo IS 'Признак сбора информации по погоде и ее обработке';
COMMENT ON COLUMN eco.nsi_cities.name_own IS 'Имя города на языке страны';
COMMENT ON COLUMN eco.nsi_cities.characteristic IS 'Текстовая информация, характеризующая город';
ALTER TABLE eco.nsi_cities ADD CONSTRAINT pk_eco_nsi_cities PRIMARY KEY (id);

-- Таблица: eco.nsi_colors
-- Комментарий: Цвета кривых графиков  и столбцов
CREATE TABLE eco.nsi_colors (id integer(32,0) NOT NULL, sh_name character varying(50), number_order integer(32,0), value character varying(32));
COMMENT ON TABLE eco.nsi_colors IS 'Цвета кривых графиков  и столбцов';
COMMENT ON COLUMN eco.nsi_colors.id IS 'Идентификатор объекта';
COMMENT ON COLUMN eco.nsi_colors.sh_name IS 'Наименование объекта';
COMMENT ON COLUMN eco.nsi_colors.number_order IS 'Порядковый номер графика с этим цветом';
COMMENT ON COLUMN eco.nsi_colors.value IS 'Числовое значение цвета';
ALTER TABLE eco.nsi_colors ADD CONSTRAINT pk_eco_nsi_colors PRIMARY KEY (id);

-- Таблица: eco.nsi_continent
-- Комментарий: Список регионов (континентов) земли
CREATE TABLE eco.nsi_continent (id integer(32,0) NOT NULL, sh_name character varying(50), code character varying(50));
COMMENT ON TABLE eco.nsi_continent IS 'Список регионов ~A~континентов~B~ земли';
COMMENT ON COLUMN eco.nsi_continent.id IS 'Идентификатор объекта';
COMMENT ON COLUMN eco.nsi_continent.sh_name IS 'Наименование объекта';
COMMENT ON COLUMN eco.nsi_continent.code IS 'Код континента';
ALTER TABLE eco.nsi_continent ADD CONSTRAINT pk_eco_nsi_continent PRIMARY KEY (id);
CREATE UNIQUE INDEX nsi_continent_idx ON eco.nsi_continent USING btree (code);

-- Таблица: eco.nsi_countries
-- Комментарий: Список стран мира
CREATE TABLE eco.nsi_countries (id integer(32,0) NOT NULL, sh_name character varying(250), official character varying(250), _delete boolean, name_rus character varying(250), official_rus character varying(250), code character varying(3), region integer(32,0), area real, population integer(32,0), capital_lat real, capital_lon real, capital character varying(50), car_side character varying(10), coat_of_arms text, flag_alt text, flag_svg text, independent boolean, landlocked boolean, start_of_week character varying(20), status character varying(50), un_member boolean, timezones text, government character varying(50), type_government character varying(50), es_member integer(32,0), cca2 character varying(2), phone_code character varying(32), av_age_last real);
COMMENT ON TABLE eco.nsi_countries IS 'Список стран мира';
COMMENT ON COLUMN eco.nsi_countries.id IS 'Идентификатор объекта';
COMMENT ON COLUMN eco.nsi_countries.sh_name IS 'Наименование страны на английском языке (общепринятое)';
COMMENT ON COLUMN eco.nsi_countries.official IS 'Официальное (полное) название страны';
COMMENT ON COLUMN eco.nsi_countries._delete IS 'Признак удаления объекта';
COMMENT ON COLUMN eco.nsi_countries.name_rus IS 'Название страны на русском языке';
COMMENT ON COLUMN eco.nsi_countries.official_rus IS 'Официальное название страны на русском языке';
COMMENT ON COLUMN eco.nsi_countries.code IS 'Уникальный код страны';
COMMENT ON COLUMN eco.nsi_countries.region IS 'Ссылка на регион расположения страны';
COMMENT ON COLUMN eco.nsi_countries.area IS 'Площадь страны';
COMMENT ON COLUMN eco.nsi_countries.population IS 'Численность наседения страны';
COMMENT ON COLUMN eco.nsi_countries.capital_lat IS 'Широта (град) столицы страны';
COMMENT ON COLUMN eco.nsi_countries.capital_lon IS 'Долгота столицы страны';
COMMENT ON COLUMN eco.nsi_countries.capital IS 'Массив наименований столицы (англ)';
COMMENT ON COLUMN eco.nsi_countries.car_side IS 'Полоса движения автотранспорта';
COMMENT ON COLUMN eco.nsi_countries.coat_of_arms IS 'Адрес изображения герба страны';
COMMENT ON COLUMN eco.nsi_countries.flag_alt IS 'Словесное описание флага страны';
COMMENT ON COLUMN eco.nsi_countries.flag_svg IS 'Ссылка на изображение флага страны';
COMMENT ON COLUMN eco.nsi_countries.independent IS 'Независимость страны';
COMMENT ON COLUMN eco.nsi_countries.landlocked IS 'Признак не морской страны';
COMMENT ON COLUMN eco.nsi_countries.start_of_week IS 'Название дня, с которого начинается неделя в стране';
COMMENT ON COLUMN eco.nsi_countries.status IS 'Статус признания страны в мире';
COMMENT ON COLUMN eco.nsi_countries.un_member IS 'Признак участия страны в ООН';
COMMENT ON COLUMN eco.nsi_countries.timezones IS 'Список часовых часов страны';
COMMENT ON COLUMN eco.nsi_countries.government IS 'Форма организации государства';
COMMENT ON COLUMN eco.nsi_countries.type_government IS 'Тип государственного устройства (унитарное, федеративное государство)';
COMMENT ON COLUMN eco.nsi_countries.es_member IS 'Признак страны члена Евро-Союза - год вступления ';
COMMENT ON COLUMN eco.nsi_countries.cca2 IS 'Код страны, представленный двумя символами';
COMMENT ON COLUMN eco.nsi_countries.phone_code IS 'Международный код страны для телефонной связи';
COMMENT ON COLUMN eco.nsi_countries.av_age_last IS 'Средний возраст населения';
ALTER TABLE eco.nsi_countries ADD CONSTRAINT pk_eco_nsi_countries PRIMARY KEY (id);
CREATE UNIQUE INDEX nsi_countries_idx ON eco.nsi_countries USING btree (official);

-- Таблица: eco.nsi_currencies
-- Комментарий: Список валют мира
CREATE TABLE eco.nsi_currencies (id integer(32,0) NOT NULL, sh_name character varying(100), code character varying(10), symbol character varying(10), _delete boolean);
COMMENT ON TABLE eco.nsi_currencies IS 'Список валют мира';
COMMENT ON COLUMN eco.nsi_currencies.id IS 'Идентификатор объекта';
COMMENT ON COLUMN eco.nsi_currencies.sh_name IS 'Наименование валюты';
COMMENT ON COLUMN eco.nsi_currencies.code IS 'Код валюты';
COMMENT ON COLUMN eco.nsi_currencies.symbol IS 'Символ валюты';
COMMENT ON COLUMN eco.nsi_currencies._delete IS 'Признак удаления объекта';
ALTER TABLE eco.nsi_currencies ADD CONSTRAINT pk_eco_nsi_currencies PRIMARY KEY (id);

-- Таблица: eco.nsi_districts
-- Комментарий: Районы в провинциях (штатах)
CREATE TABLE eco.nsi_districts (id integer(32,0) NOT NULL, sh_name character varying(50), name_own character varying(50), name_rus character varying(50), provinces integer(32,0), _delete boolean);
COMMENT ON TABLE eco.nsi_districts IS 'Районы в провинциях ~A~штатах~B~';
COMMENT ON COLUMN eco.nsi_districts.id IS 'Идентификатор объекта';
COMMENT ON COLUMN eco.nsi_districts.sh_name IS 'Наименование района на английском языке';
COMMENT ON COLUMN eco.nsi_districts.name_own IS 'Название района на языке страны';
COMMENT ON COLUMN eco.nsi_districts.name_rus IS 'Название района на русском языке';
COMMENT ON COLUMN eco.nsi_districts.provinces IS 'Провинция (штат, земля, субъект федерации), в которой находится район';
COMMENT ON COLUMN eco.nsi_districts._delete IS 'Признак удаления объекта';
ALTER TABLE eco.nsi_districts ADD CONSTRAINT pk_eco_nsi_districts PRIMARY KEY (id);

-- Таблица: eco.nsi_emails
-- Комментарий: Информация о пользователях системы                
CREATE TABLE eco.nsi_emails (id integer(32,0) NOT NULL, sh_name character varying(100), first_date timestamp without time zone, last_date timestamp without time zone, count integer(32,0));
COMMENT ON TABLE eco.nsi_emails IS 'Информация о пользователях системы                ';
COMMENT ON COLUMN eco.nsi_emails.id IS 'Идентификатор объекта';
COMMENT ON COLUMN eco.nsi_emails.sh_name IS 'Email пользователя (login при входе в систему)';
COMMENT ON COLUMN eco.nsi_emails.first_date IS 'Системное время первого обращения к системе';
COMMENT ON COLUMN eco.nsi_emails.last_date IS 'Время последнего входа в систему';
COMMENT ON COLUMN eco.nsi_emails.count IS 'Количество login, сделанных пользователем';
ALTER TABLE eco.nsi_emails ADD CONSTRAINT pk_eco_nsi_emails PRIMARY KEY (id);
CREATE UNIQUE INDEX nsi_emails_idx ON eco.nsi_emails USING btree (sh_name);

-- Таблица: eco.nsi_guests
-- Комментарий: Список IP адресов, посещающих сайт geo_web
CREATE TABLE eco.nsi_guests (id integer(32,0) NOT NULL, sh_name character varying(50), country character varying(50), city character varying(50), email integer(32,0));
COMMENT ON TABLE eco.nsi_guests IS 'Список IP адресов~a2~ посещающих сайт geo_web';
COMMENT ON COLUMN eco.nsi_guests.id IS 'Идентификатор объекта';
COMMENT ON COLUMN eco.nsi_guests.sh_name IS 'IP посетителя';
COMMENT ON COLUMN eco.nsi_guests.country IS 'Наименование страны IP';
COMMENT ON COLUMN eco.nsi_guests.city IS 'Название города IP';
COMMENT ON COLUMN eco.nsi_guests.email IS 'Пользователь системы';
ALTER TABLE eco.nsi_guests ADD CONSTRAINT pk_eco_nsi_guests PRIMARY KEY (id);

-- Таблица: eco.nsi_import
-- Комментарий: Описание импорта из разных источников
CREATE TABLE eco.nsi_import (id integer(32,0) NOT NULL, sh_name character varying(50) NOT NULL, name text, name_rus text, active boolean, param_name character varying(50), object_code USER-DEFINED, code text NOT NULL, period USER-DEFINED, column_count integer(32,0), ind_name integer(32,0), ind_value integer(32,0), coefficient integer(32,0));
COMMENT ON TABLE eco.nsi_import IS 'Описание импорта из разных источников';
COMMENT ON COLUMN eco.nsi_import.id IS 'Идентификатор объекта';
COMMENT ON COLUMN eco.nsi_import.sh_name IS 'Наименование источника данных';
COMMENT ON COLUMN eco.nsi_import.name IS 'Исходное название индикатора данных на английском языке';
COMMENT ON COLUMN eco.nsi_import.name_rus IS 'Название индикатора данных на русском языке';
COMMENT ON COLUMN eco.nsi_import.active IS 'Признак участия индикатора в автоматической загрузке';
COMMENT ON COLUMN eco.nsi_import.param_name IS 'Имя исторического параметра';
COMMENT ON COLUMN eco.nsi_import.object_code IS 'Код типа объектов, для которого образуется исторический параметр';
COMMENT ON COLUMN eco.nsi_import.code IS 'Индикатор данных для источника';
COMMENT ON COLUMN eco.nsi_import.period IS 'Периодичность запроса измерений';
COMMENT ON COLUMN eco.nsi_import.column_count IS 'Кол-во колонок в таблице';
COMMENT ON COLUMN eco.nsi_import.ind_name IS 'Индекс имени страны в строке';
COMMENT ON COLUMN eco.nsi_import.ind_value IS 'Индекс значения в строке таблицы';
COMMENT ON COLUMN eco.nsi_import.coefficient IS 'Коэффициент приведения данных из внешнего источника к единицам хранения в базе данных. Если отсутствует, то принимается за 1.';
ALTER TABLE eco.nsi_import ADD CONSTRAINT pk_eco_nsi_import PRIMARY KEY (id);
CREATE UNIQUE INDEX nsi_import_idx ON eco.nsi_import USING btree (sh_name, param_name, object_code);

-- Таблица: eco.nsi_languages
-- Комментарий: Список языков мира
CREATE TABLE eco.nsi_languages (id integer(32,0) NOT NULL, sh_name character varying(50), code character varying(3));
COMMENT ON TABLE eco.nsi_languages IS 'Список языков мира';
COMMENT ON COLUMN eco.nsi_languages.id IS 'Идентификатор объекта';
COMMENT ON COLUMN eco.nsi_languages.sh_name IS 'Название языка ';
COMMENT ON COLUMN eco.nsi_languages.code IS 'Код языка';
ALTER TABLE eco.nsi_languages ADD CONSTRAINT pk_eco_nsi_languages PRIMARY KEY (id);

-- Таблица: eco.nsi_list_countries
-- Комментарий: Список стран с кодами (для формирования границ)
CREATE TABLE eco.nsi_list_countries (id integer(32,0) NOT NULL, sh_name character varying(100), code character varying(3));
COMMENT ON TABLE eco.nsi_list_countries IS 'Список стран с кодами ~A~для формирования границ~B~';
COMMENT ON COLUMN eco.nsi_list_countries.id IS 'Идентификатор объекта';
COMMENT ON COLUMN eco.nsi_list_countries.sh_name IS 'Официальное название страны на английском языке';
COMMENT ON COLUMN eco.nsi_list_countries.code IS 'Код страны';
ALTER TABLE eco.nsi_list_countries ADD CONSTRAINT pk_eco_nsi_list_countries PRIMARY KEY (id);

-- Таблица: eco.nsi_lists
-- Комментарий: Списки стран для группировки стран по интересам
CREATE TABLE eco.nsi_lists (id integer(32,0) NOT NULL, sh_name character varying(50), adm integer(32,0));
COMMENT ON TABLE eco.nsi_lists IS 'Списки стран для группировки стран по интересам';
COMMENT ON COLUMN eco.nsi_lists.id IS 'Идентификатор объекта';
COMMENT ON COLUMN eco.nsi_lists.sh_name IS 'Наименование списка стран по интересам';
COMMENT ON COLUMN eco.nsi_lists.adm IS '1 - Административный список (который нельзя удалить)';
ALTER TABLE eco.nsi_lists ADD CONSTRAINT pk_eco_nsi_lists PRIMARY KEY (id);
CREATE UNIQUE INDEX nsi_lists_idx ON eco.nsi_lists USING btree (sh_name);

-- Таблица: eco.nsi_metrics_countries
-- Комментарий: Список метрик по странам
CREATE TABLE eco.nsi_metrics_countries (id integer(32,0) NOT NULL, sh_name character varying(250), name_rus character varying(250), code character varying(100), dig integer(32,0), div integer(32,0), month boolean, title text);
COMMENT ON TABLE eco.nsi_metrics_countries IS 'Список метрик по странам';
COMMENT ON COLUMN eco.nsi_metrics_countries.id IS 'Идентификатор объекта';
COMMENT ON COLUMN eco.nsi_metrics_countries.sh_name IS 'Наименование метрики на английском языке';
COMMENT ON COLUMN eco.nsi_metrics_countries.name_rus IS 'Имя метрики на русском языке';
COMMENT ON COLUMN eco.nsi_metrics_countries.code IS 'Код метрики (код параметра сущности типа HIS)';
COMMENT ON COLUMN eco.nsi_metrics_countries.dig IS 'Количество знаков после запятой при отображении значений';
COMMENT ON COLUMN eco.nsi_metrics_countries.div IS 'Величина, на которую нужно разделить значение метрики для отображения';
COMMENT ON COLUMN eco.nsi_metrics_countries.month IS 'Признак для формирования даты информации с месяцем';
COMMENT ON COLUMN eco.nsi_metrics_countries.title IS 'Текст, в котором объясняется сущность метрики';
ALTER TABLE eco.nsi_metrics_countries ADD CONSTRAINT pk_eco_nsi_metrics_countries PRIMARY KEY (id);
CREATE UNIQUE INDEX nsi_metrics_countries_idx ON eco.nsi_metrics_countries USING btree (code);

-- Таблица: eco.nsi_parser_functions
-- Комментарий: Список потоков, осуществляющих периодическую загрузку информации с внешних источников
CREATE TABLE eco.nsi_parser_functions (id integer(32,0) NOT NULL, sh_name character varying(50), description text, active integer(32,0), at_date_time timestamp without time zone, period real, compliment real, compliment_txt json);
COMMENT ON TABLE eco.nsi_parser_functions IS 'Список потоков~a2~ осуществляющих периодическую загрузку информации с внешних источников';
COMMENT ON COLUMN eco.nsi_parser_functions.id IS 'Идентификатор объекта';
COMMENT ON COLUMN eco.nsi_parser_functions.sh_name IS 'Наименование объекта';
COMMENT ON COLUMN eco.nsi_parser_functions.description IS 'Комментарий к потоку закачки информации';
COMMENT ON COLUMN eco.nsi_parser_functions.active IS '1 - поток активен, иначе - не активен';
COMMENT ON COLUMN eco.nsi_parser_functions.at_date_time IS 'Системное время последней работы потока';
COMMENT ON COLUMN eco.nsi_parser_functions.period IS 'Периодичность работы потока (дней)';
COMMENT ON COLUMN eco.nsi_parser_functions.compliment IS 'Дополнительный параметр (опционально)';
COMMENT ON COLUMN eco.nsi_parser_functions.compliment_txt IS 'Дополнительный параметр ';
ALTER TABLE eco.nsi_parser_functions ADD CONSTRAINT pk_eco_nsi_parser_functions PRIMARY KEY (id);

-- Таблица: eco.nsi_provinces
-- Комментарий: Деление стран на более мелкие части (штаты, провинции, субъекты федерации, земли и т.п.)
CREATE TABLE eco.nsi_provinces (id integer(32,0) NOT NULL, sh_name character varying(50), name_rus character varying(50), country integer(32,0), districts integer(32,0), communities integer(32,0), urban_villages integer(32,0), villages integer(32,0), name_own character varying(50), code character varying(16), city integer(32,0), region integer(32,0), status character varying(50), population integer(32,0), square integer(32,0), flag_svg text, capital integer(32,0));
COMMENT ON TABLE eco.nsi_provinces IS 'Деление стран на более мелкие части ~A~штаты~a2~ провинции~a2~ субъекты федерации~a2~ земли и т.п.~B~';
COMMENT ON COLUMN eco.nsi_provinces.id IS 'Идентификатор провинции';
COMMENT ON COLUMN eco.nsi_provinces.sh_name IS 'Наименование провинции';
COMMENT ON COLUMN eco.nsi_provinces.name_rus IS 'Наименование провинции на русском языке';
COMMENT ON COLUMN eco.nsi_provinces.country IS 'Страна, в которой находится провинция (штат и т.п.)';
COMMENT ON COLUMN eco.nsi_provinces.districts IS 'Количество районов провинции';
COMMENT ON COLUMN eco.nsi_provinces.communities IS 'Количество сообществ';
COMMENT ON COLUMN eco.nsi_provinces.urban_villages IS 'Количество поселков';
COMMENT ON COLUMN eco.nsi_provinces.villages IS 'Количество деревень';
COMMENT ON COLUMN eco.nsi_provinces.name_own IS 'Название провиниции (штата и т.п.) на языке страны провинции (на собственном языке)';
COMMENT ON COLUMN eco.nsi_provinces.code IS 'Код провинции';
COMMENT ON COLUMN eco.nsi_provinces.city IS 'Столица провинции';
COMMENT ON COLUMN eco.nsi_provinces.region IS 'Регион нахождения провинции';
COMMENT ON COLUMN eco.nsi_provinces.status IS 'Особый статус провинции';
COMMENT ON COLUMN eco.nsi_provinces.population IS 'Население провинции (штата, субъекта и т.п.)';
COMMENT ON COLUMN eco.nsi_provinces.square IS 'Площадь провинции (штата, субъекта)';
COMMENT ON COLUMN eco.nsi_provinces.flag_svg IS 'Ссылка на изображение флага провинции';
COMMENT ON COLUMN eco.nsi_provinces.capital IS 'Столица провинции (штата и т.п.)';
ALTER TABLE eco.nsi_provinces ADD CONSTRAINT pk_eco_nsi_provinces PRIMARY KEY (id);

-- Таблица: eco.nsi_tld
-- Комментарий: Суффиксы, которые используются в доменных именах
CREATE TABLE eco.nsi_tld (id integer(32,0) NOT NULL, sh_name character varying(5));
COMMENT ON TABLE eco.nsi_tld IS 'Суффиксы~a2~ которые используются в доменных именах';
COMMENT ON COLUMN eco.nsi_tld.id IS 'Идентификатор объекта';
COMMENT ON COLUMN eco.nsi_tld.sh_name IS 'Значение суффикса';
ALTER TABLE eco.nsi_tld ADD CONSTRAINT pk_eco_nsi_tld PRIMARY KEY (id);

-- Таблица: eco.rel_countries_continent_continent
CREATE TABLE eco.rel_countries_continent_continent (countries_id integer(32,0) NOT NULL, continent_id integer(32,0) NOT NULL);
CREATE UNIQUE INDEX rel_countries_continent_continent_idx ON eco.rel_countries_continent_continent USING btree (countries_id, continent_id);

-- Таблица: eco.rel_countries_currencies_currencies
CREATE TABLE eco.rel_countries_currencies_currencies (countries_id integer(32,0) NOT NULL, currencies_id integer(32,0) NOT NULL);
CREATE UNIQUE INDEX rel_countries_currencies_currencies_idx ON eco.rel_countries_currencies_currencies USING btree (countries_id, currencies_id);

-- Таблица: eco.rel_countries_languages_languages
CREATE TABLE eco.rel_countries_languages_languages (countries_id integer(32,0) NOT NULL, languages_id integer(32,0) NOT NULL);
CREATE UNIQUE INDEX rel_countries_languages_languages_idx ON eco.rel_countries_languages_languages USING btree (countries_id, languages_id);

-- Таблица: eco.rel_countries_list_countries_list_countries
CREATE TABLE eco.rel_countries_list_countries_list_countries (countries_id integer(32,0) NOT NULL, list_countries_id integer(32,0) NOT NULL);
CREATE UNIQUE INDEX rel_countries_list_countries_list_countries_idx ON eco.rel_countries_list_countries_list_countries USING btree (countries_id, list_countries_id);

-- Таблица: eco.rel_countries_tld_tld
CREATE TABLE eco.rel_countries_tld_tld (countries_id integer(32,0) NOT NULL, tld_id integer(32,0) NOT NULL);
CREATE UNIQUE INDEX rel_countries_tld_tld_idx ON eco.rel_countries_tld_tld USING btree (countries_id, tld_id);

-- Таблица: eco.rel_lists_countries_countries
CREATE TABLE eco.rel_lists_countries_countries (lists_id integer(32,0) NOT NULL, countries_id integer(32,0) NOT NULL);
CREATE UNIQUE INDEX rel_lists_countries_countries_idx ON eco.rel_lists_countries_countries USING btree (lists_id, countries_id);

-- Таблица: eco.rel_metrics_countries_chapter_countries_chapters
CREATE TABLE eco.rel_metrics_countries_chapter_countries_chapters (metrics_countries_id integer(32,0) NOT NULL, chapter_countries_id integer(32,0) NOT NULL);
CREATE UNIQUE INDEX rel_metrics_countries_chapter_countries_chapters_idx ON eco.rel_metrics_countries_chapter_countries_chapters USING btree (metrics_countries_id, chapter_countries_id);

-- Таблица: eco.table_depend
CREATE TABLE eco.table_depend (name text, rang integer(32,0), dop text);

-- Таблица: eco.temp_table_depend
CREATE TABLE eco.temp_table_depend (code_ref text, typeobj_code text);

-- Внешние ключи
ALTER TABLE eco.his_cities_ability_index ADD CONSTRAINT his_cities_ability_index_fk FOREIGN KEY (cities_id) REFERENCES eco.nsi_cities (id);
ALTER TABLE eco.his_cities_affordability_index ADD CONSTRAINT his_cities_affordability_index_fk FOREIGN KEY (cities_id) REFERENCES eco.nsi_cities (id);
ALTER TABLE eco.his_cities_area ADD CONSTRAINT his_cities_area_fk FOREIGN KEY (cities_id) REFERENCES eco.nsi_cities (id);
ALTER TABLE eco.his_cities_climate_index ADD CONSTRAINT his_cities_climate_index_fk FOREIGN KEY (cities_id) REFERENCES eco.nsi_cities (id);
ALTER TABLE eco.his_cities_cost_index ADD CONSTRAINT his_cities_cost_index_fk FOREIGN KEY (cities_id) REFERENCES eco.nsi_cities (id);
ALTER TABLE eco.his_cities_crime_index ADD CONSTRAINT his_cities_crime_index_fk FOREIGN KEY (cities_id) REFERENCES eco.nsi_cities (id);
ALTER TABLE eco.his_cities_gr_yield_cc ADD CONSTRAINT his_cities_gr_yield_cc_fk FOREIGN KEY (cities_id) REFERENCES eco.nsi_cities (id);
ALTER TABLE eco.his_cities_gr_yield_co ADD CONSTRAINT his_cities_gr_yield_co_fk FOREIGN KEY (cities_id) REFERENCES eco.nsi_cities (id);
ALTER TABLE eco.his_cities_health_index ADD CONSTRAINT his_cities_health_index_fk FOREIGN KEY (cities_id) REFERENCES eco.nsi_cities (id);
ALTER TABLE eco.his_cities_life_index ADD CONSTRAINT his_cities_life_index_fk FOREIGN KEY (cities_id) REFERENCES eco.nsi_cities (id);
ALTER TABLE eco.his_cities_meteo ADD CONSTRAINT his_cities_meteo_fk FOREIGN KEY (cities_id) REFERENCES eco.nsi_cities (id);
ALTER TABLE eco.his_cities_mortgage_per_income ADD CONSTRAINT his_cities_mortgage_per_income_fk FOREIGN KEY (cities_id) REFERENCES eco.nsi_cities (id);
ALTER TABLE eco.his_cities_pollution_index ADD CONSTRAINT his_cities_pollution_index_fk FOREIGN KEY (cities_id) REFERENCES eco.nsi_cities (id);
ALTER TABLE eco.his_cities_pops ADD CONSTRAINT his_cities_pops_fk FOREIGN KEY (cities_id) REFERENCES eco.nsi_cities (id);
ALTER TABLE eco.his_cities_pp_to_income_ratio ADD CONSTRAINT his_cities_pp_to_income_ratio_fk FOREIGN KEY (cities_id) REFERENCES eco.nsi_cities (id);
ALTER TABLE eco.his_cities_price_to_income ADD CONSTRAINT his_cities_price_to_income_fk FOREIGN KEY (cities_id) REFERENCES eco.nsi_cities (id);
ALTER TABLE eco.his_cities_price_to_rent_cc ADD CONSTRAINT his_cities_price_to_rent_cc_fk FOREIGN KEY (cities_id) REFERENCES eco.nsi_cities (id);
ALTER TABLE eco.his_cities_price_to_rent_co ADD CONSTRAINT his_cities_price_to_rent_co_fk FOREIGN KEY (cities_id) REFERENCES eco.nsi_cities (id);
ALTER TABLE eco.his_cities_safety_index ADD CONSTRAINT his_cities_safety_index_fk FOREIGN KEY (cities_id) REFERENCES eco.nsi_cities (id);
ALTER TABLE eco.his_cities_trafic_time_index ADD CONSTRAINT his_cities_trafic_time_index_fk FOREIGN KEY (cities_id) REFERENCES eco.nsi_cities (id);
ALTER TABLE eco.his_countries_ability_index ADD CONSTRAINT his_countries_ability_index_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_affordability_index ADD CONSTRAINT his_countries_affordability_index_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_ag_con_fert_pt_zs ADD CONSTRAINT his_countries_ag_con_fert_pt_zs_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_ag_lnd_arbl_ha_pc ADD CONSTRAINT his_countries_ag_lnd_arbl_ha_pc_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_ag_lnd_crel_ha ADD CONSTRAINT his_countries_ag_lnd_crel_ha_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_ag_lnd_crop_zs ADD CONSTRAINT his_countries_ag_lnd_crop_zs_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_ag_lnd_irig_ag_zs ADD CONSTRAINT his_countries_ag_lnd_irig_ag_zs_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_ag_lnd_totl_ru_k2 ADD CONSTRAINT his_countries_ag_lnd_totl_ru_k2_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_ag_lnd_trac_zs ADD CONSTRAINT his_countries_ag_lnd_trac_zs_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_agr_arable_land ADD CONSTRAINT his_countries_agr_arable_land_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_agr_arable_land_percent ADD CONSTRAINT his_countries_agr_arable_land_percent_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_agr_avr_prec_depth ADD CONSTRAINT his_countries_agr_avr_prec_depth_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_agr_cereal_production ADD CONSTRAINT his_countries_agr_cereal_production_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_agr_cereal_yield ADD CONSTRAINT his_countries_agr_cereal_yield_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_agr_employment_percent ADD CONSTRAINT his_countries_agr_employment_percent_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_agr_machinery ADD CONSTRAINT his_countries_agr_machinery_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_agr_pop_percent ADD CONSTRAINT his_countries_agr_pop_percent_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_agr_population ADD CONSTRAINT his_countries_agr_population_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_agr_square ADD CONSTRAINT his_countries_agr_square_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_agr_square_percent ADD CONSTRAINT his_countries_agr_square_percent_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_air_pass_carry ADD CONSTRAINT his_countries_air_pass_carry_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_arg_fertilizer ADD CONSTRAINT his_countries_arg_fertilizer_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_av_age ADD CONSTRAINT his_countries_av_age_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_av_age_man ADD CONSTRAINT his_countries_av_age_man_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_av_age_women ADD CONSTRAINT his_countries_av_age_women_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_av_day_of_stay ADD CONSTRAINT his_countries_av_day_of_stay_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_av_salary_net ADD CONSTRAINT his_countries_av_salary_net_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_bm_dollar_price ADD CONSTRAINT his_countries_bm_dollar_price_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_bm_gsr_mrch_cd ADD CONSTRAINT his_countries_bm_gsr_mrch_cd_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_bm_index_dollar ADD CONSTRAINT his_countries_bm_index_dollar_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_bm_klt_dinv_cd_wd ADD CONSTRAINT his_countries_bm_klt_dinv_cd_wd_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_bm_local_price ADD CONSTRAINT his_countries_bm_local_price_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_bn_klt_dinv_cd ADD CONSTRAINT his_countries_bn_klt_dinv_cd_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_bx_klt_dinv_cd_wd ADD CONSTRAINT his_countries_bx_klt_dinv_cd_wd_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_bx_klt_dinv_wd_gd_zs ADD CONSTRAINT his_countries_bx_klt_dinv_wd_gd_zs_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_cars1000 ADD CONSTRAINT his_countries_cars1000_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_cel_sets ADD CONSTRAINT his_countries_cel_sets_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_cgd_percent ADD CONSTRAINT his_countries_cgd_percent_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_climate_index ADD CONSTRAINT his_countries_climate_index_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_consumption ADD CONSTRAINT his_countries_consumption_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_corporate_tax_rate ADD CONSTRAINT his_countries_corporate_tax_rate_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_corruption_index ADD CONSTRAINT his_countries_corruption_index_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_cost_hd ADD CONSTRAINT his_countries_cost_hd_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_cost_index ADD CONSTRAINT his_countries_cost_index_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_count_tourists ADD CONSTRAINT his_countries_count_tourists_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_count_tourists_countries ADD CONSTRAINT his_countries_count_tourists_countries_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_cpi ADD CONSTRAINT his_countries_cpi_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_crime ADD CONSTRAINT his_countries_crime_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_death_rate ADD CONSTRAINT his_countries_death_rate_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_deposit_rate ADD CONSTRAINT his_countries_deposit_rate_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_eggs ADD CONSTRAINT his_countries_eggs_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_fert_coeff ADD CONSTRAINT his_countries_fert_coeff_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_fert_inf ADD CONSTRAINT his_countries_fert_inf_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_forest_square ADD CONSTRAINT his_countries_forest_square_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_forest_square_percent ADD CONSTRAINT his_countries_forest_square_percent_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_gasoline_price ADD CONSTRAINT his_countries_gasoline_price_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_gdp_agriculture ADD CONSTRAINT his_countries_gdp_agriculture_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_gdp_building ADD CONSTRAINT his_countries_gdp_building_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_gdp_export ADD CONSTRAINT his_countries_gdp_export_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_gdp_finance ADD CONSTRAINT his_countries_gdp_finance_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_gdp_growth ADD CONSTRAINT his_countries_gdp_growth_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_gdp_growth_per_percent ADD CONSTRAINT his_countries_gdp_growth_per_percent_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_gdp_import ADD CONSTRAINT his_countries_gdp_import_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_gdp_market ADD CONSTRAINT his_countries_gdp_market_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_gdp_pop ADD CONSTRAINT his_countries_gdp_pop_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_gdp_tnrr_percent ADD CONSTRAINT his_countries_gdp_tnrr_percent_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_gdpp ADD CONSTRAINT his_countries_gdpp_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_gnp_person ADD CONSTRAINT his_countries_gnp_person_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_gr_yield_cc ADD CONSTRAINT his_countries_gr_yield_cc_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_gr_yield_co ADD CONSTRAINT his_countries_gr_yield_co_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_hdi ADD CONSTRAINT his_countries_hdi_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_health_index ADD CONSTRAINT his_countries_health_index_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_home_ownership_rate ADD CONSTRAINT his_countries_home_ownership_rate_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_ibrd ADD CONSTRAINT his_countries_ibrd_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_income_tax_rate ADD CONSTRAINT his_countries_income_tax_rate_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_inet_user_per ADD CONSTRAINT his_countries_inet_user_per_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_inflation ADD CONSTRAINT his_countries_inflation_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_it_net_mln ADD CONSTRAINT his_countries_it_net_mln_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_it_net_secr ADD CONSTRAINT his_countries_it_net_secr_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_life_index ADD CONSTRAINT his_countries_life_index_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_loan_rate ADD CONSTRAINT his_countries_loan_rate_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_military_gdp_per ADD CONSTRAINT his_countries_military_gdp_per_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_military_total ADD CONSTRAINT his_countries_military_total_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_mort_rate_inf ADD CONSTRAINT his_countries_mort_rate_inf_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_mortage_per ADD CONSTRAINT his_countries_mortage_per_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_mortgage_per_income ADD CONSTRAINT his_countries_mortgage_per_income_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_png ADD CONSTRAINT his_countries_png_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_pollution_index ADD CONSTRAINT his_countries_pollution_index_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_pop_dnst ADD CONSTRAINT his_countries_pop_dnst_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_pop_man_percent ADD CONSTRAINT his_countries_pop_man_percent_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_pop_women_percent ADD CONSTRAINT his_countries_pop_women_percent_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_pops ADD CONSTRAINT his_countries_pops_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_population_change ADD CONSTRAINT his_countries_population_change_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_pp_to_income_ratio ADD CONSTRAINT his_countries_pp_to_income_ratio_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_ppg ADD CONSTRAINT his_countries_ppg_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_price_sm_acc ADD CONSTRAINT his_countries_price_sm_acc_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_price_sm_aoc ADD CONSTRAINT his_countries_price_sm_aoc_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_price_to_income ADD CONSTRAINT his_countries_price_to_income_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_price_to_rent_cc ADD CONSTRAINT his_countries_price_to_rent_cc_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_price_to_rent_co ADD CONSTRAINT his_countries_price_to_rent_co_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_rezerv ADD CONSTRAINT his_countries_rezerv_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_safety_index ADD CONSTRAINT his_countries_safety_index_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_sale_house ADD CONSTRAINT his_countries_sale_house_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_sale_house_month ADD CONSTRAINT his_countries_sale_house_month_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_sales_tax_rate ADD CONSTRAINT his_countries_sales_tax_rate_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_sh_xpd_chex_gd_zs ADD CONSTRAINT his_countries_sh_xpd_chex_gd_zs_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_sh_xpd_chex_pc_cd ADD CONSTRAINT his_countries_sh_xpd_chex_pc_cd_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_social_security_rate ADD CONSTRAINT his_countries_social_security_rate_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_social_security_rate_for_companies ADD CONSTRAINT his_countries_social_security_rate_for_companies_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_social_security_rate_for_empl ADD CONSTRAINT his_countries_social_security_rate_for_empl_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_sp_dyn_amrt_fe ADD CONSTRAINT his_countries_sp_dyn_amrt_fe_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_sp_dyn_amrt_ma ADD CONSTRAINT his_countries_sp_dyn_amrt_ma_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_sp_dyn_cbrt_in ADD CONSTRAINT his_countries_sp_dyn_cbrt_in_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_sp_dyn_conm_zs ADD CONSTRAINT his_countries_sp_dyn_conm_zs_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_sp_dyn_le00_fe_in ADD CONSTRAINT his_countries_sp_dyn_le00_fe_in_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_sp_dyn_le00_ma_in ADD CONSTRAINT his_countries_sp_dyn_le00_ma_in_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_sp_dyn_to65_fe_zs ADD CONSTRAINT his_countries_sp_dyn_to65_fe_zs_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_sp_dyn_to65_ma_zs ADD CONSTRAINT his_countries_sp_dyn_to65_ma_zs_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_sp_dyn_wfrt ADD CONSTRAINT his_countries_sp_dyn_wfrt_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_sp_pop_0014_to_zs ADD CONSTRAINT his_countries_sp_pop_0014_to_zs_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_sp_pop_1564_to_zs ADD CONSTRAINT his_countries_sp_pop_1564_to_zs_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_sp_pop_65up_to_zs ADD CONSTRAINT his_countries_sp_pop_65up_to_zs_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_taxrevenue_per ADD CONSTRAINT his_countries_taxrevenue_per_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_taxtotal_per ADD CONSTRAINT his_countries_taxtotal_per_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_total_air ADD CONSTRAINT his_countries_total_air_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_total_railway ADD CONSTRAINT his_countries_total_railway_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_total_sale_house ADD CONSTRAINT his_countries_total_sale_house_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_total_sale_house_first ADD CONSTRAINT his_countries_total_sale_house_first_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_total_sale_house_first_month ADD CONSTRAINT his_countries_total_sale_house_first_month_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_total_sale_house_month ADD CONSTRAINT his_countries_total_sale_house_month_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_total_sale_house_mortage ADD CONSTRAINT his_countries_total_sale_house_mortage_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_total_sale_house_mortage_month ADD CONSTRAINT his_countries_total_sale_house_mortage_month_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_total_sale_house_other ADD CONSTRAINT his_countries_total_sale_house_other_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_total_sale_house_other_month ADD CONSTRAINT his_countries_total_sale_house_other_month_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_total_sale_house_second ADD CONSTRAINT his_countries_total_sale_house_second_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_total_sale_house_second_month ADD CONSTRAINT his_countries_total_sale_house_second_month_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_tourism_gdp_per ADD CONSTRAINT his_countries_tourism_gdp_per_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_trafic_time_index ADD CONSTRAINT his_countries_trafic_time_index_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_unemployment ADD CONSTRAINT his_countries_unemployment_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_urb_lcty ADD CONSTRAINT his_countries_urb_lcty_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_urb_mln_procent ADD CONSTRAINT his_countries_urb_mln_procent_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_urb_total ADD CONSTRAINT his_countries_urb_total_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_urb_total_percent ADD CONSTRAINT his_countries_urb_total_percent_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_vc_ihr_psrc_p5 ADD CONSTRAINT his_countries_vc_ihr_psrc_p5_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_water ADD CONSTRAINT his_countries_water_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_countries_water15 ADD CONSTRAINT his_countries_water15_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.his_currencies_course ADD CONSTRAINT his_currencies_course_fk FOREIGN KEY (currencies_id) REFERENCES eco.nsi_currencies (id);
ALTER TABLE eco.his_emails_hist ADD CONSTRAINT his_emails_hist_fk FOREIGN KEY (emails_id) REFERENCES eco.nsi_emails (id);
ALTER TABLE eco.his_guests_page ADD CONSTRAINT his_guests_page_fk FOREIGN KEY (guests_id) REFERENCES eco.nsi_guests (id);
ALTER TABLE eco.his_provinces_area ADD CONSTRAINT his_provinces_area_fk FOREIGN KEY (provinces_id) REFERENCES eco.nsi_provinces (id);
ALTER TABLE eco.his_provinces_pops ADD CONSTRAINT his_provinces_pops_fk FOREIGN KEY (provinces_id) REFERENCES eco.nsi_provinces (id);
ALTER TABLE eco.link_cities ADD CONSTRAINT eco_link_cities_fk2 FOREIGN KEY (id) REFERENCES eco.nsi_cities (id);
ALTER TABLE eco.link_countries ADD CONSTRAINT eco_link_countries_fk2 FOREIGN KEY (id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.link_currencies ADD CONSTRAINT eco_link_currencies_fk2 FOREIGN KEY (id) REFERENCES eco.nsi_currencies (id);
ALTER TABLE eco.link_emails ADD CONSTRAINT eco_link_emails_fk2 FOREIGN KEY (id) REFERENCES eco.nsi_emails (id);
ALTER TABLE eco.link_guests ADD CONSTRAINT eco_link_guests_fk2 FOREIGN KEY (id) REFERENCES eco.nsi_guests (id);
ALTER TABLE eco.link_provinces ADD CONSTRAINT eco_link_provinces_fk2 FOREIGN KEY (id) REFERENCES eco.nsi_provinces (id);
ALTER TABLE eco.nsi_cities ADD CONSTRAINT eco_nsi_cities_fk1 FOREIGN KEY (country) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.nsi_cities ADD CONSTRAINT eco_nsi_cities_fk2 FOREIGN KEY (province) REFERENCES eco.nsi_provinces (id);
ALTER TABLE eco.nsi_countries ADD CONSTRAINT eco_nsi_countries_fk1 FOREIGN KEY (region) REFERENCES eco.nsi_continent (id);
ALTER TABLE eco.nsi_districts ADD CONSTRAINT eco_nsi_districts_fk1 FOREIGN KEY (provinces) REFERENCES eco.nsi_provinces (id);
ALTER TABLE eco.nsi_guests ADD CONSTRAINT eco_nsi_guests_fk1 FOREIGN KEY (email) REFERENCES eco.nsi_emails (id);
ALTER TABLE eco.nsi_provinces ADD CONSTRAINT eco_nsi_provinces_fk1 FOREIGN KEY (country) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.nsi_provinces ADD CONSTRAINT eco_nsi_provinces_fk3 FOREIGN KEY (region) REFERENCES eco.nsi_continent (id);
ALTER TABLE eco.rel_countries_continent_continent ADD CONSTRAINT countries_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.rel_countries_continent_continent ADD CONSTRAINT countries_fk_1 FOREIGN KEY (continent_id, currencies_id, languages_id, list_countries_id, tld_id) REFERENCES eco.nsi_continent (id);
ALTER TABLE eco.rel_countries_continent_continent ADD CONSTRAINT countries_fk_1 FOREIGN KEY (continent_id, currencies_id, languages_id, list_countries_id, tld_id) REFERENCES eco.nsi_currencies (id);
ALTER TABLE eco.rel_countries_continent_continent ADD CONSTRAINT countries_fk_1 FOREIGN KEY (continent_id, currencies_id, languages_id, list_countries_id, tld_id) REFERENCES eco.nsi_languages (id);
ALTER TABLE eco.rel_countries_continent_continent ADD CONSTRAINT countries_fk_1 FOREIGN KEY (continent_id, currencies_id, languages_id, list_countries_id, tld_id) REFERENCES eco.nsi_list_countries (id);
ALTER TABLE eco.rel_countries_continent_continent ADD CONSTRAINT countries_fk_1 FOREIGN KEY (continent_id, currencies_id, languages_id, list_countries_id, tld_id) REFERENCES eco.nsi_tld (id);
ALTER TABLE eco.rel_countries_currencies_currencies ADD CONSTRAINT countries_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.rel_countries_currencies_currencies ADD CONSTRAINT countries_fk_1 FOREIGN KEY (continent_id, currencies_id, languages_id, list_countries_id, tld_id) REFERENCES eco.nsi_continent (id);
ALTER TABLE eco.rel_countries_currencies_currencies ADD CONSTRAINT countries_fk_1 FOREIGN KEY (continent_id, currencies_id, languages_id, list_countries_id, tld_id) REFERENCES eco.nsi_currencies (id);
ALTER TABLE eco.rel_countries_currencies_currencies ADD CONSTRAINT countries_fk_1 FOREIGN KEY (continent_id, currencies_id, languages_id, list_countries_id, tld_id) REFERENCES eco.nsi_languages (id);
ALTER TABLE eco.rel_countries_currencies_currencies ADD CONSTRAINT countries_fk_1 FOREIGN KEY (continent_id, currencies_id, languages_id, list_countries_id, tld_id) REFERENCES eco.nsi_list_countries (id);
ALTER TABLE eco.rel_countries_currencies_currencies ADD CONSTRAINT countries_fk_1 FOREIGN KEY (continent_id, currencies_id, languages_id, list_countries_id, tld_id) REFERENCES eco.nsi_tld (id);
ALTER TABLE eco.rel_countries_languages_languages ADD CONSTRAINT countries_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.rel_countries_languages_languages ADD CONSTRAINT countries_fk_1 FOREIGN KEY (continent_id, currencies_id, languages_id, list_countries_id, tld_id) REFERENCES eco.nsi_continent (id);
ALTER TABLE eco.rel_countries_languages_languages ADD CONSTRAINT countries_fk_1 FOREIGN KEY (continent_id, currencies_id, languages_id, list_countries_id, tld_id) REFERENCES eco.nsi_currencies (id);
ALTER TABLE eco.rel_countries_languages_languages ADD CONSTRAINT countries_fk_1 FOREIGN KEY (continent_id, currencies_id, languages_id, list_countries_id, tld_id) REFERENCES eco.nsi_languages (id);
ALTER TABLE eco.rel_countries_languages_languages ADD CONSTRAINT countries_fk_1 FOREIGN KEY (continent_id, currencies_id, languages_id, list_countries_id, tld_id) REFERENCES eco.nsi_list_countries (id);
ALTER TABLE eco.rel_countries_languages_languages ADD CONSTRAINT countries_fk_1 FOREIGN KEY (continent_id, currencies_id, languages_id, list_countries_id, tld_id) REFERENCES eco.nsi_tld (id);
ALTER TABLE eco.rel_countries_list_countries_list_countries ADD CONSTRAINT countries_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.rel_countries_list_countries_list_countries ADD CONSTRAINT countries_fk_1 FOREIGN KEY (continent_id, currencies_id, languages_id, list_countries_id, tld_id) REFERENCES eco.nsi_continent (id);
ALTER TABLE eco.rel_countries_list_countries_list_countries ADD CONSTRAINT countries_fk_1 FOREIGN KEY (continent_id, currencies_id, languages_id, list_countries_id, tld_id) REFERENCES eco.nsi_currencies (id);
ALTER TABLE eco.rel_countries_list_countries_list_countries ADD CONSTRAINT countries_fk_1 FOREIGN KEY (continent_id, currencies_id, languages_id, list_countries_id, tld_id) REFERENCES eco.nsi_languages (id);
ALTER TABLE eco.rel_countries_list_countries_list_countries ADD CONSTRAINT countries_fk_1 FOREIGN KEY (continent_id, currencies_id, languages_id, list_countries_id, tld_id) REFERENCES eco.nsi_list_countries (id);
ALTER TABLE eco.rel_countries_list_countries_list_countries ADD CONSTRAINT countries_fk_1 FOREIGN KEY (continent_id, currencies_id, languages_id, list_countries_id, tld_id) REFERENCES eco.nsi_tld (id);
ALTER TABLE eco.rel_countries_tld_tld ADD CONSTRAINT countries_fk FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.rel_countries_tld_tld ADD CONSTRAINT countries_fk_1 FOREIGN KEY (continent_id, currencies_id, languages_id, list_countries_id, tld_id) REFERENCES eco.nsi_continent (id);
ALTER TABLE eco.rel_countries_tld_tld ADD CONSTRAINT countries_fk_1 FOREIGN KEY (continent_id, currencies_id, languages_id, list_countries_id, tld_id) REFERENCES eco.nsi_currencies (id);
ALTER TABLE eco.rel_countries_tld_tld ADD CONSTRAINT countries_fk_1 FOREIGN KEY (continent_id, currencies_id, languages_id, list_countries_id, tld_id) REFERENCES eco.nsi_languages (id);
ALTER TABLE eco.rel_countries_tld_tld ADD CONSTRAINT countries_fk_1 FOREIGN KEY (continent_id, currencies_id, languages_id, list_countries_id, tld_id) REFERENCES eco.nsi_list_countries (id);
ALTER TABLE eco.rel_countries_tld_tld ADD CONSTRAINT countries_fk_1 FOREIGN KEY (continent_id, currencies_id, languages_id, list_countries_id, tld_id) REFERENCES eco.nsi_tld (id);
ALTER TABLE eco.rel_lists_countries_countries ADD CONSTRAINT lists_fk FOREIGN KEY (lists_id) REFERENCES eco.nsi_lists (id);
ALTER TABLE eco.rel_lists_countries_countries ADD CONSTRAINT lists_fk_1 FOREIGN KEY (countries_id) REFERENCES eco.nsi_countries (id);
ALTER TABLE eco.rel_metrics_countries_chapter_countries_chapters ADD CONSTRAINT metrics_countries_fk FOREIGN KEY (metrics_countries_id) REFERENCES eco.nsi_metrics_countries (id);
ALTER TABLE eco.rel_metrics_countries_chapter_countries_chapters ADD CONSTRAINT metrics_countries_fk_1 FOREIGN KEY (chapter_countries_id) REFERENCES eco.nsi_chapter_countries (id);