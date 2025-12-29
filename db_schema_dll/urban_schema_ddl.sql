-- DDL схемы urban
-- Сгенерировано: 2025-12-27 18:45:38.921080

CREATE SCHEMA IF NOT EXISTS urban;


-- Таблица: urban.his_guests_page
-- Комментарий: Историческая таблица для свойства [page] сущности [guests]
CREATE TABLE urban.his_guests_page (guests_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value character varying);
COMMENT ON TABLE urban.his_guests_page IS 'Историческая таблица для свойства [page] сущности [guests]';
COMMENT ON COLUMN urban.his_guests_page.guests_id IS 'Ссылка на объект сущности [guests]';
COMMENT ON COLUMN urban.his_guests_page.dt IS 'Время значения свойства [page] сущности [guests]';
COMMENT ON COLUMN urban.his_guests_page.value IS 'Значение свойства [page] сущности [guests]';
ALTER TABLE urban.his_guests_page ADD CONSTRAINT pk_urban_his_guests_page PRIMARY KEY (guests_id, dt);

-- Таблица: urban.link_guests
-- Комментарий: Таблица хранения ссылок исторических параметров сущности [guests на параметры КСВД
CREATE TABLE urban.link_guests (id integer(32,0) NOT NULL, param_id integer(32,0) NOT NULL, parameter_id character varying, equipment_id character varying, type_his USER-DEFINED, discret integer(32,0));
COMMENT ON TABLE urban.link_guests IS 'Таблица хранения ссылок исторических параметров сущности [guests на параметры КСВД';
COMMENT ON COLUMN urban.link_guests.id IS 'Ссылка на объект сущности [guests]';
COMMENT ON COLUMN urban.link_guests.param_id IS 'Ссылка на тип параметров МДМ';
COMMENT ON COLUMN urban.link_guests.parameter_id IS 'Идентификатор параметра КСВД';
COMMENT ON COLUMN urban.link_guests.equipment_id IS 'Идентификатор устройства КСВД';
COMMENT ON COLUMN urban.link_guests.type_his IS 'Тип временного ряда';
COMMENT ON COLUMN urban.link_guests.discret IS 'Дискретность информации в секундах';
ALTER TABLE urban.link_guests ADD CONSTRAINT pk_nsi_link_guests PRIMARY KEY (id, param_id);

-- Таблица: urban.logs
CREATE TABLE urban.logs (id integer(32,0) NOT NULL, at_date_time timestamp without time zone, level character varying, source character varying, td real, page integer(32,0), law_id character varying, file_name character varying, comment character varying);
ALTER TABLE urban.logs ADD CONSTRAINT pk_urban_logs PRIMARY KEY (id);
CREATE INDEX logs_at_date_time_idx ON urban.logs USING btree (at_date_time);

-- Таблица: urban.nsi_comments
-- Комментарий: Комментарии к видео
CREATE TABLE urban.nsi_comments (id integer(32,0) NOT NULL, text text, likes integer(32,0), published_at timestamp without time zone, updated_at timestamp without time zone, sh_name text, video_id text, size_comment integer(32,0), count integer(32,0), pos_pct real, neg_pct real, neu_pct real, mean_polarity real);
COMMENT ON TABLE urban.nsi_comments IS 'Комментарии к видео';
COMMENT ON COLUMN urban.nsi_comments.id IS 'Идентификатор объекта';
COMMENT ON COLUMN urban.nsi_comments.text IS 'Текст комментария';
COMMENT ON COLUMN urban.nsi_comments.likes IS 'Количество лайков';
COMMENT ON COLUMN urban.nsi_comments.published_at IS 'Время опубликования комментария';
COMMENT ON COLUMN urban.nsi_comments.updated_at IS 'Время записи комментария в БД';
COMMENT ON COLUMN urban.nsi_comments.sh_name IS 'Автор комментария';
COMMENT ON COLUMN urban.nsi_comments.video_id IS 'Идентификатор видео~a2~ к которому принадлежит комментарий';
COMMENT ON COLUMN urban.nsi_comments.size_comment IS 'Длина комментария';
COMMENT ON COLUMN urban.nsi_comments.count IS 'Количество строк в анализе sentiment';
COMMENT ON COLUMN urban.nsi_comments.pos_pct IS 'Процент позитива';
COMMENT ON COLUMN urban.nsi_comments.neg_pct IS 'Процент негатива';
COMMENT ON COLUMN urban.nsi_comments.neu_pct IS 'Процент нейтральности';
COMMENT ON COLUMN urban.nsi_comments.mean_polarity IS 'Средняя величина polarity';
ALTER TABLE urban.nsi_comments ADD CONSTRAINT pk_urban_nsi_comments PRIMARY KEY (id);
CREATE INDEX idx_nsi_comments_video_id ON urban.nsi_comments USING btree (video_id);

-- Таблица: urban.nsi_discord_channels
-- Комментарий: Информация по обрабатываемым каналам discord
CREATE TABLE urban.nsi_discord_channels (id integer(32,0) NOT NULL, sh_name character varying(50), code text, guild_name text, topic text, "position" integer(32,0), category text, created_at timestamp without time zone, nsfw boolean, slowmode_delay integer(32,0), member_count integer(32,0), permission_overwrites json, remove boolean, removed_at timestamp without time zone);
COMMENT ON TABLE urban.nsi_discord_channels IS 'Информация по обрабатываемым каналам discord';
COMMENT ON COLUMN urban.nsi_discord_channels.id IS 'Идентификатор объекта';
COMMENT ON COLUMN urban.nsi_discord_channels.sh_name IS 'Наименование канала';
COMMENT ON COLUMN urban.nsi_discord_channels.code IS 'Идентификатор канала в discord';
COMMENT ON COLUMN urban.nsi_discord_channels.guild_name IS 'Имя гильдии~a2~ в которой существует кнал';
COMMENT ON COLUMN urban.nsi_discord_channels.topic IS 'Тема канала';
COMMENT ON COLUMN urban.nsi_discord_channels.position IS 'Номер темы ~A~канала~B~ в guild';
COMMENT ON COLUMN urban.nsi_discord_channels.category IS 'Категория канала';
COMMENT ON COLUMN urban.nsi_discord_channels.created_at IS 'Время создания канала';
COMMENT ON COLUMN urban.nsi_discord_channels.nsfw IS 'аббревиатура от английского ~a4~Not Safe For Work~a4~~a2~ то есть «небезопасно для работы».~R~~LF~Это пометка канала~a2~ указывающая~a2~ что в нём может быть размещён контент 18+~a6~~R~~LF~- откровенные изображения или тексты~a2~~R~~LF~-насилие~a2~~R~~LF~- грубый юмор и т.п.';
COMMENT ON COLUMN urban.nsi_discord_channels.slowmode_delay IS 'После отправки сообщения~a2~ пользователь должен подождать X секунд~a2~ прежде чем сможет отправить следующее.';
COMMENT ON COLUMN urban.nsi_discord_channels.member_count IS 'Количество членов канала';
COMMENT ON COLUMN urban.nsi_discord_channels.permission_overwrites IS 'механизм~a2~ который позволяет настраивать индивидуальные права доступа для конкретных ролей или пользователей на уровне отдельного канала.';
COMMENT ON COLUMN urban.nsi_discord_channels.remove IS 'Признак удаления канала';
COMMENT ON COLUMN urban.nsi_discord_channels.removed_at IS 'Время удаления канала';
ALTER TABLE urban.nsi_discord_channels ADD CONSTRAINT pk_urban_nsi_discord_channels PRIMARY KEY (id);

-- Таблица: urban.nsi_discord_his_count_members
-- Комментарий: История изменения количества подписчиков  в часовом разрезе
CREATE TABLE urban.nsi_discord_his_count_members (id integer(32,0) NOT NULL, sh_name character varying(50), date date, count_join integer(32,0), count_remove integer(32,0));
COMMENT ON TABLE urban.nsi_discord_his_count_members IS 'История изменения количества подписчиков  в часовом разрезе';
COMMENT ON COLUMN urban.nsi_discord_his_count_members.id IS 'Идентификатор объекта';
COMMENT ON COLUMN urban.nsi_discord_his_count_members.sh_name IS 'Наименование объекта';
COMMENT ON COLUMN urban.nsi_discord_his_count_members.date IS 'Дата~a2~ в которую изменился набор подписчиков ';
COMMENT ON COLUMN urban.nsi_discord_his_count_members.count_join IS 'Количество новых подписчиков в указанные сутки';
COMMENT ON COLUMN urban.nsi_discord_his_count_members.count_remove IS 'Количество ушедших подписчиков в указанные сутки';
ALTER TABLE urban.nsi_discord_his_count_members ADD CONSTRAINT pk_urban_nsi_discord_his_count_members PRIMARY KEY (id);

-- Таблица: urban.nsi_discord_his_status_members
-- Комментарий: История смены статусов подписчиков
CREATE TABLE urban.nsi_discord_his_status_members (id integer(32,0) NOT NULL, sh_name character varying(50), member_id character varying(50), at_date_time timestamp without time zone, status text);
COMMENT ON TABLE urban.nsi_discord_his_status_members IS 'История смены статусов подписчиков';
COMMENT ON COLUMN urban.nsi_discord_his_status_members.id IS 'Идентификатор объекта';
COMMENT ON COLUMN urban.nsi_discord_his_status_members.sh_name IS 'Наименование объекта';
COMMENT ON COLUMN urban.nsi_discord_his_status_members.member_id IS 'Идентификатор пользователя в Discord';
COMMENT ON COLUMN urban.nsi_discord_his_status_members.at_date_time IS 'Время и дата изменения статуса пользователя';
COMMENT ON COLUMN urban.nsi_discord_his_status_members.status IS 'Величина статуса пользователя';
ALTER TABLE urban.nsi_discord_his_status_members ADD CONSTRAINT pk_urban_nsi_discord_his_status_members PRIMARY KEY (id);

-- Таблица: urban.nsi_discord_members
-- Комментарий: Список подписчиков ~A~пользователей~B~ в Discord
CREATE TABLE urban.nsi_discord_members (id integer(32,0) NOT NULL, sh_name character varying(50), remove boolean, display_name character varying(50), join_at timestamp without time zone, member_id character varying(50), bot boolean, remove_at timestamp without time zone);
COMMENT ON TABLE urban.nsi_discord_members IS 'Список подписчиков ~A~пользователей~B~ в Discord';
COMMENT ON COLUMN urban.nsi_discord_members.id IS 'Идентификатор объекта';
COMMENT ON COLUMN urban.nsi_discord_members.sh_name IS 'Имя подписчика ~A~name в member~B~ для Discord';
COMMENT ON COLUMN urban.nsi_discord_members.remove IS 'Признак того~a2~ что в настоящее время пользователь покинул сервер';
COMMENT ON COLUMN urban.nsi_discord_members.display_name IS 'Отображаемое имя ~A~с учётом ника на сервере~B~';
COMMENT ON COLUMN urban.nsi_discord_members.join_at IS 'Дата вступления на сервер';
COMMENT ON COLUMN urban.nsi_discord_members.member_id IS 'ID пользователя на сервере';
COMMENT ON COLUMN urban.nsi_discord_members.bot IS 'True - бот~a2~ False - человек';
COMMENT ON COLUMN urban.nsi_discord_members.remove_at IS 'Время и дата когда участник покинул сервер';
ALTER TABLE urban.nsi_discord_members ADD CONSTRAINT pk_urban_nsi_discord_members PRIMARY KEY (id);

-- Таблица: urban.nsi_discord_members_test
CREATE TABLE urban.nsi_discord_members_test (id integer(32,0) NOT NULL, sh_name character varying(50), remove boolean, display_name character varying(50), join_at timestamp without time zone, member_id character varying(50), bot boolean);
COMMENT ON COLUMN urban.nsi_discord_members_test.id IS 'Идентификатор объекта';
COMMENT ON COLUMN urban.nsi_discord_members_test.sh_name IS 'Наименование объекта';
ALTER TABLE urban.nsi_discord_members_test ADD CONSTRAINT pk_urban_nsi_discord_members_test PRIMARY KEY (id);

-- Таблица: urban.nsi_discord_messages
-- Комментарий: Библиотека сообщения~a2~ полученных из discord
CREATE TABLE urban.nsi_discord_messages (id integer(32,0) NOT NULL, sh_name character varying(50), author integer(32,0), message_id text, content text, created_at timestamp without time zone, edited_at timestamp without time zone, is_reply boolean, mentions text, emodji character varying(50), count_reactions integer(32,0), reactions json, has_attachments boolean, channel integer(32,0), attachments text);
COMMENT ON TABLE urban.nsi_discord_messages IS 'Библиотека сообщения~a2~ полученных из discord';
COMMENT ON COLUMN urban.nsi_discord_messages.id IS 'Идентификатор объекта';
COMMENT ON COLUMN urban.nsi_discord_messages.sh_name IS 'Название канала или ветки';
COMMENT ON COLUMN urban.nsi_discord_messages.author IS 'Ссылка на автора';
COMMENT ON COLUMN urban.nsi_discord_messages.message_id IS 'Идентификатор сообщения в discord';
COMMENT ON COLUMN urban.nsi_discord_messages.content IS 'Текст сообщения';
COMMENT ON COLUMN urban.nsi_discord_messages.created_at IS 'Время и дата отправки сообщения';
COMMENT ON COLUMN urban.nsi_discord_messages.edited_at IS 'Когда отредактировано ~A~если было~B~';
COMMENT ON COLUMN urban.nsi_discord_messages.is_reply IS 'Признак ответа';
COMMENT ON COLUMN urban.nsi_discord_messages.mentions IS 'Кого упомянули ~A~usernames~B~';
COMMENT ON COLUMN urban.nsi_discord_messages.emodji IS 'Эмодзи';
COMMENT ON COLUMN urban.nsi_discord_messages.count_reactions IS 'Количество реакций на сообщение';
COMMENT ON COLUMN urban.nsi_discord_messages.reactions IS 'Реакции на сообщение';
COMMENT ON COLUMN urban.nsi_discord_messages.has_attachments IS 'Есть ли файлы';
COMMENT ON COLUMN urban.nsi_discord_messages.channel IS 'Канал~a2~ в котором находится сообщение';
COMMENT ON COLUMN urban.nsi_discord_messages.attachments IS 'Ссылки на файлы ~A~если есть~B~';
ALTER TABLE urban.nsi_discord_messages ADD CONSTRAINT pk_urban_nsi_discord_messages PRIMARY KEY (id);

-- Таблица: urban.nsi_discord_threads
-- Комментарий: Отдельная ветка сообщений~a2~ привязанная к определённому сообщению или начатая вручную внутри канала
CREATE TABLE urban.nsi_discord_threads (id integer(32,0) NOT NULL, sh_name character varying(50), mes_id text, author json, created_at timestamp without time zone, edited_at timestamp without time zone, channel json, embeds json, reference text, mention_everyone boolean, reactions json, thread json, flags json, content text, attachments text, mentions text, stickers text);
COMMENT ON TABLE urban.nsi_discord_threads IS 'Отдельная ветка сообщений~a2~ привязанная к определённому сообщению или начатая вручную внутри канала';
COMMENT ON COLUMN urban.nsi_discord_threads.id IS 'Идентификатор объекта';
COMMENT ON COLUMN urban.nsi_discord_threads.sh_name IS 'Наименование объекта в виде thread.parent.name ~b1~ thread.name';
COMMENT ON COLUMN urban.nsi_discord_threads.mes_id IS 'Идентификатор в Discord ~A~на всякий случай как строка~B~';
COMMENT ON COLUMN urban.nsi_discord_threads.author IS 'Объект пользователя~a2~ который отправил сообщение ~A~в виде словаря~B~';
COMMENT ON COLUMN urban.nsi_discord_threads.created_at IS 'Время отправки сообщения ~A~тип datetime~a2~ в UTC~B~';
COMMENT ON COLUMN urban.nsi_discord_threads.edited_at IS 'Время редактирования сообщения~a2~ если оно редактировалось. ';
COMMENT ON COLUMN urban.nsi_discord_threads.channel IS 'Объект канала~a2~ в котором находится сообщение. В случае треда — это сам тред';
COMMENT ON COLUMN urban.nsi_discord_threads.embeds IS 'Список embed-элементов ~A~встроенные карточки Discord~a2~ например превью ссылок~B~.';
COMMENT ON COLUMN urban.nsi_discord_threads.reference IS 'Если это ответ на сообщение — здесь будет информация о родительском сообщении';
COMMENT ON COLUMN urban.nsi_discord_threads.mention_everyone IS 'Булево значение~a6~ true~a2~ если использовано ~a1~everyone или ~a1~here';
COMMENT ON COLUMN urban.nsi_discord_threads.reactions IS 'Список реакций на сообщение';
COMMENT ON COLUMN urban.nsi_discord_threads.thread IS 'Если сообщение породило новый тред — тут будет объект этого треда';
COMMENT ON COLUMN urban.nsi_discord_threads.flags IS 'Специальные флаги сообщения ~A~например~a2~ скрытие embed~B~. Используется редко.';
COMMENT ON COLUMN urban.nsi_discord_threads.content IS 'Текст';
COMMENT ON COLUMN urban.nsi_discord_threads.attachments IS 'Список вложений ~A~файлов~a2~ картинок и т.д.~B~';
COMMENT ON COLUMN urban.nsi_discord_threads.mentions IS 'Список пользователей~a2~ которых упомянули через ~a1~.';
COMMENT ON COLUMN urban.nsi_discord_threads.stickers IS 'Стикеры~a2~ прикреплённые к сообщению';
ALTER TABLE urban.nsi_discord_threads ADD CONSTRAINT pk_urban_nsi_discord_threads PRIMARY KEY (id);

-- Таблица: urban.nsi_functions_params
-- Комментарий: Список настроечных параметров для функций сервиса парсинга
CREATE TABLE urban.nsi_functions_params (id integer(32,0) NOT NULL, sh_name text, code text, value text, function integer(32,0), is_number boolean, _delete boolean);
COMMENT ON TABLE urban.nsi_functions_params IS 'Список настроечных параметров для функций сервиса парсинга';
COMMENT ON COLUMN urban.nsi_functions_params.id IS 'Идентификатор объекта';
COMMENT ON COLUMN urban.nsi_functions_params.sh_name IS 'Наименование объекта';
COMMENT ON COLUMN urban.nsi_functions_params.code IS 'Код параметра для функции парсинга (используется в парсинге)';
COMMENT ON COLUMN urban.nsi_functions_params.value IS 'Значение параметра';
COMMENT ON COLUMN urban.nsi_functions_params.function IS 'Ссылка на функцию сервиса парсинга~a2~ для которой задается параметр';
COMMENT ON COLUMN urban.nsi_functions_params.is_number IS 'Содержимое параметра является числом или строкой: True - число, иначе - строка';
COMMENT ON COLUMN urban.nsi_functions_params._delete IS 'Flag for deleting an object';
ALTER TABLE urban.nsi_functions_params ADD CONSTRAINT pk_urban_nsi_functions_params PRIMARY KEY (id);

-- Таблица: urban.nsi_guests
-- Комментарий: Список IP адресов, посещяющих сайт sozd
CREATE TABLE urban.nsi_guests (id integer(32,0) NOT NULL, sh_name character varying(50), country character varying(50), city character varying(50), _delete boolean);
COMMENT ON TABLE urban.nsi_guests IS 'Список IP адресов, посещяющих сайт sozd';
COMMENT ON COLUMN urban.nsi_guests.id IS 'Идентификатор объекта';
COMMENT ON COLUMN urban.nsi_guests.sh_name IS 'IP посетителя';
COMMENT ON COLUMN urban.nsi_guests.country IS 'Наименование страны IP';
COMMENT ON COLUMN urban.nsi_guests.city IS 'Название города IP';
COMMENT ON COLUMN urban.nsi_guests._delete IS 'Flag for deleting an object';
ALTER TABLE urban.nsi_guests ADD CONSTRAINT pk_urban_nsi_guests PRIMARY KEY (id);
CREATE UNIQUE INDEX nsi_guests_idx ON urban.nsi_guests USING btree (sh_name);

-- Таблица: urban.nsi_his_discord_member
-- Комментарий: История количества подписчиков на каналы Discord
CREATE TABLE urban.nsi_his_discord_member (id integer(32,0) NOT NULL, sh_name character varying(50), channel integer(32,0), member_count integer(32,0), at_date date);
COMMENT ON TABLE urban.nsi_his_discord_member IS 'История количества подписчиков на каналы Discord';
COMMENT ON COLUMN urban.nsi_his_discord_member.id IS 'Идентификатор объекта';
COMMENT ON COLUMN urban.nsi_his_discord_member.sh_name IS 'Наименование объекта';
COMMENT ON COLUMN urban.nsi_his_discord_member.channel IS 'Ссылка на канал Discord';
COMMENT ON COLUMN urban.nsi_his_discord_member.member_count IS 'Количество подписчиков на канал в указанную дату';
COMMENT ON COLUMN urban.nsi_his_discord_member.at_date IS 'Дата~a2~ в которую было указанное количество подписчиков на канал';
ALTER TABLE urban.nsi_his_discord_member ADD CONSTRAINT pk_urban_nsi_his_discord_member PRIMARY KEY (id);

-- Таблица: urban.nsi_list
-- Комментарий: Список публикаций на youtube
CREATE TABLE urban.nsi_list (id integer(32,0) NOT NULL, sh_name text, url text, id_site text, size_file integer(32,0), at_date_time timestamp without time zone, need_reload boolean, sentiment text, value real, err text, result json, likes integer(32,0), dislikes integer(32,0), comments_count integer(32,0), views_count integer(32,0), published_at timestamp without time zone, channel_id text, channel_title text, category_id integer(32,0), category_name text, duration text, dimension text, definition text, caption boolean, description text, source integer(32,0), tags ARRAY);
COMMENT ON TABLE urban.nsi_list IS 'Список публикаций на youtube';
COMMENT ON COLUMN urban.nsi_list.id IS 'Идентификатор объекта';
COMMENT ON COLUMN urban.nsi_list.sh_name IS 'Наименование публикации';
COMMENT ON COLUMN urban.nsi_list.url IS 'Текст ссылки на страницу публикации';
COMMENT ON COLUMN urban.nsi_list.id_site IS 'Идентификатор публикации сайта';
COMMENT ON COLUMN urban.nsi_list.size_file IS 'Длина текста файла с расшифровкой публикации';
COMMENT ON COLUMN urban.nsi_list.at_date_time IS 'Системное время появления записи в базе данных';
COMMENT ON COLUMN urban.nsi_list.need_reload IS 'Признак необходимости загрузить транскрипцию видео с сайта и записать файл в облако.';
COMMENT ON COLUMN urban.nsi_list.sentiment IS 'Качество оценки игры в публикации';
COMMENT ON COLUMN urban.nsi_list.value IS 'Числовое значение оценки качества ~A~от 0 до 1~B~';
COMMENT ON COLUMN urban.nsi_list.err IS 'Текст ошибки при обработке видео';
COMMENT ON COLUMN urban.nsi_list.result IS 'Результат оценивания ';
COMMENT ON COLUMN urban.nsi_list.likes IS 'Количество лайков к видео';
COMMENT ON COLUMN urban.nsi_list.dislikes IS 'Количество disлайков к видео';
COMMENT ON COLUMN urban.nsi_list.comments_count IS 'Количество комментариев к видео';
COMMENT ON COLUMN urban.nsi_list.views_count IS 'Количество просмотров видео';
COMMENT ON COLUMN urban.nsi_list.published_at IS 'Время публикации видео';
COMMENT ON COLUMN urban.nsi_list.channel_id IS 'Идентификатор канала';
COMMENT ON COLUMN urban.nsi_list.channel_title IS 'Название канала';
COMMENT ON COLUMN urban.nsi_list.category_id IS 'ID категории видео youtube';
COMMENT ON COLUMN urban.nsi_list.category_name IS 'Название категории канада видео';
COMMENT ON COLUMN urban.nsi_list.duration IS 'Длительность видео ~A~в символьном формате~B~';
COMMENT ON COLUMN urban.nsi_list.dimension IS 'Пространственная размерность видео youtube';
COMMENT ON COLUMN urban.nsi_list.definition IS 'Качество видео с точки зрения разрешения';
COMMENT ON COLUMN urban.nsi_list.caption IS 'Наличие субтитров';
COMMENT ON COLUMN urban.nsi_list.description IS 'Description к видео';
COMMENT ON COLUMN urban.nsi_list.source IS 'Ссылка на источник информации ~A~откуда получено видео~B~';
COMMENT ON COLUMN urban.nsi_list.tags IS 'Массив тэгов от youtube';
ALTER TABLE urban.nsi_list ADD CONSTRAINT pk_urban_nsi_list PRIMARY KEY (id);
CREATE INDEX idx_nsi_list_id_site ON urban.nsi_list USING btree (id_site);
CREATE INDEX idx_nsi_list_views ON urban.nsi_list USING btree (views_count);
CREATE UNIQUE INDEX nsi_list_idx ON urban.nsi_list USING btree (id_site);

-- Таблица: urban.nsi_parser_functions
-- Комментарий: Список сервисов парсинга для заведения параметров работы
CREATE TABLE urban.nsi_parser_functions (id integer(32,0) NOT NULL, sh_name character varying(50), description text);
COMMENT ON TABLE urban.nsi_parser_functions IS 'Список сервисов парсинга для заведения параметров работы';
COMMENT ON COLUMN urban.nsi_parser_functions.id IS 'Идентификатор объекта';
COMMENT ON COLUMN urban.nsi_parser_functions.sh_name IS 'Имя функции сервиса парсинга';
COMMENT ON COLUMN urban.nsi_parser_functions.description IS 'Текст, описывающий назначение функции сервиса парсинга информации из ГД РФ';
ALTER TABLE urban.nsi_parser_functions ADD CONSTRAINT pk_urban_nsi_parser_functions PRIMARY KEY (id);
CREATE UNIQUE INDEX nsi_parser_functions_idx ON urban.nsi_parser_functions USING btree (sh_name);

-- Таблица: urban.nsi_sources
-- Комментарий: Список источников информации в интернете
CREATE TABLE urban.nsi_sources (id integer(32,0) NOT NULL, sh_name character varying(50));
COMMENT ON TABLE urban.nsi_sources IS 'Список источников информации в интернете';
COMMENT ON COLUMN urban.nsi_sources.id IS 'Идентификатор объекта';
COMMENT ON COLUMN urban.nsi_sources.sh_name IS 'Наименование объекта';
ALTER TABLE urban.nsi_sources ADD CONSTRAINT pk_urban_nsi_sources PRIMARY KEY (id);

-- Таблица: urban.nsi_themes
-- Комментарий: Список тем~a2~ по которым производится поиск в интернете
CREATE TABLE urban.nsi_themes (id integer(32,0) NOT NULL, sh_name character varying(50), words text, stop boolean, video_category_id integer(32,0));
COMMENT ON TABLE urban.nsi_themes IS 'Список тем~a2~ по которым производится поиск в интернете';
COMMENT ON COLUMN urban.nsi_themes.id IS 'Идентификатор темы';
COMMENT ON COLUMN urban.nsi_themes.sh_name IS 'Наименование темы';
COMMENT ON COLUMN urban.nsi_themes.words IS 'Поисковый образ темы';
COMMENT ON COLUMN urban.nsi_themes.stop IS 'Признак останова обработки темы';
COMMENT ON COLUMN urban.nsi_themes.video_category_id IS 'Возможная категория видео';
ALTER TABLE urban.nsi_themes ADD CONSTRAINT pk_urban_nsi_themes PRIMARY KEY (id);

-- Таблица: urban.rel_themes_list_lists
CREATE TABLE urban.rel_themes_list_lists (themes_id integer(32,0) NOT NULL, list_id integer(32,0) NOT NULL);
CREATE UNIQUE INDEX rel_themes_list_lists_idx ON urban.rel_themes_list_lists USING btree (themes_id, list_id);
CREATE INDEX rel_themes_list_lists_list_id_idx ON urban.rel_themes_list_lists USING btree (list_id);
CREATE INDEX rel_themes_list_lists_themes_id_idx ON urban.rel_themes_list_lists USING btree (themes_id);
CREATE INDEX idx_rel_themes_list_themes_list ON urban.rel_themes_list_lists USING btree (themes_id, list_id);

-- Таблица: urban.table_depend
CREATE TABLE urban.table_depend (name text, rang integer(32,0), dop text);

-- Таблица: urban.temp_table_depend
CREATE TABLE urban.temp_table_depend (code_ref text, typeobj_code text);

-- Внешние ключи
ALTER TABLE urban.his_guests_page ADD CONSTRAINT his_guests_page_fk FOREIGN KEY (guests_id) REFERENCES urban.nsi_guests (id);
ALTER TABLE urban.link_guests ADD CONSTRAINT urban_link_guests_fk2 FOREIGN KEY (id) REFERENCES urban.nsi_guests (id);
ALTER TABLE urban.nsi_discord_messages ADD CONSTRAINT urban_nsi_discord_messages_fk1 FOREIGN KEY (author) REFERENCES urban.nsi_discord_members (id);
ALTER TABLE urban.nsi_discord_messages ADD CONSTRAINT urban_nsi_discord_messages_fk2 FOREIGN KEY (channel) REFERENCES urban.nsi_discord_channels (id);
ALTER TABLE urban.nsi_functions_params ADD CONSTRAINT urban_nsi_functions_params_fk1 FOREIGN KEY (function) REFERENCES urban.nsi_parser_functions (id);
ALTER TABLE urban.nsi_his_discord_member ADD CONSTRAINT urban_nsi_his_discord_member_fk1 FOREIGN KEY (channel) REFERENCES urban.nsi_discord_channels (id);
ALTER TABLE urban.nsi_list ADD CONSTRAINT urban_nsi_list_fk1 FOREIGN KEY (source) REFERENCES urban.nsi_sources (id);
ALTER TABLE urban.rel_themes_list_lists ADD CONSTRAINT themes_fk FOREIGN KEY (themes_id) REFERENCES urban.nsi_themes (id);
ALTER TABLE urban.rel_themes_list_lists ADD CONSTRAINT themes_fk_1 FOREIGN KEY (list_id) REFERENCES urban.nsi_list (id);