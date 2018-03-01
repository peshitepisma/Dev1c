#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет список команд создания на основании.
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	СозданиеНаОснованииПереопределяемый.ДобавитьКомандуСоздатьНаОснованииБизнесПроцессЗадание(КомандыСозданияНаОсновании);
	
КонецПроцедуры

// Добавляет команду создания документа "Начисления по кредитам и депозитам".
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	Если ПравоДоступа("Добавление", Метаданные.Документы.НачисленияКредитовИДепозитов) Тогда
		КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Менеджер = Метаданные.Документы.НачисленияКредитовИДепозитов.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ОбщегоНазначенияУТ.ПредставлениеОбъекта(Метаданные.Документы.НачисленияКредитовИДепозитов);
		КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
		КомандаСоздатьНаОсновании.ФункциональныеОпции = "ИспользоватьДоговорыКредитовИДепозитов";
	

		Возврат КомандаСоздатьНаОсновании;
	КонецЕсли;

	Возврат Неопределено;
КонецФункции

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - Таблица с командами отчетов. Для изменения.
//       См. описание 1 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуСтруктураПодчиненности(КомандыОтчетов);
	
	
	
КонецПроцедуры


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Проведение

Функция ДополнительныеИсточникиДанныхДляДвижений(ИмяРегистра) Экспорт

	ИсточникиДанных = Новый Соответствие;

	Возврат ИсточникиДанных; 

КонецФункции

Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства, Регистры = Неопределено) Экспорт
	
	////////////////////////////////////////////////////////////////////////////
	// Создадим запрос инициализации движений
	
	Запрос = Новый Запрос;
	ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка);
	
	////////////////////////////////////////////////////////////////////////////
	// Сформируем текст запроса
	
	ТекстыЗапроса = Новый СписокЗначений;
	ТекстЗапросаТаблицаПрочиеДоходы(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаТаблицаПрочиеРасходы(Запрос, ТекстыЗапроса, Регистры);
	ТексЗапросаТаблицаРасчетыПоДоговорамКредитовИДепозитов(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаТаблицаДвиженияДенежныеСредстваДоходыРасходы(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаТаблицаСуммыДокументовВВалютеРегл(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаТаблицаДвиженияКонтрагентДоходыРасходы(Запрос, ТекстыЗапроса, Регистры);
	
	ПроведениеСерверУТ.ИнициализироватьТаблицыДляДвижений(Запрос, ТекстыЗапроса, ДополнительныеСвойства.ТаблицыДляДвижений, Истина);
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеДокумента.Дата                  КАК Период,
	|	ДанныеДокумента.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	ДанныеДокумента.Организация           КАК Организация,
	|	ДанныеДокумента.ДатаНачала            КАК ДатаНачала,
	|	ДанныеДокумента.ДатаОкончания         КАК ДатаОкончания
	|ИЗ
	|	Документ.НачисленияКредитовИДепозитов КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка";
	Реквизиты = Запрос.Выполнить().Выбрать();
	Реквизиты.Следующий();
	
	Запрос.УстановитьПараметр("Период",                Реквизиты.Период);
	Запрос.УстановитьПараметр("Организация",           Реквизиты.Организация);
	Запрос.УстановитьПараметр("ХозяйственнаяОперация", Реквизиты.ХозяйственнаяОперация);
	Запрос.УстановитьПараметр("ИспользоватьУчетПрочихДоходовРасходов", 
	                                                   ПолучитьФункциональнуюОпцию("ИспользоватьУчетПрочихДоходовРасходов"));
	Запрос.УстановитьПараметр("ВалютаУпр",             Константы.ВалютаУправленческогоУчета.Получить());
	Запрос.УстановитьПараметр("ВалютаРегл",            Константы.ВалютаРегламентированногоУчета.Получить());
	Запрос.УстановитьПараметр("ДатаНачала",            Реквизиты.ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания",         Реквизиты.ДатаОкончания);
	
	УниверсальныеМеханизмыПартийИСебестоимости.ЗаполнитьПараметрыИнициализации(Запрос, Реквизиты);
	
КонецПроцедуры

Процедура ИнициализироватьКлючиАналитикиУчетаПоПартнерам(Запрос)
	
	Если Запрос.Параметры.Свойство("КлючиАналитикиУчетаПоПартнерамИнициализированы") Тогда
		Возврат;
	КонецЕсли;
	
	ЗапросАналитик = Новый Запрос;
	ЗапросАналитик.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	&Организация                                           КАК Организация,
	|	ТаблицаНачислений.Партнер                              КАК Партнер,
	|	ТаблицаНачислений.Контрагент                           КАК Контрагент,
	|	ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка) КАК Договор,
	|	ДанныеДоговора.НаправлениеДеятельности КАК НаправлениеДеятельности
	|ИЗ
	|	Документ.НачисленияКредитовИДепозитов.Начисления КАК ТаблицаНачислений
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ДоговорыКредитовИДепозитов КАК ДанныеДоговора
	|		ПО ТаблицаНачислений.Договор = ДанныеДоговора.Ссылка
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаПоПартнерам КАК Аналитика
	|		ПО (&Организация = Аналитика.Организация)
	|			И ТаблицаНачислений.Контрагент = Аналитика.Контрагент
	|			И ТаблицаНачислений.Партнер = Аналитика.Партнер
	|			И Аналитика.Договор = ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка)
	|			И ДанныеДоговора.НаправлениеДеятельности = Аналитика.НаправлениеДеятельности
	|ГДЕ
	|	ТаблицаНачислений.Ссылка = &Ссылка
	|	И Аналитика.КлючАналитики ЕСТЬ NULL ";
	
	ЗапросАналитик.УстановитьПараметр("Ссылка",      Запрос.Параметры.Ссылка);
	ЗапросАналитик.УстановитьПараметр("Организация", Запрос.Параметры.Организация);

	Выборка = ЗапросАналитик.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		РегистрыСведений.АналитикаУчетаПоПартнерам.СоздатьКлючАналитики(Выборка);
	КонецЦикла;
	
	Запрос.УстановитьПараметр("КлючиАналитикиУчетаПоПартнерамИнициализированы", Истина);
	
КонецПроцедуры

Функция ТекстЗапросаВтКурсыВалют(Запрос, ТекстыЗапроса)
	
	ИмяРегистра = "ВтКурсыВалют"; 
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	КурсыВалют.Период    КАК Период,
	|	КурсыВалют.Валюта    КАК Валюта,
	|	КурсыВалют.Курс      КАК Курс,
	|	КурсыВалют.Кратность КАК Кратность
	|ПОМЕСТИТЬ ВтКурсыВалют
	|ИЗ
	|	РегистрСведений.КурсыВалют.СрезПоследних(&ДатаНачала, ) КАК КурсыВалют
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	КурсыВалют.Период,
	|	КурсыВалют.Валюта,
	|	КурсыВалют.Курс,
	|	КурсыВалют.Кратность
	|ИЗ
	|	РегистрСведений.КурсыВалют КАК КурсыВалют
	|ГДЕ
	|	КурсыВалют.Период МЕЖДУ &ДатаНачала И &ДатаОкончания
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	КурсыВалют.Период,
	|	КурсыВалют.Валюта";

	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаВтДатыКурсовВалют(Запрос, ТекстыЗапроса)
	
	ИмяРегистра = "ВтДатыКурсовВалют"; 
	
	Если Не ПроведениеСерверУТ.ЕстьТаблицаЗапроса("ВтКурсыВалют", ТекстыЗапроса) Тогда
		ТекстЗапросаВтКурсыВалют(Запрос, ТекстыЗапроса);
	КонецЕсли; 
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ТаблицаНачисления.Дата                 КАК Дата,
	|	ТаблицаНачисления.ВалютаВзаиморасчетов КАК ВалютаВзаиморасчетов,
	|	МАКСИМУМ(КурсыВалют.Период)            КАК ДатаКурсаВалюты,
	|	МАКСИМУМ(КурсыВалютыУпр.Период)        КАК ДатаКурсаУпр,
	|	МАКСИМУМ(КурсыВалютыРегл.Период)       КАК ДатаКурсаРегл
	|ПОМЕСТИТЬ ВтДатыКурсовВалют
	|ИЗ
	|	Документ.НачисленияКредитовИДепозитов.Начисления КАК ТаблицаНачисления
	|	ЛЕВОЕ СОЕДИНЕНИЕ ВтКурсыВалют КАК КурсыВалют
	|	ПО ТаблицаНачисления.ВалютаВзаиморасчетов = КурсыВалют.Валюта
	|		И ТаблицаНачисления.Дата >= КурсыВалют.Период
	|	ЛЕВОЕ СОЕДИНЕНИЕ ВтКурсыВалют КАК КурсыВалютыУпр
	|	ПО (&ВалютаУпр = КурсыВалютыУпр.Валюта)
	|		И ТаблицаНачисления.Дата >= КурсыВалютыУпр.Период
	|	ЛЕВОЕ СОЕДИНЕНИЕ ВтКурсыВалют КАК КурсыВалютыРегл
	|	ПО (&ВалютаРегл = КурсыВалютыРегл.Валюта)
	|		И ТаблицаНачисления.Дата >= КурсыВалютыРегл.Период
	|ГДЕ
	|	ТаблицаНачисления.Ссылка = &Ссылка
	|	
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаНачисления.ВалютаВзаиморасчетов,
	|	ТаблицаНачисления.Дата";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаВтТаблицаНачисления(Запрос, ТекстыЗапроса)
	
	ИмяРегистра = "ВтТаблицаНачисления"; 
	
	Если Не ПроведениеСерверУТ.ЕстьТаблицаЗапроса("ВтДатыКурсовВалют", ТекстыЗапроса) Тогда
		ТекстЗапросаВтДатыКурсовВалют(Запрос, ТекстыЗапроса);
	КонецЕсли; 
	
	Если Не ПроведениеСерверУТ.ЕстьТаблицаЗапроса("ВтКурсыВалют", ТекстыЗапроса) Тогда
		ТекстЗапросаВтКурсыВалют(Запрос, ТекстыЗапроса);
	КонецЕсли; 
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ТаблицаНачисления.НомерСтроки           КАК НомерСтроки,
	|	ТаблицаНачисления.Дата                  КАК Дата,
	|	ТаблицаНачисления.Партнер               КАК Партнер,
	|	ТаблицаНачисления.Контрагент            КАК Контрагент,
	|	ТаблицаНачисления.Договор               КАК Договор,
	|	ТаблицаНачисления.Договор.Подразделение КАК Подразделение,
	|	ТаблицаНачисления.Договор.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	ТаблицаНачисления.СтатьяДоходовРасходов КАК СтатьяДоходовРасходов,
	|	ТаблицаНачисления.ТипСуммыГрафика       КАК ТипСуммыГрафика,
	|	ТаблицаНачисления.ВалютаВзаиморасчетов  КАК ВалютаВзаиморасчетов,
	|	ТаблицаНачисления.СуммаВзаиморасчетов   КАК СуммаВзаиморасчетов,
	|	ВЫРАЗИТЬ(ТаблицаНачисления.СуммаВзаиморасчетов * КурсыВалют.Курс * КурсыВалютыУпр.Кратность / (КурсыВалют.Кратность * КурсыВалютыУпр.Курс) КАК ЧИСЛО(15, 2)) КАК СуммаУпр,
	|	ВЫРАЗИТЬ(ТаблицаНачисления.СуммаВзаиморасчетов * КурсыВалют.Курс * КурсыВалютыРегл.Кратность / (КурсыВалют.Кратность * КурсыВалютыРегл.Курс) КАК ЧИСЛО(15, 2)) КАК СуммаРегл
	|ПОМЕСТИТЬ ВтТаблицаНачисления
	|ИЗ
	|	Документ.НачисленияКредитовИДепозитов.Начисления КАК ТаблицаНачисления
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ 
	|		ВтДатыКурсовВалют КАК ДатыКурсовВалют
	|			ЛЕВОЕ СОЕДИНЕНИЕ ВтКурсыВалют КАК КурсыВалют
	|			ПО ДатыКурсовВалют.ВалютаВзаиморасчетов = КурсыВалют.Валюта
	|				И ДатыКурсовВалют.ДатаКурсаВалюты = КурсыВалют.Период
	|			ЛЕВОЕ СОЕДИНЕНИЕ ВтКурсыВалют КАК КурсыВалютыУпр
	|			ПО (&ВалютаУпр = КурсыВалютыУпр.Валюта)
	|				И ДатыКурсовВалют.ДатаКурсаУпр = КурсыВалютыУпр.Период
	|			ЛЕВОЕ СОЕДИНЕНИЕ ВтКурсыВалют КАК КурсыВалютыРегл
	|			ПО (&ВалютаРегл = КурсыВалютыРегл.Валюта)
	|				И ДатыКурсовВалют.ДатаКурсаРегл = КурсыВалютыРегл.Период
	|		ПО ТаблицаНачисления.ВалютаВзаиморасчетов = ДатыКурсовВалют.ВалютаВзаиморасчетов
	|			И ТаблицаНачисления.Дата = ДатыКурсовВалют.Дата
	|ГДЕ
	|	ТаблицаНачисления.Ссылка = &Ссылка";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаПрочиеДоходы(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ПрочиеДоходы"; 
	
	Если Не ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	Если Не ПроведениеСерверУТ.ЕстьТаблицаЗапроса("ВтТаблицаНачисления", ТекстыЗапроса) Тогда
		ТекстЗапросаВтТаблицаНачисления(Запрос, ТекстыЗапроса);
	КонецЕсли; 
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ТаблицаДоходы.Дата                     КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	&Организация                           КАК Организация,
	|	ТаблицаДоходы.Подразделение            КАК Подразделение,
	|	ТаблицаДоходы.НаправлениеДеятельности  КАК НаправлениеДеятельности,
	|	ТаблицаДоходы.СтатьяДоходовРасходов    КАК СтатьяДоходов,
	|	ТаблицаДоходы.Договор                  КАК АналитикаДоходов,
	|	ТаблицаДоходы.ВалютаВзаиморасчетов     КАК Валюта,
	|	ТаблицаДоходы.СуммаУпр                 КАК Сумма,
	|	(ВЫБОР
	|		КОГДА &УправленческийУчетОрганизаций
	|			ТОГДА ТаблицаДоходы.СуммаУпр
	|		ИНАЧЕ 0 КОНЕЦ) КАК СуммаУпр,
	|	(ВЫБОР
	|		КОГДА &ИспользоватьУчетПрочихДоходовРасходовРегл
	|			ТОГДА ТаблицаДоходы.СуммаРегл
	|		ИНАЧЕ 0 КОНЕЦ) КАК СуммаРегл,
	|	&ХозяйственнаяОперация                 КАК ХозяйственнаяОперация
	|ИЗ
	|	ВтТаблицаНачисления КАК ТаблицаДоходы
	|ГДЕ
	|	&ИспользоватьУчетПрочихДоходовРасходов
	|	И &ХозяйственнаяОперация В (
	|			ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.НачисленияПоДепозитам), 
	|			ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.НачисленияПоЗаймамВыданным)
	|	)";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаВтИсходныеПрочиеРасходы(Запрос, ТекстыЗапроса)
	
	ИмяРегистра = "ВтИсходныеПрочиеРасходы";
	
	Если Не ПроведениеСерверУТ.ЕстьТаблицаЗапроса("ВтТаблицаНачисления", ТекстыЗапроса) Тогда
		ТекстЗапросаВтТаблицаНачисления(Запрос, ТекстыЗапроса);
	КонецЕсли; 
	
	ТекстЗапроса = РегистрыНакопления.ПрочиеРасходы.ТекстОписаниеВтИсходныеПрочиеРасходы();
	ТекстЗапроса = ТекстЗапроса + "ОБЪЕДИНИТЬ ВСЕ" + "
	|ВЫБРАТЬ
	|	ТаблицаРасходы.Дата                     КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)  КАК ВидДвижения,
	|	&Организация                            КАК Организация,
	|	ТаблицаРасходы.Подразделение            КАК Подразделение,
	|	ТаблицаРасходы.СтатьяДоходовРасходов    КАК СтатьяРасходов,
	|	ТаблицаРасходы.Договор                  КАК АналитикаРасходов,
	|	ТаблицаРасходы.НаправлениеДеятельности  КАК НаправлениеДеятельности,
	|	НЕОПРЕДЕЛЕНО							КАК ВидДеятельностиНДС,
	|
	|	ТаблицаРасходы.СуммаУпр                 КАК СуммаСНДС,
	|	ТаблицаРасходы.СуммаУпр                 КАК СуммаБезНДС,
	|	ТаблицаРасходы.СуммаУпр                 КАК СуммаБезНДСУпр,
	|	ТаблицаРасходы.СуммаРегл 				КАК СуммаСНДСРегл,
	|	ТаблицаРасходы.СуммаРегл 				КАК СуммаБезНДСРегл,
	|	0 КАК ПостояннаяРазница,
	|	0 КАК ВременнаяРазница,
	|	&ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	НЕОПРЕДЕЛЕНО КАК АналитикаУчетаНоменклатуры
	|ИЗ
	|	ВтТаблицаНачисления КАК ТаблицаРасходы
	|ГДЕ
	|	&ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.НачисленияПоКредитам)
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаВтПрочиеРасходы(Запрос, ТекстыЗапроса)
	
	ИмяРегистра = "ВтПрочиеРасходы";
	
	Если Не ПроведениеСерверУТ.ЕстьТаблицаЗапроса("ВтИсходныеПрочиеРасходы", ТекстыЗапроса) Тогда
		ТекстЗапросаТаблицаВтИсходныеПрочиеРасходы(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	ТекстЗапроса = РегистрыНакопления.ПрочиеРасходы.ТекстЗапросаТаблицаВтПрочиеРасходы();
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаПрочиеРасходы(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ПрочиеРасходы"; 
	
	Если Не ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	Если Не ПроведениеСерверУТ.ЕстьТаблицаЗапроса("ВтПрочиеРасходы", ТекстыЗапроса) Тогда
		ТекстЗапросаТаблицаВтПрочиеРасходы(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	ТекстЗапроса = РегистрыНакопления.ПрочиеРасходы.ТекстЗапросаТаблицаПрочиеРасходы();
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТексЗапросаТаблицаРасчетыПоДоговорамКредитовИДепозитов(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "РасчетыПоДоговорамКредитовИДепозитов";
	
	Если Не ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	Если Не ПроведениеСерверУТ.ЕстьТаблицаЗапроса("ВтТаблицаНачисления", ТекстыЗапроса) Тогда
		ТекстЗапросаВтТаблицаНачисления(Запрос, ТекстыЗапроса);
	КонецЕсли; 
	
	ИнициализироватьКлючиАналитикиУчетаПоПартнерам(Запрос);
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА ТаблицаНачислений.Договор.ХарактерДоговора = ЗНАЧЕНИЕ(Перечисление.ХарактерДоговораКредитовИДепозитов.КредитИлиЗайм)
	|			ТОГДА ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	|		ИНАЧЕ ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|	КОНЕЦ                                                           КАК ВидДвижения,
	|	ТаблицаНачислений.Дата                                          КАК Период,
	|	&Организация                                                    КАК Организация,
	|	ТаблицаНачислений.Партнер                                       КАК Партнер,
	|	ТаблицаНачислений.Контрагент                                    КАК Контрагент,
	|	ЕСТЬNULL(АналитикаПоПартнерам.КлючАналитики, НЕОПРЕДЕЛЕНО)      КАК АналитикаУчетаПоПартнерам,
	|	ТаблицаНачислений.Договор                                       КАК Договор,
	|	ТаблицаНачислений.ВалютаВзаиморасчетов                          КАК Валюта,
	|	ТаблицаНачислений.СтатьяДоходовРасходов                         КАК СтатьяДоходовРасходов,
	|	ТаблицаНачислений.СтатьяДоходовРасходов                         КАК СтатьяАналитики,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыГрафикаКредитовИДепозитов.Начисления) КАК ТипГрафика,
	|	ТаблицаНачислений.ТипСуммыГрафика                               КАК ТипСуммы,
	|	ТаблицаНачислений.СуммаВзаиморасчетов                           КАК СуммаВВалюте,
	|	ТаблицаНачислений.СуммаУпр                                      КАК СуммаУпр,
	|	ТаблицаНачислений.СуммаРегл                                     КАК СуммаРегл
	|ИЗ
	|	ВтТаблицаНачисления КАК ТаблицаНачислений
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаПоПартнерам КАК АналитикаПоПартнерам
	|		ПО (&Организация = АналитикаПоПартнерам.Организация)
	|			И ТаблицаНачислений.Партнер = АналитикаПоПартнерам.Партнер
	|			И ТаблицаНачислений.Контрагент = АналитикаПоПартнерам.Контрагент
	|			И АналитикаПоПартнерам.Договор = ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка)
	|			И АналитикаПоПартнерам.НаправлениеДеятельности = ТаблицаНачислений.НаправлениеДеятельности";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаДвиженияДенежныеСредстваДоходыРасходы(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ДвиженияДенежныеСредстваДоходыРасходы";
	
	Если Не ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	Если Не ПроведениеСерверУТ.ЕстьТаблицаЗапроса("ВтТаблицаНачисления", ТекстыЗапроса) Тогда
		ТекстЗапросаВтТаблицаНачисления(Запрос, ТекстыЗапроса);
	КонецЕсли; 
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ТаблицаНачисления.Дата                              КАК Период,
	|	&ХозяйственнаяОперация                              КАК ХозяйственнаяОперация,
	|	&Организация                                        КАК Организация,
	|	ТаблицаНачисления.Подразделение                     КАК Подразделение,
	|	ТаблицаНачисления.Подразделение                     КАК ПодразделениеДоходовРасходов,
	|
	|	ТаблицаНачисления.НаправлениеДеятельности           КАК НаправлениеДеятельностиДС,
	|	ТаблицаНачисления.Договор                           КАК ДенежныеСредства,
	|	Значение(Перечисление.ТипыДенежныхСредств.Депозиты) КАК ТипДенежныхСредств,
	|	НЕОПРЕДЕЛЕНО                                        КАК СтатьяДвиженияДенежныхСредств,
	|	ТаблицаНачисления.ВалютаВзаиморасчетов              КАК Валюта,
	|
	|	ТаблицаНачисления.НаправлениеДеятельности           КАК НаправлениеДеятельностиСтатьи,
	|	ТаблицаНачисления.СтатьяДоходовРасходов             КАК СтатьяДоходовРасходов,
	|	ТаблицаНачисления.Договор                           КАК АналитикаДоходов,
	|	НЕОПРЕДЕЛЕНО                                        КАК АналитикаРасходов,
	|
	|	ТаблицаНачисления.СуммаУпр                          КАК Сумма,
	|	ТаблицаНачисления.СуммаРегл                         КАК СуммаРегл,
	|	ТаблицаНачисления.СуммаВзаиморасчетов               КАК СуммаВВалюте,
	|
	|	ТаблицаНачисления.Договор                           КАК ИсточникГФУДенежныхСредств,
	|	ТаблицаНачисления.СтатьяДоходовРасходов             КАК ИсточникГФУДоходовРасходов
	|ИЗ
	|	ВтТаблицаНачисления КАК ТаблицаНачисления
	|ГДЕ
	|	&ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.НачисленияПоДепозитам)";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;

КонецФункции

Функция ТекстЗапросаТаблицаСуммыДокументовВВалютеРегл(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "СуммыДокументовВВалютеРегл";
	
	Если Не ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	Если Не ПроведениеСерверУТ.ЕстьТаблицаЗапроса("ВтТаблицаНачисления", ТекстыЗапроса) Тогда
		ТекстЗапросаВтТаблицаНачисления(Запрос, ТекстыЗапроса);
	КонецЕсли; 

	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ТаблицаДокумента.НомерСтроки          КАК НомерСтроки,
	|	ТаблицаДокумента.Дата                 КАК Период,
	|	ТаблицаДокумента.ВалютаВзаиморасчетов КАК Валюта,
	|	ТаблицаДокумента.ИдентификаторСтроки  КАК ИдентификаторСтроки,
	|	ТаблицаДокумента.СуммаВзаиморасчетов  КАК СуммаБезНДС,
	|	НЕОПРЕДЕЛЕНО                          КАК СтавкаНДС,
	|	0                                     КАК СуммаНДС,
	|	ВЫБОР КОГДА ТаблицаДокумента.ВалютаВзаиморасчетов = &ВалютаРегл
	|		ТОГДА ТаблицаДокумента.СуммаВзаиморасчетов
	|		ИНАЧЕ ВтНачисления.СуммаРегл
	|	КОНЕЦ                                 КАК СуммаБезНДСРегл,
	|	0                                     КАК СуммаНДСРегл,
	|	0                                     КАК СуммаНДСУпр,
	|	ВЫБОР КОГДА ТаблицаДокумента.ВалютаВзаиморасчетов = &ВалютаУпр
	|		ТОГДА ТаблицаДокумента.СуммаВзаиморасчетов
	|		ИНАЧЕ ВтНачисления.СуммаУпр
	|	КОНЕЦ                                 КАК СуммаБезНДСУпр,
	|	НЕОПРЕДЕЛЕНО                          КАК ТипРасчетов
	|
	|ИЗ
	|	Документ.НачисленияКредитовИДепозитов.Начисления КАК ТаблицаДокумента
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВтТаблицаНачисления КАК ВтНачисления
	|		ПО ТаблицаДокумента.НомерСтроки = ВтНачисления.НомерСтроки
	|
	|ГДЕ
	|	ТаблицаДокумента.Ссылка = &Ссылка";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаДвиженияКонтрагентДоходыРасходы(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ДвиженияКонтрагентДоходыРасходы";
	
	Если Не ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	Если Не ПроведениеСерверУТ.ЕстьТаблицаЗапроса("ВтТаблицаНачисления", ТекстыЗапроса) Тогда
		ТекстЗапросаВтТаблицаНачисления(Запрос, ТекстыЗапроса);
	КонецЕсли; 
	
#Область НачисленияПоЗаймамВыданным
	НачисленияПоЗаймамВыданным = 
	"ВЫБРАТЬ
	|	ТаблицаДоходы.Дата                  КАК Период,
	|	&ХозяйственнаяОперация              КАК ХозяйственнаяОперация,
	|	&Организация                        КАК Организация,
	|	ТаблицаДоходы.Договор.Подразделение КАК Подразделение,
	|	ТаблицаДоходы.Договор.Подразделение КАК ПодразделениеДоходовРасходов,
	|
	|	ТаблицаДоходы.НаправлениеДеятельности КАК НаправлениеДеятельностиКонтрагента,
	|	ТаблицаДоходы.Партнер               КАК Партнер,
	|	ТаблицаДоходы.Контрагент            КАК Контрагент,
	|	ТаблицаДоходы.Договор               КАК Договор,
	|	НЕОПРЕДЕЛЕНО                        КАК ОбъектРасчетов,
	|
	|	ТаблицаДоходы.НаправлениеДеятельности КАК НаправлениеДеятельностиСтатьи,
	|	ТаблицаДоходы.СтатьяДоходовРасходов КАК СтатьяДоходовРасходов,
	|	ТаблицаДоходы.Договор               КАК АналитикаДоходов,
	|	НЕОПРЕДЕЛЕНО                        КАК АналитикаРасходов,
	|	
	|	ТаблицаДоходы.СуммаУпр              КАК Сумма,
	|	0                                   КАК СуммаБезНДС,
	|	ТаблицаДоходы.СуммаРегл             КАК СуммаРегл,
	|	0                                   КАК СуммаРеглБезНДС,
	|
	|	ТаблицаДоходы.ВалютаВзаиморасчетов  КАК Валюта,
	|	ТаблицаДоходы.СуммаВзаиморасчетов   КАК СуммаВВалюте,
	|	0                                   КАК СуммаБезНДСВВалюте,
	|		
	|	ТаблицаДоходы.ВалютаВзаиморасчетов  КАК ВалютаВзаиморасчетов,
	|	ТаблицаДоходы.СуммаВзаиморасчетов   КАК СуммаВВалютеВзаиморасчетов,
	|	0                                   КАК СуммаБезНДСВВалютеВзаиморасчетов,
	|
	|	ТаблицаДоходы.Договор               КАК ИсточникГФУРасчетов
	|ИЗ
	|	ВтТаблицаНачисления КАК ТаблицаДоходы
	|ГДЕ
	|	&ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.НачисленияПоЗаймамВыданным)
	|";
#КонецОбласти

#Область НачисленияПоКредитам
	НачисленияПоКредитам = 
	"ВЫБРАТЬ
	|	ТаблицаРасходы.Дата                  КАК Период,
	|	&ХозяйственнаяОперация               КАК ХозяйственнаяОперация,
	|	&Организация                         КАК Организация,
	|	ТаблицаРасходы.Договор.Подразделение КАК Подразделение,
	|	ТаблицаРасходы.Договор.Подразделение КАК ПодразделениеДоходовРасходов,
	|
	|	ТаблицаРасходы.НаправлениеДеятельности КАК НаправлениеДеятельностиКонтрагента,
	|	ТаблицаРасходы.Партнер               КАК Партнер,
	|	ТаблицаРасходы.Контрагент            КАК Контрагент,
	|	ТаблицаРасходы.Договор               КАК Договор,
	|	НЕОПРЕДЕЛЕНО                         КАК ОбъектРасчетов,
	|
	|	ТаблицаРасходы.НаправлениеДеятельности КАК НаправлениеДеятельностиСтатьи,
	|	ТаблицаРасходы.СтатьяДоходовРасходов КАК СтатьяДоходовРасходов,
	|	НЕОПРЕДЕЛЕНО                         КАК АналитикаДоходов,
	|	ТаблицаРасходы.Договор               КАК АналитикаРасходов,
	|	
	|	ТаблицаРасходы.СуммаУпр              КАК Сумма,
	|	0                                    КАК СуммаБезНДС,
	|	ТаблицаРасходы.СуммаРегл             КАК СуммаРегл,
	|	0                                    КАК СуммаРеглБезНДС,
	|
	|	ТаблицаРасходы.ВалютаВзаиморасчетов  КАК Валюта,
	|	ТаблицаРасходы.СуммаВзаиморасчетов   КАК СуммаВВалюте,
	|	0                                    КАК СуммаБезНДСВВалюте,
	|		
	|	ТаблицаРасходы.ВалютаВзаиморасчетов  КАК ВалютаВзаиморасчетов,
	|	ТаблицаРасходы.СуммаВзаиморасчетов   КАК СуммаВВалютеВзаиморасчетов,
	|	0                                    КАК СуммаБезНДСВВалютеВзаиморасчетов,
	|
	|	ТаблицаРасходы.Договор               КАК ИсточникГФУРасчетов
	|ИЗ
	|	ВтТаблицаНачисления КАК ТаблицаРасходы
	|ГДЕ
	|	&ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.НачисленияПоКредитам)";
#КонецОбласти

	ТекстЗапроса = НачисленияПоЗаймамВыданным
	             + " ОБЪЕДИНИТЬ ВСЕ " + НачисленияПоКредитам;
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
