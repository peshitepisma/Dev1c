#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяРегистра = "РегистрНакопления.ПрочиеРасходы";
	
	// Очистка СуммыРегл должна произойти только в Управлении торговлей
	ЭтоУТ = НЕ (ПолучитьФункциональнуюОпцию("УправлениеПредприятием") ИЛИ ПолучитьФункциональнуюОпцию("КомплекснаяАвтоматизация"));
	Если ЭтоУТ Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ПрочиеРасходы.Регистратор КАК Регистратор
		|ИЗ
		|	РегистрНакопления.ПрочиеРасходы КАК ПрочиеРасходы
		|ГДЕ
		|	ТИПЗНАЧЕНИЯ(ПрочиеРасходы.Регистратор) = ТИП(Документ.РасчетКурсовыхРазниц)
		|	И ПрочиеРасходы.СуммаРегл <> 0
		|";
		
		Регистраторы = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Регистратор");
		ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(Параметры, Регистраторы, ПолноеИмяРегистра);
	КонецЕсли;

КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяРегистра = "РегистрНакопления.ПрочиеРасходы";
	
	Выборка = ОбновлениеИнформационнойБазы.ВыбратьРегистраторыРегистраДляОбработки(
		Параметры.Очередь, Неопределено, ПолноеИмяРегистра);
		
	ЭтоУТ = НЕ (ПолучитьФункциональнуюОпцию("УправлениеПредприятием") ИЛИ ПолучитьФункциональнуюОпцию("КомплекснаяАвтоматизация"));
	МетаданныеРегистра = Метаданные.РегистрыНакопления.ПрочиеРасходы;
	Пока Выборка.Следующий() Цикл
		
		Регистратор = Выборка.Регистратор;
		ТипДокументСсылка = ТипЗнч(Регистратор);
		МетаданныеДокументСсылка = Регистратор.Метаданные();
		
		НачатьТранзакцию();
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			
			ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.ПрочиеРасходы.НаборЗаписей");
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;
			ЭлементБлокировки.УстановитьЗначение("Регистратор", Регистратор);
			
			Блокировка.Заблокировать();
		
			НаборЗаписей = РегистрыНакопления.ПрочиеРасходы.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Регистратор.Установить(Регистратор);
			НаборЗаписей.Прочитать();
			
			// Очистим СуммуРегл под ПереоценкойВалютныхСредств
			Если ЭтоУТ И ТипЗнч(Выборка.Регистратор) = Тип("ДокументСсылка.РасчетКурсовыхРазниц") Тогда
				Для Каждого Запись Из НаборЗаписей Цикл
					Запись.СуммаРегл = 0;
				КонецЦикла;
				ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей);
			КонецЕсли;
			
			ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(НаборЗаписей);
			
			ЗафиксироватьТранзакцию();
		Исключение
			
			ОтменитьТранзакцию();
			
			ТекстСообщения = НСтр("ru = 'Не удалось обработать движения по регистру ""Прочие расходы"" документа ""%1"" по причине: %2'");
			ТекстСообщения = СтрШаблон(ТекстСообщения, Регистратор, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(
				ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Ошибка,
				МетаданныеРегистра,
				Регистратор,
				ТекстСообщения);
			
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = НЕ ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Параметры.Очередь, ПолноеИмяРегистра);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ПрограммныйИнтерфейс

// Определяет показатели регистра.
// Подробнее см. ОбщийМодуль.МеждународныйУчетСерверПовтИсп.Показатели()
//
// Параметры:
//  Свойства - Структура - содержащая ключи СвойстваПоказателей, СвойстваРесурсов
//
// Возвращаемое значение:
//  Соответствие - Ключ - имя показателя.
//                 Значение - структура свойств показателя.
//
Функция Показатели(Свойства) Экспорт

	Показатели = Новый Соответствие;
	
	СвойстваПоказателей = Свойства.СвойстваПоказателей;
	СвойстваРесурсов = Свойства.СвойстваРесурсов;
	
	МассивРесурсов = Новый Массив;
    МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "Сумма", "ВалютаУпр"));
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "СуммаРегл", "ВалютаРегл"));
	Показатели.Вставить(Перечисления.ПоказателиАналитическихРегистров.Сумма, Новый Структура(СвойстваПоказателей, МассивРесурсов));
	
	МассивРесурсов = Новый Массив;
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "Сумма", "ВалютаУпр"));
	Показатели.Вставить(Перечисления.ПоказателиАналитическихРегистров.СуммаУпрСНДС, Новый Структура(СвойстваПоказателей, МассивРесурсов));
	
	Возврат Показатели;
	
КонецФункции

// Возвращает текст запроса с типовой структурой временной таблицы "ВтИсходныеПрочиеРасходы".
//
// Возвращаемое значение:
//	Строка - Текст запроса формирования временной таблицы ВтИсходныеПрочиеРасходы.
//
Функция ТекстОписаниеВтИсходныеПрочиеРасходы() Экспорт
	
	ТекстЗапроса = "
	|ВЫБРАТЬ ПЕРВЫЕ 0
	|	ДД.Период,
	|	ДД.ВидДвижения,
	|	ДД.Организация,
	|	ДД.Подразделение,
	|	ДД.СтатьяРасходов,
	|	ДД.АналитикаРасходов,
	|	ДД.НаправлениеДеятельности,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПустаяСсылка) КАК ВидДеятельностиНДС,
	|	0 КАК СуммаСНДС,
	|	0 КАК СуммаБезНДС,
	|	0 КАК СуммаБезНДСУпр,
	|	0 КАК СуммаСНДСРегл,
	|	0 КАК СуммаБезНДСРегл,
	|	0 КАК ПостояннаяРазница,
	|	0 КАК ВременнаяРазница,
	|	ДД.ХозяйственнаяОперация,
	|	ДД.АналитикаУчетаНоменклатуры
	|
	|ПОМЕСТИТЬ ВтИсходныеПрочиеРасходы
	|ИЗ
	|	РегистрНакопления.ПрочиеРасходы КАК ДД
	|";
	Возврат ТекстЗапроса
	
КонецФункции

// Формирует текст запроса для формирования временной таблицы "ВтПрочиеРасходы".
//
// Возвращаемое значение:
//	Строка - Текст запроса формирования временной таблицы ВтПрочиеРасходы.
//
Функция ТекстЗапросаТаблицаВтПрочиеРасходы() Экспорт
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	Строки.Период КАК Период,
	|	Строки.ВидДвижения КАК ВидДвижения,
	|	Строки.Организация КАК Организация,
	|	Строки.Подразделение КАК Подразделение,
	|	Строки.СтатьяРасходов КАК СтатьяРасходов,
	|	Строки.АналитикаРасходов КАК АналитикаРасходов,
	|	Строки.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|
	|	(ВЫБОР
	|		КОГДА Статья.ВариантРаспределенияРасходовУпр = ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаСебестоимостьТоваров)
	|			ТОГДА 0
	|		ИНАЧЕ Строки.СуммаСНДС КОНЕЦ) КАК Сумма,
	|	(ВЫБОР
	|		КОГДА Статья.ВариантРаспределенияРасходовУпр = ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаСебестоимостьТоваров)
	|			ТОГДА 0
	|		КОГДА Статья.ВариантРаспределенияРасходовУпр = ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаПроизводственныеЗатраты)
	|			ТОГДА Строки.СуммаБезНДС
	|		ИНАЧЕ 0 КОНЕЦ) КАК СуммаБезНДС,
	|	(ВЫБОР
	|		КОГДА Статья.ВариантРаспределенияРасходовУпр = ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаСебестоимостьТоваров)
	|		 ИЛИ НЕ &УправленческийУчетОрганизаций
	|		 ИЛИ Строки.СуммаБезНДСУпр = 0
	|			ТОГДА 0
	|		КОГДА Строки.ВидДеятельностиНДС В (
	|					ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПродажаНеОблагаетсяНДС),
	|					ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПродажаОблагаетсяЕНВД))
	|				И Статья.ВариантРаздельногоУчетаНДС = ЗНАЧЕНИЕ(Перечисление.ВариантыРаздельногоУчетаНДС.ИзДокумента)
	|			ТОГДА Строки.СуммаБезНДСУпр + (Строки.СуммаСНДС - Строки.СуммаБезНДС)
	|		ИНАЧЕ Строки.СуммаБезНДСУпр КОНЕЦ) КАК СуммаУпр,
	|
	|	(ВЫБОР 
	|		КОГДА НЕ &ИспользоватьУчетПрочихДоходовРасходовРегл ТОГДА 0
	|		КОГДА Статья.ВариантРаспределенияРасходовРегл = ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаСебестоимостьТоваров)
	|			ТОГДА 0
	|		КОГДА Статья.ВариантРаспределенияРасходовРегл = ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаПрочиеАктивы)
	|			ТОГДА 0
	|		КОГДА Статья.ВариантРаспределенияРасходовРегл = ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаВнеоборотныеАктивы)
	|				И НЕ &ИспользуетсяУправлениеВНА_2_4
	|			ТОГДА 0
	|		КОГДА Строки.ВидДеятельностиНДС В (
	|					ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПродажаНеОблагаетсяНДС),
	|					ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПродажаОблагаетсяЕНВД))
	|				И Статья.ВариантРаздельногоУчетаНДС = ЗНАЧЕНИЕ(Перечисление.ВариантыРаздельногоУчетаНДС.ИзДокумента)
	|			ТОГДА Строки.СуммаСНДСРегл
	|		ИНАЧЕ Строки.СуммаБезНДСРегл КОНЕЦ) КАК СуммаРегл,
	|
	|	(ВЫБОР
	|		КОГДА НЕ &ИспользоватьУчетПрочихДоходовРасходовРегл ТОГДА 0
	|		КОГДА Статья.ВариантРаспределенияРасходовРегл = ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаСебестоимостьТоваров)
	|			ТОГДА 0
	|		КОГДА Статья.ВариантРаспределенияРасходовРегл  В (
	|					ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаПрочиеАктивы),
	|					ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаВнеоборотныеАктивы))
	|				И НЕ &ИспользуетсяУправлениеВНА_2_4
	|			ТОГДА 0
	|		КОГДА Не Статья.ПринятиеКналоговомуУчету ТОГДА
	|			(ВЫБОР КОГДА Строки.ВидДеятельностиНДС В (
	|				ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПродажаНеОблагаетсяНДС),
	|				ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПродажаОблагаетсяЕНВД))
	|				И Статья.ВариантРаздельногоУчетаНДС = ЗНАЧЕНИЕ(Перечисление.ВариантыРаздельногоУчетаНДС.ИзДокумента)
	|			ТОГДА Строки.СуммаСНДСРегл
	|			ИНАЧЕ Строки.СуммаБезНДСРегл КОНЕЦ)
	|			- Строки.ВременнаяРазница
	|		ИНАЧЕ Строки.ПостояннаяРазница КОНЕЦ) КАК ПостояннаяРазница,
	|	(ВЫБОР
	|		КОГДА НЕ &ИспользоватьУчетПрочихДоходовРасходовРегл ТОГДА 0
	|		КОГДА Статья.ВариантРаспределенияРасходовРегл = ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаСебестоимостьТоваров)
	|			ТОГДА 0
	|		ИНАЧЕ Строки.ВременнаяРазница КОНЕЦ) КАК ВременнаяРазница,
	|	Строки.ХозяйственнаяОперация,
	|	Строки.АналитикаУчетаНоменклатуры,
	|		
	|	ВЫБОР
	|		КОГДА ТИПЗНАЧЕНИЯ(Строки.АналитикаРасходов) = ТИП(Справочник.Организации)
	|		 И Строки.АналитикаРасходов <> ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
	|			ТОГДА Строки.АналитикаРасходов
	|		КОГДА ТИПЗНАЧЕНИЯ(Строки.АналитикаРасходов) = ТИП(Документ.АктВыполненныхРабот)
	|			ТОГДА ВЫРАЗИТЬ(Строки.АналитикаРасходов КАК Документ.АктВыполненныхРабот).Организация
	|		КОГДА ТИПЗНАЧЕНИЯ(Строки.АналитикаРасходов) = ТИП(Документ.ВводОстатков)
	|			ТОГДА ВЫРАЗИТЬ(Строки.АналитикаРасходов КАК Документ.ВводОстатков).Организация
	|		КОГДА ТИПЗНАЧЕНИЯ(Строки.АналитикаРасходов) = ТИП(Документ.ЗаказКлиента)
	|			ТОГДА ВЫРАЗИТЬ(Строки.АналитикаРасходов КАК Документ.ЗаказКлиента).Организация
	|		КОГДА ТИПЗНАЧЕНИЯ(Строки.АналитикаРасходов) = ТИП(Документ.ЗаказНаПеремещение)
	|			ТОГДА ВЫРАЗИТЬ(Строки.АналитикаРасходов КАК Документ.ЗаказНаПеремещение).Организация
	|		КОГДА ТИПЗНАЧЕНИЯ(Строки.АналитикаРасходов) = ТИП(Документ.ЗаказНаСборку)
	|			ТОГДА ВЫРАЗИТЬ(Строки.АналитикаРасходов КАК Документ.ЗаказНаСборку).Организация
	|		КОГДА ТИПЗНАЧЕНИЯ(Строки.АналитикаРасходов) = ТИП(Документ.ЗаказПоставщику)
	|			ТОГДА ВЫРАЗИТЬ(Строки.АналитикаРасходов КАК Документ.ЗаказПоставщику).Организация
	|		КОГДА ТИПЗНАЧЕНИЯ(Строки.АналитикаРасходов) = ТИП(Документ.ЗаявкаНаВозвратТоваровОтКлиента)
	|			ТОГДА ВЫРАЗИТЬ(Строки.АналитикаРасходов КАК Документ.ЗаявкаНаВозвратТоваровОтКлиента).Организация
	|		КОГДА ТИПЗНАЧЕНИЯ(Строки.АналитикаРасходов) = ТИП(Документ.ПередачаТоваровМеждуОрганизациями)
	|			ТОГДА ВЫРАЗИТЬ(Строки.АналитикаРасходов КАК Документ.ПередачаТоваровМеждуОрганизациями).ОрганизацияПолучатель
	|		КОГДА ТИПЗНАЧЕНИЯ(Строки.АналитикаРасходов) = ТИП(Документ.ПеремещениеТоваров)
	|			ТОГДА ВЫРАЗИТЬ(Строки.АналитикаРасходов КАК Документ.ПеремещениеТоваров).Организация
	|		КОГДА ТИПЗНАЧЕНИЯ(Строки.АналитикаРасходов) = ТИП(Документ.ПриобретениеТоваровУслуг)
	|			ТОГДА ВЫРАЗИТЬ(Строки.АналитикаРасходов КАК Документ.ПриобретениеТоваровУслуг).Организация
	|		КОГДА ТИПЗНАЧЕНИЯ(Строки.АналитикаРасходов) = ТИП(Документ.РеализацияТоваровУслуг)
	|			ТОГДА ВЫРАЗИТЬ(Строки.АналитикаРасходов КАК Документ.РеализацияТоваровУслуг).Организация
	|		КОГДА ТИПЗНАЧЕНИЯ(Строки.АналитикаРасходов) = ТИП(Документ.РеализацияУслугПрочихАктивов)
	|			ТОГДА ВЫРАЗИТЬ(Строки.АналитикаРасходов КАК Документ.РеализацияУслугПрочихАктивов).Организация
	|		КОГДА ТИПЗНАЧЕНИЯ(Строки.АналитикаРасходов) = ТИП(Документ.СборкаТоваров)
	|			ТОГДА ВЫРАЗИТЬ(Строки.АналитикаРасходов КАК Документ.СборкаТоваров).Организация
	|		ИНАЧЕ Строки.Организация
	|	КОНЕЦ КАК ОрганизацияПолучатель
	|
	|ПОМЕСТИТЬ ВтПрочиеРасходы
	|ИЗ
	|	ВтИсходныеПрочиеРасходы КАК Строки
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		ПланВидовХарактеристик.СтатьиРасходов КАК Статья
	|	ПО
	|		Статья.Ссылка = Строки.СтатьяРасходов
	|ГДЕ
	|	(Статья.ВариантРаспределенияРасходовУпр <> ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаСебестоимостьТоваров)
	|		ИЛИ Статья.ВариантРаспределенияРасходовРегл <> ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаСебестоимостьТоваров))
	|	И &ИспользоватьУчетПрочихДоходовРасходов
	|";
	Возврат ТекстЗапроса;
	
КонецФункции

// Формирует текст запроса для формирования движений по регистру "Прочие расходы".
//
Функция ТекстЗапросаТаблицаПрочиеРасходы() Экспорт
	
	ТекстЗапроса = "
	// Формирование таблицы для записи в регистр "ПрочиеРасходы".
	|ВЫБРАТЬ
	|	Строки.Период КАК Период,
	|	Строки.ВидДвижения КАК ВидДвижения,
	|	Строки.Организация КАК Организация,
	|	Строки.Подразделение КАК Подразделение,
	|	Строки.СтатьяРасходов КАК СтатьяРасходов,
	|	Строки.АналитикаРасходов КАК АналитикаРасходов,
	|	Строки.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|
	|	Строки.Сумма КАК Сумма,
	|	Строки.СуммаБезНДС КАК СуммаБезНДС,
	|	Строки.СуммаУпр КАК СуммаУпр,
	|
	|	Строки.СуммаРегл КАК СуммаРегл,
	|	Строки.ПостояннаяРазница КАК ПостояннаяРазница,
	|	Строки.ВременнаяРазница КАК ВременнаяРазница,
	|
	|	Строки.ХозяйственнаяОперация,
	|	Строки.АналитикаУчетаНоменклатуры
	|ИЗ
	|	ВтПрочиеРасходы КАК Строки
	|ГДЕ
	|	(Строки.Сумма <> 0 ИЛИ Строки.СуммаБезНДС <> 0 ИЛИ Строки.СуммаУпр <> 0
	|	ИЛИ Строки.СуммаРегл <> 0 ИЛИ Строки.ПостояннаяРазница <> 0 ИЛИ Строки.ВременнаяРазница <> 0)
	|
	// Сторнирование расходов в упр. учете у организации - источника.
	|ОБЪЕДИНИТЬ ВСЕ
	|ВЫБРАТЬ
	|	Строки.Период КАК Период,
	|	Строки.ВидДвижения КАК ВидДвижения,
	|	Строки.Организация КАК Организация,
	|	Строки.Подразделение КАК Подразделение,
	|	Строки.СтатьяРасходов КАК СтатьяРасходов,
	|	Строки.АналитикаРасходов КАК АналитикаРасходов,
	|	Строки.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	-Строки.Сумма КАК Сумма,
	|	-Строки.СуммаБезНДС КАК СуммаБезНДС,
	|	-Строки.СуммаУпр КАК СуммаУпр,
	|	0 КАК СуммаРегл,
	|	0 КАК ПостояннаяРазница,
	|	0 КАК ВременнаяРазница,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.СторнированиеРасходовУУ) КАК ХозяйственнаяОперация,
	|	Строки.АналитикаУчетаНоменклатуры
	|ИЗ
	|	ВтПрочиеРасходы КАК Строки
	|ГДЕ
	|	Строки.ОрганизацияПолучатель <> Строки.Организация
	|	И Строки.ОрганизацияПолучатель <> ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
	|	И (Строки.Сумма <> 0 ИЛИ Строки.СуммаБезНДС <> 0 ИЛИ Строки.СуммаУпр <> 0)
	|
	// Регистрация расходов в упр. учете у организации - получателя.
	|ОБЪЕДИНИТЬ ВСЕ
	|ВЫБРАТЬ
	|	Строки.Период КАК Период,
	|	Строки.ВидДвижения КАК ВидДвижения,
	|	Строки.ОрганизацияПолучатель КАК Организация,
	|	Строки.Подразделение КАК Подразделение,
	|	Строки.СтатьяРасходов КАК СтатьяРасходов,
	|	Строки.АналитикаРасходов КАК АналитикаРасходов,
	|	Строки.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	Строки.Сумма КАК Сумма,
	|	Строки.СуммаБезНДС КАК СуммаБезНДС,
	|	Строки.СуммаУпр КАК СуммаУпр,
	|	0 КАК СуммаРегл,
	|	0 КАК ПостояннаяРазница,
	|	0 КАК ВременнаяРазница,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РегистрацияРасходовУУ) КАК ХозяйственнаяОперация,
	|	Строки.АналитикаУчетаНоменклатуры
	|ИЗ
	|	ВтПрочиеРасходы КАК Строки
	|ГДЕ
	|	Строки.ОрганизацияПолучатель <> Строки.Организация
	|	И Строки.ОрганизацияПолучатель <> ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
	|	И (Строки.Сумма <> 0 ИЛИ Строки.СуммаБезНДС <> 0 ИЛИ Строки.СуммаУпр <> 0)
	|";
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#КонецЕсли
