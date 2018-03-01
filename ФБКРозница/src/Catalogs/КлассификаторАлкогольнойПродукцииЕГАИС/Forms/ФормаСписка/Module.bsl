#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ИнтеграцияЕГАИСПереопределяемый.НастроитьПодключаемоеОборудование(ЭтотОбъект);
	
	Поля = Новый Массив;
	Поля.Добавить("Сопоставлено");
	
	Список.УстановитьОграниченияИспользованияВГруппировке(Поля);
	Список.УстановитьОграниченияИспользованияВОтборе(Поля);
	Список.УстановитьОграниченияИспользованияВПорядке(Поля);
	
	СобытияФормЕГАИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПоддерживаемыеТипыПодключаемогоОборудования = "СканерШтрихкода";
	
	ОповещениеПриПодключении = Новый ОписаниеОповещения("ПодключитьОборудованиеЗавершение", ЭтотОбъект);
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(
		ОповещениеПриПодключении,
		ЭтотОбъект,
		ПоддерживаемыеТипыПодключаемогоОборудования);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	ОповещениеПриОтключении = Новый ОписаниеОповещения("ОтключитьОборудованиеЗавершение", ЭтотОбъект);
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(ОповещениеПриОтключении, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	СобытияФормЕГАИСКлиентПереопределяемый.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
	Если ИмяСобытия = "ИзменениеСопоставленияАлкогольнойПродукцииЕГАИС" Тогда
		
		Элементы.Список.Обновить();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	
	ОповещенияПриЗавершении = СобытияФормЕГАИСКлиент.СтруктураОповещенийВнешнегоСобытия(ЭтотОбъект, Истина, Истина);
	
	СобытияФормЕГАИСКлиент.ВнешнееСобытиеПолученыШтрихкоды(ОповещенияПриЗавершении, ЭтотОбъект, Источник, Событие, Данные);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле = Элементы.Сопоставлено Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ТекущиеДанные = Элементы.Список.ТекущиеДанные;
		
		ИнтеграцияЕГАИСКлиент.ОткрытьФормуСопоставленияАлкогольнойПродукции(
			ТекущиеДанные.Ссылка,
			ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СоответствиеНоменклатурыЕГАИС.АлкогольнаяПродукция
	|ПОМЕСТИТЬ Товары
	|ИЗ
	|	РегистрСведений.СоответствиеНоменклатурыЕГАИС КАК СоответствиеНоменклатурыЕГАИС
	|ГДЕ
	|	СоответствиеНоменклатурыЕГАИС.АлкогольнаяПродукция В(&АлкогольнаяПродукция)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТабличнаяЧасть.АлкогольнаяПродукция КАК АлкогольнаяПродукция,
	|	СУММА(1) КАК Количество
	|ПОМЕСТИТЬ СопоставленоПозиций
	|ИЗ
	|	Товары КАК ТабличнаяЧасть
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СоответствиеНоменклатурыЕГАИС КАК СоответствиеНоменклатурыЕГАИС
	|		ПО (СоответствиеНоменклатурыЕГАИС.АлкогольнаяПродукция = ТабличнаяЧасть.АлкогольнаяПродукция)
	|ГДЕ
	|	НЕ СоответствиеНоменклатурыЕГАИС.АлкогольнаяПродукция ЕСТЬ NULL
	|
	|СГРУППИРОВАТЬ ПО
	|	ТабличнаяЧасть.АлкогольнаяПродукция
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Т.Ссылка                                     КАК Ссылка,
	|	ЕСТЬNULL(СопоставленоПозиций.Количество, 0)  КАК Количество,
	|	СоответствиеНоменклатурыЕГАИС.Номенклатура   КАК Номенклатура,
	|	СоответствиеНоменклатурыЕГАИС.Характеристика КАК Характеристика
	|ИЗ
	|	Справочник.КлассификаторАлкогольнойПродукцииЕГАИС КАК Т
	|		ЛЕВОЕ СОЕДИНЕНИЕ СопоставленоПозиций КАК СопоставленоПозиций
	|		ПО (СопоставленоПозиций.АлкогольнаяПродукция = Т.Ссылка)
	|		
	|		ЛЕВОЕ СОЕДИНЕНИЕ Товары КАК Товары
	|		ПО (Товары.АлкогольнаяПродукция = Т.Ссылка)
	|		И СопоставленоПозиций.Количество = 1
	|		
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СоответствиеНоменклатурыЕГАИС КАК СоответствиеНоменклатурыЕГАИС
	|		ПО (Т.Ссылка = СоответствиеНоменклатурыЕГАИС.АлкогольнаяПродукция)
	|		И СопоставленоПозиций.Количество = 1
	|	
	|ГДЕ
	|	Т.Ссылка В(&АлкогольнаяПродукция)");
	Запрос.УстановитьПараметр("АлкогольнаяПродукция", Строки.ПолучитьКлючи());
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		СтрокаСписка = Строки[Выборка.Ссылка];
		
		Если Выборка.Количество = 1 Тогда
			СтрокаСписка.Данные["Сопоставлено"] = ИнтеграцияЕГАИСПереопределяемый.ПредставлениеНоменклатуры(
				Выборка.Номенклатура,
				Выборка.Характеристика, Неопределено);
			СтрокаСписка.Оформление["Сопоставлено"].УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветГиперссылкиГИСМ);
		ИначеЕсли Выборка.Количество > 1 Тогда
			СтрокаСписка.Данные["Сопоставлено"] = СтрШаблон(НСтр("ru = '<Несколько позиций (%1)>'"), Выборка.Количество);
			СтрокаСписка.Оформление["Сопоставлено"].УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветГиперссылкиГИСМ);
		Иначе
			СтрокаСписка.Данные["Сопоставлено"] = НСтр("ru = '<Не сопоставлено>'");
			СтрокаСписка.Оформление["Сопоставлено"].УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЕГАИССтатусОбработкиОшибкаПередачи);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоискПоШтрихкодуВыполнить(Команда)
	
	ОчиститьСообщения();
	
	ШтрихкодированиеНоменклатурыЕГАИСКлиентПереопределяемый.ПоказатьВводШтрихкода(
		Новый ОписаниеОповещения("ПоискПоШтрихкодуЗавершение", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормЕГАИСКлиентПереопределяемый.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоШтрихкодуЗавершение(ДанныеШтрихкода, ДополнительныеПараметры) Экспорт
	
	ОповещенияПриЗавершении = СобытияФормЕГАИСКлиент.СтруктураОповещенийВнешнегоСобытия(ЭтотОбъект, Истина, Истина);
	
	АкцизныеМаркиЕГАИСКлиент.ОбработатьДанныеШтрихкода(ОповещенияПриЗавершении, ЭтотОбъект, ДанныеШтрихкода);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолученыШтрихкоды(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Количество() = 1 Тогда
		РезультатПоиска = ПолучитьДанныеПоШтрихкоду(Результат[0].Штрихкод);
		Если РезультатПоиска <> Неопределено Тогда
			Элементы.Список.ТекущаяСтрока = РезультатПоиска.НоменклатураЕГАИС;
		Иначе
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтрШаблон(
					НСтр("ru = 'По штрихкоду %1 не удалось найти алкогольную продукцию'"),
					Результат[0].Штрихкод));
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолученаАкцизнаяМарка(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Результат.АлкогольнаяПродукция)
		И ЗначениеЗаполнено(Результат.КодАлкогольнойПродукции) Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Операция",          ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЗапросАлкогольнойПродукции"));
		ПараметрыФормы.Вставить("ИмяПараметра",      "КОД");
		ПараметрыФормы.Вставить("ЗначениеПараметра", Результат.КодАлкогольнойПродукции);
		
		ОткрытьФорму(
			"ОбщаяФорма.ФормированиеИсходящегоЗапросаЕГАИС",
			ПараметрыФормы,
			ЭтотОбъект,,,,,
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
			
	ИначеЕсли ЗначениеЗаполнено(Результат.АлкогольнаяПродукция) Тогда
		
		Элементы.Список.ТекущаяСтрока = Результат.АлкогольнаяПродукция;
		
	Иначе
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтрШаблон(
				НСтр("ru = 'По коду акцизной марки %1 не удалось определить код алкогольной продукции'"),
				Результат.КодАкцизнойМарки));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолученDataMatrix(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Справки2.Количество() = 1 Тогда
		
		Элементы.Список.ТекущаяСтрока = Результат.Справки2[0].АлкогольнаяПродукция;
		
	Иначе
		
		СписокСсылок = Новый СписокЗначений;
		Для Каждого ДанныеСправки2 Из Результат.Справки2 Цикл
			СписокСсылок.Добавить(ДанныеСправки2.АлкогольнаяПродукция);
		КонецЦикла;
		
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список, "Ссылка");
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список,
			"Ссылка",
			СписокСсылок,
			ВидСравненияКомпоновкиДанных.ВСписке,,
			Истина,
			РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьДанныеПоШтрихкоду(Штрихкод)
	
	Возврат ШтрихкодированиеНоменклатурыЕГАИСПереопределяемый.НайтиПоШтрихкоду(Штрихкод);
	
КонецФункции

#Область Оборудование

&НаКлиенте
Процедура ПодключитьОборудованиеЗавершение(РезультатВыполнения, Параметры) Экспорт
	
	Если НЕ РезультатВыполнения.Результат Тогда
		ТекстСообщения = НСтр( "ru = 'При подключении оборудования произошла ошибка:""%ОписаниеОшибки%"".'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ОписаниеОшибки%" , РезультатВыполнения.ОписаниеОшибки);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьОборудованиеЗавершение(РезультатВыполнения, Параметры) Экспорт
	
	Если НЕ РезультатВыполнения.Результат Тогда
		ТекстСообщения = НСтр( "ru = 'При отключении оборудования произошла ошибка: ""%ОписаниеОшибки%"".'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ОписаниеОшибки%" , РезультатВыполнения.ОписаниеОшибки);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти