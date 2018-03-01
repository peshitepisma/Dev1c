&НаКлиенте
Перем ВыполняетсяЗакрытие;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();

	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ХозяйственныеОперацииРаздельнойЗакупки = ЗакупкиСервер.ХозяйственныеОперацииРаздельнойЗакупкиБезОтборов();
	
	ИспользуетсяОперацияРаздельнойЗакупки = Ложь;
	Если ХозяйственныеОперацииРаздельнойЗакупки.Найти(Параметры.ХозяйственнаяОперация) <> Неопределено Тогда
		ИспользуетсяОперацияРаздельнойЗакупки = Истина;
	КонецЕсли;
	
	ВалютаДокумента    = Параметры.ВалютаДокумента;
	НалогообложениеНДС = Параметры.НалогообложениеНДС;
	ЦенаВключаетНДС    = Параметры.ЦенаВключаетНДС;
	ПоступлениеПоЗаказам = Параметры.ПоступлениеПоЗаказам;
	ЗаказПоставщику      = Параметры.ЗаказПоставщику;
	
	АдресТоварыНакладнойВоВременномХранилище = Параметры.АдресТоварыНакладнойВоВременномХранилище;
	ИспользоватьПоступлениеПоНесколькимЗаказам = ПолучитьФункциональнуюОпцию("ИспользоватьПоступлениеПоНесколькимЗаказам");
	ИспользоватьОрдернуюСхемуПриПоступлении = Параметры.ОрдернаяСхемаПриПриемке;
	ИспользоватьЗаказыПоставщикам = ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыПоставщикам");
	
	Элементы.ПоОрдеру.Видимость = ИспользоватьЗаказыПоставщикам И ИспользоватьОрдернуюСхемуПриПоступлении;
	Если ИспользуетсяОперацияРаздельнойЗакупки Тогда
		Элементы.ТаблицаТоваровКоличествоУпаковокВОрдере.Заголовок = НСтр("ru='В поступлениях'");
	КонецЕсли;
	Элементы.ПоступлениеПоЗаказу.Видимость = ПоступлениеПоЗаказам и ИспользоватьПоступлениеПоНесколькимЗаказам;
	Элементы.ЗаказПоставщику.Видимость = ПоступлениеПоЗаказам И ИспользоватьПоступлениеПоНесколькимЗаказам;
	Элементы.ПоступлениеПоЗаказам.Видимость = ПоступлениеПоЗаказам И ИспользоватьПоступлениеПоНесколькимЗаказам;
	Элементы.НадписьЗаголовокЗаказыПоставщикам.Видимость = ПоступлениеПоЗаказам И ИспользоватьПоступлениеПоНесколькимЗаказам;
	Элементы.ТаблицаТоваровКоличествоУпаковокВОрдере.Видимость = ИспользоватьОрдернуюСхемуПриПоступлении;
	
	ЗаполнитьТаблицуТоваров();
	ПодборТоваровКлиентСервер.СформироватьЗаголовокФормыПодбора(Заголовок, Параметры.Ссылка);
	УстановитьЗаголовокЗаполнитьПоЗаказамОрдерам();
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)

	Если НЕ ВыполняетсяЗакрытие и Модифицированность И НЕ ЗавершениеРаботы Тогда
		Отказ = Истина;
		ПоказатьВопрос(Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект), НСтр("ru = 'Данные были изменены. Перенести изменения в документ?'"), РежимДиалогаВопрос.ДаНетОтмена);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Ответ = РезультатВопроса;
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ВыполняетсяЗакрытие = Истина;
		Модифицированность = Ложь;
		ПеренестиТоварыВДокумент();
		
	ИначеЕсли Ответ = КодВозвратаДиалога.Нет Тогда
		ВыполняетсяЗакрытие = Истина;
		Модифицированность = Ложь;
		Закрыть();
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТаблицаТоваровВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Элементы.ТаблицаТоваров.ТекущиеДанные <> Неопределено Тогда
		Если Поле.Имя = "ТаблицаТоваровЗаказПоставщику" Тогда
			ПоказатьЗначение(Неопределено, Элементы.ТаблицаТоваров.ТекущиеДанные.ЗаказПоставщику);
		ИначеЕсли Поле.Имя = "ТаблицаТоваровСделка" Тогда
			ПоказатьЗначение(Неопределено, Элементы.ТаблицаТоваров.ТекущиеДанные.Сделка);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоОрдеруПриИзменении(Элемент)
	ПерезаполнитьКоличествоПодобрано();
