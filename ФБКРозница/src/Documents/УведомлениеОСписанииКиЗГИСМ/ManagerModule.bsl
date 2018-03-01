#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область Панель1СМаркировка

// Возвращает текст запроса для получения общего количества документов в работе
// 
// Возвращаемое значение:
//  Строка - Текст запроса
//
Функция ТекстЗапросаУведомленияОСписанииКиЗГИСМ() Экспорт
	
	Возврат ИнтеграцияГИСМПереопределяемый.ТекстЗапросаУведомленияОСписанииКиЗГИСМ();
	
КонецФункции

// Возвращает текст запроса для получения количества документов для оформления
// 
// Возвращаемое значение:
//  Строка - Текст запроса
//
Функция ТекстЗапросаУведомленияОСписанииКиЗГИСМОформите() Экспорт
	
	Возврат ИнтеграцияГИСМПереопределяемый.ТекстЗапросаУведомленияОСписанииКиЗГИСМОформите();
	
КонецФункции

// Возвращает текст запроса для получения количества документов для отработки
// 
// Возвращаемое значение:
//  Строка - Текст запроса
//
Функция ТекстЗапросаУведомленияОСписанииКиЗГИСМОтработайте() Экспорт
	
	ТекстЗапроса = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КОЛИЧЕСТВО (РАЗЛИЧНЫЕ СтатусыИнформированияГИСМ.Документ) КАК КоличествоДокументов
	|ИЗ
	|	РегистрСведений.СтатусыИнформированияГИСМ КАК СтатусыИнформированияГИСМ
	|ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|	Документ.УведомлениеОСписанииКиЗГИСМ КАК УведомлениеОСписанииКиЗГИСМ
	|ПО
	|	СтатусыИнформированияГИСМ.ТекущееУведомление = УведомлениеОСписанииКиЗГИСМ.Ссылка
	|ГДЕ
	|	СтатусыИнформированияГИСМ.ДальнейшееДействие В 
	|		(ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПередайтеДанные),
	|		ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюГИСМ.ВыполнитеОбмен))
	|	И (УведомлениеОСписанииКиЗГИСМ.Организация = &Организация
	|		ИЛИ &Организация = НЕОПРЕДЕЛЕНО)
	|	И (УведомлениеОСписанииКиЗГИСМ.Ответственный = &Ответственный
	|		ИЛИ &Ответственный = НЕОПРЕДЕЛЕНО)
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|";
	Возврат ТекстЗапроса;
	
КонецФункции

// Возвращает текст запроса для получения количества документов, находящихся в состоянии ожидания
// 
// Возвращаемое значение:
//  Строка - Текст запроса
//
Функция ТекстЗапросаУведомленияОСписанииКиЗГИСМОжидайте() Экспорт
	
	ТекстЗапроса = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КОЛИЧЕСТВО (РАЗЛИЧНЫЕ СтатусыИнформированияГИСМ.Документ) КАК КоличествоДокументов
	|ИЗ
	|	РегистрСведений.СтатусыИнформированияГИСМ КАК СтатусыИнформированияГИСМ
	|ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|	Документ.УведомлениеОСписанииКиЗГИСМ КАК УведомлениеОСписанииКиЗГИСМ
	|ПО
	|	СтатусыИнформированияГИСМ.ТекущееУведомление = УведомлениеОСписанииКиЗГИСМ.Ссылка
	|ГДЕ
	|	СтатусыИнформированияГИСМ.ДальнейшееДействие В 
	|		(ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюГИСМ.ОжидайтеПередачуДанныхРегламентнымЗаданием),
	|		ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюГИСМ.ОжидайтеПолучениеКвитанцииОФиксации))
	|	И (УведомлениеОСписанииКиЗГИСМ.Организация = &Организация
	|		ИЛИ &Организация = НЕОПРЕДЕЛЕНО)
	|	И (УведомлениеОСписанииКиЗГИСМ.Ответственный = &Ответственный
	|		ИЛИ &Ответственный = НЕОПРЕДЕЛЕНО)
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|";
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#Область ДействияПриОбменеГИСМ

// Обновить статус после подготовки к передаче данных
//
// Параметры:
//  ДокументСсылка - ДокументСсылка - Ссылка на документ
//  Операция - ПеречислениеСсылка.ОперацииОбменаГИСМ - Операция ГИСМ
// 
// Возвращаемое значение:
//  Перечисления.СтатусыИнформированияГИСМ - Новый статус
//
Функция ОбновитьСтатусПослеПодготовкиКПередачеДанных(ДокументСсылка, Операция) Экспорт
	
	НовыйСтатус        = Неопределено;
	ДальнейшееДействие = Неопределено;
	
	ИспользоватьАвтоматическийОбмен = ПолучитьФункциональнуюОпцию("ИспользоватьАвтоматическуюОтправкуПолучениеДанныхГИСМ");
	
	Если Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаДанных
		Или Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаДанныхВыбраковкаКиЗ
		Или Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаДанныхСписаниеТоваров Тогда
		
		НовыйСтатус = Перечисления.СтатусыИнформированияГИСМ.КПередаче;
		Если ИспользоватьАвтоматическийОбмен Тогда
			ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ОжидайтеПередачуДанныхРегламентнымЗаданием;
		Иначе
			ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ВыполнитеОбмен;
		КонецЕсли;
		
	КонецЕсли;
	
	Если НовыйСтатус = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	НовыйСтатус = РегистрыСведений.СтатусыИнформированияГИСМ.ОбновитьСтатус(
		ДокументСсылка,
		НовыйСтатус,
		ДальнейшееДействие);
	
	Возврат НовыйСтатус;
	
КонецФункции

// Обновить статус после передачи данных
//
// Параметры:
//  ДокументСсылка - ДокументСсылка - Ссылка на документ
//  Операция - ПеречислениеСсылка.ОперацииОбменаГИСМ - Операция ГИСМ
//  СтатусОбработки - ПеречислениеСсылка.СтатусыОбработкиСообщенийГИСМ - Статус обработки сообщения
// 
// Возвращаемое значение:
//  Перечисления.СтатусыИнформированияГИСМ - Новый статус
//
Функция ОбновитьСтатусПослеПередачиДанных(ДокументСсылка, Операция, СтатусОбработки) Экспорт
	
	НовыйСтатус     = Неопределено;
	ДальнейшееДействие = Неопределено;
	
	Если Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаДанных
		Или Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаДанныхВыбраковкаКиЗ
		Или Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаДанныхСписаниеТоваров Тогда
		
		Если СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийГИСМ.Принято Тогда
			
			НовыйСтатус = Перечисления.СтатусыИнформированияГИСМ.Передано;
			ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ОжидайтеПолучениеКвитанцииОФиксации;
			
		ИначеЕсли СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийГИСМ.Отклонено
			ИЛИ СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийГИСМ.Ошибка Тогда
			
			НовыйСтатус = Перечисления.СтатусыИнформированияГИСМ.ОтклоненоГИСМ;
			ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПередайтеДанные;
			
		КонецЕсли;
		
	ИначеЕсли Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаДанныхПолучениеКвитанции
		Или Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаДанныхВыбраковкаКиЗПолучениеКвитанции
		Или Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаДанныхСписаниеТоваровПолучениеКвитанции Тогда
		
		Если СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийГИСМ.Принято Тогда
			
			НовыйСтатус = Перечисления.СтатусыИнформированияГИСМ.ПринятоГИСМ;
			ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.НеТребуется;
			
		ИначеЕсли СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийГИСМ.Отклонено
			ИЛИ СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийГИСМ.Ошибка Тогда
			
			НовыйСтатус = Перечисления.СтатусыИнформированияГИСМ.ОтклоненоГИСМ;
			ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПередайтеДанные;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если НовыйСтатус = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	НовыйСтатус = РегистрыСведений.СтатусыИнформированияГИСМ.ОбновитьСтатус(
		ДокументСсылка,
		НовыйСтатус,
		ДальнейшееДействие);
	
	Возврат НовыйСтатус;
	
КонецФункции

#КонецОбласти

#Область СообщенияГИСМ

// Сообщение к передаче XML
//
// Параметры:
//  ДокументСсылка - ДокументСсылка - Ссылка на документ
//  Операция - ПеречислениеСсылка.ОперацииОбменаГИСМ - Операция ГИСМ
// 
// Возвращаемое значение:
//  Строка - Текст сообщения XML
//
Функция СообщениеКПередачеXML(ДокументСсылка, Операция) Экспорт
	
	Если Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаДанных
		Или Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаДанныхВыбраковкаКиЗ
		Или Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаДанныхСписаниеТоваров Тогда
		
		Возврат УведомлениеОСписанииКиЗXML(ДокументСсылка);
		
	ИначеЕсли Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаДанныхПолучениеКвитанции Тогда
		
		Возврат ИнтеграцияГИСМВызовСервера.ЗапросКвитанцииОФиксацииПоСсылкеXML(ДокументСсылка, Перечисления.ОперацииОбменаГИСМ.ПередачаДанных);
		
	ИначеЕсли Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаДанныхВыбраковкаКиЗПолучениеКвитанции Тогда
		
		Возврат ИнтеграцияГИСМВызовСервера.ЗапросКвитанцииОФиксацииПоСсылкеXML(ДокументСсылка, Перечисления.ОперацииОбменаГИСМ.ПередачаДанныхВыбраковкаКиЗ);
		
	ИначеЕсли Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаДанныхСписаниеТоваровПолучениеКвитанции Тогда
		
		Возврат ИнтеграцияГИСМВызовСервера.ЗапросКвитанцииОФиксацииПоСсылкеXML(ДокументСсылка, Перечисления.ОперацииОбменаГИСМ.ПередачаДанныхСписаниеТоваров);
		
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область СообщенияГИСМ

Функция УведомлениеОСписанииКиЗXML(ДокументСсылка)
	
	Если ИнтеграцияГИСМ.ИспользоватьВозможностиВерсии("2.41") Тогда
		Возврат УведомлениеОСписанииКиЗXML2_41(ДокументСсылка);
	Иначе
		Возврат УведомлениеОСписанииКиЗXML2_40(ДокументСсылка);
	КонецЕсли;
	
КонецФункции

#Область Версия2_40

Функция УведомлениеОСписанииКиЗXML2_40(ДокументСсылка)
	
	СообщенияXML = Новый Массив;
	
	Версия = "2.40";
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ГИСМПрисоединенныеФайлы.ВладелецФайла КАК Ссылка,
	|	КОЛИЧЕСТВО(ГИСМПрисоединенныеФайлы.Ссылка) КАК ПоследнийНомерВерсии
	|ПОМЕСТИТЬ ВременнаяТаблица
	|ИЗ
	|	Справочник.ГИСМПрисоединенныеФайлы КАК ГИСМПрисоединенныеФайлы
	|ГДЕ
	|	ГИСМПрисоединенныеФайлы.ВладелецФайла = &Ссылка
	|	И ГИСМПрисоединенныеФайлы.Операция = ЗНАЧЕНИЕ(Перечисление.ОперацииОбменаГИСМ.ПередачаДанных)
	|	И ГИСМПрисоединенныеФайлы.ТипСообщения = ЗНАЧЕНИЕ(Перечисление.ТипыСообщенийГИСМ.Исходящее)
	|СГРУППИРОВАТЬ ПО
	|	ГИСМПрисоединенныеФайлы.ВладелецФайла
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	УведомлениеОСписанииКиЗГИСМ.Дата                       КАК Дата,
	|	УведомлениеОСписанииКиЗГИСМ.Номер                      КАК Номер,
	|	ЕСТЬNULL(ВременнаяТаблица.ПоследнийНомерВерсии, 0) КАК ПоследнийНомерВерсии,
	|	УведомлениеОСписанииКиЗГИСМ.Основание     КАК Основание,
	|	УведомлениеОСписанииКиЗГИСМ.Организация   КАК Организация,
	|	УведомлениеОСписанииКиЗГИСМ.Подразделение КАК Подразделение
	|ИЗ
	|	Документ.УведомлениеОСписанииКиЗГИСМ КАК УведомлениеОСписанииКиЗГИСМ
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВременнаяТаблица КАК ВременнаяТаблица
	|		ПО УведомлениеОСписанииКиЗГИСМ.Ссылка = ВременнаяТаблица.Ссылка
	|ГДЕ
	|	УведомлениеОСписанииКиЗГИСМ.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НомераКиЗ.НомерСтроки     КАК НомерСтроки,
	|	НомераКиЗ.НомерКиЗ        КАК НомерКиЗ,
	|	НомераКиЗ.RFIDTID         КАК TID,
	|	НомераКиЗ.RFIDEPC         КАК EPC,
	|	НомераКиЗ.ПричинаСписания КАК ПричинаСписания
	|ИЗ
	|	Документ.УведомлениеОСписанииКиЗГИСМ.НомераКиЗ КАК НомераКиЗ
	|ГДЕ
	|	НомераКиЗ.Ссылка = &Ссылка
	|УПОРЯДОЧИТЬ ПО
	|	НомераКиЗ.НомерСтроки
	|ИТОГИ ПО
	|	ПричинаСписания");
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Результат = Запрос.ВыполнитьПакет();
	Шапка  = Результат[1].Выбрать();
	Товары = Результат[2].Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкам);
	Если Не Шапка.Следующий()
		Или Товары.Строки.Количество() = 0 Тогда
		
		СообщениеXML = ИнтеграцияГИСМКлиентСервер.СтруктураСообщенияXML();
		СообщениеXML.Документ = ДокументСсылка;
		СообщениеXML.Описание = ИнтеграцияГИСМ.ОписаниеОперацииПередачиДанных(
			Перечисления.ОперацииОбменаГИСМ.ПередачаДанныхВыбраковкаКиЗ, ДокументСсылка);
		СообщениеXML.ТекстОшибки = НСтр("ru = 'Нет данных для выгрузки.'");
		СообщенияXML.Добавить(СообщениеXML);
		Возврат СообщенияXML;
		
	КонецЕсли;
	
	НомерВерсии = Шапка.ПоследнийНомерВерсии + 1;
	
	РеквизитыОгранизации = ИнтеграцияГИСМВызовСервера.ИННКППGLNОрганизации(Шапка.Организация, Шапка.Подразделение);
	
	СообщениеXML = ИнтеграцияГИСМКлиентСервер.СтруктураСообщенияXML();
	СообщениеXML.Описание = ИнтеграцияГИСМ.ОписаниеОперацииПередачиДанных(
		Перечисления.ОперацииОбменаГИСМ.ПередачаДанныхВыбраковкаКиЗ, ДокументСсылка, НомерВерсии);
	
	ИмяТипа   = "query";
	ИмяПакета = "reject_signs";
	
	ПередачаДанных = ИнтеграцияГИСМ.ОбъектXDTOПоИмениСвойства(Неопределено, ИмяТипа, Версия);
	
	УведомлениеОСписании = ИнтеграцияГИСМ.ОбъектXDTO(ИмяПакета, Версия);
	УведомлениеОСписании.action_id  = УведомлениеОСписании.action_id;
	
	Попытка
		УведомлениеОСписании.sender_gln = РеквизитыОгранизации.GLN;
	Исключение
		ИнтеграцияГИСМКлиентСервер.ДобавитьТекстОшибкиНеЗаполненGLNОрганизации(СообщениеXML, РеквизитыОгранизации.GLN, Шапка);
	КонецПопытки;
	
	УведомлениеОСписании.reject_doc_num  = Шапка.Номер;
	УведомлениеОСписании.reject_doc_date = Шапка.Дата;
	
	ХранилищеВременныхДат = Новый Соответствие;
	ИнтеграцияГИСМ.УстановитьДатуСЧасовымПоясом(
		УведомлениеОСписании,
		"reject_date",
		Шапка.Дата,
		ХранилищеВременныхДат);
	
	УведомлениеОСписании.rejects = ИнтеграцияГИСМ.ОбъектXDTOПоИмениСвойства(УведомлениеОСписании, "rejects", Версия);
	
	Для Каждого СтрокаТЧИтогПоПричинеСписания Из Товары.Строки Цикл
		
		НоваяСтрокаПричинаСписания = ИнтеграцияГИСМ.ОбъектXDTOПоИмениСвойства(УведомлениеОСписании.rejects, "by_reason", Версия);
		НоваяСтрокаПричинаСписания.reject_reason = ИнтеграцияГИСМ.ПричинаСписания(СтрокаТЧИтогПоПричинеСписания.ПричинаСписания);
		НоваяСтрокаПричинаСписания.signs = ИнтеграцияГИСМ.ОбъектXDTOПоИмениСвойства(НоваяСтрокаПричинаСписания, "signs", Версия);
		
		Для Каждого СтрокаТЧ Из СтрокаТЧИтогПоПричинеСписания.Строки Цикл
			
			НоваяСтрока = ИнтеграцияГИСМ.ОбъектXDTOПоИмениСвойства(НоваяСтрокаПричинаСписания.signs, "sign", Версия);
			
			Если ЗначениеЗаполнено(СтрокаТЧ.НомерКиЗ) Тогда
				
				НоваяСтрока.sign_num = СтрокаТЧ.НомерКиЗ;
				
			ИначеЕсли ЗначениеЗаполнено(СтрокаТЧ.TID) Тогда
				
				НоваяСтрока.sign_tid = СтрокаТЧ.TID;
				
			ИначеЕсли ЗначениеЗаполнено(СтрокаТЧ.EPC) Тогда
				
				Попытка
					НоваяСтрока.sign_sgtin = МенеджерОборудованияКлиентСервер.ПреобразоватьHEXВБинарнуюСтроку(СтрокаТЧ.EPC);
				Исключение
					ИнтеграцияГИСМКлиентСервер.ДобавитьТекстОшибки(
						СообщениеXML,
						СтрШаблон(НСтр("ru = 'Для номенклатуры %1 указан некорректный EPC ""%2"".'"),
							ИнтеграцияГИСМПереопределяемый.ПредставлениеНоменклатуры(СтрокаТЧ.Номенклатура, СтрокаТЧ.Характеристика),
							СтрокаТЧ.EPC));
				КонецПопытки;
				
			КонецЕсли;
			
			НоваяСтрокаПричинаСписания.signs.sign.Добавить(НоваяСтрока);
			
		КонецЦикла;
		
		УведомлениеОСписании.rejects.by_reason.Добавить(НоваяСтрокаПричинаСписания);
		
	КонецЦикла;
	
	ПередачаДанных.version    = ПередачаДанных.version;
	ПередачаДанных[ИмяПакета] = УведомлениеОСписании;
	
	ТекстСообщенияXML = ИнтеграцияГИСМ.ОбъектXDTOВXML(ПередачаДанных, ИмяТипа, Версия);
	ТекстСообщенияXML = ИнтеграцияГИСМ.ПреобразоватьВременныеДаты(ХранилищеВременныхДат, ТекстСообщенияXML);
	
	СообщениеXML.ТекстСообщенияXML = ТекстСообщенияXML;
	СообщениеXML.КонвертSOAP = ИнтеграцияГИСМВызовСервера.ПоместитьТекстСообщенияXMLВКонвертSOAP(ТекстСообщенияXML);
	
	СообщениеXML.ТипСообщения = Перечисления.ТипыСообщенийГИСМ.Исходящее;
	СообщениеXML.Организация  = Шапка.Организация;
	СообщениеXML.Операция     = Перечисления.ОперацииОбменаГИСМ.ПередачаДанных;
	СообщениеXML.Документ     = ДокументСсылка;
	СообщениеXML.Основание    = Шапка.Основание;
	СообщениеXML.Версия       = НомерВерсии;
	
	СообщенияXML.Добавить(СообщениеXML);
	
	Возврат СообщенияXML;
	
