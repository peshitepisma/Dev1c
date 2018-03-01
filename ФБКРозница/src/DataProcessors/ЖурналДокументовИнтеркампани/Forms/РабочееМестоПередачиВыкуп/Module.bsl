
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	// Возврат при получении формы для анализа.
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	РегистрыНакопления.РезервыТоваровОрганизаций.ВыполнитьСверткуРегистраРезервыТоваровОрганизаций();
	
	ВосстановитьНастройки(Параметры);
	
	НастроитьФорму(Параметры);
	
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если Не ЗавершениеРаботы Тогда
		СохранитьНастройки();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ПередачаТоваровМеждуОрганизациями"
		Тогда
		
		УправлениеЭлементамиФормы();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	
	ПериодПриИзмененииСервер();
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправительПриИзменении(Элемент)
	
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучательПриИзменении(Элемент)
	
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура СкладПриИзменении(Элемент)
	
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантОформленияПриИзменении(Элемент)
	
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОформитьДокумент(Команда)
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
		"Обработка.ЖурналДокументовИнтеркампани.РабочееМестоПередачиВыкуп.Команда.ОформитьДокумент");
	
	Строка = Элементы.КОформлению.ТекущиеДанные;
	
	Если Строка <> Неопределено Тогда
		
		СтруктураОснование = Новый Структура;
		СтруктураОснование.Вставить("ПоТоварамКОформлению",  Ложь);
		СтруктураОснование.Вставить("НачалоПериода",         Строка.ДатаОформления);
		СтруктураОснование.Вставить("КонецПериода",          Строка.ДатаПоследнейПродажи);
		СтруктураОснование.Вставить("ХозяйственнаяОперация", Строка.ХозяйственнаяОперация);
		СтруктураОснование.Вставить("Договор",               Строка.Договор);
		
		Если ОформляемыеДокументы = "ТолькоПередачи" Тогда
			СтруктураОснование.Вставить("Организация",             Строка.Отправитель);
			СтруктураОснование.Вставить("ОрганизацияПолучатель",   Строка.Получатель);
			СтруктураОснование.Вставить("Склад",                   Строка.Склад);
			СтруктураОснование.Вставить("ПередачаПодДеятельность", Строка.ПередачаПодДеятельность);
			СтруктураОснование.Вставить("ЗаполнятьПоСхеме",        Истина);
			СтруктураОснование.Вставить("ДатаОформления",          Строка.ДатаОформления);
			СтруктураОснование.Вставить("ВидЦены",                 Строка.ВидЦены);
			СтруктураОснование.Вставить("ВалютаВзаиморасчетов",    Строка.ВалютаВзаиморасчетов);
			
			ИмяФормыОткрытия = "Документ.ПередачаТоваровМеждуОрганизациями.ФормаОбъекта";
		КонецЕсли;
		
		ПараметрыОткрытия = Новый Структура("Основание", СтруктураОснование);
		
		ОткрытьФорму(ИмяФормыОткрытия, ПараметрыОткрытия, ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОформитьДокументЗаПериод(Команда)
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
		"Обработка.ЖурналДокументовИнтеркампани.РабочееМестоПередачиВыкуп.Команда.ОформитьДокументЗаПериод");
	
	Строка = Элементы.КОформлениюЗаПериод.ТекущиеДанные;
	
	Если Строка <> Неопределено Тогда
		
		СтруктураОснование = Новый Структура;
		СтруктураОснование.Вставить("ПоТоварамКОформлению",  Ложь);
		СтруктураОснование.Вставить("НачалоПериода",         НачалоМесяца(Строка.Месяц));
		СтруктураОснование.Вставить("КонецПериода",          КонецМесяца(Строка.Месяц));
		СтруктураОснование.Вставить("ХозяйственнаяОперация", Строка.ХозяйственнаяОперация);
		СтруктураОснование.Вставить("Договор",               Строка.Договор);
		
		Если ОформляемыеДокументы = "ТолькоПередачи" Тогда
			СтруктураОснование.Вставить("Организация",             Строка.Отправитель);
			СтруктураОснование.Вставить("ОрганизацияПолучатель",   Строка.Получатель);
			СтруктураОснование.Вставить("Склад",                   Строка.Склад);
			СтруктураОснование.Вставить("ПередачаПодДеятельность", Строка.ПередачаПодДеятельность);
			СтруктураОснование.Вставить("ЗаполнятьПоСхеме",        Истина);
			СтруктураОснование.Вставить("ДатаОформления",          Неопределено);
			СтруктураОснование.Вставить("ВидЦены",                 Строка.ВидЦены);
			СтруктураОснование.Вставить("ВалютаВзаиморасчетов",    Строка.ВалютаВзаиморасчетов);
			
			ИмяФормыОткрытия = "Документ.ПередачаТоваровМеждуОрганизациями.ФормаОбъекта";
		КонецЕсли;
		
		СтруктураПараметры = Новый Структура("Основание", СтруктураОснование);
		
		ОткрытьФорму(ИмяФормыОткрытия, СтруктураПараметры, ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаЖурналДокументовОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, 
		"Обработка.ЖурналДокументовИнтеркампани.РабочееМестоПередачиВыкуп.Команда.ГиперссылкаЖурналДокументов");
	
	СтандартнаяОбработка = Ложь;
	
	ОбщегоНазначенияУТКлиент.ОткрытьЖурнал(ПараметрыЖурнала());
	
КонецПроцедуры

&НаКлиенте
Процедура СвернутьРезервы(Команда)
	
	СвернутьРезервыСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияОформитьПередачиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормыПередач = Новый Структура;
	ПараметрыФормыПередач.Вставить("КлючНазначенияИспользования", "ДокументыИнтеркампани");
	
	ОтборыФормыСписка = Новый Структура;
	ОтборыФормыСписка.Вставить("Организация", Получатель);
	ОтборыФормыСписка.Вставить("Склад", Склад);
		
	ПараметрыФормыПередач.Вставить("ОтборыФормыСписка", ОтборыФормыСписка);
	
	ОткрытьФорму("Обработка.ЖурналДокументовИнтеркампани.Форма.РабочееМестоПередачиВыкуп",
				ПараметрыФормыПередач,
				,
				КлючНазначенияИспользования);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыКОформлению

&НаКлиенте
Процедура КОформлениюПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыКОформлениюЗаПериод

&НаКлиенте
Процедура КОформлениюЗаПериодПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "КОформлению.ДатаОформления",
		"КОформлениюДатаОформления");
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "КОформлениюЗаПериод.Месяц",
		"КОформлениюЗаПериодМесяц");
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция КлючНазначенияФормыПоУмолчанию()
	
	Возврат "ДокументыИнтеркампани";
	
КонецФункции

&НаСервере
Процедура ВосстановитьНастройки(Параметры)
	Если Параметры.Свойство("КлючНазначенияИспользования")
		И ЗначениеЗаполнено(Параметры.КлючНазначенияИспользования) Тогда
		
		КлючНазначенияИспользования = Параметры.КлючНазначенияИспользования;
		
	Иначе
		КлючНазначенияИспользования = КлючНазначенияФормыПоУмолчанию();
	КонецЕсли;
	
	ОформлениеПередач = КлючНазначенияИспользования = КлючНазначенияФормыПоУмолчанию();
	
	Если Параметры.Свойство("ПериодРегистрации") Тогда
		ФормаОткрытаПоГиперссылке = Истина;
		
		Если ОформлениеПередач Тогда
			Получатель  = Параметры.Организация;
			Отправитель = Параметры.Организация;
		Иначе
			Получатель = Параметры.Организация;
		КонецЕсли;
		
		ДатаНачала     = НачалоМесяца(Параметры.ПериодРегистрации);
		ДатаОконачания = КонецМесяца(Параметры.ПериодРегистрации);
		
		Период.ДатаНачала    = ДатаНачала;
		Период.ДатаОкончания = ДатаОконачания;
		
	ИначеЕсли Параметры.Свойство("ОтборыФормыСписка") Тогда
		
		ФормаОткрытаПоГиперссылке = Истина;
		ОтборыФормыСписка = Параметры.ОтборыФормыСписка;
		
		Если ОформлениеПередач Тогда
			Отправитель = ОтборыФормыСписка.Организация;
		Иначе
			Получатель = ОтборыФормыСписка.Организация;
		КонецЕсли;
		
		Склад = ОтборыФормыСписка.Склад;
		
	Иначе
		
		ФормаОткрытаПоГиперссылке = Ложь;
		
		КлючОбъекта = "Обработка.ЖурналДокументовИнтеркампани.Форма.РабочееМестоПередачиВыкуп";
		Настройки   = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(КлючОбъекта, КлючНазначенияИспользования);
		
		Если Настройки <> Неопределено Тогда
			Период               = Настройки.Период;
			Отправитель          = Настройки.Отправитель;
			Получатель           = Настройки.Получатель;
			Склад                = Настройки.Склад;
			ВариантОформления    = Настройки.ВариантОформления;
			ОформляемыеДокументы = Настройки.ОформляемыеДокументы;
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ВариантОформления) Тогда
		ВариантОформления = "ЗаПериод";
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ОформляемыеДокументы) Тогда
		ОформляемыеДокументы = ?(ОформлениеПередач, "ТолькоПередачи", "ТолькоВыкупы");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НастроитьФорму(Параметры)
	
	МассивСтрок = Новый Массив;
	МассивСтрок.Добавить(НСтр("ru = 'См. также:'") + " ");
	
	ИспользоватьНесколькоСкладов = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоСкладов");
	
	Если ОформляемыеДокументы = "ТолькоПередачи" Тогда
		
		Заголовок = НСтр("ru = 'Передачи товаров к оформлению'");
		
		Отправитель = ?(ЗначениеЗаполнено(Отправитель), Отправитель, Справочники.Организации.ПустаяСсылка());
		Склад = ?(ЗначениеЗаполнено(Склад), Склад, Справочники.Склады.ПустаяСсылка());
		
		Элементы.Склад.ВыбиратьТип = Ложь;
		
		Элементы.Склад.Видимость                    = ИспользоватьНесколькоСкладов;
		Элементы.КОформлениюСклад.Видимость         = ИспользоватьНесколькоСкладов;
		Элементы.КОформлениюЗаПериодСклад.Видимость = ИспользоватьНесколькоСкладов;
				
		ТекстГиперссылки = Новый ФорматированнаяСтрока(НСтр("ru = 'Документы между организациями (оформленные передачи)'"), , , ,
			"Обработка.ЖурналДокументовИнтеркампани.Форма.ФормаСписка");
		
	Иначе
		
		Заголовок = НСтр("ru = 'Выкупы товаров к оформлению'");
		
		Отправитель = ?(ЗначениеЗаполнено(Отправитель), Отправитель, Справочники.Партнеры.ПустаяСсылка());
		
		ПараметрВыбора = Новый ПараметрВыбора("Отбор.Поставщик", Истина);
		МассивПараметров = Новый Массив;
		МассивПараметров.Добавить(ПараметрВыбора);
		
		Элементы.Отправитель.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметров);
		
		ЗаголовокПолучатель = НСтр("ru = 'Организация'");
		Элементы.Получатель.Заголовок                    = ЗаголовокПолучатель;
		Элементы.КОформлениюПолучатель.Заголовок         = ЗаголовокПолучатель;
		Элементы.КОформлениюЗаПериодПолучатель.Заголовок = ЗаголовокПолучатель;
		
		ЗаголовокСклада = НСтр("ru = 'Место хранения'");
		Элементы.Склад.Заголовок                    = ЗаголовокСклада;
		Элементы.КОформлениюСклад.Заголовок         = ЗаголовокСклада;
		Элементы.КОформлениюЗаПериодСклад.Заголовок = ЗаголовокСклада;
		
		ЗаголовокПередачаПодДеятельность = НСтр("ru = 'Выкуп под деятельность'");
		Элементы.КОформлениюПередачаПодДеятельность.Заголовок         = ЗаголовокПередачаПодДеятельность;
		Элементы.КОформлениюЗаПериодПередачаПодДеятельность.Заголовок = ЗаголовокПередачаПодДеятельность;
		
		Элементы.КОформлениюВидЦены.Видимость         = Ложь;
		Элементы.КОформлениюЗаПериодВидЦены.Видимость = Ложь;
		
		ТекстГиперссылки = Новый ФорматированнаяСтрока(НСтр("ru = 'Документы закупки (оформленные выкупы)'"), , , ,
			"Обработка.ЖурналДокументовЗакупки.Форма.СписокДокументов");
		
	КонецЕсли;
	
	МассивСтрок.Добавить(ТекстГиперссылки);
	
	Элементы.ГиперссылкаЖурналДокументов.Заголовок = Новый ФорматированнаяСтрока(МассивСтрок);
	
	Элементы.КОформлениюСвернутьРезервы.Видимость = ОбщегоНазначенияУТ.РежимОтладки();
	Элементы.КОформлениюПоМесяцамСвернутьРезервы.Видимость = Элементы.КОформлениюСвернутьРезервы.Видимость;
	
КонецПроцедуры

&НаСервере
Процедура УправлениеЭлементамиФормы()
	
	Если ВариантОформления = "ПоДням" Тогда
		ЗаполнитьКОформлению();
		
		Элементы.СтраницыКОформлению.ТекущаяСтраница = Элементы.КОформлениюПоДням;
	Иначе
		ЗаполнитьКОформлениюЗаПериод();
		
		Элементы.СтраницыКОформлению.ТекущаяСтраница = Элементы.КОформлениюПоМесяцам;
	КонецЕсли;
	
	РасчитатьРеквизитЕстьТоварыКОформлениюПередачПередВыкупом();
	Элементы.ДекорацияОформитьПередачи.Видимость = ЕстьТоварыКОформлениюПередачПередВыкупом;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьКОформлению()
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	УчетнаяПолитикаОрганизаций.Период КАК Период,
	|	УчетнаяПолитикаОрганизаций.Организация КАК Организация,
	|	ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка) КАК Склад,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПоФактическомуИспользованию) КАК НалогообложениеНДС
	|ПОМЕСТИТЬ УчетныеПолитикиОрганизаций
	|ИЗ
	|	РегистрСведений.УчетнаяПолитикаОрганизаций КАК УчетнаяПолитикаОрганизаций
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.УчетныеПолитикиОрганизаций КАК УчетныеПолитикиОрганизаций
	|		ПО (УчетнаяПолитикаОрганизаций.УчетнаяПолитика = УчетныеПолитикиОрганизаций.Ссылка)
	|			И (УчетныеПолитикиОрганизаций.СистемаНалогообложения = ЗНАЧЕНИЕ(Перечисление.СистемыНалогообложения.Общая))
	|			И (УчетныеПолитикиОрганизаций.ПрименяетсяУчетНДСПоФактическомуИспользованию)
	|ГДЕ
	|	УчетнаяПолитикаОрганизаций.Период МЕЖДУ &НачалоПериода И &КонецПериода
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ПримененияЕНВД.Период,
	|	ПримененияЕНВД.Организация,
	|	ПримененияЕНВД.Склад,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПродажаОблагаетсяЕНВД)
	|ИЗ
	|	РегистрСведений.ПримененияЕНВД КАК ПримененияЕНВД
	|ГДЕ
	|	ПримененияЕНВД.Период МЕЖДУ &НачалоПериода И &КонецПериода
	|	И ПримененияЕНВД.РозничнаяТорговляОблагаетсяЕНВД
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	УчетнаяПолитикаОрганизаций.Период,
	|	УчетнаяПолитикаОрганизаций.Организация,
	|	ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка),
	|	ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПродажаНеОблагаетсяНДС)
	|ИЗ
	|	РегистрСведений.УчетнаяПолитикаОрганизаций КАК УчетнаяПолитикаОрганизаций
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.УчетныеПолитикиОрганизаций КАК УчетныеПолитикиОрганизаций
	|		ПО УчетнаяПолитикаОрганизаций.УчетнаяПолитика = УчетныеПолитикиОрганизаций.Ссылка
	|			И (УчетныеПолитикиОрганизаций.СистемаНалогообложения = ЗНАЧЕНИЕ(Перечисление.СистемыНалогообложения.Упрощенная))
	|ГДЕ
	|	УчетнаяПолитикаОрганизаций.Период МЕЖДУ &НачалоПериода И &КонецПериода
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Период
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТоварыКОформлению.Период                     КАК Период,
	|	ТоварыКОформлению.ДатаОформления             КАК ДатаОформления,
	|	ТоварыКОформлению.Отправитель                КАК Отправитель,
	|	ТоварыКОформлению.Получатель                 КАК Получатель,
	|	ТоварыКОформлению.Склад                      КАК Склад,
	|	ТоварыКОформлению.НалогообложениеНДС         КАК НалогообложениеНДС,
	|	ТоварыКОформлению.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ТоварыКОформлению.ВидЗапасов                 КАК КорВидЗапасов,
	|	ТоварыКОформлению.ВидЗапасовПолучателя       КАК ВидЗапасов,
	|	ТоварыКОформлению.ТипЗапасов                 КАК ТипЗапасов,
	|	ТоварыКОформлению.НомерГТД                   КАК НомерГТД,
	|	ТоварыКОформлению.Потреблено                 КАК Количество
	|ПОМЕСТИТЬ ТоварыКОформлению
	|ИЗ
	|	&ТоварыКОформлению КАК ТоварыКОформлению
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Отправитель,
	|	Получатель,
	|	Склад,
	|	КорВидЗапасов,
	|	ТипЗапасов";
	
	Если ОформляемыеДокументы = "ТолькоПередачи" Тогда
		
		ТекстЗапроса = ТекстЗапроса + ОбщегоНазначенияУТ.РазделительЗапросовВПакете() + "
		|ВЫБРАТЬ
		|	КОЛИЧЕСТВО(1)                                                   КАК СтрокТоваров,
		|	РезервыТоваров.ДатаОформления                                   КАК ДатаОформления,
		|	МАКСИМУМ(РезервыТоваров.Период)                                 КАК ДатаПоследнейПродажи,
		|	РезервыТоваров.Отправитель                                      КАК Отправитель,
		|	РезервыТоваров.Получатель                                       КАК Получатель,
		|	РезервыТоваров.Склад                                            КАК Склад,
		|	ВЫБОР
		|		КОГДА РезервыТоваров.ТипЗапасов = ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.КомиссионныйТовар)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПередачаНаКомиссиюВДругуюОрганизацию)
		|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияТоваровВДругуюОрганизацию)
		|	КОНЕЦ                                                           КАК ХозяйственнаяОперация,
		|	ВЫБОР
		|		КОГДА РезервыТоваров.ТипЗапасов = ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.КомиссионныйТовар)
		|			ТОГДА РезервыТоваров.ВидЗапасов.НалогообложениеНДС
		|		ИНАЧЕ РезервыТоваров.НалогообложениеНДС
		|	КОНЕЦ                                                           КАК НалогообложениеНДС,
		|	РезервыТоваров.ВидЗапасов.Договор								КАК Договор,
		|	ЕСТЬNULL(НастройкаПередачиТоваров.ВидЦены, &ВидЦеныПоУмолчанию) КАК ВидЦены,
		|	РезервыТоваров.ВидЗапасов.Валюта                                КАК Валюта
		|ПОМЕСТИТЬ РезервыТоваров
		|ИЗ
		|	ТоварыКОформлению КАК РезервыТоваров
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкаПередачиТоваровМеждуОрганизациями КАК НастройкаПередачиТоваров
		|		ПО РезервыТоваров.Получатель     = НастройкаПередачиТоваров.ОрганизацияПродавец
		|			И РезервыТоваров.Отправитель = НастройкаПередачиТоваров.ОрганизацияВладелец
		|			И РезервыТоваров.КорВидЗапасов.ТипЗапасов  = НастройкаПередачиТоваров.ТипЗапасов
		|ГДЕ
		|	РезервыТоваров.Получатель <> РезервыТоваров.Отправитель
		|	И РезервыТоваров.Отправитель ССЫЛКА Справочник.Организации
		|	И &Отправитель В (ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка), РезервыТоваров.Отправитель)
		|	И &Получатель В (ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка), РезервыТоваров.Получатель)
		|	И &Склад В (НЕОПРЕДЕЛЕНО, ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка), РезервыТоваров.Склад)
		|	
		|СГРУППИРОВАТЬ ПО
		|	РезервыТоваров.ДатаОформления,
		|	РезервыТоваров.Отправитель,
		|	РезервыТоваров.Получатель,
		|	РезервыТоваров.Склад,
		|	ВЫБОР
		|		КОГДА РезервыТоваров.ТипЗапасов = ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.КомиссионныйТовар)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПередачаНаКомиссиюВДругуюОрганизацию)
		|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияТоваровВДругуюОрганизацию)
		|	КОНЕЦ,
		|	ВЫБОР
		|		КОГДА РезервыТоваров.ТипЗапасов = ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.КомиссионныйТовар)
		|			ТОГДА РезервыТоваров.ВидЗапасов.НалогообложениеНДС
		|		ИНАЧЕ РезервыТоваров.НалогообложениеНДС
		|	КОНЕЦ,
		|	РезервыТоваров.ВидЗапасов.Договор,
		|	ЕСТЬNULL(НастройкаПередачиТоваров.ВидЦены, &ВидЦеныПоУмолчанию),
		|	РезервыТоваров.ВидЗапасов.Валюта
		|";
		
	Иначе
		
		ТекстЗапроса = ТекстЗапроса + ОбщегоНазначенияУТ.РазделительЗапросовВПакете() + "
		|ВЫБРАТЬ
		|	КОЛИЧЕСТВО(1)                                               КАК СтрокТоваров,
		|	РезервыТоваров.ДатаОформления                               КАК ДатаОформления,
		|	МАКСИМУМ(РезервыТоваров.Период)                             КАК ДатаПоследнейПродажи,
		|	КорВидыЗапасов.ВладелецТовара                               КАК Отправитель,
		|	РезервыТоваров.Получатель                                   КАК Получатель,
		|	РезервыТоваров.Склад                                        КАК Склад,
		|	ВЫБОР
		|		КОГДА РезервыТоваров.Склад ССЫЛКА Справочник.Склады
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВыкупТоваровХранящихсяНаСкладе)
		|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВыкупТоваровПереданныхВПроизводство)
		|	КОНЕЦ                                                       КАК ХозяйственнаяОперация,
		|	РезервыТоваров.НалогообложениеНДС                           КАК НалогообложениеНДС,
		|	КорВидыЗапасов.Договор										КАК Договор,
		|	ЕСТЬNULL(КорВидыЗапасов.ВидЦены, &ВидЦеныПоУмолчанию)       КАК ВидЦены,
		|	ЕСТЬNULL(Договоры.ВалютаВзаиморасчетов, &ВалютаПоУмолчанию) КАК Валюта
		|ПОМЕСТИТЬ РезервыТоваров
		|ИЗ
		|	ТоварыКОформлению КАК РезервыТоваров
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыЗапасов КАК КорВидыЗапасов
		|		ПО РезервыТоваров.КорВидЗапасов = КорВидыЗапасов.Ссылка
		|		
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ДоговорыКонтрагентов КАК Договоры
		|		ПО КорВидыЗапасов.Договор = Договоры.Ссылка
		|ГДЕ
		|	РезервыТоваров.Отправитель ССЫЛКА Справочник.Партнеры
		|	И КорВидыЗапасов.ТипЗапасов = ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.ТоварНаХраненииСПравомПродажи)
		|	И &Отправитель В (ЗНАЧЕНИЕ(Справочник.Партнеры.ПустаяСсылка), КорВидыЗапасов.ВладелецТовара)
		|	И &Получатель В (ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка), РезервыТоваров.Получатель)
		|	И &Склад В (НЕОПРЕДЕЛЕНО, ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка), ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка),
		|		РезервыТоваров.Склад)
		|	
		|СГРУППИРОВАТЬ ПО
		|	РезервыТоваров.ДатаОформления,
		|	КорВидыЗапасов.ВладелецТовара,
		|	РезервыТоваров.Получатель,
		|	РезервыТоваров.Склад,
		|	ВЫБОР
		|		КОГДА РезервыТоваров.Склад ССЫЛКА Справочник.Склады
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВыкупТоваровХранящихсяНаСкладе)
		|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВыкупТоваровПереданныхВПроизводство)
		|	КОНЕЦ,
		|	РезервыТоваров.НалогообложениеНДС,
		|	КорВидыЗапасов.Договор,
		|	ЕСТЬNULL(КорВидыЗапасов.ВидЦены, &ВидЦеныПоУмолчанию),
		|	ЕСТЬNULL(Договоры.ВалютаВзаиморасчетов, &ВалютаПоУмолчанию)
		|";
		
	КонецЕсли;
	
	ТекстЗапроса = ТекстЗапроса + ОбщегоНазначенияУТ.РазделительЗапросовВПакете() + "
	|ВЫБРАТЬ
	|	РезервыТоваров.ДатаОформления               КАК ДатаОформления,
	|	МАКСИМУМ(УчетныеПолитикиОрганизаций.Период) КАК Период,
	|	РезервыТоваров.Получатель                   КАК Получатель,
	|	РезервыТоваров.Склад                        КАК Склад
	|ПОМЕСТИТЬ ПериодыДействующихУчетныхПолитикОрганизаций
	|ИЗ
	|	РезервыТоваров КАК РезервыТоваров
	|		ЛЕВОЕ СОЕДИНЕНИЕ УчетныеПолитикиОрганизаций КАК УчетныеПолитикиОрганизаций
	|		ПО РезервыТоваров.Получатель = УчетныеПолитикиОрганизаций.Организация
	|			И (РезервыТоваров.Склад = УчетныеПолитикиОрганизаций.Склад
	|				ИЛИ УчетныеПолитикиОрганизаций.Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка))
	|			И РезервыТоваров.ДатаОформления >= УчетныеПолитикиОрганизаций.Период
	|
	|СГРУППИРОВАТЬ ПО
	|	РезервыТоваров.ДатаОформления,
	|	РезервыТоваров.Получатель,
	|	РезервыТоваров.Склад
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	РезервыТоваров.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	РезервыТоваров.ДатаОформления        КАК ДатаОформления,
	|	РезервыТоваров.ДатаПоследнейПродажи  КАК ДатаПоследнейПродажи,
	|	РезервыТоваров.Отправитель           КАК Отправитель,
	|	РезервыТоваров.Получатель            КАК Получатель,
	|	РезервыТоваров.Склад                 КАК Склад,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(РезервыТоваров.НалогообложениеНДС, ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПустаяСсылка)) <> ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПустаяСсылка)
	|			ТОГДА РезервыТоваров.НалогообложениеНДС
	|		ИНАЧЕ ЕСТЬNULL(УчетныеПолитикиОрганизаций.НалогообложениеНДС, &НалогообложениеНДСПоУмолчанию)
	|	КОНЕЦ                                КАК ПередачаПодДеятельность,
	|	РезервыТоваров.Договор               КАК Договор,
	|	РезервыТоваров.ВидЦены               КАК ВидЦены,
	|	РезервыТоваров.Валюта                КАК ВалютаВзаиморасчетов
	|ИЗ
	|	РезервыТоваров КАК РезервыТоваров
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПериодыДействующихУчетныхПолитикОрганизаций КАК ПериодыДействующихУчетныхПолитикОрганизаций
	|		ПО (РезервыТоваров.Получатель = ПериодыДействующихУчетныхПолитикОрганизаций.Получатель)
	|			И (РезервыТоваров.Склад = ПериодыДействующихУчетныхПолитикОрганизаций.Склад)
	|			И (РезервыТоваров.ДатаОформления = ПериодыДействующихУчетныхПолитикОрганизаций.ДатаОформления)
	|
	|		ЛЕВОЕ СОЕДИНЕНИЕ УчетныеПолитикиОрганизаций КАК УчетныеПолитикиОрганизаций
	|		ПО (ПериодыДействующихУчетныхПолитикОрганизаций.Получатель = УчетныеПолитикиОрганизаций.Организация)
	|			И (ПериодыДействующихУчетныхПолитикОрганизаций.Склад = УчетныеПолитикиОрганизаций.Склад
	|				ИЛИ УчетныеПолитикиОрганизаций.Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка))
	|			И (ПериодыДействующихУчетныхПолитикОрганизаций.Период = УчетныеПолитикиОрганизаций.Период)
	|
	|УПОРЯДОЧИТЬ ПО
	|	РезервыТоваров.ДатаОформления,
	|	РезервыТоваров.ХозяйственнаяОперация,
	|	РезервыТоваров.Отправитель,
	|	РезервыТоваров.Получатель,
	|	РезервыТоваров.Склад,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(РезервыТоваров.НалогообложениеНДС, ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПустаяСсылка)) <> ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПустаяСсылка)
	|			ТОГДА РезервыТоваров.НалогообложениеНДС
	|		ИНАЧЕ ЕСТЬNULL(УчетныеПолитикиОрганизаций.НалогообложениеНДС, &НалогообложениеНДСПоУмолчанию)
	|	КОНЕЦ";
	
	ВалютаПоУмолчанию             = Справочники.Валюты.ПустаяСсылка();
	ВидЦеныПоУмолчанию            = Справочники.ВидыЦен.ПустаяСсылка();
	НалогообложениеНДСПоУмолчанию = Перечисления.ТипыНалогообложенияНДС.ПродажаОблагаетсяНДС;
	
	Отборы = РегистрыНакопления.РезервыТоваровОрганизаций.ОтборыТоваровКПередаче();
	Отборы.НачалоПериода = НачалоДня(Период.ДатаНачала);
	Отборы.КонецПериода  = КонецДня(?(ЗначениеЗаполнено(Период.ДатаОкончания), Период.ДатаОкончания, Дата(2399, 12, 31)));
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.Текст = ТекстЗапроса;
	
	Запрос.УстановитьПараметр("НачалоПериода",                 Отборы.НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода",                  Отборы.КонецПериода);
	Запрос.УстановитьПараметр("Отправитель",                   Отправитель);
	Запрос.УстановитьПараметр("Получатель",                    Получатель);
	Запрос.УстановитьПараметр("Склад",                         Склад);
	Запрос.УстановитьПараметр("НалогообложениеНДСПоУмолчанию", НалогообложениеНДСПоУмолчанию);
	Запрос.УстановитьПараметр("ВалютаПоУмолчанию",             ВалютаПоУмолчанию);
	Запрос.УстановитьПараметр("ВидЦеныПоУмолчанию",            ВидЦеныПоУмолчанию);
	Запрос.УстановитьПараметр("ТоварыКОформлению", РегистрыНакопления.РезервыТоваровОрганизаций.ТоварыКПередаче(Отборы));
	
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	
	КОформлению.Загрузить(РезультатЗапроса);
	
	Элементы.КОформлению.Обновить();
	
КонецПроцедуры

&НаСервере
Процедура РасчитатьРеквизитЕстьТоварыКОформлениюПередачПередВыкупом()
	
	Если Не ОформляемыеДокументы = "ТолькоПередачи" Тогда
		
		Запрос = Новый Запрос;
		ТекстЗапроса =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	РезервыТоваровОрганизаций.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
		|	РезервыТоваровОрганизаций.Организация КАК Организация,
		|	РезервыТоваровОрганизаций.ВидЗапасов КАК ВидЗапасов,
		|	РезервыТоваровОрганизаций.НомерГТД КАК НомерГТД,
		|	СУММА(РезервыТоваровОрганизаций.Количество) КАК Количество
		|ИЗ
		|	РегистрНакопления.РезервыТоваровОрганизаций КАК РезервыТоваровОрганизаций
		|ГДЕ
		|	РезервыТоваровОрганизаций.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
		|	И РезервыТоваровОрганизаций.Организация <> РезервыТоваровОрганизаций.КорОрганизация
		|	И РезервыТоваровОрганизаций.ВидЗапасов.ТипЗапасов = ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.ТоварНаХраненииСПравомПродажи)
		|	И &Склад
		|	И &ВладелецТовара
		|	И &ОрганизацияРезерва
		|
		|СГРУППИРОВАТЬ ПО
		|	РезервыТоваровОрганизаций.АналитикаУчетаНоменклатуры,
		|	РезервыТоваровОрганизаций.НомерГТД,
		|	РезервыТоваровОрганизаций.Организация,
		|	РезервыТоваровОрганизаций.ВидЗапасов
		|
		|ИМЕЮЩИЕ
		|	СУММА(РезервыТоваровОрганизаций.Количество) > 0";
		
		Если ЗначениеЗаполнено(Получатель) Тогда
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ОрганизацияРезерва", "РезервыТоваровОрганизаций.Организация = &Организация");
			
			Запрос.УстановитьПараметр("Организация", Получатель);
		Иначе
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ОрганизацияРезерва", "ИСТИНА");
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Отправитель) Тогда
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ВладелецТовара", "РезервыТоваровОрганизаций.ВидЗапасов.ВладелецТовара = &ВладелецТовара");
			
			Запрос.УстановитьПараметр("ВладелецТовара", Отправитель);
		Иначе
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ВладелецТовара", "ИСТИНА");
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Склад) Тогда
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&Склад", "РезервыТоваровОрганизаций.АналитикаУчетаНоменклатуры.Склад = &Склад");
			
			Запрос.УстановитьПараметр("Склад", Склад);
		Иначе
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&Склад", "ИСТИНА");
		КонецЕсли;
		
		Запрос.Текст = ТекстЗапроса;
		
		ЕстьТоварыКОформлениюПередачПередВыкупом = Не Запрос.Выполнить().Пустой();
		
	Иначе
		ЕстьТоварыКОформлениюПередачПередВыкупом = Ложь;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьКОформлениюЗаПериод()
	
	ПараметрыЗапроса = Новый Структура("Отправитель, Получатель, Склад", Отправитель, Получатель, Склад);
	
	Если ОформляемыеДокументы = "ТолькоПередачи" Тогда
		
		ТекстЗапроса = Документы.ПередачаТоваровМеждуОрганизациями.ТекстЗапросаОформляемыеПередачиЗаПериод(ПараметрыЗапроса);
	КонецЕсли;
	
	НалогообложениеНДСПоУмолчанию = Перечисления.ТипыНалогообложенияНДС.ПродажаОблагаетсяНДС;
	ВидЦеныПоУмолчанию            = Справочники.ВидыЦен.ПустаяСсылка();
	
	НачалоПериода = Период.ДатаНачала;
	КонецПериода  = КонецДня(?(ЗначениеЗаполнено(Период.ДатаОкончания), Период.ДатаОкончания, Дата(2999, 12, 31)));
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	
	Запрос.УстановитьПараметр("НачалоПериода",                 НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода",                  КонецПериода);
	Запрос.УстановитьПараметр("Отправитель",                   Отправитель);
	Запрос.УстановитьПараметр("Получатель",                    Получатель);
	Запрос.УстановитьПараметр("Склад",                         Склад);
	Запрос.УстановитьПараметр("НалогообложениеНДСПоУмолчанию", НалогообложениеНДСПоУмолчанию);
	Запрос.УстановитьПараметр("ВидЦеныПоУмолчанию",            ВидЦеныПоУмолчанию);
	
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	
	КОформлениюЗаПериод.Загрузить(РезультатЗапроса);
	
	Элементы.КОформлениюЗаПериод.Обновить();
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройки()
	
	Если ФормаОткрытаПоГиперссылке Тогда
		Возврат;
	КонецЕсли;
	
	КлючОбъекта = "Обработка.ЖурналДокументовИнтеркампани.Форма.РабочееМестоПередачиВыкуп";
	ИменаСохраняемыхРеквизитов = "Период,Отправитель,Получатель,Склад,ВариантОформления,ОформляемыеДокументы";
	
	Настройки = Новый Структура(ИменаСохраняемыхРеквизитов);
	ЗаполнитьЗначенияСвойств(Настройки, ЭтаФорма);
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(КлючОбъекта, КлючНазначенияИспользования, Настройки);
	
КонецПроцедуры

&НаСервере
Процедура ПериодПриИзмененииСервер()
	
	НачалоПериода = Период.ДатаНачала;
	КонецПериода  = КонецДня(?(ЗначениеЗаполнено(Период.ДатаОкончания), Период.ДатаОкончания, Дата(2999, 12, 31)));
	
	Если НачалоПериода > КонецПериода Тогда
		ВызватьИсключение НСтр("ru = 'Дата начала периода не может быть больше даты окончания периода'");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПараметрыЖурнала()
	
	ОтборыФормыСписка = Новый Структура;
	ОтборыФормыСписка.Вставить("Склад", Склад);
	
	ПараметрыЖурнала = Новый Структура;
	
	Если ОформляемыеДокументы = "ТолькоПередачи" Тогда
		ОтборыФормыСписка.Вставить("Организация", Отправитель);
		
		ПараметрыЖурнала.Вставить("КлючНазначенияФормы", "ПередачаТоваровМеждуОрганизациями");
		ПараметрыЖурнала.Вставить("ИмяРабочегоМеста",    "ЖурналДокументовИнтеркампани");
		ПараметрыЖурнала.Вставить("СинонимЖурнала",      НСтр("ru = 'Документы между организациями'"));
	КонецЕсли;
	
	ПараметрыЖурнала.Вставить("ОтборыФормыСписка", ОтборыФормыСписка);
	
	Возврат ПараметрыЖурнала;
	
КонецФункции

&НаСервере
Процедура СвернутьРезервыСервер()
	
	РегистрыНакопления.РезервыТоваровОрганизаций.ВыполнитьСверткуРегистраРезервыТоваровОрганизаций();
	
КонецПроцедуры

#КонецОбласти
