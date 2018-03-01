
#Область СлужебныйПрограммныйИнтерфейс

Процедура ЗаполнитьИндексАкцизнойМарки(ТекущаяСтрока, ИмяКолонкиКоличество) Экспорт
	
	Если ТекущаяСтрока.МаркируемаяАлкогольнаяПродукция = Истина Тогда
		
		Если  ТекущаяСтрока[ИмяКолонкиКоличество] = ТекущаяСтрока.КоличествоАкцизныхМарок
			И ТекущаяСтрока[ИмяКолонкиКоличество] <> 0 Тогда
			ТекущаяСтрока.ИндексАкцизнойМарки = 1;
		Иначе
			ТекущаяСтрока.ИндексАкцизнойМарки = 2;
		КонецЕсли;
		
	Иначе
		
		ТекущаяСтрока.ИндексАкцизнойМарки = 0;
		
	КонецЕсли;
	
КонецПроцедуры

// Заполняет поле индекса акцизной марки в текущей строке табличной части документа.
//
// Параметры:
//	ТекущаяСтрока - Структура - структура со свойствами строки документа.
//	СтруктураДействий - Структура - структура с действиями, которые нужно произвести.
//
Процедура ЗаполнитьИндексАкцизнойМаркиДляСтрокиТабличнойЧасти(ТекущаяСтрока, СтруктураДействий) Экспорт
	
	ПараметрыДействия = Неопределено;
	Если СтруктураДействий.Свойство("ЗаполнитьИндексАкцизнойМарки", ПараметрыДействия) Тогда
		
		Если ПараметрыДействия <> Неопределено И ПараметрыДействия.Свойство("ИмяКолонкиКоличество") Тогда
			ИмяКолонкиКоличество = ПараметрыДействия.ИмяКолонкиКоличество;
		Иначе
			ИмяКолонкиКоличество = "Количество";
		КонецЕсли;
		
		АкцизныеМаркиКлиентСервер.ЗаполнитьИндексАкцизнойМарки(ТекущаяСтрока, ИмяКолонкиКоличество);
		
	КонецЕсли;
	
КонецПроцедуры

// Возвращает структуру параметров сканирования акцизных марок.
//
Функция ПараметрыСканированияАкцизныхМарок() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ИдентификаторСтроки"                , Неопределено);
	Результат.Вставить("Редактирование"                     , Ложь);
	Результат.Вставить("АдресВоВременномХранилище"          , "");
	Результат.Вставить("КонтрольАкцизныхМарок"              , Ложь);
	Результат.Вставить("ПоказатьОшибкуКонтроляАкцизныхМарок", Истина);
	Результат.Вставить("ПоказатьОшибкуОтсутствияСправок2"   , Истина);
	Результат.Вставить("Форма"                              , Неопределено);
	Результат.Вставить("ОповещениеПриЗавершении"            , Неопределено);
	Результат.Вставить("ИмяКолонкиКоличество"               , "Количество");
	Результат.Вставить("ЗапрашиватьНоменклатуру"            , Ложь);
	
	Возврат Результат;
	
КонецФункции

// Возвращает структуру параметров контроля акцизных марок.
//
Функция ПараметрыКонтроляАкцизныхМарок(КонтрольАкцизныхМарок) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("КонтрольАкцизныхМарок", КонтрольАкцизныхМарок);
	Результат.Вставить("Операция"             , ОперацияКонтроляАкцизныхМарокПоУмолчанию());
	
	Возврат Результат;
	
КонецФункции

// Возвращает операцию контроля акцизных марок по умолчанию.
//
Функция ОперацияКонтроляАкцизныхМарокПоУмолчанию() Экспорт
	
	Возврат "Продажа";
	
КонецФункции

// Проверяет соответствие переданного штрихкода формату Data Matrix.
//
// Параметры:
//  Штрихкод - Строка - проверяемый штрихкод.
//
// Возвращаемое значение:
//  Булево - Истина, если штрихкод в формате Data Matrix, Ложь - в противном случае.
//
Функция ЭтоШтрихкодDataMatrix(Штрихкод) Экспорт
	
	Если СтрДлина(Штрихкод) < 15 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Сред(Штрихкод, 4, 1) <> "-" Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ПроверяемыйШтрихкод = СтрЗаменить(Штрихкод, "-", "");
	
	Для Сч = 1 По Мин(15, СтрДлина(ПроверяемыйШтрихкод)) Цикл
		Если СтрНайти("0123456789", Сред(ПроверяемыйШтрихкод, Сч, 1)) = 0 Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

// Извлекает из переданного штрихкода тип, серию и номер марки.
//
// Параметры:
//  Штрихкод - Строка - штрихкод в формате Data Matrix, виды:
//     ВВВ-СССННННННННХХХХХХХХХХХХ - акцизная марка (АМ),
//     ВВВ-СССНННННННННХХХХХХХХХХХХ - федеральная спец. марка (ФСМ),
//  ТекстОшибки - Строка - если в процессе разбора произошла ошибка, в переменную вернется ее текст.
//
// Возвращаемое значение:
//  Структура - данные марки:
//   * ТипМарки - Строка(3),
//   * СерияМарки - Строка(3),
//   * НомерМарки - Строка(8 или 9).
//
Функция РазложитьШтрихкодDataMatrix(Штрихкод, ТекстОшибки = "") Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ТипМарки"  , "");
	Результат.Вставить("СерияМарки", "");
	Результат.Вставить("НомерМарки", "");
	
	Если НЕ ЭтоШтрихкодDataMatrix(Штрихкод) Тогда
		ТекстОшибки = НСтр("ru='Штрихкод %1 не соответствует формату Data Matrix.'");
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, Штрихкод);
		Возврат Результат;
	КонецЕсли;
	
	ТипМарки = АкцизныеМаркиВызовСервера.ТипАкцизнойМарки(Лев(Штрихкод, 3));
	
	Если НЕ ЗначениеЗаполнено(ТипМарки.ВидМарки) Тогда
		ТекстОшибки = НСтр("ru='Ошибка при обработке штрихкода %1: Не удалось определить вид акцизной марки (ФСМ или АМ).'");
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, Штрихкод);
		Возврат Результат;
	КонецЕсли;
	
	ДлинаНомера = ?(ТипМарки.ВидМарки = "АМ", 8, 9);
	
	Результат.ТипМарки   = Лев(Штрихкод, 3);
	Результат.СерияМарки = Сред(Штрихкод, 5, 3);
	Результат.НомерМарки = Сред(Штрихкод, 8, ДлинаНомера);
	
	Возврат Результат;
	
КонецФункции

// Возвращает структуру результата обработки штрихкода акцизной марки.
//
Функция РезультатОбработкиШтрихкодаАкцизнойМарки(КодАкцизнойМарки) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("КодАкцизнойМарки",                 КодАкцизнойМарки);
	Результат.Вставить("КодАлкогольнойПродукции",          "");
	Результат.Вставить("Номенклатура",                     Неопределено);
	Результат.Вставить("Характеристика",                   Неопределено);
	Результат.Вставить("Упаковка",                         Неопределено);
	Результат.Вставить("АлкогольнаяПродукция",             Неопределено);
	Результат.Вставить("Обработан",                        Ложь);
	Результат.Вставить("ТекстОшибкиКонтроляАкцизныхМарок", "");
	
	Возврат Результат;
	
КонецФункции

// Возвращает структуру результата обработки штрихкода Data Matrix.
//
Функция РезультатОбработкиШтрихкодаDataMatrix(Штрихкод) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("Штрихкод"   , Штрихкод);
	Результат.Вставить("ТипМарки"   , "");
	Результат.Вставить("СерияМарки" , "");
	Результат.Вставить("НомерМарки" , "");
	Результат.Вставить("Справки2"   , Новый Массив);
	Результат.Вставить("Обработан"  , Ложь);
	Результат.Вставить("ТекстОшибки", "");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти