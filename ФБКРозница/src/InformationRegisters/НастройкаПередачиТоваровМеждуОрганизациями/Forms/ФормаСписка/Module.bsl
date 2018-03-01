
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Элементы.ТипЗапасов.СписокВыбора.Добавить(Перечисления.ТипыЗапасов.Товар);
	Если ПолучитьФункциональнуюОпцию("ИспользоватьКомиссиюПриЗакупках") Тогда
		Элементы.ТипЗапасов.СписокВыбора.Добавить(Перечисления.ТипыЗапасов.КомиссионныйТовар);
	КонецЕсли;
	
	
	Элементы.ТипЗапасов.Видимость = Элементы.ТипЗапасов.СписокВыбора.Количество() > 1;
	
	ЗаполнитьТаблицуНастройки();
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Организация = Настройки.Получить("Организация");
	ОрганизацияПродавец = Настройки.Получить("ОрганизацияПродавец");
	ТипЗапасов = Настройки.Получить("ТипЗапасов");
	Если ЗначениеЗаполнено(Организация)
	 ИЛИ ЗначениеЗаполнено(ТипЗапасов)
	 ИЛИ ЗначениеЗаполнено(ОрганизацияПродавец) Тогда
		ЗаполнитьТаблицуНастройки();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ЗаполнитьТаблицуНастройки();
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПродавецПриИзменении(Элемент)
	
	ЗаполнитьТаблицуНастройки();
	
КонецПроцедуры

