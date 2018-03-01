#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

// Возвращает параметры таможенной декларации - регистрационный номер и признак того, декларировался ли товар в РФ.
// Порядок получения регистрационного номера таможенной декларации см. в описании функции РегистрационныйНомер(). 
// Если РегистрационныйНомер() вернет пустую строку, будет установлен признак, что товар декларировался не в РФ.
//
// Параметры
//    НомерТаможеннойДекларации - номер таможенной декларации или регистрационный номер таможенной декларации.
//
// Возвращаемое значение:
//    Структура 
//      * РегистрационныйНомер - Строка -  регистрационный номер таможенной декларации либо пустая строка, 
//                                         если его не удалось определить.
//      * СтранаВвозаНеРФ      - Булево - признак, что товар декларировался не в РФ.
Функция РегистрационныйНомерИСтранаВвоза(НомерТаможеннойДекларации) Экспорт
	
	СтруктураНомера = РегистрационныйНомер(НомерТаможеннойДекларации);
	
	СтруктураНомера.Вставить("СтранаВвозаНеРФ", НЕ ЗначениеЗаполнено(СтруктураНомера.РегистрационныйНомер));
	
	Возврат СтруктураНомера;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

// Возвращает регистрационный номер таможенной декларции по переданному полному номеру
// декларации на товары.
// Регистрационный номер не будет определен если "полный" номер таможенной декларации не соответствует 
// структуре номера декларации, выдаваемой российскими таможенными органами.
// 
// Регистрационный номер таможенной декларации может быть получен из "полного" номера таможенной декларации
// или регистрационного номера при условиях:
// 1. Длина номера таможенной декларации от 23 до 27 символов.
// 2. Количество элементов, разделенных знаком дробь ("/") 3 или 4.
// 3. Длина первого элемента 8, второго 6, третьего 7, четвертого (при наличии) от 1 до 3 символов.
// 4. Второй элемент можно преобразовать в дату.
// Регистрационный номер таможенной декларации будет получен из "полного" номера таможенной декларации
// путем отсечения последнего (4-го) элемента номера.
//
// Параметры
//    НомерТаможеннойДекларации - номер таможенной декларации или регистрационный номер таможенной декларации.
//
// Возвращаемое значение:
//    Регистрационный номер - Строка - регистрационный номер таможенной декларации либо пустая строка, 
//                                     если его не удалось определить.
Функция РегистрационныйНомер(НомерТаможеннойДекларации)
	
	НомерДекларацииНаТовары = СокрЛП(НомерТаможеннойДекларации);
	СтруктураНомера = Новый Структура("РегистрационныйНомер,ПорядковыйНомерТовара","","");
	
	Если СтрДлина(НомерДекларацииНаТовары) < 23
	 ИЛИ СтрДлина(НомерДекларацииНаТовары) > 27 Тогда
		Возврат СтруктураНомера;
	КонецЕсли;
	
	МассивТД = СтрРазделить(НомерДекларацииНаТовары, "/");
	
	Если МассивТД.Количество() > 4
	 ИЛИ МассивТД.Количество() < 3 Тогда
		// Номер декларации на товары указан с ошибками.
		Возврат СтруктураНомера;
	КонецЕсли;
	
	КодТаможенногоОргана = МассивТД[0];
	
	Если СтрДлина(КодТаможенногоОргана) <> 8 Тогда
		Возврат СтруктураНомера;
	КонецЕсли;
	
	ДатаПринятияДекларацииНаТовары = МассивТД[1];
	
	Если СтрДлина(ДатаПринятияДекларацииНаТовары) <> 6 Тогда
		Возврат СтруктураНомера;
	Иначе
		СтрокаВДату = СтроковыеФункцииКлиентСервер.СтрокаВДату(ДатаПринятияДекларацииНаТовары);
		Если НЕ ЗначениеЗаполнено(СтрокаВДату) Тогда
			Возврат СтруктураНомера;
		КонецЕсли;
	КонецЕсли;

	ПорядковыйНомерДекларацииНаТовары = МассивТД[2];
	
	Если СтрДлина(ПорядковыйНомерДекларацииНаТовары) <> 7 Тогда
		Возврат СтруктураНомера;
	КонецЕсли;
	
	Если МассивТД.Количество() = 4 Тогда
		ПорядковыйНомерТовара = МассивТД[3];
		Если СтрДлина(ПорядковыйНомерТовара) > 3
		 ИЛИ СтрДлина(ПорядковыйНомерТовара) < 1 Тогда
			Возврат СтруктураНомера;
		КонецЕсли;
		СтруктураНомера.ПорядковыйНомерТовара = ПорядковыйНомерТовара;
		МассивТД.Удалить(3);
	КонецЕсли;
	
	СтруктураНомера.РегистрационныйНомер = СтрСоединить(МассивТД, "/");
	
	Возврат СтруктураНомера;
	
КонецФункции

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

// Обработчик обновления УТ 11.4.2,
// заполняет реквизиты "Регистрационный номер", "Порядковый номер товара" и "Страна ввоза не РФ" справочника "НомераГТД"
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НомераГТД.Ссылка
	|ИЗ
	|	Справочник.НомераГТД КАК НомераГТД
	|ГДЕ
	|	НомераГТД.РегистрационныйНомер = """"
	|	И НЕ НомераГТД.СтранаВвозаНеРФ");
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
 	ПолноеИмяОбъекта = "Справочник.НомераГТД";
	МетаданныеСправочника = Метаданные.НайтиПоПолномуИмени(ПолноеИмяОбъекта);
	
	Выборка = ОбновлениеИнформационнойБазы.ВыбратьСсылкиДляОбработки(Параметры.Очередь, ПолноеИмяОбъекта);	
	Пока Выборка.Следующий() Цикл
		НачатьТранзакцию();
		Попытка
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяОбъекта);
			ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.Ссылка);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			Блокировка.Заблокировать();
			
			СправочникОбъект = Выборка.Ссылка.ПолучитьОбъект();
			Если СправочникОбъект = Неопределено Тогда
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Выборка.Ссылка);
				ЗафиксироватьТранзакцию();
				Продолжить;
			КонецЕсли;
		
			ЗаполнитьЗначенияСвойств(СправочникОбъект,РегистрационныйНомерИСтранаВвоза(СправочникОбъект.Код));
		
			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(СправочникОбъект, Истина);
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ТекстСообщения = НСтр("ru = 'Не удалось обработать : %Ссылка% по причине: %Причина%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Ссылка%", Выборка.Ссылка);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Предупреждение,
				МетаданныеСправочника,
				Выборка.Ссылка,
				ТекстСообщения);
			ВызватьИсключение;
		КонецПопытки;
	КонецЦикла;
	Параметры.ОбработкаЗавершена = Не ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Параметры.Очередь, ПолноеИмяОбъекта);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СтранаПроисхождения = Неопределено;
	Параметры.Отбор.Свойство("СтранаПроисхождения", СтранаПроисхождения);

	Если Параметры.СтрокаПоиска = Неопределено Тогда
		Запрос = Новый Запрос("
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ДанныеСправочника.Ссылка КАК Ссылка,
		|	ДанныеСправочника.Представление КАК Представление,
		|	ДанныеСправочника.ПометкаУдаления КАК ПометкаУдаления,
		|	ДанныеСправочника.СтранаПроисхождения.Представление КАК СтранаПредставление
		|ИЗ
		|	Справочник.НомераГТД КАК ДанныеСправочника
		|ГДЕ
		|	Не ДанныеСправочника.Предопределенный
		|");
	Иначе
		Запрос = Новый Запрос("ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 100
		                      |	ПриобретениеТоваровУслугТовары.Номенклатура,
		                      |	ПриобретениеТоваровУслугТовары.Характеристика,
		                      |	ПриобретениеТоваровУслугТовары.НомерГТД,
		                      |	ПриобретениеТоваровУслугТовары.Ссылка,
		                      |	ПриобретениеТоваровУслугТовары.Ссылка.Дата КАК Дата
		                      |ПОМЕСТИТЬ СочетанияНоменклатураГТД
		                      |ИЗ
		                      |	Документ.ПриобретениеТоваровУслуг.Товары КАК ПриобретениеТоваровУслугТовары
		                      |ГДЕ
		                      |	ПриобретениеТоваровУслугТовары.Номенклатура = &Номенклатура
		                      |	И ПриобретениеТоваровУслугТовары.Характеристика = &Характеристика
		                      |	И ПриобретениеТоваровУслугТовары.Ссылка.Проведен
		                      |
		                      |ОБЪЕДИНИТЬ ВСЕ
		                      |
		                      |ВЫБРАТЬ ПЕРВЫЕ 100
		                      |	ОприходованиеИзлишковТоваровТовары.Номенклатура,
		                      |	ОприходованиеИзлишковТоваровТовары.Характеристика,
		                      |	ОприходованиеИзлишковТоваровТовары.НомерГТД,
		                      |	ОприходованиеИзлишковТоваровТовары.Ссылка,
		                      |	ОприходованиеИзлишковТоваровТовары.Ссылка.Дата
		                      |ИЗ
		                      |	Документ.ОприходованиеИзлишковТоваров.Товары КАК ОприходованиеИзлишковТоваровТовары
		                      |ГДЕ
		                      |	ОприходованиеИзлишковТоваровТовары.Номенклатура = &Номенклатура
		                      |	И ОприходованиеИзлишковТоваровТовары.Характеристика = &Характеристика
		                      |	И ОприходованиеИзлишковТоваровТовары.Ссылка.Проведен
		                      |
		                      |ОБЪЕДИНИТЬ ВСЕ
		                      |
		                      |ВЫБРАТЬ ПЕРВЫЕ 100
		                      |	КорректировкаПриобретенияТовары.Номенклатура,
		                      |	КорректировкаПриобретенияТовары.Характеристика,
		                      |	КорректировкаПриобретенияТовары.НомерГТД,
		                      |	КорректировкаПриобретенияТовары.Ссылка,
		                      |	КорректировкаПриобретенияТовары.Ссылка.Дата
		                      |ИЗ
		                      |	Документ.КорректировкаПриобретения.Товары КАК КорректировкаПриобретенияТовары
		                      |ГДЕ
		                      |	КорректировкаПриобретенияТовары.Номенклатура = &Номенклатура
		                      |	И КорректировкаПриобретенияТовары.Характеристика = &Характеристика
		                      |	И КорректировкаПриобретенияТовары.Ссылка.Проведен
		                      |
		                      |ОБЪЕДИНИТЬ ВСЕ
		                      |
		                      |ВЫБРАТЬ ПЕРВЫЕ 100
		                      |	ПересортицаТоваровТовары.Номенклатура,
		                      |	ПересортицаТоваровТовары.Характеристика,
		                      |	ПересортицаТоваровТовары.НомерГТД,
		                      |	ПересортицаТоваровТовары.Ссылка,
		                      |	ПересортицаТоваровТовары.Ссылка.Дата
		                      |ИЗ
		                      |	Документ.ПересортицаТоваров.Товары КАК ПересортицаТоваровТовары
		                      |ГДЕ
		                      |	ПересортицаТоваровТовары.Номенклатура = &Номенклатура
		                      |	И ПересортицаТоваровТовары.Характеристика = &Характеристика
		                      |	И ПересортицаТоваровТовары.Ссылка.Проведен
		                      |
		                      |ОБЪЕДИНИТЬ ВСЕ
		                      |
		                      |ВЫБРАТЬ ПЕРВЫЕ 100
		                      |	ТаможеннаяДекларацияИмпортТовары.Номенклатура,
		                      |	ТаможеннаяДекларацияИмпортТовары.Характеристика,
		                      |	ТаможеннаяДекларацияИмпортТовары.НомерГТД,
		                      |	ТаможеннаяДекларацияИмпортТовары.Ссылка,
		                      |	ТаможеннаяДекларацияИмпортТовары.Ссылка.Дата
		                      |ИЗ
		                      |	Документ.ТаможеннаяДекларацияИмпорт.Товары КАК ТаможеннаяДекларацияИмпортТовары
		                      |ГДЕ
		                      |	ТаможеннаяДекларацияИмпортТовары.Номенклатура = &Номенклатура
		                      |	И ТаможеннаяДекларацияИмпортТовары.Характеристика = &Характеристика
		                      |	И ТаможеннаяДекларацияИмпортТовары.Ссылка.Проведен
		                      |
		                      |УПОРЯДОЧИТЬ ПО
		                      |	Дата УБЫВ
		                      |;
		                      |
		                      |////////////////////////////////////////////////////////////////////////////////
		                      |ВЫБРАТЬ РАЗРЕШЕННЫЕ
		                      |	ДанныеСправочника.Ссылка КАК Ссылка,
		                      |	ДанныеСправочника.Представление КАК Представление,
		                      |	ДанныеСправочника.ПометкаУдаления КАК ПометкаУдаления,
		                      |	ДанныеСправочника.СтранаПроисхождения.Представление КАК СтранаПредставление,
		                      |	МАКСИМУМ(СочетанияНоменклатураГТД.Дата) КАК Порядок
		                      |ИЗ
		                      |	Справочник.НомераГТД КАК ДанныеСправочника
		                      |		ЛЕВОЕ СОЕДИНЕНИЕ СочетанияНоменклатураГТД КАК СочетанияНоменклатураГТД
		                      |		ПО (СочетанияНоменклатураГТД.НомерГТД = ДанныеСправочника.Ссылка)
		                      |ГДЕ
		                      |	ДанныеСправочника.Код ПОДОБНО &СтрокаПоиска
		                      |	И (НЕ &ОтборПоСтране
		                      |			ИЛИ ДанныеСправочника.СтранаПроисхождения = &Страна)
		                      |
		                      |СГРУППИРОВАТЬ ПО
		                      |	ДанныеСправочника.Ссылка,
		                      |	ДанныеСправочника.Представление,
		                      |	ДанныеСправочника.ПометкаУдаления,
		                      |	ДанныеСправочника.СтранаПроисхождения.Представление
		                      |
		                      |УПОРЯДОЧИТЬ ПО
		                      |	Порядок УБЫВ");
		Запрос.УстановитьПараметр("Номенклатура", ?(Параметры.Свойство("Номенклатура"),Параметры.Номенклатура,Неопределено));
		Запрос.УстановитьПараметр("Характеристика", ?(Параметры.Свойство("Характеристика"),Параметры.Характеристика,Неопределено));
		Запрос.УстановитьПараметр("СтрокаПоиска", Параметры.СтрокаПоиска + "%");
		Запрос.УстановитьПараметр("ОтборПоСтране", ЗначениеЗаполнено(СтранаПроисхождения));
		Запрос.УстановитьПараметр("Страна", СтранаПроисхождения);
	КонецЕсли;
	
	ДанныеВыбора = Новый СписокЗначений;
	ВыборкаГТД = Запрос.Выполнить().Выбрать();
	Пока ВыборкаГТД.Следующий() Цикл
		ЭлементВыбора = Новый Структура("Значение, ПометкаУдаления", ВыборкаГТД.Ссылка, ВыборкаГТД.ПометкаУдаления);
		Представление = СокрЛП(ВыборкаГТД.Представление)
			+ ?(ЗначениеЗаполнено(ВыборкаГТД.СтранаПредставление), " (" + ВыборкаГТД.СтранаПредставление + ")", "");
		ДанныеВыбора.Добавить(ЭлементВыбора, Представление);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

