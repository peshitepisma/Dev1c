#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	
	Если ЭтотОбъект.Количество() = 0 Тогда
		Возврат
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	УточняемыеДанные.Организация КАК Организация,
	|	УточняемыеДанные.УчетнаяПолитика КАК УчетнаяПолитика,
	|	УточняемыеДанные.Период КАК Период,
	|	УточняемыеДанные.ПлательщикЕНВД КАК ПлательщикЕНВД,
	|	УточняемыеДанные.ПрименяетсяПБУ18 КАК ПрименяетсяПБУ18
	|ПОМЕСТИТЬ ВТДанныеДляУточнения
	|ИЗ
	|	&Данные КАК УточняемыеДанные";
	Запрос.УстановитьПараметр("Данные", ЭтотОбъект.Выгрузить());
	Запрос.Выполнить(); 
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	УточняемыеДанные.Организация КАК Организация,
	|	УточняемыеДанные.УчетнаяПолитика КАК УчетнаяПолитика,
	|	ВЫБОР
	|		КОГДА УточняемыеДанные.Организация = УточняемыеДанные.Организация.ГоловнаяОрганизация
	|		ТОГДА УточняемыеДанные.УчетнаяПолитика.ПрименяетсяЕНВД
	|		ИНАЧЕ ЕСТЬNULL(УчетнаяПолитикаОрганизаций.ПлательщикЕНВД, ЛОЖЬ)
	|	КОНЕЦ КАК ПлательщикЕНВД,
	|	ВЫБОР
	|		КОГДА УточняемыеДанные.Организация = УточняемыеДанные.Организация.ГоловнаяОрганизация
	|		ТОГДА УточняемыеДанные.УчетнаяПолитика.СистемаНалогообложения = ЗНАЧЕНИЕ(Перечисление.СистемыНалогообложения.Общая)
	|				И УточняемыеДанные.Организация.ЮрФизЛицо = ЗНАЧЕНИЕ(Перечисление.ЮрФизЛицо.ЮрЛицо)
	|		ИНАЧЕ ЕСТЬNULL(УчетнаяПолитикаОрганизаций.ПлательщикНалогаНаПрибыль, ЛОЖЬ)
	|	КОНЕЦ КАК ПлательщикНалогаНаПрибыль,
	|	ВЫБОР
	|		КОГДА УточняемыеДанные.Организация = УточняемыеДанные.Организация.ГоловнаяОрганизация
	|		ТОГДА УточняемыеДанные.УчетнаяПолитика.СистемаНалогообложения = ЗНАЧЕНИЕ(Перечисление.СистемыНалогообложения.Упрощенная)
	|			 И УточняемыеДанные.Организация <> ЗНАЧЕНИЕ(Справочник.Организации.УправленческаяОрганизация)
	|		ИНАЧЕ ЕСТЬNULL(УчетнаяПолитикаОрганизаций.ПрименяетсяУСН, ЛОЖЬ)
	|	КОНЕЦ КАК ПрименяетсяУСН,
	|	ВЫБОР
	|		КОГДА УточняемыеДанные.Организация = УточняемыеДанные.Организация.ГоловнаяОрганизация
	|		ТОГДА УточняемыеДанные.УчетнаяПолитика.ОбъектНалогообложенияУСН = ЗНАЧЕНИЕ(Перечисление.ОбъектыНалогообложенияПоУСН.ДоходыМинусРасходы)
	|			 И УточняемыеДанные.Организация <> ЗНАЧЕНИЕ(Справочник.Организации.УправленческаяОрганизация)
	|		ИНАЧЕ ЕСТЬNULL(УчетнаяПолитикаОрганизаций.ПрименяетсяУСНДоходыМинусРасходы, ЛОЖЬ)
	|	КОНЕЦ КАК ПрименяетсяУСНДоходыМинусРасходы,
	|	ВЫБОР
	|		КОГДА УточняемыеДанные.Организация = УточняемыеДанные.Организация.ГоловнаяОрганизация
	|		ТОГДА УточняемыеДанные.УчетнаяПолитика.ПрименяетсяПБУ18
	|		ИНАЧЕ ЕСТЬNULL(УчетнаяПолитикаОрганизаций.ПрименяетсяПБУ18, ЛОЖЬ)
	|	КОНЕЦ КАК ПрименяетсяПБУ18,
	|	УточняемыеДанные.Период КАК Период
	|ИЗ
	|	ВТДанныеДляУточнения КАК УточняемыеДанные
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.УчетнаяПолитикаОрганизаций КАК УчетнаяПолитикаОрганизаций
	|		ПО УточняемыеДанные.Организация.ГоловнаяОрганизация = УчетнаяПолитикаОрганизаций.Организация
	|			И УточняемыеДанные.Период = УчетнаяПолитикаОрганизаций.Период";
	
	ЭтотОбъект.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ЭтотОбъект.Количество() = 0 Тогда
		Возврат
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	УточняемыеДанные.Период КАК Период,
	|	УточняемыеДанные.Организация КАК Организация,
	|	УточняемыеДанные.УчетнаяПолитика КАК УчетнаяПолитика,
	|	УточняемыеДанные.ПлательщикЕНВД КАК ПлательщикЕНВД,
	|	УточняемыеДанные.ПлательщикНалогаНаПрибыль КАК ПлательщикНалогаНаПрибыль,
	|	УточняемыеДанные.ПрименяетсяУСН КАК ПрименяетсяУСН,
	|	УточняемыеДанные.ПрименяетсяУСНДоходыМинусРасходы КАК ПрименяетсяУСНДоходыМинусРасходы,
	|	УточняемыеДанные.ПрименяетсяПБУ18 КАК ПрименяетсяПБУ18
	|ПОМЕСТИТЬ ВТНовыеДанные
	|ИЗ
	|	&Данные КАК УточняемыеДанные
	|";
	Запрос.УстановитьПараметр("Данные", ЭтотОбъект.Выгрузить());
	Запрос.Выполнить(); 
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НовыеДанные.Период КАК Период,
	|	Организации.Ссылка КАК Организация,
	|	НовыеДанные.УчетнаяПолитика КАК УчетнаяПолитика,
	|	НовыеДанные.ПлательщикЕНВД КАК ПлательщикЕНВД,
	|	НовыеДанные.ПлательщикНалогаНаПрибыль КАК ПлательщикНалогаНаПрибыль,
	|	НовыеДанные.ПрименяетсяУСН КАК ПрименяетсяУСН,
	|	НовыеДанные.ПрименяетсяУСНДоходыМинусРасходы КАК ПрименяетсяУСНДоходыМинусРасходы,
	|	НовыеДанные.ПрименяетсяПБУ18
	|ИЗ
	|	Справочник.Организации КАК Организации
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТНовыеДанные КАК НовыеДанные
	|		ПО Организации.Ссылка.ГоловнаяОрганизация = НовыеДанные.Организация
	|ГДЕ
	|	Организации.Ссылка <> Организации.ГоловнаяОрганизация
	|	И Организации.ГоловнаяОрганизация В
	|			(ВЫБРАТЬ
	|				Организации.Организация
	|			ИЗ
	|				ВТНовыеДанные КАК Организации
	|			ГДЕ
	|				Организации.Организация = Организации.Организация.ГоловнаяОрганизация)";
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
	
		НаборЗаписей = РегистрыСведений.УчетнаяПолитикаОрганизаций.СоздатьНаборЗаписей();
		НаборЗаписей.ОбменДанными.Загрузка = Истина;
		НаборЗаписей.Отбор.Организация.Установить(Выборка.Организация);
		НаборЗаписей.Отбор.Период.Установить(Выборка.Период);
		ЗаполнитьЗначенияСвойств(НаборЗаписей.Добавить(),Выборка);
		НаборЗаписей.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти


#КонецЕсли
