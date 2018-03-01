#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	// Вместо ОбменДанными.Загрузка используется ДополнительныеСвойства.Свойство("ДляПроведения").
	// Данное свойство устанавливается в модуле ПроведениеСервер при интерактивном проведении документа.
	Если НЕ ДополнительныеСвойства.Свойство("ДляПроведения")
		Или ОбменДанными.Загрузка
		Или ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	БлокироватьДляИзменения = Истина;
	ДополнительныеСвойства.ДляПроведения.Вставить("ВалютаУпр", Константы.ВалютаУправленческогоУчета.Получить());
	ДополнительныеСвойства.ДляПроведения.Вставить("ВалютаРегл", Константы.ВалютаРегламентированногоУчета.Получить());
	
	// Текущее состояние набора помещается во временную таблицу,
	// чтобы при записи получить изменение нового набора относительно текущего.
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Записи.Период                     КАК Период,
	|	Записи.Регистратор                КАК Регистратор,
	|	Записи.Организация                КАК Организация,
	|	Записи.ВидПереводаДенежныхСредств КАК ВидПереводаДенежныхСредств,
	|	Записи.Получатель                 КАК Получатель,
	|	Записи.Отправитель                КАК Отправитель,
	|	Записи.Контрагент                 КАК Контрагент,
	|	Записи.Валюта                     КАК Валюта,
	|
	|	Записи.Сумма       КАК Сумма,
	|	Записи.СуммаУпр    КАК СуммаУпр,
	|	Записи.СуммаРегл   КАК СуммаРегл,
	|
	|	Записи.СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств
	|ПОМЕСТИТЬ ДенежныеСредстваВПутиПередЗаписью
	|ИЗ
	|	РегистрНакопления.ДенежныеСредстваВПути КАК Записи
	|ГДЕ
	|	Записи.Регистратор = &Регистратор
	|	И (ТипЗначения(Записи.Регистратор) = ТИП(Документ.РасчетКурсовыхРазниц)
	|		ИЛИ Записи.Валюта <> &ВалютаУпр
	|		ИЛИ Записи.Валюта <> &ВалютаРегл
	|	)
	|");
	
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.УстановитьПараметр("ВалютаУпр", ДополнительныеСвойства.ДляПроведения.ВалютаУпр);
	Запрос.УстановитьПараметр("ВалютаРегл", ДополнительныеСвойства.ДляПроведения.ВалютаРегл);
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Выполнить();
	
	СформироватьТаблицуОбъектовОплаты();
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	// Вместо ОбменДанными.Загрузка используется ДополнительныеСвойства.Свойство("ДляПроведения").
	// Данное свойство устанавливается в модуле ПроведениеСервер при интерактивном проведении документа.
	Если НЕ ДополнительныеСвойства.Свойство("ДляПроведения")
		Или ОбменДанными.Загрузка
		Или ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	// Рассчитывается изменение нового набора относительно текущего с учетом накопленных изменений
	// и помещается во временную таблицу.
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НАЧАЛОПЕРИОДА(Таблица.Период, МЕСЯЦ) КАК МЕСЯЦ,
	|	Таблица.Организация                  КАК Организация,
	|	&Операция                            КАК Операция,
	|	Таблица.Регистратор                  КАК Документ
	|ПОМЕСТИТЬ ДенежныеСредстваВПутиЗаданияКЗакрытиюМесяца
	|ИЗ
	|	(ВЫБРАТЬ
	|		Записи.Период                     КАК Период,
	|		Записи.Регистратор                КАК Регистратор,
	|		Записи.Организация                КАК Организация,
	|		Записи.ВидПереводаДенежныхСредств КАК ВидПереводаДенежныхСредств,
	|		Записи.Получатель                 КАК Получатель,
	|		Записи.Отправитель                КАК Отправитель,
	|		Записи.Контрагент                 КАК Контрагент,
	|		Записи.Валюта                      КАК Валюта,
	|
	|		Записи.Сумма       КАК Сумма,
	|		Записи.СуммаУпр    КАК СуммаУпр,
	|		Записи.СуммаРегл   КАК СуммаРегл,
	|
	|		Записи.СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств
	|	ИЗ
	|		ДенежныеСредстваВПутиПередЗаписью КАК Записи
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|
	|	ВЫБРАТЬ
	|		Записи.Период                     КАК Период,
	|		Записи.Регистратор                КАК Регистратор,
	|		Записи.Организация                КАК Организация,
	|		Записи.ВидПереводаДенежныхСредств КАК ВидПереводаДенежныхСредств,
	|		Записи.Получатель                 КАК Получатель,
	|		Записи.Отправитель                КАК Отправитель,
	|		Записи.Контрагент                 КАК Контрагент,
	|		Записи.Валюта                      КАК Валюта,
	|
	|		-Записи.Сумма       КАК Сумма,
	|		-Записи.СуммаУпр    КАК СуммаУпр,
	|		-Записи.СуммаРегл   КАК СуммаРегл,
	|
	|		Записи.СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств
	|	ИЗ
	|		РегистрНакопления.ДенежныеСредстваВПути КАК Записи
	|	ГДЕ
	|		Записи.Регистратор = &Регистратор
	|		И (ТипЗначения(Записи.Регистратор) = ТИП(Документ.РасчетКурсовыхРазниц)
	|			ИЛИ Записи.Валюта <> &ВалютаУпр
	|			ИЛИ Записи.Валюта <> &ВалютаРегл)
	|	) КАК Таблица
	|
	|СГРУППИРОВАТЬ ПО
	|	НАЧАЛОПЕРИОДА(Таблица.Период, МЕСЯЦ),
	|	Таблица.Период,
	|	Таблица.Регистратор,
	|	Таблица.Организация,
	|	Таблица.ВидПереводаДенежныхСредств,
	|	Таблица.Получатель,
	|	Таблица.Отправитель,
	|	Таблица.Контрагент,
	|	Таблица.Валюта,
	|	Таблица.СтатьяДвиженияДенежныхСредств
	|ИМЕЮЩИЕ
	|	СУММА(Таблица.Сумма) <> 0
	|	ИЛИ СУММА(Таблица.СуммаУпр) <> 0
	|	ИЛИ СУММА(Таблица.СуммаРегл) <> 0
	|");
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.УстановитьПараметр("Операция", Перечисления.ОперацииЗакрытияМесяца.ПереоценкаДенежныхСредствКредитовДепозитовЗаймов);
	Запрос.УстановитьПараметр("ВалютаУпр", ДополнительныеСвойства.ДляПроведения.ВалютаУпр);
	Запрос.УстановитьПараметр("ВалютаРегл", ДополнительныеСвойства.ДляПроведения.ВалютаРегл);
	
	Запрос.Выполнить();
	
	РегистрыСведений.ГрафикПлатежей.РассчитатьГрафикПлатежейПоДенежнымСредствамВПути(ДополнительныеСвойства.ТаблицаОбъектовОплаты);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Формирует таблицу отправителей и получателей, которые были раньше в движениях и которые будут записаны
//
Процедура СформироватьТаблицуОбъектовОплаты()
	
	ВидыПереводовМеждуМестамиХранения = Новый Массив;
	ВидыПереводовМеждуМестамиХранения.Добавить(Перечисления.ВидыПереводовДенежныхСредств.ИнкассацияВБанк);
	ВидыПереводовМеждуМестамиХранения.Добавить(Перечисления.ВидыПереводовДенежныхСредств.ИнкассацияИзБанка);
	ВидыПереводовМеждуМестамиХранения.Добавить(Перечисления.ВидыПереводовДенежныхСредств.ПеремещениеВДругуюКассу);
	ВидыПереводовМеждуМестамиХранения.Добавить(Перечисления.ВидыПереводовДенежныхСредств.ПеречислениеНаДругойСчет);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДенежныеСредстваВПути.Получатель КАК БанковскийСчетКасса,
	|	
	|	ВЫБОР КОГДА ВидПереводаДенежныхСредств В (
	|		ЗНАЧЕНИЕ(Перечисление.ВидыПереводовДенежныхСредств.ИнкассацияВБанк),
	|		ЗНАЧЕНИЕ(Перечисление.ВидыПереводовДенежныхСредств.ИнкассацияИзБанка),
	|		ЗНАЧЕНИЕ(Перечисление.ВидыПереводовДенежныхСредств.ПеречислениеНаДругойСчет),
	|		ЗНАЧЕНИЕ(Перечисление.ВидыПереводовДенежныхСредств.ПеремещениеВДругуюКассу))
	|	ТОГДА
	|		ДенежныеСредстваВПути.Отправитель
	|	КОГДА ВидПереводаДенежныхСредств В (
	|		ЗНАЧЕНИЕ(Перечисление.ВидыПереводовДенежныхСредств.ПоступлениеОтБанкаПоЭквайрингу),
	|		ЗНАЧЕНИЕ(Перечисление.ВидыПереводовДенежныхСредств.ПриобретениеВалюты),
	|		ЗНАЧЕНИЕ(Перечисление.ВидыПереводовДенежныхСредств.РеализацияВалюты))
	|	ТОГДА
	|		ДенежныеСредстваВПути.Контрагент
	|	КОНЕЦ КАК ОбъектОплаты
	|ИЗ
	|	РегистрНакопления.ДенежныеСредстваВПути КАК ДенежныеСредстваВПути
	|ГДЕ
	|	ДенежныеСредстваВПути.Регистратор = &Регистратор
	|	И ВЫБОР КОГДА ВидПереводаДенежныхСредств В (
	|		ЗНАЧЕНИЕ(Перечисление.ВидыПереводовДенежныхСредств.ИнкассацияВБанк),
	|		ЗНАЧЕНИЕ(Перечисление.ВидыПереводовДенежныхСредств.ИнкассацияИзБанка),
	|		ЗНАЧЕНИЕ(Перечисление.ВидыПереводовДенежныхСредств.ПеречислениеНаДругойСчет),
	|		ЗНАЧЕНИЕ(Перечисление.ВидыПереводовДенежныхСредств.ПеремещениеВДругуюКассу))
	|	ТОГДА
	|		ДенежныеСредстваВПути.Отправитель
	|	КОГДА ВидПереводаДенежныхСредств В (
	|		ЗНАЧЕНИЕ(Перечисление.ВидыПереводовДенежныхСредств.ПоступлениеОтБанкаПоЭквайрингу),
	|		ЗНАЧЕНИЕ(Перечисление.ВидыПереводовДенежныхСредств.ПриобретениеВалюты),
	|		ЗНАЧЕНИЕ(Перечисление.ВидыПереводовДенежныхСредств.РеализацияВалюты))
	|	ТОГДА
	|		ДенежныеСредстваВПути.Контрагент
	|	КОНЕЦ <> НЕОПРЕДЕЛЕНО
	|";
	
	ТаблицаОбъектовОплаты = Запрос.Выполнить().Выгрузить();
	
	ТаблицаНовыхОбъектовОплаты = Выгрузить(, "ВидПереводаДенежныхСредств, Получатель, Отправитель, Контрагент");
	ТаблицаНовыхОбъектовОплаты.Свернуть("ВидПереводаДенежныхСредств, Получатель, Отправитель, Контрагент");
	Для Каждого Запись Из ТаблицаНовыхОбъектовОплаты Цикл
		
		СтруктураПоиска = Новый Структура;;
		СтруктураПоиска.Вставить("БанковскийСчетКасса", Запись.Получатель);
		Если ВидыПереводовМеждуМестамиХранения.Найти(Запись.ВидПереводаДенежныхСредств) <> Неопределено Тогда
			Если ЗначениеЗаполнено(Запись.Отправитель) Тогда
				СтруктураПоиска.Вставить("ОбъектОплаты", Запись.Отправитель);
			Иначе
				Продолжить;
			КонецЕсли;
		Иначе
			СтруктураПоиска.Вставить("ОбъектОплаты", Запись.Контрагент);
		КонецЕсли;
		
		Если Не ТаблицаОбъектовОплаты.НайтиСтроки(СтруктураПоиска).Количество() Тогда
			НоваяСтрока = ТаблицаОбъектовОплаты.Добавить();
			НоваяСтрока.ОбъектОплаты = СтруктураПоиска.ОбъектОплаты;
			НоваяСтрока.БанковскийСчетКасса = СтруктураПоиска.БанковскийСчетКасса;
		КонецЕсли;
	КонецЦикла;
	
	ДополнительныеСвойства.Вставить("ТаблицаОбъектовОплаты", ТаблицаОбъектовОплаты);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли