-- DDL схемы lib
-- Сгенерировано: 2025-12-27 11:24:07.098272

CREATE SCHEMA IF NOT EXISTS lib;


-- Таблица: lib.his_guests_page
-- Комментарий: Историческая таблица для свойства [page] сущности [guests]
CREATE TABLE lib.his_guests_page (guests_id integer(32,0) NOT NULL, dt timestamp without time zone NOT NULL, value character varying);
COMMENT ON TABLE lib.his_guests_page IS 'Историческая таблица для свойства [page] сущности [guests]';
COMMENT ON COLUMN lib.his_guests_page.guests_id IS 'Ссылка на объект сущности [guests]';
COMMENT ON COLUMN lib.his_guests_page.dt IS 'Время значения свойства [page] сущности [guests]';
COMMENT ON COLUMN lib.his_guests_page.value IS 'Значение свойства [page] сущности [guests]';
ALTER TABLE lib.his_guests_page ADD CONSTRAINT pk_lib_his_guests_page PRIMARY KEY (guests_id, dt);

-- Таблица: lib.link_guests
-- Комментарий: Таблица хранения ссылок исторических параметров сущности [guests на параметры КСВД
CREATE TABLE lib.link_guests (id integer(32,0) NOT NULL, param_id integer(32,0) NOT NULL, parameter_id character varying, equipment_id character varying, type_his USER-DEFINED, discret integer(32,0));
COMMENT ON TABLE lib.link_guests IS 'Таблица хранения ссылок исторических параметров сущности [guests на параметры КСВД';
COMMENT ON COLUMN lib.link_guests.id IS 'Ссылка на объект сущности [guests]';
COMMENT ON COLUMN lib.link_guests.param_id IS 'Ссылка на тип параметров МДМ';
COMMENT ON COLUMN lib.link_guests.parameter_id IS 'Идентификатор параметра КСВД';
COMMENT ON COLUMN lib.link_guests.equipment_id IS 'Идентификатор устройства КСВД';
COMMENT ON COLUMN lib.link_guests.type_his IS 'Тип временного ряда';
COMMENT ON COLUMN lib.link_guests.discret IS 'Дискретность информации в секундах';
ALTER TABLE lib.link_guests ADD CONSTRAINT pk_nsi_link_guests PRIMARY KEY (id, param_id);

-- Таблица: lib.logs
CREATE TABLE lib.logs (id integer(32,0) NOT NULL, at_date_time timestamp without time zone, level character varying, source character varying, td real, page integer(32,0), law_id character varying, file_name character varying, comment character varying);
ALTER TABLE lib.logs ADD CONSTRAINT pk_sozd_logs PRIMARY KEY (id);

-- Таблица: lib.nsi_alex_authors
-- Комментарий: Авторы~a2~ полученные из OpenAlex
CREATE TABLE lib.nsi_alex_authors (id integer(32,0) NOT NULL, sh_name character varying(50), orcid text, author_id text, works_count integer(32,0), cited_by_count integer(32,0), summary_stats json, last_known_institutions json, update_at timestamp without time zone, altervatives_name text);
COMMENT ON TABLE lib.nsi_alex_authors IS 'Авторы~a2~ полученные из OpenAlex';
COMMENT ON COLUMN lib.nsi_alex_authors.id IS 'Идентификатор объекта';
COMMENT ON COLUMN lib.nsi_alex_authors.sh_name IS 'Полное имя автора';
COMMENT ON COLUMN lib.nsi_alex_authors.orcid IS 'ORCID ~A~Open Researcher and Contributor ID~B~ — это международный уникальный идентификатор исследователя';
COMMENT ON COLUMN lib.nsi_alex_authors.author_id IS 'ID автора в OpenAlex в виде url';
COMMENT ON COLUMN lib.nsi_alex_authors.works_count IS 'Количество работ автора в OpenAlex';
COMMENT ON COLUMN lib.nsi_alex_authors.cited_by_count IS 'Количество ссылок на автора в работах других авторов';
COMMENT ON COLUMN lib.nsi_alex_authors.summary_stats IS 'Суммарные индексы автора~a6~~R~~LF~2yr_mean_citedness -~TAB~Средняя цитируемость публикаций за последние 2 года~R~~LF~h_index - число публикаций~a2~ процитированных хотя бы h раз~R~~LF~i10_index~TAB~ -  Количество публикаций с ≥10 цитирований ~A~используется в Google Scholar~B~';
COMMENT ON COLUMN lib.nsi_alex_authors.last_known_institutions IS 'Последнее известное основное место работы ~A~на уровне author~B~';
COMMENT ON COLUMN lib.nsi_alex_authors.update_at IS 'Время последнего обновления записи';
ALTER TABLE lib.nsi_alex_authors ADD CONSTRAINT pk_lib_nsi_alex_authors PRIMARY KEY (id);

-- Таблица: lib.nsi_alex_concepts
-- Комментарий: Темы или область знаний ~A~используется для категоризации научных работ~a2~ журналов~a2~ авторов и других сущностей~B~ в openalex
CREATE TABLE lib.nsi_alex_concepts (id integer(32,0) NOT NULL, sh_name character varying(50), level integer(32,0), description text, works_count integer(32,0), cited_by_count integer(32,0), concept_id text);
COMMENT ON TABLE lib.nsi_alex_concepts IS 'Темы или область знаний ~A~используется для категоризации научных работ~a2~ журналов~a2~ авторов и других сущностей~B~ в openalex';
COMMENT ON COLUMN lib.nsi_alex_concepts.id IS 'Идентификатор объекта';
COMMENT ON COLUMN lib.nsi_alex_concepts.sh_name IS 'Название концепта';
COMMENT ON COLUMN lib.nsi_alex_concepts.level IS 'Уровень иерархии концептов';
COMMENT ON COLUMN lib.nsi_alex_concepts.description IS 'Краткое описание концепта';
COMMENT ON COLUMN lib.nsi_alex_concepts.works_count IS 'Количество работ~a2~ относящихся к этому концепту';
COMMENT ON COLUMN lib.nsi_alex_concepts.cited_by_count IS 'Общее число цитат всех работ по этой теме';
COMMENT ON COLUMN lib.nsi_alex_concepts.concept_id IS 'Уникальный OpenAlex ID концепта';
ALTER TABLE lib.nsi_alex_concepts ADD CONSTRAINT pk_lib_nsi_alex_concepts PRIMARY KEY (id);

-- Таблица: lib.nsi_alex_documents
-- Комментарий: Каталог документов OpenAlex
CREATE TABLE lib.nsi_alex_documents (id integer(32,0) NOT NULL, sh_name character varying(50), publication_year integer(32,0), doi text, authors text, concepts text, cited_by_count integer(32,0), document_id text, language character varying(16), pdf_url text, type text, type_crossref text, biblio json, url text, updated_at timestamp without time zone, source_name text);
COMMENT ON TABLE lib.nsi_alex_documents IS 'Каталог документов OpenAlex';
COMMENT ON COLUMN lib.nsi_alex_documents.id IS 'Идентификатор объекта';
COMMENT ON COLUMN lib.nsi_alex_documents.sh_name IS 'Title ~A~название~B~ документа ';
COMMENT ON COLUMN lib.nsi_alex_documents.publication_year IS 'Год публикации документа';
COMMENT ON COLUMN lib.nsi_alex_documents.doi IS 'DOI документа';
COMMENT ON COLUMN lib.nsi_alex_documents.authors IS 'Список авторов документа';
COMMENT ON COLUMN lib.nsi_alex_documents.concepts IS 'Список областей знания ~A~концептов~B~~a2~ к которым можно отнести документ';
COMMENT ON COLUMN lib.nsi_alex_documents.cited_by_count IS 'Количество цитирований документа';
COMMENT ON COLUMN lib.nsi_alex_documents.document_id IS 'ID документа в OpenAlex';
COMMENT ON COLUMN lib.nsi_alex_documents.language IS 'Язык документа';
COMMENT ON COLUMN lib.nsi_alex_documents.pdf_url IS 'URL на документ в формате PDF';
COMMENT ON COLUMN lib.nsi_alex_documents.type IS 'Тип документа';
COMMENT ON COLUMN lib.nsi_alex_documents.type_crossref IS 'type_crossref';
COMMENT ON COLUMN lib.nsi_alex_documents.biblio IS 'biblio';
COMMENT ON COLUMN lib.nsi_alex_documents.url IS 'Ссылка на документ на сервере OpenAlex';
COMMENT ON COLUMN lib.nsi_alex_documents.updated_at IS 'Время и дата обновления записи';
COMMENT ON COLUMN lib.nsi_alex_documents.source_name IS 'Название источника ~A~например~a2~ журнал~A~';
ALTER TABLE lib.nsi_alex_documents ADD CONSTRAINT pk_lib_nsi_alex_documents PRIMARY KEY (id);

-- Таблица: lib.nsi_answers_ai
-- Комментарий: Тексты ответов ИИ на поставленные prompt для эссе
CREATE TABLE lib.nsi_answers_ai (id integer(32,0) NOT NULL, sh_name character varying(50), prompt integer(32,0) NOT NULL, essay integer(32,0) NOT NULL, text text, mark integer(32,0));
COMMENT ON TABLE lib.nsi_answers_ai IS 'Тексты ответов ИИ на поставленные prompt для эссе';
COMMENT ON COLUMN lib.nsi_answers_ai.id IS 'Идентификатор объекта';
COMMENT ON COLUMN lib.nsi_answers_ai.sh_name IS 'Наименование объекта';
COMMENT ON COLUMN lib.nsi_answers_ai.prompt IS 'Принадлежность ответа ИИ к вопросу ~A~prompt~B~';
COMMENT ON COLUMN lib.nsi_answers_ai.essay IS 'Принадлежность ответа ИИ к эссе';
COMMENT ON COLUMN lib.nsi_answers_ai.text IS 'Содержимое ответа ИИ на определенный вопрос для определенного эссе';
COMMENT ON COLUMN lib.nsi_answers_ai.mark IS 'Оценка ЭССЕ по промпту в шкале от 0 до 100';
ALTER TABLE lib.nsi_answers_ai ADD CONSTRAINT pk_lib_nsi_answers_ai PRIMARY KEY (id);

-- Таблица: lib.nsi_books
-- Комментарий: Список литературы к лекциям
CREATE TABLE lib.nsi_books (id integer(32,0) NOT NULL, sh_name text, publisher text, count_words integer(32,0), year_publication integer(32,0), filename text, author text, vector_id integer(32,0));
COMMENT ON TABLE lib.nsi_books IS 'Список литературы к лекциям';
COMMENT ON COLUMN lib.nsi_books.id IS 'Идентификатор книги';
COMMENT ON COLUMN lib.nsi_books.sh_name IS 'Наименование ~a4~книги~a4~';
COMMENT ON COLUMN lib.nsi_books.publisher IS 'Издательство';
COMMENT ON COLUMN lib.nsi_books.count_words IS 'Количество слов в ~a4~книге~a4~';
COMMENT ON COLUMN lib.nsi_books.year_publication IS 'Год издания ~A~публикации~B~ ~a4~книги~a4~';
COMMENT ON COLUMN lib.nsi_books.filename IS 'Имя файла с текстом книги в формате txt~a2~ лежащего в облаке ~A~bucket является конфигурационным параметром books~a9~courses~B~';
COMMENT ON COLUMN lib.nsi_books.author IS 'Автор ~a4~Книги~a4~';
COMMENT ON COLUMN lib.nsi_books.vector_id IS 'Индекс в FAISS в файле faiss~a9~index.bin в облаке';
ALTER TABLE lib.nsi_books ADD CONSTRAINT pk_lib_nsi_books PRIMARY KEY (id);

-- Таблица: lib.nsi_catalog
-- Комментарий: Список статей и книг с метаданными
CREATE TABLE lib.nsi_catalog (id integer(32,0) NOT NULL, sh_name text, id_libgen integer(32,0), author text, publisher text, year integer(32,0), pages character varying(32), language character varying(32), size character varying(32), extension character varying(8), mirror_1 text, mirror_2 text, mirror_3 text, journal text, volume integer(32,0), issue integer(32,0), doi text);
COMMENT ON TABLE lib.nsi_catalog IS 'Список статей и книг с метаданными';
COMMENT ON COLUMN lib.nsi_catalog.id IS 'Идентификатор объекта';
COMMENT ON COLUMN lib.nsi_catalog.sh_name IS 'Название статьи или книги';
COMMENT ON COLUMN lib.nsi_catalog.id_libgen IS 'Идентификатор документа в libgen';
COMMENT ON COLUMN lib.nsi_catalog.author IS 'Автор или авторы ';
COMMENT ON COLUMN lib.nsi_catalog.publisher IS 'Издательство~a2~ издавшее книгу';
COMMENT ON COLUMN lib.nsi_catalog.year IS 'Год издания ~A~публикации~B~';
COMMENT ON COLUMN lib.nsi_catalog.pages IS 'Количество страниц ~A~возможно задание двух чисел~a2~ второе в квадратных скобках~B~';
COMMENT ON COLUMN lib.nsi_catalog.language IS 'Имя языка~a2~ на котором издан документ';
COMMENT ON COLUMN lib.nsi_catalog.size IS 'Символьное изображение размера документа';
COMMENT ON COLUMN lib.nsi_catalog.extension IS 'Символьное расширение документа';
COMMENT ON COLUMN lib.nsi_catalog.mirror_1 IS 'Ссылка на первое зеркало с текстом документа';
COMMENT ON COLUMN lib.nsi_catalog.mirror_2 IS 'Ссылка на второе зеркало с текстом документа';
COMMENT ON COLUMN lib.nsi_catalog.mirror_3 IS 'Ссылка на третье зеркало с текстом статьи';
COMMENT ON COLUMN lib.nsi_catalog.journal IS 'Название журнала~a2~ в котором напечатана строка';
COMMENT ON COLUMN lib.nsi_catalog.volume IS 'Номер тома';
COMMENT ON COLUMN lib.nsi_catalog.issue IS 'Номер выпуска';
COMMENT ON COLUMN lib.nsi_catalog.doi IS 'Научный идентификатор публикации';
ALTER TABLE lib.nsi_catalog ADD CONSTRAINT pk_lib_nsi_catalog PRIMARY KEY (id);

-- Таблица: lib.nsi_config
-- Комментарий: Список конфигурационных параметров
CREATE TABLE lib.nsi_config (id integer(32,0) NOT NULL, sh_name character varying(50), value text, comment text, is_number boolean);
COMMENT ON TABLE lib.nsi_config IS 'Список конфигурационных параметров';
COMMENT ON COLUMN lib.nsi_config.id IS 'Идентификатор объекта';
COMMENT ON COLUMN lib.nsi_config.sh_name IS 'Код параметра';
COMMENT ON COLUMN lib.nsi_config.value IS 'Значение параметра в символьном имени';
COMMENT ON COLUMN lib.nsi_config.comment IS 'Текст~a2~ описывающий назначение параметра';
COMMENT ON COLUMN lib.nsi_config.is_number IS 'Признак того~a2~ что value является числом';
ALTER TABLE lib.nsi_config ADD CONSTRAINT pk_lib_nsi_config PRIMARY KEY (id);
CREATE UNIQUE INDEX nsi_config_idx ON lib.nsi_config USING btree (sh_name);

-- Таблица: lib.nsi_countries_authors
-- Комментарий: Список стран с их кодами ISO 3166-1 alpha-2
CREATE TABLE lib.nsi_countries_authors (id integer(32,0) NOT NULL, sh_name character varying(2), display_name character varying(100), url text, count integer(32,0));
COMMENT ON TABLE lib.nsi_countries_authors IS 'Список стран с их кодами ISO 3166-1 alpha-2';
COMMENT ON COLUMN lib.nsi_countries_authors.id IS 'Идентификатор объекта';
COMMENT ON COLUMN lib.nsi_countries_authors.sh_name IS 'Краткое обозначение страны';
COMMENT ON COLUMN lib.nsi_countries_authors.display_name IS 'Название страны ~A~английский язык~B~';
COMMENT ON COLUMN lib.nsi_countries_authors.url IS 'Ссылка на сайт OpenAlex на страницу с информацией по авторам страны';
COMMENT ON COLUMN lib.nsi_countries_authors.count IS 'Количество авторов публикаций~a2~ проживающих в стране';
ALTER TABLE lib.nsi_countries_authors ADD CONSTRAINT pk_lib_nsi_countries_authors PRIMARY KEY (id);

-- Таблица: lib.nsi_courses
-- Комментарий: Список курсов лекций
CREATE TABLE lib.nsi_courses (id integer(32,0) NOT NULL, sh_name text, description text, code text);
COMMENT ON TABLE lib.nsi_courses IS 'Список курсов лекций';
COMMENT ON COLUMN lib.nsi_courses.id IS 'Идентификатор объекта';
COMMENT ON COLUMN lib.nsi_courses.sh_name IS 'Наименование курса';
COMMENT ON COLUMN lib.nsi_courses.description IS 'Комментарий по назначению курса лекций';
COMMENT ON COLUMN lib.nsi_courses.code IS 'Код курса лекций';
ALTER TABLE lib.nsi_courses ADD CONSTRAINT pk_lib_nsi_courses PRIMARY KEY (id);
CREATE UNIQUE INDEX nsi_courses_idx ON lib.nsi_courses USING btree (code);

-- Таблица: lib.nsi_essay_embeddings
-- Комментарий: Вектора текстов эссе
CREATE TABLE lib.nsi_essay_embeddings (id integer(32,0) NOT NULL, sh_name character varying(50), essay integer(32,0) NOT NULL, embedding ARRAY);
COMMENT ON TABLE lib.nsi_essay_embeddings IS 'Вектора текстов эссе';
COMMENT ON COLUMN lib.nsi_essay_embeddings.id IS 'Идентификатор объекта';
COMMENT ON COLUMN lib.nsi_essay_embeddings.sh_name IS 'Наименование объекта';
COMMENT ON COLUMN lib.nsi_essay_embeddings.essay IS 'Ссылка на описание документа';
COMMENT ON COLUMN lib.nsi_essay_embeddings.embedding IS 'Вектора эссе';
ALTER TABLE lib.nsi_essay_embeddings ADD CONSTRAINT pk_lib_nsi_essay_embeddings PRIMARY KEY (id);

-- Таблица: lib.nsi_essays
-- Комментарий: Метаданные библиотеки по эссе
CREATE TABLE lib.nsi_essays (id integer(32,0) NOT NULL, word_count integer(32,0), professor text, institution text, faculty text, email text, date date, course text, academic_year character varying(50), program text, city text, filename text, sh_name text, student_id integer(32,0), student_name text, sentence_count integer(32,0), language text, vector_id bigint(64,0));
COMMENT ON TABLE lib.nsi_essays IS 'Метаданные библиотеки по эссе';
COMMENT ON COLUMN lib.nsi_essays.id IS 'Идентификатор объекта';
COMMENT ON COLUMN lib.nsi_essays.word_count IS 'Количество слов в тексте эссе';
COMMENT ON COLUMN lib.nsi_essays.professor IS 'Имя профессора';
COMMENT ON COLUMN lib.nsi_essays.institution IS 'Название института';
COMMENT ON COLUMN lib.nsi_essays.faculty IS 'Название факультета';
COMMENT ON COLUMN lib.nsi_essays.email IS 'Email для связи';
COMMENT ON COLUMN lib.nsi_essays.date IS 'Дата написания эссе';
COMMENT ON COLUMN lib.nsi_essays.course IS 'Название курса';
COMMENT ON COLUMN lib.nsi_essays.academic_year IS 'Академический год';
COMMENT ON COLUMN lib.nsi_essays.program IS 'Программа курса';
COMMENT ON COLUMN lib.nsi_essays.city IS 'Название города';
COMMENT ON COLUMN lib.nsi_essays.filename IS 'Имя файла в bucket облака с текстом эссе в текстовом формате';
COMMENT ON COLUMN lib.nsi_essays.sh_name IS 'Наименование эссе';
COMMENT ON COLUMN lib.nsi_essays.student_id IS 'Идентификатор студента';
COMMENT ON COLUMN lib.nsi_essays.student_name IS 'Имя слушателя~a2~ если нет его ID';
COMMENT ON COLUMN lib.nsi_essays.sentence_count IS 'Количество предложений';
COMMENT ON COLUMN lib.nsi_essays.language IS 'Код языка документа';
COMMENT ON COLUMN lib.nsi_essays.vector_id IS 'Индекс в FAISS';
ALTER TABLE lib.nsi_essays ADD CONSTRAINT pk_lib_nsi_essays PRIMARY KEY (id);

-- Таблица: lib.nsi_experiments
-- Комментарий: Список экспериментов по работе ИИ с эссе
CREATE TABLE lib.nsi_experiments (id integer(32,0) NOT NULL, sh_name text, count integer(32,0), prompt text, essay text, finished boolean, number integer(32,0), started_at timestamp without time zone, finished_at timestamp without time zone, need_start boolean, error text, in_start boolean);
COMMENT ON TABLE lib.nsi_experiments IS 'Список экспериментов по работе ИИ с эссе';
COMMENT ON COLUMN lib.nsi_experiments.id IS 'Идентификатор объекта';
COMMENT ON COLUMN lib.nsi_experiments.sh_name IS 'Наименование испытания';
COMMENT ON COLUMN lib.nsi_experiments.count IS 'Количество прогонов ИИ с одним промптом и текстом эссе';
COMMENT ON COLUMN lib.nsi_experiments.prompt IS 'Текст промпта ~A~задания для эссе~B~';
COMMENT ON COLUMN lib.nsi_experiments.essay IS 'Текст испытуемого эссе';
COMMENT ON COLUMN lib.nsi_experiments.finished IS 'Признак окончания испытания ~A~эксперимента~B~';
COMMENT ON COLUMN lib.nsi_experiments.number IS 'Номер последнего проведенного испытания ~A~от 1 до count~B~';
COMMENT ON COLUMN lib.nsi_experiments.started_at IS 'Время и дата начала эксперимента ~A~начало первого испытания~B~';
COMMENT ON COLUMN lib.nsi_experiments.finished_at IS 'Время и дата окончания испытания с номером number эксперимента';
COMMENT ON COLUMN lib.nsi_experiments.need_start IS 'Признак начала работы по итерациям';
COMMENT ON COLUMN lib.nsi_experiments.error IS 'Ошибка при работе с экспериментом';
COMMENT ON COLUMN lib.nsi_experiments.in_start IS 'Признак текущей обработки эксперимента';
ALTER TABLE lib.nsi_experiments ADD CONSTRAINT pk_lib_nsi_experiments PRIMARY KEY (id);

-- Таблица: lib.nsi_formats_doc
-- Комментарий: Состав ~A~содержание~B~ выходного документа результатов инспекции эссе
CREATE TABLE lib.nsi_formats_doc (id integer(32,0) NOT NULL, sh_name character varying(50), code character varying(50), sort integer(32,0), checked boolean);
COMMENT ON TABLE lib.nsi_formats_doc IS 'Состав ~A~содержание~B~ выходного документа результатов инспекции эссе';
COMMENT ON COLUMN lib.nsi_formats_doc.id IS 'Идентификатор объекта';
COMMENT ON COLUMN lib.nsi_formats_doc.sh_name IS 'Имя части документа';
COMMENT ON COLUMN lib.nsi_formats_doc.code IS 'Код части документа';
COMMENT ON COLUMN lib.nsi_formats_doc.sort IS 'Порядок сортировки параметров';
COMMENT ON COLUMN lib.nsi_formats_doc.checked IS 'Задание по умолчанию';
ALTER TABLE lib.nsi_formats_doc ADD CONSTRAINT pk_lib_nsi_formats_doc PRIMARY KEY (id);

-- Таблица: lib.nsi_groups_prompts
-- Комментарий: Группы ~A~папки~B~ вопросов ~A~prompt~B~ для AI
CREATE TABLE lib.nsi_groups_prompts (id integer(32,0) NOT NULL, sh_name text);
COMMENT ON TABLE lib.nsi_groups_prompts IS 'Группы ~A~папки~B~ вопросов ~A~prompt~B~ для AI';
COMMENT ON COLUMN lib.nsi_groups_prompts.id IS 'Идентификатор группы';
COMMENT ON COLUMN lib.nsi_groups_prompts.sh_name IS 'Наименование группы';
ALTER TABLE lib.nsi_groups_prompts ADD CONSTRAINT pk_lib_nsi_groups_prompts PRIMARY KEY (id);
CREATE UNIQUE INDEX nsi_groups_prompts_idx ON lib.nsi_groups_prompts USING btree (sh_name);

-- Таблица: lib.nsi_guests
-- Комментарий: Список IP адресов, посещяющих сайт sozd
CREATE TABLE lib.nsi_guests (id integer(32,0) NOT NULL, country character varying(50), city character varying(50), _delete boolean, sh_name text);
COMMENT ON TABLE lib.nsi_guests IS 'Список IP адресов, посещяющих сайт sozd';
COMMENT ON COLUMN lib.nsi_guests.id IS 'Идентификатор объекта';
COMMENT ON COLUMN lib.nsi_guests.country IS 'Наименование страны IP';
COMMENT ON COLUMN lib.nsi_guests.city IS 'Название города IP';
COMMENT ON COLUMN lib.nsi_guests._delete IS 'Flag for deleting an object';
COMMENT ON COLUMN lib.nsi_guests.sh_name IS 'IP посетителя';
ALTER TABLE lib.nsi_guests ADD CONSTRAINT pk_lib_nsi_guests PRIMARY KEY (id);
CREATE UNIQUE INDEX nsi_guests_idx ON lib.nsi_guests USING btree (sh_name);

-- Таблица: lib.nsi_his_experiments
-- Комментарий: История проведения испытаний экспериментов
CREATE TABLE lib.nsi_his_experiments (id integer(32,0) NOT NULL, sh_name character varying(50), experiment integer(32,0), number integer(32,0), mark real, answer text, count_output integer(32,0), started_at timestamp without time zone, finished_at timestamp without time zone);
COMMENT ON TABLE lib.nsi_his_experiments IS 'История проведения испытаний экспериментов';
COMMENT ON COLUMN lib.nsi_his_experiments.id IS 'Идентификатор объекта';
COMMENT ON COLUMN lib.nsi_his_experiments.sh_name IS 'Наименование объекта';
COMMENT ON COLUMN lib.nsi_his_experiments.experiment IS 'Идентификатор эксперимента испытания';
COMMENT ON COLUMN lib.nsi_his_experiments.number IS 'Номер испытания в эксперименте';
COMMENT ON COLUMN lib.nsi_his_experiments.mark IS 'Оценка эссе~a2~ данная ИИ в текущем испытании эксперимента';
COMMENT ON COLUMN lib.nsi_his_experiments.answer IS 'Текст ответа ИИ в испытании с номером number';
COMMENT ON COLUMN lib.nsi_his_experiments.count_output IS 'Количество токенов в тексте отзыва ИИ';
COMMENT ON COLUMN lib.nsi_his_experiments.started_at IS 'Время и дата начала испытания с номером number';
COMMENT ON COLUMN lib.nsi_his_experiments.finished_at IS 'Время и дата окончания испытания с номером number';
ALTER TABLE lib.nsi_his_experiments ADD CONSTRAINT pk_lib_nsi_his_experiments PRIMARY KEY (id);

-- Таблица: lib.nsi_his_inspection
-- Комментарий: История инспекций эссе всеми профессорами
CREATE TABLE lib.nsi_his_inspection (id integer(32,0) NOT NULL, sh_name character varying(50), at_date_time timestamp without time zone, inspector integer(32,0) NOT NULL, filename text, degree text, mood text, group_prompts integer(32,0) NOT NULL, essay integer(32,0) NOT NULL, mark integer(32,0), error text, fmt character varying(10), avg_mark real, lang text, human_recall text, human_recall_en text, answer_gpt text);
COMMENT ON TABLE lib.nsi_his_inspection IS 'История инспекций эссе всеми профессорами';
COMMENT ON COLUMN lib.nsi_his_inspection.id IS 'Идентификатор объекта';
COMMENT ON COLUMN lib.nsi_his_inspection.sh_name IS 'Наименование объекта';
COMMENT ON COLUMN lib.nsi_his_inspection.at_date_time IS 'Время инспекции эссе';
COMMENT ON COLUMN lib.nsi_his_inspection.inspector IS 'Ссылка на профессора~a2~ проводящего инспекцию';
COMMENT ON COLUMN lib.nsi_his_inspection.filename IS 'Имя файла~a2~ который был инспектирован';
COMMENT ON COLUMN lib.nsi_his_inspection.degree IS 'Название академической степени на которую претендует эссе';
COMMENT ON COLUMN lib.nsi_his_inspection.mood IS 'Степень строгости подхода к оценке эссе';
COMMENT ON COLUMN lib.nsi_his_inspection.group_prompts IS 'Ссылка на группу промптов~a2~ которая использовалась при инспекции';
COMMENT ON COLUMN lib.nsi_his_inspection.essay IS 'Ссылка на эссе';
COMMENT ON COLUMN lib.nsi_his_inspection.mark IS 'Оценка инспектирующего по работе ИИ в оценке эссе';
COMMENT ON COLUMN lib.nsi_his_inspection.error IS 'Текст возможной ошибки';
COMMENT ON COLUMN lib.nsi_his_inspection.fmt IS 'Формат файла результат инспекции';
COMMENT ON COLUMN lib.nsi_his_inspection.avg_mark IS 'Средняя оценка эссе~a2~ сделанная ИИ';
COMMENT ON COLUMN lib.nsi_his_inspection.lang IS 'Язык общения~a2~ использованный пользователем';
COMMENT ON COLUMN lib.nsi_his_inspection.human_recall IS 'Отзыв на эссе~a2~ данный человеком ~A~на любом языке~B~';
COMMENT ON COLUMN lib.nsi_his_inspection.human_recall_en IS 'Текст отзыва человека на английском языке';
COMMENT ON COLUMN lib.nsi_his_inspection.answer_gpt IS 'Текст ответа ChatGPT на проведенную инспекцию';
ALTER TABLE lib.nsi_his_inspection ADD CONSTRAINT pk_lib_nsi_his_inspection PRIMARY KEY (id);

-- Таблица: lib.nsi_inspectors
-- Комментарий: Список инспекторов ~A~профессоров~B~~a2~ проверяющих эссе
CREATE TABLE lib.nsi_inspectors (id integer(32,0) NOT NULL, sh_name text, insert_at timestamp without time zone, last_at timestamp without time zone, user_id integer(32,0), email text, max_count integer(32,0), name text);
COMMENT ON TABLE lib.nsi_inspectors IS 'Список инспекторов ~A~профессоров~B~~a2~ проверяющих эссе';
COMMENT ON COLUMN lib.nsi_inspectors.id IS 'Идентификатор объекта';
COMMENT ON COLUMN lib.nsi_inspectors.sh_name IS 'Имя инспектора';
COMMENT ON COLUMN lib.nsi_inspectors.insert_at IS 'Дата и время начала инспектирования эссе профессором ';
COMMENT ON COLUMN lib.nsi_inspectors.last_at IS 'Время и дата последней инспекции эссе профессором';
COMMENT ON COLUMN lib.nsi_inspectors.user_id IS 'Идентификатор пользователе в ТЕЛЕГРАМ';
COMMENT ON COLUMN lib.nsi_inspectors.email IS 'Имя пользователя~a2~ работавшего из вэб-сайта';
COMMENT ON COLUMN lib.nsi_inspectors.max_count IS 'Ограничение количества инспекций для инспектора ~A~0 - нет ограничения~B~';
COMMENT ON COLUMN lib.nsi_inspectors.name IS 'Имя инспектора в ТГ ~A~user~a9~name~B~';
ALTER TABLE lib.nsi_inspectors ADD CONSTRAINT pk_lib_nsi_inspectors PRIMARY KEY (id);

-- Таблица: lib.nsi_libgen
-- Комментарий: Каталог научных публикаций в Lib Genezis  ~A~scimag~B~
CREATE TABLE lib.nsi_libgen (id integer(32,0) NOT NULL, sh_name text, id_libgen integer(32,0), doi text, authors text, year integer(32,0), month text, day integer(32,0), volume integer(32,0), issue integer(32,0), first_page integer(32,0), last_page integer(32,0), journal text, md5_hash text, size_in_bytes integer(32,0), at_date_time timestamp without time zone, pubmed_id text, pii text);
COMMENT ON TABLE lib.nsi_libgen IS 'Каталог научных публикаций в Lib Genezis  ~A~scimag~B~';
COMMENT ON COLUMN lib.nsi_libgen.id IS 'Идентификатор объекта';
COMMENT ON COLUMN lib.nsi_libgen.sh_name IS 'Наименование объекта';
COMMENT ON COLUMN lib.nsi_libgen.id_libgen IS 'Идентификатор в базе данных LibGen';
COMMENT ON COLUMN lib.nsi_libgen.doi IS 'Идентификатор~a2~ описывающий публикацию ~A~служит для скачивания текста публикации~B~';
COMMENT ON COLUMN lib.nsi_libgen.authors IS 'Список авторов публикации';
COMMENT ON COLUMN lib.nsi_libgen.year IS 'Год публикации';
COMMENT ON COLUMN lib.nsi_libgen.month IS 'Месяц публикации';
COMMENT ON COLUMN lib.nsi_libgen.day IS 'День публикации';
COMMENT ON COLUMN lib.nsi_libgen.volume IS 'Номер тома';
COMMENT ON COLUMN lib.nsi_libgen.issue IS 'Номер выпуска';
COMMENT ON COLUMN lib.nsi_libgen.first_page IS 'Первая страница публикации';
COMMENT ON COLUMN lib.nsi_libgen.last_page IS 'Последняя страница публикации';
COMMENT ON COLUMN lib.nsi_libgen.journal IS 'Название журнала публикации';
COMMENT ON COLUMN lib.nsi_libgen.md5_hash IS 'Уникальный идентификатор файла~a2~ построенный по его содержимому.~R~~LF~Проверка целостности файлов~R~~LF~Если у файла тот же MD5~a2~ значит~a2~ он не был изменён.~R~~LF~~R~~LF~Поиск и идентификация~R~~LF~Хеши позволяют быстро сравнивать данные ~A~например~a2~ в LibGen — для поиска одинаковых книг~b1~статей~B~.~R~~LF~~R~~LF~Идентификаторы~R~~LF~Например~a2~ можно использовать md5~A~email~B~ для уникального~a2~ но анонимного ID.~R~~LF~~R~~LF~Индексация в базах данных ~A~как ключ~B~';
COMMENT ON COLUMN lib.nsi_libgen.size_in_bytes IS 'Длина текста публикации в байтах';
COMMENT ON COLUMN lib.nsi_libgen.at_date_time IS 'Дата и время появления в библиотеке';
COMMENT ON COLUMN lib.nsi_libgen.pubmed_id IS 'Идентификатор публикации в pubmed';
COMMENT ON COLUMN lib.nsi_libgen.pii IS 'Идентификатор статьи у издателей';
ALTER TABLE lib.nsi_libgen ADD CONSTRAINT pk_lib_nsi_libgen PRIMARY KEY (id);

-- Таблица: lib.nsi_metadata
CREATE TABLE lib.nsi_metadata (id integer(32,0) NOT NULL, title text, volumeinfo text, series text, periodical text, author text, year text, edition text, publisher text, city text, pages text, pagesinfile integer(32,0), language text, topic text, library text, issue text, identifier text, issn text, asin text, udc text, lbc text, ddc text, lcc text, doi text, googlebookid text, openlibraryid text, commentary text, dpi integer(32,0), color text, cleaned text, orientation text, paginated text, scanned text, bookmarked text);
ALTER TABLE lib.nsi_metadata ADD CONSTRAINT nsi_metadata_pkey PRIMARY KEY (id);

-- Таблица: lib.nsi_operations
-- Комментарий: Список операций вэба~a2~ для которых задается доступ  по видам ролей
CREATE TABLE lib.nsi_operations (id integer(32,0) NOT NULL, sh_name text, code text);
COMMENT ON TABLE lib.nsi_operations IS 'Список операций вэба~a2~ для которых задается доступ  по видам ролей';
COMMENT ON COLUMN lib.nsi_operations.id IS 'Идентификатор операции в вэбе';
COMMENT ON COLUMN lib.nsi_operations.sh_name IS 'Имя операции в вэбе';
COMMENT ON COLUMN lib.nsi_operations.code IS 'Код операции';
ALTER TABLE lib.nsi_operations ADD CONSTRAINT pk_lib_nsi_operations PRIMARY KEY (id);
CREATE UNIQUE INDEX nsi_operations_idx ON lib.nsi_operations USING btree (code);

-- Таблица: lib.nsi_prompt_gpt
-- Комментарий: Вопросы ~A~промпты~B~ для ChatGPT для групп вопросов инспекции
CREATE TABLE lib.nsi_prompt_gpt (id integer(32,0) NOT NULL, sh_name character varying(50), prompt text, group_id integer(32,0));
COMMENT ON TABLE lib.nsi_prompt_gpt IS 'Вопросы ~A~промпты~B~ для ChatGPT для групп вопросов инспекции';
COMMENT ON COLUMN lib.nsi_prompt_gpt.id IS 'Идентификатор объекта';
COMMENT ON COLUMN lib.nsi_prompt_gpt.sh_name IS 'Наименование объекта';
COMMENT ON COLUMN lib.nsi_prompt_gpt.prompt IS 'Текст вопроса';
COMMENT ON COLUMN lib.nsi_prompt_gpt.group_id IS 'Ссылка на группу вопросов~a2~ привязанных для вопроса GPT';
ALTER TABLE lib.nsi_prompt_gpt ADD CONSTRAINT pk_lib_nsi_prompt_gpt PRIMARY KEY (id);

-- Таблица: lib.nsi_prompts
-- Комментарий: Список вопросов для ИИ по анализу эссе
CREATE TABLE lib.nsi_prompts (id integer(32,0) NOT NULL, sh_name character varying(50), prompt text);
COMMENT ON TABLE lib.nsi_prompts IS 'Список вопросов для ИИ по анализу эссе';
COMMENT ON COLUMN lib.nsi_prompts.id IS 'Идентификатор объекта';
COMMENT ON COLUMN lib.nsi_prompts.sh_name IS 'Имя вопроса';
COMMENT ON COLUMN lib.nsi_prompts.prompt IS 'Текст вопроса на английском языке';
ALTER TABLE lib.nsi_prompts ADD CONSTRAINT pk_lib_nsi_prompts PRIMARY KEY (id);
CREATE UNIQUE INDEX nsi_prompts_idx ON lib.nsi_prompts USING btree (sh_name);

-- Таблица: lib.nsi_roles_vid
-- Комментарий: Список ролей пользователей вэба
CREATE TABLE lib.nsi_roles_vid (id integer(32,0) NOT NULL, sh_name text, vid text);
COMMENT ON TABLE lib.nsi_roles_vid IS 'Список ролей пользователей вэба';
COMMENT ON COLUMN lib.nsi_roles_vid.id IS 'Идентификатор объекта';
COMMENT ON COLUMN lib.nsi_roles_vid.sh_name IS 'Наименование объекта';
COMMENT ON COLUMN lib.nsi_roles_vid.vid IS 'Вид роли';
ALTER TABLE lib.nsi_roles_vid ADD CONSTRAINT pk_lib_nsi_roles_vid PRIMARY KEY (id);
CREATE UNIQUE INDEX nsi_roles_vid_idx ON lib.nsi_roles_vid USING btree (vid);

-- Таблица: lib.rel_books_courses_course
CREATE TABLE lib.rel_books_courses_course (books_id integer(32,0) NOT NULL, courses_id integer(32,0) NOT NULL);
CREATE UNIQUE INDEX rel_books_courses_course_idx ON lib.rel_books_courses_course USING btree (books_id, courses_id);

-- Таблица: lib.rel_operations_roles_vid_pravo
CREATE TABLE lib.rel_operations_roles_vid_pravo (operations_id integer(32,0) NOT NULL, roles_vid_id integer(32,0) NOT NULL);
CREATE UNIQUE INDEX rel_operations_roles_vid_pravo_idx ON lib.rel_operations_roles_vid_pravo USING btree (operations_id, roles_vid_id);

-- Таблица: lib.rel_prompts_groups_prompts_group
CREATE TABLE lib.rel_prompts_groups_prompts_group (prompts_id integer(32,0) NOT NULL, groups_prompts_id integer(32,0) NOT NULL);
CREATE UNIQUE INDEX rel_prompts_groups_prompts_group_idx ON lib.rel_prompts_groups_prompts_group USING btree (prompts_id, groups_prompts_id);

-- Таблица: lib.table_depend
CREATE TABLE lib.table_depend (name text, rang integer(32,0), dop text);

-- Таблица: lib.table_dependencies
CREATE TABLE lib.table_dependencies (from_table text NOT NULL, to_table text NOT NULL);

-- Таблица: lib.table_dependencies_ordered
CREATE TABLE lib.table_dependencies_ordered (table_name text NOT NULL, dependency_level integer(32,0) NOT NULL);
ALTER TABLE lib.table_dependencies_ordered ADD CONSTRAINT table_dependencies_ordered_pkey PRIMARY KEY (table_name);

-- Таблица: lib.temp_table_depend
CREATE TABLE lib.temp_table_depend (code_ref text, typeobj_code text);

-- Таблица: lib.topics
CREATE TABLE lib.topics (id integer(32,0) NOT NULL, topic_descr character varying(500) NOT NULL, lang character varying(2) NOT NULL, kolxoz_code character varying(10) NOT NULL, topic_id integer(32,0), topic_id_hl integer(32,0));
ALTER TABLE lib.topics ADD CONSTRAINT topics_pkey PRIMARY KEY (id);

-- Таблица: lib.updated
CREATE TABLE lib.updated (id integer(32,0) NOT NULL, title character varying(2000), volume_info character varying(100), series character varying(300), periodical character varying(200), author character varying(1000), year character varying(14), edition character varying(60), publisher character varying(400), city character varying(100), pages character varying(100), pages_in_file integer(32,0) NOT NULL, language character varying(150), topic character varying(500), library character varying(50), issue character varying(100), identifier character varying(300), issn character varying(9), asin character varying(200), udc character varying(200), lbc character varying(200), ddc character varying(45), lcc character varying(45), doi character varying(45), googlebookid character varying(45), open_library_id character varying(200), commentary character varying(10000), dpi integer(32,0), color character varying(1), cleaned character varying(1), orientation character varying(1), paginated character varying(1), scanned character varying(1), bookmarked character varying(1), searchable character varying(1), filesize bigint(64,0) NOT NULL, extension character varying(50), md5 character(32), generic character(32), visible character(3), locator character varying(733), local integer(32,0), time_added timestamp without time zone NOT NULL, time_last_modified timestamp without time zone NOT NULL, coverurl character varying(200), tags character varying(500), identifier_wodash character varying(300));
ALTER TABLE lib.updated ADD CONSTRAINT updated_pkey PRIMARY KEY (id);

-- Внешние ключи
ALTER TABLE lib.his_guests_page ADD CONSTRAINT his_guests_page_fk FOREIGN KEY (guests_id) REFERENCES lib.nsi_guests (id);
ALTER TABLE lib.link_guests ADD CONSTRAINT lib_link_guests_fk2 FOREIGN KEY (id) REFERENCES lib.nsi_guests (id);
ALTER TABLE lib.nsi_answers_ai ADD CONSTRAINT lib_nsi_answers_ai_fk1 FOREIGN KEY (prompt) REFERENCES lib.nsi_prompts (id);
ALTER TABLE lib.nsi_his_experiments ADD CONSTRAINT lib_nsi_his_experiments_fk1 FOREIGN KEY (experiment) REFERENCES lib.nsi_experiments (id);
ALTER TABLE lib.nsi_his_inspection ADD CONSTRAINT lib_nsi_his_inspection_fk1 FOREIGN KEY (inspector) REFERENCES lib.nsi_inspectors (id);
ALTER TABLE lib.nsi_his_inspection ADD CONSTRAINT lib_nsi_his_inspection_fk2 FOREIGN KEY (group_prompts) REFERENCES lib.nsi_groups_prompts (id);
ALTER TABLE lib.nsi_prompt_gpt ADD CONSTRAINT lib_nsi_prompt_gpt_fk1 FOREIGN KEY (group_id) REFERENCES lib.nsi_groups_prompts (id);
ALTER TABLE lib.rel_books_courses_course ADD CONSTRAINT books_fk FOREIGN KEY (books_id) REFERENCES lib.nsi_books (id);
ALTER TABLE lib.rel_books_courses_course ADD CONSTRAINT books_fk_1 FOREIGN KEY (courses_id) REFERENCES lib.nsi_courses (id);
ALTER TABLE lib.rel_operations_roles_vid_pravo ADD CONSTRAINT operations_fk FOREIGN KEY (operations_id) REFERENCES lib.nsi_operations (id);
ALTER TABLE lib.rel_operations_roles_vid_pravo ADD CONSTRAINT operations_fk_1 FOREIGN KEY (roles_vid_id) REFERENCES lib.nsi_roles_vid (id);
ALTER TABLE lib.rel_prompts_groups_prompts_group ADD CONSTRAINT prompts_fk FOREIGN KEY (prompts_id) REFERENCES lib.nsi_prompts (id);
ALTER TABLE lib.rel_prompts_groups_prompts_group ADD CONSTRAINT prompts_fk_1 FOREIGN KEY (groups_prompts_id) REFERENCES lib.nsi_groups_prompts (id);