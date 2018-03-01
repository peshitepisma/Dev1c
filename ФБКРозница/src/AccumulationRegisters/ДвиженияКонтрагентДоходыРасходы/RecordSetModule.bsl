#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
		
	Если НЕ ДополнительныеСвойства.Свойство("ДляПроведения") Тогда
		Возврат;
	КонецЕсли;
	
	Если ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("РежимЗаписи") 
		И ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
		Возврат;
	КонецЕсли;
	
	// Текущее состояние набора помещается во временную таблицу,
	// чтобы при записи получить изменение нового набора относительно текущего.
	
	ТекстыЗапросовДляПолученияТаблицыИзменений = 
		ЗакрытиеМесяцаСервер.ТекстыЗапросовДляПолученияТаблицыИзмененийРегистра(ЭтотОбъект.Метаданные());
	
	Запрос = Новый Запрос;
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст = ТекстыЗапросовДляПолученияТаблицыИзменений.ТекстВыборкиНачальныхДанных;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	
	Запрос.Выполнить();
	
	ДополнительныеСвойства.Вставить("ТекстВыборкиТаблицыИзменений", ТекстыЗапросовДляПолученияТаблицыИзменений.ТекстВыборкиТаблицыИзменений);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ДополнительныеСвойства.Свойство("ДляПроведения") Тогда
		Возврат;
	КонецЕсли;
	
	Если ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("РежимЗаписи") 
		И ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
		Возврат;
	КонецЕсли;
	
	// Рассчитывается изменение нового набора относительно текущего с учетом накопленных изменений
	// и помещается во временную таблицу для последующей записи в регистрах заданий.
	Запрос = Новый Запрос;
	Запрос.Текст = ДополнительныеСвойства.ТекстВыборкиТаблицыИзменений;
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	
	
	Запрос.Текст = Запрос.Текст + ОбщегоНазначения.РазделительПакетаЗапросов() +
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НАЧАЛОПЕРИОДА(ТаблицаИзменений.Период, МЕСЯЦ) КАК Месяц,
	|	ТаблицаИзменений.Регистратор КАК Документ,
	|	ТаблицаИзменений.Организация,
	|	ЗНАЧЕНИЕ(Перечисление.ОперацииЗакрытияМесяца.РаспределениеНДС) КАК Операция
	|ПОМЕСТИТЬ ДвиженияКонтрагентДоходыРасходыЗаданияКЗакрытиюМесяца
	|ИЗ
	|	ТаблицаИзмененийДвиженияКонтрагентДоходыРасходы КАК ТаблицаИзменений
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.РаспределениеНДС КАК РаспределениеНДС
	|		ПО (НАЧАЛОПЕРИОДА(ТаблицаИзменений.Период, МЕСЯЦ) = НАЧАЛОПЕРИОДА(РаспределениеНДС.Дата, МЕСЯЦ))
	|			И ТаблицаИзменений.Организация = РаспределениеНДС.Организация
	|			И (РаспределениеНДС.Проведен)
	|ГДЕ
	|	ТаблицаИзменений.ХозяйственнаяОперация В (ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.НачисленияПоЗаймамВыданным), ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияОС), ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияНМА), ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияПрочихУслуг))
	|
	|СГРУППИРОВАТЬ ПО
	|	НАЧАЛОПЕРИОДА(ТаблицаИзменений.Период, МЕСЯЦ),
	|	ТаблицаИзменений.Регистратор,
	|	ТаблицаИзменений.Организация
	|
	|ИМЕЮЩИЕ
	|	СУММА(ТаблицаИзменений.СуммаРеглБезНДС) <> 0
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НАЧАЛОПЕРИОДА(КОНЕЦПЕРИОДА(ТаблицаИзменений.Период, КВАРТАЛ), МЕСЯЦ),
	|	ТаблицаИзменений.Регистратор,
	|	ТаблицаИзменений.Организация,
	|	ЗНАЧЕНИЕ(Перечисление.ОперацииЗакрытияМесяца.РаспределениеНДС)
	|ИЗ
	|	ТаблицаИзмененийДвиженияКонтрагентДоходыРасходы КАК ТаблицаИзменений
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.РаспределениеНДС КАК РаспределениеНДС
	|		ПО (КОНЕЦПЕРИОДА(ТаблицаИзменений.Период, КВАРТАЛ) = КОНЕЦПЕРИОДА(РаспределениеНДС.Дата, МЕСЯЦ))
	|			И ТаблицаИзменений.Организация = РаспределениеНДС.Организация
	|			И (РаспределениеНДС.Проведен)
	|ГДЕ
	|	ТаблицаИзменений.ХозяйственнаяОперация В (ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.НачисленияПоЗаймамВыданным), ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияОС), ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияНМА), ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияПрочихУслуг))
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаИзменений.Регистратор,
	|	ТаблицаИзменений.Организация,
	|	НАЧАЛОПЕРИОДА(КОНЕЦПЕРИОДА(ТаблицаИзменений.Период, КВАРТАЛ), МЕСЯЦ)
	|
	|ИМЕЮЩИЕ
	|	СУММА(ТаблицаИзменений.СуммаРеглБезНДС) <> 0";
	
	// Уничтожаем таблицу изменений регистра:
	Запрос.Текст = Запрос.Текст + ОбщегоНазначения.РазделительПакетаЗапросов() + "УНИЧТОЖИТЬ ТаблицаИзмененийДвиженияКонтрагентДоходыРасходы";
	
	Запрос.Выполнить();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
