#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Кэширует свойство Использование регламентных заданий в одноименном реквизите регистра.
//
// Параметры:
//	ОтборОрганизации - Массив - организация для кэширования свойства
//
Функция ОбновитьКэшСвойстваИспользованиеРегламентногоЗадания(ОтборОрганизации = Неопределено) Экспорт
	
	КоличествоДанных = 0; // для замера производительности
	ОписаниеЗадания  = СформироватьОписаниеЗадания();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Задания.Организация КАК Организация,
	|	Задания.РегламентноеЗадание КАК ИдентификаторЗадания,
	|	Задания.ЗакрываемыйПериодОУ,
	|	Задания.ЗакрываемыйПериодРУ,
	|	Задания.ЗакрываемыйПериодМУ,
	|	Задания.Использование
	|ИЗ
	|	РегистрСведений.РегламентныеЗаданияЗакрытияМесяца КАК Задания
	|ГДЕ
	|	(Задания.Организация В (&ОтборОрганизации)
	|			ИЛИ &ПоВсемОрганизациям)";
	
	Запрос.УстановитьПараметр("ОтборОрганизации", 	ОбщегоНазначенияУТКлиентСервер.Массив(ОтборОрганизации));
	Запрос.УстановитьПараметр("ПоВсемОрганизациям", НЕ ЗначениеЗаполнено(ОтборОрганизации));
	
	УстановитьПривилегированныйРежим(Истина);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		КоличествоДанных = КоличествоДанных + 1;
		
		Задание = РегламентныеЗаданияСервер.Задание(Выборка.ИдентификаторЗадания);
		
		Если Задание = Неопределено Тогда
			
			// Задание не найдено - удалим запись регистра.
			Запись = РегистрыСведений.РегламентныеЗаданияЗакрытияМесяца.СоздатьМенеджерЗаписи();
			Запись.Организация = Выборка.Организация;
			
			Запись.Удалить();
			
		ИначеЕсли Задание.Использование <> Выборка.Использование Тогда
			
			// Обновим кэш свойства "Использование".
			ЗаполнитьЗначенияСвойств(ОписаниеЗадания, Выборка);
			ОписаниеЗадания.Использование = Задание.Использование;
			
			ЗаписатьРегламентноеЗаданиеПоОрганизации(ОписаниеЗадания);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат КоличествоДанных;
	
КонецФункции

// Возвращает описание регламентного задания закрытия месяца по указанной организации.
//
// Параметры:
//	Организация - СправочникСсылка.Организации - организация для получения регламентного задания
//
// Возвращаемое значение:
//	Структура с ключами
//		- Организация - СправочникСсылка.Организации
//		- ИдентификаторЗадания - УникальныйИдентификатор
//		- ЗакрываемыйПериодОУ - Дата
//		- ЗакрываемыйПериодРУ - Дата
//		- ЗакрываемыйПериодМУ - Дата
//		- Задание - РегламентноеЗадание
//		- СостояниеЗадания - Структура, ключи см. в ОбщегоНазначенияУТ.ПолучитьСостояниеПоследнегоЗадания()
//
Функция ПолучитьРегламентноеЗаданиеПоОрганизации(Организация) Экспорт
	
	Если Организация = Неопределено Тогда
		Организация = Справочники.Организации.ПустаяСсылка();
	КонецЕсли;
	
	ОписаниеЗадания = СформироватьОписаниеЗадания();
	ОписаниеЗадания.Организация = Организация;
	ОписаниеЗадания.ЗаданиеСуществует = Ложь;
	ОписаниеЗадания.НастройкаСуществует = Ложь;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Задания.РегламентноеЗадание,
	|	Задания.ЗакрываемыйПериодОУ,
	|	Задания.ЗакрываемыйПериодРУ,
	|	Задания.ЗакрываемыйПериодМУ
	|ИЗ
	|	РегистрСведений.РегламентныеЗаданияЗакрытияМесяца КАК Задания
	|ГДЕ
	|	Задания.Организация = &Организация";
	
	Запрос.УстановитьПараметр("Организация", Организация);
	
	УстановитьПривилегированныйРежим(Истина);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		ОписаниеЗадания.НастройкаСуществует  = Истина;
		ОписаниеЗадания.ИдентификаторЗадания = Выборка.РегламентноеЗадание;
		ОписаниеЗадания.ЗакрываемыйПериодОУ  =
			?(ЗначениеЗаполнено(Выборка.ЗакрываемыйПериодОУ), НачалоМесяца(Выборка.ЗакрываемыйПериодОУ), НачалоМесяца(Выборка.ЗакрываемыйПериодРУ));
		ОписаниеЗадания.ЗакрываемыйПериодРУ  = НачалоМесяца(Выборка.ЗакрываемыйПериодРУ);
		ОписаниеЗадания.ЗакрываемыйПериодМУ  = НачалоМесяца(Выборка.ЗакрываемыйПериодМУ);
	Иначе
		ОписаниеЗадания.ЗакрываемыйПериодОУ  = Дата(1,1,1);
		ОписаниеЗадания.ЗакрываемыйПериодРУ  = Дата(1,1,1);
		ОписаниеЗадания.ЗакрываемыйПериодМУ  = Дата(1,1,1);
	КонецЕсли;
	
	Если ОписаниеЗадания.ИдентификаторЗадания <> Неопределено Тогда
		
		ОписаниеЗадания.Задание = РегламентныеЗаданияСервер.Задание(ОписаниеЗадания.ИдентификаторЗадания);
		
		Если ОписаниеЗадания.Задание <> Неопределено Тогда
			ОписаниеЗадания.ЗаданиеСуществует = Истина;
			ОписаниеЗадания.Использование 	  = ОписаниеЗадания.Задание.Использование; // получаем не из кэша регистра, а из самого задания
			ОписаниеЗадания.СостояниеЗадания  = ОбщегоНазначенияУТ.ПолучитьСостояниеПоследнегоЗадания(ОписаниеЗадания.Задание);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ОписаниеЗадания;
	
КонецФункции

// Сохраняет параметры регламентного задания закрытия месяца.
//
// Параметры:
//	ОписаниеЗадания - Структура с ключами
//		- Организация - СправочникСсылка.Организации
//		- ИдентификаторЗадания - УникальныйИдентификатор
//		- ЗакрываемыйПериодОУ - Дата
//		- ЗакрываемыйПериодРУ - Дата
//		- ЗакрываемыйПериодМУ - Дата
//
Процедура ЗаписатьРегламентноеЗаданиеПоОрганизации(ОписаниеЗадания) Экспорт
	
	Запись = РегистрыСведений.РегламентныеЗаданияЗакрытияМесяца.СоздатьМенеджерЗаписи();
	
	Запись.Организация 		   		   = ОписаниеЗадания.Организация;
	Запись.РегламентноеЗадание 		   = ОписаниеЗадания.ИдентификаторЗадания;
	Запись.ЗакрываемыйПериодОУ 		   = НачалоМесяца(ОписаниеЗадания.ЗакрываемыйПериодОУ);
	Запись.ЗакрываемыйПериодРУ 		   = НачалоМесяца(ОписаниеЗадания.ЗакрываемыйПериодРУ);
	Запись.ЗакрываемыйПериодМУ 		   = НачалоМесяца(ОписаниеЗадания.ЗакрываемыйПериодМУ);
	Запись.Использование	   		   = ОписаниеЗадания.Использование;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запись.Записать(Истина);
	
КонецПроцедуры

// Возвращает массив организаций, у которых есть включенные регламентные задания закрытия месяца.
//
// Параметры:
//	ОтборОрганизации - Массив - организация для проверки наличия включенного регламентного задания
//
// Возвращаемое значение:
//	Массив - массив организаций
//
Функция ПолучитьОрганизацииСВключеннымиРегламентнымиЗаданиями(ОтборОрганизации = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Задания.Организация КАК Организация
	|ИЗ
	|	РегистрСведений.РегламентныеЗаданияЗакрытияМесяца КАК Задания
	|ГДЕ
	|	(Задания.Организация В (&ОтборОрганизации)
	|			ИЛИ &ПоВсемОрганизациям)
	|	И Задания.Использование
	|
	|УПОРЯДОЧИТЬ ПО
	|	Организация";
	
	Запрос.УстановитьПараметр("ОтборОрганизации", 	ОбщегоНазначенияУТКлиентСервер.Массив(ОтборОрганизации));
	Запрос.УстановитьПараметр("ПоВсемОрганизациям", НЕ ЗначениеЗаполнено(ОтборОрганизации));
	
	УстановитьПривилегированныйРежим(Истина);
	
	МассивОрганизаций = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Организация");
	
	Возврат МассивОрганизаций;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СформироватьОписаниеЗадания()
	
	Возврат Новый Структура(
		"Организация, ИдентификаторЗадания,
		|ЗакрываемыйПериодОУ, ЗакрываемыйПериодРУ, ЗакрываемыйПериодМУ,
		|Задание, Использование, СостояниеЗадания, ЗаданиеСуществует, НастройкаСуществует");
	
КонецФункции

Процедура ЗаполнитьПризнакНаличияЗаданияУОрганизаций(СписокВыбора) Экспорт
	
	ПустаяКартинка    = Новый Картинка;
	МассивОрганизаций = ПолучитьОрганизацииСВключеннымиРегламентнымиЗаданиями();
	
	Для Каждого ТекущаяОрганизация Из СписокВыбора Цикл
		ЕстьРегламентноеЗадание 	= (МассивОрганизаций.Найти(ТекущаяОрганизация.Значение) <> Неопределено);
		ТекущаяОрганизация.Картинка = ?(ЕстьРегламентноеЗадание, БиблиотекаКартинок.РегламентноеЗадание, ПустаяКартинка);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
