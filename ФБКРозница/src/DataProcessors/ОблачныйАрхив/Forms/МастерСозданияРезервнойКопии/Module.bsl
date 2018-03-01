#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	Если НЕ ОблачныйАрхивПовтИсп.РазрешенаРаботаСОблачнымАрхивом() Тогда
		Отказ = Истина;
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;

	Если ОбщегоНазначенияКлиентСервер.ЭтоВебКлиент() Тогда
		Отказ = Истина;
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;

	ЕстьОшибки = Ложь;
	ВремяНачала = ТекущаяУниверсальнаяДатаВМиллисекундах();
	КонтекстВыполнения = ИнтернетПоддержкаПользователейКлиентСервер.НоваяЗаписьРезультатовВыполненияОпераций();
	ИдентификаторИБ = "";
	ИдентификаторИБ_Полный = "";

	// 1. Собрать данные о клиентском компьютере.
#Область СборДанных

	ИнтернетПоддержкаПользователейКлиентСервер.НачатьРегистрациюРезультатаВыполненияОперации(
		КонтекстВыполнения,
		"ОблачныйАрхив.СозданиеФайлаРезервнойКопии.Инициализация.СборДанных",
		НСтр("ru='Сбор данных о настройках'"));
	КодРезультата = 0;
	ОписаниеРезультата = "";

		// Сбор информации запускается сразу, а не фоновым заданием.
		ЗагрузитьСтатистику(300);

	ИнтернетПоддержкаПользователейКлиентСервер.ЗавершитьРегистрациюРезультатаВыполненияОперации(
		КонтекстВыполнения,
		КодРезультата,
		ОписаниеРезультата,
		Неопределено);
#КонецОбласти

	// 2. Анализ возможности запуска.
#Область ПроверкаВозможностиСозданияРезервнойКопии

	// 2.1. Проанализировать данные клиентского компьютера.
#Область ПроверкаВозможностиСозданияРезервнойКопии_НастройкиКлиентскогоКомпьютера
	// Получить настройки клиента (путь расположения файлов настроек).
	// Для файл-серверного режима клиент и сервер выполняются на одном компьютере.

	ИнтернетПоддержкаПользователейКлиентСервер.НачатьРегистрациюРезультатаВыполненияОперации(
		КонтекстВыполнения,
		"ОблачныйАрхив.СозданиеФайлаРезервнойКопии.Инициализация.АнализДанных.ИнформацияОКомпьютере",
		НСтр("ru='Информация о клиентском компьютере'"));
	КодРезультата = 0;
	ОписаниеРезультата = "";

		ИнформацияОКлиенте = ОблачныйАрхив.ПолучитьНастройкиОблачногоАрхива("ИнформацияОКлиенте", ИмяКомпьютера());
		АктивацииАгентовКопирования = ОблачныйАрхив.ПолучитьНастройкиОблачногоАрхива("АктивацииАгентовКопирования", ИмяКомпьютера());
		Если (ИнформацияОКлиенте.АгентКопированияУстановлен = Истина)
				И (ИнформацияОКлиенте.АгентКопированияАктивирован_ЕстьФайлыСертификатов = Истина)
				И (АктивацииАгентовКопирования.АгентКопированияАктивирован_ДанныеВебСервисов = Истина) Тогда
			ЭтотОбъект.КаталогУстановкиАгентаКопирования = ИнформацияОКлиенте.КаталогУстановкиАгентаКопирования;
			// Текущая версия клиента не устарела? ////! Реализовать.
		Иначе
			ЕстьОшибки = Истина;
			КодРезультата = 1101;
			ОписаниеРезультата =
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru='На этом компьютере (идентификатор: %1) невозможно работать с Агентом резервного копирования:
						|%2
						|%3
						|%4
						|%5'"),
					ИнформацияОКлиенте.ИдентификаторКомпьютера,
					?(ИнформацияОКлиенте.АгентКопированияУстановлен = Истина,
						" - " + НСтр("ru='Агент резервного копирования установлен'"),
						" - " + НСтр("ru='Агент резервного копирования НЕ установлен'")),
					?(ИнформацияОКлиенте.АгентКопированияАктивирован_ЕстьФайлыСертификатов = Истина,
						" - " + НСтр("ru='Файлы сертификатов загружены'"),
						" - " + НСтр("ru='Файлы сертификатов НЕ загружены (агент не активирован)'")),
					?(АктивацииАгентовКопирования.АгентКопированияАктивирован_ДанныеВебСервисов = Истина,
						" - " + НСтр("ru='Агент резервного копирования активирован на текущий логин'"),
						" - " + НСтр("ru='Агент резервного копирования НЕ активирован на текущий логин'")),
					?(АктивацииАгентовКопирования.АгентКопированияАктивированНаДругойЛогин = Истина,
						" - " + НСтр("ru='Агент резервного копирования активирован на другой логин'"),
						" - " + НСтр("ru='Агент резервного копирования НЕ активирован на другой логин'")));
		КонецЕсли;

	ИнтернетПоддержкаПользователейКлиентСервер.ЗавершитьРегистрациюРезультатаВыполненияОперации(
		КонтекстВыполнения,
		КодРезультата,
		ОписаниеРезультата,
		Неопределено);
#КонецОбласти

	// 2.2. В облачном хранилище достаточно места?
#Область ПроверкаВозможностиСозданияРезервнойКопии_НастройкиКлиентскогоКомпьютера
	//  Т.к. предсказать размер архива невозможно, то считаем, что должно быть свободно хотя бы 10 МБайт.
	ИнтернетПоддержкаПользователейКлиентСервер.НачатьРегистрациюРезультатаВыполненияОперации(
		КонтекстВыполнения,
		"ОблачныйАрхив.СозданиеФайлаРезервнойКопии.Инициализация.АнализДанных.ОстатокСвободногоМеста",
		НСтр("ru='Проверка свободного места в облачном хранилище'"));
	КодРезультата = 0;
	ОписаниеРезультата = "";

		БайтКуплено     = 0;
		БайтДоступно    = 0;
		ПроцентДоступно = "0%";

		Запись = РегистрыСведений.СвойстваХранилищаОблачногоАрхива.СоздатьМенеджерЗаписи();
		Запись.Свойство = "Объем байт, куплено"; // Идентификатор
		Запись.Прочитать(); // Только чтение, без последующей записи.
		Если Запись.Выбран() Тогда
			БайтКуплено = Запись.Значение;
		КонецЕсли;

		Запись = РегистрыСведений.СвойстваХранилищаОблачногоАрхива.СоздатьМенеджерЗаписи();
		Запись.Свойство = "Объем байт, доступно"; // Идентификатор
		Запись.Прочитать(); // Только чтение, без последующей записи.
		Если Запись.Выбран() Тогда
			БайтДоступно = Запись.Значение;
		КонецЕсли;

		Если БайтКуплено > 0 Тогда
			ПроцентДоступно = "" + Окр(БайтДоступно / БайтКуплено * 100, 0, РежимОкругления.Окр15как20) + "%";
		КонецЕсли;

		ОписаниеРезультата = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Состояние облачного хранилища:
				|Куплено: %1 байт (%2 Мбайт, %3 Гбайт)
				|Доступно %4 байт (%5 Мбайт, %6 Гбайт)'"),
			Формат(БайтКуплено, "ЧЦ=20; ЧДЦ=; ЧРГ=' '; ЧН=0; ЧГ=3,0"),
			Формат(БайтКуплено, "ЧЦ=20; ЧДЦ=2; ЧС=6; ЧРД=,; ЧРГ=' '; ЧН=0,00; ЧГ=3,0"),
			Формат(БайтКуплено, "ЧЦ=20; ЧДЦ=2; ЧС=9; ЧРД=,; ЧРГ=' '; ЧН=0,00; ЧГ=3,0"),
			Формат(БайтДоступно, "ЧЦ=20; ЧДЦ=; ЧРГ=' '; ЧН=0; ЧГ=3,0"),
			Формат(БайтДоступно, "ЧЦ=20; ЧДЦ=2; ЧС=6; ЧРД=,; ЧРГ=' '; ЧН=0,00; ЧГ=3,0"),
			Формат(БайтДоступно, "ЧЦ=20; ЧДЦ=2; ЧС=9; ЧРД=,; ЧРГ=' '; ЧН=0,00; ЧГ=3,0"));
		Если БайтДоступно < 10*1024*1024 Тогда
			// Не считаем данное состояние ошибкой (это только предупреждение),
			//  т.к. только пользователь может определить - хватает ли ему места для копии или нет.
			КодРезультата = 1103;
			ОписаниеРезультата = ОписаниеРезультата + Символы.ПС + Символы.ПС
				+ НСтр("ru='В облачном хранилище недостаточно места для создания резервной копии (менее 10 МБайт).'");
		КонецЕсли;

		Элементы.ДекорацияСтатистика.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Всего доступно %1 из %2 Мбайт (%3)'"),
			Формат(БайтДоступно, "ЧЦ=20; ЧДЦ=; ЧС=6; ЧН=0; ЧГ=3,0"),
			Формат(БайтКуплено, "ЧЦ=20; ЧДЦ=; ЧС=6; ЧН=0; ЧГ=3,0"),
			ПроцентДоступно);

	ИнтернетПоддержкаПользователейКлиентСервер.ЗавершитьРегистрациюРезультатаВыполненияОперации(
		КонтекстВыполнения,
		КодРезультата,
		ОписаниеРезультата,
		Неопределено);
#КонецОбласти

#КонецОбласти

	// 3. Получение общих настроек (идентификатор ИБ).
#Область ПолучениеОбщихНастроек
	ИнтернетПоддержкаПользователейКлиентСервер.НачатьРегистрациюРезультатаВыполненияОперации(
		КонтекстВыполнения,
		"ОблачныйАрхив.СозданиеФайлаРезервнойКопии.Инициализация.ЧтениеНастроек.ОбщиеНастройки",
		НСтр("ru='Чтение общих настроек'"));
	КодРезультата = 0;
	ОписаниеРезультата = "";

		ПараметрыОкруженияСервер = ОблачныйАрхив.ПолучитьНастройкиОблачногоАрхива("ПараметрыОкруженияСервер");
		ИдентификаторИБ = ПараметрыОкруженияСервер.ИдентификаторИБ;
		ИдентификаторИБ_Полный =
			ИдентификаторИБ
				+ ОблачныйАрхивКлиентСервер.ПолучитьОписаниеСуффиксовИдентификаторовИБ().РучнаяКопия.Суффикс;

	ИнтернетПоддержкаПользователейКлиентСервер.ЗавершитьРегистрациюРезультатаВыполненияОперации(
		КонтекстВыполнения,
		КодРезультата,
		ОписаниеРезультата,
		Неопределено);
#КонецОбласти

	// 4. Чтение настроек Агента резервного копирования.
#Область ЧтениеНастроекАгентаРезервногоКопирования
	ИнтернетПоддержкаПользователейКлиентСервер.НачатьРегистрациюРезультатаВыполненияОперации(
		КонтекстВыполнения,
		"ОблачныйАрхив.СозданиеФайлаРезервнойКопии.Инициализация.ЧтениеНастроек.НастройкиАгента",
		НСтр("ru='Чтение настроек агента резервного копирования'"));
	КодРезультата = 0;
	ОписаниеРезультата = "";

		НастройкиАгентаКопированияКлиент = ОблачныйАрхив.ПолучитьНастройкиОблачногоАрхива("НастройкиАгентаКопированияКлиент", ИмяКомпьютера());
		КаталогРабочий = НастройкиАгентаКопированияКлиент.КаталогРабочий;

		ЭтотОбъект.ИмяФайлаНастроекИБ = "";
		КаталогНастроекИБ = 
			НастройкиАгентаКопированияКлиент.КаталогРабочий
			+ ПолучитьРазделительПути()
			+ ИдентификаторИБ_Полный;
		МаскаФайлаНастроекИБ = "*_backupConfig.xml";
		МассивНайденныхФайлов = НайтиФайлы(КаталогНастроекИБ, МаскаФайлаНастроекИБ, Ложь);
		Если МассивНайденныхФайлов.Количество() >= 1 Тогда
			// Взять самый последний файл.
			ФайлНастроекИБ = МассивНайденныхФайлов.Получить(МассивНайденныхФайлов.Количество() - 1);
			Если ФайлНастроекИБ.Существует() Тогда
				ЭтотОбъект.ИмяФайлаНастроекИБ = ФайлНастроекИБ.ПолноеИмя;
			КонецЕсли;
		КонецЕсли;

		ОписаниеРезультата = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Чтение настроек Агента резервного копирования:
				|Рабочий каталог: %1
				|Идентификатор ИБ: %2
				|Имя файла настроек: %3'"),
			КаталогРабочий,
			ИдентификаторИБ_Полный,
			ЭтотОбъект.ИмяФайлаНастроекИБ);

	ИнтернетПоддержкаПользователейКлиентСервер.ЗавершитьРегистрациюРезультатаВыполненияОперации(
		КонтекстВыполнения,
		КодРезультата,
		ОписаниеРезультата,
		Неопределено);
#КонецОбласти

	// 5. Чтение списка резервных копий.
#Область ЧтениеСпискаРезервныхКопий
	ИнтернетПоддержкаПользователейКлиентСервер.НачатьРегистрациюРезультатаВыполненияОперации(
		КонтекстВыполнения,
		"ОблачныйАрхив.СозданиеФайлаРезервнойКопии.Инициализация.ЧтениеНастроек.ЧтениеСпискаРезервныхКопий",
		НСтр("ru='Анализ списка резервных копий'"));
	КодРезультата = 0;
	ОписаниеРезультата = "";

		ДатаПоследнегоРезервногоКопирования = '00010101';
		Запрос = Новый Запрос;
		Запрос.Текст = "
			|ВЫБРАТЬ ПЕРВЫЕ 1
			|	Рег.ДатаСоздания КАК ДатаСоздания,
			|	Рег.РазмерФайла  КАК РазмерФайла
			|ИЗ
			|	РегистрСведений.РезервныеКопииОблачногоАрхива КАК Рег
			|ГДЕ
			|	Рег.ИдентификаторИБ ПОДОБНО ""&ИдентификаторИБ""
			|УПОРЯДОЧИТЬ ПО
			|	ДатаСоздания УБЫВ
			|";
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ИдентификаторИБ", ИдентификаторИБ + "%");

		РезультатЗапроса = Запрос.Выполнить();
		Если НЕ РезультатЗапроса.Пустой() Тогда
			Выборка = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.Прямой);
			Если Выборка.Следующий() Тогда
				ДатаПоследнегоРезервногоКопирования = Выборка.ДатаСоздания;
			КонецЕсли;
		КонецЕсли;

		Если ДатаПоследнегоРезервногоКопирования = '00010101' Тогда
			ТекстЗаголовка = НСтр("ru = 'Резервное копирование еще ни разу не проводилось'");
		Иначе
			ТекстЗаголовка =
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'В последний раз резервное копирование проводилось: %1'"),
					Формат(ДатаПоследнегоРезервногоКопирования, "ДЛФ=ДДВ"));
		КонецЕсли;
		Элементы.ДекорацияДатаПроведенияПоследнегоРезервногоКопирования.Заголовок = ТекстЗаголовка;

		ОписаниеРезультата = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Анализ списка резервных копий:
				|Идентификатор ИБ: %1
				|Дата самой последней резервной копии: %2'"),
			ИдентификаторИБ + "*",
			ДатаПоследнегоРезервногоКопирования);

	ИнтернетПоддержкаПользователейКлиентСервер.ЗавершитьРегистрациюРезультатаВыполненияОперации(
		КонтекстВыполнения,
		КодРезультата,
		ОписаниеРезультата,
		Неопределено);
#КонецОбласти

	// 6. Настройки Авторизации.
#Область ПараметрыАвторизацииИПП

	// Не устанавливать привилегированный режим, чтобы читать / сохранять эти настройки мог только полноправный пользователь.
	ПараметрыАвторизацииИПП = ОблачныйАрхив.ПолучитьНастройкиОблачногоАрхива("ПараметрыАвторизацииИПП");
	ЭтотОбъект.Логин = ПараметрыАвторизацииИПП.Логин;

#КонецОбласти

	ЭтотОбъект.КаталогИБ = ОбщегоНазначенияКлиентСервер.КаталогФайловойИнформационнойБазы();
	ЭтотОбъект.КаталогИБ = ОблачныйАрхивКлиентСервер.ПривестиИмяКаталогаКПолномуВиду(ЭтотОбъект.КаталогИБ);

	ВремяОкончания = ТекущаяУниверсальнаяДатаВМиллисекундах();
	ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='Создание резервной копии, инициализация формы, завершение.
			|Время начала (мс): %1
			|Время окончания (мс): %2
			|Длительность (мс): %3
			|Результат выполнения:
			|%4'")
			+ Символы.ПС,
		ВремяНачала,
		ВремяОкончания,
		ВремяОкончания - ВремяНачала,
		ИнтернетПоддержкаПользователейКлиентСервер.ПредставлениеЗаписиРезультатовВыполненияОпераций(
			КонтекстВыполнения,
			Истина, // ВключаяВложенные
			"ПодробноПоШагам",
			1));

	// Запись в журнал регистрации.
	ИнтернетПоддержкаПользователей.ЗаписатьСообщениеВЖурналРегистрации(
		НСтр("ru='БИП:ОблачныйАрхив.Сервис и регламент'"), // Имя события
		НСтр("ru='Облачный архив. Сервис и регламент. Резервное копирование. Инициализация'"), // ИмяСобытия
		УровеньЖурналаРегистрации.Информация, // УровеньЖурналаРегистрации.*
		, // ОбъектМетаданных
		(ВремяОкончания - ВремяНачала), // Данные
		ТекстСообщения, // Комментарий
		ОблачныйАрхивПовтИсп.ВестиПодробныйЖурналРегистрации()); // ВестиПодробныйЖурналРегистрации

	Если ЕстьОшибки = Истина Тогда
		// Если есть ошибки, то сразу открыть страницу с ошибками.
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаОшибка;
	Иначе
		// Если нет ошибок, то вывести страницу с предупреждением о длительной операции.
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаПредупреждениеОДлительнойОперации;
	КонецЕсли;

	ОбновитьИнформационныеСтроки();

	УправлениеФормой(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	Если ПустаяСтрока(ЭтотОбъект.Логин) Тогда
		Отказ = Истина;
		// Чтобы появилось окно ввода логина / пароля ВебИТС.
		ОблачныйАрхивКлиент.ПодключитьСервисОблачныйАрхив();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)

	ПрочиеПараметры = Новый Структура;
	ОблачныйАрхивКлиент.ОбработкаНавигационнойСсылки(
		ЭтотОбъект,
		Элемент,
		НавигационнаяСсылкаФорматированнойСтроки,
		СтандартнаяОбработка,
		ПрочиеПараметры);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаДалее(Команда)

	// Проверить возможность перехода.

	лкТекущаяСтраница = Элементы.ГруппаСтраницы.ТекущаяСтраница;
	Если лкТекущаяСтраница = Элементы.СтраницаПредупреждениеОДлительнойОперации Тогда
		// Переход возможен только если активен один сеанс.
		ОбновитьИнформационныеСтроки();
		Если ЭтотОбъект.КоличествоАктивныхСеансов <= 1 Тогда // Проверка количества сеансов.
			// Начать резервное копирование.
			НачатьРезервноеКопирование();
		Иначе
			// Перейти на страницу со списком активных сеансов.
			Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаПодготовкаКСозданиюРезервнойКопии;
			УправлениеФормой(ЭтотОбъект);
		КонецЕсли;
	ИначеЕсли лкТекущаяСтраница = Элементы.СтраницаПодготовкаКСозданиюРезервнойКопии Тогда
		ОбновитьИнформационныеСтроки();
		Если ЭтотОбъект.КоличествоАктивныхСеансов <= 1 Тогда // Проверка количества сеансов.
			// Начать резервное копирование.
			НачатьРезервноеКопирование();
		Иначе
			// Перейти на страницу со списком активных сеансов.
			Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаПодготовкаКСозданиюРезервнойКопии;
			УправлениеФормой(ЭтотОбъект);
		КонецЕсли;
	ИначеЕсли лкТекущаяСтраница = Элементы.СтраницаОшибка Тогда
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КомандаНазад(Команда)

	лкТекущаяСтраница = Элементы.ГруппаСтраницы.ТекущаяСтраница;
	Если лкТекущаяСтраница = Элементы.СтраницаПредупреждениеОДлительнойОперации Тогда
	ИначеЕсли лкТекущаяСтраница = Элементы.СтраницаПодготовкаКСозданиюРезервнойКопии Тогда
	ИначеЕсли лкТекущаяСтраница = Элементы.СтраницаОшибка Тогда
		// Переход назад со страницы ошибок.
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция возвращает количество сторонних сеансов соединения с ИБ.
//
// Параметры:
//  Нет.
//
// Возвращаемое значение:
//   Число - Количество активных сеансов, кроме этого, консоли кластеров и других (которые не мешают восстановлению из резервной копии).
//
&НаСервереБезКонтекста
Функция КоличествоСеансовИнформационнойБазы()

	Возврат СоединенияИБ.КоличествоСеансовИнформационнойБазы(Ложь, Ложь);

КонецФункции

// Обновляет информационные надписи.
//
// Параметры:
//  Нет.
//
&НаСервере
Процедура ОбновитьИнформационныеСтроки()

	лкТекущаяСтраница = Элементы.ГруппаСтраницы.ТекущаяСтраница;
	Если (лкТекущаяСтраница = Элементы.СтраницаПредупреждениеОДлительнойОперации)
			ИЛИ (лкТекущаяСтраница = Элементы.СтраницаПодготовкаКСозданиюРезервнойКопии) Тогда
		ЭтотОбъект.КоличествоАктивныхСеансов = КоличествоСеансовИнформационнойБазы();
		Элементы.ДекорацияПодготовкаКСозданиюРезервнойКопииТекст.Заголовок = Новый ФорматированнаяСтрока(
			НСтр("ru='Производится отключение сеансов других пользователей,
				|работающих в программе.'"),
			Символы.ПС,
			Символы.ПС,
			Новый ФорматированнаяСтрока(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru='Активные сеансы: %1'"),
					ЭтотОбъект.КоличествоАктивныхСеансов), // Содержимое
				, // Шрифт
				, // ЦветТекста
				, // ЦветФона
				"backup1C:OpenActiveSessionsList"), // Ссылка
			Символы.ПС,
			Символы.ПС,
			НСтр("ru='Имеются активные сеансы работы с программой,
				|которые не могут быть завершены принудительно.'"));

	ИначеЕсли лкТекущаяСтраница = Элементы.СтраницаОшибка Тогда
	КонецЕсли;

КонецПроцедуры

// Управляет видимостью и доступностью элементов управления.
//
// Параметры:
//  Форма  - Управляемая форма - форма, в которой необходимо установить видимость / доступность.
//
&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)

	Элементы = Форма.Элементы;
	ТекущаяСтраница = Элементы.ГруппаСтраницы.ТекущаяСтраница;

	лкНазад      = Элементы.КомандаНазад;
	лкДалее      = Элементы.КомандаДалее;
	лкЗакрыть    = Элементы.КомандаЗакрыть;

	Если ТекущаяСтраница = Элементы.СтраницаПредупреждениеОДлительнойОперации Тогда
#Область СтраницаПредупреждениеОДлительнойОперации

		лкНазад.Видимость   = Ложь;
		лкДалее.Видимость   = Истина;
		лкЗакрыть.Видимость = Истина;

		лкДалее.Заголовок = НСтр("ru='Создать резервную копию'");
		лкДалее.КнопкаПоУмолчанию = Истина;

		лкЗакрыть.Заголовок = НСтр("ru='Отмена'");

#КонецОбласти

	ИначеЕсли ТекущаяСтраница = Элементы.СтраницаПодготовкаКСозданиюРезервнойКопии Тогда
#Область СтраницаПодготовкаКСозданиюРезервнойКопии

		лкНазад.Видимость   = Ложь;
		лкДалее.Видимость   = Истина;
		лкЗакрыть.Видимость = Истина;

		// Если активных сеансов нет, то нажатие на кнопку Далее = "Сохранить", иначе "Повторить проверку количества сеансов".
		Если Форма.КоличествоАктивныхСеансов <= 1 Тогда // Проверка количества сеансов.
			лкДалее.Заголовок = НСтр("ru='Создать резервную копию'");
		Иначе
			лкДалее.Заголовок = НСтр("ru='Обновить'");
		КонецЕсли;
		лкДалее.КнопкаПоУмолчанию = Истина;

		лкЗакрыть.Заголовок = НСтр("ru='Отмена'");

#КонецОбласти

	ИначеЕсли ТекущаяСтраница = Элементы.СтраницаОшибка Тогда
#Область СтраницаОшибка

		лкНазад.Видимость   = Ложь;
		лкДалее.Видимость   = Ложь;
		лкЗакрыть.Видимость = Истина;
		лкЗакрыть.КнопкаПоУмолчанию = Истина;
		лкЗакрыть.Заголовок = НСтр("ru='Закрыть'");

#КонецОбласти

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура НачатьРезервноеКопирование()

	ВремяНачала = ТекущаяУниверсальнаяДатаВМиллисекундах();
	КонтекстВыполнения = ИнтернетПоддержкаПользователейКлиентСервер.НоваяЗаписьРезультатовВыполненияОпераций();

	// Процесс резервного копирования в 1С:Облачный архив состоит из следующих шагов:
	// 1. Установить блокировку сеансов на 2 минуты.

	КодРезультата = 0;
	ОписаниеРезультата = "";
	ИнтернетПоддержкаПользователейКлиентСервер.НачатьРегистрациюРезультатаВыполненияОперации(
		КонтекстВыполнения,
		"ОблачныйАрхив.СозданиеФайлаРезервнойКопии.ЗапускРезервирования.УстановкаБлокировкиСеансов",
		НСтр("ru='Запуск резервного копирования, установка блокировки'"));

		УстановитьБлокировкуСеансовНа2Минуты();

	ИнтернетПоддержкаПользователейКлиентСервер.ЗавершитьРегистрациюРезультатаВыполненияОперации(
		КонтекстВыполнения,
		КодРезультата,
		ОписаниеРезультата,
		Неопределено);

	// 2. Выполнить все операции с настройками.
	КонтекстВыполненияВложенный = ИнтернетПоддержкаПользователейКлиентСервер.НоваяЗаписьРезультатовВыполненияОпераций();

	ИнтернетПоддержкаПользователейКлиентСервер.НачатьРегистрациюРезультатаВыполненияОперации(
		КонтекстВыполнения,
		"ОблачныйАрхив.СозданиеФайлаРезервнойКопии.ЗапускРезервирования.ИзменениеНастроек",
		НСтр("ru='Запуск резервного копирования, изменение настроек для Агента резервного копирования'"));
	КодРезультата = 0;
	ОписаниеРезультата = "";

		ИзменитьНастройкиАгентаРезервногоКопирования(
			КонтекстВыполненияВложенный,
			ЭтотОбъект.ИмяФайлаНастроекИБ,
			ЭтотОбъект.КаталогУстановкиАгентаКопирования);

	ИнтернетПоддержкаПользователейКлиентСервер.ЗавершитьРегистрациюРезультатаВыполненияОперации(
		КонтекстВыполнения,
		КодРезультата,
		ОписаниеРезультата,
		КонтекстВыполненияВложенный);

	// 3. Подготовка к выходу из программы.
	ИнтернетПоддержкаПользователейКлиентСервер.НачатьРегистрациюРезультатаВыполненияОперации(
		КонтекстВыполнения,
		"ОблачныйАрхив.СозданиеФайлаРезервнойКопии.ЗапускРезервирования.ПодготовкаКВыходу",
		НСтр("ru='Запуск резервного копирования, подготовка к выходу из программы'"));
	КодРезультата = 0;
	ОписаниеРезультата = "";

		СоединенияИБКлиент.УстановитьПризнакЗавершитьВсеСеансыКромеТекущего(Истина);
		СоединенияИБКлиент.УстановитьПризнакРаботаПользователейЗавершается(Истина);

	ИнтернетПоддержкаПользователейКлиентСервер.ЗавершитьРегистрациюРезультатаВыполненияОперации(
		КонтекстВыполнения,
		КодРезультата,
		ОписаниеРезультата,
		Неопределено);

	// 4. Лог.
	ВремяОкончания = ТекущаяУниверсальнаяДатаВМиллисекундах();
	ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='Запуск резервного копирования.
			|Время начала (мс): %1
			|Время окончания (мс): %2
			|Длительность (мс): %3
			|Результат выполнения:
			|%4'")
			+ Символы.ПС,
		ВремяНачала,
		ВремяОкончания,
		ВремяОкончания - ВремяНачала,
		ИнтернетПоддержкаПользователейКлиентСервер.ПредставлениеЗаписиРезультатовВыполненияОпераций(
			КонтекстВыполнения,
			Истина, // ВключаяВложенные
			"ПодробноПоШагам",
			1));
	// Запись в журнал регистрации.
	ИнтернетПоддержкаПользователейВызовСервера.ЗаписатьСообщениеВЖурналРегистрации(
		НСтр("ru='БИП:ОблачныйАрхив.Сервис и регламент'"), // Имя события
		НСтр("ru='Облачный архив. Сервис и регламент. Резервное копирование. Завершение'"), // ИмяСобытия
		"Информация", // УровеньЖурналаРегистрации.*
		, // ОбъектМетаданных
		(ВремяОкончания - ВремяНачала), // Данные
		ТекстСообщения, // Комментарий
		ОблачныйАрхивКлиентПовтИсп.ВестиПодробныйЖурналРегистрации()); // ВестиПодробныйЖурналРегистрации

	// 5. Выйти из программы.
	СоединенияИБКлиент.ЗавершитьРаботуЭтогоСеанса(Ложь); // ВыводитьВопрос = Ложь.
	ЗавершитьРаботуСистемы(Ложь);

КонецПроцедуры

// Устанавливает блокировку сеанса на 2 минуты.
//
// Параметры:
//  Нет.
//
&НаСервереБезКонтекста
Процедура УстановитьБлокировкуСеансовНа2Минуты()

	КодРазрешения = "РезервноеКопирование"; // Идентификатор.
	Блокировка = Новый БлокировкаСеансов;
	Блокировка.Установлена = Истина;
	Блокировка.Начало = ТекущаяДатаСеанса();
	Блокировка.Конец  = ТекущаяДатаСеанса() + 2*60;
	Блокировка.КодРазрешения = КодРазрешения;
	Блокировка.Сообщение = СоединенияИБ.СформироватьСообщениеБлокировки(
		НСтр("ru = 'Выполняется резервное копирование. Вход в информационную базу заблокирован на 2 минуты.'"),
		КодРазрешения);
	УстановитьБлокировкуСеансов(Блокировка);

КонецПроцедуры

// Изменяет настройки агента резервного копирования.
//
// Параметры:
//  КонтекстВыполнения                - Структура - контекст выполнения;
//  ИмяФайлаНастроекИБ                - Строка - имя файла настроек;
//  КаталогУстановкиАгентаКопирования - Строка - каталог установки Агента резервного копирования.
//
&НаСервере
Процедура ИзменитьНастройкиАгентаРезервногоКопирования(КонтекстВыполнения, ИмяФайлаНастроекИБ, КаталогУстановкиАгентаКопирования)

	ТипСтруктура = Тип("Структура");
	СтруктураНастроекИБ = Неопределено;

	// 1. В файле настроек Агента резервного копирования необходимо добавить строку с указанием,
	//    что необходимо немедленно провести резервное копирование.
#Область ЧтениеНастроек
	// Найти и перезаписать файл с настройками текущей ИБ.
	КодРезультата = 0;
	ОписаниеРезультата = "";
	ИнтернетПоддержкаПользователейКлиентСервер.НачатьРегистрациюРезультатаВыполненияОперации(
		КонтекстВыполнения,
		"ОблачныйАрхив.СозданиеФайлаРезервнойКопии.ЗапускРезервирования.ИзменениеНастроек.ЧтениеНастроек",
		НСтр("ru='Запуск резервного копирования, изменение настроек для Агента резервного копирования, чтение настроек'"));

		// Для ручной копии всегда брать новые настройки.
		// Создать настройки по-умолчанию.
		СтруктураНастроекИБ = ОблачныйАрхив.ПреобразоватьФайлXMLВСтруктуру("Макет.НастройкиИБ");
		ПараметрыОкруженияСервер = ОблачныйАрхив.ПолучитьНастройкиОблачногоАрхива("ПараметрыОкруженияСервер");
			ИмяИБ = ПараметрыОкруженияСервер.ИмяИБ;
			ИмяИБ_Полный =
				ИмяИБ
					+ ОблачныйАрхивКлиентСервер.ПолучитьОписаниеСуффиксовИдентификаторовИБ().РучнаяКопия.Описание;
			ИдентификаторИБ = ПараметрыОкруженияСервер.ИдентификаторИБ;
			ИдентификаторИБ_Полный =
				ИдентификаторИБ
					+ ОблачныйАрхивКлиентСервер.ПолучитьОписаниеСуффиксовИдентификаторовИБ().РучнаяКопия.Суффикс;
		НастройкиАгентаКопированияОбщие = ОблачныйАрхив.ПолучитьНастройкиОблачногоАрхива("НастройкиАгентаКопированияОбщие");
			КоличествоХранимыхКопий_Ежемесячные  = НастройкиАгентаКопированияОбщие.КоличествоХранимыхКопий_Ежемесячные;
			КоличествоХранимыхКопий_Еженедельные = НастройкиАгентаКопированияОбщие.КоличествоХранимыхКопий_Еженедельные;
			КоличествоХранимыхКопий_Ежедневные   = НастройкиАгентаКопированияОбщие.КоличествоХранимыхКопий_Ежедневные;

		// В настройках установить правильные параметры секции DatabaseBackupConfiguration/Database:
		// - DB_ID,
		// - DBName,
		// - DBFolder.
		// Удалить все расписания кроме BackupNow.
		// В настройках установить правильные параметры секции DatabaseBackupConfiguration/RetentionRule:
		// - Daily,
		// - Weekly,
		// - Monthly.

		// Текст, Атрибуты, Элементы.
		Если ТипЗнч(СтруктураНастроекИБ) = ТипСтруктура Тогда
			ВложенныеЭлементы = СтруктураНастроекИБ.Элементы;
			Если ВложенныеЭлементы.Свойство("DatabaseBackupConfiguration") Тогда
				ВложенныеЭлементы = ВложенныеЭлементы.DatabaseBackupConfiguration.Элементы;
				Если ВложенныеЭлементы.Свойство("Database") Тогда
					СтруктураИБ = ВложенныеЭлементы.Database;
					СтруктураИБ.Элементы.Вставить("DB_ID", Новый Структура("Текст", ИдентификаторИБ_Полный));
					СтруктураИБ.Элементы.Вставить("DBName", Новый Структура("Текст", ИмяИБ_Полный));
					СтруктураИБ.Элементы.Вставить("DBFolder", Новый Структура("Текст", ЭтотОбъект.КаталогИБ));
				КонецЕсли;
				Если ВложенныеЭлементы.Свойство("RetentionRule") Тогда
					СтруктураДлительностиХраненияКопий = ВложенныеЭлементы.RetentionRule;
					СтруктураДлительностиХраненияКопий.Элементы.Вставить("Daily", Новый Структура("Текст", КоличествоХранимыхКопий_Ежедневные));
					СтруктураДлительностиХраненияКопий.Элементы.Вставить("Weekly", Новый Структура("Текст", КоличествоХранимыхКопий_Еженедельные));
					СтруктураДлительностиХраненияКопий.Элементы.Вставить("Monthly", Новый Структура("Текст", КоличествоХранимыхКопий_Ежемесячные));
				КонецЕсли;
				Если ВложенныеЭлементы.Свойство("Schedule") Тогда
					СтруктураРасписания = ВложенныеЭлементы.Schedule;
					СтруктураРасписания.Элементы = Новый Структура; // Очистка расписания.
					// При этом удалятся все остальные элементы:
					// - BackupNow;
					// - Time;
					// - BackupDaily;
					// - BackupWeekly;
					// - BackupMonthly.
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;

		ОписаниеРезультата = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Созданы настройки по-умолчанию:
				|%1'"),
			ИнтернетПоддержкаПользователейКлиентСервер.ПредставлениеЗначения(СтруктураНастроекИБ, "=", Символы.ПС));

	ИнтернетПоддержкаПользователейКлиентСервер.ЗавершитьРегистрациюРезультатаВыполненияОперации(
		КонтекстВыполнения,
		КодРезультата,
		ОписаниеРезультата,
		Неопределено);
#КонецОбласти

	// 2. Изменить настройки.
#Область ИзменениеНастроек
	// Пройтись по настройкам, найти / добавить настройку DatabaseBackupConfiguration/Schedule/BackupNow с атрибутом delay="30".
	КодРезультата = 0;
	ОписаниеРезультата = "";
	ИнтернетПоддержкаПользователейКлиентСервер.НачатьРегистрациюРезультатаВыполненияОперации(
		КонтекстВыполнения,
		"ОблачныйАрхив.СозданиеФайлаРезервнойКопии.ЗапускРезервирования.ИзменениеНастроек.ДобавлениеНастроекНемедленногоКопирования",
		НСтр("ru='Запуск резервного копирования, изменение настроек для Агента резервного копирования, добавление настроек для немедленного копирования'"));

		// Текст, Атрибуты, Элементы.
		Если ТипЗнч(СтруктураНастроекИБ) = ТипСтруктура Тогда
			ВложенныеЭлементы = СтруктураНастроекИБ.Элементы;
			Если ВложенныеЭлементы.Свойство("DatabaseBackupConfiguration") Тогда
				ВложенныеЭлементы = ВложенныеЭлементы.DatabaseBackupConfiguration.Элементы;
				Если ВложенныеЭлементы.Свойство("Schedule") Тогда
					СтруктураРасписания = ВложенныеЭлементы.Schedule;
					Если ТипЗнч(СтруктураРасписания.Элементы) <> ТипСтруктура Тогда
						СтруктураРасписания.Элементы = Новый Структура;
					КонецЕсли;
					СтруктураЗадержки  = Новый Структура("delay", 30);
					СтруктураАтрибутов = Новый Структура("Атрибуты", СтруктураЗадержки);
					СтруктураРасписания.Элементы.Вставить("BackupNow", СтруктураАтрибутов);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;

		ОписаниеРезультата = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Изменены настройки:
				|%1'"),
			ИнтернетПоддержкаПользователейКлиентСервер.ПредставлениеЗначения(СтруктураНастроекИБ, "=", Символы.ПС));

	ИнтернетПоддержкаПользователейКлиентСервер.ЗавершитьРегистрациюРезультатаВыполненияОперации(
		КонтекстВыполнения,
		КодРезультата,
		ОписаниеРезультата,
		Неопределено);
#КонецОбласти

	// 3. Сохранить настройки.
#Область ЗаписьНастроек
	КодРезультата = 0;
	ОписаниеРезультата = "";
	ИнтернетПоддержкаПользователейКлиентСервер.НачатьРегистрациюРезультатаВыполненияОперации(
		КонтекстВыполнения,
		"ОблачныйАрхив.СозданиеФайлаРезервнойКопии.ЗапускРезервирования.ИзменениеНастроек.ЗаписьФайлаНастроек",
		НСтр("ru='Запуск резервного копирования, изменение настроек для Агента резервного копирования, запись файла настроек'"));

		ИмяВременногоФайлаНастроекИБ = ПолучитьИмяВременногоФайла("xml");
		ОблачныйАрхив.ПреобразоватьСтруктуруВФайлXML(ИмяВременногоФайлаНастроекИБ, СтруктураНастроекИБ);

	ИнтернетПоддержкаПользователейКлиентСервер.ЗавершитьРегистрациюРезультатаВыполненияОперации(
		КонтекстВыполнения,
		КодРезультата,
		ОписаниеРезультата,
		Неопределено);
#КонецОбласти

	// 4. Запустить Агент резервного копирования, чтобы он перечитал настройки.
#Область РеинициализацияАгентаРезервногоКопирования
	КодРезультата = 0;
	ОписаниеРезультата = "";
	ИнтернетПоддержкаПользователейКлиентСервер.НачатьРегистрациюРезультатаВыполненияОперации(
		КонтекстВыполнения,
		"ОблачныйАрхив.СозданиеФайлаРезервнойКопии.ЗапускРезервирования.ИзменениеНастроек.РеинициализацияАгентаРезервногоКопирования",
		НСтр("ru='Запуск резервного копирования, изменение настроек для Агента резервного копирования, реинициализация агента резервного копирования'"));

		СтрокаКоманды =
			""""
			+ КаталогУстановкиАгентаКопирования
			+ ПолучитьРазделительПути()
			+ "BackupAgent.exe"
			+ """"
			+ " update_task_config -path="
				+ """"
				+ ИмяВременногоФайлаНастроекИБ
				+ """";
		ЗапуститьПриложение(СтрокаКоманды, КаталогУстановкиАгентаКопирования, Истина, КодРезультата);

	ОписаниеРезультата = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='Команда реинициализации: %1
			|Код возврата: %2'"),
		СтрокаКоманды,
		КодРезультата);

	ИнтернетПоддержкаПользователейКлиентСервер.ЗавершитьРегистрациюРезультатаВыполненияОперации(
		КонтекстВыполнения,
		КодРезультата,
		ОписаниеРезультата,
		Неопределено);
#КонецОбласти

	// 5. Удаление временного файла.
#Область УдалениеВременногоФайла
	КодРезультата = 0;
	ОписаниеРезультата = "";
	ИнтернетПоддержкаПользователейКлиентСервер.НачатьРегистрациюРезультатаВыполненияОперации(
		КонтекстВыполнения,
		"ОблачныйАрхив.СозданиеФайлаРезервнойКопии.ЗапускРезервирования.ИзменениеНастроек.УдалениеВременныхФайлов",
		НСтр("ru='Запуск резервного копирования, изменение настроек для Агента резервного копирования, удаление временных файлов'"));

		ФайлУдален  = Истина;
		ТекстОшибки = "";
		Попытка
			УдалитьФайлы(ИмяВременногоФайлаНастроекИБ);
			ТекстРезультата = НСтр("ru='Успешно удален'");
		Исключение
			ФайлУдален = Ложь;
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			ТекстРезультата = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Ошибка удаления:
					|%1'"),
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
		КонецПопытки;

	ОписаниеРезультата = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='Удаление временного файла: %1
			|Результат: %2'"),
		ИмяВременногоФайлаНастроекИБ,
		ТекстРезультата);

	ИнтернетПоддержкаПользователейКлиентСервер.ЗавершитьРегистрациюРезультатаВыполненияОперации(
		КонтекстВыполнения,
		КодРезультата,
		ОписаниеРезультата,
		Неопределено);
#КонецОбласти

КонецПроцедуры

// Загружает из веб-сервисов статистику и список резервных копий и собирает информацию о клиентском компьютере.
//
// Параметры:
//  СрокЖизниСтатистики - Число - количество секунд, сколько собранная статистика считается актуальной,
//                        если 0 - обновить принудительно.
//
&НаСервере
Процедура ЗагрузитьСтатистику(СрокЖизниСтатистики = 300)

	// Сбор информации запускается сразу, а не фоновым заданием.
	МассивШагов = Новый Массив;

		ШагСбораДанных = ОблачныйАрхивКлиентСервер.ПолучитьОписаниеШагаСбораДанных();
			ШагСбораДанных.КодШага               = "ИнформацияОКлиенте"; // Идентификатор
			ШагСбораДанных.ОписаниеШага          = НСтр("ru='Сбор информации о клиентском компьютере'");
			ШагСбораДанных.СрокУстареванияСекунд = СрокЖизниСтатистики; // Обновлять только если данные были собраны > 5 минут назад.
		МассивШагов.Добавить(ШагСбораДанных);

		ШагСбораДанных = ОблачныйАрхивКлиентСервер.ПолучитьОписаниеШагаСбораДанных();
			ШагСбораДанных.КодШага               = "СвойстваХранилищаОблачногоАрхива"; // Идентификатор
			ШагСбораДанных.ОписаниеШага          = НСтр("ru='Сбор информации об использовании облачного хранилища'");
			ШагСбораДанных.СрокУстареванияСекунд = СрокЖизниСтатистики; // Обновлять только если данные были собраны > 5 минут назад.
		МассивШагов.Добавить(ШагСбораДанных);

		ШагСбораДанных = ОблачныйАрхивКлиентСервер.ПолучитьОписаниеШагаСбораДанных();
			ШагСбораДанных.КодШага               = "НастройкиАгентаКопированияКлиент"; // Идентификатор
			ШагСбораДанных.ОписаниеШага          = НСтр("ru='Чтение настроек Агента резервного копирования'");
			ШагСбораДанных.СрокУстареванияСекунд = СрокЖизниСтатистики; // Обновлять только если данные были собраны > 5 минут назад.
		МассивШагов.Добавить(ШагСбораДанных);

		ШагСбораДанных = ОблачныйАрхивКлиентСервер.ПолучитьОписаниеШагаСбораДанных();
			ШагСбораДанных.КодШага               = "АктивацииАгентовКопирования"; // Идентификатор
			ШагСбораДанных.ОписаниеШага          = НСтр("ru='Проверка активации Агента резервного копирования на этом компьютере'");
			ШагСбораДанных.СрокУстареванияСекунд = СрокЖизниСтатистики; // Обновлять только если данные были собраны > 5 минут назад.
		МассивШагов.Добавить(ШагСбораДанных);

		ШагСбораДанных = ОблачныйАрхивКлиентСервер.ПолучитьОписаниеШагаСбораДанных();
			ШагСбораДанных.КодШага               = "СписокРезервныхКопий"; // Идентификатор
			ШагСбораДанных.ОписаниеШага          = НСтр("ru='Получение списка резервных копий'");
			ШагСбораДанных.СрокУстареванияСекунд = СрокЖизниСтатистики; // Обновлять только если данные были собраны > 5 минут назад.
		МассивШагов.Добавить(ШагСбораДанных);

	ОблачныйАрхив.СобратьДанныеПоОблачномуАрхиву(Новый Структура("МассивШагов", МассивШагов), "");

КонецПроцедуры

#КонецОбласти

