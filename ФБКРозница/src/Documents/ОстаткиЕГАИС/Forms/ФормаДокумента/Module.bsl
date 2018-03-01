
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
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
	
	СобытияФормЕГАИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
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
	
	ОбновитьСтатусЕГАИС();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПараметрыЗаписи.Вставить("Основание", Неопределено);
	Оповестить("Запись_ОстаткиЕГАИС", ПараметрыЗаписи, Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ОрганизацияЕГАИСПриИзменении(Элемент)
	
	Элементы.СтраницаКорректировкаОстатков.Видимость = ВидимостьКорректировкиОстатков(Объект.ОрганизацияЕГАИС, Объект.ВидДокумента);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьДействиеТребующееПроведения(ОповещениеПриЗавершении)
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОповещениеПриЗавершении", ОповещениеПриЗавершении);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ВыполнитьДействиеТребующееПроведенияПриЗакрытииВопроса",
		ЭтотОбъект,
		ДополнительныеПараметры);
	
	Если (Не ЗначениеЗаполнено(Объект.Ссылка)) Или (Не Объект.Проведен) Тогда
		
		ТекстВопроса = НСтр("ru = 'Документ был изменен. Провести?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	ИначеЕсли Модифицированность Тогда
		
		ТекстВопроса = НСтр("ru = 'Документ не проведен. Провести?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	Иначе
		
		ВыполнитьОбработкуОповещения(ОповещениеПриЗавершении, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусОбработкиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОчиститьСообщения();
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ВыполнитьКомандуОбработатьНажатиеНавигационнойСсылкиПослеПроведения",
		ЭтотОбъект,
		НавигационнаяСсылкаФорматированнойСтроки);
	ВыполнитьДействиеТребующееПроведения(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидДокументаПриИзменении(Элемент)
	
	Элементы.СтраницаКорректировкаОстатков.Видимость = ВидимостьКорректировкиОстатков(Объект.ОрганизацияЕГАИС, Объект.ВидДокумента);
	
	ВидимостьСправки2 = Объект.ВидДокумента = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЗапросОстатковВРегистре1");
	
	Элементы.ОстаткиПоДаннымЕГАИССправка2.Видимость = ВидимостьСправки2;
	Элементы.КорректировкаОстатковСправка2.Видимость = ВидимостьСправки2;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
		"Документ.ОстаткиЕГАИС.Форма.ФормаДокумента.Записать");
	
	ОчиститьСообщения();
	Записать();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоРасхождениям(Команда)
	
	ОчиститьСообщения();
	
	ЗаполнитьПоРасхождениямНаСервере();
	
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
		"Документ.ОстаткиЕГАИС.Форма.ФормаДокумента.Провести");
	
	ОчиститьСообщения();
	ПараметрыЗаписи = Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение);
	Записать(ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
		"Документ.ОстаткиЕГАИС.Форма.ФормаДокумента.ПровестиИЗакрыть");
	
	ОчиститьСообщения();
	ПараметрыЗаписи = Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение);
	
	Если Записать(ПараметрыЗаписи) Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	ОбновитьСтатусЕГАИС();
	
	ДоступностьЭлементовФормы();
	
КонецПроцедуры

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
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюЕГАИС.НеТребуется)
		|		ИНАЧЕ Статусы.ДальнейшееДействие1
		|	КОНЕЦ КАК ДальнейшееДействие1,
		|	ВЫБОР
		|		КОГДА Статусы.ДальнейшееДействие2 В (&МассивДальнейшиеДействия)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюЕГАИС.НеТребуется)
		|		ИНАЧЕ Статусы.ДальнейшееДействие2
		|	КОНЕЦ КАК ДальнейшееДействие2,
		|	ВЫБОР
		|		КОГДА Статусы.ДальнейшееДействие3 В (&МассивДальнейшиеДействия)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюЕГАИС.НеТребуется)
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
	ДопустимыеДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ЗапроситеОстатки);
	ДопустимыеДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ОтменитеОперацию);
	ДопустимыеДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ОтменитеПередачуДанных);
	СтатусЕГАИСПредставление = ИнтеграцияЕГАИС.ПредставлениеСтатусаЕГАИС(
		СтатусЕГАИС,
		ДальнейшееДействие,
		ДопустимыеДействия);
	
	РедактированиеФормыНеДоступно = СтатусЕГАИС <> Перечисления.СтатусыОбработкиОстатковЕГАИС.Черновик
	                              И СтатусЕГАИС <> Перечисления.СтатусыОбработкиОстатковЕГАИС.ОшибкаПередачи;
	
	Элементы.ГруппаНередактируемыеПослеОтправкиРеквизитыОсновное.ТолькоПросмотр = РедактированиеФормыНеДоступно;
	
	Элементы.ОстаткиПоДаннымЕГАИСНомерСтроки.ТолькоПросмотр          = РедактированиеФормыНеДоступно;
	Элементы.ОстаткиПоДаннымЕГАИСАлкогольнаяПродукция.ТолькоПросмотр = РедактированиеФормыНеДоступно;
	Элементы.ОстаткиПоДаннымЕГАИССправка2.ТолькоПросмотр             = РедактированиеФормыНеДоступно;
	Элементы.ОстаткиПоДаннымЕГАИСКоличество.ТолькоПросмотр           = РедактированиеФормыНеДоступно;
	
	ПолученыОстатки = (СтатусЕГАИС = Перечисления.СтатусыОбработкиОстатковЕГАИС.ПолученыОстатки);
	
	Элементы.КорректировкаОстатковЗаполнитьРасхождения.Доступность = ПолученыОстатки;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьНажатиеНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ЗапроситьОстатки" Тогда
		
		ИнтеграцияЕГАИСКлиент.ПодготовитьКПередаче(
			Объект.Ссылка,
			ПредопределенноеЗначение("Перечисление.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ЗапроситеОстатки"));
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ОтменитьОперацию" Тогда
		
		ИнтеграцияЕГАИСКлиент.ОтменитьПоследнююОперацию(Объект.Ссылка);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ОтменитьПередачу" Тогда
		
		ИнтеграцияЕГАИСКлиент.ОтменитьПередачу(Объект.Ссылка);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьДействиеТребующееПроведенияПриЗакрытииВопроса(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если Не РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Если ПроверитьЗаполнение() Тогда
		Записать(Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение));
	КонецЕсли;
	
	Если Не Модифицированность И Объект.Проведен Тогда
		
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьКомандуОбработатьНажатиеНавигационнойСсылкиПослеПроведения(РезультатВопроса, НавигационнаяСсылкаФорматированнойСтроки) Экспорт
	
	ОбработатьНажатиеНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки);
	
КонецПроцедуры

#КонецОбласти

#Область УправлениеЭлементамиФормы

&НаСервере
Процедура ДоступностьЭлементовФормы()
	
	Элементы.СтраницаКорректировкаОстатков.Видимость = ВидимостьКорректировкиОстатков(Объект.ОрганизацияЕГАИС, Объект.ВидДокумента);
	
	ВидимостьСправки2 = Объект.ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ЗапросОстатковВРегистре1;
	
	Элементы.ОстаткиПоДаннымЕГАИССправка2.Видимость = ВидимостьСправки2;
	Элементы.КорректировкаОстатковСправка2.Видимость = ВидимостьСправки2;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура ЗаполнитьПоРасхождениямНаСервере()
	
	ТекущийОбъект = РеквизитФормыВЗначение("Объект");
	ТекущийОбъект.ЗаполнитьПоРасхождениям();
	
	ЗначениеВРеквизитФормы(ТекущийОбъект, "Объект");
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ВидимостьКорректировкиОстатков(ОрганизацияЕГАИС, ВидДокумента)
	
	Если НЕ ЗначениеЗаполнено(ОрганизацияЕГАИС) ИЛИ НЕ ЗначениеЗаполнено(ВидДокумента) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ЗапросОстатковВРегистре1;
	
КонецФункции

#КонецОбласти

#КонецОбласти