
#Область СлужебныеПроцедурыИФункции

// Серверный обработчик события ОбработкаПолученияДанныхВыбора справочника ТранспортныеСредства.
//
Процедура ТранспортныеСредстваОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	Если ЗначениеЗаполнено(Параметры.СтрокаПоиска) Тогда
		ДанныеВыбора = Новый СписокЗначений;
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ТранспортныеСредства.Ссылка КАК Значение,
		|	ПРЕДСТАВЛЕНИЕ(ТранспортныеСредства.Ссылка) КАК Представление
		|ИЗ
		|	Справочник.ТранспортныеСредства КАК ТранспортныеСредства
		|ГДЕ
		|	ТранспортныеСредства.Код ПОДОБНО &Текст
		|
		|УПОРЯДОЧИТЬ ПО
		|	Наименование";
		
		Запрос.УстановитьПараметр("Текст", "%" + СокрЛП(Параметры.СтрокаПоиска) + "%");
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Пока Выборка.Следующий() Цикл
			ДанныеВыбора.Добавить(Выборка.Значение, Выборка.Представление);
		КонецЦикла;
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти