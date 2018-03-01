#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	НепроверяемыеРеквизиты = Новый Массив;
	// проверка реквизитов Объекта
	Если Перечисления.ХозяйственныеОперации.ОформлениеГТДСамостоятельно = ВариантОформления Тогда
		НепроверяемыеРеквизиты.Добавить("Соглашение");
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Соглашение) Или Не ОбщегоНазначенияУТ.ЗначениеРеквизитаОбъектаТипаБулево(Соглашение, "ИспользуютсяДоговорыКонтрагентов") Тогда
		НепроверяемыеРеквизиты.Добавить("Договор");
	КонецЕсли;
	Если ТаможенныйШтраф = 0 Тогда
		НепроверяемыеРеквизиты.Добавить("СтатьяРасходовШтраф");
	КонецЕсли;
	Если ТаможенныйСбор = 0 Тогда
		НепроверяемыеРеквизиты.Добавить("СтатьяРасходовСбор");
	КонецЕсли;
	// проверка табчасти Разделы
	Шаблон = НСтр("ru='""%СинонимПоля%"" в строке %НомерСтроки% списка ""%ИмяТабчасти%"" необходимо заполнить.'");
	Для Каждого Раздел Из Разделы Цикл
		ПроверитьИСообщитьОшибку(Раздел.СтавкаПошлины<>0. И Раздел.СуммаПошлины=0.,
				Отказ, Шаблон, "СуммаПошлины", "Сумма пошлины", "Разделы", Раздел.НомерСтроки);
		ЗаполнитьНДС = Раздел.СтавкаНДС <> Перечисления.СтавкиНДС.БезНДС И Раздел.СтавкаНДС <> Перечисления.СтавкиНДС.НДС0;
		ПроверитьИСообщитьОшибку(ЗаполнитьНДС И Раздел.СуммаНДС=0.,
				Отказ, Шаблон, "СуммаНДС", "Сумма НДС", "Разделы", Раздел.НомерСтроки);
	КонецЦикла;
	
	// проверки и исключения, зависимые от статуса декларации
	Если Перечисления.СтатусыТаможенныхДеклараций.ТаможенноеОформление = Статус Тогда
		НепроверяемыеРеквизиты.Добавить("Товары");
		НепроверяемыеРеквизиты.Добавить("Товары.Склад");
		НепроверяемыеРеквизиты.Добавить("Товары.НомерРаздела");
		НепроверяемыеРеквизиты.Добавить("Товары.ТаможеннаяСтоимость");
		НепроверяемыеРеквизиты.Добавить("Товары.НомерДляСФ");
		НепроверяемыеРеквизиты.Добавить("Разделы.НомерДляСФ");
	ИначеЕсли Перечисления.СтатусыТаможенныхДеклараций.ВыпущеноСТаможни = Статус Тогда
		НепроверяемыеРеквизиты.Добавить(?(НумероватьПоТоварам, "Разделы.НомерДляСФ", "Товары.НомерДляСФ"));
		
		// проверка соответствия товаров и разделов
		КешРазделов = Новый Соответствие;
		Для Каждого Раздел Из Разделы Цикл
			Значение = Новый Структура("Раздел, ТаможеннаяСтоимость, СуммаПошлины, СуммаНДС", Раздел, 0., 0., 0.);
			КешРазделов.Вставить(Раздел.НомерРаздела, Значение);
		КонецЦикла;
		Для Каждого Товар Из Товары Цикл
			ЭлементКеша = КешРазделов[Товар.НомерРаздела];
			Если Неопределено <> ЭлементКеша Тогда
				ЭлементКеша.ТаможеннаяСтоимость = ЭлементКеша.ТаможеннаяСтоимость + Товар.ТаможеннаяСтоимость;
				ЭлементКеша.СуммаПошлины = ЭлементКеша.СуммаПошлины + Товар.СуммаПошлины;
				ЭлементКеша.СуммаНДС = ЭлементКеша.СуммаНДС + Товар.СуммаНДС;
			КонецЕсли;
		КонецЦикла;
		Шаблон = НСтр("ru='""%СинонимПоля%"" в строке %НомерСтроки% списка ""%ИмяТабчасти%"" не соответствует итогу по товарам раздела.'");
		Для Каждого ЭлементКеша Из КешРазделов Цикл
			Значение = ЭлементКеша.Значение;
			ПроверитьИСообщитьОшибку(Значение.Раздел.ТаможеннаяСтоимость<>Значение.ТаможеннаяСтоимость,
					Отказ, Шаблон, "ТаможеннаяСтоимость", "Таможенная стоимость", "Разделы", Значение.Раздел.НомерСтроки);
			ПроверитьИСообщитьОшибку(Значение.Раздел.СуммаПошлины<>Значение.СуммаПошлины,
					Отказ, Шаблон, "СуммаПошлины", "Сумма пошлины", "Разделы", Значение.Раздел.НомерСтроки);
			ПроверитьИСообщитьОшибку(Значение.Раздел.СуммаНДС<>Значение.СуммаНДС,
					Отказ, Шаблон, "СуммаНДС", "Сумма НДС", "Разделы", Значение.Раздел.НомерСтроки);
		КонецЦикла;
	КонецЕсли;
	// дополнительные проверки
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект, НепроверяемыеРеквизиты, Отказ);
	НоменклатураСервер.ПроверитьЗаполнениеСерий(ЭтотОбъект,
												НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ТаможеннаяДекларацияИмпорт),
												Отказ,
												НепроверяемыеРеквизиты);
	ОбщегоНазначенияУТ.ПроверитьЗаполнениеКоличества(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ);
	
	ПланыВидовХарактеристик.СтатьиРасходов.ПроверитьЗаполнениеАналитик(
		ЭтотОбъект,
		"СтатьяРасходовСбор, АналитикаРасходовСбор, СтатьяРасходовШтраф, АналитикаРасходовШтраф",
		НепроверяемыеРеквизиты,
		Отказ);
		
	Если ЗначениеЗаполнено(НаправлениеДеятельности) 
		ИЛИ НЕ НаправленияДеятельностиСервер.УказаниеНаправленияДеятельностиОбязательно(ВариантОформления) Тогда
		НепроверяемыеРеквизиты.Добавить("НаправлениеДеятельности");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	ПроведениеСерверУТ.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	ОбщегоНазначенияУТ.ОкруглитьКоличествоШтучныхТоваров(ЭтотОбъект, РежимЗаписи);
	
	// корректировка НомерРаздела
	КешРазделов = Новый Соответствие;
	Для Каждого Раздел Из Разделы Цикл
		КешРазделов.Вставить(Раздел.НомерРаздела, 0);
	КонецЦикла;
	Для Каждого Товар Из Товары Цикл
		Если Неопределено=КешРазделов[Товар.НомерРаздела] Тогда
			Товар.НомерРаздела = 0;
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Товар.ЗакупкаПодДеятельность) Тогда
			Товар.ЗакупкаПодДеятельность = Перечисления.ТипыНалогообложенияНДС.ПродажаОблагаетсяНДС;
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Товар.ХозяйственнаяОперация) Тогда
			Товар.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ЗакупкаПоИмпорту;
		КонецЕсли;
	КонецЦикла;
	
	Если Перечисления.ХозяйственныеОперации.ОформлениеГТДСамостоятельно = ВариантОформления Тогда
		Соглашение = Неопределено;
	КонецЕсли;
	
	ТабчастьОчистки = ?(НумероватьПоТоварам, Разделы, Товары);
	Для Каждого Строка Из ТабчастьОчистки Цикл
		Строка.НомерДляСФ = "";
	КонецЦикла;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьУчетПрочихДоходовРасходов") Тогда
		Если Не ТаможенныйСбор = 0 Тогда
			ТаможенныйСбор = 0;
		КонецЕсли;
		Если Не ТаможенныйШтраф = 0 Тогда
			ТаможенныйШтраф = 0;
		КонецЕсли;
	КонецЕсли;
	
	СуммаДокумента = Документы.ТаможеннаяДекларацияИмпорт.СуммаДокумента(ЭтотОбъект);
	ВзаиморасчетыСервер.ЗаполнитьСуммуВзаиморасчетов(ЭтотОбъект);
	
	Если РежимЗаписи=РежимЗаписиДокумента.Проведение Тогда
		Если (Статус = Перечисления.СтатусыТаможенныхДеклараций.ВыпущеноСТаможни) Тогда
			ЗаполнитьСклад();
			
			ИтоговаяТЧ = Товары.ВыгрузитьКолонки();
			
			ХозОперацииТЧ = Товары.ВыгрузитьКолонку("ХозяйственнаяОперация");
			ХозОперацииТЧ = ОбщегоНазначенияКлиентСервер.СвернутьМассив(ХозОперацииТЧ);
			
			Для Каждого ХозОперация Из ХозОперацииТЧ Цикл
				
				ПараметрыОтбора = Новый Структура("ХозяйственнаяОперация", ХозОперация);
				НайденныеСтроки = Товары.НайтиСтроки(ПараметрыОтбора);
				ТаблицаДляОбработки = Товары.Выгрузить(НайденныеСтроки);
				ТаблицаДляОбработки.Колонки.Добавить("Партнер", Новый ОписаниеТипов("СправочникСсылка.Партнеры"));
				ТаблицаДляОбработки.ЗаполнитьЗначения(Поставщик, "Партнер");
				
				МенеджерАналитики = РегистрыСведений.АналитикаУчетаНоменклатуры;
				МестаУчета = МенеджерАналитики.МестаУчета(ВариантОформления, Неопределено, Подразделение, Неопределено);
				
				РасчетИменПолей = МенеджерАналитики.МестаУчета(ХозОперация, "Склад", Подразделение, "Партнер");
				
				ИменаПолей = МенеджерАналитики.ИменаПолейКоллекцииПоУмолчанию();
				ИменаПолей.Произвольный = РасчетИменПолей.Произвольный;
				
				Если ХозОперация = Перечисления.ХозяйственныеОперации.ЗакупкаПоИмпортуТоварыВПути Тогда
					ИменаПолей.СтатусУказанияСерий = "";
					ИменаПолей.Серия = "";
				КонецЕсли;
				
				МенеджерАналитики.ЗаполнитьВКоллекции(ТаблицаДляОбработки, МестаУчета, ИменаПолей);
				
				ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(ТаблицаДляОбработки, ИтоговаяТЧ);
				
			КонецЦикла;
			
			Товары.Загрузить(ИтоговаяТЧ);
			
			ВременныеТаблицы = ВременныеТаблицы();
			ЗапасыСервер.ЗаполнитьВидыЗапасовПоУмолчанию(ВременныеТаблицы, Товары);
			
			ЗаполнитьНомераГТД(ВременныеТаблицы);
			
		КонецЕсли;
		
		Если СуммаДокумента > 0 И НЕ ПорядокРасчетов = Перечисления.ПорядокРасчетов.ПоДоговорамКонтрагентов Тогда
			ВзаиморасчетыСервер.ЗаполнитьСуммыРасшифровкиНакладной(СуммаДокумента, СуммаВзаиморасчетов, РасшифровкаПлатежа);
		Иначе
			Если РасшифровкаПлатежа.Количество() <> 0 Тогда
				РасшифровкаПлатежа.Очистить();
			КонецЕсли;
		КонецЕсли;
		
	ИначеЕсли РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
		Для Каждого Товар Из Товары Цикл
			Товар.ВидЗапасов = Неопределено;
		КонецЦикла;
	КонецЕсли;
	
	ПорядокРасчетов = ВзаиморасчетыСервер.ПорядокРасчетовПоДокументу(ЭтотОбъект);
	НоменклатураСервер.ОчиститьНеиспользуемыеСерии(
		ЭтотОбъект, НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ТаможеннаяДекларацияИмпорт));
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	РасшифровкаПлатежа.Очистить();
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	Документы.ТаможеннаяДекларацияИмпорт.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	ВзаиморасчетыСервер.ОтразитьРасчетыСПоставщиками(ДополнительныеСвойства, Движения, Отказ);
	ДоходыИРасходыСервер.ОтразитьПрочиеРасходы(ДополнительныеСвойства, Движения, Отказ);
	ДоходыИРасходыСервер.ОтразитьПартииПрочихРасходов(ДополнительныеСвойства, Движения, Отказ);
	ДоходыИРасходыСервер.ОтразитьПрочиеАктивыПассивы(ДополнительныеСвойства, Движения, Отказ);
	ДоходыИРасходыСервер.ОтразитьСебестоимостьТоваров(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьТоварыКОформлениюТаможенныхДеклараций(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьТоварыОрганизаций(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьДатыПоступленияТоваровОрганизаций(ДополнительныеСвойства, Отказ);
	ЗапасыСервер.ОтразитьТоварыУПартнеров(ДополнительныеСвойства, Движения, Отказ);
	ДоходыИРасходыСервер.ОтразитьЖурналУчетаСчетовФактур(ДополнительныеСвойства, Движения, Отказ);
	ДоходыИРасходыСервер.ОтразитьНДСПредъявленный(ДополнительныеСвойства, Движения, Отказ);
	ПартионныйУчетСервер.ОтразитьПартииРасходовНаСебестоимостьТоваров(ДополнительныеСвойства, Движения, Отказ);
	
	// Движения по оборотным регистрам управленческого учета
	УправленческийУчетПроведениеСервер.ОтразитьЗакупки(ДополнительныеСвойства, Движения, Отказ);
	УправленческийУчетПроведениеСервер.ОтразитьДвиженияКонтрагентДоходыРасходы(ДополнительныеСвойства, Движения, Отказ);
	
	РегистрыСведений.РеестрДокументов.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	РегистрыСведений.ПодтверждениеОплатыНДСВБюджет.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	
	
	СформироватьСписокРегистровДляКонтроля();
	
	ЗапасыСервер.ПодготовитьЗаписьТоваровОрганизаций(ЭтотОбъект, РежимЗаписиДокумента.Проведение);
	
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПараметрыЗаполнения = ЗапасыСервер.ПараметрыЗаполненияВидовЗапасов();
	ЗапасыСервер.СформироватьРезервыПоТоварамОрганизаций(ЭтотОбъект, Отказ, ПараметрыЗаполнения);

	ПроведениеСерверУТ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	СформироватьСписокРегистровДляКонтроля();
	
	ЗапасыСервер.ПодготовитьЗаписьТоваровОрганизаций(ЭтотОбъект, РежимЗаписиДокумента.ОтменаПроведения);
	
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПараметрыЗаполнения = ЗапасыСервер.ПараметрыЗаполненияВидовЗапасов();
	ЗапасыСервер.СформироватьРезервыПоТоварамОрганизаций(ЭтотОбъект, Отказ, ПараметрыЗаполнения);

	ПроведениеСерверУТ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Отказ
		И Не ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		РегистрыСведений.РеестрДокументов.ИнициализироватьИЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	Запрос = Новый Запрос();
	Реквизиты = Документы.ТаможеннаяДекларацияИмпорт.СтруктураЗаполнения();
	ТипДанных = ТипЗнч(ДанныеЗаполнения);
	Если ТипДанных = Тип("ДокументСсылка.ПриобретениеТоваровУслуг") Тогда
		Запрос.Текст = "
		|ВЫБРАТЬ
		|	ХозяйственнаяОперация КАК ВариантОформления,
		|	Валюта КАК ВалютаПоступления,
		|	Дата КАК ДатаПоступления,
		|	ЦенаВключаетНДС КАК ЦенаВключаетНДС,
		|	Организация КАК Организация,
		|	Партнер КАК Поставщик,
		|	Проведен КАК Проведен,
		|	Контрагент КАК КонтрагентПоставщика,
		|	НаправлениеДеятельности КАК НаправлениеДеятельности
		|ИЗ
		|	Документ.ПриобретениеТоваровУслуг
		|ГДЕ
		|	Ссылка = &Ссылка
		|";
		Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения);
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			ОбщегоНазначенияУТ.ПроверитьВозможностьВводаНаОсновании(ДанныеЗаполнения, , Не Выборка.Проведен);
			
			ХозяйственныеОперацииИмпорта = ЗакупкиСервер.ХозяйственныеОперацииПоОсновной(
				Перечисления.ХозяйственныеОперации.ЗакупкаПоИмпорту);

			Если ХозяйственныеОперацииИмпорта.Найти(Выборка.ВариантОформления) = Неопределено Тогда
				Ошибка = НСтр("ru='Ввод таможенной декларации на основании поступления с операцией %Операция% не требуется.'");
				ВызватьИсключение СтрЗаменить(Ошибка, "%Операция%", Выборка.ВариантОформления);
			КонецЕсли;

			Запрос.Текст = "
			|ВЫБРАТЬ
			|	Строки.Номенклатура,
			|	Строки.Характеристика,
			|	Строки.Склад,
			|	Строки.Назначение,
			|	Строки.ВидЗапасов,
			|	СУММА(Строки.Количество) КАК Количество
			|
			|ПОМЕСТИТЬ Импорт
			|ИЗ
			|	Документ.ТаможеннаяДекларацияИмпорт КАК Импорт
			|
			|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
			|		Документ.ТаможеннаяДекларацияИмпорт.Товары КАК Строки
			|	ПО
			|		Строки.Ссылка = Импорт.Ссылка
			|ГДЕ
			|	Импорт.Проведен
			|	И Строки.ДокументПоступления = &Ссылка
			|
			|СГРУППИРОВАТЬ ПО
			|	Строки.Номенклатура,
			|	Строки.Характеристика,
			|	Строки.Склад,
			|	Строки.Назначение,
			|	Строки.ВидЗапасов
			|;
			|///////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	Товары.Ссылка.Дата КАК ДатаДокумента,
			|	Товары.Номенклатура,
			|	Товары.Характеристика,
			|	Товары.Назначение,
			|	Товары.Серия,
			|	Товары.Назначение,
			|	Товары.СтавкаНДС,
			|	НЕОПРЕДЕЛЕНО КАК Упаковка,
			|	0 КАК Цена,
			|	Товары.Количество - ЕСТЬNULL(Импорт.Количество, 0) КАК КоличествоУпаковок,
			|	Товары.Количество - ЕСТЬNULL(Импорт.Количество, 0) КАК Количество,
			|	Товары.Сумма * (Товары.Количество - ЕСТЬNULL(Импорт.Количество, 0)) / Товары.Количество КАК Сумма,
			|	Товары.СуммаНДС * (Товары.Количество - ЕСТЬNULL(Импорт.Количество, 0)) / Товары.Количество КАК СуммаНДС,
			|	Товары.СуммаСНДС * (Товары.Количество - ЕСТЬNULL(Импорт.Количество, 0)) / Товары.Количество КАК СуммаСНДС,
			|	Товары.Склад КАК Склад,
			|	Товары.Ссылка КАК ДокументПоступления,
			|	Товары.Ссылка.ЗакупкаПодДеятельность КАК ЗакупкаПодДеятельность,
			|	Товары.Ссылка.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
			|	Товары.ВидЗапасов КАК ВидЗапасов
			|ИЗ
			|	Документ.ПриобретениеТоваровУслуг.Товары КАК Товары
			|
			|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
			|		Справочник.Номенклатура КАК НоменклатураСпр
			|	ПО
			|		НоменклатураСпр.Ссылка = Товары.Номенклатура
			|
			|	ЛЕВОЕ СОЕДИНЕНИЕ
			|		Импорт КАК Импорт
			|	ПО
			|		Импорт.Номенклатура = Товары.Номенклатура
			|		И Импорт.Характеристика = Товары.Характеристика
			|		И Импорт.Склад = Товары.Склад
			|		И Импорт.Назначение = Товары.Назначение
			|		И Импорт.ВидЗапасов = Товары.ВидЗапасов
			|ГДЕ
			|	Товары.Ссылка = &Ссылка
			|	И Товары.Количество > 0.
			|	И НоменклатураСпр.ТипНоменклатуры В
			|		(ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар),ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара))
			|";
			
			ЗаполнитьЗначенияСвойств(Реквизиты, Выборка);
			Реквизиты.Товары = Запрос.Выполнить().Выгрузить();
			Документы.ТаможеннаяДекларацияИмпорт.ЗаполнитьПоДанным(ЭтотОбъект, Реквизиты);
		КонецЕсли;
	ИначеЕсли ТипДанных = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(Реквизиты, ДанныеЗаполнения);
		Если ДанныеЗаполнения.Свойство("ЗапросТовары") Тогда
			Запрос.Текст = ДанныеЗаполнения.ЗапросТовары;
			Для Каждого Свойство Из ДанныеЗаполнения Цикл
				Запрос.УстановитьПараметр(Свойство.Ключ, Свойство.Значение);
			КонецЦикла;
			Реквизиты.Товары = Запрос.Выполнить().Выгрузить();
		ИначеЕсли ДанныеЗаполнения.Свойство("Товары") Тогда
			Реквизиты.Товары = ДанныеЗаполнения.Товары;
		КонецЕсли;
		Документы.ТаможеннаяДекларацияИмпорт.ЗаполнитьПоДанным(ЭтотОбъект, Реквизиты);
	Иначе
		Документы.ТаможеннаяДекларацияИмпорт.ЗаполнитьПоУмолчанию(ЭтотОбъект);
	КонецЕсли;
	ДополнительныеСвойства.Вставить("НеобходимостьЗаполненияСчетаПриФОИспользоватьНесколькоСчетовЛожь", Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПроцедурыЗаполненияЗначенийАвтоподстановкиВидыЗапасовНомераГтд

Функция ВременныеТаблицы()
	ВременныеТаблицы = Новый МенеджерВременныхТаблиц;
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Товары.НомерСтроки КАК НомерСтроки,
	|	Товары.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ВЫРАЗИТЬ(Товары.Номенклатура КАК Справочник.Номенклатура) КАК Номенклатура,
	|	ЛОЖЬ КАК ЭтоВозвратнаяТара,
	|	&Организация КАК Организация,
	|	&Соглашение КАК Соглашение,
	|	&Контрагент КАК Контрагент,
	|	&Договор КАК Договор,
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК Валюта,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПустаяСсылка) КАК НалогообложениеНДС,
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК НалогообложениеОрганизации,
	|	ЗНАЧЕНИЕ(Справочник.ГруппыФинансовогоУчетаДенежныхСредств.ПустаяСсылка) КАК ГруппаФинансовогоУчета,
	|	ЗНАЧЕНИЕ(Справочник.ГруппыАналитическогоУчетаНоменклатуры.ПустаяСсылка) КАК ГруппаПродукции,
	|	ЗНАЧЕНИЕ(Справочник.ВидыЦен.ПустаяСсылка) КАК ВидЦены,
	|	ВЫРАЗИТЬ(Товары.ВидЗапасов КАК Справочник.ВидыЗапасов) КАК ВидЗапасов,
	|	Товары.НомерРаздела КАК НомерРаздела,
	|	Товары.СтранаПроисхождения КАК СтранаПроисхождения,
	|	Товары.НомерДляСФ КАК НомерДляСФ,
	|	Товары.НомерГТД КАК НомерГТД,
	|	Товары.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	ВЫБОР
	|		КОГДА Товары.ХозяйственнаяОперация В
	|			(ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ЗакупкаВСтранахЕАЭСТоварыВПути),
	|			 ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ЗакупкаПоИмпортуТоварыВПути),
	|			 ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ЗакупкаУПоставщикаТоварыВПути))
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.СобственныйТоварВПути)
	|		КОГДА Товары.ХозяйственнаяОперация В
	|			(ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ЗакупкаВСтранахЕАЭСФактуровкаПоставки),
	|			 ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ЗакупкаУПоставщикаФактуровкаПоставки))
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.СобственныйТоварПоНеотфактурованнойПоставке)
	|		КОГДА Товары.ХозяйственнаяОперация В
	|			(ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПриемНаКомиссию))
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.КомиссионныйТовар)
	|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.Товар)
	|	КОНЕЦ КАК ТипЗапасов
	|
	|ПОМЕСТИТЬ ТаблицаТоваров
	|ИЗ
	|	&Товары КАК Товары
	|;
	|///////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаРазделов.НомерРаздела КАК НомерРаздела,
	|	ТаблицаРазделов.НомерДляСФ КАК НомерДляСФ
	|
	|ПОМЕСТИТЬ Разделы
	|ИЗ
	|	&ТаблицаРазделов КАК ТаблицаРазделов
	|;
	|///////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВЫБОР КОГДА &НумероватьПоТоварам ТОГДА
	|		Товары.НомерДляСФ
	|	ИНАЧЕ
	|		Разделы.НомерДляСФ
	|	КОНЕЦ 						КАК НомерДляСФ,
	|	&РегистрационныйНомер 		КАК РегистрационныйНомер,
	|	ВЫБОР КОГДА &НумероватьПоТоварам ТОГДА
	|		Товары.НомерСтроки
	|	ИНАЧЕ
	|		Разделы.НомерРаздела
	|	КОНЕЦ 						КАК ПорядковыйНомерТовара,
	|	Товары.СтранаПроисхождения	КАК СтранаПроисхождения
	|
	|ПОМЕСТИТЬ ГенерацияГТД
	|ИЗ
	|	ТаблицаТоваров КАК Товары
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Разделы КАК Разделы
	|	ПО
	|		Разделы.НомерРаздела = Товары.НомерРаздела
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		Справочник.НомераГТД КАК УказанныеГТД
	|	ПО
	|		УказанныеГТД.Ссылка = Товары.НомерГТД
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		Справочник.НомераГТД КАК ПодобранныеГТД
	|	ПО
	|		ПодобранныеГТД.СтранаПроисхождения = Товары.СтранаПроисхождения
	|		И НЕ ПодобранныеГТД.ПометкаУдаления
	|		И ПодобранныеГТД.Код = (
	|			ВЫБОР КОГДА &НумероватьПоТоварам ТОГДА
	|				Товары.НомерДляСФ
	|			ИНАЧЕ
	|				Разделы.НомерДляСФ
	|			КОНЕЦ)
	|ГДЕ
	|	УказанныеГТД.Ссылка ЕСТЬ NULL
	|	И ПодобранныеГТД.Ссылка ЕСТЬ NULL
	|	
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки КАК НомерСтроки,
	|	ТаблицаТоваров.Номенклатура КАК Номенклатура,
	|	ВЫБОР
	|		КОГДА &Проведен
	|			ТОГДА ТаблицаТоваров.ВидЗапасов
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ВидыЗапасов.ПустаяСсылка)
	|	КОНЕЦ КАК ТекущийВидЗапасов,
	|	ЛОЖЬ КАК ЭтоВозвратнаяТара,
	|	ТаблицаТоваров.Организация КАК Организация,
	|	ТаблицаТоваров.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	ТаблицаТоваров.ТипЗапасов КАК ТипЗапасов,
	|	ТаблицаТоваров.Соглашение КАК Соглашение,
	|	ТаблицаТоваров.Валюта КАК Валюта,
	|	ТаблицаТоваров.НалогообложениеНДС КАК НалогообложениеНДС,
	|	ТаблицаТоваров.НалогообложениеОрганизации КАК НалогообложениеОрганизации,
	|	НЕОПРЕДЕЛЕНО КАК ВладелецТовара,
	|	НЕОПРЕДЕЛЕНО КАК Контрагент,
	|	НЕОПРЕДЕЛЕНО КАК Договор
	|ПОМЕСТИТЬ ИсходнаяТаблицаТоваров
	|ИЗ
	|	ТаблицаТоваров КАК ТаблицаТоваров
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыЗапасов КАК РеквизитыВидаЗапасов
	|		ПО ТаблицаТоваров.ВидЗапасов = РеквизитыВидаЗапасов.Ссылка
	|ГДЕ
	|	ТаблицаТоваров.Номенклатура.ТипНоменклатуры <> ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Работа)
	|	И (ТаблицаТоваров.ВидЗапасов = ЗНАЧЕНИЕ(Справочник.ВидыЗапасов.ПустаяСсылка)
	|			ИЛИ
	|			(ТаблицаТоваров.ХозяйственнаяОперация В
	|				(ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ЗакупкаПоИмпортуТоварыВПути),
	|				 ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ЗакупкаПоИмпортуПоступлениеИзТоваровВПути)
	|				)
	|			И ТаблицаТоваров.ВидЗапасов.ТипЗапасов <> ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.СобственныйТоварВПути))
	|			ИЛИ
	|			(ТаблицаТоваров.ХозяйственнаяОперация В
	|				(ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ЗакупкаПоИмпорту)
	|				)
	|			И ТаблицаТоваров.ВидЗапасов.ТипЗапасов = ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.СобственныйТоварВПути))
	|		)");
	
	Запрос.МенеджерВременныхТаблиц = ВременныеТаблицы;
	Запрос.УстановитьПараметр("Товары",
		Товары.Выгрузить(, "НомерСтроки, АналитикаУчетаНоменклатуры, Номенклатура, ВидЗапасов, НомерРаздела, СтранаПроисхождения, НомерДляСФ, НомерГТД, ХозяйственнаяОперация"));
	Запрос.УстановитьПараметр("ТаблицаРазделов", Разделы.Выгрузить(, "НомерРаздела, НомерДляСФ"));
	Запрос.УстановитьПараметр("НумероватьПоТоварам", НумероватьПоТоварам);
	Запрос.УстановитьПараметр("РегистрационныйНомер", НомерДекларации);
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Соглашение", Соглашение);
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Запрос.УстановитьПараметр("Договор", Договор);
	Запрос.УстановитьПараметр("Проведен", Проведен);
	
	ЗапасыСервер.ДополнитьВременныеТаблицыОбязательнымиКолонками(Запрос);
	ЗапасыСервер.ПроверитьНеобходимостьПерезаполненияВидовЗапасовДокумента(ЭтотОбъект, Запрос);
	
	Запрос.Выполнить();
	Возврат ВременныеТаблицы;
КонецФункции

Процедура ЗаполнитьНомераГТД(ВременныеТаблицы)
	
	// Создаем новые номера ГТД по временной таблице ГенерацияГТД.
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ГенерацияГТД.НомерДляСФ,
	|	ГенерацияГТД.РегистрационныйНомер,
	|	ГенерацияГТД.ПорядковыйНомерТовара,
	|	ГенерацияГТД.СтранаПроисхождения
	|ИЗ
	|	ГенерацияГТД КАК ГенерацияГТД
	|");
	Запрос.МенеджерВременныхТаблиц = ВременныеТаблицы;
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		НомерГТД = Справочники.НомераГТД.СоздатьЭлемент();
		НомерГТД.Код = Выборка.НомерДляСФ;
		НомерГТД.ПорядковыйНомерТовара = Выборка.ПорядковыйНомерТовара;
		НомерГТД.РегистрационныйНомер = Выборка.РегистрационныйНомер;
		НомерГТД.СтранаПроисхождения = Выборка.СтранаПроисхождения;
		НомерГТД.Записать();
	КонецЦикла;
	
	// Подбираем номера ГТД в товары.
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	Товары.НомерСтроки,
	|	Товары.СтранаПроисхождения,
	|	ВЫБОР КОГДА &НумероватьПоТоварам ТОГДА
	|		Товары.НомерДляСФ
	|	ИНАЧЕ
	|		Разделы.НомерДляСФ
	|	КОНЕЦ КАК НомерДляСФ,
	|	ПодобранныеГТД.Ссылка КАК НомерГТД
	|ИЗ
	|	ТаблицаТоваров КАК Товары
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Разделы
	|	ПО
	|		Разделы.НомерРаздела = Товары.НомерРаздела
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		Справочник.НомераГТД КАК УказанныеГТД
	|	ПО
	|		УказанныеГТД.Ссылка = Товары.НомерГТД
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		Справочник.НомераГТД КАК ПодобранныеГТД
	|	ПО
	|		ПодобранныеГТД.СтранаПроисхождения = Товары.СтранаПроисхождения
	|		И НЕ ПодобранныеГТД.ПометкаУдаления
	|		И ПодобранныеГТД.Код = (
	|			ВЫБОР КОГДА &НумероватьПоТоварам ТОГДА
	|				Товары.НомерДляСФ
	|			ИНАЧЕ
	|				Разделы.НомерДляСФ
	|			КОНЕЦ)
	|ГДЕ
	|	УказанныеГТД.Ссылка ЕСТЬ NULL
	|УПОРЯДОЧИТЬ ПО
	|	Товары.НомерСтроки
	|";
	Запрос.УстановитьПараметр("НумероватьПоТоварам", НумероватьПоТоварам);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		// слияние упорядоченных массивов, |Выборки| <= |Товары|
		Для Каждого Товар Из Товары Цикл
			Если ЗначениеЗаполнено(Товар.НомерГТД) Или Товар.НомерСтроки < Выборка.НомерСтроки Тогда
				Продолжить;
			КонецЕсли;
			
			Если Не ЗначениеЗаполнено(Выборка.НомерГТД) Тогда
				ВызватьИсключение НСтр("ru='Обнаружены проблемы в подборе номеров ГТД!'");
			КонецЕсли;
			
			Товар.НомерГТД = Выборка.НомерГТД;

			Если Не Выборка.Следующий() Тогда
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область Прочее

Процедура СформироватьСписокРегистровДляКонтроля()
	
	ХозяйственныеОперации = Товары.ВыгрузитьКолонку("ХозяйственнаяОперация");
	ЕстьОперацияДляКонтроля = ХозяйственныеОперации.Найти(Перечисления.ХозяйственныеОперации.ЗакупкаПоИмпортуТоварыВПути) <> Неопределено;
	КонтролироватьНомераГТД = ПолучитьФункциональнуюОпцию("КонтролироватьОстаткиНомеровГТДПриИмпортеПоСхемеТоварыВПути")
								И ЕстьОперацияДляКонтроля;
	
	Массив = Новый Массив;
	// Приходы в регистр контролируем при перепроведении и отмене проведения
	Если Не ДополнительныеСвойства.ЭтоНовый Тогда
		Массив.Добавить(Движения.ТоварыОрганизаций);
	КонецЕсли;
	// Расходы из регистра контролируем только при проведении
	Если ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		Массив.Добавить(Движения.ТоварыКОформлениюТаможенныхДеклараций);
	КонецЕсли;
	
	Если КонтролироватьНомераГТД Тогда
		Массив.Добавить(Движения.ТоварыУПартнеров);
	КонецЕсли;
	
	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Массив);
КонецПроцедуры

Процедура ПроверитьИСообщитьОшибку(УсловиеОшибки, Отказ, Знач Шаблон, Знач ИмяПоля, Знач СинонимПоля, Знач ИмяТабчасти = Неопределено, Знач НомерСтроки = Неопределено)
	Если УсловиеОшибки Тогда
		Сообщение = СтрЗаменить(Шаблон, "%СинонимПоля%", СинонимПоля);
		Сообщение = СтрЗаменить(Сообщение, "%НомерСтроки%", НомерСтроки);
		Сообщение = СтрЗаменить(Сообщение, "%ИмяТабчасти%", ИмяТабчасти);
		Если ЗначениеЗаполнено(ИмяТабчасти) И НомерСтроки > 0 Тогда
			ИмяПоля = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти(ИмяТабчасти, НомерСтроки, ИмяПоля);
		КонецЕсли;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Сообщение, , ИмяПоля, "Объект", Отказ);
	КонецЕсли;
КонецПроцедуры

Процедура ЗаполнитьСклад()
	Для Каждого Строка Из Товары Цикл
		Строка.Склад = ЗначениеНастроекПовтИсп.ПолучитьСкладПоУмолчанию(Строка.Склад, Ложь, Истина);
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
