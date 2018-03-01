#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает таблицу классификатора из макета с предопределенными элементами.
// Макеты хранятся в макетах данного справочника (см. общую форму "ДобавлениеЭлементовВКлассификатор").
//	Параметры:
//		Переменные - Строка - в данном методе не используется, однако является обязательной в случе обращения к другим классификаторам.
//	Возвращаемое значение:
//		Таблица значений - таблица классификатора с колонками:
//			* Код - Строка - строковое представление кода элемента классификатора.
//			* Наименование - Строка - наименование элемента классификатора.
//
Функция ТаблицаКлассификатора(Знач Переменные) Экспорт
	
	ТаблицаПоказателей = Новый ТаблицаЗначений;
	
	Макет = Справочники.КлассификаторТНВЭД.ПолучитьМакет("КлассификаторТоварнойНоменклатурыВнешнеэкономическойДеятельности");
	
	// В полученном макете содержатся значения всех списков используемых в отчете, ищем переданный.
	Список = Макет.Области.Найти("Строки");
	
	Если Список.ТипОбласти = ТипОбластиЯчеекТабличногоДокумента.Строки Тогда
		// Заполнение дерева данными списка.	
		ВерхОбласти = Список.Верх;
		НизОбласти = Список.Низ;
		
		НомерКолонки = 1;
		Область = Макет.Область(ВерхОбласти - 1, НомерКолонки);
		ИмяКолонки = Область.Текст;
		ДлинаКодаКлассификатора = 7;
		
		Пока ЗначениеЗаполнено(ИмяКолонки) Цикл
			
			Если ИмяКолонки = "Код" Тогда
				ТаблицаПоказателей.Колонки.Добавить("Код", Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(12)));
			ИначеЕсли ИмяКолонки = "Наименование" Тогда
				ТаблицаПоказателей.Колонки.Добавить("Наименование",Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(255)));
			ИначеЕсли ИмяКолонки = "ЕдиницаИзмерения" Тогда
				ТаблицаПоказателей.Колонки.Добавить("ЕдиницаИзмеренияКод",Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(3)));
			КонецЕсли;	
			
			НомерКолонки = НомерКолонки + 1;
			Область = Макет.Область(ВерхОбласти - 1, НомерКолонки);
			ИмяКолонки = Область.Текст;
			
		КонецЦикла;
		
		Для НомСтр = ВерхОбласти По НизОбласти Цикл
			
			// Отображаем только элементы.
			
			Код = СокрП(Макет.Область(НомСтр, 1).Текст);
			Если СтрДлина(Код) = 2 Тогда
				Продолжить;
			КонецЕсли;
			СтрокаСписка = ТаблицаПоказателей.Добавить();
			
			Для Каждого Колонка Из ТаблицаПоказателей.Колонки Цикл
				
				ЗначениеКолонки = СокрП(Макет.Область(НомСтр, ТаблицаПоказателей.Колонки.Индекс(Колонка) + 1).Текст);
				СтрокаСписка[Колонка.Имя] = ЗначениеКолонки;
				
			КонецЦикла;
			
		КонецЦикла;
	КонецЕсли;
	
	ТаблицаПоказателей.Сортировать(ТаблицаПоказателей.Колонки[0].Имя + " Возр");
	
	Возврат ТаблицаПоказателей;
	
КонецФункции

Процедура ЗаполнитьКодыТНВЭДВКоллекции(Коллекция, ПолеНоменклатуры, КодыТНВЭДНоменклатуры, СоответствиеКодов, Отказ) Экспорт
	
	Для Каждого СтрокаТЧ Из Коллекция Цикл
		
		СтрокаКода = КодыТНВЭДНоменклатуры.Найти(СтрокаТЧ[ПолеНоменклатуры],"ПолеНоменклатуры");
		
		Если СтрокаКода = Неопределено Тогда
			СтрокаКода = КодыТНВЭДНоменклатуры.Найти(СтрокаТЧ[ПолеНоменклатуры].Номенклатура,"ПолеНоменклатуры");
			Если СтрокаКода = Неопределено Тогда
				Отказ = Истина;
				Возврат;
			КонецЕсли;
		КонецЕсли;
		
		Если СтрокаКода.КодТНВЭД = ПустаяСсылка() Тогда
			СтрокаТЧ.КодТНВЭД = СоответствиеКодов[СтрокаКода.СырьевойТовар];
		Иначе
			СтрокаТЧ.КодТНВЭД = СтрокаКода.КодТНВЭД;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ПолучитьСлужебныеЭлементы() Экспорт
	
	СоответствиеКодов = Новый Соответствие;
	СоответствиеКодов.Вставить(Ложь, НайтиПоНаименованию("несырьевой товар"));
	СоответствиеКодов.Вставить(Истина, НайтиПоНаименованию("сырьевой товар"));
	
	Возврат СоответствиеКодов;
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

// Обработчик обновления УТ 11.4.2,
// заполняет реквизит "Единица измерения" справочника.
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Номенклатура.КодТНВЭД КАК КодТНВЭД,
	|	Номенклатура.УдалитьСырьевойТовар КАК СырьевойТовар
	|ПОМЕСТИТЬ УказаныКоды
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|ГДЕ
	|	Номенклатура.КодТНВЭД <> ЗНАЧЕНИЕ(Справочник.КлассификаторТНВЭД.ПустаяСсылка)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВидыНоменклатуры.КодТНВЭД,
	|	ВидыНоменклатуры.УдалитьСырьевойТовар
	|ИЗ
	|	Справочник.ВидыНоменклатуры КАК ВидыНоменклатуры
	|ГДЕ
	|	ВидыНоменклатуры.КодТНВЭД <> ЗНАЧЕНИЕ(Справочник.КлассификаторТНВЭД.ПустаяСсылка)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	СырьевойТовар
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СырьевыеТовары.КодТНВЭД КАК Ссылка
	|ИЗ
	|	(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|		УказаныКоды.КодТНВЭД КАК КодТНВЭД
	|	ИЗ
	|		УказаныКоды КАК УказаныКоды
	|	ГДЕ
	|		УказаныКоды.СырьевойТовар) КАК СырьевыеТовары
	|ГДЕ
	|	НЕ СырьевыеТовары.КодТНВЭД В
	|				(ВЫБРАТЬ
	|					УказаныКоды.КодТНВЭД
	|				ИЗ
	|					УказаныКоды КАК УказаныКоды
	|				ГДЕ
	|					НЕ УказаныКоды.СырьевойТовар)
	|	И НЕ СырьевыеТовары.КодТНВЭД.СырьевойТовар
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	КлассификаторТНВЭД.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.КлассификаторТНВЭД КАК КлассификаторТНВЭД
	|ГДЕ
	|	НЕ КлассификаторТНВЭД.ЭлементОбработан
	|	И КлассификаторТНВЭД.ЕдиницаИзмерения = ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)";
	
	Ссылки = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Ссылки);
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяОбъекта = "Справочник.КлассификаторТНВЭД";
	
	МетаданныеДокумента = Метаданные.НайтиПоПолномуИмени(ПолноеИмяОбъекта);
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Результат = ОбновлениеИнформационнойБазы.СоздатьВременнуюТаблицуСсылокДляОбработки(Параметры.Очередь, ПолноеИмяОбъекта, МенеджерВременныхТаблиц);
	
	Если НЕ Результат.ЕстьДанныеДляОбработки Тогда
		Параметры.ОбработкаЗавершена = Истина;
		Возврат;
	КонецЕсли;
	Если НЕ Результат.ЕстьЗаписиВоВременнойТаблице Тогда
		Параметры.ОбработкаЗавершена = Ложь;
		Возврат;
	КонецЕсли;
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Т.Код КАК Код,
	|	Т.ЕдиницаИзмеренияКод КАК ЕдиницаИзмеренияКод
	|ПОМЕСТИТЬ ТаблицаКлассификатора
	|ИЗ
	|	&ТаблицаКлассификатора КАК Т
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Код
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Номенклатура.КодТНВЭД КАК КодТНВЭД,
	|	Номенклатура.УдалитьСырьевойТовар КАК СырьевойТовар
	|ПОМЕСТИТЬ УказаныКоды
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|ГДЕ
	|	Номенклатура.КодТНВЭД <> ЗНАЧЕНИЕ(Справочник.КлассификаторТНВЭД.ПустаяСсылка)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВидыНоменклатуры.КодТНВЭД,
	|	ВидыНоменклатуры.УдалитьСырьевойТовар
	|ИЗ
	|	Справочник.ВидыНоменклатуры КАК ВидыНоменклатуры
	|ГДЕ
	|	ВидыНоменклатуры.КодТНВЭД <> ЗНАЧЕНИЕ(Справочник.КлассификаторТНВЭД.ПустаяСсылка)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	СырьевойТовар
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СырьевыеТовары.КодТНВЭД КАК Ссылка
	|ПОМЕСТИТЬ СырьевыеТовары
	|ИЗ
	|	(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|		УказаныКоды.КодТНВЭД КАК КодТНВЭД
	|	ИЗ
	|		УказаныКоды КАК УказаныКоды
	|	ГДЕ
	|		УказаныКоды.СырьевойТовар) КАК СырьевыеТовары
	|ГДЕ
	|	НЕ СырьевыеТовары.КодТНВЭД В
	|				(ВЫБРАТЬ
	|					УказаныКоды.КодТНВЭД
	|				ИЗ
	|					УказаныКоды КАК УказаныКоды
	|				ГДЕ
	|					НЕ УказаныКоды.СырьевойТовар)
	|	И НЕ СырьевыеТовары.КодТНВЭД.СырьевойТовар
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОбъектыДляОбработки.Ссылка КАК Ссылка,
	|	ОбъектыДляОбработки.Ссылка.ВерсияДанных КАК ВерсияДанных,
	|	Единицы.Ссылка КАК ЕдиницаИзмерения,
	|	НЕ СырьевыеТовары.Ссылка ЕСТЬ NULL КАК СырьевойТовар
	|ИЗ
	|	ВТОбъектыДляОбработки КАК ОбъектыДляОбработки
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаКлассификатора КАК ТаблицаКлассификатора
	|		ПО ОбъектыДляОбработки.Ссылка.Код = ТаблицаКлассификатора.Код
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.УпаковкиЕдиницыИзмерения КАК Единицы
	|		ПО (ТаблицаКлассификатора.ЕдиницаИзмеренияКод = Единицы.Код)
	|			И (Единицы.Владелец = ЗНАЧЕНИЕ(Справочник.НаборыУпаковок.БазовыеЕдиницыИзмерения))
	|		ЛЕВОЕ СОЕДИНЕНИЕ СырьевыеТовары КАК СырьевыеТовары
	|		ПО ОбъектыДляОбработки.Ссылка = СырьевыеТовары.Ссылка";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ВТОбъектыДляОбработки", Результат.ИмяВременнойТаблицы);
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("ТаблицаКлассификатора", ТаблицаКлассификатора(0));
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		НачатьТранзакцию();
		
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяОбъекта);
			ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.Ссылка);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			
			Блокировка.Заблокировать();
			
		Исключение
			
			ОтменитьТранзакцию();
			ОбновлениеИнформационнойБазыУТ.СообщитьОНеудачнойБлокировке(Выборка.Ссылка);
			Продолжить;
			
		КонецПопытки;
		
		СправочникОбъект = ОбновлениеИнформационнойБазыУТ.ПроверитьПолучитьОбъект(Выборка.Ссылка, Выборка.ВерсияДанных, Параметры.Очередь);
		Если СправочникОбъект = Неопределено Тогда
			ЗафиксироватьТранзакцию();
			Продолжить;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(СправочникОбъект.ЕдиницаИзмерения) И ЗначениеЗаполнено(Выборка.ЕдиницаИзмерения) Тогда
			СправочникОбъект.ЕдиницаИзмерения = Выборка.ЕдиницаИзмерения;
		КонецЕсли;
		СправочникОбъект.ЭлементОбработан = Истина;
		Если Выборка.СырьевойТовар Тогда
			СправочникОбъект.СырьевойТовар = Истина;
		КонецЕсли;
		
		Попытка
			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(СправочникОбъект);
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ОбновлениеИнформационнойБазыУТ.СообщитьОНеудачнойОбработке(Выборка.Ссылка);
			ВызватьИсключение;
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = Не ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Параметры.Очередь, ПолноеИмяОбъекта);
		
КонецПроцедуры

Процедура СоздатьСлужебныеЭлементы() Экспорт
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПродажиНаЭкспортНесырьевыхТоваров") 
		ИЛИ ПолучитьФункциональнуюОпцию("ИспользоватьПродажиНаЭкспортСырьевыхТоваровУслуг") Тогда
	
		НесырьевойЭлемент = НайтиПоНаименованию("несырьевой товар");
		Если НесырьевойЭлемент.Пустая() Тогда
			НесырьевойЭлемент = СоздатьЭлемент();
			НесырьевойЭлемент.Код = "0000000001";
			НесырьевойЭлемент.СырьевойТовар = Ложь;
			НесырьевойЭлемент.ЭлементОбработан = Истина;
			НесырьевойЭлемент.Наименование = "несырьевой товар";
			НесырьевойЭлемент.НаименованиеПолное = "несырьевой товар";
			НесырьевойЭлемент.Записать();
		КонецЕсли;
		
		СырьевойЭлемент = НайтиПоНаименованию("сырьевой товар");
		Если СырьевойЭлемент.Пустая() Тогда
			СырьевойЭлемент = СоздатьЭлемент();
			СырьевойЭлемент.Код = "0000000002";
			СырьевойЭлемент.СырьевойТовар = Истина;
			СырьевойЭлемент.ЭлементОбработан = Истина;
			СырьевойЭлемент.Наименование = "сырьевой товар";
			СырьевойЭлемент.НаименованиеПолное = "сырьевой товар";
			СырьевойЭлемент.Записать();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли