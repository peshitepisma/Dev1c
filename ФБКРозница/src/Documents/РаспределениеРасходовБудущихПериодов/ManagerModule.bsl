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

// Добавляет команду создания документа "Распределение РБП".
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	Если ПравоДоступа("Добавление", Метаданные.Документы.РаспределениеРасходовБудущихПериодов) Тогда
		КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Менеджер = Метаданные.Документы.РаспределениеРасходовБудущихПериодов.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ОбщегоНазначенияУТ.ПредставлениеОбъекта(Метаданные.Документы.РаспределениеРасходовБудущихПериодов);
		КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
		КомандаСоздатьНаОсновании.ФункциональныеОпции = "ИспользоватьУчетПрочихДоходовРасходов";
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


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

#КонецОбласти

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
	ТекстЗапросаТаблицаПрочиеРасходы(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаТаблицаПартииПрочихРасходов(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаТаблицаПрочиеАктивыПассивы(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаДвиженияДоходыРасходыПрочиеАктивыПассивы(Запрос, ТекстыЗапроса, Регистры);
	
	////////////////////////////////////////////////////////////////////////////
	// Поместим результаты запроса в дополнительные свойства
	
	ПроведениеСерверУТ.ИнициализироватьТаблицыДляДвижений(Запрос, ТекстыЗапроса, ДополнительныеСвойства.ТаблицыДляДвижений, Истина);
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ДанныеДокумента.Дата КАК Период,
	|	ДанныеДокумента.Ссылка КАК Ссылка,
	|	ДанныеДокумента.Организация КАК Организация
	|ИЗ
	|	Документ.РаспределениеРасходовБудущихПериодов КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|";
	Реквизиты = Запрос.Выполнить().Выбрать();
	Реквизиты.Следующий();

	Запрос.УстановитьПараметр("Валюта", Константы.ВалютаУправленческогоУчета.Получить());
	УниверсальныеМеханизмыПартийИСебестоимости.ЗаполнитьПараметрыИнициализации(Запрос, Реквизиты);

КонецПроцедуры

Функция ТекстЗапросаТаблицаВтИсходныеПрочиеРасходы(Запрос, ТекстыЗапроса)
	
	ИмяРегистра = "ВтИсходныеПрочиеРасходы";
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	Строки.Дата                             КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)  КАК ВидДвижения,
	|	ДанныеДокумента.Организация             КАК Организация,
	|	ДанныеДокумента.Подразделение           КАК Подразделение,
	|	ДанныеДокумента.СтатьяРасходов          КАК СтатьяРасходов,
	|	ДанныеДокумента.АналитикаРасходов       КАК АналитикаРасходов,
	|	ДанныеДокумента.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	НЕОПРЕДЕЛЕНО                            КАК ВидДеятельностиНДС,
	|	СУММА(Строки.Сумма)                            КАК СуммаСНДС,
	|	СУММА(Строки.СуммаУпр)                         КАК СуммаБезНДС,
	|	СУММА(Строки.СуммаУпр)                         КАК СуммаБезНДСУпр,
	|	СУММА(Строки.СуммаРегл)                        КАК СуммаСНДСРегл,
	|	СУММА(Строки.СуммаРегл)                        КАК СуммаБезНДСРегл,
	|	СУММА(Строки.ПостояннаяРазница)                КАК ПостояннаяРазница,
	|	СУММА(Строки.ВременнаяРазница)                 КАК ВременнаяРазница,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РаспределениеРБП) КАК ХозяйственнаяОперация,
	|	НЕОПРЕДЕЛЕНО КАК АналитикаУчетаНоменклатуры
	|
	|ПОМЕСТИТЬ ВтИсходныеПрочиеРасходы
	|ИЗ
	|	Документ.РаспределениеРасходовБудущихПериодов КАК ДанныеДокумента
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.РаспределениеРасходовБудущихПериодов.РаспределениеРасходов КАК Строки
	|		ПО ДанныеДокумента.Ссылка = Строки.Ссылка
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|	И (Строки.Сумма <> 0 ИЛИ Строки.СуммаУпр <> 0
	|		ИЛИ Строки.СуммаРегл <> 0
	|		ИЛИ Строки.ПостояннаяРазница <> 0
	|		ИЛИ Строки.ВременнаяРазница <> 0)
	|
	|СГРУППИРОВАТЬ ПО
	|	Строки.Дата,
	|	ДанныеДокумента.Организация,
	|	ДанныеДокумента.Подразделение,
	|	ДанныеДокумента.СтатьяРасходов,
	|	ДанныеДокумента.АналитикаРасходов,
	|	ДанныеДокумента.НаправлениеДеятельности
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Строки.Дата								КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)	КАК ВидДвижения,
	|	ДанныеДокумента.Организация				КАК Организация,
	|	Строки.Подразделение                    КАК Подразделение,
	|	Строки.СтатьяРасходов					КАК СтатьяРасходов,
	|	Строки.АналитикаРасходов				КАК АналитикаРасходов,
	|	ДанныеДокумента.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	НЕОПРЕДЕЛЕНО                            КАК ВидДеятельностиНДС,
	|	СУММА(Строки.Сумма)                     КАК СуммаСНДС,
	|	СУММА(Строки.СуммаУпр)                  КАК СуммаБезНДС,
	|	СУММА(Строки.СуммаУпр)                  КАК СуммаБезНДСУпр,
	|	СУММА(Строки.СуммаРегл)                 КАК СуммаСНДСРегл,
	|	СУММА(Строки.СуммаРегл)                 КАК СуммаБезНДСРегл,
	|	СУММА(Строки.ПостояннаяРазница)         КАК ПостояннаяРазница,
	|	СУММА(Строки.ВременнаяРазница)          КАК ВременнаяРазница,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РаспределениеРБП) КАК ХозяйственнаяОперация,
	|	НЕОПРЕДЕЛЕНО КАК АналитикаУчетаНоменклатуры
	|ИЗ
	|	Документ.РаспределениеРасходовБудущихПериодов.РаспределениеРасходов КАК Строки
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.РаспределениеРасходовБудущихПериодов КАК ДанныеДокумента
	|		ПО ДанныеДокумента.Ссылка = Строки.Ссылка
	|ГДЕ
	|	Строки.Ссылка = &Ссылка
	|	И (Строки.Сумма <> 0 ИЛИ Строки.СуммаУпр <> 0
	|		ИЛИ Строки.СуммаРегл <> 0
	|		ИЛИ Строки.ПостояннаяРазница <> 0
	|		ИЛИ Строки.ВременнаяРазница <> 0)
	|
	|СГРУППИРОВАТЬ ПО
	|	Строки.Дата,
	|	ДанныеДокумента.Организация,
	|	Строки.Подразделение,
	|	Строки.СтатьяРасходов,
	|	Строки.АналитикаРасходов,
	|	ДанныеДокумента.НаправлениеДеятельности
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
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	Строки.Дата                             КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)  КАК ВидДвижения,
	|	Строки.Ссылка.Организация               КАК Организация,
	|	ВЫБОР
	|		КОГДА Строки.Подразделение <> ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка)
	|			ТОГДА Строки.Подразделение
	|		ИНАЧЕ Строки.Ссылка.Подразделение
	|	КОНЕЦ                                   КАК Подразделение,
	|	&Ссылка                                 КАК ДокументПоступленияРасходов,
	|	Строки.СтатьяРасходов                   КАК СтатьяРасходов,
	|	Строки.АналитикаРасходов                КАК АналитикаРасходов,
	|	НЕОПРЕДЕЛЕНО                            КАК АналитикаАктивовПассивов,
	|	НЕОПРЕДЕЛЕНО                            КАК АналитикаУчетаПартий,
	|	ДанныеДокумента.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	НЕОПРЕДЕЛЕНО                            КАК АналитикаУчетаНоменклатуры,
	|	НЕОПРЕДЕЛЕНО                            КАК ВидДеятельностиНДС,
	|	
	|	Строки.Сумма                            КАК Стоимость,
	|	Строки.СуммаУпр                         КАК СтоимостьБезНДС,
	|	0                                       КАК НДСУпр,
	|	Строки.СуммаРегл                        КАК СтоимостьРегл,
	|	Строки.ПостояннаяРазница                КАК ПостояннаяРазница,
	|	Строки.ВременнаяРазница                 КАК ВременнаяРазница,
	|	0                                       КАК НДСРегл,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РаспределениеРБП) КАК ХозяйственнаяОперация
	|
	|ПОМЕСТИТЬ ВтИсходныеПартииПрочихРасходов
	|ИЗ
	|	Документ.РаспределениеРасходовБудущихПериодов.РаспределениеРасходов КАК Строки
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.РаспределениеРасходовБудущихПериодов КАК ДанныеДокумента
	|		ПО ДанныеДокумента.Ссылка = Строки.Ссылка
	|ГДЕ
	|	Строки.Ссылка = &Ссылка
	|	И (Строки.Сумма <> 0 ИЛИ Строки.СуммаУпр <> 0
	|		ИЛИ Строки.СуммаРегл <> 0
	|		ИЛИ Строки.ПостояннаяРазница <> 0
	|		ИЛИ Строки.ВременнаяРазница <> 0)
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

Функция ТекстЗапросаДвиженияДоходыРасходыПрочиеАктивыПассивы(Запрос, ТекстыЗапроса, Регистры)

	ИмяРегистра = "ДвиженияДоходыРасходыПрочиеАктивыПассивы";
	
	Если Не ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли; 
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	Строки.НомерСтроки,
	|	Строки.Дата КАК Период,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РаспределениеРБП) КАК ХозяйственнаяОперация,
	|	ДанныеДокумента.Организация КАК Организация,
	|	ДанныеДокумента.Подразделение КАК Подразделение,
	|	ДанныеДокумента.СтатьяРасходов КАК Статья,
	|	ДанныеДокумента.АналитикаРасходов КАК АналитикаРасходов,
	|
	|	Строки.Подразделение КАК КорПодразделение,
	|	Строки.СтатьяРасходов КАК КорСтатья,
	|	Строки.АналитикаРасходов КАК КорАналитикаРасходов,
	|
	|	ДанныеДокумента.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	ДанныеДокумента.НаправлениеДеятельности КАК КорНаправлениеДеятельности,
	|
	|	Строки.Сумма КАК Сумма,
	|	ВЫБОР
	|		КОГДА ДанныеДокумента.СтатьяРасходов.ВариантРаспределенияРасходовУпр = ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаСебестоимостьТоваров)
	|		 ИЛИ НЕ &УправленческийУчетОрганизаций
	|			ТОГДА 0
	|		ИНАЧЕ
	|			Строки.СуммаУпр
	|	КОНЕЦ КАК СуммаУпр,
	|	Строки.СуммаРегл КАК СуммаРегл,
	|
	|	&Валюта КАК Валюта,
	|	Строки.Сумма КАК СуммаВВалюте
	|
	|ИЗ
	|	Документ.РаспределениеРасходовБудущихПериодов КАК ДанныеДокумента
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.РаспределениеРасходовБудущихПериодов.РаспределениеРасходов КАК Строки
	|		ПО Строки.Ссылка = ДанныеДокумента.Ссылка
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|	И (Строки.Сумма <> 0 ИЛИ Строки.СуммаУпр <> 0 ИЛИ Строки.СуммаРегл <> 0)
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки
	|";
	
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

#Область ОбновлениеИнформационнойБазы

Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Операция.Ссылка
	|ИЗ
	|	Документ.РаспределениеРасходовБудущихПериодов КАК Операция
	|ГДЕ
	|	(Операция.ПравилоРаспределения = ЗНАЧЕНИЕ(Перечисление.ПравилаРаспределенияРБП.ПустаяСсылка)
	|		ИЛИ Операция.ВариантУказанияСуммыУпр = ЗНАЧЕНИЕ(Перечисление.ВариантыУказанияСуммыРБП.ПустаяСсылка)
	|		ИЛИ Операция.ВариантУказанияСуммыРегл = ЗНАЧЕНИЕ(Перечисление.ВариантыУказанияСуммыРБП.ПустаяСсылка))
	|	И Операция.Проведен
	|	И НЕ Операция.ПометкаУдаления
	|");
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяОбъекта = "Документ.РаспределениеРасходовБудущихПериодов";
	МетаданныеОбъекта = Метаданные.Документы.РаспределениеРасходовБудущихПериодов;
	
	МВТ = Новый МенеджерВременныхТаблиц;
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Результат = ОбновлениеИнформационнойБазы.СоздатьВременнуюТаблицуСсылокДляОбработки(Параметры.Очередь, ПолноеИмяОбъекта, МенеджерВременныхТаблиц);
	
	Если Не Результат.ЕстьДанныеДляОбработки Тогда
		Параметры.ОбработкаЗавершена = Истина;
		Возврат;
	КонецЕсли;
	
	Если Не Результат.ЕстьЗаписиВоВременнойТаблице Тогда
		Возврат;
	КонецЕсли;
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ОбъектыДляОбработки.Ссылка КАК Ссылка,
	|	ОбъектыДляОбработки.Ссылка.ВерсияДанных КАК ВерсияДанных
	|ИЗ
	|	ВТОбъектыДляОбработки КАК ОбъектыДляОбработки
	|";
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ВТОбъектыДляОбработки", Результат.ИмяВременнойТаблицы);
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НачатьТранзакцию();
		Попытка
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяОбъекта);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.Ссылка);
			Блокировка.Заблокировать();
			
			ДокументОбъект = Выборка.Ссылка.ПолучитьОбъект();
			Если Не ЗначениеЗаполнено(ДокументОбъект.ПравилоРаспределения) Тогда
				ДокументОбъект.ПравилоРаспределения = Перечисления.ПравилаРаспределенияРБП.ПоМесяцам;
			КонецЕсли;
			Если Не ЗначениеЗаполнено(ДокументОбъект.ВариантУказанияСуммыУпр) Тогда
				ДокументОбъект.ВариантУказанияСуммыУпр = Перечисления.ВариантыУказанияСуммыРБП.УказываетсяВручную;
			КонецЕсли;
			Если Не ЗначениеЗаполнено(ДокументОбъект.ВариантУказанияСуммыРегл) Тогда
				ДокументОбъект.ВариантУказанияСуммыРегл = Перечисления.ВариантыУказанияСуммыРБП.УказываетсяВручную;
			КонецЕсли;
			
			Если ДокументОбъект.Модифицированность() Тогда
				ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ДокументОбъект, Ложь, Ложь, РежимЗаписиДокумента.Запись);
			Иначе
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Выборка.Ссылка);
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();

		Исключение
			ОтменитьТранзакцию();
			ТекстСообщения = НСтр("ru = 'Не удалось обработать документ: %1 по причине: %2'");
			ТекстСообщения = СтрШаблон(ТекстСообщения, Выборка.Ссылка, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(
				ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Предупреждение,
				МетаданныеОбъекта,
				Выборка.Ссылка,
				ТекстСообщения);
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = Не ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Параметры.Очередь, ПолноеИмяОбъекта);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
