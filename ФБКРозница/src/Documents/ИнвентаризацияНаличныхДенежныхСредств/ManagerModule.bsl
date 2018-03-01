#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Определяет список команд создания на основании.
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	
	
КонецПроцедуры

// Добавляет команду создания документа "Инвентаризация наличных денежных средств".
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	Если ПравоДоступа("Добавление", Метаданные.Документы.ИнвентаризацияНаличныхДенежныхСредств) Тогда
		КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Менеджер = Метаданные.Документы.ИнвентаризацияНаличныхДенежныхСредств.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ОбщегоНазначенияУТ.ПредставлениеОбъекта(Метаданные.Документы.ИнвентаризацияНаличныхДенежныхСредств);
		КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
		
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
	
	
	
КонецПроцедуры


// Процедура заполняет массивы реквизитов, зависимых от хозяйственной операции документа.
//
// Параметры:
//	ХозяйственнаяОперация - ПеречислениеСсылка.ХозяйственныеОперации - Выбранная хозяйственная операция
//	МассивВсехРеквизитов - Массив - Массив всех имен реквизитов, зависимых от хозяйственной операции
//	МассивРеквизитовОперации - Массив - Массив имен реквизитов, используемых в выбранной хозяйственной операции
//
Процедура ЗаполнитьИменаРеквизитовПоХозяйственнойОперации(ХозяйственнаяОперация, МассивВсехРеквизитов, МассивРеквизитовОперации) Экспорт
	
	МассивВсехРеквизитов = Новый Массив;
	МассивВсехРеквизитов.Добавить("СтатьяДоходов");
	МассивВсехРеквизитов.Добавить("АналитикаДоходов");
	МассивВсехРеквизитов.Добавить("СтатьяРасходов");
	МассивВсехРеквизитов.Добавить("АналитикаРасходов");
	
	МассивРеквизитовОперации = Новый Массив;
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ОтражениеИзлишкаПриИнкассацииДенежныхСредств Тогда
		
		МассивРеквизитовОперации.Добавить("СтатьяДоходов");
		МассивРеквизитовОперации.Добавить("АналитикаДоходов");
	
	ИначеЕсли ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ОтражениеНедостачиПриИнкассацииДенежныхСредств Тогда
		
		МассивРеквизитовОперации.Добавить("СтатьяРасходов");
		МассивРеквизитовОперации.Добавить("АналитикаРасходов");
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Проведение

Функция ДополнительныеИсточникиДанныхДляДвижений(ИмяРегистра) Экспорт

	ИсточникиДанных = Новый Соответствие;

	Возврат ИсточникиДанных; 

КонецФункции

Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства, Регистры = Неопределено) Экспорт
	
	// Создание запроса инициализации движений и заполенение его параметров
	Запрос = Новый Запрос;
	ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка);

	// Текст запроса, формирующего таблицы движений
	ТекстыЗапроса = Новый СписокЗначений;
	
	ТекстЗапросаПрочиеДоходы(Запрос, ТекстыЗапроса, Регистры);	
	ТекстЗапросаТаблицаПрочиеРасходы(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаТаблицаПартииПрочихРасходов(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаДенежныеСредстваНаличные(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаДвиженияДенежныеСредстваДоходыРасходы(Запрос, ТекстыЗапроса, Регистры);	
	ТекстЗапросаТаблицаПрочиеАктивыПассивы(Запрос, ТекстыЗапроса, Регистры);
		
	// Выполение запроса и выгрузка полученных таблиц для формирования движений
	ПроведениеСерверУТ.ИнициализироватьТаблицыДляДвижений(Запрос, ТекстыЗапроса, ДополнительныеСвойства.ТаблицыДляДвижений, Истина);
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)

	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеДокумента.Дата                                       КАК Период,
	|	ДанныеДокумента.Организация                                КАК Организация,
	|	ДанныеДокумента.КассоваяКнига                              КАК КассоваяКнига
	|ИЗ
	|	Документ.ИнвентаризацияНаличныхДенежныхСредств КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка";

	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Реквизиты = Запрос.Выполнить().Выбрать();
	Реквизиты.Следующий();
	
	ВалютаУправленческогоУчета = Константы.ВалютаУправленческогоУчета.Получить();
	ВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	
	Запрос.УстановитьПараметр("Период",                            Реквизиты.Период);
	Запрос.УстановитьПараметр("Организация",                       Реквизиты.Организация);
	
	Запрос.УстановитьПараметр("ХозяйственнаяОперацияИзлишек",      Перечисления.ХозяйственныеОперации.ОтражениеИзлишкаПриИнвентаризацииДенежныхСредств);
	Запрос.УстановитьПараметр("ХозяйственнаяОперацияНедостача",    Перечисления.ХозяйственныеОперации.ОтражениеНедостачиПриИнвентаризацииДенежныхСредств);
	
	Запрос.УстановитьПараметр("ВалютаУправленческогоУчета",        ВалютаУправленческогоУчета);
	Запрос.УстановитьПараметр("ВалютаРегламентированногоУчета",    ВалютаРегламентированногоУчета);
	УниверсальныеМеханизмыПартийИСебестоимости.ЗаполнитьПараметрыИнициализации(Запрос, Реквизиты);
	
КонецПроцедуры

Функция ТекстЗапросаВТКурсыВалютУпр(Запрос, ТекстыЗапроса)	
	
	ИмяРегистра = "ВТКурсыВалютУпр"; 
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	КурсВалюты.Валюта КАК Валюта,
	|	КурсВалюты.Курс * КурсВалютыУпр.Кратность / (КурсВалюты.Кратность * КурсВалютыУпр.Курс) КАК КоэффициентПересчета
	|ПОМЕСТИТЬ ВТКурсыВалютУпр
	|ИЗ РегистрСведений.КурсыВалют.СрезПоследних(&Период, ) КАК КурсВалюты
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(&Период, Валюта = &ВалютаУправленческогоУчета) КАК КурсВалютыУпр
	|	ПО (ИСТИНА)
	|ГДЕ
	|	КурсВалюты.Кратность <> 0
	|	И КурсВалютыУпр.Курс <> 0";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаВТКурсыВалютРегл(Запрос, ТекстыЗапроса)
	
	ИмяРегистра = "ВТКурсыВалютРегл"; 
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	КурсВалюты.Валюта КАК Валюта,
	|	КурсВалюты.Курс * КурсВалютыРегл.Кратность / (КурсВалюты.Кратность * КурсВалютыРегл.Курс) КАК КоэффициентПересчета
	|ПОМЕСТИТЬ ВТКурсыВалютРегл
	|ИЗ РегистрСведений.КурсыВалют.СрезПоследних(&Период, ) КАК КурсВалюты
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(&Период, Валюта = &ВалютаРегламентированногоУчета) КАК КурсВалютыРегл
	|	ПО (ИСТИНА)
	|ГДЕ
	|	КурсВалюты.Кратность <> 0
	|	И КурсВалютыРегл.Курс <> 0";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаВТКассы(Запрос, ТекстыЗапроса)
	
	ИмяРегистра = "ВТКассы"; 
	
	Если Не ПроведениеСерверУТ.ЕстьТаблицаЗапроса("ВТКурсыВалютУпр", ТекстыЗапроса) Тогда
		ТекстЗапросаВТКурсыВалютУпр(Запрос, ТекстыЗапроса);
	КонецЕсли; 
	
	Если Не ПроведениеСерверУТ.ЕстьТаблицаЗапроса("ВТКурсыВалютРегл", ТекстыЗапроса) Тогда
		ТекстЗапросаВТКурсыВалютРегл(Запрос, ТекстыЗапроса);
	КонецЕсли; 
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ТаблицаКассы.Ссылка КАК Ссылка,
	|	ТаблицаКассы.НомерСтроки КАК НомерСтроки,
	|	ТаблицаКассы.ИдентификаторСтроки КАК ИдентификаторСтроки,
	|	ТаблицаКассы.Касса КАК Касса,
	|	ТаблицаКассы.Касса.ВалютаДенежныхСредств КАК Валюта,
	|	ТаблицаКассы.СуммаРасхождения КАК СуммаРасхождения,
	|	ТаблицаКассы.СуммаРасхождения * ЕСТЬNULL(ТаблицаКурсыВалютУпр.КоэффициентПересчета, 0) КАК СуммаРасхожденияУпр,
	|	ТаблицаКассы.СуммаРасхождения * ЕСТЬNULL(ТаблицаКурсыВалютРегл.КоэффициентПересчета, 0) КАК СуммаРасхожденияРегл,
	|	ТаблицаКассы.СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств,
	|	ТаблицаКассы.Касса.Подразделение КАК Подразделение,
	|	ТаблицаКассы.Подразделение КАК ПодразделениеДоходовРасходов,
	|	ТаблицаКассы.Касса.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	ТаблицаКассы.СтатьяДоходовРасходов КАК СтатьяДоходовРасходов,
	|	ТаблицаКассы.АналитикаДоходов КАК АналитикаДоходов,
	|	ТаблицаКассы.АналитикаРасходов КАК АналитикаРасходов
	|ПОМЕСТИТЬ ВТКассы
	|ИЗ
	|	Документ.ИнвентаризацияНаличныхДенежныхСредств.Кассы КАК ТаблицаКассы
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТКурсыВалютУпр КАК ТаблицаКурсыВалютУпр
	|		ПО (ТаблицаКурсыВалютУпр.Валюта = ТаблицаКассы.Касса.ВалютаДенежныхСредств)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТКурсыВалютРегл КАК ТаблицаКурсыВалютРегл
	|		ПО (ТаблицаКурсыВалютРегл.Валюта = ТаблицаКассы.Касса.ВалютаДенежныхСредств)
	|ГДЕ
	|	ТаблицаКассы.Ссылка = &Ссылка
	|	И ТаблицаКассы.СуммаРасхождения <> 0";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаПрочиеДоходы(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ПрочиеДоходы";
	
	Если Не ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли; 
	
	Если Не ПроведениеСерверУТ.ЕстьТаблицаЗапроса("ВТКассы", ТекстыЗапроса) Тогда
		ТекстЗапросаВТКассы(Запрос, ТекстыЗапроса);
	КонецЕсли; 
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)       КАК ВидДвижения,
	|	&Период                                      КАК Период,
	|	
	|	&Организация                                 КАК Организация,
	|	
	|	ВТКассы.ПодразделениеДоходовРасходов         КАК Подразделение,
	|	ВТКассы.НаправлениеДеятельности              КАК НаправлениеДеятельности,
	|	ВТКассы.СтатьяДоходовРасходов                КАК СтатьяДоходов,
	|	ВТКассы.АналитикаДоходов                     КАК АналитикаДоходов,
	|	
	|	ВТКассы.СуммаРасхожденияРегл                 КАК Сумма,
	|	
	|	&ХозяйственнаяОперацияИзлишек                КАК ХозяйственнаяОперация
	|	
	|ИЗ
	|	ВТКассы КАК ВТКассы
	|	
	|ГДЕ
	|	ВТКассы.СуммаРасхождения > 0";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаВтИсходныеПрочиеРасходы(Запрос, ТекстыЗапроса)
	
	ИмяРегистра = "ВтИсходныеПрочиеРасходы";
	
	Если Не ПроведениеСерверУТ.ЕстьТаблицаЗапроса("ВТКассы", ТекстыЗапроса) Тогда
		ТекстЗапросаВТКассы(Запрос, ТекстыЗапроса);
	КонецЕсли; 
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)       КАК ВидДвижения,
	|	&Период                                      КАК Период,
	|	&Организация                                 КАК Организация,
	|	ВТКассы.ПодразделениеДоходовРасходов         КАК Подразделение,
	|	ВТКассы.НаправлениеДеятельности              КАК НаправлениеДеятельности,
	|	ВТКассы.СтатьяДоходовРасходов                КАК СтатьяРасходов,
	|	ВТКассы.АналитикаРасходов                    КАК АналитикаРасходов,
	|	НЕОПРЕДЕЛЕНО                                 КАК ВидДеятельностиНДС,
	|	
	|	-ВТКассы.СуммаРасхожденияРегл                КАК СуммаСНДС,
	|	-ВТКассы.СуммаРасхожденияРегл                КАК СуммаБезНДС,
	|	-ВТКассы.СуммаРасхожденияРегл                КАК СуммаБезНДСУпр,
	|
	|	-ВТКассы.СуммаРасхожденияРегл                КАК СуммаСНДСРегл,
	|	-ВТКассы.СуммаРасхожденияРегл                КАК СуммаБезНДСРегл,
	|	0                                            КАК ПостояннаяРазница,
	|	0                                            КАК ВременнаяРазница,
	|	&ХозяйственнаяОперацияНедостача              КАК ХозяйственнаяОперация,
	|	НЕОПРЕДЕЛЕНО                                 КАК АналитикаУчетаНоменклатуры
	|
	|ПОМЕСТИТЬ ВтИсходныеПрочиеРасходы
	|ИЗ
	|	ВТКассы КАК ВТКассы
	|ГДЕ
	|	ВТКассы.СуммаРасхождения < 0";
	
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
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	Если Не ПроведениеСерверУТ.ЕстьТаблицаЗапроса("ВтПрочиеРасходы", ТекстыЗапроса) Тогда
		ТекстЗапросаТаблицаВтПрочиеРасходы(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	ТекстЗапроса = РегистрыНакопления.ПрочиеРасходы.ТекстЗапросаТаблицаПрочиеРасходы();
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаВтИсходныеПартииПрочихРасходов(Запрос, ТекстыЗапроса)
	
	ИмяРегистра = "ВтИсходныеПартииПрочихРасходов";
	
	Если Не ПроведениеСерверУТ.ЕстьТаблицаЗапроса("ВТКассы", ТекстыЗапроса) Тогда
		ТекстЗапросаВТКассы(Запрос, ТекстыЗапроса);
	КонецЕсли; 
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)                            КАК ВидДвижения,
	|	&Период                                                           КАК Период,
	|	&Организация                                                      КАК Организация,
	|	ВТКассы.ПодразделениеДоходовРасходов                              КАК Подразделение,
	|	&Ссылка                                                           КАК ДокументПоступленияРасходов,
	|	ВТКассы.СтатьяДоходовРасходов                                     КАК СтатьяРасходов,
	|	ВТКассы.АналитикаРасходов                                         КАК АналитикаРасходов,
	|	НЕОПРЕДЕЛЕНО                                                      КАК АналитикаАктивовПассивов,
	|	ЗНАЧЕНИЕ(Справочник.КлючиАналитикиУчетаПартий.ПустаяСсылка)       КАК АналитикаУчетаПартий,
	|	ВТКассы.НаправлениеДеятельности                                   КАК НаправлениеДеятельности,
	|	НЕОПРЕДЕЛЕНО                                                      КАК АналитикаУчетаНоменклатуры,
	|	НЕОПРЕДЕЛЕНО                                                      КАК ВидДеятельностиНДС,
	|	
	|	-ВТКассы.СуммаРасхожденияРегл                                     КАК Стоимость,
	|	-ВТКассы.СуммаРасхожденияРегл                                     КАК СтоимостьБезНДС,
	|	0                                                                 КАК НДСУпр,
	|	-ВТКассы.СуммаРасхожденияРегл                                     КАК СтоимостьРегл,
	|	0                                                                 КАК ПостояннаяРазница,
	|	0                                                                 КАК ВременнаяРазница,
	|	0                                                                 КАК НДСРегл,
	|	&ХозяйственнаяОперацияНедостача                                   КАК ХозяйственнаяОперация
	|
	|ПОМЕСТИТЬ ВтИсходныеПартииПрочихРасходов
	|ИЗ
	|	ВТКассы КАК ВТКассы
	|ГДЕ
	|	ВТКассы.СуммаРасхождения < 0
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаВтПартииПрочихРасходов(Запрос, ТекстыЗапроса)
	
	ИмяРегистра = "ВтПартииПрочихРасходов";
	
	Если Не ПроведениеСерверУТ.ЕстьТаблицаЗапроса("ВтИсходныеПартииПрочихРасходов", ТекстыЗапроса) Тогда
		ТекстЗапросаТаблицаВтИсходныеПартииПрочихРасходов(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	ТекстЗапроса = РегистрыНакопления.ПартииПрочихРасходов.ТекстЗапросаТаблицаВтПартииПрочихРасходов();
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаПартииПрочихРасходов(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ПартииПрочихРасходов";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	Если Не ПроведениеСерверУТ.ЕстьТаблицаЗапроса("ВтПартииПрочихРасходов", ТекстыЗапроса) Тогда
		ТекстЗапросаТаблицаВтПартииПрочихРасходов(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	ТекстЗапроса = РегистрыНакопления.ПартииПрочихРасходов.ТекстЗапросаТаблицаПартииПрочихРасходов();
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаДенежныеСредстваНаличные(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ДенежныеСредстваНаличные";
	
	Если Не ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли; 
	
	Если Не ПроведениеСерверУТ.ЕстьТаблицаЗапроса("ВТКассы", ТекстыЗапроса) Тогда
		ТекстЗапросаВТКассы(Запрос, ТекстыЗапроса);
	КонецЕсли; 
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ВЫБОР КОГДА ВТКассы.СуммаРасхождения > 0 ТОГДА
	|		ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|	ИНАЧЕ
	|		ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	|	КОНЕЦ КАК ВидДвижения,
	|	&Период                                           КАК Период,
	|	
	|	&Организация                                      КАК Организация,
	|	ВТКассы.Касса                                     КАК Касса,
	|	
	|	ВЫБОР КОГДА ВТКассы.СуммаРасхождения > 0 ТОГДА
	|		ВТКассы.СуммаРасхождения
	|	ИНАЧЕ
	|		-ВТКассы.СуммаРасхождения
	|	КОНЕЦ КАК Сумма,
	|	ВЫБОР КОГДА ВТКассы.СуммаРасхождения > 0 ТОГДА
	|		ВТКассы.СуммаРасхожденияУпр
	|	ИНАЧЕ
	|		-ВТКассы.СуммаРасхожденияУпр
	|	КОНЕЦ КАК СуммаУпр,
	|	ВЫБОР КОГДА ВТКассы.СуммаРасхождения > 0 ТОГДА
	|		ВТКассы.СуммаРасхожденияРегл
	|	ИНАЧЕ
	|		-ВТКассы.СуммаРасхожденияРегл
	|	КОНЕЦ КАК СуммаРегл,
	|	
	|	ВЫБОР КОГДА ВТКассы.СуммаРасхождения > 0 ТОГДА
	|		&ХозяйственнаяОперацияИзлишек
	|	ИНАЧЕ
	|		&ХозяйственнаяОперацияНедостача
	|	КОНЕЦ КАК ХозяйственнаяОперация,
	|	ВТКассы.СтатьяДвиженияДенежныхСредств             КАК СтатьяДвиженияДенежныхСредств
	|	
	|ИЗ
	|	ВТКассы КАК ВТКассы";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаДвиженияДенежныеСредстваДоходыРасходы(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ДвиженияДенежныеСредстваДоходыРасходы";
	
	Если Не ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли; 
	
	Если Не ПроведениеСерверУТ.ЕстьТаблицаЗапроса("ВТКассы", ТекстыЗапроса) Тогда
		ТекстЗапросаВТКассы(Запрос, ТекстыЗапроса);
	КонецЕсли; 
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	&Период                                             КАК Период,
	|	ВЫБОР КОГДА ВТКассы.СуммаРасхождения > 0 ТОГДА
	|		&ХозяйственнаяОперацияИзлишек
	|	ИНАЧЕ
	|		&ХозяйственнаяОперацияНедостача
	|	КОНЕЦ КАК ХозяйственнаяОперация,
	|	&Организация КАК Организация,
	|	ВТКассы.Подразделение                               КАК Подразделение,
	|	ВТКассы.НаправлениеДеятельности                     КАК НаправлениеДеятельностиДС,
	|	ВТКассы.ПодразделениеДоходовРасходов                КАК ПодразделениеДоходовРасходов,
	|
	|	ВТКассы.Касса                                       КАК ДенежныеСредства,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыДенежныхСредств.Наличные) КАК ТипДенежныхСредств,
	|	ВТКассы.СтатьяДвиженияДенежныхСредств               КАК СтатьяДвиженияДенежныхСредств,
	|	ВТКассы.Валюта                                      КАК Валюта,
	|
	|	ВТКассы.НаправлениеДеятельности                     КАК НаправлениеДеятельностиСтатьи,
	|	ВТКассы.СтатьяДоходовРасходов                       КАК СтатьяДоходовРасходов,
	|	ВТКассы.АналитикаДоходов                            КАК АналитикаДоходов,
	|	ВТКассы.АналитикаРасходов                           КАК АналитикаРасходов,
	|
	|	ВЫБОР КОГДА ВТКассы.СуммаРасхождения > 0 ТОГДА
	|		ВТКассы.СуммаРасхожденияУпр
	|	ИНАЧЕ
	|		-ВТКассы.СуммаРасхожденияУпр
	|	КОНЕЦ КАК Сумма,
	|	ВЫБОР КОГДА ВТКассы.СуммаРасхождения > 0 ТОГДА
	|		ВТКассы.СуммаРасхожденияРегл
	|	ИНАЧЕ
	|		-ВТКассы.СуммаРасхожденияРегл
	|	КОНЕЦ КАК СуммаРегл,
	|	ВЫБОР КОГДА ВТКассы.СуммаРасхождения > 0 ТОГДА
	|		ВТКассы.СуммаРасхождения
	|	ИНАЧЕ
	|		-ВТКассы.СуммаРасхождения
	|	КОНЕЦ КАК СуммаВВалюте,
	|
	|	ВТКассы.Касса                                       КАК ИсточникГФУДенежныхСредств,
	|	ВТКассы.СтатьяДоходовРасходов                       КАК ИсточникГФУДоходовРасходов
	|	
	|ИЗ
	|	ВТКассы КАК ВТКассы";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;

КонецФункции

Функция ТекстЗапросаТаблицаПрочиеАктивыПассивы(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ПрочиеАктивыПассивы";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	Если Не ПроведениеСерверУТ.ЕстьТаблицаЗапроса("ВтПрочиеРасходы", ТекстыЗапроса) Тогда
		ТекстЗапросаТаблицаВтПрочиеРасходы(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	Если Не ПроведениеСерверУТ.ЕстьТаблицаЗапроса("ВтПартииПрочихРасходов", ТекстыЗапроса) Тогда
		ТекстЗапросаТаблицаВтПартииПрочихРасходов(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	ТекстЗапроса = РегистрыНакопления.ПрочиеАктивыПассивы.ТекстЗапросаТаблицаПрочиеАктивыПассивы();
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции



#КонецОбласти

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	Если ПравоДоступа("Изменение", Метаданные.Документы.ИнвентаризацияНаличныхДенежныхСредств) Тогда
		
		// Акт инвентаризации
		КомандаПечати = КомандыПечати.Добавить();
		КомандаПечати.Идентификатор = "ИНВ15";
		КомандаПечати.Представление = НСтр("ru = 'ИНВ-15'");
		КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ИНВ15") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"ИНВ15",
			"ИНВ-15",
			СформироватьПечатнуюАктаИнвентаризацииНаличныхДенежныхСредств(МассивОбъектов, ОбъектыПечати));
		
	КонецЕсли;
	
КонецПроцедуры

Функция СформироватьПечатнуюАктаИнвентаризацииНаличныхДенежныхСредств(МассивОбъектов, ОбъектыПечати)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ИНВ15";
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ИнвентаризацияНаличныхДенежныхСредств.ПФ_MXL_ИНВ15");
	
	ВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	ОтветственныеЛицаСервер.СформироватьВременнуюТаблицуОтветственныхЛицДокументов(МассивОбъектов, МенеджерВременныхТаблиц);
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка КАК Ссылка,
	|	ДанныеДокумента.Номер КАК Номер,
	|	ДанныеДокумента.Организация.Префикс КАК Префикс,
	|	ДанныеДокумента.Дата КАК ДатаДокумента,
	|	ДанныеДокумента.Организация КАК Организация,
	|	ДанныеДокумента.Организация.НаименованиеСокращенное КАК ПредставлениеОрганизации,
	|	ДанныеДокумента.Организация.КодПоОКПО КАК ОрганизацияКодПоОКПО,
	|	ДанныеДокумента.Организация.КодОКВЭД КАК ОрганизацияКодПоОКВЭД,
	|	ДанныеДокумента.ПоследнийНомерПКО КАК НомерПКО,
	|	ДанныеДокумента.ПоследнийНомерРКО КАК НомерРКО,
	|	ДанныеДокумента.КассоваяКнига.СтруктурноеПодразделение КАК Подразделение,
	|	ТаблицаОтветственныеЛица.КассирНаименование КАК ФИОКассира,
	|	ТаблицаОтветственныеЛица.КассирДолжность КАК КассирДолжность,
	|	ТаблицаОтветственныеЛица.РуководительНаименование КАК ФИОРуководителя,
	|	ТаблицаОтветственныеЛица.РуководительДолжность КАК РуководительДолжность
	|ИЗ
	|	Документ.ИнвентаризацияНаличныхДенежныхСредств КАК ДанныеДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаОтветственныеЛица КАК ТаблицаОтветственныеЛица
	|		ПО ДанныеДокумента.Ссылка = ТаблицаОтветственныеЛица.Ссылка
	|ГДЕ
	|	ДанныеДокумента.Ссылка В(&МассивДокументов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаДокумента,
	|	Номер
	|;
	|///////////////////////////////////////////////////////////
	|
	|ВЫБРАТЬ
	|	ТаблицаДокумента.Ссылка КАК Ссылка,
	|	ТаблицаДокумента.Касса.ВалютаДенежныхСредств КАК Валюта,
	|	СУММА(ТаблицаДокумента.СуммаПоФакту) КАК СуммаПоФакту
	|	
	|ИЗ
	|	Документ.ИнвентаризацияНаличныхДенежныхСредств.Кассы КАК ТаблицаДокумента
	|	
	|ГДЕ
	|	ТаблицаДокумента.Ссылка В(&МассивДокументов)
	|	
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаДокумента.Ссылка,
	|	ТаблицаДокумента.Касса.ВалютаДенежныхСредств
	|;
	|///////////////////////////////////////////////////////////
	|
	|ВЫБРАТЬ
	|	ТаблицаДокумента.Ссылка                       КАК Ссылка,
	|	ТаблицаДокумента.Ссылка.СуммаПоФактуВсего     КАК СуммаПоФактуРегл,
	|	ТаблицаДокумента.Ссылка.СуммаПоУчетуВсего     КАК СуммаПоУчетуРегл,
	|	ЕСТЬNULL(ДенежныеСредства.СуммаРеглПриход, 0) КАК СуммаИзлишекРегл,
	|	ЕСТЬNULL(ДенежныеСредства.СуммаРеглРасход, 0) КАК СуммаНедостачаРегл
	|	
	|ИЗ
	|	Документ.ИнвентаризацияНаличныхДенежныхСредств.Кассы КАК ТаблицаДокумента
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрНакопления.ДенежныеСредстваНаличные.Обороты(,, Регистратор) КАК ДенежныеСредства
	|	ПО
	|		ДенежныеСредства.Регистратор = ТаблицаДокумента.Ссылка
	|	
	|ГДЕ
	|	ТаблицаДокумента.Ссылка В(&МассивДокументов)
	|;";
	
	Запрос.УстановитьПараметр("МассивДокументов", МассивОбъектов);
	Запрос.УстановитьПараметр("ВалютаРегламентированногоУчета", ВалютаРегламентированногоУчета);
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	ВыборкаДокументов = МассивРезультатов[0].Выбрать();
	ВыборкаРасхождений = МассивРезультатов[1].Выбрать();
	ВыборкаИтогов = МассивРезультатов[2].Выбрать();
	
	ПервыйДокумент = Истина;
	Пока ВыборкаДокументов.Следующий() Цикл
		
		Если ПервыйДокумент Тогда
			ПервыйДокумент = Ложь;
		Иначе
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
		ОбластьМакета.Параметры.Заполнить(ВыборкаДокументов);
		ОбластьМакета.Параметры.НомерДокумента = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ВыборкаДокументов.Номер);
		ОбластьМакета.Параметры.ДатаДокумента = Формат(ВыборкаДокументов.ДатаДокумента, "ДЛФ=D");
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		СтруктураПоиска = Новый Структура("Ссылка", ВыборкаДокументов.Ссылка);
		НомерПоПорядку = 1;
		Пока ВыборкаРасхождений.НайтиСледующий(СтруктураПоиска) Цикл
			ОбластьМакета = Макет.ПолучитьОбласть("СтрокаНаличныхДенег");
			ОбластьМакета.Параметры.Заполнить(ВыборкаРасхождений);
			ОбластьМакета.Параметры.НомерПоПорядку = НомерПоПорядку;
			ОбластьМакета.Параметры.НаименованиеЦенности = НСтр("ru = 'наличных денег'");
			ТабличныйДокумент.Вывести(ОбластьМакета);
			НомерПоПорядку = НомерПоПорядку + 1;
		КонецЦикла;
		Для Инд = НомерПоПорядку По 5 Цикл
			ОбластьМакета = Макет.ПолучитьОбласть("СтрокаНаличныхДенег");
			ОбластьМакета.Параметры.НомерПоПорядку = Инд;
			ТабличныйДокумент.Вывести(ОбластьМакета);
		КонецЦикла;
		
		ВыборкаРасхождений.Сбросить();
		
		ОбластьМакета = Макет.ПолучитьОбласть("Итоги");
		Если ВыборкаИтогов.НайтиСледующий(СтруктураПоиска) Тогда
		
			ОбластьМакета.Параметры.СуммаПоФактуРубли = Формат(Цел(ВыборкаИтогов.СуммаПоФактуРегл), "ЧЦ=15; ЧДЦ=0; ЧН='0'");
			КопеекПоФакту = (ВыборкаИтогов.СуммаПоФактуРегл - Цел(ВыборкаИтогов.СуммаПоФактуРегл)) * 100;
			ОбластьМакета.Параметры.СуммаПоФактуКопейки = Формат(КопеекПоФакту, "ЧЦ=2; ЧДЦ=0; ЧН='00'");
			
			ОбластьМакета.Параметры.СуммаПоУчетуРубли = Формат(Цел(ВыборкаИтогов.СуммаПоУчетуРегл), "ЧЦ=15; ЧДЦ=0; ЧН='0'");
			КопеекПоУчету = (ВыборкаИтогов.СуммаПоУчетуРегл - Цел(ВыборкаИтогов.СуммаПоУчетуРегл)) * 100;
			ОбластьМакета.Параметры.СуммаПоУчетуКопейки = Формат(КопеекПоУчету, "ЧЦ=2; ЧДЦ=0; ЧН='00'");
			
			ОбластьМакета.Параметры.СуммаИзлишекРубли = Формат(Цел(ВыборкаИтогов.СуммаИзлишекРегл), "ЧЦ=15; ЧДЦ=0; ЧН='0'");
			КопеекИзлишек = (ВыборкаИтогов.СуммаИзлишекРегл - Цел(ВыборкаИтогов.СуммаИзлишекРегл)) * 100;
			ОбластьМакета.Параметры.СуммаИзлишекКопейки = Формат(КопеекИзлишек, "ЧЦ=2; ЧДЦ=0; ЧН='00'");
			
			ОбластьМакета.Параметры.СуммаНедостачаРубли = Формат(Цел(ВыборкаИтогов.СуммаНедостачаРегл), "ЧЦ=15; ЧДЦ=0; ЧН='0'");
			КопеекНедостача = (ВыборкаИтогов.СуммаНедостачаРегл - Цел(ВыборкаИтогов.СуммаНедостачаРегл)) * 100;
			ОбластьМакета.Параметры.СуммаНедостачаКопейки = Формат(КопеекНедостача, "ЧЦ=2; ЧДЦ=0; ЧН='00'");
			
			ОбластьМакета.Параметры.СуммаПоФактуРеглПрописью = РаботаСКурсамиВалют.СформироватьСуммуПрописью(
				ВыборкаИтогов.СуммаПоФактуРегл,
				ВалютаРегламентированногоУчета,
				Ложь);
			ОбластьМакета.Параметры.СуммаПоУчетуРеглПрописью = РаботаСКурсамиВалют.СформироватьСуммуПрописью(
				ВыборкаИтогов.СуммаПоУчетуРегл,
				ВалютаРегламентированногоУчета,
				Ложь);
		КонецЕсли;
		
		ТабличныйДокумент.Вывести(ОбластьМакета);
		ВыборкаИтогов.Сбросить();
		
		ОбластьМакета = Макет.ПолучитьОбласть("Подвал");
		ОбластьМакета.Параметры.Заполнить(ВыборкаДокументов);
		ОбластьМакета.Параметры.НомерПКО = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ВыборкаДокументов.НомерПКО);
		ОбластьМакета.Параметры.НомерРКО = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ВыборкаДокументов.НомерРКО);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		
		ОбластьМакета = Макет.ПолучитьОбласть("Страница2");
		ОбластьМакета.Параметры.Заполнить(ВыборкаДокументов);
		ТабличныйДокумент.Вывести(ОбластьМакета);
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