КонецПроцедуры

&НаКлиенте
Процедура ПоЗаказамПриИзменении(Элемент)
	
	ПриИзмененииПоЗаказам();
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьЗаголовокЗаказыПоставщикамНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьФорму(
		"ОбщаяФорма.ПросмотрСпискаДокументов",
		Новый Структура("СписокДокументов, Заголовок",
			СписокЗаказов,
			НСтр("ru='Заказы поставщикам (%КоличествоДокументов%)'")
		),
		ЭтаФорма,,,, Неопределено, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПеренестиВДокументВыполнить()

	ПеренестиТоварыВДокумент();

КонецПроцедуры

&НаКлиенте
Процедура ВыбратьТоварыВыполнить()
	
	ВыбратьВсеТоварыНаСервере();
	
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
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаТоваров.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаТоваров.ПрисутствуетВДокументе");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Gray);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаТоваровЗаказПоставщику.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаТоваров.ЗаказПоставщику");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветГиперссылки);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаТоваровСделка.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаТоваров.Сделка");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветГиперссылки);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаТоваровСуммаСНДС.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ЦенаВключаетНДС");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаТоваровСуммаНДС.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаТоваровСтавкаНДС.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаТоваровСуммаСНДС.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НалогообложениеНДС");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ТипыНалогообложенияНДС.ПродажаНеОблагаетсяНДС;

	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);

	// Оформление склада и подразделения
	// отключение видимости склада, если работа или услуга

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаТоваровСклад.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаТоваров.ТипНоменклатуры");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	СписокЗначений = Новый СписокЗначений;
	СписокЗначений.Добавить(Перечисления.ТипыНоменклатуры.Работа);
	СписокЗначений.Добавить(Перечисления.ТипыНоменклатуры.Услуга);
	ОтборЭлемента.ПравоеЗначение = СписокЗначений;

	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
	// отключение видимости подразделения, если товар или тара

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаТоваровПодразделение.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаТоваров.ТипНоменклатуры");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	СписокЗначений = Новый СписокЗначений;
	СписокЗначений.Добавить(Перечисления.ТипыНоменклатуры.Товар);
	СписокЗначений.Добавить(Перечисления.ТипыНоменклатуры.МногооборотнаяТара);
	ОтборЭлемента.ПравоеЗначение = СписокЗначений;

	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
	НоменклатураСервер.УстановитьУсловноеОформлениеЕдиницИзмерения(ЭтаФорма, "ТаблицаТоваровНоменклатураЕдиницаИзмерения", "ТаблицаТоваров.Упаковка");

КонецПроцедуры

#Область Прочее

&НаСервере
Процедура ВыбратьВсеТоварыНаСервере(ЗначениеВыбора = Истина)
	
	Для Каждого СтрокаТаблицы Из ТаблицаТоваров.НайтиСтроки(Новый Структура("СтрокаВыбрана", Не ЗначениеВыбора)) Цикл
		
		СтрокаТаблицы.СтрокаВыбрана = ЗначениеВыбора;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПоместитьТоварыВХранилище()

	Возврат ПоместитьВоВременноеХранилище(ТаблицаТоваров.Выгрузить(Новый Структура("СтрокаВыбрана", Истина)));

КонецФункции

&НаСервере
Процедура ЗаполнитьТаблицуТоваров()
	
	ТоварыНакладной = ПолучитьИзВременногоХранилища(АдресТоварыНакладнойВоВременномХранилище);
	
	ДанныеОтбора = Новый Структура();
	ДанныеОтбора.Вставить("Партнер",                   Параметры.Партнер);
	ДанныеОтбора.Вставить("Контрагент",                Параметры.Контрагент);
	ДанныеОтбора.Вставить("Договор",                   Параметры.Договор);
	ДанныеОтбора.Вставить("Организация",               Параметры.Организация);
	ДанныеОтбора.Вставить("ХозяйственнаяОперация",     Параметры.ХозяйственнаяОперация);
	ДанныеОтбора.Вставить("Соглашение",                Параметры.Соглашение);
	ДанныеОтбора.Вставить("Валюта",                    Параметры.ВалютаДокумента);
	ДанныеОтбора.Вставить("ВалютаВзаиморасчетов",      Параметры.ВалютаВзаиморасчетов);
	ДанныеОтбора.Вставить("НалогообложениеНДС",        Параметры.НалогообложениеНДС);
	ДанныеОтбора.Вставить("ЦенаВключаетНДС",           Параметры.ЦенаВключаетНДС);
	ДанныеОтбора.Вставить("ПорядокРасчетов",           Параметры.ПорядокРасчетов);
	ДанныеОтбора.Вставить("ВернутьМногооборотнуюТару", Параметры.ВернутьМногооборотнуюТару);
	ДанныеОтбора.Вставить("Склад",                     Параметры.Склад);
	ДанныеОтбора.Вставить("Ссылка",                    Параметры.Ссылка);
	ДанныеОтбора.Вставить("НаправлениеДеятельности",   Параметры.НаправлениеДеятельности);
	ДанныеОтбора.Вставить("ВариантПриемкиТоваров",     Параметры.ВариантПриемкиТоваров);
	ДанныеОтбора.Вставить("ТоварыНакладной",           ТоварыНакладной);
	
	Если Не ЗначениеЗаполнено(Параметры.ЗаказПоставщику) Или ПолучитьФункциональнуюОпцию("ИспользоватьПоступлениеПоНесколькимЗаказам") Тогда
		МассивЗаказов = Неопределено;
	Иначе
		МассивЗаказов = Новый Массив();
		МассивЗаказов.Добавить(Параметры.ЗаказПоставщику);
	КонецЕсли;
	
	ЗаполнитьПоЗаказамПоПриемке(ДанныеОтбора, ТаблицаТоваров, Параметры.Склад, ПоОрдеру, МассивЗаказов);
	ЗаказыСервер.УстановитьПризнакиПрисутствияСтрокиВДокументе(ТаблицаТоваров, "ЗаказПоставщику", Параметры.МассивКодовСтрок);
	ПерезаполнитьКоличествоПодобрано(Истина, ТоварыНакладной);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоЗаказамПоПриемке(ДанныеОтбора, Товары, СкладПоступления, ПоОрдеру,
		МассивЗаказов = Неопределено) Экспорт
	
	РаспоряжениеЗаказ = Ложь;
	МенеджерОбъекта   = ОбщегоНазначения.МенеджерОбъектаПоСсылке(ДанныеОтбора.Ссылка);
	
	МенеджерОбъекта.ЗаполнитьПоОстаткамЗаказов(ДанныеОтбора, Товары, СкладПоступления, МассивЗаказов);
	
	ПринятыеТовары = ПолучитьРезультатЗапросаПоПринятымТоварам(ДанныеОтбора, СкладПоступления, МассивЗаказов).Выгрузить();
	
	Если ПринятыеТовары.Количество()<>0 Тогда
		ДокументПоступления = ПринятыеТовары.Получить(0).ЗаказПоставщику;
		РаспоряжениеЗаказ   = (ТипЗнч(ДокументПоступления) = Тип("ДокументСсылка.ЗаказПоставщику"));
	КонецЕсли;
	
	
	СтруктураПоиска = Новый Структура("Склад,Номенклатура,Характеристика,Назначение");
	
	Если РаспоряжениеЗаказ Тогда
		СтруктураПоиска.Вставить("ЗаказПоставщику");
	КонецЕсли;
	
	Для Каждого СтрокаТовары Из Товары Цикл
		
		СтрокаТовары.КоличествоУпаковокВЗаказе = СтрокаТовары.КоличествоВЗаказе / СтрокаТовары.Коэффициент;
		
		ЗаполнитьЗначенияСвойств(СтруктураПоиска, СтрокаТовары);
		НайденныеСтроки = ПринятыеТовары.НайтиСтроки(СтруктураПоиска);
		
		Если НайденныеСтроки.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		ПринятаяСтрока = НайденныеСтроки[0];
		СтрокаТовары.ОрдернаяСхемаПриПриемке = ПринятаяСтрока.ОрдернаяСхемаПриПриемке;
		СтрокаТовары.ТипНоменклатуры = ПринятаяСтрока.ТипНоменклатуры;
		
		Если ПринятаяСтрока.Количество > 0 Тогда
			Если ПринятаяСтрока.Количество <= СтрокаТовары.Количество Тогда
				СтрокаТовары.КоличествоВОрдере = ПринятаяСтрока.Количество;
				СтрокаТовары.КоличествоУпаковокВОрдере = ПринятаяСтрока.Количество / СтрокаТовары.Коэффициент;
				СтрокаТовары.Серия = ПринятаяСтрока.Серия;
				ПринятаяСтрока.Количество = 0;
				ПринятыеТовары.Удалить(ПринятаяСтрока);
			Иначе
				СтрокаТовары.КоличествоВОрдере = СтрокаТовары.Количество;
				СтрокаТовары.КоличествоУпаковокВОрдере = СтрокаТовары.Количество / СтрокаТовары.Коэффициент;
				СтрокаТовары.Серия = ПринятаяСтрока.Серия;
				ПринятаяСтрока.Количество = ПринятаяСтрока.Количество - СтрокаТовары.Количество;
			КонецЕсли;
		КонецЕсли;
		
		Если ПоОрдеру Тогда
			СтрокаТовары.Количество = СтрокаТовары.КоличествоВОрдере;
			СтрокаТовары.КоличествоУпаковок = СтрокаТовары.КоличествоУпаковокВОрдере;
		КонецЕсли;
		
	КонецЦикла;
	
	Если ПринятыеТовары.Количество() > 0 Тогда
		
		СписокСвойств = "Номенклатура,Характеристика,Склад";
		ДопустимыеОтклонения = ЗакупкиСервер.ДопустимыеОтклоненияМерныхТоваров(МассивЗаказов, РаспоряжениеЗаказ);
		
		Если РаспоряжениеЗаказ Тогда 
			СписокСвойств = СписокСвойств + ",ЗаказПоставщику";
		КонецЕсли;
		
		СтруктураПоискаОтклонений = Новый Структура(СписокСвойств);
		
		Для Каждого ПринятаяСтрока Из ПринятыеТовары Цикл
			
			Если ПринятаяСтрока.Количество > 0 Тогда
				ЗаполнитьЗначенияСвойств(СтруктураПоискаОтклонений, ПринятаяСтрока, СписокСвойств);
				
				СтрокиДопустимыхОтклонений = ДопустимыеОтклонения.НайтиСтроки(СтруктураПоискаОтклонений);
				СтрокиТоваров              = Товары.НайтиСтроки(СтруктураПоискаОтклонений);
				
				Если СтрокиТоваров.Количество() > 0 И СтрокиДопустимыхОтклонений.Количество() > 0 
					И СтрокиДопустимыхОтклонений[0].ДопустимоеОтклонение >= ПринятаяСтрока.Количество Тогда
					СтрокаТовары = СтрокиТоваров[0];
					СтрокаТовары.КоличествоВОрдере = СтрокаТовары.КоличествоВОрдере + ПринятаяСтрока.Количество;
					СтрокаТовары.КоличествоУпаковокВОрдере = СтрокаТовары.КоличествоВОрдере / СтрокаТовары.Коэффициент;
				Иначе
					СтрокаТовары = Товары.Добавить();
					ЗаполнитьЗначенияСвойств(СтрокаТовары, ПринятаяСтрока);
					СтрокаТовары.КоличествоВОрдере = ПринятаяСтрока.Количество;
					СтрокаТовары.КоличествоУпаковокВОрдере = ПринятаяСтрока.Количество;
				КонецЕсли;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьРезультатЗапросаПоПринятымТоварам(ДанныеОтбора,СкладПоступления = Неопределено,МассивЗаказов = Неопределено)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НакладнаяСсылка",         ДанныеОтбора.Ссылка);
	Запрос.УстановитьПараметр("ТекущаяДата",             ТекущаяДатаСеанса());
	Запрос.УстановитьПараметр("Соглашение",              ДанныеОтбора.Соглашение);
	Запрос.УстановитьПараметр("СкладПоступления",        СкладПоступления);
	Запрос.УстановитьПараметр("МассивЗаказов",           МассивЗаказов);
	Запрос.УстановитьПараметр("ЗаполнитьПоПоступлениям", ИспользуетсяОперацияРаздельнойЗакупки);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаОстатков.ДокументПоступления КАК ЗаказПоставщику,
	|	ТаблицаОстатков.Склад,
	|	ТаблицаОстатков.Номенклатура,
	|	ТаблицаОстатков.Номенклатура.ТипНоменклатуры КАК ТипНоменклатуры,
	|	ТаблицаОстатков.Характеристика,
	|	ТаблицаОстатков.Назначение,
	|	ТаблицаОстатков.Серия,
	|	ТаблицаОстатков.ОрдернаяСхемаПриПриемке,
	|	СУММА(ТаблицаОстатков.КОформлениюОстаток) КАК Количество
	|ИЗ
	|	(ВЫБРАТЬ
	|		ТоварыКОформлениюПоступленияОстатки.ДокументПоступления КАК ДокументПоступления,
	|		ТоварыКОформлениюПоступленияОстатки.Склад КАК Склад,
	|		ВЫБОР
	|			КОГДА ТоварыКОформлениюПоступленияОстатки.Склад.ИспользоватьОрдернуюСхемуПриПоступлении = ИСТИНА
	|					И ТоварыКОформлениюПоступленияОстатки.Склад.ДатаНачалаОрдернойСхемыПриПоступлении <= &ТекущаяДата
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ЛОЖЬ
	|		КОНЕЦ КАК ОрдернаяСхемаПриПриемке,
	|		ТоварыКОформлениюПоступленияОстатки.Номенклатура КАК Номенклатура,
	|		ТоварыКОформлениюПоступленияОстатки.Характеристика КАК Характеристика,
	|		ТоварыКОформлениюПоступленияОстатки.Назначение КАК Назначение,
	|		ТоварыКОформлениюПоступленияОстатки.Серия КАК Серия,
	|		ВЫБОР
	|			КОГДА &ЗаполнитьПоПоступлениям = ИСТИНА ТОГДА
	|				-ТоварыКОформлениюПоступленияОстатки.КОформлениюПоступленийПоНакладнымОстаток
	|			ИНАЧЕ
	|				ТоварыКОформлениюПоступленияОстатки.КОформлениюПоступленийПоОрдерамОстаток
	|		КОНЕЦ КАК КОформлениюОстаток
	|	ИЗ
	|		РегистрНакопления.ТоварыКПоступлению.Остатки(
	|				,
	|				ДокументПоступления В (&МассивЗаказов)
	|					ИЛИ ДокументПоступления = &Соглашение
	|					ИЛИ ДокументПоступления = &НакладнаяСсылка) КАК ТоварыКОформлениюПоступленияОстатки
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ТоварыКОформлениюПоступления.ДокументПоступления,
	|		ТоварыКОформлениюПоступления.Склад,
	|		ВЫБОР
	|			КОГДА ТоварыКОформлениюПоступления.Склад.ИспользоватьОрдернуюСхемуПриПоступлении = ИСТИНА
	|					И ТоварыКОформлениюПоступления.Склад.ДатаНачалаОрдернойСхемыПриПоступлении <= &ТекущаяДата
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ЛОЖЬ
	|		КОНЕЦ КАК ОрдернаяСхемаПриПриемке,
	|		ТоварыКОформлениюПоступления.Номенклатура,
	|		ТоварыКОформлениюПоступления.Характеристика,
	|		ТоварыКОформлениюПоступления.Назначение,
	|		ТоварыКОформлениюПоступления.Серия,
	|		ВЫБОР
	|			КОГДА &ЗаполнитьПоПоступлениям = ИСТИНА ТОГДА
	|				ТоварыКОформлениюПоступления.КОформлениюПоступленийПоНакладным
	|			ИНАЧЕ
	|				ТоварыКОформлениюПоступления.КОформлениюПоступленийПоОрдерам
	|		КОНЕЦ КАК Количество
	|	ИЗ
	|		РегистрНакопления.ТоварыКПоступлению КАК ТоварыКОформлениюПоступления
	|	ГДЕ
	|		ТоварыКОформлениюПоступления.Регистратор = &НакладнаяСсылка
	|		И ТоварыКОформлениюПоступления.Активность) КАК ТаблицаОстатков
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаОстатков.ДокументПоступления,
	|	ТаблицаОстатков.Склад,
	|	ТаблицаОстатков.ОрдернаяСхемаПриПриемке,
	|	ТаблицаОстатков.Номенклатура,
	|	ТаблицаОстатков.Характеристика,
	|	ТаблицаОстатков.Назначение,
	|	ТаблицаОстатков.Серия
	|
	|ИМЕЮЩИЕ
	|	СУММА(ТаблицаОстатков.КОформлениюОстаток) > 0";
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат Запрос.Выполнить();
	
