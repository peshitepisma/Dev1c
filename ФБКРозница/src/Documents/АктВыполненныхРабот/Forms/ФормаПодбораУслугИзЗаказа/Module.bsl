
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ВалютаДокумента    = Параметры.ВалютаДокумента;
	НалогообложениеНДС = Параметры.НалогообложениеНДС;
	ЦенаВключаетНДС    = Параметры.ЦенаВключаетНДС;
	
	ЗаполнитьТаблицуУслуг(Параметры.ЗаказКлиента, Параметры.Документ, Параметры.ВалютаДокумента);
	ПодборТоваровКлиентСервер.СформироватьЗаголовокФормыПодбора(Заголовок, Параметры.Документ);

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)

	Если ПринудительноЗакрытьФорму Тогда
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда

		Отказ = Истина;
		ПоказатьВопрос(
			Новый ОписаниеОповещения("ПередЗакрытиемВопросЗавершение", ЭтотОбъект),
			НСтр("ru = 'Данные были изменены. Перенести изменения в документ?'"),
			РежимДиалогаВопрос.ДаНетОтмена);

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемВопросЗавершение(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		
		ПеренестиТоварыВДокумент();
		
		ПринудительноЗакрытьФорму = Истина;
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыУслуги

&НаКлиенте
Процедура ТаблицаУслугВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Элементы.ТаблицаУслуг.ТекущиеДанные <> Неопределено Тогда
		Если Поле.Имя = "ТаблицаУслугЗаказКлиента" Тогда
			ПоказатьЗначение(Неопределено, Элементы.ТаблицаУслуг.ТекущиеДанные.ЗаказКлиента);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПеренестиВДокументВыполнить()

	ПеренестиТоварыВДокумент();

КонецПроцедуры

&НаКлиенте
Процедура ВыбратьТоварыВыполнить()

	ВыбратьВсеТоварыНаСервере(Истина);

КонецПроцедуры

&НаКлиенте
Процедура ИсключитьТоварыВыполнить()

	ВыбратьВсеТоварыНаСервере(Ложь);

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаУслуг.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаУслуг.ПрисутствуетВДокументе");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Gray);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаУслугЗаказКлиента.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаУслуг.ЗаказКлиента");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветГиперссылки);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаУслугСуммаСНДС.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ЦенаВключаетНДС");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаУслугСуммаНДС.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаУслугСуммаСНДС.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаУслугСтавкаНДС.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НалогообложениеНДС");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ТипыНалогообложенияНДС.ПродажаНеОблагаетсяНДС;

	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);

КонецПроцедуры

#Область Прочее

&НаКлиенте
Процедура ПеренестиТоварыВДокумент()
	
	АдресТоваровВХранилище = ПоместитьТоварыВХранилище();
	
	ОповеститьОВыборе(Новый Структура("АдресТоваровВХранилище", АдресТоваровВХранилище));
	
КонецПроцедуры

&НаСервере
Процедура ВыбратьВсеТоварыНаСервере(ЗначениеВыбора = Истина)
	
	Для Каждого СтрокаТаблицы Из ТаблицаУслуг.НайтиСтроки(Новый Структура("СтрокаВыбрана", Не ЗначениеВыбора)) Цикл
		СтрокаТаблицы.СтрокаВыбрана = ЗначениеВыбора;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПоместитьТоварыВХранилище()
	
	// Формирование таблицы для возврата в документ.
	ТаблицаВыбранныхТоваров = ТаблицаУслуг.Выгрузить(Новый Структура("СтрокаВыбрана", Истина));
	
	// Формирование таблицы скидок для возврата в документ.
	ТаблицаВыбранныхСкидокНаценок = ТаблицаСкидкиНаценки.Выгрузить(Новый Структура("КлючСвязи", -1));
	СтруктураПоиска = Новый Структура("КлючСвязи");
	Для Каждого СтрокаТоваров Из ТаблицаВыбранныхТоваров Цикл
		
		СтруктураПоиска.КлючСвязи = СтрокаТоваров.КлючСвязи;
		Для Каждого СтрокаСкидки Из ТаблицаСкидкиНаценки.НайтиСтроки(СтруктураПоиска) Цикл
			
			ЗаполнитьЗначенияСвойств(ТаблицаВыбранныхСкидокНаценок.Добавить(), СтрокаСкидки);
			
		КонецЦикла;
		
	КонецЦикла;
	
	АдресТоваровВХранилище = ПоместитьВоВременноеХранилище(
		Новый Структура("Товары, СкидкиНаценки", ТаблицаВыбранныхТоваров, ТаблицаВыбранныхСкидокНаценок));
	
	Возврат АдресТоваровВХранилище;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьТаблицуУслуг(ЗаказКлиента, Документ, ВалютаДокумента)
	
	ДанныеОтбора = Новый Структура();
	ДанныеОтбора.Вставить("Партнер",               Параметры.Партнер);
	ДанныеОтбора.Вставить("Контрагент",            Параметры.Контрагент);
	ДанныеОтбора.Вставить("Договор",               Параметры.Договор);
	ДанныеОтбора.Вставить("Организация",           Параметры.Организация);
	ДанныеОтбора.Вставить("Соглашение",            Параметры.Соглашение);
	ДанныеОтбора.Вставить("Валюта",                Параметры.ВалютаДокумента);
	ДанныеОтбора.Вставить("ВалютаВзаиморасчетов",  Параметры.ВалютаВзаиморасчетов);
	ДанныеОтбора.Вставить("НалогообложениеНДС",    Параметры.НалогообложениеНДС);
	ДанныеОтбора.Вставить("ЦенаВключаетНДС",       Параметры.ЦенаВключаетНДС);
	ДанныеОтбора.Вставить("Ссылка",                Параметры.Документ);
	ДанныеОтбора.Вставить("Сделка",                Параметры.Сделка);
	ДанныеОтбора.Вставить("Дата",                  Параметры.Дата);
	ДанныеОтбора.Вставить("ПорядокРасчетов",       Параметры.ПорядокРасчетов);
	ДанныеОтбора.Вставить("НаправлениеДеятельности", Параметры.НаправлениеДеятельности);
	
	Если Не ЗначениеЗаполнено(Параметры.ЗаказКлиента) Или ПолучитьФункциональнуюОпцию("ИспользоватьАктыВыполненныхРаботПоНесколькимЗаказам") Тогда
		МассивЗаказов = Неопределено;
	Иначе
		МассивЗаказов = Новый Массив();
		МассивЗаказов.Добавить(ЗаказКлиента);
	КонецЕсли;
	
	Документы.АктВыполненныхРабот.ЗаполнитьПоОстаткамЗаказов(
		ДанныеОтбора,
		ТаблицаУслуг,
		ТаблицаСкидкиНаценки,
		МассивЗаказов,
		Ложь);
	
	ЗаказыСервер.УстановитьПризнакиПрисутствияСтрокиВДокументе(ТаблицаУслуг, "ЗаказКлиента", Параметры.МассивКодовСтрок);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
