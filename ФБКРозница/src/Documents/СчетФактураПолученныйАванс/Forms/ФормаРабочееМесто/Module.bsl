
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	УстановитьЗначенияПоУмолчанию();
	УстановитьЗначенияПоПараметрамФормы(Параметры);
	ОбновитьДанныеФормы();
	
	Элементы.ТаблицаВыданныеАвансыСуммаАвансаРегл.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Сумма (%1)'"), ВалютаРеглУчета);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	МассивМенеджеровРасчетаСмТакжеВРаботе = Новый Массив();
	МассивМенеджеровРасчетаСмТакжеВРаботе.Добавить("Обработка.ЖурналДокументовНДС");
	СмТакжеВРаботе = ОбщегоНазначенияУТ.СформироватьГиперссылкуСмТакжеВРаботе(МассивМенеджеровРасчетаСмТакжеВРаботе, Неопределено);
	ИспользоватьНесколькоОрганизаций = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций");

	УчетНДСУТ.НастроитьСовместныйВыборКонтрагентовОрганизаций(Элементы.ОтборПоставщик, ОтборПоставщик);
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НачалоПериодаПриИзменении(Элемент)
	
	ОбновитьДанныеФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура КонецПериодаПриИзменении(Элемент)
	
	ОбновитьДанныеФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОбновитьДанныеФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура СмТакжеВРаботеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	// &ЗамерПроизводительности
	ИмяКлючевойОперации = СтрШаблон("Обработка.СчетФактураПолученныйАванс.Форма.ФормаРабочееМесто.СмТакже.%1",
									НавигационнаяСсылкаФорматированнойСтроки);
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, ИмяКлючевойОперации);
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	СтруктураБыстрогоОтбора = Новый Структура;
	
	Если ЗначениеЗаполнено(Организация) Тогда
		СтруктураБыстрогоОтбора.Вставить("Организация", Организация);
		ПараметрыФормы.Вставить("Организация", Организация);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ОтборПоставщик) Тогда
		СтруктураБыстрогоОтбора.Вставить("Контрагент", ОтборПоставщик);
	КонецЕсли;
	
	ТекущаяДата = ОбщегоНазначенияКлиент.ДатаСеанса();
	Период = Новый СтандартныйПериод;
	Период.ДатаНачала = НачалоПериода;
	Период.ДатаОкончания = КонецПериода;
	СтруктураБыстрогоОтбора.Вставить("Период", Период);
	СтруктураБыстрогоОтбора.Вставить("НачалоПериода", ?(ЗначениеЗаполнено(Период.ДатаНачала), Период.ДатаНачала, НачалоКвартала(ТекущаяДата)));
	ПараметрыФормы.Вставить("НачалоПериода", СтруктураБыстрогоОтбора.НачалоПериода);
	СтруктураБыстрогоОтбора.Вставить("КонецПериода", ?(ЗначениеЗаполнено(Период.ДатаОкончания), Период.ДатаОкончания, КонецКвартала(ТекущаяДата)));
	ПараметрыФормы.Вставить("КонецПериода", СтруктураБыстрогоОтбора.КонецПериода);
	
	ПараметрыФормы.Вставить("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	
	ОткрытьФорму(НавигационнаяСсылкаФорматированнойСтроки, ПараметрыФормы,ЭтаФорма, ЭтаФорма.УникальныйИдентификатор);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВыданныеАвансы

&НаКлиенте
Процедура ОтборСостояниеПриИзменении(Элемент)
	
	Если ОтборСостояние = "ТребуетсяРегистрацияСчетаФактуры" Тогда
		Элементы.ТаблицаВыданныеАвансы.ОтборСтрок = Новый ФиксированнаяСтруктура("СчетФактура",ПредопределенноеЗначение("Документ.СчетФактураПолученныйАванс.ПустаяСсылка"));
		ОтборПоставщик = Неопределено;
	Иначе
		Элементы.ТаблицаВыданныеАвансы.ОтборСтрок = Неопределено
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПоставщикПриИзменении(Элемент)
	
	Если ОтборПоставщик = Неопределено Тогда
		ОтборПоставщик = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.Контрагенты.ПустаяСсылка");
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ОтборПоставщик) Тогда
		Элементы.ТаблицаВыданныеАвансы.ОтборСтрок = Неопределено
	Иначе	
		Элементы.ТаблицаВыданныеАвансы.ОтборСтрок = Новый ФиксированнаяСтруктура("Поставщик",ОтборПоставщик);
		ОтборСостояние = "ВсеВыплаченныеАвансы";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыданныеАвансыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Поле.Родитель = Элементы.ГруппаРеквизитыПлатежногоДокумента Тогда
		ОткрытьПлатежныйДокументАванс()
	Иначе	
	    ВвестиСчетФактуруПолученныйАванс();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьПериод(Команда)
	
	ПараметрыВыбора = Новый Структура("НачалоПериода,КонецПериода", НачалоПериода, КонецПериода);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПериодЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериода", ПараметрыВыбора, Элементы.ВыбратьПериод, , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ВвестиСчетФактуруПолученныйАвансВыполнить(Команда)
	
	ВвестиСчетФактуруПолученныйАванс();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПлатежныйДокументАвансВыполнить(Команда)
	
	ОткрытьПлатежныйДокументАванс();
	
КонецПроцедуры

&НаКлиенте
Процедура АктуализироватьРасчеты(Команда)
	
	КодОтвета = Неопределено;
	ПоказатьВопрос(
		Новый ОписаниеОповещения("АктуализироватьРасчетыЗавершение", ЭтотОбъект), 
		НСтр("ru = 'Актуализировать расчеты с поставщиками?'"), 
		РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура АктуализироватьРасчетыЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	КодОтвета = РезультатВопроса;
	Если КодОтвета = КодВозвратаДиалога.Да Тогда
		
		АктуализироватьРасчетыСервер();
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Расчеты актуализированы'"),
			, // НавигационнаяСсылка
			НСтр("ru = 'Расчеты с поставщиками актуализированы'"));
			
		АктуальностьГраницыРасчетов = Истина;
		Элементы.ГруппаАктуальностьРасчетов.Видимость = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.ТаблицаВыданныеАвансы);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.ТаблицаВыданныеАвансы, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.ТаблицаВыданныеАвансы);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПолучениеДанныхФормы

&НаСервере
Процедура ЗаполнитьВыданныеАвансы()
	
	Результат = Документы.СчетФактураПолученныйАванс.ПолучитьВыданныеАвансы(Организация, НачалоПериода, КонецПериода);
	
	ВыданныеАвансы.Загрузить(Результат);
	
КонецПроцедуры

#КонецОбласти

#Область АвансыВыданные

&НаСервере
Процедура ОбновитьДанныеСтрокиВыданныхАвансов(ДокументОснование, Поставщик)
	
	РеквизитыСчетФактуры = Новый Структура;
	РеквизитыСчетФактуры.Вставить("НомерСчетаФактуры", "");
	РеквизитыСчетФактуры.Вставить("ДатаСчетаФактуры",  '00010101');
	РеквизитыСчетФактуры.Вставить("СуммаСчетаФактуры", 0);
	РеквизитыСчетФактуры.Вставить("СчетФактура",       Неопределено);
	
	// Получим данные счета-фактуры
	Запрос = Новый Запрос;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СчетФактураПолученныйАванс.Ссылка          КАК СчетФактура,
	|	СчетФактураПолученныйАванс.Номер           КАК НомерСчетаФактуры,
	|	СчетФактураПолученныйАванс.ДатаСоставления КАК ДатаСчетаФактуры,
	|	СчетФактураПолученныйАванс.Сумма           КАК СуммаСчетаФактуры
	|ИЗ
	|	Документ.СчетФактураПолученныйАванс КАК СчетФактураПолученныйАванс
	|ГДЕ
	|	СчетФактураПолученныйАванс.ДокументОснование = &ДокументОснование
	|	И СчетФактураПолученныйАванс.Контрагент = &Поставщик
	|	И СчетФактураПолученныйАванс.Проведен";
	 
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
	Запрос.УстановитьПараметр("Поставщик",        Поставщик);
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(РеквизитыСчетФактуры, Выборка);
	КонецЕсли; 
	
	// Аванс может быть в разных валютах, в этом случае будет несколько строк
	СписокАвансов = ВыданныеАвансы.НайтиСтроки(Новый Структура("ДокументОснование, Поставщик", ДокументОснование, Поставщик));
	Для каждого ЭлКоллекции Из СписокАвансов Цикл
		ЗаполнитьЗначенияСвойств(ЭлКоллекции, РеквизитыСчетФактуры);
	КонецЦикла; 
	
КонецПроцедуры

&НаКлиенте
Процедура ВвестиСчетФактуруПолученныйАванс()

	ТекущиеДанные = Элементы.ТаблицаВыданныеАвансы.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.СчетФактура.Пустая() Тогда
		
		Если Не ЗначениеЗаполнено(Организация) И ИспользоватьНесколькоОрганизаций Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Выберите организацию'"), , "Организация");
			Возврат;
		КонецЕсли;
		
		СтруктураОснования = Новый Структура;
		СтруктураОснования.Вставить("Организация",       Организация);
		СтруктураОснования.Вставить("ДокументОснование", ТекущиеДанные.ДокументОснование);
		СтруктураОснования.Вставить("Контрагент",        ТекущиеДанные.Поставщик);
		СтруктураОснования.Вставить("Валюта",            ВалютаРеглУчета);
		СтруктураОснования.Вставить("Дата",              ТекущиеДанные.Дата);
		СтруктураОснования.Вставить("Сумма",             ТекущиеДанные.СуммаАвансаРегл);
		
		ПараметрыФормы = Новый Структура("Основание", СтруктураОснования);
	Иначе
		ПараметрыФормы = Новый Структура("Ключ", ТекущиеДанные.СчетФактура);
	КонецЕсли; 
	
	ОткрытьФорму("Документ.СчетФактураПолученныйАванс.ФормаОбъекта", ПараметрыФормы,,,,, Новый ОписаниеОповещения("ВвестиСчетФактуруПолученныйАвансЗавершение", ЭтотОбъект, Новый Структура("ТекущиеДанные", ТекущиеДанные)), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ВвестиСчетФактуруПолученныйАвансЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    ТекущиеДанные = ДополнительныеПараметры.ТекущиеДанные;
    
    
    ОбновитьДанныеСтрокиВыданныхАвансов(ТекущиеДанные.ДокументОснование, ТекущиеДанные.Поставщик);

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПлатежныйДокументАванс()

	ТекущиеДанные = Элементы.ТаблицаВыданныеАвансы.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИмяТаблицы = ИмяТаблицыПоСсылке(ТекущиеДанные.ДокументОснование);
	
	ОткрытьФорму(ИмяТаблицы + ".ФормаОбъекта", Новый Структура("Ключ", ТекущиеДанные.ДокументОснование))
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаКлиенте
Процедура ВыбратьПериодЗавершение(РезультатВыбора, ДопПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ЗаполнитьЗначенияСвойств(ЭтаФорма, РезультатВыбора, "НачалоПериода,КонецПериода");
	
	ОбновитьДанныеФормы();
	
КонецПроцедуры

&НаСервере
Функция ИмяТаблицыПоСсылке(Ссылка)
	
	Возврат ОбщегоНазначения.ИмяТаблицыПоСсылке(Ссылка);
	
КонецФункции

&НаСервере
Процедура УстановитьЗначенияПоУмолчанию()

	ВалютаРеглУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	НачалоПериода = НачалоКвартала(ТекущаяДатаСеанса());
	КонецПериода = КонецКвартала(ТекущаяДатаСеанса());
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДанныеФормы()

	УстановитьАктуальностьГраницыРасчетов();
	
	ЗаполнитьВыданныеАвансы();
	
	Если ОтборСостояние = "ТребуетсяРегистрацияСчетаФактуры" Тогда
		Элементы.ТаблицаВыданныеАвансы.ОтборСтрок = Новый ФиксированнаяСтруктура("СчетФактура",
						ПредопределенноеЗначение("Документ.СчетФактураПолученныйАванс.ПустаяСсылка"));
		ОтборПоставщик = Неопределено;
	Иначе
		ОтборСостояние = "ВсеВыплаченныеАвансы";
	КонецЕсли;
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьТекстЗаголовка(Форма)
	
	ЗаголовокОтчета = НСтр("ru='Учет НДС с выплаченных авансов'")
		+ БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(Форма.НачалоПериода, Форма.КонецПериода);
	
	Форма.Заголовок = ЗаголовокОтчета;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьАктуальностьГраницыРасчетов()
	
	ПериодРасчета = КонецМесяца(КонецПериода);
	
	ПоляОтбора = Новый Структура("Организация, Партнер, Контрагент, Договор");
	ПоляОтбора.Организация = Организация;
	АналитикиРасчета = РаспределениеВзаиморасчетовВызовСервера.АналитикиРасчета();
	АналитикиРасчета.АналитикиУчетаПоПартнерам = РаспределениеВзаиморасчетовВызовСервера.МассивКлючейПартнеровПоОтбору(ПоляОтбора);
	
	УстановитьПривилегированныйРежим(Истина);
	НачалоРасчета = РаспределениеВзаиморасчетовВызовСервера.НачалоРасчетов(ПериодРасчета, АналитикиРасчета, "РасчетыСПоставщиками");
	УстановитьПривилегированныйРежим(Ложь);
	
	Если НЕ ЗначениеЗаполнено(НачалоРасчета) ИЛИ НачалоРасчета > ПериодРасчета Тогда
		АктуальностьГраницыРасчетов = Истина;
	Иначе
		АктуальностьГраницыРасчетов = Ложь;
	КонецЕсли;
	Элементы.ГруппаАктуальностьРасчетов.Видимость = НЕ АктуальностьГраницыРасчетов;
	
КонецПроцедуры

&НаСервере
Процедура АктуализироватьРасчетыСервер()
	
	АналитикиРасчета = РаспределениеВзаиморасчетовВызовСервера.АналитикиРасчета();
	РаспределениеВзаиморасчетовВызовСервера.РаспределитьВсеРасчетыСПоставщиками(КонецМесяца(КонецПериода) + 1, АналитикиРасчета);
	ЗаполнитьВыданныеАвансы();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗначенияПоПараметрамФормы(Параметры)

	СтруктураБыстрогоОтбора = Неопределено;
	Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	
	Если СтруктураБыстрогоОтбора <> Неопределено Тогда
		СтруктураБыстрогоОтбора.Свойство("Организация", Организация);
		СтруктураБыстрогоОтбора.Свойство("НачалоПериода", НачалоПериода);
		СтруктураБыстрогоОтбора.Свойство("КонецПериода", КонецПериода);
		СтруктураБыстрогоОтбора.Свойство("ОтборСостояние", ОтборСостояние);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
