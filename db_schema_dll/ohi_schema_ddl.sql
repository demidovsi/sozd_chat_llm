-- DDL схемы ohi
-- Сгенерировано: 2025-12-28 20:46:02.614392

CREATE SCHEMA IF NOT EXISTS ohi;


-- Таблица: ohi.his_biographies_stages
-- Комментарий: Историческая таблица для свойства [stages] сущности [biographies]
CREATE TABLE ohi.his_biographies_stages (biographies_id integer(32,0) NOT NULL, dt date NOT NULL, dt_end date, value text);
COMMENT ON TABLE ohi.his_biographies_stages IS 'Историческая таблица для свойства [stages] сущности [biographies]';
COMMENT ON COLUMN ohi.his_biographies_stages.biographies_id IS 'Ссылка на объект сущности [biographies]';
COMMENT ON COLUMN ohi.his_biographies_stages.dt IS 'Время значения свойства [stages] сущности [biographies]';
COMMENT ON COLUMN ohi.his_biographies_stages.value IS 'Значение свойства [stages] сущности [biographies]';
ALTER TABLE ohi.his_biographies_stages ADD CONSTRAINT pk_ohi_his_biographies_stages PRIMARY KEY (biographies_id, dt);

-- Таблица: ohi.his_guests_page
CREATE TABLE ohi.his_guests_page (guests_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value character varying);
ALTER TABLE ohi.his_guests_page ADD CONSTRAINT pk_ohi_his_guests_page PRIMARY KEY (guests_id, dt);

-- Таблица: ohi.link_biographies
-- Комментарий: Таблица хранения ссылок исторических параметров сущности [biographies на параметры КСВД
CREATE TABLE ohi.link_biographies (id integer(32,0) NOT NULL, param_id integer(32,0) NOT NULL, parameter_id character varying, equipment_id character varying, type_his USER-DEFINED, discret integer(32,0));
COMMENT ON TABLE ohi.link_biographies IS 'Таблица хранения ссылок исторических параметров сущности [biographies на параметры КСВД';
COMMENT ON COLUMN ohi.link_biographies.id IS 'Ссылка на объект сущности [biographies]';
COMMENT ON COLUMN ohi.link_biographies.param_id IS 'Ссылка на тип параметров МДМ';
COMMENT ON COLUMN ohi.link_biographies.parameter_id IS 'Идентификатор параметра КСВД';
COMMENT ON COLUMN ohi.link_biographies.equipment_id IS 'Идентификатор устройства КСВД';
COMMENT ON COLUMN ohi.link_biographies.type_his IS 'Тип временного ряда';
COMMENT ON COLUMN ohi.link_biographies.discret IS 'Дискретность информации в секундах';
ALTER TABLE ohi.link_biographies ADD CONSTRAINT pk_nsi_link_biographies PRIMARY KEY (id, param_id);

-- Таблица: ohi.link_guests
-- Комментарий: Таблица хранения ссылок исторических параметров сущности [guests на параметры КСВД
CREATE TABLE ohi.link_guests (id integer(32,0) NOT NULL, param_id integer(32,0) NOT NULL, parameter_id character varying, equipment_id character varying, type_his USER-DEFINED, discret integer(32,0));
COMMENT ON TABLE ohi.link_guests IS 'Таблица хранения ссылок исторических параметров сущности [guests на параметры КСВД';
COMMENT ON COLUMN ohi.link_guests.id IS 'Ссылка на объект сущности [guests]';
COMMENT ON COLUMN ohi.link_guests.param_id IS 'Ссылка на тип параметров МДМ';
COMMENT ON COLUMN ohi.link_guests.parameter_id IS 'Идентификатор параметра КСВД';
COMMENT ON COLUMN ohi.link_guests.equipment_id IS 'Идентификатор устройства КСВД';
COMMENT ON COLUMN ohi.link_guests.type_his IS 'Тип временного ряда';
COMMENT ON COLUMN ohi.link_guests.discret IS 'Дискретность информации в секундах';
ALTER TABLE ohi.link_guests ADD CONSTRAINT pk_nsi_link_guests PRIMARY KEY (id, param_id);

-- Таблица: ohi.logs
CREATE TABLE ohi.logs (id integer(32,0) NOT NULL, at_date_time timestamp without time zone, level character varying, source character varying, td real, page integer(32,0), law_id character varying, file_name character varying, comment character varying);
ALTER TABLE ohi.logs ADD CONSTRAINT pk_sozd_logs PRIMARY KEY (id);

-- Таблица: ohi.nsi_biographies
-- Комментарий: Биографии политических деятелей
CREATE TABLE ohi.nsi_biographies (id integer(32,0) NOT NULL, sh_name character varying(50), _delete boolean, txt text, person integer(32,0));
COMMENT ON TABLE ohi.nsi_biographies IS 'Биографии политических деятелей';
COMMENT ON COLUMN ohi.nsi_biographies.id IS 'Идентификатор объекта';
COMMENT ON COLUMN ohi.nsi_biographies.sh_name IS 'Наименование объекта';
COMMENT ON COLUMN ohi.nsi_biographies._delete IS 'Признак удаления объекта';
COMMENT ON COLUMN ohi.nsi_biographies.txt IS 'Текст биографии';
COMMENT ON COLUMN ohi.nsi_biographies.person IS 'Собственник биографии';
ALTER TABLE ohi.nsi_biographies ADD CONSTRAINT pk_ohi_nsi_biographies PRIMARY KEY (id);

-- Таблица: ohi.nsi_functions_params
-- Комментарий: Список настроечных параметров для функций сервиса парсинга
CREATE TABLE ohi.nsi_functions_params (id integer(32,0) NOT NULL, sh_name text, code text, value text, function integer(32,0), is_number boolean, _delete boolean);
COMMENT ON TABLE ohi.nsi_functions_params IS 'Список настроечных параметров для функций сервиса парсинга';
COMMENT ON COLUMN ohi.nsi_functions_params.id IS 'Идентификатор объекта';
COMMENT ON COLUMN ohi.nsi_functions_params.sh_name IS 'Наименование объекта';
COMMENT ON COLUMN ohi.nsi_functions_params.code IS 'Код параметра для функции парсинга (используется в парсинге)';
COMMENT ON COLUMN ohi.nsi_functions_params.value IS 'Значение параметра';
COMMENT ON COLUMN ohi.nsi_functions_params.function IS 'Ссылка на функцию сервиса парсинга, для которой задается параметр';
COMMENT ON COLUMN ohi.nsi_functions_params.is_number IS 'Содержимое параметра является числом или строкой: True - число, иначе - строка';
COMMENT ON COLUMN ohi.nsi_functions_params._delete IS 'Flag for deleting an object';
ALTER TABLE ohi.nsi_functions_params ADD CONSTRAINT pk_ohi_nsi_functions_params PRIMARY KEY (id);

-- Таблица: ohi.nsi_guests
-- Комментарий: Список IP адресов, посещяющих сайт sozd
CREATE TABLE ohi.nsi_guests (id integer(32,0) NOT NULL, sh_name character varying(50), country character varying(50), city character varying(50));
COMMENT ON TABLE ohi.nsi_guests IS 'Список IP адресов, посещяющих сайт sozd';
COMMENT ON COLUMN ohi.nsi_guests.id IS 'Идентификатор объекта';
COMMENT ON COLUMN ohi.nsi_guests.sh_name IS 'IP посетителя';
COMMENT ON COLUMN ohi.nsi_guests.country IS 'Наименование страны IP';
COMMENT ON COLUMN ohi.nsi_guests.city IS 'Название города IP';
ALTER TABLE ohi.nsi_guests ADD CONSTRAINT pk_ohi_nsi_guests PRIMARY KEY (id);
CREATE UNIQUE INDEX nsi_guests_idx ON ohi.nsi_guests USING btree (sh_name);

-- Таблица: ohi.nsi_log_rss_history
-- Комментарий: Лог новостей от RSS
CREATE TABLE ohi.nsi_log_rss_history (id integer(32,0) NOT NULL, sh_name character varying(50), url text, public_date timestamp without time zone);
COMMENT ON TABLE ohi.nsi_log_rss_history IS 'Лог новостей от RSS';
COMMENT ON COLUMN ohi.nsi_log_rss_history.id IS 'Идентификатор объекта';
COMMENT ON COLUMN ohi.nsi_log_rss_history.sh_name IS 'Наименование объекта';
COMMENT ON COLUMN ohi.nsi_log_rss_history.url IS 'URL новости на сайте';
COMMENT ON COLUMN ohi.nsi_log_rss_history.public_date IS 'Дата публикации';
ALTER TABLE ohi.nsi_log_rss_history ADD CONSTRAINT pk_ohi_nsi_log_rss_history PRIMARY KEY (id);
CREATE UNIQUE INDEX nsi_log_rss_history_idx ON ohi.nsi_log_rss_history USING btree (url);

-- Таблица: ohi.nsi_parser_functions
-- Комментарий: Список сервисов парсинга
CREATE TABLE ohi.nsi_parser_functions (id integer(32,0) NOT NULL, sh_name character varying(50), description text, _delete boolean);
COMMENT ON TABLE ohi.nsi_parser_functions IS 'Список сервисов парсинга';
COMMENT ON COLUMN ohi.nsi_parser_functions.id IS 'Идентификатор объекта';
COMMENT ON COLUMN ohi.nsi_parser_functions.sh_name IS 'Имя функции сервиса парсинга';
COMMENT ON COLUMN ohi.nsi_parser_functions.description IS 'Текст, описывающий назначение функции сервиса парсинга информации из ГД РФ';
COMMENT ON COLUMN ohi.nsi_parser_functions._delete IS 'Flag for deleting an object';
ALTER TABLE ohi.nsi_parser_functions ADD CONSTRAINT pk_ohi_nsi_parser_functions PRIMARY KEY (id);
CREATE UNIQUE INDEX nsi_parser_functions_idx ON ohi.nsi_parser_functions USING btree (sh_name);

-- Таблица: ohi.nsi_persons
-- Комментарий: Политические деятели
CREATE TABLE ohi.nsi_persons (id integer(32,0) NOT NULL, sh_name character varying(50), first_name character varying(20), second_name character varying(20), birth_date date, _delete boolean);
COMMENT ON TABLE ohi.nsi_persons IS 'Политические деятели';
COMMENT ON COLUMN ohi.nsi_persons.id IS 'Идентификатор объекта';
COMMENT ON COLUMN ohi.nsi_persons.sh_name IS 'Фамилия политического деятеля';
COMMENT ON COLUMN ohi.nsi_persons.first_name IS 'Имя политического деятеля';
COMMENT ON COLUMN ohi.nsi_persons.second_name IS 'Отчество политического деятеля';
COMMENT ON COLUMN ohi.nsi_persons.birth_date IS 'Дата рождения политического деятеля';
COMMENT ON COLUMN ohi.nsi_persons._delete IS 'Признак удаления объекта';
ALTER TABLE ohi.nsi_persons ADD CONSTRAINT pk_ohi_nsi_persons PRIMARY KEY (id);

-- Таблица: ohi.nsi_rss_history
-- Комментарий: Историческое хранилище  лент новостей, в которых есть заданные темы поиска
CREATE TABLE ohi.nsi_rss_history (id integer(32,0) NOT NULL, public_date timestamp without time zone, url text, title_ru text, description_ru text, author character varying(50), title_en text, description_en text, title_he text, description_he text, rss integer(32,0), at_date_time timestamp without time zone, file integer(32,0), error_translator boolean, lang character varying(4), meta_img text);
COMMENT ON TABLE ohi.nsi_rss_history IS 'Историческое хранилище  лент новостей~a2~ в которых есть заданные темы поиска';
COMMENT ON COLUMN ohi.nsi_rss_history.id IS 'Идентификатор объекта';
COMMENT ON COLUMN ohi.nsi_rss_history.public_date IS 'Дата и время публичного появления новости';
COMMENT ON COLUMN ohi.nsi_rss_history.url IS 'Ссылка на страницу сайта с более подробной информацией по новости';
COMMENT ON COLUMN ohi.nsi_rss_history.title_ru IS 'Заголовок новости (тэг title в xml новости) на русском языке';
COMMENT ON COLUMN ohi.nsi_rss_history.description_ru IS 'Текстовое описание новости на русском языке';
COMMENT ON COLUMN ohi.nsi_rss_history.author IS 'Источник новости';
COMMENT ON COLUMN ohi.nsi_rss_history.title_en IS 'Заголовок новости (тэг title в xml новости) на английском языке';
COMMENT ON COLUMN ohi.nsi_rss_history.description_en IS 'Текст описания новости на английском';
COMMENT ON COLUMN ohi.nsi_rss_history.title_he IS 'Заголовок новости (тэг title в xml новости) на иврите';
COMMENT ON COLUMN ohi.nsi_rss_history.description_he IS 'Текстовое описание новости на иврите';
COMMENT ON COLUMN ohi.nsi_rss_history.rss IS 'Лента новостей, с которой получена новость';
COMMENT ON COLUMN ohi.nsi_rss_history.at_date_time IS 'Время поступления записи в БД';
COMMENT ON COLUMN ohi.nsi_rss_history.file IS 'Длина полного текста в облаке (на языке сайта)';
COMMENT ON COLUMN ohi.nsi_rss_history.error_translator IS 'Признак наличия ошибки трансляции (текст останется на языке сайта)';
COMMENT ON COLUMN ohi.nsi_rss_history.lang IS 'Код языка, на котором выпускаются новости сайта';
COMMENT ON COLUMN ohi.nsi_rss_history.meta_img IS 'Ссылка на картинку к новости';
ALTER TABLE ohi.nsi_rss_history ADD CONSTRAINT pk_ohi_nsi_rss_history PRIMARY KEY (id);

-- Таблица: ohi.nsi_rss_list
-- Комментарий: Описание новостных лент RSS
CREATE TABLE ohi.nsi_rss_list (id integer(32,0) NOT NULL, sh_name character varying(50), url character varying(250), lang USER-DEFINED, description text, type_rss character varying(32), stop boolean, type_article text);
COMMENT ON TABLE ohi.nsi_rss_list IS 'Описание новостных лент RSS';
COMMENT ON COLUMN ohi.nsi_rss_list.id IS 'Идентификатор объекта';
COMMENT ON COLUMN ohi.nsi_rss_list.sh_name IS 'Наименование новостной ленты';
COMMENT ON COLUMN ohi.nsi_rss_list.url IS 'url для получения новостной ленты';
COMMENT ON COLUMN ohi.nsi_rss_list.lang IS 'Язык, на котором лента выдает сообщения';
COMMENT ON COLUMN ohi.nsi_rss_list.description IS 'Описание направленности информации новостной ленты сайта';
COMMENT ON COLUMN ohi.nsi_rss_list.type_rss IS 'Тип ленты новостей: rss - просто лента новостей, иначе имя сервиса разбора';
COMMENT ON COLUMN ohi.nsi_rss_list.stop IS 'Признак временного останова обработки новостной ленты';
COMMENT ON COLUMN ohi.nsi_rss_list.type_article IS 'Тип разборщика текста статьи из url новости';
ALTER TABLE ohi.nsi_rss_list ADD CONSTRAINT pk_ohi_nsi_rss_list PRIMARY KEY (id);

-- Таблица: ohi.nsi_rss_themes
-- Комментарий: Поисковые слова  для контроля лент новостей через RSS
CREATE TABLE ohi.nsi_rss_themes (id integer(32,0) NOT NULL, sh_name character varying(50), value text, stop boolean);
COMMENT ON TABLE ohi.nsi_rss_themes IS 'Поисковые слова  для контроля лент новостей через RSS';
COMMENT ON COLUMN ohi.nsi_rss_themes.id IS 'Идентификатор объекта';
COMMENT ON COLUMN ohi.nsi_rss_themes.sh_name IS 'Имя темы поиска в лентах новостей';
COMMENT ON COLUMN ohi.nsi_rss_themes.value IS 'Поисковые образы через ; для соблюдения регистра используется окаймление через символ ^';
COMMENT ON COLUMN ohi.nsi_rss_themes.stop IS 'Признак временного исключения темы из поисков новостей';
ALTER TABLE ohi.nsi_rss_themes ADD CONSTRAINT pk_ohi_nsi_rss_themes PRIMARY KEY (id);

-- Таблица: ohi.nsi_ru_events
-- Комментарий: Новости, сообщения, пресс-конференции главы правительства РФ
CREATE TABLE ohi.nsi_ru_events (id integer(32,0) NOT NULL, sh_name text, category USER-DEFINED, date date, source text, excerption text, txt text, sh_name_en text, excerption_en integer(32,0), txt_en text, file integer(32,0));
COMMENT ON TABLE ohi.nsi_ru_events IS 'Новости~a2~ сообщения~a2~ пресс-конференции главы правительства РФ';
COMMENT ON COLUMN ohi.nsi_ru_events.id IS 'Идентификатор объекта';
COMMENT ON COLUMN ohi.nsi_ru_events.sh_name IS 'Заголовок события на русском языке';
COMMENT ON COLUMN ohi.nsi_ru_events.category IS 'Категория события';
COMMENT ON COLUMN ohi.nsi_ru_events.date IS 'Дата события';
COMMENT ON COLUMN ohi.nsi_ru_events.source IS 'Источник получения события';
COMMENT ON COLUMN ohi.nsi_ru_events.excerption IS 'Опциональный текст к событию';
COMMENT ON COLUMN ohi.nsi_ru_events.txt IS 'Текст сообщения для категории messages на русском языке';
COMMENT ON COLUMN ohi.nsi_ru_events.sh_name_en IS 'Заголовок на английском языке';
COMMENT ON COLUMN ohi.nsi_ru_events.excerption_en IS 'Опциональный текст на английском языке';
COMMENT ON COLUMN ohi.nsi_ru_events.txt_en IS 'Текст сообщения для категории messages на английском языке';
COMMENT ON COLUMN ohi.nsi_ru_events.file IS 'Размер файла с текстом в облаке';
ALTER TABLE ohi.nsi_ru_events ADD CONSTRAINT pk_ohi_nsi_ru_events PRIMARY KEY (id);

-- Таблица: ohi.nsi_texts
-- Комментарий: Библиотека текстов
CREATE TABLE ohi.nsi_texts (id integer(32,0) NOT NULL, sh_name character varying(250), dt date NOT NULL, source text, _delete boolean, url text, txt text);
COMMENT ON TABLE ohi.nsi_texts IS 'Библиотека текстов';
COMMENT ON COLUMN ohi.nsi_texts.id IS 'Идентификатор объекта';
COMMENT ON COLUMN ohi.nsi_texts.sh_name IS 'Наименование текста';
COMMENT ON COLUMN ohi.nsi_texts.dt IS 'Дата появления текста';
COMMENT ON COLUMN ohi.nsi_texts.source IS 'Источник, из которого получен текст';
COMMENT ON COLUMN ohi.nsi_texts._delete IS 'Признак удаления объекта';
COMMENT ON COLUMN ohi.nsi_texts.url IS 'Ссылка на документ с текстом';
COMMENT ON COLUMN ohi.nsi_texts.txt IS 'Текст документа (временно)';
ALTER TABLE ohi.nsi_texts ADD CONSTRAINT pk_ohi_nsi_texts PRIMARY KEY (id);

-- Таблица: ohi.nsi_topics
-- Комментарий: Темы, которые могут быть затронуты в текстах
CREATE TABLE ohi.nsi_topics (id integer(32,0) NOT NULL, sh_name character varying(50), words text, _delete boolean, count integer(32,0));
COMMENT ON TABLE ohi.nsi_topics IS 'Темы~a2~ которые могут быть затронуты в текстах';
COMMENT ON COLUMN ohi.nsi_topics.id IS 'Идентификатор объекта';
COMMENT ON COLUMN ohi.nsi_topics.sh_name IS 'Наименование тем';
COMMENT ON COLUMN ohi.nsi_topics.words IS 'Список поисковых образов для определения принадлежности текстов к теме (через точку с запятой)';
COMMENT ON COLUMN ohi.nsi_topics._delete IS 'Признак удаления объекта';
COMMENT ON COLUMN ohi.nsi_topics.count IS 'Количество документов, в которых присутствует тема';
ALTER TABLE ohi.nsi_topics ADD CONSTRAINT pk_ohi_nsi_topics PRIMARY KEY (id);

-- Таблица: ohi.nsi_transcripts
-- Комментарий: Список документов стенограмм заседаний Кнессета, привязанные к темам поиска
CREATE TABLE ohi.nsi_transcripts (id integer(32,0) NOT NULL, sh_name character varying(100), date date, theme integer(32,0), count integer(32,0), file_size_ru integer(32,0), file_size_he integer(32,0), file_size_en integer(32,0));
COMMENT ON TABLE ohi.nsi_transcripts IS 'Список документов стенограмм заседаний Кнессета~a2~ привязанные к темам поиска';
COMMENT ON COLUMN ohi.nsi_transcripts.id IS 'Идентификатор объекта';
COMMENT ON COLUMN ohi.nsi_transcripts.sh_name IS 'Имя исходного файла на иврите';
COMMENT ON COLUMN ohi.nsi_transcripts.date IS 'Дата заседания Кнессета';
COMMENT ON COLUMN ohi.nsi_transcripts.theme IS 'Ссылка на поисковую тему';
COMMENT ON COLUMN ohi.nsi_transcripts.count IS 'Количество вхождений поисковых образов темы в документе';
COMMENT ON COLUMN ohi.nsi_transcripts.file_size_ru IS 'Размер файла с документом на русском языке';
COMMENT ON COLUMN ohi.nsi_transcripts.file_size_he IS 'Размер файла с документа на иврите';
COMMENT ON COLUMN ohi.nsi_transcripts.file_size_en IS 'Длина файла на английском языке';
ALTER TABLE ohi.nsi_transcripts ADD CONSTRAINT pk_ohi_nsi_transcripts PRIMARY KEY (id);

-- Таблица: ohi.rel_persons_texts_texts
CREATE TABLE ohi.rel_persons_texts_texts (persons_id integer(32,0) NOT NULL, texts_id integer(32,0) NOT NULL);
CREATE UNIQUE INDEX rel_persons_texts_texts_idx ON ohi.rel_persons_texts_texts USING btree (persons_id, texts_id);

-- Таблица: ohi.rel_rss_themes_rss_history_rss
CREATE TABLE ohi.rel_rss_themes_rss_history_rss (rss_themes_id integer(32,0) NOT NULL, rss_history_id integer(32,0) NOT NULL);
CREATE UNIQUE INDEX rel_rss_themes_rss_history_rss_idx ON ohi.rel_rss_themes_rss_history_rss USING btree (rss_themes_id, rss_history_id);

-- Таблица: ohi.rel_texts_topics_topic
CREATE TABLE ohi.rel_texts_topics_topic (texts_id integer(32,0) NOT NULL, topics_id integer(32,0) NOT NULL);
CREATE UNIQUE INDEX rel_texts_topics_topic_idx ON ohi.rel_texts_topics_topic USING btree (texts_id, topics_id);

-- Таблица: ohi.table_depend
CREATE TABLE ohi.table_depend (name text, rang integer(32,0), dop text);

-- Таблица: ohi.temp_table_depend
CREATE TABLE ohi.temp_table_depend (code_ref text, typeobj_code text);

-- Внешние ключи
ALTER TABLE ohi.his_biographies_stages ADD CONSTRAINT his_biographies_stages_fk FOREIGN KEY (biographies_id) REFERENCES ohi.nsi_biographies (id);
ALTER TABLE ohi.his_guests_page ADD CONSTRAINT his_guests_page_fk FOREIGN KEY (guests_id) REFERENCES ohi.nsi_guests (id);
ALTER TABLE ohi.link_biographies ADD CONSTRAINT ohi_link_biographies_fk2 FOREIGN KEY (id) REFERENCES ohi.nsi_biographies (id);
ALTER TABLE ohi.link_guests ADD CONSTRAINT ohi_link_guests_fk2 FOREIGN KEY (id) REFERENCES ohi.nsi_guests (id);
ALTER TABLE ohi.nsi_biographies ADD CONSTRAINT ohi_nsi_biographies_fk1 FOREIGN KEY (person) REFERENCES ohi.nsi_persons (id);
ALTER TABLE ohi.nsi_functions_params ADD CONSTRAINT ohi_nsi_functions_params_fk1 FOREIGN KEY (function) REFERENCES ohi.nsi_parser_functions (id);
ALTER TABLE ohi.nsi_transcripts ADD CONSTRAINT ohi_nsi_transcripts_fk1 FOREIGN KEY (theme) REFERENCES ohi.nsi_rss_themes (id);
ALTER TABLE ohi.rel_persons_texts_texts ADD CONSTRAINT persons_fk FOREIGN KEY (persons_id) REFERENCES ohi.nsi_persons (id);
ALTER TABLE ohi.rel_persons_texts_texts ADD CONSTRAINT persons_fk_1 FOREIGN KEY (texts_id) REFERENCES ohi.nsi_texts (id);
ALTER TABLE ohi.rel_rss_themes_rss_history_rss ADD CONSTRAINT rss_themes_fk FOREIGN KEY (rss_themes_id) REFERENCES ohi.nsi_rss_themes (id);
ALTER TABLE ohi.rel_rss_themes_rss_history_rss ADD CONSTRAINT rss_themes_fk_1 FOREIGN KEY (rss_history_id) REFERENCES ohi.nsi_rss_history (id);
ALTER TABLE ohi.rel_texts_topics_topic ADD CONSTRAINT texts_fk FOREIGN KEY (texts_id) REFERENCES ohi.nsi_texts (id);
ALTER TABLE ohi.rel_texts_topics_topic ADD CONSTRAINT texts_fk_1 FOREIGN KEY (topics_id) REFERENCES ohi.nsi_topics (id);