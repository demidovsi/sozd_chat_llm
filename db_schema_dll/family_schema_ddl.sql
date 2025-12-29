-- DDL схемы family
-- Сгенерировано: 2025-12-26 13:39:20.177140

CREATE SCHEMA IF NOT EXISTS family;


-- Таблица: family.assets_debt
CREATE TABLE family.assets_debt (assets_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, comment text, delta real, id integer(32,0) NOT NULL);
ALTER TABLE family.assets_debt ADD CONSTRAINT pk_family_assets_debt PRIMARY KEY (id);
CREATE INDEX assets_debt_assets_id_idx ON family.assets_debt USING btree (assets_id);

-- Таблица: family.assets_income
CREATE TABLE family.assets_income (assets_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, comment text, delta real, id integer(32,0) NOT NULL);
ALTER TABLE family.assets_income ADD CONSTRAINT pk_family_assets_income PRIMARY KEY (id);
CREATE INDEX assets_income_assets_id_idx ON family.assets_income USING btree (assets_id);

-- Таблица: family.assets_percent
CREATE TABLE family.assets_percent (assets_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, comment text, delta real, id integer(32,0) NOT NULL);
ALTER TABLE family.assets_percent ADD CONSTRAINT pk_family_assets_percent PRIMARY KEY (id);
CREATE INDEX assets_percent_assets_id_idx ON family.assets_percent USING btree (assets_id);

-- Таблица: family.his_assets
-- Комментарий: Историческая таблица суммарных активов за сутки в разных валютах
CREATE TABLE family.his_assets (id integer(32,0) NOT NULL, dt date NOT NULL, ils real, usd real, rub real, in_ils real, in_usd real, in_rub real);
COMMENT ON TABLE family.his_assets IS 'Историческая таблица суммарных активов за сутки в разных валютах';
COMMENT ON COLUMN family.his_assets.id IS 'идентификатор записи';
COMMENT ON COLUMN family.his_assets.dt IS 'дата информации по активам';
COMMENT ON COLUMN family.his_assets.ils IS 'суммарный актив в шекелях';
COMMENT ON COLUMN family.his_assets.usd IS 'суммарный актив в долларах';
COMMENT ON COLUMN family.his_assets.rub IS 'суммарный актив в рублях';
COMMENT ON COLUMN family.his_assets.in_ils IS 'Деньги в шекелях';
COMMENT ON COLUMN family.his_assets.in_usd IS 'Деньги в долларах';
COMMENT ON COLUMN family.his_assets.in_rub IS 'Деньги в рублях';
ALTER TABLE family.his_assets ADD CONSTRAINT his_assets_pk PRIMARY KEY (id);
CREATE UNIQUE INDEX his_assets_dt_idx ON family.his_assets USING btree (dt);

-- Таблица: family.his_human_comment
-- Комментарий: Историческая таблица для свойства [comment] сущности [human]
CREATE TABLE family.his_human_comment (human_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value text);
COMMENT ON TABLE family.his_human_comment IS 'Историческая таблица для свойства [comment] сущности [human]';
COMMENT ON COLUMN family.his_human_comment.human_id IS 'Ссылка на объект сущности [human]';
COMMENT ON COLUMN family.his_human_comment.dt IS 'Время значения свойства [comment] сущности [human]';
COMMENT ON COLUMN family.his_human_comment.value IS 'Значение свойства [comment] сущности [human]';
ALTER TABLE family.his_human_comment ADD CONSTRAINT pk_family_his_human_comment PRIMARY KEY (human_id, dt);

-- Таблица: family.his_human_sugar_after
-- Комментарий: Историческая таблица для свойства [sugar_after] сущности [human]
CREATE TABLE family.his_human_sugar_after (human_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value integer(32,0));
COMMENT ON TABLE family.his_human_sugar_after IS 'Историческая таблица для свойства [sugar_after] сущности [human]';
COMMENT ON COLUMN family.his_human_sugar_after.human_id IS 'Ссылка на объект сущности [human]';
COMMENT ON COLUMN family.his_human_sugar_after.dt IS 'Время значения свойства [sugar_after] сущности [human]';
COMMENT ON COLUMN family.his_human_sugar_after.value IS 'Значение свойства [sugar_after] сущности [human]';
ALTER TABLE family.his_human_sugar_after ADD CONSTRAINT pk_family_his_human_sugar_after PRIMARY KEY (human_id, dt);

-- Таблица: family.his_human_sugar_morning
-- Комментарий: Историческая таблица для свойства [sugar_moring] сущности [human]
CREATE TABLE family.his_human_sugar_morning (human_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value integer(32,0));
COMMENT ON TABLE family.his_human_sugar_morning IS 'Историческая таблица для свойства [sugar_moring] сущности [human]';
COMMENT ON COLUMN family.his_human_sugar_morning.human_id IS 'Ссылка на объект сущности [human]';
COMMENT ON COLUMN family.his_human_sugar_morning.dt IS 'Время значения свойства [sugar_moring] сущности [human]';
COMMENT ON COLUMN family.his_human_sugar_morning.value IS 'Значение свойства [sugar_moring] сущности [human]';
ALTER TABLE family.his_human_sugar_morning ADD CONSTRAINT pk_family_his_human_sugar_morning PRIMARY KEY (human_id, dt);

-- Таблица: family.his_human_weight
-- Комментарий: Историческая таблица для свойства [weight] сущности [human]
CREATE TABLE family.his_human_weight (human_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value real);
COMMENT ON TABLE family.his_human_weight IS 'Историческая таблица для свойства [weight] сущности [human]';
COMMENT ON COLUMN family.his_human_weight.human_id IS 'Ссылка на объект сущности [human]';
COMMENT ON COLUMN family.his_human_weight.dt IS 'Время значения свойства [weight] сущности [human]';
COMMENT ON COLUMN family.his_human_weight.value IS 'Значение свойства [weight] сущности [human]';
ALTER TABLE family.his_human_weight ADD CONSTRAINT pk_family_his_human_weight PRIMARY KEY (human_id, dt);

