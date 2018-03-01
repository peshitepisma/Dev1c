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
	
	СозданиеНаОснованииПереопределяемый.ДобавитьКомандуСоздатьНаОснованииБизнесПроцессЗадание(КомандыСозданияНаОсновании);
	Команда = Документы.ЗаписьКнигиПродаж.ДобавитьКомандуСоздатьНаОснованииИсправлениеПрочегоНачисленияНДС(КомандыСозданияНаОсновании);
	Если Команда <> Неопределено Тогда
		ПодключаемыеКоманды.ДобавитьУсловиеВидимостиКоманды(Команда, "ХозяйственнаяОперация", 
					Перечисления.ХозяйственныеОперации.ПрочееНачислениеНДС, ВидСравненияКомпоновкиДанных.Равно);
	КонецЕсли;
	
КонецПроцедуры

// Добавляет команду создания документа "Запись книги продаж".
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Функция ДобавитьКомандуСоздатьНаОснованииИсправлениеПрочегоНачисленияНДС(КомандыСозданияНаОсновании) Экспорт
	Если ПравоДоступа("Добавление", Метаданные.Документы.СчетФактураВыданный) Тогда
		КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Обработчик = "СозданиеНаОснованииУТКлиент.ИсправлениеПрочегоНачисленияНДС";
		КомандаСоздатьНаОсновании.Идентификатор = "ИсправлениеПрочегоНачисленияНДС";
		КомандаСоздатьНаОсновании.Представление = НСтр("ru = 'Исправление прочего начисления НДС'");
		КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
		
		Возврат КомандаСоздатьНаОсновании;
		
	КонецЕсли;
	
	Возврат Неопределено;
КонецФункции

// Добавляет команду создания документа "Запись книги продаж".
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	Если ПравоДоступа("Добавление", Метаданные.Документы.ЗаписьКнигиПродаж) Тогда
		КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Менеджер = Метаданные.Документы.ЗаписьКнигиПродаж.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ОбщегоНазначенияУТ.ПредставлениеОбъекта(Метаданные.Документы.ЗаписьКнигиПродаж);
		КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
		КомандаСоздатьНаОсновании.ФункциональныеОпции = "ФормироватьОтчетностьПоНДС";
		
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

// Заполняет таблицу реквизитов, зависимых от хозяйственной операции
//
// Параметры:
//	ХозяйственнаяОперация - ПеречислениеСсылка.ХозяйственныеОперации - хозяйственная операция соглашения
//	МассивВсехРеквизитов - Массив - реквизиты, которые не зависят от хозяйственной операции
//	МассивРеквизитовОперации - Массив - реквизиты, которые зависят от хозяйственной операции
//
Процедура ЗаполнитьИменаРеквизитовПоХозяйственнойОперации(ХозяйственнаяОперация, МассивВсехРеквизитов, МассивРеквизитовОперации) Экспорт
	
	МассивВсехРеквизитов = Новый Массив;
	МассивВсехРеквизитов.Добавить("ДокументРасчетов");
	МассивВсехРеквизитов.Добавить("ИсправляемыйДокумент");
	МассивВсехРеквизитов.Добавить("Грузоотправитель");
	МассивВсехРеквизитов.Добавить("Грузополучатель");
	МассивВсехРеквизитов.Добавить("Грузополучатель");
	МассивВсехРеквизитов.Добавить("Руководитель");
	МассивВсехРеквизитов.Добавить("ГлавныйБухгалтер");
	МассивВсехРеквизитов.Добавить("ЗаписьДополнительногоЛиста");
	МассивВсехРеквизитов.Добавить("КорректируемыйПериод");
	
	МассивВсехРеквизитов.Добавить("Ценности.Номенклатура");
	МассивВсехРеквизитов.Добавить("Ценности.Количество");
	МассивВсехРеквизитов.Добавить("Ценности.Цена");
	МассивВсехРеквизитов.Добавить("Ценности.НомерГТД");
	
	МассивРеквизитовОперации = Новый Массив;
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПрочееНачислениеНДС Тогда
		
		МассивРеквизитовОперации.Добавить("Грузоотправитель");
		МассивРеквизитовОперации.Добавить("Грузополучатель");
		МассивРеквизитовОперации.Добавить("Грузополучатель");
		МассивРеквизитовОперации.Добавить("Руководитель");
		МассивРеквизитовОперации.Добавить("ГлавныйБухгалтер");
		
		МассивРеквизитовОперации.Добавить("ЗаписьДополнительногоЛиста");
		МассивРеквизитовОперации.Добавить("КорректируемыйПериод");
		
		МассивРеквизитовОперации.Добавить("Ценности.Номенклатура");
		МассивРеквизитовОперации.Добавить("Ценности.Количество");
		МассивРеквизитовОперации.Добавить("Ценности.Цена");
		МассивРеквизитовОперации.Добавить("Ценности.НомерГТД");
		
	ИначеЕсли ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ИсправлениеПрочегоНачисленияНДС Тогда
		
		МассивРеквизитовОперации.Добавить("ИсправляемыйДокумент");
		
		МассивРеквизитовОперации.Добавить("Грузоотправитель");
		МассивРеквизитовОперации.Добавить("Грузополучатель");
		МассивРеквизитовОперации.Добавить("Грузополучатель");
		МассивРеквизитовОперации.Добавить("Руководитель");
		МассивРеквизитовОперации.Добавить("ГлавныйБухгалтер");
		
		МассивРеквизитовОперации.Добавить("Ценности.Номенклатура");
		МассивРеквизитовОперации.Добавить("Ценности.Количество");
		МассивРеквизитовОперации.Добавить("Ценности.Цена");
		МассивРеквизитовОперации.Добавить("Ценности.НомерГТД");
		
	ИначеЕсли ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВосстановлениеНДС Тогда
		
		МассивРеквизитовОперации.Добавить("ДокументРасчетов");
		МассивРеквизитовОперации.Добавить("ЗаписьДополнительногоЛиста");
		МассивРеквизитовОперации.Добавить("КорректируемыйПериод");
		
	КонецЕсли;
	
КонецПроцедуры

// Возвращает текст запроса для расчета необходимости ввода счета-фактуры выданного.
//	Возвращаемое значение:
//		Строка - текст запроса
//
Функция ТекстЗапросаДляРасчетаНеобходимостиСчетаФактуры() Экспорт
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка      КАК Основание,
	|	ДанныеДокумента.Дата        КАК ДатаДокумента,
	|	ДанныеДокумента.Организация КАК Организация,
	|	ДанныеДокумента.Контрагент  КАК Контрагент,
	|	ДанныеДокумента.Валюта      КАК Валюта,
	|	МАКСИМУМ(ВЫБОР
	|		КОГДА ТаблицаСчетовФактуры.СчетФактура ЕСТЬ NULL 
	|				И ДанныеДокумента.Проведен
	|				И %ТекстУсловия%
	|			ТОГДА
	|				ВЫБОР 
	|					КОГДА УчетнаяПолитика.ПрименяетсяОсвобождениеОтУплатыНДС
	|						ТОГДА ИСТИНА
	|					КОГДА НЕ ТоварыСНДС.Ссылка ЕСТЬ NULL
	|						ТОГДА ИСТИНА
	|					ИНАЧЕ ЛОЖЬ
	|				КОНЕЦ
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ)                       КАК Требуется
	|//ОператорПОМЕСТИТЬ
	|ИЗ
	|	Документ.ЗаписьКнигиПродаж КАК ДанныеДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаСчетовФактуры КАК ТаблицаСчетовФактуры
	|		ПО ДанныеДокумента.Ссылка = ТаблицаСчетовФактуры.Основание
	|			И ДанныеДокумента.Организация = ТаблицаСчетовФактуры.Организация
	|			И ДанныеДокумента.Контрагент = ТаблицаСчетовФактуры.Контрагент
	|		ЛЕВОЕ СОЕДИНЕНИЕ УчетнаяПолитика КАК УчетнаяПолитика
	|		ПО ДанныеДокумента.Ссылка = УчетнаяПолитика.Ссылка
	|			И ДанныеДокумента.Организация = УчетнаяПолитика.Организация
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаписьКнигиПродаж.Ценности КАК ТоварыСНДС
	|		ПО ДанныеДокумента.Ссылка = ТоварыСНДС.Ссылка
	|			И ТоварыСНДС.СтавкаНДС <> ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.БезНДС)
	|ГДЕ
	|	ДанныеДокумента.Ссылка В (&МассивОснований)
	|
	|СГРУППИРОВАТЬ ПО
	|	ДанныеДокумента.Ссылка,
	|	ДанныеДокумента.Дата,
	|	ДанныеДокумента.Организация,
	|	ДанныеДокумента.Контрагент,
	|	ДанныеДокумента.Валюта
	|";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%ТекстУсловия%", ТекстУсловияТребуетсяСчетФактура());
	
	Возврат ТекстЗапроса;
	
КонецФункции

// Возвращает текст условия запроса, по которым документу требуется счет-фактура.
// Условие применяется для таблица "ДанныеДокумента", содержащую реквизиты документа.
//
//	Возвращаемое значение:
//		Строка - текст условия запроса
//
Функция ТекстУсловияТребуетсяСчетФактура() Экспорт
	
	ТекстУсловия =
	"ДанныеДокумента.ХозяйственнаяОперация В (ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПрочееНачислениеНДС), 
	|										  ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ИсправлениеПрочегоНачисленияНДС))";
	
	Возврат ТекстУсловия;
	
КонецФункции

// Заполняет табличную часть "Расхождения"
//
// Параметры:
// 	Объект - ДокументОбъект.ЗаписьКнигиПродаж - Документ для которого необходимо заполнить расхождения
//
Процедура ЗаполнитьРасхождения(Объект) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ЗаписьКнигиПродаж.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ ДанныеПоследнегоИсправления
	|ИЗ
	|	Документ.ЗаписьКнигиПродаж КАК ЗаписьКнигиПродаж
	|ГДЕ
	|	ЗаписьКнигиПродаж.Проведен
	|	И ЗаписьКнигиПродаж.Ссылка <> &Ссылка
	|	И ЗаписьКнигиПродаж.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ИсправлениеПрочегоНачисленияНДС)
	|	И ЗаписьКнигиПродаж.ИсправляемыйДокумент = &ИсправляемыйДокумент
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЗаписьКнигиПродаж.МоментВремени УБЫВ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаЦенности.ВидЦенности		КАК ВидЦенности,
	|	ТаблицаЦенности.Сумма			КАК Сумма,
	|	ТаблицаЦенности.СтавкаНДС		КАК СтавкаНДС,
	|	ТаблицаЦенности.СуммаНДС		КАК СуммаНДС,
	|	ТаблицаЦенности.СчетУчета		КАК СчетУчета,
	|	ТаблицаЦенности.Субконто1		КАК Субконто1,
	|	ТаблицаЦенности.Субконто2		КАК Субконто2,
	|	ТаблицаЦенности.Субконто3		КАК Субконто3
	|
	|ПОМЕСТИТЬ ИсходныеДанные
	|ИЗ
	|	Документ.ЗаписьКнигиПродаж.Ценности КАК ТаблицаЦенности
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ДанныеПоследнегоИсправления КАК ДанныеПоследнегоИсправления
	|		ПО ТаблицаЦенности.Ссылка = ДанныеПоследнегоИсправления.Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТаблицаЦенности.ВидЦенности		КАК ВидЦенности,
	|	ТаблицаЦенности.Сумма			КАК Сумма,
	|	ТаблицаЦенности.СтавкаНДС		КАК СтавкаНДС,
	|	ТаблицаЦенности.СуммаНДС		КАК СуммаНДС,
	|	ТаблицаЦенности.СчетУчета		КАК СчетУчета,
	|	ТаблицаЦенности.Субконто1		КАК Субконто1,
	|	ТаблицаЦенности.Субконто2		КАК Субконто2,
	|	ТаблицаЦенности.Субконто3		КАК Субконто3
	|ИЗ
	|	Документ.ЗаписьКнигиПродаж.Ценности КАК ТаблицаЦенности
	|		ЛЕВОЕ СОЕДИНЕНИЕ ДанныеПоследнегоИсправления КАК ДанныеПоследнегоИсправления
	|		ПО ИСТИНА
	|ГДЕ
	|	ДанныеПоследнегоИсправления.Ссылка ЕСТЬ NULL
	|	И ТаблицаЦенности.Ссылка = &ИсправляемыйДокумент
	|;
	|
	|ВЫБРАТЬ
	|	НовыеДанные.ВидЦенности			КАК ВидЦенности,
	|	НовыеДанные.Сумма				КАК Сумма,
	|	НовыеДанные.СтавкаНДС			КАК СтавкаНДС,
	|	НовыеДанные.СуммаНДС			КАК СуммаНДС,
	|	НовыеДанные.СчетУчета			КАК СчетУчета,
	|	НовыеДанные.Субконто1			КАК Субконто1,
	|	НовыеДанные.Субконто2			КАК Субконто2,
	|	НовыеДанные.Субконто3			КАК Субконто3
	|ПОМЕСТИТЬ НовыеДанныеИзТаблицы
	|ИЗ
	|	&НовыеДанные КАК НовыеДанные
	|;
	|
	|ВЫБРАТЬ
	|	ИсходныеДанные.ВидЦенности							КАК ВидЦенности,
	|	-ИсходныеДанные.Сумма								КАК Сумма,
	|	ИсходныеДанные.СтавкаНДС							КАК СтавкаНДС,
	|	-ИсходныеДанные.СуммаНДС							КАК СуммаНДС,
	|	ИсходныеДанные.СчетУчета							КАК СчетУчета,
	|	ИсходныеДанные.Субконто1							КАК Субконто1,
	|	ИсходныеДанные.Субконто2							КАК Субконто2,
	|	ИсходныеДанные.Субконто3							КАК Субконто3
	|ПОМЕСТИТЬ ДанныеДляРасхождения
	|ИЗ
	|	ИсходныеДанные КАК ИсходныеДанные
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	НовыеДанныеИзТаблицы.ВидЦенности					КАК ВидЦенности,
	|	НовыеДанныеИзТаблицы.Сумма							КАК Сумма,
	|	НовыеДанныеИзТаблицы.СтавкаНДС						КАК СтавкаНДС,
	|	НовыеДанныеИзТаблицы.СуммаНДС						КАК СуммаНДС,
	|	НовыеДанныеИзТаблицы.СчетУчета						КАК СчетУчета,
	|	НовыеДанныеИзТаблицы.Субконто1						КАК Субконто1,
	|	НовыеДанныеИзТаблицы.Субконто2						КАК Субконто2,
	|	НовыеДанныеИзТаблицы.Субконто3						КАК Субконто3
	|ИЗ
	|	НовыеДанныеИзТаблицы КАК НовыеДанныеИзТаблицы
	|;
	|
	|ВЫБРАТЬ
	|	ДанныеДляРасхождения.ВидЦенности					КАК ВидЦенности,
	|	ДанныеДляРасхождения.СтавкаНДС						КАК СтавкаНДС,
	|	ДанныеДляРасхождения.СчетУчета						КАК СчетУчета,
	|	ДанныеДляРасхождения.Субконто1						КАК Субконто1,
	|	ДанныеДляРасхождения.Субконто2						КАК Субконто2,
	|	ДанныеДляРасхождения.Субконто3						КАК Субконто3,
	|	СУММА(ДанныеДляРасхождения.Сумма)					КАК Сумма,
	|	СУММА(ДанныеДляРасхождения.СуммаНДС)				КАК СуммаНДС
	|ИЗ
	|	ДанныеДляРасхождения
	|	
	|СГРУППИРОВАТЬ ПО
	|	ДанныеДляРасхождения.ВидЦенности,
	|	ДанныеДляРасхождения.СтавкаНДС,
	|	ДанныеДляРасхождения.СчетУчета,
	|	ДанныеДляРасхождения.Субконто1,
	|	ДанныеДляРасхождения.Субконто2,
	|	ДанныеДляРасхождения.Субконто3
	|
	|ИМЕЮЩИЕ
	|	СУММА(ДанныеДляРасхождения.Сумма) <> 0
	|	ИЛИ СУММА(ДанныеДляРасхождения.СуммаНДС) <> 0
	|";
	Запрос.УстановитьПараметр("НовыеДанные",          Объект.Ценности.Выгрузить());
	Запрос.УстановитьПараметр("ИсправляемыйДокумент", Объект.ИсправляемыйДокумент);
	Запрос.УстановитьПараметр("Ссылка",               Объект.Ссылка);
	
	Объект.Расхождения.Загрузить(Запрос.Выполнить().Выгрузить());
	
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
	
	ТекстЗапросаТаблицаНДСЗаписиКнигиПродаж(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаТаблицаСуммыДокументовВВалютеРегл(Запрос, ТекстыЗапроса, Регистры);
	
	ПроведениеСерверУТ.ИнициализироватьТаблицыДляДвижений(Запрос, ТекстыЗапроса, ДополнительныеСвойства.ТаблицыДляДвижений, Истина);
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДанныеДокумента.Дата КАК Период,
		|	ДанныеДокумента.Организация КАК Организация,
		|	ДанныеДокумента.Контрагент КАК Контрагент,
		|	ДанныеДокумента.ДокументРасчетов КАК ДокументРасчетов,
		|	ДанныеДокумента.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
		|	ДанныеДокумента.КодВидаОперации КАК КодВидаОперации,
		|	ДанныеДокумента.Валюта КАК Валюта,
		|	ДанныеДокумента.ЗаписьДополнительногоЛиста КАК ЗаписьДополнительногоЛиста,
		|	ДанныеДокумента.ФормироватьСторнирующиеЗаписиДопЛистовВручную КАК ФормироватьСторнирующиеЗаписиДопЛистовВручную,
		|	ВЫБОР
		|		КОГДА ДанныеДокумента.ЗаписьДополнительногоЛиста
		|			ТОГДА ДанныеДокумента.КорректируемыйПериод
		|		ИНАЧЕ ДАТАВРЕМЯ(1, 1, 1)
		|	КОНЕЦ КАК КорректируемыйПериод
		|ИЗ
		|	Документ.ЗаписьКнигиПродаж КАК ДанныеДокумента
		|ГДЕ
		|	ДанныеДокумента.Ссылка = &Ссылка";
	
	Реквизиты = Запрос.Выполнить().Выбрать();
	Реквизиты.Следующий();
	
	Коэффициенты = РаботаСКурсамивалютУТ.ПолучитьКоэффициентыПересчетаВалюты(Реквизиты.Валюта, Реквизиты.Валюта, Реквизиты.Период);
	
	Запрос.УстановитьПараметр("Период",							Реквизиты.Период);
	Запрос.УстановитьПараметр("Организация",					Реквизиты.Организация);
	Запрос.УстановитьПараметр("Контрагент",						Реквизиты.Контрагент);
	Запрос.УстановитьПараметр("СчетФактура",					?(ЗначениеЗаполнено(Реквизиты.ДокументРасчетов), Реквизиты.ДокументРасчетов, ДокументСсылка));
	Запрос.УстановитьПараметр("Валюта",							Реквизиты.Валюта);
	Запрос.УстановитьПараметр("КодВидаОперации",				Реквизиты.КодВидаОперации);
	Запрос.УстановитьПараметр("ЗаписьДополнительногоЛиста",		Реквизиты.ЗаписьДополнительногоЛиста);
	Запрос.УстановитьПараметр("КорректируемыйПериод",			Реквизиты.КорректируемыйПериод);
	Запрос.УстановитьПараметр("ВалютаРеглУчета",				Константы.ВалютаРегламентированногоУчета.Получить());
	Запрос.УстановитьПараметр("КоэффициентПересчетаВВалютуРегл",Коэффициенты.КоэффициентПересчетаВВалютуРегл);
	Запрос.УстановитьПараметр("КоэффициентПересчетаВВалютуУпр", Коэффициенты.КоэффициентПересчетаВВалютуУпр);
	Запрос.УстановитьПараметр("ХозяйственнаяОперация",			Реквизиты.ХозяйственнаяОперация);
	Запрос.УстановитьПараметр("ЭтоКорректировкаНДС",			ЗначениеЗаполнено(Реквизиты.ДокументРасчетов));
	
КонецПроцедуры

Функция ТекстЗапросаТаблицаНДСЗаписиКнигиПродаж(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "НДСЗаписиКнигиПродаж";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли; 

	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	&Период КАК Период,
	|	&Организация КАК Организация,
	|	&Контрагент КАК Покупатель,
	|	&СчетФактура КАК СчетФактура,
	|	ТаблицаЦенности.ВидЦенности КАК ВидЦенности,
	|	ТаблицаЦенности.Событие КАК Событие,
	|	&Период КАК ДатаСобытия,
	|	ТаблицаЦенности.СтавкаНДС КАК СтавкаНДС,
	|	СУММА(ВЫБОР
	|			КОГДА &Валюта = &ВалютаРеглУчета
	|				ТОГДА ТаблицаЦенности.Сумма
	|			ИНАЧЕ ВЫРАЗИТЬ(ТаблицаЦенности.Сумма * &КоэффициентПересчетаВВалютуРегл КАК ЧИСЛО(15, 2))
	|		КОНЕЦ) КАК СуммаБезНДС,
	|	СУММА(ВЫБОР
	|			КОГДА &Валюта = &ВалютаРеглУчета
	|				ТОГДА ТаблицаЦенности.СуммаНДС
	|			ИНАЧЕ ВЫРАЗИТЬ(ТаблицаЦенности.СуммаНДС * &КоэффициентПересчетаВВалютуРегл КАК ЧИСЛО(15, 2))
	|		КОНЕЦ) КАК НДС,
	|	&ЗаписьДополнительногоЛиста КАК ЗаписьДополнительногоЛиста,
	|	&КорректируемыйПериод КАК КорректируемыйПериод,
	|	ВЫБОР
	|		КОГДА &ЗаписьДополнительногоЛиста 
	|				И &ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВосстановлениеНДС)
	|			ТОГДА ТаблицаЦенности.СторнирующаяЗаписьДопЛиста
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК СторнирующаяЗаписьДопЛиста,
	|	НЕОПРЕДЕЛЕНО КАК НомерДокументаОплаты,
	|	НЕОПРЕДЕЛЕНО КАК ДатаДокументаОплаты,
	|	&КодВидаОперации КАК КодВидаОперации
	|ИЗ
	|	Документ.ЗаписьКнигиПродаж.Ценности КАК ТаблицаЦенности
	|ГДЕ
	|	ТаблицаЦенности.Ссылка = &Ссылка
	|	И &ХозяйственнаяОперация В (
	|			ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПрочееНачислениеНДС),
	|			ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВосстановлениеНДС))
	|	
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаЦенности.СтавкаНДС,
	|	ТаблицаЦенности.ВидЦенности,
	|	ТаблицаЦенности.Событие,
	|	ВЫБОР
	|		КОГДА &ЗаписьДополнительногоЛиста 
	|			И &ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВосстановлениеНДС)
	|			ТОГДА ТаблицаЦенности.СторнирующаяЗаписьДопЛиста
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	&Период КАК Период,
	|	&Организация КАК Организация,
	|	&Контрагент КАК Покупатель,
	|	&СчетФактура КАК СчетФактура,
	|	ТаблицаЦенности.ВидЦенности КАК ВидЦенности,
	|	ТаблицаЦенности.Событие КАК Событие,
	|	&Период КАК ДатаСобытия,
	|	ТаблицаЦенности.СтавкаНДС КАК СтавкаНДС,
	|	0 КАК СуммаБезНДС,
	|	0 КАК НДС,
	|	&ЗаписьДополнительногоЛиста КАК ЗаписьДополнительногоЛиста,
	|	&КорректируемыйПериод КАК КорректируемыйПериод,
	|	ВЫБОР
	|		КОГДА &ЗаписьДополнительногоЛиста 
	|				И &ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВосстановлениеНДС)
	|			ТОГДА ТаблицаЦенности.СторнирующаяЗаписьДопЛиста
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК СторнирующаяЗаписьДопЛиста,
	|	ЕСТЬNULL(ДанныеПервичныхДокументов.Номер, ДокументыОплаты.ДокументОплаты.Номер) КАК НомерДокументаОплаты,
	|	ЕСТЬNULL(ДанныеПервичныхДокументов.Дата, ДокументыОплаты.ДокументОплаты.Дата) КАК ДатаДокументаОплаты,
	|	&КодВидаОперации КАК КодВидаОперации
	|ИЗ
	|	Документ.ЗаписьКнигиПродаж.Ценности КАК ТаблицаЦенности
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.ЗаписьКнигиПродаж.ДокументыОплаты КАК ДокументыОплаты
	|	ПО
	|		ТаблицаЦенности.Ссылка = ДокументыОплаты.Ссылка
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.ДанныеПервичныхДокументов КАК ДанныеПервичныхДокументов
	|	ПО
	|		ДанныеПервичныхДокументов.Организация = &Организация
	|		И ДокументыОплаты.ДокументОплаты = ДанныеПервичныхДокументов.Документ
	|ГДЕ
	|	ТаблицаЦенности.Ссылка = &Ссылка
	|	И &ХозяйственнаяОперация В (
	|			ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПрочееНачислениеНДС),
	|			ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВосстановлениеНДС))
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;

КонецФункции

Функция ТекстЗапросаТаблицаСуммыДокументовВВалютеРегл(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "СуммыДокументовВВалютеРегл";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ТаблицаДокумента.НомерСтроки КАК НомерСтроки,
	|	&Период КАК Период,
	|	&Валюта КАК Валюта,
	|	ТаблицаДокумента.ИдентификаторСтроки КАК ИдентификаторСтроки,
	|	ТаблицаДокумента.Сумма КАК СуммаБезНДС,
	|	ТаблицаДокумента.СтавкаНДС КАК СтавкаНДС,
	|	ТаблицаДокумента.СуммаНДС КАК СуммаНДС,
	|	ТаблицаДокумента.Сумма * &КоэффициентПересчетаВВалютуРегл КАК СуммаБезНДСРегл,
	|	ТаблицаДокумента.СуммаНДС * &КоэффициентПересчетаВВалютуРегл КАК СуммаНДСРегл,
	|	ТаблицаДокумента.Сумма * &КоэффициентПересчетаВВалютуУпр КАК СуммаБезНДСУпр,
	|	ТаблицаДокумента.СуммаНДС * &КоэффициентПересчетаВВалютуУпр КАК СуммаНДСУпр,
	|	НЕОПРЕДЕЛЕНО КАК ТипРасчетов
	|
	|ИЗ
	|	Документ.ЗаписьКнигиПродаж.Ценности КАК ТаблицаДокумента
	|
	|ГДЕ
	|	ТаблицаДокумента.Ссылка = &Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТаблицаДокумента.НомерСтроки КАК НомерСтроки,
	|	&Период КАК Период,
	|	&Валюта КАК Валюта,
	|	ТаблицаДокумента.ИдентификаторСтроки КАК ИдентификаторСтроки,
	|	ТаблицаДокумента.Сумма КАК СуммаБезНДС,
	|	ТаблицаДокумента.СтавкаНДС КАК СтавкаНДС,
	|	ТаблицаДокумента.СуммаНДС КАК СуммаНДС,
	|	ТаблицаДокумента.Сумма * &КоэффициентПересчетаВВалютуРегл КАК СуммаБезНДСРегл,
	|	ТаблицаДокумента.СуммаНДС * &КоэффициентПересчетаВВалютуРегл КАК СуммаНДСРегл,
	|	ТаблицаДокумента.Сумма * &КоэффициентПересчетаВВалютуУпр КАК СуммаБезНДСУпр,
	|	ТаблицаДокумента.СуммаНДС * &КоэффициентПересчетаВВалютуУпр КАК СуммаНДСУпр,
	|	НЕОПРЕДЕЛЕНО КАК ТипРасчетов
	|
	|ИЗ
	|	Документ.ЗаписьКнигиПродаж.Расхождения КАК ТаблицаДокумента
	|
	|ГДЕ
	|	ТаблицаДокумента.Ссылка = &Ссылка
	|	И &ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ИсправлениеПрочегоНачисленияНДС)
	|";
	
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

	// Счет-фактура
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "Обработка.ПечатьОбщихФорм";
	КомандаПечати.Идентификатор = "СчетФактура";
	КомандаПечати.Представление = НСтр("ru = 'Счет-фактура'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КомандаПечати.ДополнительныеПараметры.Вставить("ПечатьВВалюте", Ложь);

КонецПроцедуры

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати - Структура - дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы (выходной параметр)
//  ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                            представление - имя области в которой был выведен объект (выходной параметр);
//  ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов (выходной параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
КонецПроцедуры

// Формирует временную таблицу, содержащую табличную часть по таблице данных документов.
//
// Параметры:
//	МенеджерВременныхТаблиц - МенеджерВременныхТаблиц - Менеджер временных таблиц, содержащий таблицу ТаблицаДанныхДокументов с полями:
//		Ссылка,
//		Валюта.
//
//	ПараметрыЗаполнения - Структура - структура, возвращаемая функцией ПродажиСервер.ПараметрыЗаполненияВременнойТаблицыТоваров
//
Процедура ПоместитьВременнуюТаблицуТоваров(МенеджерВременныхТаблиц, ПараметрыЗаполнения = Неопределено) Экспорт
	
	Если ПараметрыЗаполнения = Неопределено Тогда
		ПараметрыЗаполнения = ПродажиСервер.ПараметрыЗаполненияВременнойТаблицыТоваров();
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("ПересчитыватьВВалютуРегл", ПараметрыЗаполнения.ПересчитыватьВВалютуРегл);
	Запрос.УстановитьПараметр("ВключаяНомераГТД",         ПараметрыЗаполнения.ВключаяНомераГТД);
	Запрос.УстановитьПараметр("ПустаяХарактеристика",     Справочники.ХарактеристикиНоменклатуры.ПустаяСсылка());
	Запрос.УстановитьПараметр("ПустаяУпаковка",           Справочники.УпаковкиЕдиницыИзмерения.ПустаяСсылка());
	Запрос.УстановитьПараметр("ПустаяГТД",                Справочники.НомераГТД.ПустаяСсылка());
	
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ТаблицаДокумента.Ссылка                                 КАК Ссылка,
	|	ТаблицаДокумента.НомерСтроки                            КАК НомерСтроки,
	|	ТаблицаДокумента.Номенклатура                           КАК Номенклатура,
	|	ВЫБОР
	|		КОГДА
	|			ТаблицаДокумента.Номенклатура = ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|		ТОГДА
	|			ТаблицаДокумента.ВидЦенности
	|		ИНАЧЕ
	|			""""
	|	КОНЕЦ КАК Содержание,
	|	&ПустаяХарактеристика                                   КАК Характеристика,
	|	ВЫБОР КОГДА &ВключаяНомераГТД ТОГДА
	|		ТаблицаДокумента.НомерГТД
	|	ИНАЧЕ
	|		&ПустаяГТД
	|	КОНЕЦ КАК НомерГТД,
	|	ТаблицаДокумента.КодТНВЭД                               КАК КодТНВЭД,
	|	&ПустаяУпаковка                                         КАК Упаковка,
	|	ТаблицаДокумента.Количество                             КАК Количество,
	|	ТаблицаДокумента.Количество                             КАК КоличествоУпаковок,
	|	ТаблицаДокумента.Цена                                   КАК Цена,
	|	
	|	ЕСТЬNULL(
	|		СуммыДокументовВВалютеРегл.СуммаБезНДСРегл,
	|		ТаблицаДокумента.Сумма
	|	) КАК СуммаБезНДС,
	|	
	|	ТаблицаДокумента.СтавкаНДС                              КАК СтавкаНДС,
	|	
	|	ЕСТЬNULL(
	|		СуммыДокументовВВалютеРегл.СуммаНДСРегл,
	|		ТаблицаДокумента.СуммаНДС
	|	) КАК СуммаНДС,
	|	
	|	ВЫБОР КОГДА ТаблицаДокумента.Номенклатура.ТипНоменклатуры В
	|				(ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар),
	|				ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара))
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ                                                   КАК ЭтоТовар,
	|	ЛОЖЬ                                                    КАК ВернутьМногооборотнуюТару
	|
	|ПОМЕСТИТЬ ЗаписьКнигиПродажТаблицаТоваров
	|ИЗ
	|	Документ.ЗаписьКнигиПродаж.Ценности КАК ТаблицаДокумента
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		ТаблицаДанныхДокументов КАК ДанныеДокументов
	|	ПО
	|		ТаблицаДокумента.Ссылка = ДанныеДокументов.Ссылка
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.СуммыДокументовВВалютеРегл КАК СуммыДокументовВВалютеРегл
	|	ПО
	|		ТаблицаДокумента.Ссылка = СуммыДокументовВВалютеРегл.Регистратор
	|		И ТаблицаДокумента.ИдентификаторСтроки = СуммыДокументовВВалютеРегл.ИдентификаторСтроки
	|		И СуммыДокументовВВалютеРегл.Активность
	|		И &ПересчитыватьВВалютуРегл
	|";
	
	Запрос.Выполнить();
	
КонецПроцедуры

// Формирует текст запроса для получения данных основания при печати Счет-фактуры.
//
Функция ТекстЗапросаДанныхОснованияДляПечатнойФормыСчетФактура() Экспорт
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ДанныеДокументов.Ссылка                                   КАК Ссылка,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПустаяСсылка) КАК ХозяйственнаяОперация,
	|	ДанныеДокументов.Валюта                                   КАК Валюта,
	|	ДанныеДокументов.Организация                              КАК Организация,
	|	НЕОПРЕДЕЛЕНО                                              КАК НалогообложениеНДС,
	|	НЕОПРЕДЕЛЕНО                                              КАК Подразделение,
	|	ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)                  КАК Склад,
	|	ДанныеДокументов.Грузоотправитель                         КАК Грузоотправитель,
	|	ДанныеДокументов.Грузополучатель                          КАК Грузополучатель,
	|	ЛОЖЬ                                                      КАК РасчетыЧерезОтдельногоКонтрагента,
	|	НЕОПРЕДЕЛЕНО                                              КАК Номенклатура,
	|	""""                                                      КАК Содержание,
	|	ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)             КАК Комиссионер,
	|	НЕОПРЕДЕЛЕНО                                              КАК Основание,
	|	НЕОПРЕДЕЛЕНО                                              КАК ОснованиеДата,
	|	НЕОПРЕДЕЛЕНО                                              КАК ОснованиеНомер,
	|	НЕОПРЕДЕЛЕНО                                              КАК ДоверенностьНомер,
	|	НЕОПРЕДЕЛЕНО                                              КАК ДоверенностьДата,
	|	НЕОПРЕДЕЛЕНО                                              КАК ДоверенностьВыдана,
	|	НЕОПРЕДЕЛЕНО                                              КАК ДоверенностьЛицо,
	|	НЕОПРЕДЕЛЕНО                                              КАК Кладовщик,
	|	НЕОПРЕДЕЛЕНО                                              КАК ДолжностьКладовщика
	|
	|//ОператорПОМЕСТИТЬ
	|ИЗ
	|	Документ.ЗаписьКнигиПродаж КАК ДанныеДокументов
	|ГДЕ
	|	ДанныеДокументов.Ссылка В (&ДокументОснование_ЗаписьКнигиПродаж)";
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

#КонецОбласти

#КонецОбласти

#КонецЕсли