КонецФункции

&НаСервере
Процедура ПерезаполнитьКоличествоПодобрано(СЗаполнением = Ложь, ТоварыНакладной = Неопределено)
	
	Если СЗаполнением Тогда
		ОбновитьИнформациюПоЗаказам(ТоварыНакладной);
		ПоЗаказам = ?(СписокЗаказов.Количество() > 0, СписокЗаказов.Количество() > 0, ЗначениеЗаполнено(ЗаказПоставщику));
		
		УстановитьОтборПоЗаказам();
		СтруктураПоиска = Новый Структура("Номенклатура, Характеристика, КодСтроки, ЗаказПоставщику, Серия, Склад");
		СтруктураПоискаБезСерии = Новый Структура("Номенклатура, Характеристика, КодСтроки, ЗаказПоставщику, Склад");
	КонецЕсли;
	
	СтруктураДействий = Новый Структура;
	ДобавитьВСтруктуруДействияПриИзмененииКоличестваУпаковок(СтруктураДействий, ЦенаВключаетНДС);
	
	МассивУдаляемыхСтрок = Новый Массив;
	
	Для каждого ТекСтрока Из ТаблицаТоваров Цикл
		КоличествоУпаковокДоИзм = ТекСтрока.КоличествоУпаковок;
		ТекСтрока.КоличествоУпаковок = ?(ПоОрдеру, ТекСтрока.КоличествоУпаковокВОрдере, ТекСтрока.КоличествоУпаковокВЗаказе);
		ТекСтрока.Количество = ?(ПоОрдеру, ТекСтрока.КоличествоВОрдере, ТекСтрока.КоличествоВЗаказе);
		Если ТекСтрока.КоличествоУпаковок <> КоличествоУпаковокДоИзм Тогда
			ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(ТекСтрока, СтруктураДействий, Неопределено);
		КонецЕсли;
		ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(ТекСтрока, СтруктураДействий, Неопределено);
		
		Если СЗаполнением Тогда
			ЗаполнитьЗначенияСвойств(СтруктураПоиска, ТекСтрока);
			Строки = ТоварыНакладной.НайтиСтроки(СтруктураПоиска);
			Если Строки.Количество() > 0 Тогда
				СтрокаРеализации = Строки.Получить(0);
				ЗаполнитьЗначенияСвойств(ТекСтрока, СтрокаРеализации,,"Количество, КоличествоУпаковок");
				ТекСтрока.КоличествоВНакладной = СтрокаРеализации.Количество;
				ТекСтрока.КоличествоУпаковокВНакладной = СтрокаРеализации.КоличествоУпаковок;
				ТекСтрока.ПрисутствуетВДокументе = Истина;
				ТоварыНакладной.Удалить(СтрокаРеализации);
			Иначе
				ЗаполнитьЗначенияСвойств(СтруктураПоискаБезСерии, ТекСтрока);
				Строки = ТоварыНакладной.НайтиСтроки(СтруктураПоискаБезСерии);
				Если Строки.Количество() > 0 Тогда
					СтрокаРеализации = Строки.Получить(0);
					ЗаполнитьЗначенияСвойств(ТекСтрока, СтрокаРеализации,,"Количество, КоличествоУпаковок");
					ТекСтрока.КоличествоВНакладной = СтрокаРеализации.Количество;
					ТекСтрока.КоличествоУпаковокВНакладной = СтрокаРеализации.КоличествоУпаковок;
					ТекСтрока.ПрисутствуетВДокументе = Истина;
					ТоварыНакладной.Удалить(СтрокаРеализации);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		Если СписокЗаказов.НайтиПоЗначению(ТекСтрока.ЗаказПоставщику) <> Неопределено 
			ИЛИ ТекСтрока.ЗаказПоставщику = ЗаказПоставщику
			ИЛИ НЕ ЗначениеЗаполнено(ТекСтрока.ЗаказПоставщику) Тогда
			
			ТекСтрока.ЗаказИзНакладной = Истина;
			
		КонецЕсли;
		
		ТекСтрока.РасхождениеНакладная = ТекСтрока.КоличествоУпаковок - ТекСтрока.КоличествоУпаковокВНакладной;
		Если ТекСтрока.РасхождениеНакладная <> 0 
			И ((ТекСтрока.ЗаказИзНакладной И ПоЗаказам) ИЛИ НЕ ПоЗаказам) Тогда
			ТекСтрока.СтрокаВыбрана = Истина;
		Иначе
			ТекСтрока.СтрокаВыбрана = Ложь;
		КонецЕсли;
		
		Если СЗаполнением Тогда
			Если (ТекСтрока.КоличествоУпаковокВНакладной = ТекСтрока.КоличествоУпаковокВЗаказе 
					ИЛИ НЕ ЗначениеЗаполнено(ТекСтрока.ЗаказПоставщику))
				И (ТекСтрока.КоличествоУпаковокВНакладной = ТекСтрока.КоличествоУпаковокВОрдере 
					ИЛИ НЕ ТекСтрока.ОрдернаяСхемаПриПриемке) Тогда
					МассивУдаляемыхСтрок.Добавить(ТаблицаТоваров.Индекс(ТекСтрока));
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	ИндексЭлементаМассива = МассивУдаляемыхСтрок.Количество() - 1;
	Пока ИндексЭлементаМассива >= 0 Цикл
		ТаблицаТоваров.Удалить(МассивУдаляемыхСтрок[ИндексЭлементаМассива]);
		ИндексЭлементаМассива = ИндексЭлементаМассива - 1;
	КонецЦикла;
	
	Если СЗаполнением Тогда
		Для каждого ТекСтрока Из ТоварыНакладной Цикл
			СтрокаТовары = ТаблицаТоваров.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТовары, ТекСтрока,,"Количество, КоличествоУпаковок");
			СтрокаТовары.КоличествоВНакладной = ТекСтрока.Количество;
			СтрокаТовары.КоличествоУпаковокВНакладной = ТекСтрока.КоличествоУпаковок;
			СтрокаТовары.СтрокаВыбрана = Истина;
			СтрокаТовары.ПрисутствуетВДокументе = Истина;
			СтрокаТовары.РасхождениеНакладная = -СтрокаТовары.КоличествоУпаковокВНакладной;
			СтрокаТовары.ЗаказИзНакладной = Истина;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьИнформациюПоЗаказам(ТоварыНакладной)
	
	ПараметрыОбновления = ЗаказыСервер.ПараметрыОбновленияИнформацииПоЗаказамВФорме();
	
	ПараметрыОбновления.ИмяРеквизитаСписокЗаказов         = "СписокЗаказов";
	ПараметрыОбновления.ПутьЗаказаВШапке                  = "ЗаказПоставщику";
	ПараметрыОбновления.ИмяНадписиЗаголовка               = "НадписьЗаголовокЗаказы";
	ПараметрыОбновления.ИмяГруппыКолонокВТабличнойЧасти   = "ТаблицаТоваровГруппаЗаказПоставщику";
	ПараметрыОбновления.ИмяЗаказаВТабличнойЧасти          = "ЗаказПоставщику";
	ПараметрыОбновления.ИспользоватьЗаказыВТабличнойЧасти = ИспользоватьПоступлениеПоНесколькимЗаказам;

	ЗаказыСервер.ОбновитьИнформациюПоЗаказамВФорме(ЭтаФорма, ТоварыНакладной, ПараметрыОбновления);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоЗаказам()
	
	Если ПоЗаказам Тогда
		Элементы.ТаблицаТоваров.ОтборСтрок = Новый ФиксированнаяСтруктура("ЗаказИзНакладной", Истина);
	Иначе
		Элементы.ТаблицаТоваров.ОтборСтрок = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ДобавитьВСтруктуруДействияПриИзмененииКоличестваУпаковок(СтруктураДействий, ЦенаВключаетНДС)
	
	СтруктураПересчетаСуммы =  Новый Структура("ЦенаВключаетНДС", ЦенаВключаетНДС);
	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСуммуСНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСумму");
	СтруктураДействий.Вставить("ПересчитатьСуммуСУчетомРучнойСкидки", Новый Структура("Очищать", Ложь));
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииПоЗаказам()
	
	УстановитьОтборПоЗаказам();
	
	Если ПоЗаказам Тогда
		СброситьВыборСтрокНеИзНакладной();
	Иначе
		УстановитьВыборСтрокНеИзНакладной();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура СброситьВыборСтрокНеИзНакладной()
	СтруктураПоиска = Новый Структура("СтрокаВыбрана", Истина);
	ТоварыПодобрано = ТаблицаТоваров.НайтиСтроки(СтруктураПоиска);
	
	Для каждого СтрокаПодобрано Из ТоварыПодобрано Цикл
		СтрокаПодобрано.СтрокаВыбрана = СтрокаПодобрано.ЗаказИзНакладной;
	КонецЦикла; 
КонецПроцедуры

&НаСервере
Процедура УстановитьВыборСтрокНеИзНакладной()
	СтруктураПоиска = Новый Структура("СтрокаВыбрана", Ложь);
	ТоварыПодобрано = ТаблицаТоваров.НайтиСтроки(СтруктураПоиска);
	
	Для каждого СтрокаПодобрано Из ТоварыПодобрано Цикл
		Если СтрокаПодобрано.РасхождениеНакладная <> 0 Тогда
			СтрокаПодобрано.СтрокаВыбрана = Истина;
		Иначе
			СтрокаПодобрано.СтрокаВыбрана = Ложь;
		КонецЕсли;
	КонецЦикла; 
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовокЗаполнитьПоЗаказамОрдерам()
	
	Если НЕ ИспользоватьОрдернуюСхемуПриПоступлении И ИспользоватьЗаказыПоставщикам Тогда
		ЗаголовокЗаполнить = НСтр("ru = 'Подбор товаров по заказам'");
	ИначеЕсли ИспользоватьОрдернуюСхемуПриПоступлении И НЕ ИспользоватьЗаказыПоставщикам Тогда
		ЗаголовокЗаполнить = НСтр("ru = 'Подбор товаров по ордерам'");
	Иначе
		ЗаголовокЗаполнить = НСтр("ru = 'Подбор товаров по заказам/ордерам'");
	КонецЕсли;
	
	Заголовок = ЗаголовокЗаполнить;
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиТоварыВДокумент()

	// Снятие модифицированности, т.к. перед закрытием признак проверяется.
	Модифицированность = Ложь;

	Закрыть();

	ОповеститьОВыборе(Новый Структура("АдресТоваровВХранилище", ПоместитьТоварыВХранилище()));

КонецПроцедуры

#КонецОбласти

#КонецОбласти

ВыполняетсяЗакрытие = Ложь;