КонецФункции

#КонецОбласти

#Область Версия2_41

Функция УведомлениеОСписанииКиЗXML2_41(ДокументСсылка)
	
	СообщенияXML = Новый Массив;
	
	Версия = ИнтеграцияГИСМ.ВерсииСхемОбмена().Клиент;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ГИСМПрисоединенныеФайлы.ВладелецФайла      КАК Ссылка,
	|	КОЛИЧЕСТВО(ГИСМПрисоединенныеФайлы.Ссылка) КАК ПоследнийНомерВерсии,
	|	0                                          КАК ПередачаДанныхВыбраковкаКиЗПоследнийНомерВерсии,
	|	0                                          КАК ПередачаДанныхСписаниеТоваровПоследнийНомерВерсии
	|ПОМЕСТИТЬ ВременнаяТаблицаОбъединение
	|ИЗ
	|	Справочник.ГИСМПрисоединенныеФайлы КАК ГИСМПрисоединенныеФайлы
	|ГДЕ
	|	ГИСМПрисоединенныеФайлы.ВладелецФайла = &Ссылка
	|	И ГИСМПрисоединенныеФайлы.Операция = ЗНАЧЕНИЕ(Перечисление.ОперацииОбменаГИСМ.ПередачаДанных)
	|	И ГИСМПрисоединенныеФайлы.ТипСообщения = ЗНАЧЕНИЕ(Перечисление.ТипыСообщенийГИСМ.Исходящее)
	|
	|СГРУППИРОВАТЬ ПО
	|	ГИСМПрисоединенныеФайлы.ВладелецФайла
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ГИСМПрисоединенныеФайлы.ВладелецФайла      КАК Ссылка,
	|	0                                          КАК ПоследнийНомерВерсии,
	|	КОЛИЧЕСТВО(ГИСМПрисоединенныеФайлы.Ссылка) КАК ПередачаДанныхВыбраковкаКиЗПоследнийНомерВерсии,
	|	0                                          КАК ПередачаДанныхСписаниеТоваровПоследнийНомерВерсии
	|ИЗ
	|	Справочник.ГИСМПрисоединенныеФайлы КАК ГИСМПрисоединенныеФайлы
	|ГДЕ
	|	ГИСМПрисоединенныеФайлы.ВладелецФайла = &Ссылка
	|	И ГИСМПрисоединенныеФайлы.Операция = ЗНАЧЕНИЕ(Перечисление.ОперацииОбменаГИСМ.ПередачаДанныхВыбраковкаКиЗ)
	|	И ГИСМПрисоединенныеФайлы.ТипСообщения = ЗНАЧЕНИЕ(Перечисление.ТипыСообщенийГИСМ.Исходящее)
	|
	|СГРУППИРОВАТЬ ПО
	|	ГИСМПрисоединенныеФайлы.ВладелецФайла
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ГИСМПрисоединенныеФайлы.ВладелецФайла      КАК Ссылка,
	|	0                                          КАК ПоследнийНомерВерсии,
	|	0                                          КАК ПередачаДанныхВыбраковкаКиЗПоследнийНомерВерсии,
	|	КОЛИЧЕСТВО(ГИСМПрисоединенныеФайлы.Ссылка) КАК ПередачаДанныхСписаниеТоваровПоследнийНомерВерсии
	|ИЗ
	|	Справочник.ГИСМПрисоединенныеФайлы КАК ГИСМПрисоединенныеФайлы
	|ГДЕ
	|	ГИСМПрисоединенныеФайлы.ВладелецФайла = &Ссылка
	|	И ГИСМПрисоединенныеФайлы.Операция = ЗНАЧЕНИЕ(Перечисление.ОперацииОбменаГИСМ.ПередачаДанныхСписаниеТоваров)
	|	И ГИСМПрисоединенныеФайлы.ТипСообщения = ЗНАЧЕНИЕ(Перечисление.ТипыСообщенийГИСМ.Исходящее)
	|
	|СГРУППИРОВАТЬ ПО
	|	ГИСМПрисоединенныеФайлы.ВладелецФайла
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ 
	|	Т.Ссылка,
	|	МАКСИМУМ(Т.ПоследнийНомерВерсии)                              КАК ПоследнийНомерВерсии,
	|	МАКСИМУМ(Т.ПередачаДанныхВыбраковкаКиЗПоследнийНомерВерсии)   КАК ПередачаДанныхВыбраковкаКиЗПоследнийНомерВерсии,
	|	МАКСИМУМ(Т.ПередачаДанныхСписаниеТоваровПоследнийНомерВерсии) КАК ПередачаДанныхСписаниеТоваровПоследнийНомерВерсии
	|ПОМЕСТИТЬ ВременнаяТаблица
	|ИЗ
	|	ВременнаяТаблицаОбъединение КАК Т
	|СГРУППИРОВАТЬ ПО
	|	Т.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	УведомлениеОСписанииКиЗГИСМ.Дата                       КАК Дата,
	|	УведомлениеОСписанииКиЗГИСМ.Номер                      КАК Номер,
	|	
	|	ЕСТЬNULL(ВременнаяТаблица.ПоследнийНомерВерсии, 0)                              КАК ПоследнийНомерВерсии,
	|	ЕСТЬNULL(ВременнаяТаблица.ПередачаДанныхВыбраковкаКиЗПоследнийНомерВерсии, 0)   КАК ПередачаДанныхВыбраковкаКиЗПоследнийНомерВерсии,
	|	ЕСТЬNULL(ВременнаяТаблица.ПередачаДанныхСписаниеТоваровПоследнийНомерВерсии, 0) КАК ПередачаДанныхСписаниеТоваровПоследнийНомерВерсии,
	|
	|	УведомлениеОСписанииКиЗГИСМ.Основание       КАК Основание,
	|	УведомлениеОСписанииКиЗГИСМ.Основание.Номер КАК НомерДокументаОснования,
	|	УведомлениеОСписанииКиЗГИСМ.Основание.Дата  КАК ДатаДокументаОснования,
	|	УведомлениеОСписанииКиЗГИСМ.Организация     КАК Организация,
	|	УведомлениеОСписанииКиЗГИСМ.Подразделение   КАК Подразделение
	|ИЗ
	|	Документ.УведомлениеОСписанииКиЗГИСМ КАК УведомлениеОСписанииКиЗГИСМ
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВременнаяТаблица КАК ВременнаяТаблица
	|		ПО УведомлениеОСписанииКиЗГИСМ.Ссылка = ВременнаяТаблица.Ссылка
	|ГДЕ
	|	УведомлениеОСписанииКиЗГИСМ.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НомераКиЗ.НомерСтроки                 КАК НомерСтроки,
	|	НомераКиЗ.НомерКиЗ                    КАК НомерКиЗ,
	|	НомераКиЗ.ПричинаСписания             КАК ПричинаСписания,
	|	НомераКиЗ.ЗаявкаНаВыпускКиЗ.НомерГИСМ КАК НомерГИСМ
	|ИЗ
	|	Документ.УведомлениеОСписанииКиЗГИСМ.НомераКиЗ КАК НомераКиЗ
	|ГДЕ
	|	НомераКиЗ.Ссылка = &Ссылка
	|	И Не НомераКиЗ.Индивидуализирован
	|УПОРЯДОЧИТЬ ПО
	|	НомераКиЗ.НомерСтроки
	|ИТОГИ ПО
	|	НомераКиЗ.ЗаявкаНаВыпускКиЗ.НомерГИСМ,
	|	ПричинаСписания
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НомераКиЗ.НомерСтроки КАК НомерСтроки,
	|	НомераКиЗ.НомерКиЗ    КАК НомерКиЗ,
	|	НомераКиЗ.RFIDTID     КАК TID,
	|	НомераКиЗ.RFIDEPC     КАК EPC
	|ИЗ
	|	Документ.УведомлениеОСписанииКиЗГИСМ.НомераКиЗ КАК НомераКиЗ
	|ГДЕ
	|	НомераКиЗ.Ссылка = &Ссылка
	|	И НомераКиЗ.Индивидуализирован
	|УПОРЯДОЧИТЬ ПО
	|	НомераКиЗ.НомерСтроки
	|");
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Результат = Запрос.ВыполнитьПакет();
	Шапка  = Результат[2].Выбрать();
	КиЗ    = Результат[3].Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкам);
	Товары = Результат[4].Выгрузить();
	Если Не Шапка.Следующий()
		Или (Товары.Количество() = 0 И КиЗ.Строки.Количество() = 0) Тогда
		
		СообщениеXML = ИнтеграцияГИСМКлиентСервер.СтруктураСообщенияXML();
		СообщениеXML.Документ = ДокументСсылка;
		СообщениеXML.Описание = ИнтеграцияГИСМ.ОписаниеОперацииПередачиДанных(
			Перечисления.ОперацииОбменаГИСМ.ПередачаДанныхВыбраковкаКиЗ, ДокументСсылка);
		СообщениеXML.ТекстОшибки = НСтр("ru = 'Нет данных для выгрузки.'");
		СообщенияXML.Добавить(СообщениеXML);
		Возврат СообщенияXML;
		
	КонецЕсли;
	
	НомерВерсии                              = Шапка.ПоследнийНомерВерсии + 1;
	НомерВерсииПередачаДанныхВыбраковкаКиЗ   = Шапка.ПередачаДанныхВыбраковкаКиЗПоследнийНомерВерсии + 1;
	НомерВерсииПередачаДанныхСписаниеТоваров = Шапка.ПередачаДанныхСписаниеТоваровПоследнийНомерВерсии + 1;
	
	РеквизитыОгранизации = ИнтеграцияГИСМВызовСервера.ИННКППGLNОрганизации(Шапка.Организация, Шапка.Подразделение);
	
	Если КиЗ.Строки.Количество() > 0 Тогда
		
		Для Каждого СтрокаДереваНомерГИСМ Из КиЗ.Строки Цикл
			
			#Область ununify_reject
			
			СообщениеXML = ИнтеграцияГИСМКлиентСервер.СтруктураСообщенияXML();
			СообщениеXML.Описание = ИнтеграцияГИСМ.ОписаниеОперацииПередачиДанных(
				Перечисления.ОперацииОбменаГИСМ.ПередачаДанныхВыбраковкаКиЗ, ДокументСсылка, НомерВерсииПередачаДанныхВыбраковкаКиЗ);
			
			ИмяТипа   = "query";
			ИмяПакета = "ununify_reject";
			
			ПередачаДанных = ИнтеграцияГИСМ.ОбъектXDTOПоИмениСвойства(Неопределено, ИмяТипа, Версия);
			
			УведомлениеОСписании = ИнтеграцияГИСМ.ОбъектXDTO(ИмяПакета, Версия);
			УведомлениеОСписании.action_id  = УведомлениеОСписании.action_id;
			
			Попытка
				УведомлениеОСписании.sender_gln = РеквизитыОгранизации.GLN;
			Исключение
				ИнтеграцияГИСМКлиентСервер.ДобавитьТекстОшибкиНеЗаполненGLNОрганизации(СообщениеXML, РеквизитыОгранизации.GLN, Шапка);
			КонецПопытки;
			
			УведомлениеОСписании.emit_order_id = СтрокаДереваНомерГИСМ.НомерГИСМ;
			
			УведомлениеОСписании.rejects = ИнтеграцияГИСМ.ОбъектXDTOПоИмениСвойства(УведомлениеОСписании, "rejects", Версия);
			
			Для Каждого СтрокаТЧИтогПоПричинеСписания Из СтрокаДереваНомерГИСМ.Строки Цикл
				
				НоваяСтрокаПричинаСписания = ИнтеграцияГИСМ.ОбъектXDTOПоИмениСвойства(УведомлениеОСписании.rejects, "reject_by_reason", Версия);
				НоваяСтрокаПричинаСписания.reject_reason = ИнтеграцияГИСМ.ПричинаСписания(СтрокаТЧИтогПоПричинеСписания.ПричинаСписания);
				НоваяСтрокаПричинаСписания.signs = ИнтеграцияГИСМ.ОбъектXDTOПоИмениСвойства(НоваяСтрокаПричинаСписания, "signs", Версия);
				
				Для Каждого СтрокаТЧ Из СтрокаТЧИтогПоПричинеСписания.Строки Цикл
					
					НоваяСтрокаПричинаСписания.signs.sign_num.Добавить(СтрокаТЧ.НомерКиЗ);
					
				КонецЦикла;
				
				УведомлениеОСписании.rejects.reject_by_reason.Добавить(НоваяСтрокаПричинаСписания);
				
			КонецЦикла;
			
			ХранилищеВременныхДат = Новый Соответствие;
			ИнтеграцияГИСМ.УстановитьДатуСЧасовымПоясом(
				УведомлениеОСписании,
				"reject_date",
				Шапка.Дата,
				ХранилищеВременныхДат);
			
			ПередачаДанных.version    = ПередачаДанных.version;
			ПередачаДанных[ИмяПакета] = УведомлениеОСписании;
			
			ТекстСообщенияXML = ИнтеграцияГИСМ.ОбъектXDTOВXML(ПередачаДанных, ИмяТипа, Версия);
			ТекстСообщенияXML = ИнтеграцияГИСМ.ПреобразоватьВременныеДаты(ХранилищеВременныхДат, ТекстСообщенияXML);
			
			СообщениеXML.ТекстСообщенияXML = ТекстСообщенияXML;
			СообщениеXML.КонвертSOAP = ИнтеграцияГИСМВызовСервера.ПоместитьТекстСообщенияXMLВКонвертSOAP(ТекстСообщенияXML);
			
			СообщениеXML.ТипСообщения = Перечисления.ТипыСообщенийГИСМ.Исходящее;
			СообщениеXML.Организация  = Шапка.Организация;
			СообщениеXML.Операция     = Перечисления.ОперацииОбменаГИСМ.ПередачаДанныхВыбраковкаКиЗ;
			СообщениеXML.Документ     = ДокументСсылка;
			СообщениеXML.Основание    = Шапка.Основание;
			СообщениеXML.Версия       = НомерВерсииПередачаДанныхВыбраковкаКиЗ;
			
			СообщенияXML.Добавить(СообщениеXML);
			
			#КонецОбласти
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если Товары.Количество() > 0 Тогда
		
		#Область item_removal
		
		СообщениеXML = ИнтеграцияГИСМКлиентСервер.СтруктураСообщенияXML();
		СообщениеXML.Описание = ИнтеграцияГИСМ.ОписаниеОперацииПередачиДанных(
			Перечисления.ОперацииОбменаГИСМ.ПередачаДанныхСписаниеТоваров, ДокументСсылка, НомерВерсииПередачаДанныхСписаниеТоваров);
		
		ИмяТипа   = "query";
		ИмяПакета = "item_removal";
		
		ПередачаДанных = ИнтеграцияГИСМ.ОбъектXDTOПоИмениСвойства(Неопределено, ИмяТипа, Версия);
		
		УведомлениеОСписании = ИнтеграцияГИСМ.ОбъектXDTO(ИмяПакета, Версия);
		УведомлениеОСписании.action_id  = УведомлениеОСписании.action_id;
		
		Попытка
			УведомлениеОСписании.sender_gln = РеквизитыОгранизации.GLN;
		Исключение
			ИнтеграцияГИСМКлиентСервер.ДобавитьТекстОшибкиНеЗаполненGLNОрганизации(СообщениеXML, РеквизитыОгранизации.GLN, Шапка);
		КонецПопытки;
		
		УведомлениеОСписании.action = ИнтеграцияГИСМ.ОбъектXDTOПоИмениСвойства(УведомлениеОСписании, "action", Версия);
		УведомлениеОСписании.action.writeoff = ИнтеграцияГИСМ.ОбъектXDTOПоИмениСвойства(УведомлениеОСписании.action, "writeoff", Версия);
		
		УведомлениеОСписании.action.writeoff.doc_num  = Шапка.НомерДокументаОснования;
		УведомлениеОСписании.action.writeoff.doc_date = Шапка.ДатаДокументаОснования;
		
		ХранилищеВременныхДат = Новый Соответствие;
		ИнтеграцияГИСМ.УстановитьДатуСЧасовымПоясом(
			УведомлениеОСписании,
			"action_date",
			Шапка.Дата,
			ХранилищеВременныхДат);
		
		УведомлениеОСписании.details = ИнтеграцияГИСМ.ОбъектXDTOПоИмениСвойства(УведомлениеОСписании, "details", Версия);
		
		Для Каждого СтрокаТЧ Из Товары Цикл
			
			Если Не ЗначениеЗаполнено(СтрокаТЧ.НомерКиЗ)
				И Не ЗначениеЗаполнено(СтрокаТЧ.TID)
				И Не ЗначениеЗаполнено(СтрокаТЧ.EPC) Тогда
				ИнтеграцияГИСМКлиентСервер.ДобавитьТекстОшибки(
					СообщениеXML,
					СтрШаблон(НСтр("ru = 'В строке %1 не указаны данные о КиЗ.'"),
						СтрокаТЧ.НомерСтроки));
				Продолжить;
			КонецЕсли;
			
			НоваяСтрока = ИнтеграцияГИСМ.ОбъектXDTOПоИмениСвойства(УведомлениеОСписании.details, "sign", Версия);
			
			Если ЗначениеЗаполнено(СтрокаТЧ.НомерКиЗ) Тогда
				Попытка
					НоваяСтрока.sign_num.Добавить(СтрокаТЧ.НомерКиЗ);
				Исключение
					ИнтеграцияГИСМКлиентСервер.ДобавитьТекстОшибки(
						СообщениеXML,
						СтрШаблон(НСтр("ru = 'В строке %1 указан некорректный номер КиЗ ""%2"".'"),
							СтрокаТЧ.НомерСтроки,
							СтрокаТЧ.НомерКиЗ));
				КонецПопытки;
			КонецЕсли;
			
			Если ЗначениеЗаполнено(СтрокаТЧ.TID) Тогда
				Попытка
					НоваяСтрока.sign_tid.Добавить(СтрокаТЧ.TID);
				Исключение
					ИнтеграцияГИСМКлиентСервер.ДобавитьТекстОшибки(
						СообщениеXML,
						СтрШаблон(НСтр("ru = 'В строке %1 указан некорректный TID ""%2"".'"),
							СтрокаТЧ.НомерСтроки,
							СтрокаТЧ.TID));
				КонецПопытки;
			КонецЕсли;
			
			Если ЗначениеЗаполнено(СтрокаТЧ.EPC) Тогда
				Попытка
					НоваяСтрока.sign_sgtin.Добавить(МенеджерОборудованияКлиентСервер.ПреобразоватьHEXВБинарнуюСтроку(СтрокаТЧ.EPC));
				Исключение
					ИнтеграцияГИСМКлиентСервер.ДобавитьТекстОшибки(
						СообщениеXML,
						СтрШаблон(НСтр("ru = 'В строке %1 указан некорректный EPC ""%2"".'"),
							СтрокаТЧ.НомерСтроки,
							СтрокаТЧ.EPC));
				КонецПопытки;
			КонецЕсли;
			
			УведомлениеОСписании.details.sign.Добавить(НоваяСтрока);
			
		КонецЦикла;
		
		ПередачаДанных.version    = ПередачаДанных.version;
		ПередачаДанных[ИмяПакета] = УведомлениеОСписании;
		
		ТекстСообщенияXML = ИнтеграцияГИСМ.ОбъектXDTOВXML(ПередачаДанных, ИмяТипа, Версия);
		ТекстСообщенияXML = ИнтеграцияГИСМ.ПреобразоватьВременныеДаты(ХранилищеВременныхДат, ТекстСообщенияXML);
		
		СообщениеXML.ТекстСообщенияXML = ТекстСообщенияXML;
		СообщениеXML.КонвертSOAP = ИнтеграцияГИСМВызовСервера.ПоместитьТекстСообщенияXMLВКонвертSOAP(ТекстСообщенияXML);
		
		СообщениеXML.ТипСообщения = Перечисления.ТипыСообщенийГИСМ.Исходящее;
		СообщениеXML.Организация  = Шапка.Организация;
		СообщениеXML.Операция     = Перечисления.ОперацииОбменаГИСМ.ПередачаДанныхСписаниеТоваров;
		СообщениеXML.Документ     = ДокументСсылка;
		СообщениеXML.Основание    = Шапка.Основание;
		СообщениеXML.Версия       = НомерВерсииПередачаДанныхСписаниеТоваров;
		
		СообщенияXML.Добавить(СообщениеXML);
		
		#КонецОбласти
		
	КонецЕсли;
	
	Возврат СообщенияXML;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область Отчеты

#КонецОбласти

#КонецОбласти

#КонецЕсли

