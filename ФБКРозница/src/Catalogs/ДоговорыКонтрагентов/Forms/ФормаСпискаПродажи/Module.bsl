
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ИспользоватьПартнеровКакКонтрагентов = (ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов"));
	Список.Параметры.УстановитьЗначениеПараметра("ДатаАктуальности", НачалоДня(ТекущаяДатаСеанса()));
	
	СтруктураБыстрогоОтбора = Неопределено;
	Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	
	ОтборыСписковКлиентСервер.ЗаполнитьСписокВыбораОтбораПоАктуальности(Элементы.ОтборСрокДействия.СписокВыбора);
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(Список, "Менеджер", Менеджер, СтруктураБыстрогоОтбора);
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(Список, "Организация", Организация, СтруктураБыстрогоОтбора);
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(Список, "Контрагент", Контрагент, СтруктураБыстрогоОтбора);
	ОтборыСписковКлиентСервер.ОтборПоАктуальностиПриСозданииНаСервере(Список, Актуальность, ДатаСобытия, СтруктураБыстрогоОтбора);
	
	Если Параметры.Свойство("Партнер") 
		ИЛИ (ИспользоватьПартнеровКакКонтрагентов 
		И Параметры.Свойство("Отбор") И Параметры.Отбор.Свойство("Контрагент")) Тогда
		
		Если Параметры.Свойство("Партнер") Тогда
			Партнер = Параметры.Партнер;
		Иначе
			Партнер = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.Отбор.Контрагент, "Партнер");
		КонецЕсли;
		
		УстановитьОтборПоПартнеру();
		
	Иначе
		
		Список.Параметры.УстановитьЗначениеПараметра("ПартнерПоУмолчанию", Справочники.Партнеры.ПустаяСсылка());
		
	КонецЕсли;

	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, 
		"ХозяйственнаяОперацияПоУмолчанию", 
		Перечисления.ХозяйственныеОперации.РеализацияКлиенту, 
		ВидСравненияКомпоновкиДанных.Равно,
		, 
		Истина);
	
	Если ОтборыСписковКлиентСервер.НеобходимОтборПоСостояниюПриСозданииНаСервере(Состояние, СтруктураБыстрогоОтбора) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Состояние", Состояние, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Состояние));
	КонецЕсли;
	
	ОтборыСписковКлиентСервер.СкопироватьСписокВыбораОтбораПоМенеджеру(
		Элементы.ОтборМенеджер.СписокВыбора, 
		ОбщегоНазначенияУТ.ПолучитьСписокПользователейСПравомДобавления(Метаданные.Справочники.ДоговорыКонтрагентов));
	
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма, Элементы.ГруппаГлобальныеКоманды);
	// Конец ИнтеграцияС1СДокументооборотом

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(Список, "Менеджер", Менеджер, СтруктураБыстрогоОтбора, Настройки);
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(Список, "Организация", Организация, СтруктураБыстрогоОтбора, Настройки);
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(Список, "Контрагент", Контрагент, СтруктураБыстрогоОтбора, Настройки);
	Если ИспользоватьПартнеровКакКонтрагентов И ЗначениеЗаполнено(Контрагент) Тогда
		УстановитьОтборПоКонтрагентуПартнера();
	КонецЕсли;
	ОтборыСписковКлиентСервер.ОтборПоАктуальностиПриЗагрузкеИзНастроек(Список, Актуальность, ДатаСобытия, СтруктураБыстрогоОтбора, Настройки);
	
	Если ОтборыСписковКлиентСервер.НеобходимОтборПоСостояниюПриЗагрузкеИзНастроек(Состояние, СтруктураБыстрогоОтбора, Настройки) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Состояние", Состояние, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Состояние));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборСостояниеПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Состояние", Состояние, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Состояние));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСрокДействияПриИзменении(Элемент)
	
	ОтборыСписковКлиентСервер.ПриИзмененииОтбораПоАктуальности(Список, Актуальность, ДатаСобытия);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСрокДействияОчистка(Элемент, СтандартнаяОбработка)
	
	ОтборыСписковКлиентСервер.ПриОчисткеОтбораПоАктуальности(Список, Актуальность, ДатаСобытия, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСрокДействияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ОбщегоНазначенияУТКлиент.ПриВыбореОтбораПоАктуальности(
		ВыбранноеЗначение, 
		СтандартнаяОбработка, 
		ЭтаФорма,
		Список, 
		"Актуальность", 
		"ДатаСобытия");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, 
		"Организация", 
		Организация, 
		ВидСравненияКомпоновкиДанных.Равно,
		, 
		ЗначениеЗаполнено(Организация));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборКонтрагентПриИзменении(Элемент)
	
	Если ИспользоватьПартнеровКакКонтрагентов Тогда
		
		УстановитьОтборПоКонтрагентуПартнера();
		
	Иначе
	
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, 
			"Контрагент", 
			Контрагент, 
			ВидСравненияКомпоновкиДанных.Равно,
			, 
			ЗначениеЗаполнено(Контрагент));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборМенеджерПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, 
		"Менеджер", 
		Менеджер, 
		ВидСравненияКомпоновкиДанных.Равно,
		, 
		ЗначениеЗаполнено(Менеджер));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьСтатусНеСогласован(Команда)
	
	ВыделенныеСтроки = ОбщегоНазначенияУТКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Список);
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru='У выделенных в списке договоров будет установлен статус ""Не согласован"". По действующим договорам могут быть оформлены документы. После изменения статуса действующие договоры перестанут действовать. Продолжить?'");
	
	Ответ = Неопределено;

	
	ПоказатьВопрос(Новый ОписаниеОповещения("УстановитьСтатусНеСогласованЗавершение", ЭтотОбъект, Новый Структура("ВыделенныеСтроки", ВыделенныеСтроки)), ТекстВопроса,РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусНеСогласованЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    ВыделенныеСтроки = ДополнительныеПараметры.ВыделенныеСтроки;
    
    
    Ответ = РезультатВопроса;
    Если Ответ = КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;
    
    ОчиститьСообщения();
    КоличествоОбработанных = УстановитьСтатусСервер(ВыделенныеСтроки, "НеСогласован");
    ОбщегоНазначенияУТКлиент.ОповеститьПользователяОбУстановкеСтатуса(Элементы.Список, КоличествоОбработанных, ВыделенныеСтроки.Количество(), НСтр("ru='Не согласован'"));

КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусДействует(Команда)
	
	ВыделенныеСтроки = ОбщегоНазначенияУТКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Список);
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru='У выделенных в списке договоров будет установлен статус ""Действует"". Продолжить?'");
	
	Ответ = Неопределено;

	
	ПоказатьВопрос(Новый ОписаниеОповещения("УстановитьСтатусДействуетЗавершение", ЭтотОбъект, Новый Структура("ВыделенныеСтроки", ВыделенныеСтроки)), ТекстВопроса,РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусДействуетЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    ВыделенныеСтроки = ДополнительныеПараметры.ВыделенныеСтроки;
    
    
    Ответ = РезультатВопроса;
    Если Ответ = КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;
    
    ОчиститьСообщения();
    КоличествоОбработанных = УстановитьСтатусСервер(ВыделенныеСтроки, "Действует");
    ОбщегоНазначенияУТКлиент.ОповеститьПользователяОбУстановкеСтатуса(Элементы.Список, КоличествоОбработанных, ВыделенныеСтроки.Количество(), НСтр("ru='Действует'"));

КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусЗакрыт(Команда)
	
	ВыделенныеСтроки = ОбщегоНазначенияУТКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Список);
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru='У выделенных в списке договоров будет установлен статус ""Закрыт"". После изменения статуса действующие договоры перестанут действовать. Продолжить?'");
	
	Ответ = Неопределено;

	
	ПоказатьВопрос(Новый ОписаниеОповещения("УстановитьСтатусЗакрытЗавершение", ЭтотОбъект, Новый Структура("ВыделенныеСтроки", ВыделенныеСтроки)), ТекстВопроса,РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусЗакрытЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    ВыделенныеСтроки = ДополнительныеПараметры.ВыделенныеСтроки;
    
    
    Ответ = РезультатВопроса;
    Если Ответ = КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;
    
    ОчиститьСообщения();
    КоличествоОбработанных = УстановитьСтатусСервер(ВыделенныеСтроки, "Закрыт");
    ОбщегоНазначенияУТКлиент.ОповеститьПользователяОбУстановкеСтатуса(Элементы.Список, КоличествоОбработанных, ВыделенныеСтроки.Количество(), НСтр("ru='Закрыт'"));

КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
//Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры


// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// Конец МенюОтчеты

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаСервереБезКонтекста
Функция УстановитьСтатусСервер(Знач Договоры, НовыйСтатус)
	
	Возврат Справочники.ДоговорыКонтрагентов.УстановитьСтатус(Договоры, Перечисления.СтатусыДоговоровКонтрагентов[НовыйСтатус]);
	
КонецФункции

&НаСервере
Процедура УстановитьОтборПоКонтрагентуПартнера()

	Партнер = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Контрагент, "Партнер");
	УстановитьОтборПоПартнеру();

КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоПартнеру()

	Список.Параметры.УстановитьЗначениеПараметра("ПартнерПоУмолчанию", Партнер);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, 
		"ПартнерПоУмолчанию", 
		Партнер, 
		ВидСравненияКомпоновкиДанных.Равно,
		, 
		ЗначениеЗаполнено(Партнер));
		
	СписокПартнеров = Новый СписокЗначений;
	ПартнерыИКонтрагенты.ЗаполнитьСписокПартнераСРодителями(Партнер, СписокПартнеров);

	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, 
		"Партнер", 
		СписокПартнеров, 
		ВидСравненияКомпоновкиДанных.ВСписке,
		, 
		ЗначениеЗаполнено(Партнер));

КонецПроцедуры

#КонецОбласти

#КонецОбласти
