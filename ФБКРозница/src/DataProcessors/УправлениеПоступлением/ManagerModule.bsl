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
	
	Документы.ОтборРазмещениеТоваров.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	
	Обработки.СправочноеРазмещениеНоменклатуры.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

#Область ТекущиеДела

// Заполняет список текущих дел пользователя.
// Описание параметров процедуры см. в ТекущиеДелаСлужебный.НоваяТаблицаТекущихДел()
//
Процедура ПриЗаполненииСпискаТекущихДел(ТекущиеДела) Экспорт
	
	ИмяФормы = "Обработка.УправлениеПоступлением.Форма.Форма";
	
	ОбщиеПараметрыЗапросов = ТекущиеДелаСлужебный.ОбщиеПараметрыЗапросов();
	
	// Определим доступны ли текущему пользователю показатели группы
	Доступность =
		(ОбщиеПараметрыЗапросов.ЭтоПолноправныйПользователь
			Или ПравоДоступа("Просмотр", Метаданные.Обработки.УправлениеПоступлением))
		И ПолучитьФункциональнуюОпцию("ИспользоватьОрдернуюСхемуПриПоступлении");
	
	Если НЕ Доступность Тогда
		Возврат;
	КонецЕсли;
	
	// Расчет показателей.
	// Строка с неуказанным значением склада не учитывается,
	// показатели для остальных складов увеличиваются на количество соглашений с неуказанным складом.
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВсеРаспоряжения.ДокументПоступления) КАК ЗначениеПоказателя,
	|	ВсеРаспоряжения.Склад КАК Склад
	|ПОМЕСТИТЬ ВТРасшифровка
	|ИЗ
	|	(ВЫБРАТЬ
	|		СоглашенияСПоставщиками.Ссылка КАК ДокументПоступления,
	|		СоглашенияСПоставщиками.Склад КАК Склад
	|	ИЗ
	|		Справочник.СоглашенияСПоставщиками КАК СоглашенияСПоставщиками
	|	ГДЕ
	|		СоглашенияСПоставщиками.ВариантПриемкиТоваров = ЗНАЧЕНИЕ(Перечисление.ВариантыПриемкиТоваров.МожетПроисходитьБезЗаказовИНакладных)
	|		И СоглашенияСПоставщиками.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСоглашенийСПоставщиками.Действует)
	|		И НЕ СоглашенияСПоставщиками.ПометкаУдаления
	|		И (СоглашенияСПоставщиками.Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
	|				ИЛИ СоглашенияСПоставщиками.Склад.ИспользоватьОрдернуюСхемуПриПоступлении)
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ТоварыКПоступлению.ДокументПоступления,
	|		ТоварыКПоступлению.Склад
	|	ИЗ
	|		(ВЫБРАТЬ
	|			ТоварыКПоступлениюОстаткиНаДату.ДокументПоступления КАК ДокументПоступления,
	|			ТоварыКПоступлениюОстаткиНаДату.Склад КАК Склад,
	|			МИНИМУМ(ВЫБОР
	|					КОГДА ТоварыКПоступлениюОстаткиНаДату.КОформлениюОрдеровОстаток - ТоварыКПоступлениюОстаткиНаДату.ПринимаетсяОстаток < 0
	|						ТОГДА ИСТИНА
	|					ИНАЧЕ ЛОЖЬ
	|				КОНЕЦ) КАК Перепоставка
	|		ИЗ
	|			РегистрНакопления.ТоварыКПоступлению.Остатки(&ДатаПоступления, Склад.ИспользоватьОрдернуюСхемуПриПоступлении) КАК ТоварыКПоступлениюОстаткиНаДату
	|				ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ТоварыКПоступлению.Остатки(, Склад.ИспользоватьОрдернуюСхемуПриПоступлении) КАК ТоварыКПоступлениюОстаткиТекущие
	|				ПО ТоварыКПоступлениюОстаткиНаДату.ДокументПоступления = ТоварыКПоступлениюОстаткиТекущие.ДокументПоступления
	|					И ТоварыКПоступлениюОстаткиНаДату.Номенклатура = ТоварыКПоступлениюОстаткиТекущие.Номенклатура
	|					И ТоварыКПоступлениюОстаткиНаДату.Характеристика = ТоварыКПоступлениюОстаткиТекущие.Характеристика
	|					И ТоварыКПоступлениюОстаткиНаДату.Склад = ТоварыКПоступлениюОстаткиТекущие.Склад
	|		
	|		СГРУППИРОВАТЬ ПО
	|			ТоварыКПоступлениюОстаткиНаДату.ДокументПоступления,
	|			ТоварыКПоступлениюОстаткиНаДату.Склад) КАК ТоварыКПоступлению
	|	ГДЕ
	|		НЕ ТоварыКПоступлению.Перепоставка) КАК ВсеРаспоряжения
	|
	|СГРУППИРОВАТЬ ПО
	|	ВсеРаспоряжения.Склад
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТРасшифровка.ЗначениеПоказателя + ЕСТЬNULL(ВТРасшифровкаБезСклада.ЗначениеПоказателя, 0) КАК ЗначениеПоказателя,
	|	ВТРасшифровка.Склад КАК Склад
	|ИЗ
	|	ВТРасшифровка КАК ВТРасшифровка
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТРасшифровка КАК ВТРасшифровкаБезСклада
	|		ПО (ВТРасшифровкаБезСклада.Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка))
	|ГДЕ
	|	ВТРасшифровка.Склад <> ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)";
	
	ТекущиеДелаСлужебный.УстановитьОбщиеПараметрыЗапросов(Запрос, ОбщиеПараметрыЗапросов);
	
	Запрос.УстановитьПараметр("ДатаПоступления", КонецДня(ОбщиеПараметрыЗапросов.ТекущаяДата));
	
	Результат = Запрос.Выполнить().Выгрузить();
	
	// Заполнение дел.
	// РаспоряженияНаПоступление
	ДелоРодитель = ТекущиеДела.Добавить();
	ДелоРодитель.Идентификатор  = "РаспоряженияНаПоступление";
	ДелоРодитель.Представление  = НСтр("ru = 'Распоряжения на поступление'");
	ДелоРодитель.Владелец       = Метаданные.Подсистемы.Склад;
	
	Для Каждого СтрокаРезультата Из Результат Цикл
		
		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("Помещение", Неопределено);
		ПараметрыОтбора.Вставить("ЗонаПриемки", Неопределено);
		
		ПредставлениеДела = "";
		ИдентификаторДела = "";
		ЗначениеДела      = 0;
		Для Каждого КолонкаРезультата Из Результат.Колонки Цикл
			ЗначениеКолонки = СтрокаРезультата[КолонкаРезультата.Имя];
			Если КолонкаРезультата.Имя = "ЗначениеПоказателя" Тогда
				ЗначениеДела = ЗначениеКолонки;
				Продолжить;
			КонецЕсли;
			ПредставлениеДела = ?(ПредставлениеДела = "", "", ", ") + Строка(ЗначениеКолонки);
			ИдентификаторДела = ?(ИдентификаторДела = "", ДелоРодитель.Идентификатор, ИдентификаторДела)
				+ СтрЗаменить(Строка(ЗначениеКолонки), " ", "");
			ПараметрыОтбора.Вставить(КолонкаРезультата.Имя, ЗначениеКолонки);
		КонецЦикла;
		
		Дело = ТекущиеДела.Добавить();
		Дело.Идентификатор  = ИдентификаторДела;
		Дело.ЕстьДела       = ЗначениеДела > 0;
		Дело.Представление  = ПредставлениеДела;
		Дело.Количество     = ЗначениеДела;
		Дело.Важное         = Ложь;
		Дело.Форма          = ИмяФормы;
		Дело.ПараметрыФормы = Новый Структура("СтруктураБыстрогоОтбора", ПараметрыОтбора);
		Дело.Владелец       = "РаспоряженияНаПоступление";
		
		Если ЗначениеДела > 0 Тогда
			ДелоРодитель.ЕстьДела = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
