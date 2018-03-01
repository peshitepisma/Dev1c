////////////////////////////////////////////////////////////////////////////////
// ОБЩАЯ РЕАЛИЗАЦИЯ ОБРАБОТКИ СООБЩЕНИЙ УПРАВЛЕНИЯ РАСШИРЕНИЯМИ
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Обработка входящих сообщений с типом {http://www.1c.ru/1cFresh/ConfigurationExtensions/Management/a.b.c.d}Install
//
// Параметры:
//  ОписаниеИнсталляции - Структура, ключи:
//    Идентификатор - УникальныйИдентификатор, уникальный идентификатор ссылки
//      элемента справочника ПоставляемыеРасширения,
//    Представление - строка, представление инсталляции поставляемого расширения
//      (будет использоваться в качестве наименования расширения),
//    Инсталляция - УникальныйИдентификатор, уникальный идентификатор инсталляции
//      поставляемого расширения,
//  ИдентификаторПользователяСервиса - УникальныйИдентификатор, определяющий пользователя
//    сервиса, который инициировал инсталляцию поставляемого расширения.
//
Процедура УстановитьРасширение(Знач ОписаниеИнсталляции, Знач ИдентификаторПользователяСервиса) Экспорт
	
	РасширенияВМоделиСервиса.УстановитьПоставляемоеРасширениеВОбластьДанных(
		ОписаниеИнсталляции,
		ПолучитьПользователяОбластиПоИдентификаторуПользователяСервиса(ИдентификаторПользователяСервиса));
	
КонецПроцедуры

// Обработка входящих сообщений с типом {http://www.1c.ru/1cFresh/ConfigurationExtensions/Management/a.b.c.d}Delete
//
// Параметры:
//  ИдентификаторПоставляемогоРасширения - УникальныйИдентификатор, ссылка на элемент
//    справочника ПоставляемыеРасширения;
//
Процедура УдалитьРасширение(Знач ИдентификаторПоставляемогоРасширения) Экспорт
	
	ПоставляемоеРасширение = Справочники.ПоставляемыеРасширения.ПолучитьСсылку(ИдентификаторПоставляемогоРасширения);
	РасширенияВМоделиСервиса.УдалитьПоставляемоеРасширениеИзОбластиДанных(ПоставляемоеРасширение);
	
КонецПроцедуры

// Обработка входящих сообщений с типом {http://www.1c.ru/1cFresh/ConfigurationExtensions/Management/a.b.c.d}Disable
//
// Параметры:
//  ИдентификаторРасширения - УникальныйИдентификатор, ссылка на элемент
//    справочника ПоставляемыеРасширения,
//  ПричинаОтключения - ПеречислениеСсылка.ПричиныОтключенияРасширенийВМоделиСервиса.
//
Процедура ОтключитьРасширение(Знач ИдентификаторРасширения, Знач ПричинаОтключения = Неопределено) Экспорт
	
	Если ПричинаОтключения = Неопределено Тогда
		
		ПричинаОтключения = Перечисления.ПричиныОтключенияРасширенийВМоделиСервиса.БлокировкаАдминистраторомСервиса;
		
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПоставляемоеРасширение = Справочники.ПоставляемыеРасширения.ПолучитьСсылку(ИдентификаторРасширения);
	
	Если ОбщегоНазначения.СсылкаСуществует(ПоставляемоеРасширение) Тогда
		
		Объект = ПоставляемоеРасширение.ПолучитьОбъект();
		
		Объект.Отключено = Истина;
		Объект.ПричинаОтключения = ПричинаОтключения;
		
		Объект.Записать();
		
	КонецЕсли;
	
КонецПроцедуры

// Обработка входящих сообщений с типом {http://www.1c.ru/1cFresh/ConfigurationExtensions/Management/a.b.c.d}Enable
//
// Параметры:
//  ИдентификаторРасширения - УникальныйИдентификатор, ссылка на элемент
//  справочника ПоставляемыеРасширения.
//
Процедура ВключитьРасширение(Знач ИдентификаторРасширения) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПоставляемоеРасширение = Справочники.ПоставляемыеРасширения.ПолучитьСсылку(ИдентификаторРасширения);
	
	Если ОбщегоНазначения.СсылкаСуществует(ПоставляемоеРасширение) Тогда
		
		Объект = ПоставляемоеРасширение.ПолучитьОбъект();
		
		Объект.Отключено = Ложь;
		Объект.ПричинаОтключения = Неопределено;
		
		Объект.Записать();
		
	КонецЕсли;
	
КонецПроцедуры

// Обработка входящих сообщений с типом {http://www.1c.ru/1cFresh/ConfigurationExtensions/Management/a.b.c.d}Drop
//
// Параметры:
//  ИдентификаторРасширения - УникальныйИдентификатор, ссылка на элемент
//  справочника ПоставляемыеРасширения.
//
Процедура ОтозватьРасширение(Знач ИдентификаторПоставляемогоРасширения) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПоставляемоеРасширение = Справочники.ПоставляемыеРасширения.ПолучитьСсылку(ИдентификаторПоставляемогоРасширения);
	
	Если ОбщегоНазначения.СсылкаСуществует(ПоставляемоеРасширение) Тогда
		
		РасширенияВМоделиСервиса.ОтозватьПоставляемоеРасширение(ПоставляемоеРасширение);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьПользователяОбластиПоИдентификаторуПользователяСервиса(Знач ИдентификаторПользователяСервиса)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Пользователи.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Пользователи КАК Пользователи
	|ГДЕ
	|	Пользователи.ИдентификаторПользователяСервиса = &ИдентификаторПользователяСервиса");
	
	Запрос.УстановитьПараметр("ИдентификаторПользователяСервиса", ИдентификаторПользователяСервиса);
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("Справочник.Пользователи");
	
	НачатьТранзакцию();
	
	Попытка
		
		Блокировка.Заблокировать();
		Результат = Запрос.Выполнить();
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ВызватьИсключение;
		
	КонецПопытки;
	
	Если Результат.Пустой() Тогда
		
		ШаблонСообщения = НСтр("ru = 'Не найден пользователь с идентификатором пользователя сервиса %1'");
		ТекстСообщения = СтрШаблон(ШаблонСообщения, ИдентификаторПользователяСервиса);
		ВызватьИсключение(ТекстСообщения);
		
	КонецЕсли;
	
	Возврат Результат.Выгрузить()[0].Ссылка;
	
КонецФункции

#КонецОбласти