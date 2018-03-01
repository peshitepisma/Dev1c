&НаКлиенте
Перем КэшированныеЗначения; //используется механизмом обработки изменения реквизитов ТЧ

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Запись, ЭтотОбъект);

	ТипНоменклатуры = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Запись.СкладскаяГруппаНоменклатуры, "ТипНоменклатуры");

	Если ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Товар
		И Не ЗначениеЗаполнено(Запись.СкладскаяГруппаУпаковок) Тогда
		Размещение = "ЕдиницыХранения";
		Элементы.СкладскаяГруппаУпаковок.Доступность = Ложь;
	Иначе ЗначениеЗаполнено(Запись.СкладскаяГруппаУпаковок); 
		Размещение = "Упаковки";
		Элементы.СкладскаяГруппаУпаковок.Доступность = Истина;
	КонецЕсли;
	
	Если Запись.ИсходныйКлючЗаписи.Пустой() Тогда
		ПриЧтенииСозданииНаСервере();
	Иначе
		УстановитьДоступность();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	ПриЧтенииСозданииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Товар
		И Размещение = "Упаковки"
		И Не ЗначениеЗаполнено(Запись.СкладскаяГруппаУпаковок) Тогда
		ТекстСообщения = НСтр("ru = 'Поле ""Складская группа упаковок"" не заполнено'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,"СкладскаяГруппаУпаковок","Запись",Отказ);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_ПравилаРазмещенияТоваровВЯчейках", ПараметрыЗаписи);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СкладПриИзменении(Элемент)
	
	УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Склад,Помещение",Запись.Склад,Запись.Помещение));
	
КонецПроцедуры

&НаКлиенте
Процедура ПомещениеПриИзменении(Элемент)
	
	УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Склад,Помещение",Запись.Склад,Запись.Помещение));

КонецПроцедуры

&НаКлиенте
Процедура СкладскаяГруппаНоменклатурыПриИзменении(Элемент)
	УстановитьДоступность();
	
	Если Не Элементы.СкладскаяГруппаУпаковок.Доступность Тогда
		Запись.СкладскаяГруппаУпаковок = Неопределено;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура РазмещениеПриИзменении(Элемент)
	
	УстановитьДоступность();
	Если Не Элементы.СкладскаяГруппаУпаковок.Доступность Тогда
		Запись.СкладскаяГруппаУпаковок = Неопределено;
	КонецЕсли;
	
	Модифицированность = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Склад,Помещение",Запись.Склад,Запись.Помещение));
	УстановитьДоступность();
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступность()
	
	УстановитьПривилегированныйРежим(Истина);
	ТипНоменклатуры = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Запись.СкладскаяГруппаНоменклатуры, "ТипНоменклатуры");
	УстановитьПривилегированныйРежим(Ложь);
	Элементы.СкладскаяГруппаУпаковок.Доступность = ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Товар И Размещение = "Упаковки";
	Элементы.Размещение.Доступность = (ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Товар)
		И ПравоДоступа("Изменение", Метаданные.РегистрыСведений.ПравилаРазмещенияТоваровВЯчейках);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СкладскаяГруппаУпаковок.Имя);

	ГруппаОтбора1 = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора1.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;

	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Размещение");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = "Упаковки";

	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТипНоменклатуры");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ТипыНоменклатуры.Товар;
	                                                                      
	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Запись.СкладскаяГруппаУпаковок");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Справочники.СкладскиеГруппыУпаковок.ПустаяСсылка();
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Истина);
	
КонецПроцедуры

#КонецОбласти
