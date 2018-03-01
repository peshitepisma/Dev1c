
#Область ПрограммныйИнтерфейс

// Возвращает таблицу учетных остатков алкогольной продукции.
//
// Параметры:
//  ДатаОстатков - Дата - дата получения остатков,
//  Организация - ОпределяемыйТип.ОрганизацияКонтрагентЕГАИС - ссылка на собственную организацию,
//  ТорговыйОбъект - ОпределяемыйТип.ТорговыйОбъектЕГАИС - торговый объект для получения остатков,
//  КорректироватьОстаткиНемаркируемойПродукции - Булево - признак корректировки остатков немаркируемой продукции.
//
// Возвращаемое значение:
//   ТаблицаЗначений - учетные остатки. Колонки таблицы:
//    * Номенклатура - ОпределяемыйТип.Номенклатура
//    * Характеристика - ОпределяемыйТип.ХарактеристикаНоменклатуры
//    * ПродаетсяВРозлив - Булево
//    * ОбъемДАЛ - Число
//    * ТипПродукции - ПеречислениеСсылка.ТипыПродукцииЕГАИС
//    * ОстатокСкладБазЕд - Число - остаток в базовых единицах измерения (для оптового склада)
//    * ОстатокТорговыйЗалБазЕд - Число - остаток в базовых единицах измерения (для розничного магазина)
//    * ОстатокСклад - Число - остаток в штуках для фасованной и в ДАЛах для нефасованной продукциии (для оптового склада)
//    * ОстатокТорговыйЗал - Число - остаток в штуках для фасованной и в ДАЛах для нефасованной продукциии (для розничного магазина)
//
Функция УчетныеОстатки(ДатаОстатков, Организация, ТорговыйОбъект, КорректироватьОстаткиНемаркируемойПродукции) Экспорт
	
	//++ НЕ ЕГАИС
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТорговыйОбъект", ТорговыйОбъект);
	Запрос.УстановитьПараметр("ДатаОстатков", ДатаОстатков);
	Запрос.УстановитьПараметр("КорректироватьОстаткиНемаркируемойПродукции", КорректироватьОстаткиНемаркируемойПродукции);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТоварыНаСкладахОстатки.Номенклатура КАК Номенклатура,
	|	ТоварыНаСкладахОстатки.Характеристика КАК Характеристика,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(СоответствиеНоменклатурыЕГАИС.АлкогольнаяПродукция.ТипПродукции, ЗНАЧЕНИЕ(Перечисление.ТипыПродукцииЕГАИС.ПустаяСсылка)) = ЗНАЧЕНИЕ(Перечисление.ТипыПродукцииЕГАИС.Неупакованная)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ПродаетсяВРозлив,
	|	ЕСТЬNULL(СоответствиеНоменклатурыЕГАИС.АлкогольнаяПродукция.ТипПродукции, ЗНАЧЕНИЕ(Перечисление.ТипыПродукцииЕГАИС.ПустаяСсылка)) КАК ТипПродукции,
	|	ВЫБОР
	|		КОГДА ТоварыНаСкладахОстатки.Склад.ТипСклада = ЗНАЧЕНИЕ(Перечисление.ТипыСкладов.ОптовыйСклад)
	|			ТОГДА ТоварыНаСкладахОстатки.ВНаличииОстаток
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК ОстатокСкладБазЕд,
	|	ВЫБОР
	|		КОГДА ТоварыНаСкладахОстатки.Склад.ТипСклада = ЗНАЧЕНИЕ(Перечисление.ТипыСкладов.ОптовыйСклад)
	|			ТОГДА 0
	|		ИНАЧЕ ТоварыНаСкладахОстатки.ВНаличииОстаток
	|	КОНЕЦ КАК ОстатокТорговыйЗалБазЕд
	|ПОМЕСТИТЬ УчетныеОстатки
	|ИЗ
	|	РегистрНакопления.ТоварыНаСкладах.Остатки(
	|			&ДатаОстатков,
	|			Склад = &ТорговыйОбъект
	|				И Номенклатура.АлкогольнаяПродукция
	|				И НЕ Номенклатура.АлкогольнаяПродукцияВоВскрытойТаре
	|				И ВЫБОР
	|					КОГДА НЕ ЕСТЬNULL(Номенклатура.ВидАлкогольнойПродукции.Маркируемый, ЛОЖЬ)
	|						ТОГДА &КорректироватьОстаткиНемаркируемойПродукции
	|					ИНАЧЕ ИСТИНА
	|				КОНЕЦ) КАК ТоварыНаСкладахОстатки
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СоответствиеНоменклатурыЕГАИС КАК СоответствиеНоменклатурыЕГАИС
	|		ПО ТоварыНаСкладахОстатки.Номенклатура = СоответствиеНоменклатурыЕГАИС.Номенклатура
	|			И ТоварыНаСкладахОстатки.Характеристика = СоответствиеНоменклатурыЕГАИС.Характеристика
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	УчетныеОстатки.Номенклатура КАК Номенклатура,
	|	УчетныеОстатки.Характеристика КАК Характеристика,
	|	УчетныеОстатки.ПродаетсяВРозлив КАК ПродаетсяВРозлив,
	|	УчетныеОстатки.Номенклатура.ОбъемДАЛ КАК ОбъемДАЛ,
	|	УчетныеОстатки.ТипПродукции КАК ТипПродукции,
	|	УчетныеОстатки.ОстатокСкладБазЕд КАК ОстатокСкладБазЕд,
	|	УчетныеОстатки.ОстатокСкладБазЕд * ВЫБОР
	|		КОГДА УчетныеОстатки.ПродаетсяВРозлив
	|			ТОГДА УчетныеОстатки.Номенклатура.ОбъемДАЛ
	|		ИНАЧЕ 1
	|	КОНЕЦ КАК ОстатокСклад,
	|	УчетныеОстатки.ОстатокТорговыйЗалБазЕд КАК ОстатокТорговыйЗалБазЕд,
	|	УчетныеОстатки.ОстатокТорговыйЗалБазЕд * ВЫБОР
	|		КОГДА УчетныеОстатки.ПродаетсяВРозлив
	|			ТОГДА УчетныеОстатки.Номенклатура.ОбъемДАЛ
	|		ИНАЧЕ 1
	|	КОНЕЦ КАК ОстатокТорговыйЗал
	|ИЗ
	|	УчетныеОстатки КАК УчетныеОстатки
	|
	|УПОРЯДОЧИТЬ ПО
	|	Номенклатура
	|АВТОУПОРЯДОЧИВАНИЕ";
	
	Возврат Запрос.Выполнить().Выгрузить();
	//-- НЕ ЕГАИС
	
	Возврат Неопределено;
	
КонецФункции

// Заполняет в табличной части коэффициент пересчета в декалитры для базовой единицы измерения номенклатуры.
//
// Параметры:
//  ТабличнаяЧасть - ТабличнаяЧасть - табличная часть, в которой нужно обновить коэффициент.
//
Процедура ЗаполнитьКоэффициентПересчетаВДАЛ(ТабличнаяЧасть) Экспорт
	
	//++ НЕ ЕГАИС
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТабличнаяЧасть", ТабличнаяЧасть);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВЫРАЗИТЬ(ТабличнаяЧасть.Номенклатура КАК Справочник.Номенклатура) КАК Номенклатура,
	|	ТабличнаяЧасть.ОбъемДАЛ КАК КоэффициентПересчета,
	|	ТабличнаяЧасть.НомерСтроки КАК НомерСтроки
	|ПОМЕСТИТЬ ИсходнаяТаблица
	|ИЗ
	|	&ТабличнаяЧасть КАК ТабличнаяЧасть
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ИсходнаяТаблица.Номенклатура,
	|	ИсходнаяТаблица.Номенклатура.ОбъемДАЛ КАК КоэффициентПересчета,
	|	ИсходнаяТаблица.НомерСтроки
	|ИЗ
	|	ИсходнаяТаблица КАК ИсходнаяТаблица
	|ГДЕ
	|	ИсходнаяТаблица.Номенклатура.ОбъемДАЛ <> ИсходнаяТаблица.КоэффициентПересчета";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ТабличнаяЧасть[Выборка.НомерСтроки - 1].ОбъемДАЛ = Выборка.КоэффициентПересчета;
	КонецЦикла;
	//-- НЕ ЕГАИС
	
	Возврат;
	
КонецПроцедуры

// В процедуре необходимо определить значения переменных ЭтоСклад и ЭтоТорговыйЗал в зависимости от типа торгового объекта.
//
// Параметры:
//  ТорговыйОбъект - ОпределяемыйТип.ТорговыйОбъектЕГАИС - ссылка на собственный торговый объект,
//  ЭтоСклад - Булево - признак того, что торговый объект является складским помещением. Выходной параметр,
//  ЭтоТорговыйЗал - Булево - признак того, что торговый объект является торговым залом. Выходной параметр.
//
Процедура ПриОпределенииТипаТорговогоОбъекта(ТорговыйОбъект, ЭтоСклад, ЭтоТорговыйЗал) Экспорт
	
	//++ НЕ ЕГАИС
	ТипСклада = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ТорговыйОбъект, "ТипСклада");
	
	ЭтоСклад = ТипСклада = Перечисления.ТипыСкладов.ОптовыйСклад;
	ЭтоТорговыйЗал = ТипСклада = Перечисления.ТипыСкладов.РозничныйМагазин;
	//-- НЕ ЕГАИС
	
	Возврат;
	
КонецПроцедуры

// Проверяет наличие документа инвентаризации по складу.
//
// Параметры:
//  Организация - ОпределяемыйТип.ОрганизацияКонтрагентЕГАИС - ссылка на собственную организацию,
//  ТорговыйОбъект - ОпределяемыйТип.ТорговыйОбъектЕГАИС - ссылка на собственный торговый объект,
//  ТекстОшибкиСклад - Строка, ФорматированнаяСтрока - текст ошибки проверки инвентаризации на складе. Выходной параметр,
//  ТекстОшибкиТорговыйЗал - Строка, ФорматированнаяСтрока - текст ошибки проверки инвентаризации в торговом зале. Выходной параметр,
//  ОтчетПоРасхождениямСклад - Булево - если Истина, будет доступна ссылка на формирование отчета по излишкам/недостачам. Выходной параметр,
//  ОтчетПоРасхождениямТорговыйЗал - Булево - если Истина, будет доступна ссылка на формирование отчета по излишкам/недостачам. Выходной параметр.
//
Процедура ПроверитьНаличиеИнвентаризации(Организация, ТорговыйОбъект, ТекстОшибкиСклад, ТекстОшибкиТорговыйЗал, ОтчетПоРасхождениямСклад, ОтчетПоРасхождениямТорговыйЗал) Экспорт
	
	//++ НЕ ЕГАИС
	ТипСклада = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ТорговыйОбъект, "ТипСклада");
	
	Если СкладыСервер.ИспользоватьОрдернуюСхемуПриОтраженииИзлишковНедостач(ТорговыйОбъект) Тогда
		ЕстьРасхождения = Обработки.ПомощникОформленияСкладскихАктов.ТоварыКОформлениюСкладскихАктов(ТорговыйОбъект).Количество() > 0;
		
		ОтчетПоРасхождениямСклад = ЕстьРасхождения И ТипСклада = Перечисления.ТипыСкладов.ОптовыйСклад;
		ОтчетПоРасхождениямТорговыйЗал = ЕстьРасхождения И ТипСклада = Перечисления.ТипыСкладов.РозничныйМагазин;
	Иначе
		ОтчетПоРасхождениямСклад = Ложь;
		ОтчетПоРасхождениямТорговыйЗал = Ложь;
	КонецЕсли;
	
	МассивСтроки = Новый Массив;
	МассивСтроки.Добавить(?(ТипСклада = Перечисления.ТипыСкладов.ОптовыйСклад, НСтр("ru='на складе'"), НСтр("ru='в торговом зале'")));
	МассивСтроки.Добавить(" ");
	МассивСтроки.Добавить(Новый ФорматированнаяСтрока(Строка(ТорговыйОбъект),,,, ПолучитьНавигационнуюСсылку(ТорговыйОбъект)));
	
	ПредставлениеСклада = Новый ФорматированнаяСтрока(МассивСтроки);
	
	ТекстОшибки = "";
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Склад", ТорговыйОбъект);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПересчетТоваров.Ссылка КАК Ссылка,
	|	ПересчетТоваров.Дата КАК Дата,
	|	ПересчетТоваров.Статус КАК Статус
	|ИЗ
	|	Документ.ПересчетТоваров КАК ПересчетТоваров
	|ГДЕ
	|	ПересчетТоваров.Проведен
	|	И ПересчетТоваров.Склад = &Склад
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата УБЫВ";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		МассивСтроки = Новый Массив;
		МассивСтроки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru='Инвентаризация товаров'"),,,, "ОткрытьСписокИнвентаризаций"));
		МассивСтроки.Добавить(" ");
		МассивСтроки.Добавить(ПредставлениеСклада);
		МассивСтроки.Добавить(" ");
		МассивСтроки.Добавить(НСтр("ru='не проводилась.'"));
		
		ТекстОшибки = Новый ФорматированнаяСтрока(МассивСтроки);
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Если НачалоДня(Выборка.Дата) < НачалоДня(ДобавитьМесяц(ТекущаяДатаСеанса(), -1)) Тогда
			МассивСтроки = Новый Массив;
			МассивСтроки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru='Инвентаризация товаров'"),,,, "ОткрытьСписокИнвентаризаций"));
			МассивСтроки.Добавить(" ");
			МассивСтроки.Добавить(ПредставлениеСклада);
			МассивСтроки.Добавить(" ");
			МассивСтроки.Добавить(НСтр("ru='проводилась больше месяца назад.'"));
			МассивСтроки.Добавить(Символы.ПС);
			МассивСтроки.Добавить(НСтр("ru='Рекомендуется провести повторную инвентаризацию.'"));
			
			ТекстОшибки = Новый ФорматированнаяСтрока(МассивСтроки);
			
		ИначеЕсли Выборка.Статус <> Перечисления.СтатусыПересчетовТоваров.Выполнено Тогда
			МассивСтроки = Новый Массив;
			МассивСтроки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru='Инвентаризация товаров'"),,,, "ОткрытьСписокИнвентаризаций"));
			МассивСтроки.Добавить(" ");
			МассивСтроки.Добавить(ПредставлениеСклада);
			МассивСтроки.Добавить(" ");
			МассивСтроки.Добавить(НСтр("ru='не завершена.'"));
			МассивСтроки.Добавить(Символы.ПС);
			МассивСтроки.Добавить(НСтр("ru='Перед корректировкой остатков по регистрам ЕГАИС рекомендуется завершить инвентаризацию.'"));
			
			ТекстОшибки = Новый ФорматированнаяСтрока(МассивСтроки);
		КонецЕсли;
		
		Прервать;
		
	КонецЦикла;
	
	Если НЕ ПустаяСтрока(ТекстОшибки) Тогда
		Если ТипСклада = Перечисления.ТипыСкладов.ОптовыйСклад Тогда
			ТекстОшибкиСклад = ТекстОшибки;
		Иначе
			ТекстОшибкиТорговыйЗал = ТекстОшибки;
		КонецЕсли;
	КонецЕсли;
	//-- НЕ ЕГАИС
	
	Возврат;
	
КонецПроцедуры

// Вызывается после заполнения таблицы значений неподтвержденными документами.
//
// Параметры:
//  НеподтвержденныеДокументы - ТаблицаЗначений - таблица с найденными неподтвержденными документами,
//  ОрганизацияЕГАИС - СправочникСсылка.КлассификаторОрганизацийЕГАИС - собственная организация по классификатору.
//
Процедура ПриПроверкеНеподтвержденныхДокументов(НеподтвержденныеДокументы, ОрганизацияЕГАИС) Экспорт
	
	//++ НЕ ЕГАИС
	СписокСтатусов = Новый Массив;
	СписокСтатусов.Добавить(Перечисления.СтатусыОбработкиТТНВходящейЕГАИС.Подтвержден);
	СписокСтатусов.Добавить(Перечисления.СтатусыОбработкиТТНВходящейЕГАИС.ПодтвержденСРасхождениями);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ОрганизацияЕГАИС", ОрганизацияЕГАИС);
	Запрос.УстановитьПараметр("СписокСтатусов", СписокСтатусов);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТТНВходящая.Ссылка КАК ДокументСсылка
	|ИЗ
	|	Документ.ТТНВходящаяЕГАИС КАК ТТНВходящая
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СтатусыДокументовЕГАИС КАК СтатусыДокументовЕГАИС
	|		ПО ТТНВходящая.Ссылка = СтатусыДокументовЕГАИС.Документ
	|ГДЕ
	|	ТТНВходящая.Проведен
	|	И ТТНВходящая.Грузополучатель = &ОрганизацияЕГАИС
	|	И НЕ СтатусыДокументовЕГАИС.Статус В (&СписокСтатусов)
	|	И ТТНВходящая.ДокументОснование.Проведен";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СтрокаТаблицы = НеподтвержденныеДокументы.Найти(Выборка.ДокументСсылка, "ДокументСсылка");
		Если СтрокаТаблицы = Неопределено Тогда
			СтрокаТаблицы = НеподтвержденныеДокументы.Добавить();
			СтрокаТаблицы.ДокументСсылка = Выборка.ДокументСсылка;
			СтрокаТаблицы.ТипЗначения = Документы.ТТНВходящаяЕГАИС.ПустаяСсылка();
		КонецЕсли;
	КонецЦикла;
	//-- НЕ ЕГАИС
	
	Возврат;
	
КонецПроцедуры

// Вызывается после заполнения таблицы значений документами, требующих оформления.
//
// Параметры:
//  НеоформленныеДокументы - ТаблицаЗначений - таблица с найденными документами,
//  ОрганизацияЕГАИС - СправочникСсылка.КлассификаторОрганизацийЕГАИС - собственная организация по классификатору.
//
Процедура ПриПроверкеНеоформленныхДокументов(НеоформленныеДокументы, ОрганизацияЕГАИС) Экспорт
	
	//++ НЕ ЕГАИС
	СписокСтатусов = Новый Массив;
	СписокСтатусов.Добавить(Перечисления.СтатусыОбработкиТТНВходящейЕГАИС.Подтвержден);
	СписокСтатусов.Добавить(Перечисления.СтатусыОбработкиТТНВходящейЕГАИС.ПодтвержденСРасхождениями);
	
	ПустоеОснование = Новый Массив;
	ПустоеОснование.Добавить(Неопределено);
	ПустоеОснование.Добавить(Документы.ПриобретениеТоваровУслуг.ПустаяСсылка());
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ОрганизацияЕГАИС", ОрганизацияЕГАИС);
	Запрос.УстановитьПараметр("СписокСтатусов"  , СписокСтатусов);
	Запрос.УстановитьПараметр("ПустоеОснование" , ПустоеОснование);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТТНВходящая.Ссылка КАК ДокументСсылка
	|ИЗ
	|	Документ.ТТНВходящаяЕГАИС КАК ТТНВходящая
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СтатусыДокументовЕГАИС КАК СтатусыДокументовЕГАИС
	|		ПО ТТНВходящая.Ссылка = СтатусыДокументовЕГАИС.Документ
	|ГДЕ
	|	ТТНВходящая.Проведен
	|	И ТТНВходящая.Грузополучатель = &ОрганизацияЕГАИС
	|	И ТТНВходящая.ДокументОснование В(&ПустоеОснование)
	|	И СтатусыДокументовЕГАИС.Статус В(&СписокСтатусов)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СтрокаТаблицы = НеоформленныеДокументы.Найти(Выборка.ДокументСсылка, "ДокументСсылка");
		Если СтрокаТаблицы = Неопределено Тогда
			СтрокаТаблицы = НеоформленныеДокументы.Добавить();
			СтрокаТаблицы.ДокументСсылка = Выборка.ДокументСсылка;
			СтрокаТаблицы.ТипЗначения = Документы.ТТНВходящаяЕГАИС.ПустаяСсылка();
		КонецЕсли;
	КонецЦикла;
	//-- НЕ ЕГАИС
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти