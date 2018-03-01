&НаКлиенте
Перем КэшированныеЗначения; //используется механизмом обработки изменения реквизитов ТЧ

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	УстановитьУсловноеОформление();
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		ПриЧтенииСозданииНаСервере();
		
	КонецЕсли;

	НалогообложенияНДС = Перечисления.ТипыНалогообложенияНДС.ПродажаОблагаетсяНДС;
	ВалютаРеглУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// Обработчик механизма "ДатыЗапретаИзменения"
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	ПриЧтенииСозданииНаСервере();
	
	СобытияФорм.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_СчетФактураНаНеподтвержденнуюРеализацию0", , Объект.Ссылка);
	
	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	СобытияФормКлиент.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	СобытияФормКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	ДатаПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ПлатежноРасчетныеДокументыСтрокойНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПолучитьПлатежноРасчетныеДокументыИзХранилища", ЭтотОбъект);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Организация", 		 Объект.Организация);
	ПараметрыФормы.Вставить("ДокументОснование", Объект.ДокументОснование);
	ПараметрыФормы.Вставить("АдресВХранилище",	 ПоместитьПлатежноРасчетныеДокументыВХранилище());
	
	ОткрытьФорму("Документ.СчетФактураВыданный.Форма.ФормаПлатежноРасчетныеДокументы", 
		ПараметрыФормы, , , , , ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура КодВидаОперацииПриИзменении(Элемент)
	
	ОбновитьПредставлениеВидаОперации(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура КодВидаОперацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	СписокКодовВидовОпераций.ПоказатьВыборЭлемента(Новый ОписаниеОповещения("КодВидаОперацииНачалоВыбораЗавершение", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура КодВидаОперацииНачалоВыбораЗавершение(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныйЭлемент <> Неопределено Тогда
		Объект.КодВидаОперации = ВыбранныйЭлемент.Значение;
		ОбновитьПредставлениеВидаОперации(ЭтаФорма);
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДатаПриИзмененииСервер()
	
	ЗаполнитьЗависимыеОтКонтрагентаРеквизитыФормы(Истина);
	ЗаполнитьСписокКодовВидовОпераций();
	
КонецПроцедуры

&НаКлиенте
Процедура КППКонтрагентаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если СписокВыбораКПП.Количество() = 0 Тогда
		
		Если ЗначениеЗаполнено(Объект.Контрагент) Тогда
			ЗаполнитьСписокВыбораКПП(СписокВыбораКПП, Объект.Контрагент, Объект.Дата);
		КонецЕсли;
		
	КонецЕсли;
	
	ДанныеВыбора = СписокВыбораКПП;
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования, 
		ЭтотОбъект, 
		"Объект.Комментарий");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТовары

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	СтруктураПересчетаСуммы = СтруктураПересчетаСуммыНДС();
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу",    ТекущаяСтрока.Характеристика);
	СтруктураДействий.Вставить("ПроверитьЗаполнитьУпаковкуПоВладельцу", ТекущаяСтрока.Упаковка);
	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
	
	СтруктураДействий.Вставить("ЗаполнитьСтавкуНДС", НалогообложенияНДС);
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСуммуСНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ЗаполнитьПризнакТипНоменклатуры", Новый Структура("Номенклатура", "ТипНоменклатуры"));
	СтруктураДействий.Вставить("ЗаполнитьПризнакАртикул", Новый Структура("Номенклатура", "Артикул"));
	СтруктураДействий.Вставить("ЗаполнитьПризнакВедетсяУчетПоГТД", Новый Структура("Номенклатура", "ВедетсяУчетПоГТД"));
	СтруктураДействий.Вставить("НоменклатураПриИзмененииПереопределяемый", Новый Структура("ИмяФормы, ИмяТабличнойЧасти",
		ЭтаФорма.ИмяФормы, "Товары"));
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыХарактеристикаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	СтруктураПересчетаСуммы = СтруктураПересчетаСуммыНДС();
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСуммуСНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ХарактеристикаПриИзмененииПереопределяемый", Новый Структура("ИмяФормы, ИмяТабличнойЧасти",
		ЭтаФорма.ИмяФормы, "Товары"));
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыУпаковкаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	СтруктураПересчетаСуммы = СтруктураПересчетаСуммыНДС();
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");	
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСуммуСНДС", СтруктураПересчетаСуммы);
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыКоличествоУпаковокПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	СтруктураДействий = Новый Структура;
	ДобавитьВСтруктуруДействияПриИзмененииКоличестваУпаковок(СтруктураДействий, Объект);
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСтавкаНДСПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	СтруктураПересчетаСуммы = СтруктураПересчетаСуммыНДС();
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСуммуСНДС", СтруктураПересчетаСуммы);
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСуммаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	СтруктураПересчетаСуммы = СтруктураПересчетаСуммыНДС();
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСуммуСНДС", СтруктураПересчетаСуммы);
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоДокументуОснованию(Команда)
	
	Если Объект.Товары.Количество() > 0 Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ОбработкаВопросЗаполнениеТоваров", ЭтотОбъект);
		
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(КодВозвратаДиалога.Да, НСтр("ru='Продолжить'"));
		Кнопки.Добавить(КодВозвратаДиалога.Отмена, НСтр("ru='Отмена'"));
		
		ТекстВопроса = НСтр("ru='Перед заполнением табличная часть будет очищена. Продолжить?'");
		
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, Кнопки);
		
		Возврат;
		
	КонецЕсли;
	
	ЗаполнитьТоварыПоДокументуОснованиюСервер();
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
//Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Провести(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиИЗакрыть(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	//
	
	Ценообразование.УстановитьУсловноеОформлениеСуммНДС(ЭтаФорма);
	
	//
	
	Ценообразование.УстановитьУсловноеОформлениеЦенаВключаетНДС(ЭтаФорма);
	
	//
	
	НоменклатураСервер.УстановитьУсловноеОформлениеЕдиницИзмерения(ЭтаФорма);
	
	//
	
	НоменклатураСервер.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтаФорма);
	
	//
	
	НоменклатураСервер.УстановитьУсловноеОформлениеНомераГТД(ЭтаФорма);

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСлужебныеРеквизитыПоНоменклатуре()
	
	ПараметрыЗаполненияРеквизитов = Новый Структура;
	ПараметрыЗаполненияРеквизитов.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются",
											Новый Структура("Номенклатура", "ХарактеристикиИспользуются"));
	ПараметрыЗаполненияРеквизитов.Вставить("ЗаполнитьПризнакТипНоменклатуры",
											Новый Структура("Номенклатура", "ТипНоменклатуры"));
	ПараметрыЗаполненияРеквизитов.Вставить("ЗаполнитьПризнакАртикул",
											Новый Структура("Номенклатура", "Артикул"));
	ПараметрыЗаполненияРеквизитов.Вставить("ЗаполнитьПризнакВедетсяУчетПоГТД",
											Новый Структура("Номенклатура", "ВедетсяУчетПоГТД"));

	НоменклатураСервер.ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВКоллекции(Объект.Товары,ПараметрыЗаполненияРеквизитов);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ДобавитьВСтруктуруДействияПриИзмененииКоличестваУпаковок(СтруктураДействий, Объект)
	
	СтруктураПересчетаСуммы = СтруктураПересчетаСуммыНДС();
	
	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСуммуСНДС", СтруктураПересчетаСуммы);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	ЗаполнитьСлужебныеРеквизитыПоНоменклатуре();
	ЗаполнитьЗависимыеОтКонтрагентаРеквизитыФормы();
	УправлениеЭлементамиФормы(ЭтотОбъект);
	
	Если ЗначениеЗаполнено(Объект.СтрокаПлатежноРасчетныеДокументы) Тогда
		СтрокаПлатежноРасчетныеДокументы = Объект.СтрокаПлатежноРасчетныеДокументы;
	Иначе
		СтрокаПлатежноРасчетныеДокументы = НСтр("ru='<отсутствуют>'"); 
	КонецЕсли;
	
	ЗаполнитьСписокКодовВидовОпераций();
	
	Элементы.СтрокаПлатежноРасчетныеДокументы.Гиперссылка = ПравоДоступа("Изменение",  Метаданные.Документы.СчетФактураНаНеподтвержденнуюРеализацию0);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция СтруктураПересчетаСуммыНДС()
	
	СтруктураЗаполненияЦены = Новый Структура;
	СтруктураЗаполненияЦены.Вставить("ЦенаВключаетНДС", Ложь);
	
	Возврат СтруктураЗаполненияЦены;
	
КонецФункции

&НаСервере
Функция ПоместитьПлатежноРасчетныеДокументыВХранилище()
	
	Возврат ПоместитьВоВременноеХранилище(Объект.ПлатежноРасчетныеДокументы.Выгрузить());
	
КонецФункции

&НаСервере
Процедура ПолучитьПлатежноРасчетныеДокументыИзХранилища(НовыйАдресВХранилище, ДополнительныеПараметры)
	
	Если ЗначениеЗаполнено(НовыйАдресВХранилище) Тогда
		Объект.ПлатежноРасчетныеДокументы.Загрузить(ПолучитьИзВременногоХранилища(НовыйАдресВХранилище));
		СформироватьСтрокуРасчетноПлатежныхДокументов();
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьСтрокуРасчетноПлатежныхДокументов()
	
	СтрокаНомеровИДата = "";
	Для Каждого СтрокаТаблицы Из Объект.ПлатежноРасчетныеДокументы Цикл
		СтрокаНомеровИДата = СтрокаНомеровИДата + ?(ПустаяСтрока(СтрокаНомеровИДата), "", ", ")
							 + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
									НСтр("ru = '%1 от %2'"),
									СтрокаТаблицы.НомерПлатежноРасчетногоДокумента,
									Формат(СтрокаТаблицы.ДатаПлатежноРасчетногоДокумента, "ДЛФ=D"));
	КонецЦикла; 
		
	Если Объект.СтрокаПлатежноРасчетныеДокументы <> СтрокаНомеровИДата Тогда
		Объект.СтрокаПлатежноРасчетныеДокументы = СтрокаНомеровИДата;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.СтрокаПлатежноРасчетныеДокументы) Тогда
		СтрокаПлатежноРасчетныеДокументы = Объект.СтрокаПлатежноРасчетныеДокументы;
	Иначе
		СтрокаПлатежноРасчетныеДокументы = НСтр("ru='<отсутствуют>'"); 
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВопросЗаполнениеТоваров(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Объект.Товары.Очистить();
		ЗаполнитьТоварыПоДокументуОснованиюСервер();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТоварыПоДокументуОснованиюСервер()
	
	ТаблицаТовары = Документы.СчетФактураНаНеподтвержденнуюРеализацию0.ТоварыПоДокументыОснованию(Объект.ДокументОснование);
	Объект.Товары.Загрузить(ТаблицаТовары);
	ЗаполнитьСлужебныеРеквизитыПоНоменклатуре();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьПредставлениеВидаОперации(Форма)
	
	ТекущийКод = Форма.СписокКодовВидовОпераций.НайтиПоЗначению(Форма.Объект.КодВидаОперации);
	Если ТекущийКод <> Неопределено Тогда
		Форма.ПредставлениеВидаОперации = Сред(ТекущийКод.Представление, 4);
	Иначе
		Форма.ПредставлениеВидаОперации = "";
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокКодовВидовОпераций()
	
	УчетНДС.ЗаполнитьСписокКодовВидовОпераций(
		Перечисления.ЧастиЖурналаУчетаСчетовФактур.ВыставленныеСчетаФактуры,
		СписокКодовВидовОпераций,
		?(ЗначениеЗаполнено(Объект.Дата), Объект.Дата, ТекущаяДатаСеанса()));
	
	ОбновитьПредставлениеВидаОперации(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЗависимыеОтКонтрагентаРеквизитыФормы(ИзменятьИННКПП = Ложь) Экспорт
	
	УчетНДСУТ.ЗаполнитьЗависимыеОтКонтрагентаРеквизитыФормы(ЭтотОбъект, Объект.Дата, ИзменятьИННКПП);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаполнитьСписокВыбораКПП(СписокВыбора, Контрагент, ДатаСведений)
	
	УчетНДСУТ.ЗаполнитьСписокВыбораКППСчетФактурыПолученные(СписокВыбора, Контрагент, ДатаСведений);
	
КонецПроцедуры

&НаСервере
Процедура УправлениеЭлементамиФормы(Форма)
	
	Форма.Элементы.ИННКонтрагента.Доступность = ЗначениеЗаполнено(Форма.Объект.Контрагент);
	Форма.Элементы.КППКонтрагента.Доступность = ЗначениеЗаполнено(Форма.Объект.Контрагент)
	                                            И Форма.КонтрагентЮрЛицо;
	
КонецПроцедуры

#КонецОбласти
