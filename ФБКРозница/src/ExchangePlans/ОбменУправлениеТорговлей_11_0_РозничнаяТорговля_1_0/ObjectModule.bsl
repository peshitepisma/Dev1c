#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	// Очистка неиспользуемых реквизитов
	
	Если НЕ ИспользоватьОтборПоВидамЦенНоменклатуры И ВидыЦенНоменклатуры.Количество() <> 0 Тогда
		ВидыЦенНоменклатуры.Очистить();
	ИначеЕсли ИспользоватьОтборПоВидамЦенНоменклатуры И ВидыЦенНоменклатуры.Количество() = 0 Тогда
		ИспользоватьОтборПоВидамЦенНоменклатуры = Ложь;
	КонецЕсли;
	
	Если НЕ ИспользоватьОтборПоЭквайринговымТерминалам И ЭквайринговыеТерминалы.Количество() <> 0 Тогда
		ЭквайринговыеТерминалы.Очистить();
	ИначеЕсли ИспользоватьОтборПоЭквайринговымТерминалам И ЭквайринговыеТерминалы.Количество() = 0 Тогда
		ИспользоватьОтборПоЭквайринговымТерминалам = Ложь;
	КонецЕсли;
	
	Если НЕ ИспользоватьОтборПоКассам И Кассы.Количество() <> 0 Тогда
		Кассы.Очистить();
	ИначеЕсли ИспользоватьОтборПоКассам И Кассы.Количество() = 0 Тогда
		ИспользоватьОтборПоКассам = Ложь;
	КонецЕсли;
	
	Если НЕ ИспользоватьОтборПоОрганизациям И Организации.Количество() <> 0 Тогда
		Организации.Очистить();
	ИначеЕсли ИспользоватьОтборПоОрганизациям И Организации.Количество() = 0 Тогда
		ИспользоватьОтборПоОрганизациям = Ложь;
	КонецЕсли;
	
	Если НЕ ИспользоватьОтборПоСкладам И Склады.Количество() <> 0 Тогда
		Склады.Очистить();
	ИначеЕсли ИспользоватьОтборПоСкладам И Склады.Количество() = 0 Тогда
		ИспользоватьОтборПоСкладам = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли