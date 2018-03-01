////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность в модели сервиса".
// Серверные процедуры и функции общего назначения:
// - Поддержка работы в модели сервиса.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Добавляет в список процедуры-обработчики обновления данных ИБ
// для всех поддерживаемых версий библиотеки или конфигурации.
// Вызывается перед началом обновления данных ИБ для построения плана обновления.
//
// Параметры:
//  Обработчики - ТаблицаЗначений - описание полей 
//                                  см. в процедуре ОбновлениеИнформационнойБазы.НоваяТаблицаОбработчиковОбновления.
//
// Пример добавления процедуры-обработчика в список:
//  Обработчик = Обработчики.Добавить();
//  Обработчик.Версия              = "1.0.0.0";
//  Обработчик.Процедура           = "ОбновлениеИБ.ПерейтиНаВерсию_1_0_0_0";
//  Обработчик.МонопольныйРежим    = Ложь;
//  Обработчик.Опциональный        = Истина;
// 
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "*";
		Обработчик.Процедура = "РаботаВМоделиСервисаБТС.СоздатьНеразделенныеПредопределенныеЭлементы";
		Обработчик.Приоритет = 99;
		Обработчик.ОбщиеДанные = Истина;
		Обработчик.МонопольныйРежим = Ложь;
		
	КонецЕсли;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.12.15";
	Обработчик.Процедура = "РаботаВМоделиСервисаБТС.ПеренестиДанныеУдаленногоАдминистрирования";
	Обработчик.РежимВыполнения = "Оперативно";
	Обработчик.ОбщиеДанные = Истина;
	Обработчик.ВыполнятьВГруппеОбязательных = Истина;
	Обработчик.Приоритет = 99;
	Обработчик.НачальноеЗаполнение = Истина;
	Обработчик.МонопольныйРежим = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Вызывается при включении разделения данных по областям данных.
//
Процедура ПриВключенииРазделенияПоОбластямДанных() Экспорт
	
	СоздатьНеразделенныеПредопределенныеЭлементы();
	
КонецПроцедуры

// Вызывается при установке конечной точки Менеддера сервиса.
//
Процедура ПриУстановкеКонечнойТочкиМенеджераСервиса() Экспорт
	
	Если ТехнологияСервисаИнтеграцияСБСП.ПодсистемаСуществует("ТехнологияСервиса.РаботаВМоделиСервиса.УправлениеТарифамиВМоделиСервиса") Тогда
		МодульТарификацияСлужебный = ТехнологияСервисаИнтеграцияСБСП.ОбщийМодуль("ТарификацияСлужебный");
		МодульТарификацияСлужебный.ПриУстановкеКонечнойТочкиМенеджераСервиса();
	КонецЕсли;
	
КонецПроцедуры

// Формирует список параметров ИБ.
//
// Параметры:
// ТаблицаПараметров - ТаблицаЗначений - таблица описания параметров.
// Описание состав колонок - см. РаботаВМоделиСервиса.ПолучитьТаблицуПараметровИБ().
//
Процедура ПриЗаполненииТаблицыПараметровИБ(Знач ТаблицаПараметров) Экспорт
	
	Если ТехнологияСервисаИнтеграцияСБСП.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса") Тогда
		МодульРаботаВМоделиСервиса = ТехнологияСервисаИнтеграцияСБСП.ОбщийМодуль("РаботаВМоделиСервиса");
		МодульРаботаВМоделиСервиса.ДобавитьКонстантуВТаблицуПараметровИБ(ТаблицаПараметров, "ВнешнийАдресУправляющегоПриложения");
	КонецЕсли;
	
КонецПроцедуры

// Обработчик создания/обновления предопределенных элементов
// неразделенных объектов метаданных.
//
Процедура СоздатьНеразделенныеПредопределенныеЭлементы() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() И ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
		
		ВызватьИсключение НСтр("ru = 'Операция может быть выполнена только в сеансе, в котором не установлены значения разделителей'");
		
	КонецЕсли;
	
	ИнициализироватьПредопределенныеДанные();
	
КонецПроцедуры

