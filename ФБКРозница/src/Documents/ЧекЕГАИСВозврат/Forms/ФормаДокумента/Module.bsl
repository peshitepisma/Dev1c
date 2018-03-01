&НаКлиенте
Перем КэшированныеЗначения; //используется механизмом обработки изменения реквизитов ТЧ

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ВалютаДокумента = ИнтеграцияЕГАИСПереопределяемый.ПредставлениеВалютыРегламентированногоУчета();
	
	Если Объект.Ссылка.Пустая() Тогда
		ПриСозданииЧтенииНаСервере();
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВерсионированиеОбъектов") Тогда
		МодульВерсионированиеОбъектов = ОбщегоНазначения.ОбщийМодуль("ВерсионированиеОбъектов");
		МодульВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ГосударственныеИнформационныеСистемыПереопределяемый.УстановитьПараметрыВыбораНоменклатуры(ЭтотОбъект);
	
	ГосударственныеИнформационныеСистемыПереопределяемый.УстановитьСвязиПараметровВыбораСНоменклатурой(ЭтотОбъект, "ТоварыХарактеристика");
	ГосударственныеИнформационныеСистемыПереопределяемый.УстановитьСвязиПараметровВыбораСНоменклатурой(ЭтотОбъект, "ТоварыУпаковка");
	
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
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	ОповещениеПриОтключении = Новый ОписаниеОповещения("ОтключитьОборудованиеЗавершение", ЭтотОбъект);
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(ОповещениеПриОтключении, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	СобытияФормЕГАИСКлиентПереопределяемый.ОбработкаВыбораПодборНоменклатуры(
		Новый ОписаниеОповещения("Подключаемый_ОбработкаРезультатаПодбораНоменклатуры", ЭтотОбъект),
		ВыбранноеЗначение, ИсточникВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если НЕ РедактированиеФормыНедоступно Тогда
		СобытияФормЕГАИСКлиентПереопределяемый.ОбработкаОповещенияПодборНоменклатуры(
			Новый ОписаниеОповещения("Подключаемый_ОбработкаРезультатаПодбораНоменклатуры", ЭтотОбъект),
			ИмяСобытия, Параметр, Источник);
		
		СобытияФормЕГАИСКлиентПереопределяемый.ОбработкаОповещенияОбработаныНеизвестныеШтрихкоды(
			Новый ОписаниеОповещения("Подключаемый_ОбработаныНеизвестныеШтрихкоды", ЭтотОбъект),
			ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	КонецЕсли;
	
	Если ИмяСобытия = "ИзменениеСостоянияЕГАИС"
		И Параметр.Ссылка = Объект.Ссылка Тогда
		
		ОбновитьСтатусЕГАИС();
		
	КонецЕсли;
	
	Если ИмяСобытия = "ВыполненОбменЕГАИС"
		И (Параметр = Неопределено
		Или (ТипЗнч(Параметр) = Тип("Структура") И Параметр.ОбновлятьСтатусЕГАИСВФормахДокументов)) Тогда
		
		ОбновитьСтатусЕГАИС();
		
	КонецЕсли;
	
	СобытияФормЕГАИСКлиентПереопределяемый.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриСозданииЧтенииНаСервере();
	
	СобытияФормЕГАИСПереопределяемый.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	СобытияФормЕГАИСКлиентПереопределяемый.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ГосударственныеИнформационныеСистемыПереопределяемый.ЗаполнитьСлужебныеРеквизитыВКоллекции(ЭтотОбъект, Объект.Товары);
	
	АкцизныеМаркиЕГАИС.ЗаполнитьСлужебныеРеквизиты(ЭтотОбъект);
	
	ОбновитьСтатусЕГАИС();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПараметрыЗаписи.Вставить("Основание", Объект.ДокументОснование);
	Оповестить("Запись_ЧекЕГАИСВозврат", ПараметрыЗаписи, Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	
	Если РедактированиеФормыНедоступно Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыСканированияАкцизныхМарок = АкцизныеМаркиКлиентСервер.ПараметрыСканированияАкцизныхМарок();
	ПараметрыСканированияАкцизныхМарок.Форма                   = ЭтотОбъект;
	ПараметрыСканированияАкцизныхМарок.ЗапрашиватьНоменклатуру = Истина;
	ПараметрыСканированияАкцизныхМарок.КонтрольАкцизныхМарок   = Истина;
	
	Если Элементы.Товары.ТекущиеДанные <> Неопределено Тогда
		ПараметрыСканированияАкцизныхМарок.ИдентификаторСтроки = Элементы.Товары.ТекущиеДанные.ПолучитьИдентификатор();
	КонецЕсли;
	
	ОповещенияПриЗавершении = СобытияФормЕГАИСКлиент.СтруктураОповещенийВнешнегоСобытия(ЭтотОбъект,,, ПараметрыСканированияАкцизныхМарок);
	
	СобытияФормЕГАИСКлиент.ВнешнееСобытиеПолученыШтрихкоды(ОповещенияПриЗавершении, ЭтотОбъект, Источник, Событие, Данные, ПараметрыСканированияАкцизныхМарок);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ВидОперацииПриИзменении(Элемент)
	НастроитьЭлементыФормы(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ВидОперацииОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусОбработкиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОчиститьСообщения();
	
	Если (Не ЗначениеЗаполнено(Объект.Ссылка)) Или (Не Объект.Проведен) Тогда
		
		ОписаниеОповещенияВопрос = Новый ОписаниеОповещения("СтатусОбработкиОбработкаНавигационнойСсылкиЗавершение",
		                                                    ЭтотОбъект,
		                                                    Новый Структура("НавигационнаяСсылкаФорматированнойСтроки", НавигационнаяСсылкаФорматированнойСтроки));
		ТекстВопроса = НСтр("ru = 'Документ был изменен. Провести?'");
		ПоказатьВопрос(ОписаниеОповещенияВопрос, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	ИначеЕсли Модифицированность Тогда
		
		ОписаниеОповещенияВопрос = Новый ОписаниеОповещения("СтатусОбработкиОбработкаНавигационнойСсылкиЗавершение",
		                                                    ЭтотОбъект,
		                                                    Новый Структура("НавигационнаяСсылкаФорматированнойСтроки", НавигационнаяСсылкаФорматированнойСтроки));
		ТекстВопроса = НСтр("ru = 'Документ не проведен. Провести?'");
		ПоказатьВопрос(ОписаниеОповещенияВопрос, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	Иначе
		
		ОбработатьНажатиеНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТабличнойЧастиТовары

&НаКлиенте
Процедура ТоварыПриАктивизацииЯчейки(Элемент)
	
	Если Не Элемент.ТекущийЭлемент = Элементы.ТоварыШтрихкод Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Элементы.ТоварыШтрихкод.СписокВыбора.Очистить();
		Возврат;
	КонецЕсли;
	
	Структура = Новый Структура;
	Структура.Вставить("Номенклатура",   ТекущиеДанные.Номенклатура);
	Структура.Вставить("Характеристика", ТекущиеДанные.Характеристика);
	Структура.Вставить("Упаковка",       ТекущиеДанные.Упаковка);
	
	Штрихкоды = ПолучитьШтрихкодыНоменклатуры(Структура);
	
	Если ТипЗнч(Штрихкоды) = Тип("Массив") Тогда
		Элементы.ТоварыШтрихкод.СписокВыбора.ЗагрузитьЗначения(Штрихкоды);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		Элемент.ТекущиеДанные.ИдентификаторСтроки = Строка(Новый УникальныйИдентификатор);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПередУдалением(Элемент, Отказ)
	
	ИдентификаторыСтрок = Новый Массив;
	ВыделенныеСтроки = Элементы.Товары.ВыделенныеСтроки;
	Для Каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
		СтрокаТЧ = Объект.Товары.НайтиПоИдентификатору(ВыделеннаяСтрока);
		ИдентификаторыСтрок.Добавить(СтрокаТЧ.ИдентификаторСтроки);
	КонецЦикла;
	
	Если Не Отказ И ИдентификаторыСтрок.Количество() > 0 Тогда
		УдалитьАкцизныеМарки(ИдентификаторыСтрок);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	ТекущаяСтрока.Штрихкод = Неопределено;
	
	ПриИзмененииНоменклатуры(ТекущаяСтрока, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыХарактеристикаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	ТекущаяСтрока.Штрихкод = Неопределено;
	
	ПараметрыЗаполнения = СобытияФормЕГАИСКлиент.СтруктураПараметрыЗаполнения();
	ПараметрыЗаполнения.ПересчитатьСумму             = Истина;
	ПараметрыЗаполнения.ПересчитатьКоличествоЕдиниц  = Истина;
	ПараметрыЗаполнения.ЗаполнитьИндексАкцизнойМарки = Истина;
	
	СобытияФормЕГАИСКлиентПереопределяемый.ПриИзмененииХарактеристики(
		ЭтотОбъект, ТекущаяСтрока, КэшированныеЗначения,
		ПараметрыЗаполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыХарактеристикаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	СобытияФормЕГАИСКлиентПереопределяемый.НачалоВыбораХарактеристики(ЭтотОбъект, ТекущаяСтрока, Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыУпаковкаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	ПараметрыЗаполнения = СобытияФормЕГАИСКлиент.СтруктураПараметрыЗаполнения();
	ПараметрыЗаполнения.ПересчитатьСумму             = Истина;
	ПараметрыЗаполнения.ПересчитатьКоличествоЕдиниц  = Истина;
	ПараметрыЗаполнения.ЗаполнитьИндексАкцизнойМарки = Истина;
	
	СобытияФормЕГАИСКлиентПереопределяемый.ПриИзмененииУпаковки(
		ЭтотОбъект, ТекущаяСтрока, КэшированныеЗначения,
		ПараметрыЗаполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыУпаковкаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	СобытияФормЕГАИСКлиентПереопределяемый.НачалоВыбораУпаковки(ЭтотОбъект, ТекущаяСтрока, Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыКоличествоУпаковокПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	ПриИзмененииКоличестваУпаковок(ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыЦенаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	ПараметрыЗаполнения = СобытияФормЕГАИСКлиент.СтруктураПараметрыЗаполнения();
	ПараметрыЗаполнения.ПересчитатьСумму             = Истина;
	ПараметрыЗаполнения.ПересчитатьКоличествоЕдиниц  = Истина;
	ПараметрыЗаполнения.ЗаполнитьИндексАкцизнойМарки = Истина;
	
	СобытияФормЕГАИСКлиентПереопределяемый.ПриИзмененииЦены(
		ЭтотОбъект, ТекущаяСтрока, КэшированныеЗначения,
		ПараметрыЗаполнения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура АкцизныеМарки(Команда)
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ТекущиеДанные.ИдентификаторСтроки) Тогда
		ТекущиеДанные.ИдентификаторСтроки = Строка(Новый УникальныйИдентификатор);
	КонецЕсли;
	
	ДополнительныеПараметрыИзменениеАкцизныхМарок = Новый Структура;
	ДополнительныеПараметрыИзменениеАкцизныхМарок.Вставить("ИдентификаторСтроки", ТекущиеДанные.ПолучитьИдентификатор());
	ДополнительныеПараметрыИзменениеАкцизныхМарок.Вставить("Редактирование", Истина);
	
	ДополнительныеПараметры = АкцизныеМаркиКлиентСервер.ПараметрыСканированияАкцизныхМарок();
	ДополнительныеПараметры.ИдентификаторСтроки       = ТекущиеДанные.ПолучитьИдентификатор();
	ДополнительныеПараметры.Редактирование            = Истина;
	ДополнительныеПараметры.КонтрольАкцизныхМарок     = Истина;
	ДополнительныеПараметры.АдресВоВременномХранилище = АдресТаблицыАкцизныхМаркиВоВременномХранилище(ТекущиеДанные.ИдентификаторСтроки);
	ДополнительныеПараметры.Форма                     = ЭтотОбъект;
	ДополнительныеПараметры.ОповещениеПриЗавершении   = Новый ОписаниеОповещения("ИзменениеАкцизныхМарокЗавершение", ЭтотОбъект, ДополнительныеПараметрыИзменениеАкцизныхМарок);
	
	АкцизныеМаркиЕГАИСКлиент.ОткрытьФормуСчитыванияАкцизнойМарки(
		Неопределено,
		ДополнительныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
		"Документ.ЧекЕГАИСВозврат.Форма.ФормаДокумента.Записать");
	
	ОчиститьСообщения();
	Записать();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПодбор(Команда)
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, 
		"Документ.ЧекЕГАИСВозврат.ФормаДокумента.Команда.ОткрытьПодбор");
	
	СобытияФормЕГАИСКлиентПереопределяемый.ОткрытьФормуПодбораНоменклатуры(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоШтрихкодуВыполнить(Команда)
	
	ОчиститьСообщения();
	
	ШтрихкодированиеНоменклатурыЕГАИСКлиентПереопределяемый.ПоказатьВводШтрихкода(
		Новый ОписаниеОповещения("ПоискПоШтрихкодуЗавершение", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьДанныеВТСД(Команда)
	
	ОчиститьСообщения();
	
	СобытияФормЕГАИСКлиентПереопределяемый.ВыгрузитьДанныеВТСД(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьДанныеИзТСД(Команда)
	
	ОчиститьСообщения();
	
	МенеджерОборудованияКлиент.НачатьЗагрузкуДанныеИзТСД(
		Новый ОписаниеОповещения("ЗагрузитьИзТСДЗавершение", ЭтотОбъект),
		УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ПерезаполнитьПоОснованию(Команда)
	
	ОчиститьСообщения();
	
	Если Объект.Товары.Количество() > 0 Тогда
		
		ТекстВопроса = НСтр("ru = 'Табличная часть будет перезаполнена. Продолжить?'");
		ОписаниеОповещенияОЗавершении = Новый ОписаниеОповещения("ВопросОПерезаполнениииПоОснованиюПриЗавершении", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещенияОЗавершении, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	Иначе
		
		ПерезаполнитьПоОснованиюСервер();
		
	КонецЕсли;
	
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

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормЕГАИСКлиентПереопределяемый.ВыполнитьПереопределяемуюКоманду(ЭтотОбъект, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
		"Документ.ЧекЕГАИСВозврат.Форма.ФормаДокумента.Провести");
	
	ОчиститьСообщения();
	ПараметрыЗаписи = Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение);
	Записать(ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
		"Документ.ЧекЕГАИСВозврат.Форма.ФормаДокумента.ПровестиИЗакрыть");
	
	ОчиститьСообщения();
	ПараметрыЗаписи = Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение);
	
	Если Записать(ПараметрыЗаписи) Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	ГосударственныеИнформационныеСистемыПереопределяемый.УстановитьУсловноеОформлениеЕдиницИзмерения(ЭтотОбъект);
	ГосударственныеИнформационныеСистемыПереопределяемый.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	ИнтеграцияЕГАИСПереопределяемый.НастроитьПодключаемоеОборудование(ЭтотОбъект);
	
	ГосударственныеИнформационныеСистемыПереопределяемый.ЗаполнитьСлужебныеРеквизитыВКоллекции(ЭтотОбъект, Объект.Товары);
	
	ИспользоватьАкцизныеМарки = Истина;
	АкцизныеМаркиЕГАИС.ЗаполнитьСлужебныеРеквизиты(ЭтотОбъект);
	
	ОбновитьСтатусЕГАИС();
	
	УстановитьВидимостьИнформацииОСканированииDataMatrix();
	
КонецПроцедуры

#Область АкцизныеМарки

&НаСервере
Функция АдресТаблицыАкцизныхМаркиВоВременномХранилище(ИдентификаторСтроки)
	
	Возврат АкцизныеМаркиЕГАИС.АдресТаблицыАкцизныхМаркиВоВременномХранилище(
		ЭтотОбъект,
		ИдентификаторСтроки);
	
КонецФункции

&НаСервере
Функция ЗагрузитьАкцизныеМаркиИзВременногоХранилища(ИдентификаторСтроки, АдресВоВременномХранилище)
	
	Возврат АкцизныеМаркиЕГАИС.ЗагрузитьАкцизныеМаркиИзВременногоХранилища(
		ЭтотОбъект,
		ИдентификаторСтроки,
		АдресВоВременномХранилище);
	
КонецФункции

&НаСервере
Функция ДанныеПоАкцизнымМаркам(ИдентификаторСтроки, КодАкцизнойМарки)
	
	Возврат АкцизныеМаркиЕГАИС.ДанныеПоАкцизнымМаркам(
		ЭтотОбъект,
		ИдентификаторСтроки,
		КодАкцизнойМарки);
	
КонецФункции

&НаСервере
Процедура УдалитьАкцизныеМарки(Данные)
	
	АкцизныеМаркиЕГАИС.УдалитьАкцизныеМарки(
		ЭтотОбъект,
		Данные);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменениеАкцизныхМарокЗавершение(ТекущаяСтрока, ДополнительныеПараметры) Экспорт
	
	ПараметрыЗаполнения = СобытияФормЕГАИСКлиент.СтруктураПараметрыЗаполнения();
	ПараметрыЗаполнения.ПересчитатьСумму             = Истина;
	ПараметрыЗаполнения.ПересчитатьКоличествоЕдиниц  = Истина;
	ПараметрыЗаполнения.ЗаполнитьИндексАкцизнойМарки = Истина;
	
	Если ДополнительныеПараметры.ВыполнитьОбработкуТабличнойЧасти Тогда
		ПараметрыЗаполнения.ПерезаполнитьНоменклатуруЕГАИС = Истина;
	КонецЕсли;
	
	СобытияФормЕГАИСКлиентПереопределяемый.ПриИзмененииКоличества(
		ЭтотОбъект, ТекущаяСтрока, КэшированныеЗначения,
		ПараметрыЗаполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолученаАкцизнаяМарка(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВыполнитьОбработкуТабличнойЧасти = Ложь;
	Если ДополнительныеПараметры.Редактирование Тогда
		
		ТекущиеДанные = Объект.Товары.НайтиПоИдентификатору(ДополнительныеПараметры.ИдентификаторСтроки);
		ДанныеПоАкцизнымМаркам = ЗагрузитьАкцизныеМаркиИзВременногоХранилища(
			ТекущиеДанные.ИдентификаторСтроки,
			Результат);
		
	Иначе
		
		КодАкцизнойМарки        = Результат.КодАкцизнойМарки;
		ЗапрашиватьНоменклатуру = ДополнительныеПараметры.ЗапрашиватьНоменклатуру;

		
		Если ДополнительныеПараметры.ИдентификаторСтроки = Неопределено Тогда
			ТекущиеДанные = Неопределено;
		Иначе
			НайденнаяСтрока = Объект.Товары.НайтиПоИдентификатору(ДополнительныеПараметры.ИдентификаторСтроки);
			Если ЗначениеЗаполнено(Результат.Номенклатура)
				И НайденнаяСтрока <> Неопределено
				И (НайденнаяСтрока.Номенклатура <> Результат.Номенклатура
				   Или НайденнаяСтрока.Характеристика <> Результат.Характеристика) Тогда
				ТекущиеДанные = Неопределено;
			Иначе
				ТекущиеДанные = НайденнаяСтрока;
			КонецЕсли;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Результат.Номенклатура)

			ИЛИ Не ЗапрашиватьНоменклатуру Тогда
			
			Если ТекущиеДанные <> Неопределено
				И Не ЗапрашиватьНоменклатуру Тогда
				
				// Добавление акцизной марки к текущий строке
				
			ИначеЕсли ТекущиеДанные <> Неопределено
				И Результат.Номенклатура = ТекущиеДанные.Номенклатура
				И Результат.Характеристика = ТекущиеДанные.Характеристика Тогда
				
				// Искомая алкогольная продукция найдена
				
			Иначе
				
				Если Объект.Товары.Количество() = 0 Тогда
					ТекущиеДанные = Объект.Товары.Добавить();
					ЗаполнитьЗначенияСвойств(ТекущиеДанные, Результат);
					Если ЗначениеЗаполнено(Результат.Номенклатура) Тогда
						ВыполнитьОбработкуТабличнойЧасти = Истина;
					Иначе

						ТекущиеДанные.МаркируемаяАлкогольнаяПродукция = Истина;
					КонецЕсли;
				Иначе
					Если ТекущиеДанные = Неопределено Тогда
						ТекущиеДанные = Объект.Товары.Добавить();
						ЗаполнитьЗначенияСвойств(ТекущиеДанные, Результат);
						Если ЗначениеЗаполнено(Результат.Номенклатура) Тогда
							ВыполнитьОбработкуТабличнойЧасти = Истина;
						Иначе

							ТекущиеДанные.МаркируемаяАлкогольнаяПродукция = Истина;
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;
				
			КонецЕсли;
			
		Иначе
			
			ПараметрыОткрытияФормы = Новый Структура;
			ПараметрыОткрытияФормы.Вставить("КодАкцизнойМарки", КодАкцизнойМарки);
			Если ЗначениеЗаполнено(Результат.АлкогольнаяПродукция) Тогда
				ПараметрыОткрытияФормы.Вставить("НоменклатураЕГАИС", Результат.АлкогольнаяПродукция);
			КонецЕсли;
			
			ОткрытьФорму(
				"Обработка.РаботаСАкцизнымиМаркамиЕГАИС.Форма.ФормаВводаАкцизнойМаркиПоискНоменклатуры",
				ПараметрыОткрытияФормы,
				 ЭтотОбъект,,,,
				Новый ОписаниеОповещения("Подключаемый_ПолученаАкцизнаяМарка", ЭтотОбъект, ДополнительныеПараметры));
			Возврат;
			
		КонецЕсли;
		
		ДанныеПоАкцизнымМаркам = ДанныеПоАкцизнымМаркам(
			ТекущиеДанные.ИдентификаторСтроки,
			КодАкцизнойМарки);
		
	КонецЕсли;
	
	ДополнительныеПараметры.Вставить("ТекущиеДанные", ТекущиеДанные);
	ДополнительныеПараметры.Вставить("ВыполнитьОбработкуТабличнойЧасти", ВыполнитьОбработкуТабличнойЧасти);
	
	АкцизныеМаркиЕГАИСКлиент.Подключаемый_ПолученаАкцизнаяМарка(
		ДанныеПоАкцизнымМаркам,
		ДополнительныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолученDataMatrix(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Справки2.Количество() = 1 Тогда
		ДобавитьСправку2ВТабличнуюЧасть(Результат.Справки2[0]);
	Иначе
		МассивСсылок = Новый Массив;
		Для Каждого ДанныеСправки2 Из Результат.Справки2 Цикл
			Если МассивСсылок.Найти(ДанныеСправки2.АлкогольнаяПродукция) = Неопределено Тогда
				МассивСсылок.Добавить(ДанныеСправки2.АлкогольнаяПродукция);
			КонецЕсли;
		КонецЦикла;
		
		Если МассивСсылок.Количество() = 1 Тогда
			ДобавитьСправку2ВТабличнуюЧасть(Результат.Справки2[0]);
		Иначе
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("РежимВыбора"       , Истина);
			ПараметрыФормы.Вставить("ЗакрыватьПриВыборе", Истина);
			ПараметрыФормы.Вставить("Отбор"             , Новый Структура("Ссылка", МассивСсылок));
			
			ОповещениеОЗакрытии = Новый ОписаниеОповещения("ВыборАлкогольнойПродукции_Завершение", ЭтотОбъект, Результат);
			ОткрытьФорму("Справочник.КлассификаторАлкогольнойПродукцииЕГАИС.ФормаВыбора", ПараметрыФормы, ЭтотОбъект,,,, ОповещениеОЗакрытии, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборАлкогольнойПродукции_Завершение(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого ДанныеСправки2 Из ДополнительныеПараметры.Справки2 Цикл
		Если ДанныеСправки2.АлкогольнаяПродукция = РезультатВыбора Тогда
			ДобавитьСправку2ВТабличнуюЧасть(ДанныеСправки2);
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьСправку2ВТабличнуюЧасть(ДанныеСправки2)
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("АлкогольнаяПродукция", ДанныеСправки2.АлкогольнаяПродукция);
	
	МассивСтрокПоАлкогольнойПродукции = Объект.Товары.НайтиСтроки(ПараметрыОтбора);
	
	Если НЕ ЗначениеЗаполнено(ДанныеСправки2.Номенклатура)
		И МассивСтрокПоАлкогольнойПродукции.Количество() = 0 Тогда
		ПараметрыОткрытияФормы = Новый Структура;
		ПараметрыОткрытияФормы.Вставить("НоменклатураЕГАИС", ДанныеСправки2.АлкогольнаяПродукция);
		
		ОткрытьФорму(
			"Обработка.РаботаСАкцизнымиМаркамиЕГАИС.Форма.ФормаВводаАкцизнойМаркиПоискНоменклатуры",
			ПараметрыОткрытияФормы,
			ЭтотОбъект,,,,
			Новый ОписаниеОповещения("ПоискНоменклатуры_Завершение", ЭтотОбъект, ДанныеСправки2));
		Возврат;
	КонецЕсли;
	
	Если МассивСтрокПоАлкогольнойПродукции.Количество() = 0 Тогда
		СтрокаТЧ = Объект.Товары.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТЧ, ДанныеСправки2);
		СтрокаТЧ.КоличествоУпаковок = 1;
		
		Если НЕ ЗначениеЗаполнено(ДанныеСправки2.Номенклатура) И МассивСтрокПоАлкогольнойПродукции.Количество() > 0 Тогда
			ЗаполнитьЗначенияСвойств(СтрокаТЧ, МассивСтрокПоАлкогольнойПродукции[0], "Номенклатура, Характеристика, Упаковка");
		КонецЕсли;
		
		ПриИзмененииНоменклатуры(СтрокаТЧ, Ложь);
	Иначе
		СтрокаТЧ = МассивСтрокПоАлкогольнойПродукции[0];
		СтрокаТЧ.КоличествоУпаковок = СтрокаТЧ.КоличествоУпаковок + 1;
		
		ПриИзмененииКоличестваУпаковок(СтрокаТЧ);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Штрихкоды

&НаКлиенте
Процедура ПоискПоШтрихкодуЗавершение(ДанныеШтрихкода, ДополнительныеПараметры) Экспорт
	
	ПараметрыСканированияАкцизныхМарок = АкцизныеМаркиКлиентСервер.ПараметрыСканированияАкцизныхМарок();
	ПараметрыСканированияАкцизныхМарок.Форма                   = ЭтотОбъект;
	ПараметрыСканированияАкцизныхМарок.ЗапрашиватьНоменклатуру = Истина;
	ПараметрыСканированияАкцизныхМарок.КонтрольАкцизныхМарок   = Истина;
	
	Если Элементы.Товары.ТекущиеДанные <> Неопределено Тогда
		ПараметрыСканированияАкцизныхМарок.ИдентификаторСтроки = Элементы.Товары.ТекущиеДанные.ПолучитьИдентификатор();
	КонецЕсли;
	
	ОповещенияПриЗавершении = СобытияФормЕГАИСКлиент.СтруктураОповещенийВнешнегоСобытия(ЭтотОбъект,,, ПараметрыСканированияАкцизныхМарок);
	
	АкцизныеМаркиЕГАИСКлиент.ОбработатьДанныеШтрихкода(ОповещенияПриЗавершении, ЭтотОбъект, ДанныеШтрихкода, ПараметрыСканированияАкцизныхМарок);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзТСДЗавершение(РезультатВыполнения, ДополнительныеПараметры) Экспорт
	
	СобытияФормЕГАИСКлиентПереопределяемый.ПриПолученииДанныхИзТСД(
		Новый ОписаниеОповещения("Подключаемый_ПолученыДанныеИзТСД", ЭтотОбъект),
		ЭтотОбъект, РезультатВыполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолученыШтрихкоды(ДанныеШтрихкодов, ДополнительныеПараметры) Экспорт
	
	ПараметрыЗаполнения = СобытияФормЕГАИСКлиент.СтруктураПараметрыЗаполнения();
	ПараметрыЗаполнения.ПересчитатьСумму                   = Истина;
	ПараметрыЗаполнения.ПересчитатьКоличествоЕдиниц        = Истина;
	ПараметрыЗаполнения.ЗаполнитьИндексАкцизнойМарки       = Истина;
	ПараметрыЗаполнения.ШтрихкодыВТЧ                       = Истина;
	ПараметрыЗаполнения.МаркируемаяАлкогольнаяПродукцияВТЧ = Истина;
	
	ДанныеДляОбработки = ШтрихкодированиеНоменклатурыЕГАИСКлиентПереопределяемый.ПодготовитьДанныеДляОбработкиШтрихкодов(
		ЭтотОбъект, ДанныеШтрихкодов, КэшированныеЗначения,
		ПараметрыЗаполнения);
	
	ОбработатьШтрихкоды(ДанныеДляОбработки, КэшированныеЗначения);
	
	ШтрихкодированиеНоменклатурыЕГАИСКлиентПереопределяемый.ПослеОбработкиШтрихкодов(
		ЭтотОбъект,
		ДанныеДляОбработки,
		КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработаныНеизвестныеШтрихкоды(ДанныеШтрихкодов, ДополнительныеПараметры) Экспорт
	
	ШтрихкодированиеНоменклатурыЕГАИСКлиентПереопределяемый.ОчиститьКэшированныеШтрихкоды(ДанныеШтрихкодов, КэшированныеЗначения);
	
	Подключаемый_ПолученыШтрихкоды(ДанныеШтрихкодов, ДополнительныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолученыДанныеИзТСД(ТаблицаТоваров, ДополнительныеПараметры) Экспорт
	
	ПараметрыЗаполнения = СобытияФормЕГАИСКлиент.СтруктураПараметрыЗаполнения();
	ПараметрыЗаполнения.ПересчитатьСумму                   = Истина;
	ПараметрыЗаполнения.ПересчитатьКоличествоЕдиниц        = Истина;
	ПараметрыЗаполнения.ЗаполнитьИндексАкцизнойМарки       = Истина;
	ПараметрыЗаполнения.ШтрихкодыВТЧ                       = Истина;
	ПараметрыЗаполнения.МаркируемаяАлкогольнаяПродукцияВТЧ = Истина;
	
	ДанныеДляОбработки = ШтрихкодированиеНоменклатурыЕГАИСКлиентПереопределяемый.ПодготовитьДанныеДляОбработкиТаблицыТоваровПолученнойИзТСД(
		ЭтотОбъект, ТаблицаТоваров, КэшированныеЗначения,
		ПараметрыЗаполнения);
	
	ОбработатьДанныеИзТСД(ДанныеДляОбработки, КэшированныеЗначения);
	
	ШтрихкодированиеНоменклатурыЕГАИСКлиентПереопределяемый.ПослеОбработкиТаблицыТоваровПолученнойИзТСД(
		ЭтотОбъект,
		ДанныеДляОбработки,
		КэшированныеЗначения);
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьШтрихкоды(ДанныеДляОбработки, КэшированныеЗначения)
	
	ШтрихкодированиеНоменклатурыЕГАИСПереопределяемый.ОбработатьШтрихкоды(
		ЭтотОбъект, ДанныеДляОбработки, КэшированныеЗначения);
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьДанныеИзТСД(ТаблицаТоваров, КэшированныеЗначения)
	
	ШтрихкодированиеНоменклатурыЕГАИСПереопределяемый.ОбработатьДанныеИзТСД(
		ЭтотОбъект, ТаблицаТоваров, КэшированныеЗначения);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьШтрихкодыНоменклатуры(Отбор)
	
	Возврат ШтрихкодированиеНоменклатурыЕГАИСПереопределяемый.ПолучитьШтрихкодыНоменклатуры(Отбор);
	
КонецФункции

#КонецОбласти

#Область Подбор

&НаСервере
Процедура ОбработкаРезультатаПодбораНоменклатуры(ВыбранноеЗначение, ПараметрыЗаполнения)
	
	СобытияФормЕГАИСПереопределяемый.ОбработкаРезультатаПодбораНоменклатуры(
		ЭтотОбъект, ВыбранноеЗначение,
		ПараметрыЗаполнения);
	
	ГосударственныеИнформационныеСистемыПереопределяемый.ЗаполнитьСлужебныеРеквизитыВКоллекции(ЭтотОбъект, Объект.Товары);
	
	АкцизныеМаркиЕГАИС.ЗаполнитьСлужебныеРеквизиты(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработкаРезультатаПодбораНоменклатуры(Результат, ДополнительныеПараметры) Экспорт
	
	ПараметрыЗаполнения = СобытияФормЕГАИСКлиент.СтруктураПараметрыЗаполнения();
	ПараметрыЗаполнения.ПересчитатьСумму             = Истина;
	ПараметрыЗаполнения.ПересчитатьКоличествоЕдиниц  = Истина;
	ПараметрыЗаполнения.ЗаполнитьИндексАкцизнойМарки = Истина;
	
	ОбработкаРезультатаПодбораНоменклатуры(Результат, ПараметрыЗаполнения);
	
КонецПроцедуры

#КонецОбласти

#Область Статус

&НаСервере
Процедура ОбновитьСтатусЕГАИС()
	
	МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Объект.Ссылка);
	
	СтатусЕГАИС        = МенеджерОбъекта.СтатусПоУмолчанию();
	ДальнейшееДействие = МенеджерОбъекта.ДальнейшееДействиеПоУмолчанию();
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	Статусы.Статус КАК Статус,
		|	ВЫБОР
		|		КОГДА Статусы.ДальнейшееДействие1 В (&МассивДальнейшиеДействия)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ПустаяСсылка)
		|		ИНАЧЕ Статусы.ДальнейшееДействие1
		|	КОНЕЦ КАК ДальнейшееДействие1,
		|	ВЫБОР
		|		КОГДА Статусы.ДальнейшееДействие2 В (&МассивДальнейшиеДействия)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ПустаяСсылка)
		|		ИНАЧЕ Статусы.ДальнейшееДействие2
		|	КОНЕЦ КАК ДальнейшееДействие2,
		|	ВЫБОР
		|		КОГДА Статусы.ДальнейшееДействие3 В (&МассивДальнейшиеДействия)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ПустаяСсылка)
		|		ИНАЧЕ Статусы.ДальнейшееДействие3
		|	КОНЕЦ КАК ДальнейшееДействие3
		|ИЗ
		|	РегистрСведений.СтатусыДокументовЕГАИС КАК Статусы
		|ГДЕ
		|	Статусы.Документ = &Документ");
		
		Запрос.УстановитьПараметр("Документ", Объект.Ссылка);
		Запрос.УстановитьПараметр("МассивДальнейшиеДействия", ИнтеграцияЕГАИС.НеотображаемыеВДокументахДальнейшиеДействия());
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Следующий() Тогда
			
			СтатусЕГАИС = Выборка.Статус;
			
			ДальнейшееДействие = Новый Массив;
			ДальнейшееДействие.Добавить(Выборка.ДальнейшееДействие1);
			ДальнейшееДействие.Добавить(Выборка.ДальнейшееДействие2);
			ДальнейшееДействие.Добавить(Выборка.ДальнейшееДействие3);
			
		КонецЕсли;
		
	КонецЕсли;
	
	ДопустимыеДействия = Новый Массив;
	ДопустимыеДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ПередайтеДанные);
	ДопустимыеДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ОтменитеОперацию);
	ДопустимыеДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ОтменитеПередачуДанных);
	СтатусЕГАИСПредставление = ИнтеграцияЕГАИС.ПредставлениеСтатусаЕГАИС(
		СтатусЕГАИС,
		ДальнейшееДействие,
		ДопустимыеДействия);
	
	РедактированиеФормыНеДоступно = СтатусЕГАИС <> Перечисления.СтатусыИнформированияЕГАИС.Черновик
	                              И СтатусЕГАИС <> Перечисления.СтатусыИнформированияЕГАИС.ОшибкаПередачи;
	
	Элементы.ГруппаНередактируемыеПослеОтправкиРеквизитыОсновное.ТолькоПросмотр = РедактированиеФормыНеДоступно;
	Элементы.ГруппаНередактируемыеПослеОтправкиКомандыТовары.Доступность        = НЕ РедактированиеФормыНедоступно;
	Элементы.СтраницаТовары.ТолькоПросмотр                                      = РедактированиеФормыНеДоступно;
	
	Элементы.ТоварыПодменюЗаполнить.Видимость = ЗначениеЗаполнено(Объект.ДокументОснование);
	Элементы.ТоварыОткрытьПодбор.Видимость = НЕ ЗначениеЗаполнено(Объект.ДокументОснование);
	
	НастроитьЭлементыФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьНажатиеНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ПередатьДанные" Тогда
		
		ИнтеграцияЕГАИСКлиент.ПодготовитьКПередаче(
			Объект.Ссылка,
			ПредопределенноеЗначение("Перечисление.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ПередайтеДанные"));
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ОтменитьОперацию" Тогда
		
		ИнтеграцияЕГАИСКлиент.ОтменитьПоследнююОперацию(Объект.Ссылка);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ОтменитьПередачу" Тогда
		
		ИнтеграцияЕГАИСКлиент.ОтменитьПередачу(Объект.Ссылка);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусОбработкиОбработкаНавигационнойСсылкиЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если Не РезультатВопроса = КодВозвратаДиалога.Да Тогда
		 Возврат;
	КонецЕсли;
	
	Если ПроверитьЗаполнение() Тогда
		Записать(Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение));
	КонецЕсли;
	
	Если Не Модифицированность И Объект.Проведен Тогда
		ОбработатьНажатиеНавигационнойСсылки(ДополнительныеПараметры.НавигационнаяСсылкаФорматированнойСтроки);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область УправлениеЭлементамиФормы

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьЭлементыФормы(Форма)
	
	Если Форма.Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийЧекаЕГАИСВозврат.ВозвратОтЮридическогоЛицаСБезналичнойОплатой") Тогда
		Форма.Элементы.НомерЧекаККМ.Заголовок = НСтр("ru = 'Номер чека'");
		Форма.Элементы.НомерСмены.Заголовок = НСтр("ru = 'Номер накладной'");
		Форма.Элементы.СерийныйНомерККМ.Заголовок = НСтр("ru = 'Номер счета на оплату'");
	Иначе
		Форма.Элементы.НомерЧекаККМ.Заголовок = НСтр("ru = 'Номер чека'");
		Форма.Элементы.НомерСмены.Заголовок = НСтр("ru = 'Номер смены'");
		Форма.Элементы.СерийныйНомерККМ.Заголовок = НСтр("ru = 'Номер фискального накопителя'");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

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

#Область Прочее

&НаКлиенте
Процедура ВопросОПерезаполнениииПоОснованиюПриЗавершении(Результат, Параметры) Экспорт

	Если Результат = КодВозвратаДиалога.Да Тогда
		
		ПерезаполнитьПоОснованиюСервер();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПерезаполнитьПоОснованиюСервер()
	
	Чек = РеквизитФормыВЗначение("Объект");
	Чек.Заполнить(Объект.ДокументОснование);
	
	ЗначениеВРеквизитФормы(Чек, "Объект");
	
	ГосударственныеИнформационныеСистемыПереопределяемый.ЗаполнитьСлужебныеРеквизитыВКоллекции(ЭтотОбъект, Объект.Товары);
	
	АкцизныеМаркиЕГАИС.ЗаполнитьСлужебныеРеквизиты(ЭтотОбъект);
	
	НастроитьЭлементыФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииНоменклатуры(ТекущаяСтрока, ЗаполнитьАлкогольнуюПродукцию)
	
	ПараметрыЗаполнения = СобытияФормЕГАИСКлиент.СтруктураПараметрыЗаполнения();
	ПараметрыЗаполнения.ПересчитатьСумму             = Истина;
	ПараметрыЗаполнения.ПересчитатьКоличествоЕдиниц  = Истина;
	ПараметрыЗаполнения.ЗаполнитьИндексАкцизнойМарки = Истина;
	
	СобытияФормЕГАИСКлиентПереопределяемый.ПриИзмененииНоменклатуры(
		ЭтотОбъект, ТекущаяСтрока, КэшированныеЗначения,
		ПараметрыЗаполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииКоличестваУпаковок(ТекущаяСтрока)
	
	ПараметрыЗаполнения = СобытияФормЕГАИСКлиент.СтруктураПараметрыЗаполнения();
	ПараметрыЗаполнения.ПересчитатьСумму             = Истина;
	ПараметрыЗаполнения.ПересчитатьКоличествоЕдиниц  = Истина;
	ПараметрыЗаполнения.ЗаполнитьИндексАкцизнойМарки = Истина;
	
	СобытияФормЕГАИСКлиентПереопределяемый.ПриИзмененииКоличестваУпаковок(
		ЭтотОбъект, ТекущаяСтрока, КэшированныеЗначения,
		ПараметрыЗаполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискНоменклатуры_Завершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Результат.Номенклатура) Тогда
		ЗаполнитьЗначенияСвойств(ДополнительныеПараметры, Результат);
		ДобавитьСправку2ВТабличнуюЧасть(ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьИнформацииОСканированииDataMatrix()
	
	ВидимостьИнформации = АкцизныеМаркиЕГАИС.ВидимостьИнформацииОСканированииDataMatrix(Ложь);
	
	Элементы.ГруппаИнформацияDataMatrix.Видимость = НЕ Элементы.СтраницаТовары.ТолькоПросмотр И ВидимостьИнформации;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
