#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	
КонецПроцедуры

// Возвращает массив реквизитов, доступных для типа первичного документа
//
// Параметры:
// 	ТипПервичногоДокумента - ПеречислениеСсылка.ТипыПервичныхДокумента - Тип первичного документа
//
// Возвращаемое значение:
// 	Результат - Структура - Структура с полями
// 	                          * МассивВсехРеквизитов - Массив - Все условно видиные реквизиты
// 	                          * МассивРеквизитовДляТипа - Массив - Реквизиты, видиные для типа документа
//
Функция МассивРеквизитовПоТипуПервичногоДокумента(ТипПервичногоДокумента) Экспорт
	
	МассивВсехРеквизитов = Новый Массив;
	МассивВсехРеквизитов.Добавить("Партнер");
	МассивВсехРеквизитов.Добавить("Контрагент");
	МассивВсехРеквизитов.Добавить("Договор");
	МассивВсехРеквизитов.Добавить("ГруппаФинансовогоУчета");
	МассивВсехРеквизитов.Добавить("НаправлениеДеятельности");
	МассивВсехРеквизитов.Добавить("Подразделение");
	МассивВсехРеквизитов.Добавить("ПорядокРасчетов");
	МассивВсехРеквизитов.Добавить("Валюта");
	МассивВсехРеквизитов.Добавить("НомерВходящегоДокумента");
	МассивВсехРеквизитов.Добавить("ДатаВходящегоДокумента");
	МассивВсехРеквизитов.Добавить("СуммаДокумента");
	МассивВсехРеквизитов.Добавить("СуммаРегл");
	
	МассивРеквизитовДляТипа = Новый Массив;
	Если ТипПервичногоДокумента = Перечисления.ТипыПервичныхДокументов.ПриобретениеУПоставщика Тогда
		МассивРеквизитовДляТипа.Добавить("Партнер");
		МассивРеквизитовДляТипа.Добавить("Контрагент");
		МассивРеквизитовДляТипа.Добавить("Договор");
		МассивРеквизитовДляТипа.Добавить("ГруппаФинансовогоУчета");
		МассивРеквизитовДляТипа.Добавить("НаправлениеДеятельности");
		МассивРеквизитовДляТипа.Добавить("Подразделение");
		МассивРеквизитовДляТипа.Добавить("ПорядокРасчетов");
		МассивРеквизитовДляТипа.Добавить("Валюта");
		МассивРеквизитовДляТипа.Добавить("НомерВходящегоДокумента");
		МассивРеквизитовДляТипа.Добавить("ДатаВходящегоДокумента");
		МассивРеквизитовДляТипа.Добавить("СуммаДокумента");
		МассивРеквизитовДляТипа.Добавить("СуммаРегл");
		
	ИначеЕсли ТипПервичногоДокумента = Перечисления.ТипыПервичныхДокументов.РеализацияКлиенту Тогда
		МассивРеквизитовДляТипа.Добавить("Партнер");
		МассивРеквизитовДляТипа.Добавить("Контрагент");
		МассивРеквизитовДляТипа.Добавить("Договор");
		МассивРеквизитовДляТипа.Добавить("ГруппаФинансовогоУчета");
		МассивРеквизитовДляТипа.Добавить("НаправлениеДеятельности");
		МассивРеквизитовДляТипа.Добавить("Подразделение");
		МассивРеквизитовДляТипа.Добавить("ПорядокРасчетов");
		МассивРеквизитовДляТипа.Добавить("Валюта");
		МассивРеквизитовДляТипа.Добавить("СуммаДокумента");
		МассивРеквизитовДляТипа.Добавить("СуммаРегл");
		
	ИначеЕсли ТипПервичногоДокумента = Перечисления.ТипыПервичныхДокументов.ОплатаПоставщику Тогда
		МассивРеквизитовДляТипа.Добавить("Партнер");
		МассивРеквизитовДляТипа.Добавить("Контрагент");
		МассивРеквизитовДляТипа.Добавить("Договор");
		МассивРеквизитовДляТипа.Добавить("ГруппаФинансовогоУчета");
		МассивРеквизитовДляТипа.Добавить("НаправлениеДеятельности");
		МассивРеквизитовДляТипа.Добавить("Подразделение");
		МассивРеквизитовДляТипа.Добавить("ПорядокРасчетов");
		МассивРеквизитовДляТипа.Добавить("Валюта");
		МассивРеквизитовДляТипа.Добавить("НомерВходящегоДокумента");
		МассивРеквизитовДляТипа.Добавить("ДатаВходящегоДокумента");
		МассивРеквизитовДляТипа.Добавить("СуммаДокумента");
		МассивРеквизитовДляТипа.Добавить("СуммаРегл");
		
	ИначеЕсли ТипПервичногоДокумента = Перечисления.ТипыПервичныхДокументов.ОплатаОтКлиента Тогда
		МассивРеквизитовДляТипа.Добавить("Партнер");
		МассивРеквизитовДляТипа.Добавить("Контрагент");
		МассивРеквизитовДляТипа.Добавить("Договор");
		МассивРеквизитовДляТипа.Добавить("ГруппаФинансовогоУчета");
		МассивРеквизитовДляТипа.Добавить("НаправлениеДеятельности");
		МассивРеквизитовДляТипа.Добавить("Подразделение");
		МассивРеквизитовДляТипа.Добавить("ПорядокРасчетов");
		МассивРеквизитовДляТипа.Добавить("Валюта");
		МассивРеквизитовДляТипа.Добавить("НомерВходящегоДокумента");
		МассивРеквизитовДляТипа.Добавить("ДатаВходящегоДокумента");
		МассивРеквизитовДляТипа.Добавить("СуммаДокумента");
		МассивРеквизитовДляТипа.Добавить("СуммаРегл");
	
	ИначеЕсли ТипПервичногоДокумента = Перечисления.ТипыПервичныхДокументов.ВнутренняяНакладная Тогда 
		
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("МассивВсехРеквизитов", МассивВсехРеквизитов);
	Результат.Вставить("МассивРеквизитовДляТипа", МассивРеквизитовДляТипа);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытия

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Поля.Добавить("Ссылка");
	Поля.Добавить("ТипПервичногоДокумента");
	Поля.Добавить("Номер");
	Поля.Добавить("Дата");
	
КонецПроцедуры

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Представление = СтрШаблон(НСтр("ru = '%1 %2 от %3'"), Данные.ТипПервичногоДокумента, СокрЛП(Данные.Номер), Данные.Дата)
	
КонецПроцедуры

#КонецОбласти
