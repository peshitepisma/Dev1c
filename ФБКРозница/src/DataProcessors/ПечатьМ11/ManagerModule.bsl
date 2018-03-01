#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область Печать

// Сформировать печатные формы объектов
//
// ВХОДЯЩИЕ:
// 		ИменаМакетов    - Строка    - Имена макетов, перечисленные через запятую
// 		МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать
// 		ПараметрыПечати - Структура - Структура дополнительных параметров печати
//
// ИСХОДЯЩИЕ:
// 		КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы
// 		ПараметрыВывода       - Структура        - Параметры сформированных табличных документов
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	СтруктураТипов = ОбщегоНазначенияУТ.СоответствиеМассивовПоТипамОбъектов(МассивОбъектов);
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "М11") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"М11",
			НСтр("ru='Требование-накладная (М-11)'"),
			СформироватьПечатнуюФормуМ11(
				СтруктураТипов,
				ОбъектыПечати,
				ПараметрыПечати));
		
	КонецЕсли;
	
КонецПроцедуры // Печать()

// Функция формирует печатную форму "М-11"
//
Функция СформироватьПечатнуюФормуМ11(СтруктураТипов, ОбъектыПечати, ПараметрыПечати) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ОриентацияСтраницы  = ОриентацияСтраницы.Ландшафт;
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_М11";
	
	НомерТипаДокумента = 0;
	
	Для Каждого СтруктураОбъектов Из СтруктураТипов Цикл
		
		НомерТипаДокумента = НомерТипаДокумента + 1;
		Если НомерТипаДокумента > 1 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(СтруктураОбъектов.Ключ);
		ДанныеДляПечати = МенеджерОбъекта.ПолучитьДанныеДляПечатнойФормыМ11(
			ПараметрыПечати,
			СтруктураОбъектов.Значение);
		
		ЗаполнитьТабличныйДокументМ11(ТабличныйДокумент, ДанныеДляПечати, ОбъектыПечати);
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции // СформироватьПечатнуюФормуСчетНаОплату()

// Процедура заполняет табличный документ "М-11"
//
Процедура ЗаполнитьТабличныйДокументМ11(ТабличныйДокумент, ДанныеДляПечати, ОбъектыПечати)
	
	ШаблонОшибкиТовары = НСтр("ru = 'В документе %1 отсутствуют товары. Печать М-11 не требуется'");
	
	ТоварКод = ФормированиеПечатныхФорм.ИмяДополнительнойКолонки();
	Если Не ЗначениеЗаполнено(ТоварКод) Тогда
		ТоварКод = "Код";
	КонецЕсли;
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Обработка.ПечатьМ11.ПФ_MXL_М11");
	
	ПервыйДокумент = Истина;
	ВыборкаДокументы = ДанныеДляПечати.РезультатПоШапке.Выбрать();
	ВыборкаПоТабличнымЧастям = ДанныеДляПечати.РезультатПоТабличнойЧасти.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	СтруктураОтбора = Новый Структура("Ссылка");
	
	Пока ВыборкаДокументы.Следующий() Цикл
		
		СтруктураОтбора.Ссылка = ВыборкаДокументы.Ссылка;
		ВыборкаПоТабличнымЧастям.Сбросить();
		Если НЕ ВыборкаПоТабличнымЧастям.НайтиСледующий(СтруктураОтбора) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					ШаблонОшибкиТовары,
					ВыборкаДокументы.Ссылка
				),
				ВыборкаДокументы.Ссылка);
			Продолжить;
		КонецЕсли;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ВыборкаПоСкладам = ВыборкаПоТабличнымЧастям.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Пока ВыборкаПоСкладам.Следующий() Цикл
			
			Если Не ПервыйДокумент Тогда
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			КонецЕсли;
			ПервыйДокумент = Ложь;
			НомерСтраницы   = 1;
			НомерСтроки = 0;
			
			// Создаем массив для проверки вывода
			МассивВыводимыхОбластей = Новый Массив;
			
			ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
			
			//Вывод шапки.
			ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
			ШтрихкодированиеПечатныхФорм.ВывестиШтрихкодВТабличныйДокумент(ТабличныйДокумент, Макет, ОбластьШапка, ВыборкаДокументы.Ссылка);
			ОбластьШапка.Параметры.Заголовок = НСтр("ru = 'ТРЕБОВАНИЕ-НАКЛАДНАЯ №'") + ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ВыборкаДокументы.Номер, Ложь, Истина);
			ОбластьШапка.Параметры.Заполнить(ВыборкаДокументы);
			ОбластьШапка.Параметры.Заполнить(ВыборкаПоСкладам);
			ОбластьШапка.Параметры.ПредставлениеПодразделения = ВыборкаДокументы.Подразделение;
			
			СведенияОбОрганизации = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ВыборкаДокументы.Организация, ВыборкаДокументы.ДатаДокумента);
			ОбластьШапка.Параметры.ПредставлениеОрганизации = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОбОрганизации);
			ОбластьШапка.Параметры.КодОКПО = СведенияОбОрганизации.КодПоОКПО;
			ТабличныйДокумент.Вывести(ОбластьШапка);
			
			ВыборкаПоСтрокам = ВыборкаПоСкладам.Выбрать();
			КоличествоСтрок = ВыборкаПоСтрокам.Количество();
			Пока ВыборкаПоСтрокам.Следующий() Цикл
				
				Область = Макет.ПолучитьОбласть("Строка");
				Область.Параметры.Заполнить(ВыборкаПоСтрокам);
				
				НомерСтроки = НомерСтроки + 1;
				
				МассивВыводимыхОбластей.Очистить();
				МассивВыводимыхОбластей.Добавить(Область);
				
				Если НомерСтроки = КоличествоСтрок Тогда
					МассивВыводимыхОбластей.Добавить(ОбластьПодвал);
				КонецЕсли;
				
				Если ТоварКод = "Артикул" Тогда
					Область.Параметры.НоменклатурныйНомер = ВыборкаПоСтрокам.НоменклатурныйНомерАртикул;
				Иначе
					Область.Параметры.НоменклатурныйНомер = ВыборкаПоСтрокам.НоменклатурныйНомерКод;
				КонецЕсли;
				
				Область.Параметры.МатериалНаименование = НоменклатураКлиентСервер.ПредставлениеНоменклатурыДляПечати(
					СокрЛП(ВыборкаПоСтрокам.НоменклатураНаименование),
					СокрЛП(ВыборкаПоСтрокам.Характеристика));
					
				Если НЕ ТабличныйДокумент.ПроверитьВывод(МассивВыводимыхОбластей) Тогда
					НомерСтраницы = НомерСтраницы + 1;
					ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
					УстановитьПараметр(ОбластьШапка, "НомерСтраницы", "Страница " + НомерСтраницы);
					ТабличныйДокумент.Вывести(ОбластьШапка);
				КонецЕсли;
					
				ТабличныйДокумент.Вывести(Область);
				
			КонецЦикла;
			
			// Вывод подвала.
			ОбластьПодвал.Параметры.ДолжностьОтправителя = ВыборкаПоСкладам.ДолжностьКладовщикаОтправителя;
			ОбластьПодвал.Параметры.ФИООтправителя = ФизическиеЛицаУТ.ФамилияИнициалыФизЛица(ВыборкаПоСкладам.КладовщикОтправитель, ВыборкаДокументы.ДатаДокумента);
			ТабличныйДокумент.Вывести(ОбластьПодвал);
		
		КонецЦикла;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ВыборкаДокументы.Ссылка);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура УстановитьПараметр(ОбластьМакета, ИмяПараметра, ЗначениеПараметра)
	ОбластьМакета.Параметры.Заполнить(Новый Структура(ИмяПараметра, ЗначениеПараметра));
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