// Обработчик переносит значения в констнаты "ВнутреннийАдресМенеджераСервиса" и "КонечнаяТочкаМенеджераСервиса"
// из одноименных констант с преффиксом "Удалить".
//
Процедура ПеренестиДанныеУдаленногоАдминистрирования() Экспорт
	
	Если Не ЗначениеЗаполнено(Константы.ВнутреннийАдресМенеджераСервиса.Получить()) Тогда
		Константы.ВнутреннийАдресМенеджераСервиса.Установить(Константы.УдалитьВнутреннийАдресМенеджераСервиса.Получить());
	КонецЕсли;
	Константы.УдалитьВнутреннийАдресМенеджераСервиса.Установить("");
	Если Не ЗначениеЗаполнено(Константы.КонечнаяТочкаМенеджераСервиса.Получить()) Тогда
		Константы.КонечнаяТочкаМенеджераСервиса.Установить(Константы.УдалитьКонечнаяТочкаМенеджераСервиса.Получить());
	КонецЕсли;
	Константы.УдалитьКонечнаяТочкаМенеджераСервиса.Установить(ПланыОбмена.ОбменСообщениями.ПустаяСсылка());
	
КонецПроцедуры

// Вызывается при формировании манифеста конфигурации.
//
// Параметры:
//  РасширенныеСведения - Массив, внутри процедуры обработчика в данный массив требуется
//    добавить объекты типа ОбъектXDTO с ТипомXDTO, унаследованным от
//    {http://www.1c.ru/1cFresh/Application/Manifest/a.b.c.d}ExtendedInfoItem.
//
Процедура ПриФормированииМанифестаКонфигурации(РасширенныеСведения) Экспорт
	
	Если ТранзакцияАктивна() Тогда
		ВызватьИсключение НСтр("ru = 'Операция не может быть выполнена при активной внешней транзакции!'");
	КонецЕсли;
	
	ВызовВНеразделеннойИБ = Не ОбщегоНазначенияПовтИсп.РазделениеВключено();
	
	НачатьТранзакцию();
	
	Попытка
		
		ОписаниеРазрешений = ФабрикаXDTO.Создать(
			ФабрикаXDTO.Тип("http://www.1c.ru/1cFresh/Application/Permissions/Manifes/1.0.0.1", "RequiredPermissions")
		);
		
		ОписаниеВнешнихКомпонент = ФабрикаXDTO.Создать(
			ФабрикаXDTO.Тип("http://www.1c.ru/1cFresh/Application/Permissions/Manifes/1.0.0.1", "Addins")
		);
		
		МакетыВнешнихКомпонент = Новый Соответствие();
		
		Если ВызовВНеразделеннойИБ Тогда
			
			Константы.ИспользоватьРазделениеПоОбластямДанных.Установить(Истина);
			ОбновитьПовторноИспользуемыеЗначения();
			
		КонецЕсли;
		
		Константы.ИспользуютсяПрофилиБезопасности.Установить(Истина);
		Константы.АвтоматическиНастраиватьРазрешенияВПрофиляхБезопасности.Установить(Истина);
		
		ИдентификаторыЗапросов = РаботаВБезопасномРежиме.ЗапросыОбновленияРазрешенийКонфигурации();
		
		МенеджерПрименения = РаботаВБезопасномРежимеСлужебныйВМоделиСервиса.МенеджерПримененияРазрешений(ИдентификаторыЗапросов);
		Дельта = МенеджерПрименения.ДельтаБезУчетаВладельцев();
		
		МакетыВнешнихКомпонент = Новый Массив();
		
		Для Каждого ЭлементДельты Из Дельта.Добавляемые Цикл
			
			Для Каждого КлючИЗначение Из ЭлементДельты.Разрешения Цикл
				
				Разрешение = ОбщегоНазначения.ОбъектXDTOИзСтрокиXML(КлючИЗначение.Значение);
				ОписаниеРазрешений.Permission.Добавить(Разрешение);
				
				Если Разрешение.Тип() = ФабрикаXDTO.Тип("http://www.1c.ru/1cFresh/Application/Permissions/1.0.0.1", "AttachAddin") Тогда
					МакетыВнешнихКомпонент.Добавить(Разрешение.TemplateName);
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЦикла;
		
		Для Каждого ИмяМакета Из МакетыВнешнихКомпонент Цикл
			
			ОписаниеВнешнейКомпоненты = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип("http://www.1c.ru/1cFresh/Application/Permissions/Manifes/1.0.0.1", "AddinBundle"));
			ОписаниеВнешнейКомпоненты.TemplateName = ИмяМакета;
			
			ОписанияФайлов = РаботаВБезопасномРежиме.КонтрольныеСуммыФайловКомплектаВнешнейКомпоненты(ИмяМакета);
			
			Для Каждого КлючИЗначение Из ОписанияФайлов Цикл
				
				ОписаниеФайла = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип("http://www.1c.ru/1cFresh/Application/Permissions/Manifes/1.0.0.1", "AddinFile"));
				ОписаниеФайла.FileName = КлючИЗначение.Ключ;
				ОписаниеФайла.Hash = КлючИЗначение.Значение;
				
				ОписаниеВнешнейКомпоненты.Files.Добавить(ОписаниеФайла);
				
			КонецЦикла;
			
			ОписаниеВнешнихКомпонент.Bundles.Добавить(ОписаниеВнешнейКомпоненты);
			
		КонецЦикла;
		
		РасширенныеСведения.Добавить(ОписаниеРазрешений);
		РасширенныеСведения.Добавить(ОписаниеВнешнихКомпонент);
		
	Исключение
		
		ОтменитьТранзакцию();
		Если ВызовВНеразделеннойИБ Тогда
			ОбновитьПовторноИспользуемыеЗначения();
		КонецЕсли;
		
		ВызватьИсключение;
		
	КонецПопытки;
	
	ОтменитьТранзакцию();
	Если ВызовВНеразделеннойИБ Тогда
		ОбновитьПовторноИспользуемыеЗначения();
	КонецЕсли;
	
КонецПроцедуры

// Возвращает внутренний адрес менеджера сервиса.
//
// Возвращаемое значение:
//  Строка - внутренний адрес менеджера сервиса.
//
Функция ВнутреннийАдресМенеджераСервиса() Экспорт
	
	Возврат Константы.ВнутреннийАдресМенеджераСервиса.Получить();
	
КонецФункции

// Устанавливает внутренний адрес менеджера сервиса.
//
// Параметры:
//  Значение - Строка - внутренний адрес менеджера сервиса.
//
Процедура УстановитьВнутреннийАдресМенеджераСервиса(Знач Значение) Экспорт
	
	Константы.ВнутреннийАдресМенеджераСервиса.Установить(Значение);
	
КонецПроцедуры

// Возвращает имя служебного пользователя менеджера сервиса.
//
// Возвращаемое значение:
//  Строка - имя служебного пользователя менеджера сервиса.
//
Функция ИмяСлужебногоПользователяМенеджераСервиса() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Владелец = ТехнологияСервисаИнтеграцияСБСП.ИдентификаторОбъектаМетаданных("Константа.ВнутреннийАдресМенеджераСервиса");
	ИмяСлужебногоПользователя = ТехнологияСервисаИнтеграцияСБСП.ПрочитатьДанныеИзБезопасногоХранилища(Владелец, "ИмяСлужебногоПользователяМенеджераСервиса", Истина);
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат ИмяСлужебногоПользователя;
	
КонецФункции

// Возвращает пароль служебного пользователя менеджера сервиса.
//
// Возвращаемое значение:
//  Строка - пароль служебного пользователя менеджера сервиса.
//
Функция ПарольСлужебногоПользователяМенеджераСервиса() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Владелец = ТехнологияСервисаИнтеграцияСБСП.ИдентификаторОбъектаМетаданных("Константа.ВнутреннийАдресМенеджераСервиса");
	ПарольСлужебногоПользователя = ТехнологияСервисаИнтеграцияСБСП.ПрочитатьДанныеИзБезопасногоХранилища(Владелец, "ПарольСлужебногоПользователяМенеджераСервиса", Истина);
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат ПарольСлужебногоПользователя;
	
КонецФункции

// Возвращает конечную точку для отправки сообщений в менеджер сервиса.
//
// Возвращаемое значение:
//  ПланОбменСсылка.ОбменСообщениями - узел соответствующий менеджеру сервиса.
//
Функция КонечнаяТочкаМенеджераСервиса() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Возврат Константы.КонечнаяТочкаМенеджераСервиса.Получить();
	
КонецФункции

Процедура ПодготовитьИПрикрепитьОбластьДанных(Знач КодОбластиДанных, Знач СписокПользователей, Знач ПредставлениеПриложения, Знач ЧасовойПоясПриложения, Знач ИдентифкаторФайлаНачальныхДанных) Экспорт
	
	ПодготовитьОбластьДанных(КодОбластиДанных, ИдентифкаторФайлаНачальныхДанных);
	ПрикрепитьОбластьДанных(КодОбластиДанных, СписокПользователей, ПредставлениеПриложения, ЧасовойПоясПриложения);
	
КонецПроцедуры

Процедура ПодготовитьОбластьДанных(Знач КодОбластиДанных, Знач ИдентифкаторФайлаНачальныхДанных)
	
	Если НЕ Пользователи.ЭтоПолноправныйПользователь(, Истина) Тогда
		ВызватьИсключение(НСтр("ru = 'Недостаточно прав для выполнения операции'"));
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	КлючОбласти = РаботаВМоделиСервиса.СоздатьКлючЗаписиРегистраСведенийВспомогательныхДанных(
		РегистрыСведений.ОбластиДанных,
		Новый Структура(РаботаВМоделиСервиса.РазделительВспомогательныхДанных(), КодОбластиДанных));
	ЗаблокироватьДанныеДляРедактирования(КлючОбласти);
	
	Попытка
		МенеджерЗаписи = РаботаВМоделиСервиса.ПолучитьМенеджерЗаписиОбластиДанных(КодОбластиДанных, Перечисления.СтатусыОбластейДанных.ПустаяСсылка());
		
		Если ТекущийРежимЗапуска() <> Неопределено Тогда
			
			СообщениеОбОшибке = "";
			
			ПользователиСлужебный.АвторизоватьТекущегоПользователя();
			
			РезультатПодготовки = РаботаВМоделиСервиса.ПодготовитьОбластьДанныхКИспользованиюИзЭталонной(КодОбластиДанных, ИдентифкаторФайлаНачальныхДанных, "Стандарт", СообщениеОбОшибке);
			
			Если РезультатПодготовки <> "Успех" Тогда
				ИмяСобытия = РаботаВМоделиСервиса.СобытиеЖурналаРегистрацииПодготовкаОбластиДанных();
				ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Ошибка, , , СообщениеОбОшибке);
				ТипСообщения = СообщенияКонтрольУдаленногоАдминистрированияИнтерфейс.СообщениеОшибкаПодготовкиОбластиДанных();
				ОтправитьСообщениеОСостоянииОбластиДанных(ТипСообщения, КодОбластиДанных, СообщениеОбОшибке);
				ВызватьИсключение СообщениеОбОшибке;
			КонецЕсли;
			
		КонецЕсли;
			
	Исключение
		РазблокироватьДанныеДляРедактирования(КлючОбласти);
		ВызватьИсключение;
	КонецПопытки;
	
	РазблокироватьДанныеДляРедактирования(КлючОбласти);
	
КонецПроцедуры

Процедура ПрикрепитьОбластьДанных(Знач КодОбластиДанных, Знач СписокПользователей, Знач ПредставлениеПриложения, Знач ЧасовойПоясПриложения) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию();
	Попытка
		
		// Установка параметров области данных.
		Блокировка = Новый БлокировкаДанных;
		Элемент = Блокировка.Добавить("РегистрСведений.ОбластиДанных");
		Блокировка.Заблокировать();
		
		МенеджерЗаписи = РегистрыСведений.ОбластиДанных.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Прочитать();
		Если НЕ МенеджерЗаписи.Выбран() Тогда
			ШаблонСообщения = НСтр("ru = 'Область данных %1 не существует.'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, КодОбластиДанных);
			ВызватьИсключение(ТекстСообщения);
		КонецЕсли;
		
		МенеджерЗаписи.Статус = Перечисления.СтатусыОбластейДанных.Используется;
		КопияМенеджера = РегистрыСведений.ОбластиДанных.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(КопияМенеджера, МенеджерЗаписи);
		МенеджерЗаписи = КопияМенеджера;
		МенеджерЗаписи.Записать();
		
		// Создание администраторов в области.
		Для каждого ОписаниеПользователя Из СписокПользователей Цикл
			ЯзыкПользователя = ЯзыкПоКоду(ОписаниеПользователя.Language);
			
			Почта = "";
			Телефон = "";
			Если ЗначениеЗаполнено(ОписаниеПользователя.EMail) Тогда
				Почта = ОписаниеПользователя.EMail;
			КонецЕсли;
			
			Если ЗначениеЗаполнено(ОписаниеПользователя.Phone) Тогда
				Телефон = ОписаниеПользователя.Phone;
			КонецЕсли;
			
			СтруктураАдресаЭП = СоставПочтовогоАдреса(Почта);
			
			Запрос = Новый Запрос;
			Запрос.Текст =
			"ВЫБРАТЬ
			|    Пользователи.Ссылка КАК Ссылка
			|ИЗ
			|    Справочник.Пользователи КАК Пользователи
			|ГДЕ
			|    Пользователи.ИдентификаторПользователяСервиса = &ИдентификаторПользователяСервиса";
			Запрос.УстановитьПараметр("ИдентификаторПользователяСервиса", ОписаниеПользователя.UserServiceID);
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить("Справочник.Пользователи");
			Блокировка.Заблокировать();
			
			Результат = Запрос.Выполнить();
			Если Результат.Пустой() Тогда
				ПользовательОбластиДанных = Неопределено;
			Иначе
				Выборка = Результат.Выбрать();
				Выборка.Следующий();
				ПользовательОбластиДанных = Выборка.Ссылка;
			КонецЕсли;
			
			Если НЕ ЗначениеЗаполнено(ПользовательОбластиДанных) Тогда
				ПользовательОбъект = Справочники.Пользователи.СоздатьЭлемент();
				ПользовательОбъект.ИдентификаторПользователяСервиса = ОписаниеПользователя.UserServiceID;
			Иначе
				ПользовательОбъект = ПользовательОбластиДанных.ПолучитьОбъект();
			КонецЕсли;
			
			ПользовательОбъект.Наименование = ОписаниеПользователя.FullName;
			
			ОбновитьАдресЭлектроннойПочты(ПользовательОбъект, Почта, СтруктураАдресаЭП);
			
			ОбновитьТелефон(ПользовательОбъект, Телефон);
			
			ОписаниеПользователяИБ = Пользователи.НовоеОписаниеПользователяИБ();
			
			ОписаниеПользователяИБ.Имя = ОписаниеПользователя.Name;
			
			ОписаниеПользователяИБ.АутентификацияСтандартная = Истина;
			ОписаниеПользователяИБ.АутентификацияOpenID = Истина;
			ОписаниеПользователяИБ.ПоказыватьВСпискеВыбора = Ложь;
			
			ОписаниеПользователяИБ.СохраняемоеЗначениеПароля = ОписаниеПользователя.StoredPasswordValue;
			
			ОписаниеПользователяИБ.Язык = ЯзыкПользователя;
			
			Роли = Новый Массив;
			Роли.Добавить("ПолныеПрава");
			ОписаниеПользователяИБ.Роли = Роли;
			
			ОписаниеПользователяИБ.Вставить("Действие", "Записать");
			ПользовательОбъект.ДополнительныеСвойства.Вставить("ОписаниеПользователяИБ", ОписаниеПользователяИБ);
			ПользовательОбъект.ДополнительныеСвойства.Вставить("СозданиеАдминистратора",
				НСтр("ru = 'Создание администратора области данных из менеджера сервиса.'"));
			
			ПользовательОбъект.ДополнительныеСвойства.Вставить("ОбработкаСообщенияКаналаУдаленногоАдминистрирования");
			ПользовательОбъект.Записать();
			
			ПользовательОбластиДанных = ПользовательОбъект.Ссылка;
			
			Если ПользователиСлужебный.ЗапретРедактированияРолей()
				И ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
			
				МодульУправлениеДоступомСлужебныйВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступомСлужебныйВМоделиСервиса");
				МодульУправлениеДоступомСлужебныйВМоделиСервиса.УстановитьПринадлежностьПользователяКГруппеАдминистраторы(ПользовательОбластиДанных, Истина);
			КонецЕсли;
		КонецЦикла;
		
		Если Не ПустаяСтрока(ПредставлениеПриложения) Тогда
			ОбновитьСвойстваПредопределенныхУзлов(ПредставлениеПриложения);
		КонецЕсли;
		
		Сообщение = СообщенияВМоделиСервиса.НовоеСообщение(СообщенияКонтрольУдаленногоАдминистрированияИнтерфейс.СообщениеОбластьДанныхГотоваКИспользованию());
			Сообщение.Body.Zone = КодОбластиДанных;
		
		СообщенияВМоделиСервиса.ОтправитьСообщение(Сообщение, РаботаВМоделиСервисаБТСПовтИсп.КонечнаяТочкаМенеджераСервиса(), Истина);
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ВызватьИсключение;
		
	КонецПопытки;
	
	ОбновитьПараметрыТекущейОбластиДанных(ПредставлениеПриложения, ЧасовойПоясПриложения);
	
	СообщенияВМоделиСервиса.ДоставитьБыстрыеСообщения();
	
КонецПроцедуры

Функция ОтправитьСообщениеОСостоянииОбластиДанных(Знач ТипСообщения, Знач КодОбластиДанных, Знач СообщениеОбОшибке = "")
	
	Сообщение = СообщенияВМоделиСервиса.НовоеСообщение(ТипСообщения);
	Сообщение.Body.Zone = КодОбластиДанных;
	Если Не ПустаяСтрока(СообщениеОбОшибке) Тогда 
		Сообщение.Body.ErrorDescription = СообщениеОбОшибке;
	КонецЕсли;

	НачатьТранзакцию();
	Попытка
		СообщенияВМоделиСервиса.ОтправитьСообщение(
			Сообщение,
			РаботаВМоделиСервисаПовтИсп.КонечнаяТочкаМенеджераСервиса());
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецФункции

Функция ЯзыкПоКоду(Знач КодЯзыка) Экспорт
	
	Если ЗначениеЗаполнено(КодЯзыка) Тогда
		
		Для каждого Язык Из Метаданные.Языки Цикл
			Если Язык.КодЯзыка = КодЯзыка Тогда
				Возврат Язык.Имя;
			КонецЕсли;
		КонецЦикла;
		
		ШаблонСообщения = НСтр("ru = 'Неподдерживаемый код языка: %1'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, Язык);
		ВызватьИсключение(ТекстСообщения);
		
	Иначе
		
		Возврат Неопределено;
		
	КонецЕсли;
	
КонецФункции

Функция СоставПочтовогоАдреса(Знач АдресЭП) Экспорт
	
	Если ЗначениеЗаполнено(АдресЭП) Тогда
		
		Попытка
			СтруктураАдресаЭП = ОбщегоНазначенияКлиентСервер.РазобратьСтрокуСПочтовымиАдресами(АдресЭП);
		Исключение
			ШаблонСообщения = НСтр("ru = 'Указан некорректный адрес электронной почты: %1
				|Ошибка: %2'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, АдресЭП, ИнформацияОбОшибке().Описание);
			ВызватьИсключение(ТекстСообщения);
		КонецПопытки;
		
		Возврат СтруктураАдресаЭП;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

Процедура ОбновитьАдресЭлектроннойПочты(Знач ПользовательОбъект, Знач Адрес, Знач СтруктураАдресаЭП) Экспорт
	
	ВидКИ = Справочники.ВидыКонтактнойИнформации.EmailПользователя;
	
	СтрокаТабличнойЧасти = ПользовательОбъект.КонтактнаяИнформация.Найти(ВидКИ, "Вид");
	Если СтруктураАдресаЭП = Неопределено Тогда
		Если СтрокаТабличнойЧасти <> Неопределено Тогда
			ПользовательОбъект.КонтактнаяИнформация.Удалить(СтрокаТабличнойЧасти);
		КонецЕсли;
	Иначе
		Если СтрокаТабличнойЧасти = Неопределено Тогда
			СтрокаТабличнойЧасти = ПользовательОбъект.КонтактнаяИнформация.Добавить();
			СтрокаТабличнойЧасти.Вид = ВидКИ;
		КонецЕсли;
		СтрокаТабличнойЧасти.Тип = Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты;
		СтрокаТабличнойЧасти.Представление = Адрес;
		
		Если СтруктураАдресаЭП.Количество() > 0 Тогда
			СтрокаТабличнойЧасти.АдресЭП = СтруктураАдресаЭП[0].Адрес;
			
			Поз = СтрНайти(СтрокаТабличнойЧасти.АдресЭП, "@");
			Если Поз <> 0 Тогда
				СтрокаТабличнойЧасти.ДоменноеИмяСервера = Сред(СтрокаТабличнойЧасти.АдресЭП, Поз + 1);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбновитьТелефон(Знач ПользовательОбъект, Знач Телефон) Экспорт
	
	ВидКИ = Справочники.ВидыКонтактнойИнформации.ТелефонПользователя;
	
	СтрокаТабличнойЧасти = ПользовательОбъект.КонтактнаяИнформация.Найти(ВидКИ, "Вид");
	Если СтрокаТабличнойЧасти = Неопределено Тогда
		СтрокаТабличнойЧасти = ПользовательОбъект.КонтактнаяИнформация.Добавить();
		СтрокаТабличнойЧасти.Вид = ВидКИ;
	КонецЕсли;
	СтрокаТабличнойЧасти.Тип = Перечисления.ТипыКонтактнойИнформации.Телефон;
	СтрокаТабличнойЧасти.Представление = Телефон;
	
КонецПроцедуры

Процедура ОбновитьСвойстваПредопределенныхУзлов(Знач Наименование) Экспорт
	
	Для Каждого ПланОбмена Из Метаданные.ПланыОбмена Цикл
		
		Если ОбменДаннымиПовтИсп.ПланОбменаИспользуетсяВМоделиСервиса(ПланОбмена.Имя) Тогда
			
			ЭтотУзел = ПланыОбмена[ПланОбмена.Имя].ЭтотУзел();
			
			СвойстваУзла = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ЭтотУзел, "Код, Наименование");
			
			Если ПустаяСтрока(СвойстваУзла.Код) Тогда
				
				ЭтотУзелОбъект = ЭтотУзел.ПолучитьОбъект();
				ЭтотУзелОбъект.Код = СообщенияУдаленногоАдминистрированияРеализация.КодУзлаПланаОбменаВСервисе(РаботаВМоделиСервиса.ЗначениеРазделителяСеанса());
				ЭтотУзелОбъект.Наименование = Наименование;
				ЭтотУзелОбъект.Записать();
				
			ИначеЕсли СвойстваУзла.Наименование <> Наименование Тогда
				
				ЭтотУзелОбъект = ЭтотУзел.ПолучитьОбъект();
				ЭтотУзелОбъект.Наименование = Наименование;
				ЭтотУзелОбъект.Записать();
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбновитьПараметрыТекущейОбластиДанных(Знач Представление, Знач ЧасовойПояс) Экспорт
	
	Константы.ПредставлениеОбластиДанных.Установить(Представление);
	Константы.ЧасовойПоясОбластиДанных.Установить(ЧасовойПояс);
	
	Если ПолучитьЧасовойПоясИнформационнойБазы() <> ЧасовойПояс Тогда
		
		ВнешнийМонопольныйРежим = МонопольныйРежим();
		
		Если ВнешнийМонопольныйРежим Тогда
			
			ОбластьЗаблокирована = Истина;
			
		Иначе
			
			Попытка
				
				РаботаВМоделиСервиса.ЗаблокироватьТекущуюОбластьДанных();
				ОбластьЗаблокирована = Истина;
				
			Исключение
				
				ОбластьЗаблокирована = Ложь;
				
				ШаблонСообщения = НСтр("ru = 'Не удалось заблокировать область данных для установки часового пояса ""%1""'");
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, ЧасовойПояс);
				ЗаписьЖурналаРегистрации(СообщенияУдаленногоАдминистрированияРеализация.СобытиеЖурналаРегистрацииУдаленноеАдминистрированиеУстановитьПараметры(),
					УровеньЖурналаРегистрации.Ошибка, , , ТекстСообщения);
				
			КонецПопытки;
			
		КонецЕсли;
		
		Если ОбластьЗаблокирована Тогда
			
			Если ЗначениеЗаполнено(ЧасовойПояс) Тогда
				
				УстановитьЧасовойПоясИнформационнойБазы(ЧасовойПояс);
				
			Иначе
				
				УстановитьЧасовойПоясИнформационнойБазы();
				
			КонецЕсли;
			
			Если НЕ ВнешнийМонопольныйРежим Тогда
				
				РаботаВМоделиСервиса.РазблокироватьТекущуюОбластьДанных();
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Заполняет соответствие имен методов их псевдонимам для вызова из очереди заданий.
//
// Параметры:
//  СоответствиеИменПсевдонимам - Соответствие
//   Ключ - Псевдоним метода, например ОчиститьОбластьДанных.
//   Значение - Имя метода для вызова, например РаботаВМоделиСервиса.ОчиститьОбластьДанных.
//    В качестве значения можно указать Неопределено, в этом случае считается что имя 
//    совпадает с псевдонимом.
//
Процедура ПриОпределенииПсевдонимовОбработчиков(СоответствиеИменПсевдонимам) Экспорт
	
	СоответствиеИменПсевдонимам.Вставить("РаботаВМоделиСервисаБТС.ПодготовитьИПрикрепитьОбластьДанных");
	
КонецПроцедуры


#КонецОбласти