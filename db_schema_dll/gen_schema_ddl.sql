-- DDL схемы gen
-- Сгенерировано: 2025-12-28 13:51:43.451044

CREATE SCHEMA IF NOT EXISTS gen;


-- Таблица: gen.his_projects_events
-- Комментарий: Историческая таблица для свойства [events] сущности [projects]
CREATE TABLE gen.his_projects_events (projects_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value text);
COMMENT ON TABLE gen.his_projects_events IS 'Историческая таблица для свойства [events] сущности [projects]';
COMMENT ON COLUMN gen.his_projects_events.projects_id IS 'Ссылка на объект сущности [projects]';
COMMENT ON COLUMN gen.his_projects_events.dt IS 'Время значения свойства [events] сущности [projects]';
COMMENT ON COLUMN gen.his_projects_events.value IS 'Значение свойства [events] сущности [projects]';
ALTER TABLE gen.his_projects_events ADD CONSTRAINT pk_gen_his_projects_events PRIMARY KEY (projects_id, dt);

-- Таблица: gen.link_projects
-- Комментарий: Таблица хранения ссылок исторических параметров сущности [projects на параметры КСВД
CREATE TABLE gen.link_projects (id integer(32,0) NOT NULL, param_id integer(32,0) NOT NULL, parameter_id character varying, equipment_id character varying, type_his USER-DEFINED, discret integer(32,0));
COMMENT ON TABLE gen.link_projects IS 'Таблица хранения ссылок исторических параметров сущности [projects на параметры КСВД';
COMMENT ON COLUMN gen.link_projects.id IS 'Ссылка на объект сущности [projects]';
COMMENT ON COLUMN gen.link_projects.param_id IS 'Ссылка на тип параметров МДМ';
COMMENT ON COLUMN gen.link_projects.parameter_id IS 'Идентификатор параметра КСВД';
COMMENT ON COLUMN gen.link_projects.equipment_id IS 'Идентификатор устройства КСВД';
COMMENT ON COLUMN gen.link_projects.type_his IS 'Тип временного ряда';
COMMENT ON COLUMN gen.link_projects.discret IS 'Дискретность информации в секундах';
ALTER TABLE gen.link_projects ADD CONSTRAINT pk_nsi_link_projects PRIMARY KEY (id, param_id);

-- Таблица: gen.nsi_cities
-- Комментарий: Города городов в странах
CREATE TABLE gen.nsi_cities (id integer(32,0) NOT NULL, sh_name character varying(50), country integer(32,0) NOT NULL, at_date date NOT NULL);
COMMENT ON TABLE gen.nsi_cities IS 'Города городов в странах';
COMMENT ON COLUMN gen.nsi_cities.id IS 'Идентификатор объекта';
COMMENT ON COLUMN gen.nsi_cities.sh_name IS 'Наименование объекта';
COMMENT ON COLUMN gen.nsi_cities.country IS 'Страна, в которой находится город';
COMMENT ON COLUMN gen.nsi_cities.at_date IS 'Дата когда город был внесен в базу данных ';
ALTER TABLE gen.nsi_cities ADD CONSTRAINT pk_gen_nsi_cities PRIMARY KEY (id);
CREATE UNIQUE INDEX nsi_cities_idx ON gen.nsi_cities USING btree (country, sh_name);

-- Таблица: gen.nsi_claims
-- Комментарий: Квитанции на оплату работ по фазам проектов
CREATE TABLE gen.nsi_claims (id integer(32,0) NOT NULL, at_date date, phase integer(32,0) NOT NULL, money real, currency USER-DEFINED, code integer(32,0), payment_method USER-DEFINED, comment text);
COMMENT ON TABLE gen.nsi_claims IS 'Квитанции на оплату работ по фазам проектов';
COMMENT ON COLUMN gen.nsi_claims.id IS 'Идентификатор объекта';
COMMENT ON COLUMN gen.nsi_claims.at_date IS 'Дата выдачи квитанции';
COMMENT ON COLUMN gen.nsi_claims.phase IS 'Фаза проекта, за работу над которой была произведена выплата вознаграждения';
COMMENT ON COLUMN gen.nsi_claims.money IS 'Величина вознаграждения';
COMMENT ON COLUMN gen.nsi_claims.currency IS 'Валюта платежа';
COMMENT ON COLUMN gen.nsi_claims.code IS 'Номер квитанции';
COMMENT ON COLUMN gen.nsi_claims.payment_method IS 'Способ получения оплаты за работу';
COMMENT ON COLUMN gen.nsi_claims.comment IS 'Комментарий к квитанции';
ALTER TABLE gen.nsi_claims ADD CONSTRAINT pk_gen_nsi_claims PRIMARY KEY (id);
CREATE INDEX idx_nsi_claims_phase ON gen.nsi_claims USING btree (phase);
CREATE UNIQUE INDEX nsi_claims_idx ON gen.nsi_claims USING btree (code);

-- Таблица: gen.nsi_clients
-- Комментарий: Список клиентов, для которых проводятся генеалогические поиски (исследования)
CREATE TABLE gen.nsi_clients (id integer(32,0) NOT NULL, sh_name character varying(50), first_name character varying(50), second_name character varying(50), whatsapp character varying(50), telegram character varying(50), phone character varying(50), email character varying(50), country integer(32,0), city integer(32,0), post character varying(250), messenger character varying(250), at_date date NOT NULL);
COMMENT ON TABLE gen.nsi_clients IS 'Список клиентов~a2~ для которых проводятся генеалогические поиски ~A~исследования~B~';
COMMENT ON COLUMN gen.nsi_clients.id IS 'Идентификатор объекта';
COMMENT ON COLUMN gen.nsi_clients.sh_name IS 'Фамилия клиента';
COMMENT ON COLUMN gen.nsi_clients.first_name IS 'Имя клиента';
COMMENT ON COLUMN gen.nsi_clients.second_name IS 'Отчество клиента';
COMMENT ON COLUMN gen.nsi_clients.whatsapp IS 'Способ связи с клиентом по WhatsApp';
COMMENT ON COLUMN gen.nsi_clients.telegram IS 'Параметры связи с клиентом по телеграму';
COMMENT ON COLUMN gen.nsi_clients.phone IS 'Телефон клиента';
COMMENT ON COLUMN gen.nsi_clients.email IS 'Адрес электронной почты клиента';
COMMENT ON COLUMN gen.nsi_clients.country IS 'Страна, в которой проживает клиент';
COMMENT ON COLUMN gen.nsi_clients.city IS 'Город, в котором проживает клиент';
COMMENT ON COLUMN gen.nsi_clients.post IS 'Почтовый адрес клиента';
COMMENT ON COLUMN gen.nsi_clients.messenger IS 'Мессенджер для связи';
COMMENT ON COLUMN gen.nsi_clients.at_date IS 'Дата заведения клиента в базу данных';
ALTER TABLE gen.nsi_clients ADD CONSTRAINT pk_gen_nsi_clients PRIMARY KEY (id);
CREATE UNIQUE INDEX nsi_clients_idx ON gen.nsi_clients USING btree (first_name, sh_name, second_name, city);

-- Таблица: gen.nsi_countries
-- Комментарий: Список стран
CREATE TABLE gen.nsi_countries (id integer(32,0) NOT NULL, sh_name character varying(50), at_date date NOT NULL);
COMMENT ON TABLE gen.nsi_countries IS 'Список стран';
COMMENT ON COLUMN gen.nsi_countries.id IS 'Идентификатор объекта';
COMMENT ON COLUMN gen.nsi_countries.sh_name IS 'Наименование объекта';
COMMENT ON COLUMN gen.nsi_countries.at_date IS 'Дата занесения страны в базу данных';
ALTER TABLE gen.nsi_countries ADD CONSTRAINT pk_gen_nsi_countries PRIMARY KEY (id);

-- Таблица: gen.nsi_documents
-- Комментарий: Список документов для законов с указанием пути доступа к ним
CREATE TABLE gen.nsi_documents (id integer(32,0) NOT NULL, sh_name character varying(250), project integer(32,0), url character varying(500));
COMMENT ON TABLE gen.nsi_documents IS 'Список документов для законов с указанием пути доступа к ним';
COMMENT ON COLUMN gen.nsi_documents.id IS 'Идентификатор документа';
COMMENT ON COLUMN gen.nsi_documents.sh_name IS 'Комментарий к документу (суть документа)';
COMMENT ON COLUMN gen.nsi_documents.project IS 'Проект, которому принадлежит документ';
COMMENT ON COLUMN gen.nsi_documents.url IS 'Путь к документу проекта';
ALTER TABLE gen.nsi_documents ADD CONSTRAINT pk_gen_nsi_documents PRIMARY KEY (id);

-- Таблица: gen.nsi_phases
-- Комментарий: Фазы работы над проектами
CREATE TABLE gen.nsi_phases (id integer(32,0) NOT NULL, sh_name character varying(250), project integer(32,0) NOT NULL, start_at date NOT NULL, finish_at date, content text);
COMMENT ON TABLE gen.nsi_phases IS 'Фазы работы над проектами';
COMMENT ON COLUMN gen.nsi_phases.id IS 'Идентификатор объекта';
COMMENT ON COLUMN gen.nsi_phases.sh_name IS 'Имя фазы проекта (для мониторинга)';
COMMENT ON COLUMN gen.nsi_phases.project IS 'Проект, которому принадлежит фаза';
COMMENT ON COLUMN gen.nsi_phases.start_at IS 'Дата начала интервала длительности фазы проекта';
COMMENT ON COLUMN gen.nsi_phases.finish_at IS 'Дата окончания интервала длительности фазы проекта';
COMMENT ON COLUMN gen.nsi_phases.content IS 'Текст, описывающий работы проведенные для фазы проекта';
ALTER TABLE gen.nsi_phases ADD CONSTRAINT pk_gen_nsi_phases PRIMARY KEY (id);
CREATE INDEX idx_nsi_phases_project ON gen.nsi_phases USING btree (project);

-- Таблица: gen.nsi_projects
-- Комментарий: Проекты поисков по договорам с клиентами
CREATE TABLE gen.nsi_projects (id integer(32,0) NOT NULL, client integer(32,0) NOT NULL, date_begin date, date_end date, result text, comment text, sh_name text NOT NULL, status integer(32,0), project_type USER-DEFINED, rating USER-DEFINED);
COMMENT ON TABLE gen.nsi_projects IS 'Проекты поисков по договорам с клиентами';
COMMENT ON COLUMN gen.nsi_projects.id IS 'Идентификатор объекта';
COMMENT ON COLUMN gen.nsi_projects.client IS 'Клиент, заказавший работу';
COMMENT ON COLUMN gen.nsi_projects.date_begin IS 'Дата начала проекта';
COMMENT ON COLUMN gen.nsi_projects.date_end IS 'Дата окончания проекта';
COMMENT ON COLUMN gen.nsi_projects.result IS 'Результат работы по проекту';
COMMENT ON COLUMN gen.nsi_projects.comment IS 'Комментарии по ходу работы над проектом';
COMMENT ON COLUMN gen.nsi_projects.sh_name IS 'Название работы';
COMMENT ON COLUMN gen.nsi_projects.status IS 'Последнее состояние проекта';
COMMENT ON COLUMN gen.nsi_projects.project_type IS 'Тип проекта (наличие оплаты)';
COMMENT ON COLUMN gen.nsi_projects.rating IS 'Оценка проекта';
ALTER TABLE gen.nsi_projects ADD CONSTRAINT pk_gen_nsi_projects PRIMARY KEY (id);
CREATE INDEX idx_nsi_projects_client ON gen.nsi_projects USING btree (client);
CREATE UNIQUE INDEX nsi_projects_idx ON gen.nsi_projects USING btree (client, sh_name);

-- Таблица: gen.nsi_projects_status
-- Комментарий: Список возможных состояний проектов
CREATE TABLE gen.nsi_projects_status (id integer(32,0) NOT NULL, sh_name character varying(50), code character varying(20));
COMMENT ON TABLE gen.nsi_projects_status IS 'Список возможных состояний проектов';
COMMENT ON COLUMN gen.nsi_projects_status.id IS 'Идентификатор объекта';
COMMENT ON COLUMN gen.nsi_projects_status.sh_name IS 'Имя состояния проекта';
COMMENT ON COLUMN gen.nsi_projects_status.code IS 'Код состояния проекта';
ALTER TABLE gen.nsi_projects_status ADD CONSTRAINT pk_gen_nsi_projects_status PRIMARY KEY (id);

-- Таблица: gen.nsi_types_asset
-- Комментарий: Типы активов (недвижимости)
CREATE TABLE gen.nsi_types_asset (id integer(32,0) NOT NULL, sh_name text, sh_name_he text);
COMMENT ON TABLE gen.nsi_types_asset IS 'Типы активов ~A~недвижимости~B~';
COMMENT ON COLUMN gen.nsi_types_asset.id IS 'Идентификатор объекта';
COMMENT ON COLUMN gen.nsi_types_asset.sh_name IS 'Название актива (недвижимость) на английском языке';
COMMENT ON COLUMN gen.nsi_types_asset.sh_name_he IS 'Имя актива на иврите';
ALTER TABLE gen.nsi_types_asset ADD CONSTRAINT pk_gen_nsi_types_asset PRIMARY KEY (id);

-- Таблица: gen.nsi_victims_assets
-- Комментарий: Список  жертв Холокоста с активами (недвижимостью)
CREATE TABLE gen.nsi_victims_assets (id integer(32,0) NOT NULL, sh_name text, city text, city_he text, country text, country_he text, asset integer(32,0), asset_number text, asset_number_he text);
COMMENT ON TABLE gen.nsi_victims_assets IS 'Список  жертв Холокоста с активами ~A~недвижимостью~B~';
COMMENT ON COLUMN gen.nsi_victims_assets.id IS 'Идентификатор объекта';
COMMENT ON COLUMN gen.nsi_victims_assets.sh_name IS 'Идентификация собственника актива (человек или организация)';
COMMENT ON COLUMN gen.nsi_victims_assets.city IS 'Город на английском, в котором собственник актива находился в последний известный раз';
COMMENT ON COLUMN gen.nsi_victims_assets.city_he IS 'Город (на иврите), в котором собственник актива находился в последний известный раз';
COMMENT ON COLUMN gen.nsi_victims_assets.country IS 'Страна на английском, в которой собственник находился в последний известный раз';
COMMENT ON COLUMN gen.nsi_victims_assets.country_he IS 'Страна на иврите, в которой собственник находился в последний известный раз';
COMMENT ON COLUMN gen.nsi_victims_assets.asset IS 'Ссылка на тип актива (недвижимости)';
COMMENT ON COLUMN gen.nsi_victims_assets.asset_number IS 'Номер актива';
COMMENT ON COLUMN gen.nsi_victims_assets.asset_number_he IS 'Номер актива на иврите';
ALTER TABLE gen.nsi_victims_assets ADD CONSTRAINT pk_gen_nsi_victims_assets PRIMARY KEY (id);

-- Таблица: gen.table_depend
CREATE TABLE gen.table_depend (name text, rang integer(32,0), dop text);

-- Таблица: gen.temp_table_depend
CREATE TABLE gen.temp_table_depend (code_ref text, typeobj_code text);

-- Внешние ключи
ALTER TABLE gen.his_projects_events ADD CONSTRAINT his_projects_events_fk FOREIGN KEY (projects_id) REFERENCES gen.nsi_projects (id);
ALTER TABLE gen.link_projects ADD CONSTRAINT gen_link_projects_fk2 FOREIGN KEY (id) REFERENCES gen.nsi_projects (id);
ALTER TABLE gen.nsi_cities ADD CONSTRAINT gen_nsi_cities_fk1 FOREIGN KEY (country) REFERENCES gen.nsi_countries (id);
ALTER TABLE gen.nsi_claims ADD CONSTRAINT gen_nsi_claims_fk1 FOREIGN KEY (phase) REFERENCES gen.nsi_phases (id);
ALTER TABLE gen.nsi_clients ADD CONSTRAINT gen_nsi_clients_fk1 FOREIGN KEY (country) REFERENCES gen.nsi_countries (id);
ALTER TABLE gen.nsi_clients ADD CONSTRAINT gen_nsi_clients_fk2 FOREIGN KEY (city) REFERENCES gen.nsi_cities (id);
ALTER TABLE gen.nsi_documents ADD CONSTRAINT gen_nsi_documents_fk1 FOREIGN KEY (project) REFERENCES gen.nsi_projects (id);
ALTER TABLE gen.nsi_phases ADD CONSTRAINT gen_nsi_phases_fk1 FOREIGN KEY (project) REFERENCES gen.nsi_projects (id);
ALTER TABLE gen.nsi_projects ADD CONSTRAINT gen_nsi_projects_fk1 FOREIGN KEY (client) REFERENCES gen.nsi_clients (id);
ALTER TABLE gen.nsi_projects ADD CONSTRAINT gen_nsi_projects_fk2 FOREIGN KEY (status) REFERENCES gen.nsi_projects_status (id);
ALTER TABLE gen.nsi_victims_assets ADD CONSTRAINT gen_nsi_victims_assets_fk1 FOREIGN KEY (asset) REFERENCES gen.nsi_types_asset (id);