-- Таблица: family.link_human
-- Комментарий: Таблица хранения ссылок исторических параметров сущности [human на параметры КСВД
CREATE TABLE family.link_human (id integer(32,0) NOT NULL, param_id integer(32,0) NOT NULL, parameter_id character varying, equipment_id character varying, type_his USER-DEFINED, discret integer(32,0));
COMMENT ON TABLE family.link_human IS 'Таблица хранения ссылок исторических параметров сущности [human на параметры КСВД';
COMMENT ON COLUMN family.link_human.id IS 'Ссылка на объект сущности [human]';
COMMENT ON COLUMN family.link_human.param_id IS 'Ссылка на тип параметров МДМ';
COMMENT ON COLUMN family.link_human.parameter_id IS 'Идентификатор параметра КСВД';
COMMENT ON COLUMN family.link_human.equipment_id IS 'Идентификатор устройства КСВД';
COMMENT ON COLUMN family.link_human.type_his IS 'Тип временного ряда';
COMMENT ON COLUMN family.link_human.discret IS 'Дискретность информации в секундах';
ALTER TABLE family.link_human ADD CONSTRAINT pk_nsi_link_human PRIMARY KEY (id, param_id);

-- Таблица: family.logs
CREATE TABLE family.logs (id integer(32,0) NOT NULL, at_date_time timestamp without time zone, level character varying, source character varying, td real, comment character varying, for_delete boolean, page integer(32,0), law_id text, file_name character varying);
COMMENT ON COLUMN family.logs.for_delete IS 'Признак удаления старых записей';
ALTER TABLE family.logs ADD CONSTRAINT pk_public_logs PRIMARY KEY (id);
CREATE INDEX logs_family_at_date_time_idx ON family.logs USING btree (at_date_time);

-- Таблица: family.need_calc_assets
-- Комментарий: Список дат, за которые необходимо пересчитать активы
CREATE TABLE family.need_calc_assets (id integer(32,0) NOT NULL, date date NOT NULL, at_datetime timestamp without time zone);
COMMENT ON TABLE family.need_calc_assets IS 'Список дат, за которые необходимо пересчитать активы';
COMMENT ON COLUMN family.need_calc_assets.id IS 'Идентификатор записи';
COMMENT ON COLUMN family.need_calc_assets.date IS 'Дата корректировки активов';
COMMENT ON COLUMN family.need_calc_assets.at_datetime IS 'Время занесения строки в таблицу';
ALTER TABLE family.need_calc_assets ADD CONSTRAINT need_calc_assets_pk PRIMARY KEY (id);

-- Таблица: family.nsi_assets
-- Комментарий: Активы и пассивы
CREATE TABLE family.nsi_assets (id integer(32,0) NOT NULL, sh_name character varying(250), owner character varying(50), url text, currency character varying(3), source character varying(250), connection text, comment text, _delete boolean, login text, password text, numer integer(32,0));
COMMENT ON TABLE family.nsi_assets IS 'Активы и пассивы';
COMMENT ON COLUMN family.nsi_assets.id IS 'Идентификатор актива';
COMMENT ON COLUMN family.nsi_assets.sh_name IS 'Наименование актива';
COMMENT ON COLUMN family.nsi_assets.owner IS 'Владелец актива ';
COMMENT ON COLUMN family.nsi_assets.url IS 'Полный путь для доступа к веб сайту актива';
COMMENT ON COLUMN family.nsi_assets.currency IS 'Код валюты актива';
COMMENT ON COLUMN family.nsi_assets.source IS 'Источник актива ~A~банк~a2~ страховая компания и т.п.~B~';
COMMENT ON COLUMN family.nsi_assets.connection IS 'Данные для подключения';
COMMENT ON COLUMN family.nsi_assets.comment IS 'Комментарий к активу';
COMMENT ON COLUMN family.nsi_assets._delete IS 'Признак удаления объекта';
COMMENT ON COLUMN family.nsi_assets.login IS 'Логин для входа в базу актива';
COMMENT ON COLUMN family.nsi_assets.password IS 'Пароль к логину';
COMMENT ON COLUMN family.nsi_assets.numer IS 'Номер в сортировке для формирования combobox';
ALTER TABLE family.nsi_assets ADD CONSTRAINT pk_family_nsi_assets PRIMARY KEY (id);

-- Таблица: family.nsi_categor
CREATE TABLE family.nsi_categor (id integer(32,0) NOT NULL, sh_name character varying(50), _delete boolean, income boolean);
COMMENT ON COLUMN family.nsi_categor.id IS 'Object ID';
COMMENT ON COLUMN family.nsi_categor.sh_name IS 'Name of the object';
COMMENT ON COLUMN family.nsi_categor._delete IS 'Flag for deleting an object';
COMMENT ON COLUMN family.nsi_categor.income IS 'Признак того, что строка относится к доходам';
ALTER TABLE family.nsi_categor ADD CONSTRAINT pk_family_nsi_categor PRIMARY KEY (id);

-- Таблица: family.nsi_events
-- Комментарий: Дневник для фиксации  значимых событий
CREATE TABLE family.nsi_events (id integer(32,0) NOT NULL, date_begin date, date_end date, content text, words text);
COMMENT ON TABLE family.nsi_events IS 'Дневник для фиксации  значимых событий';
COMMENT ON COLUMN family.nsi_events.id IS 'Идентификатор события';
COMMENT ON COLUMN family.nsi_events.date_begin IS 'Дата начала события';
COMMENT ON COLUMN family.nsi_events.date_end IS 'Дата окончания события~a2~ если оно длилось несколько дней';
COMMENT ON COLUMN family.nsi_events.content IS 'Текст события';
ALTER TABLE family.nsi_events ADD CONSTRAINT pk_family_nsi_events PRIMARY KEY (id);

-- Таблица: family.nsi_functions
-- Комментарий: Список сервисов~a2~ которые работают на отдельном сервере
CREATE TABLE family.nsi_functions (id integer(32,0) NOT NULL, sh_name character varying(50), description text);
COMMENT ON TABLE family.nsi_functions IS 'Список сервисов~a2~ которые работают на отдельном сервере';
COMMENT ON COLUMN family.nsi_functions.id IS 'Идентификатор объекта';
COMMENT ON COLUMN family.nsi_functions.sh_name IS 'Код функции ~A~сервиса~B~';
COMMENT ON COLUMN family.nsi_functions.description IS 'Текст~a2~ описывающий назначение функции сервиса';
ALTER TABLE family.nsi_functions ADD CONSTRAINT pk_family_nsi_functions PRIMARY KEY (id);

-- Таблица: family.nsi_functions_params
-- Комментарий: Список настроечных параметров для  сервисов
CREATE TABLE family.nsi_functions_params (id integer(32,0) NOT NULL, sh_name character varying(50), code text, value text, function integer(32,0), is_number boolean, comp text);
COMMENT ON TABLE family.nsi_functions_params IS 'Список настроечных параметров для  сервисов';
COMMENT ON COLUMN family.nsi_functions_params.id IS 'Идентификатор объекта';
COMMENT ON COLUMN family.nsi_functions_params.sh_name IS 'Наименование объекта';
COMMENT ON COLUMN family.nsi_functions_params.code IS 'Код параметра для функций сервисов';
COMMENT ON COLUMN family.nsi_functions_params.value IS 'Значение параметра';
COMMENT ON COLUMN family.nsi_functions_params.function IS 'Ссылка на сервис~a2~ для котороuj задается параметр';
COMMENT ON COLUMN family.nsi_functions_params.is_number IS 'Содержимое параметра является числом или строкой~a6~ True - число~a2~ иначе - строка';
COMMENT ON COLUMN family.nsi_functions_params.comp IS 'Дополнительный параметр ~R~~LF~~A~в основном для записи информации в самом сервисе~B~';
ALTER TABLE family.nsi_functions_params ADD CONSTRAINT pk_family_nsi_functions_params PRIMARY KEY (id);

-- Таблица: family.nsi_group
CREATE TABLE family.nsi_group (id integer(32,0) NOT NULL, sh_name character varying(50), _delete boolean);
COMMENT ON COLUMN family.nsi_group.id IS 'Object ID';
COMMENT ON COLUMN family.nsi_group.sh_name IS 'Name of the object';
COMMENT ON COLUMN family.nsi_group._delete IS 'Flag for deleting an object';
ALTER TABLE family.nsi_group ADD CONSTRAINT pk_family_nsi_group PRIMARY KEY (id);

-- Таблица: family.nsi_human
CREATE TABLE family.nsi_human (id integer(32,0) NOT NULL, sh_name character varying(50), family character varying(50), name2 character varying(50));
COMMENT ON COLUMN family.nsi_human.id IS 'Идентификатор объекта';
COMMENT ON COLUMN family.nsi_human.sh_name IS 'Имя человека';
COMMENT ON COLUMN family.nsi_human.family IS 'Фамилия человека';
COMMENT ON COLUMN family.nsi_human.name2 IS 'Отчество человека';
ALTER TABLE family.nsi_human ADD CONSTRAINT pk_family_nsi_human PRIMARY KEY (id);

-- Таблица: family.nsi_rashod
-- Комментарий: Расходы и доходы семьи
CREATE TABLE family.nsi_rashod (id integer(32,0) NOT NULL, dt timestamp without time zone, _delete boolean, cat_id integer(32,0), money real, comment character varying(200), group_id integer(32,0), income real, currency character varying(3), asset integer(32,0), asset_id integer(32,0), fantom boolean);
COMMENT ON TABLE family.nsi_rashod IS 'Расходы и доходы семьи';
COMMENT ON COLUMN family.nsi_rashod.id IS 'Object ID';
COMMENT ON COLUMN family.nsi_rashod._delete IS 'Flag for deleting an object';
COMMENT ON COLUMN family.nsi_rashod.group_id IS 'Группа расходов';
COMMENT ON COLUMN family.nsi_rashod.currency IS 'Код валюты~a2~ в которой производилась операция';
COMMENT ON COLUMN family.nsi_rashod.asset IS 'Актив~a2~ которого касается расход или доход';
COMMENT ON COLUMN family.nsi_rashod.asset_id IS 'Идентификатор строки в истории актива';
COMMENT ON COLUMN family.nsi_rashod.fantom IS 'Признак не учета расхода~b1~дохода в суммарных величинах';
ALTER TABLE family.nsi_rashod ADD CONSTRAINT pk_family_nsi_rashod PRIMARY KEY (id);

-- Таблица: family.table_depend
CREATE TABLE family.table_depend (name text, rang integer(32,0), dop text);

-- Таблица: family.temp_table_depend
CREATE TABLE family.temp_table_depend (code_ref text, typeobj_code text);

-- Внешние ключи
ALTER TABLE family.his_human_comment ADD CONSTRAINT his_human_comment_fk FOREIGN KEY (human_id) REFERENCES family.nsi_human (id);
ALTER TABLE family.his_human_sugar_after ADD CONSTRAINT his_human_sugar_after_fk FOREIGN KEY (human_id) REFERENCES family.nsi_human (id);
ALTER TABLE family.his_human_sugar_morning ADD CONSTRAINT his_human_sugar_morning_fk FOREIGN KEY (human_id) REFERENCES family.nsi_human (id);
ALTER TABLE family.his_human_weight ADD CONSTRAINT his_human_weight_fk FOREIGN KEY (human_id) REFERENCES family.nsi_human (id);
ALTER TABLE family.link_human ADD CONSTRAINT family_link_human_fk2 FOREIGN KEY (id) REFERENCES family.nsi_human (id);
ALTER TABLE family.nsi_functions_params ADD CONSTRAINT family_nsi_functions_params_fk1 FOREIGN KEY (function) REFERENCES family.nsi_functions (id);
ALTER TABLE family.nsi_rashod ADD CONSTRAINT family_nsi_rashod_fk1 FOREIGN KEY (cat_id) REFERENCES family.nsi_categor (id);
ALTER TABLE family.nsi_rashod ADD CONSTRAINT family_nsi_rashod_fk2 FOREIGN KEY (group_id) REFERENCES family.nsi_group (id);
ALTER TABLE family.nsi_rashod ADD CONSTRAINT family_nsi_rashod_fk3 FOREIGN KEY (asset) REFERENCES family.nsi_assets (id);