&НаКлиенте
Процедура ТипЗапасовПриИзменении(Элемент)
	
	ЗаполнитьТаблицуНастройки();
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаНастройкиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Перем СпособПередачи;
	Перем Валюта;
	
	Позиция = 0;
	КоличествоСимволов = СтрДлина(Поле.Имя);
	Для Сч = 0 По КоличествоСимволов - 1 Цикл
		Если СтрНайти("0123456789", Сред(Поле.Имя, КоличествоСимволов - Сч, 1)) = 0 Тогда
			Позиция = КоличествоСимволов - Сч + 1;
			ИндексКолонки = Сред(Поле.Имя, Позиция);
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	ИндексКолонки = Сред(Поле.Имя, Позиция);
	
	СтрокаТаблицы = Элементы.ТаблицаНастройки.ТекущиеДанные;
	
	
	Если СтрокаТаблицы.Свойство("СпособПередачи" + ИндексКолонки) Тогда
		
		СпособПередачиНеТребуется = ПредопределенноеЗначение("Перечисление.СпособыПередачиТоваров.НеТребуется");
		Если СтрокаТаблицы["СпособПередачи" + ИндексКолонки] <> СпособПередачиНеТребуется Тогда
			
			СтруктураКлюча = Новый Структура("ОрганизацияВладелец, ОрганизацияПродавец, ТипЗапасов");
			СтруктураКлюча.ОрганизацияПродавец = СтрокаТаблицы["Продавец" + ИндексКолонки];
			СтруктураКлюча.ОрганизацияВладелец = СтрокаТаблицы.Организация;
			СтруктураКлюча.ТипЗапасов = СтрокаТаблицы.ТипЗапасов;
			
			ПараметрыФормыЗаписи = Новый Структура;
			
			Если СтрокаТаблицы["ЕстьВРегистре" + ИндексКолонки] Тогда
				ПараметрыФормыЗаписи.Вставить("Ключ", КлючЗаписиРегистра(СтруктураКлюча));
			Иначе
				СтруктураКлюча.Вставить("СпособПередачиТоваров", СтрокаТаблицы["СпособПередачи" + ИндексКолонки]);
				
				Если Не ЗначениеЗаполнено(СтруктураКлюча.СпособПередачиТоваров) Тогда
					СтруктураКлюча.СпособПередачиТоваров = ПредопределенноеЗначение("Перечисление.СпособыПередачиТоваров.НеПередается");
				КонецЕсли;
				
				ПараметрыФормыЗаписи.Вставить("ЗначенияЗаполнения", СтруктураКлюча);
			КонецЕсли;
			
			ОписаниеОповещенияОЗакрытии = Новый ОписаниеОповещения("ТаблицаНастройкиВыборЗавершение",
																	ЭтотОбъект,
																	Новый Структура("ИндексКолонки, СтрокаТаблицы", ИндексКолонки, СтрокаТаблицы));
			
			ОткрытьФорму("РегистрСведений.НастройкаПередачиТоваровМеждуОрганизациями.ФормаЗаписи",
						ПараметрыФормыЗаписи
						,
						,
						,
						,
						,
						ОписаниеОповещенияОЗакрытии,
						РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция КлючЗаписиРегистра(СтруктураКлюча)
	
	Возврат РегистрыСведений.НастройкаПередачиТоваровМеждуОрганизациями.СоздатьКлючЗаписи(СтруктураКлюча);
	
КонецФункции

&НаКлиенте
Процедура ТаблицаНастройкиВыборЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ИндексКолонки = ДополнительныеПараметры.ИндексКолонки;
	СтрокаТаблицы = ДополнительныеПараметры.СтрокаТаблицы;
	
	Если Результат <> Неопределено Тогда
		СтрокаТаблицы["СпособПередачи" + ИндексКолонки] = Результат.СпособПередачиТоваров;
		СтрокаТаблицы["Валюта" + ИндексКолонки] = Результат.Валюта;
		СтрокаТаблицы["Договор" + ИндексКолонки] = Результат.Договор;
		СтрокаТаблицы["ВидЦены" + ИндексКолонки] = Результат.ВидЦены;
		СтрокаТаблицы["ЕстьВРегистре" + ИндексКолонки] = Истина;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаСервере
Процедура ДобавитьСтрокуДереваНастройки(Выборка, СоответствиеОрганизаций, Знач СтрокаОрганизации)
	
	Если Выборка.ТипЗаписи() = ТипЗаписиЗапроса.ИтогПоГруппировке Тогда
		
		Если Выборка.Уровень() = 1 Тогда
			
		 	СтрокаОрганизации = ТаблицаНастройки.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаОрганизации, Выборка);
			
		КонецЕсли;
		
		СледующаяВыборка = Выборка.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока СледующаяВыборка.Следующий() Цикл
			ДобавитьСтрокуДереваНастройки(СледующаяВыборка, СоответствиеОрганизаций, СтрокаОрганизации);
		КонецЦикла;
		
	Иначе
		
		ИндексКолонки = СоответствиеОрганизаций.Получить(Выборка.Продавец);
		Если СтрокаОрганизации <> Неопределено
		 И ИндексКолонки <> Неопределено Тогда
			СтрокаОрганизации["Продавец" + ИндексКолонки] = Выборка.Продавец;
			СтрокаОрганизации["СпособПередачи" + ИндексКолонки] = Выборка.СпособПередачиТоваров;
			СтрокаОрганизации["Валюта" + ИндексКолонки] = Выборка.Валюта;
			СтрокаОрганизации["Договор" + ИндексКолонки] = Выборка.Договор;
			СтрокаОрганизации["ВидЦены" + ИндексКолонки] = Выборка.ВидЦены;
			СтрокаОрганизации["ЕстьВРегистре" + ИндексКолонки] = Выборка.ЕстьВРегистре;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуНастройки()
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Организации.Ссылка КАК Организация,
	|	Организации.Наименование КАК ОрганизацияПредставление
	|ИЗ
	|	Справочник.Организации КАК Организации
	|ГДЕ
	|	Организации.Ссылка <> &Организация
	|	И (Организации.Ссылка = &ОрганизацияПродавец
	|		ИЛИ &ОрганизацияПродавец = Неопределено)
	|	И Не Организации.ПометкаУдаления
	|	И (Не Организации.Предопределенный ИЛИ &ИспользоватьУправленческуюОрганизацию)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Организации.Наименование Возр
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	ТипыЗапасов.Ссылка КАК ТипЗапасов,
	|	Организации.Ссылка КАК Организация,
	|	Продавцы.Ссылка КАК Продавец,
	|
	|	ВЫБОР КОГДА Организации.Ссылка = Продавцы.Ссылка
	|		ИЛИ Организации.ГоловнаяОрганизация = Продавцы.Ссылка
	|		ИЛИ Организации.Ссылка = Продавцы.ГоловнаяОрганизация
	|		ИЛИ (Организации.ГоловнаяОрганизация = Продавцы.ГоловнаяОрганизация И Организации.ОбособленноеПодразделение)
	|	ТОГДА
	|		ЗНАЧЕНИЕ(Перечисление.СпособыПередачиТоваров.НеТребуется)
	|	ИНАЧЕ
	|		Настройка.СпособПередачиТоваров
	|	КОНЕЦ КАК СпособПередачиТоваров,
	|
	|	(ВЫБОР КОГДА &ИспользоватьНесколькоВалют ТОГДА Настройка.Валюта
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КОНЕЦ) КАК Валюта,
	|
	|	ЕСТЬNULL(Настройка.Договор, ЗНАЧЕНИЕ(Справочник.ДоговорыМеждуОрганизациями.ПустаяСсылка)) КАК Договор,
	|	ЕСТЬNULL(Настройка.ВидЦены, ЗНАЧЕНИЕ(Справочник.ВидыЦен.ПустаяСсылка)) КАК ВидЦены,
	|	НЕ Настройка.ОрганизацияВладелец ЕСТЬ NULL КАК ЕстьВРегистре
	|ИЗ
	|	Справочник.Организации КАК Организации
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		Перечисление.ТипыЗапасов КАК ТипыЗапасов
	|	ПО
	|		Истина
	|		
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		Справочник.Организации КАК Продавцы
	|	ПО
	|		Истина
	|		
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.НастройкаПередачиТоваровМеждуОрганизациями КАК Настройка
	|	ПО
	|		Организации.Ссылка = Настройка.ОрганизацияВладелец
	|		И Продавцы.Ссылка = Настройка.ОрганизацияПродавец
	|		И ТипыЗапасов.Ссылка = Настройка.ТипЗапасов
	|		
	|ГДЕ
	|	Не Организации.ПометкаУдаления
	|	И Не Продавцы.ПометкаУдаления
	|	И ТипыЗапасов.Ссылка В (&ТипыЗапасов)
	|	И (Организации.Ссылка = &Организация
	|		ИЛИ &Организация = Неопределено)
	|	И (ТипыЗапасов.Ссылка = &ТипЗапасов
	|		ИЛИ &ТипЗапасов = Неопределено)
	|	И Организации.Ссылка <> &ОрганизацияПродавец
	|	И Продавцы.Ссылка <> &Организация
	|	И (Продавцы.Ссылка = &ОрганизацияПродавец
	|		ИЛИ &ОрганизацияПродавец = Неопределено)
	|	И (Не Организации.Предопределенный ИЛИ &ИспользоватьУправленческуюОрганизацию)
	|	И (Не Продавцы.Предопределенный ИЛИ &ИспользоватьУправленческуюОрганизацию)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Организации.Наименование Возр,
	|	ТипЗапасов,
	|	Продавец
	|
	|ИТОГИ ПО
	|	Организация,
	|	ТипЗапасов
	|");
	Запрос.УстановитьПараметр("Организация", ?(ЗначениеЗаполнено(Организация), Организация, Неопределено));
	Запрос.УстановитьПараметр("ОрганизацияПродавец", ?(ЗначениеЗаполнено(ОрганизацияПродавец), ОрганизацияПродавец, Неопределено));
	Запрос.УстановитьПараметр("ТипыЗапасов", Элементы.ТипЗапасов.СписокВыбора.ВыгрузитьЗначения());
	Запрос.УстановитьПараметр("ТипЗапасов", ?(ЗначениеЗаполнено(ТипЗапасов), ТипЗапасов, Неопределено));
	Запрос.УстановитьПараметр("ИспользоватьУправленческуюОрганизацию", ПолучитьФункциональнуюОпцию("ИспользоватьУправленческуюОрганизацию"));
	Запрос.УстановитьПараметр("ИспользоватьНесколькоВалют", ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВалют"));
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	УстановитьПривилегированныйРежим(Истина);
	
	РезультатЗапросаПоОрганизациям = МассивРезультатов[0];
	РезультатЗапросаПоВидамЗапасов = МассивРезультатов[1];
	
	МассивРеквизитов = Новый Массив;
	МассивДобавляемыхРеквизитов = Новый Массив;
	СоответствиеОрганизаций = Новый Соответствие;
	СоответствиеРеквизитов = Новый Соответствие;
	ИндексОрганизации = 0;
	
	// Добавим колонки таблицы настройки.
	ВыборкаПоОрганизациям = РезультатЗапросаПоОрганизациям.Выбрать();
	Пока ВыборкаПоОрганизациям.Следующий() Цикл
		
		НовыйРеквизит = Новый РеквизитФормы(
			"СпособПередачи" + ИндексОрганизации,
			Новый ОписаниеТипов("ПеречислениеСсылка.СпособыПередачиТоваров"),
			"ТаблицаНастройки",
			ВыборкаПоОрганизациям.ОрганизацияПредставление);
		МассивРеквизитов.Добавить(НовыйРеквизит);
		СоответствиеРеквизитов.Вставить(НовыйРеквизит, ИндексОрганизации);
		
		Если ИндексОрганизации > КоличествоГруппКолонок Тогда
			
			МассивДобавляемыхРеквизитов.Добавить(НовыйРеквизит);
			
			// Добавим новую колонку "Продавец".
			НовыйРеквизитПродавец = Новый РеквизитФормы(
				"Продавец" + ИндексОрганизации,
				Новый ОписаниеТипов("СправочникСсылка.Организации"),
				"ТаблицаНастройки");
			МассивДобавляемыхРеквизитов.Добавить(НовыйРеквизитПродавец);
			
			// Добавим новую колонку "Валюта".
			НовыйРеквизитВалюта = Новый РеквизитФормы(
				"Валюта" + ИндексОрганизации,
				Новый ОписаниеТипов("СправочникСсылка.Валюты"),
				"ТаблицаНастройки");
			МассивРеквизитов.Добавить(НовыйРеквизитВалюта);
			МассивДобавляемыхРеквизитов.Добавить(НовыйРеквизитВалюта);
			СоответствиеРеквизитов.Вставить(НовыйРеквизитВалюта, ИндексОрганизации);
			
			// Добавим новую колонку "Вид цены".
			НовыйРеквизитВидЦены = Новый РеквизитФормы(
				"ВидЦены" + ИндексОрганизации,
				Новый ОписаниеТипов("СправочникСсылка.ВидыЦен"),
				"ТаблицаНастройки");
			МассивРеквизитов.Добавить(НовыйРеквизитВидЦены);
			МассивДобавляемыхРеквизитов.Добавить(НовыйРеквизитВидЦены);
			СоответствиеРеквизитов.Вставить(НовыйРеквизитВидЦены, ИндексОрганизации);
			
			// Добавим новую колонку "Договор".
			НовыйРеквизитДоговор = Новый РеквизитФормы(
				"Договор" + ИндексОрганизации,
				Новый ОписаниеТипов("СправочникСсылка.ДоговорыМеждуОрганизациями"),
				"ТаблицаНастройки");
			МассивРеквизитов.Добавить(НовыйРеквизитДоговор);
			МассивДобавляемыхРеквизитов.Добавить(НовыйРеквизитДоговор);
			СоответствиеРеквизитов.Вставить(НовыйРеквизитДоговор, ИндексОрганизации);
			
			// Добавим новую колонку "ЕстьВРегистре".
			НовыйРеквизитЕстьВРегистре = Новый РеквизитФормы(
				"ЕстьВРегистре" + ИндексОрганизации,
				Новый ОписаниеТипов("Булево"),
				"ТаблицаНастройки");
			МассивДобавляемыхРеквизитов.Добавить(НовыйРеквизитЕстьВРегистре);
			СоответствиеРеквизитов.Вставить(НовыйРеквизитЕстьВРегистре, ИндексОрганизации);
		КонецЕсли;
		
		СоответствиеОрганизаций.Вставить(ВыборкаПоОрганизациям.Организация, ИндексОрганизации);
		
		ИндексОрганизации = ИндексОрганизации + 1;
		
	КонецЦикла;
	
	КоличествоГруппКолонок = Макс(КоличествоГруппКолонок, ИндексОрганизации);
	
	Если МассивДобавляемыхРеквизитов.Количество() > 0 Тогда
		ИзменитьРеквизиты(МассивДобавляемыхРеквизитов);
	КонецЕсли;
	
	// Добавим элементы формы.
	Для Каждого Реквизит из МассивРеквизитов Цикл
		
		ИмяЭлемента = Реквизит.Путь + Реквизит.Имя;
		Элемент = Элементы.Найти(ИмяЭлемента);
		
		НомерГруппы = СоответствиеРеквизитов.Получить(Реквизит);
		Если НомерГруппы = Неопределено Тогда
			НомерГруппы = 99;
		КонецЕсли;
		ИмяГруппы = "ТаблицаНастройкиГруппа" + НомерГруппы;
		ЭлементГруппа = Элементы.Найти(ИмяГруппы);
		Если ЭлементГруппа = Неопределено Тогда
			ЭлементГруппа = Элементы.Добавить(
				ИмяГруппы,
				Тип("ГруппаФормы"),
				Элементы[Реквизит.Путь]);
			ЭлементГруппа.Группировка = ГруппировкаКолонок.ВЯчейке;
		КонецЕсли;
		
		Если Элемент = Неопределено Тогда
			Элемент = Элементы.Добавить(
				ИмяЭлемента,
				Тип("ПолеФормы"),
				ЭлементГруппа);
			Элемент.Вид = ВидПоляФормы.ПолеВвода;
			Элемент.ПутьКДанным = Реквизит.Путь + "." + Реквизит.Имя;
			Элемент.ТолькоПросмотр = Истина;
			Если СтрНайти(ИмяЭлемента, "Валюта") > 0 Тогда
				Элемент.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
				Элемент.Ширина = 5;
			ИначеЕсли СтрНайти(ИмяЭлемента, "Договор") > 0 
				ИЛИ СтрНайти(ИмяЭлемента, "ВидЦены") > 0 Тогда
				Элемент.Видимость = Ложь;
			Иначе
				Элемент.Ширина = 10;
			КонецЕсли;
		КонецЕсли;
		
		Элемент.Заголовок = Реквизит.Заголовок;
		
	КонецЦикла;
	
	// Заполним таблицу настройки.
	ТаблицаНастройки.Очистить();
	
	Выборка = РезультатЗапросаПоВидамЗапасов.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока Выборка.Следующий() Цикл
		ДобавитьСтрокуДереваНастройки(
			Выборка,
			СоответствиеОрганизаций,
			Неопределено); // СтрокаОрганизации
	КонецЦикла;
	
	КоличествоОрганизаций = СоответствиеОрганизаций.Количество();
	Для Сч = 0 По КоличествоГруппКолонок Цикл
		ИмяЭлемента = "ТаблицаНастройкиГруппа" + Сч;
		Элемент = Элементы.Найти(ИмяЭлемента);
		Если Элемент <> Неопределено Тогда
			ЭлементВидимость = (Сч < КоличествоОрганизаций);
			Если Элемент.Видимость <> ЭлементВидимость Тогда
				Элемент.Видимость = ЭлементВидимость;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	// Добавим условное оформление новых колонок.
	Для Сч = 0 По ИндексОрганизации Цикл
		
		// Условое оформление для способа передачи "Не требуется".
		НовыйЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
		НовыйЭлементУсловногоОформления.Использование = Истина;
	
		ЭлементОтбора = НовыйЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.Использование = Истина;
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаНастройки.СпособПередачи" + Сч);
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.ПравоеЗначение = Перечисления.СпособыПередачиТоваров.НеТребуется;
		
		НовоеПоле = НовыйЭлементУсловногоОформления.Поля.Элементы.Добавить();
		НовоеПоле.Использование = Истина;
		НовоеПоле.Поле = Новый ПолеКомпоновкиДанных("ТаблицаНастройкиСпособПередачи" + Сч);
		
		НовыйЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветРамки);
		
		// Условое оформление для незаполненного способа передачи.
		НовыйЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
		НовыйЭлементУсловногоОформления.Использование = Истина;
	
		ЭлементОтбора = НовыйЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.Использование = Истина;
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаНастройки.СпособПередачи" + Сч);
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
		
		НовоеПоле = НовыйЭлементУсловногоОформления.Поля.Элементы.Добавить();
		НовоеПоле.Использование = Истина;
		НовоеПоле.Поле = Новый ПолеКомпоновкиДанных("ТаблицаНастройкиСпособПередачи" + Сч);
		
		НовыйЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='Не передается'"));
		
	КонецЦикла;
		
КонецПроцедуры

#КонецОбласти

#КонецОбласти
