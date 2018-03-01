#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКопировании(ОбъектКопирования)
	
	ИнициализироватьДокумент();
	ВидЗапасов = Неопределено;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ДокументОснование = Неопределено;
	ЗаполнитьТабличнуюЧастьТовары = Истина;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		Если ДанныеЗаполнения.Свойство("АктОРасхождениях") 
			И ДанныеЗаполнения.Свойство("ОснованиеАкта") Тогда
			
			ЗаполнитьДокументНаОснованииАктаПриемки(ДанныеЗаполнения);
			ЗаполнитьТабличнуюЧастьТовары = Ложь;
			ДокументОснование = ДанныеЗаполнения.АктОРасхождениях;
			
		Иначе
			
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
			ЗаполнитьТабличнуюЧастьТовары = НЕ ДанныеЗаполнения.Свойство("НеЗаполнятьТаблинуюЧастьТовары");
			
		КонецЕсли;
		
	ИначеЕсли Документы.ТипВсеСсылки().СодержитТип(ТипЗнч(ДанныеЗаполнения))
		И ДанныеЗаполнения <> Неопределено Тогда 	
	
		Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПересчетТоваров") Тогда 
			СтруктураРезультат = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДанныеЗаполнения, "Статус, Склад");
			Если СтруктураРезультат.Статус <> Перечисления.СтатусыПересчетовТоваров.Выполнено Тогда 
				ТекстСообщения = НСтр("ru='Документ ""%ДокументПересчет%"" находится в статусе ""%СтатусПересчета%"". Ввод документа ""%ДокументАкт%"" на основании разрешен только в статусе ""%СтатусВыполнено%"".'");
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДокументПересчет%", ДанныеЗаполнения);
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДокументАкт%", Метаданные.Документы.ОприходованиеИзлишковТоваров.Синоним);
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%СтатусВыполнено%", Перечисления.СтатусыПересчетовТоваров.Выполнено);
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%СтатусПересчета%", СтруктураРезультат.Статус);
				ВызватьИсключение ТекстСообщения;
			КонецЕсли;
			Склад = СтруктураРезультат.Склад;
			ПересчетТоваров = ДанныеЗаполнения;
		КонецЕсли;
				
		Если Не ЗначениеЗаполнено(Склад) Тогда
			Склад = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеЗаполнения, "Склад");	
		КонецЕсли;
		
		ДокументОснование = ДанныеЗаполнения;
				
	КонецЕсли;
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
		
	Если ЗаполнитьТабличнуюЧастьТовары Тогда 
		ЗаполнитьТабличнуюЧастьТовары(ДокументОснование);
	КонецЕсли;

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеСерверУТ.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	НоменклатураСервер.ОчиститьНеиспользуемыеСерии(ЭтотОбъект,
	НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ОприходованиеИзлишковТоваров));
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		МестаУчета = РегистрыСведений.АналитикаУчетаНоменклатуры.МестаУчета(Перечисления.ХозяйственныеОперации.ОприходованиеТоваров, Склад, Подразделение, Неопределено);
		РегистрыСведений.АналитикаУчетаНоменклатуры.ЗаполнитьВКоллекции(Товары, МестаУчета);
		
		ЗаполнитьВидыЗапасовДокумента();
		ВзаиморасчетыСервер.ЗаполнитьИдентификаторыСтрокВТабличнойЧасти(Товары);
		
	КонецЕсли;
	
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

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
		
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ);
	
	НоменклатураСервер.ПроверитьЗаполнениеСерий(
		ЭтотОбъект,
		НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ОприходованиеИзлишковТоваров),
		Отказ,
		МассивНепроверяемыхРеквизитов);
	
	МассивНепроверяемыхРеквизитов.Добавить("Товары.НомерГТД");
	Если ПолучитьФункциональнуюОпцию("ЗапретитьПоступлениеТоваровБезНомеровГТД") Тогда
		ЗапасыСервер.ПроверитьЗаполнениеНомеровГТД(ЭтотОбъект, Отказ);
	КонецЕсли;
	
	ПланыВидовХарактеристик.СтатьиДоходов.ПроверитьЗаполнениеАналитик(
		ЭтотОбъект,, МассивНепроверяемыхРеквизитов, Отказ);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	Документы.ОприходованиеИзлишковТоваров.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ЗапасыСервер.ОтразитьТоварыНаСкладах(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьТоварыОрганизаций(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьСвободныеОстатки(ДополнительныеСвойства, Движения, Отказ);
	СкладыСервер.ОтразитьДвиженияСерийТоваров(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьТоварыКОформлениюИзлишковНедостач(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьДатыПоступленияТоваровОрганизаций(ДополнительныеСвойства, Отказ);
	ЗапасыСервер.ОтразитьОбеспечениеЗаказов(ДополнительныеСвойства, Движения, Отказ);
	
	ДоходыИРасходыСервер.ОтразитьСебестоимостьТоваров(ДополнительныеСвойства, Движения, Отказ);
	ДоходыИРасходыСервер.ОтразитьПрочиеДоходы(ДополнительныеСвойства, Движения, Отказ);
	
	ВзаиморасчетыСервер.ОтразитьСуммыДокументаВВалютеРегл(ДополнительныеСвойства, Движения, Отказ);
	
	ПартионныйУчетСервер.ОтразитьПартииТоваровОрганизаций(ДополнительныеСвойства, Движения, Отказ);
	
	// Движения по оборотным регистрам управленческого учета
	УправленческийУчетПроведениеСервер.ОтразитьДвиженияНоменклатураДоходыРасходы(ДополнительныеСвойства, Движения, Отказ);
	
	РегистрыСведений.РеестрДокументов.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);

	
	СформироватьСписокРегистровДляКонтроля();
	
	ЗапасыСервер.ПодготовитьЗаписьТоваровОрганизаций(ЭтотОбъект, РежимЗаписиДокумента.Проведение);	
	
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПараметрыЗаполнения = ЗапасыСервер.ПараметрыЗаполненияВидовЗапасов();
	ЗапасыСервер.СформироватьРезервыПоТоварамОрганизаций(ЭтотОбъект, Отказ, ПараметрыЗаполнения);
	
	ПроведениеСерверУТ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	ПроведениеСерверУТ.ЗаписатьПодчиненныеНаборамЗаписейДанные(ЭтотОбъект, Отказ);
	
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	РегистрыСведений.СостоянияЗаказовКлиентов.ОтразитьСостояниеЗаказа(ЭтотОбъект, Отказ);
	
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
	ПроведениеСерверУТ.ЗаписатьПодчиненныеНаборамЗаписейДанные(ЭтотОбъект, Отказ);
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	РегистрыСведений.СостоянияЗаказовКлиентов.ОтразитьСостояниеЗаказа(ЭтотОбъект, Отказ);
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ЗаполнитьТабличнуюЧастьТовары(ДокументОснование = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	
	ИспользоватьОрдернуюСхемуПриОтраженииИзлишковНедостач = СкладыСервер.ИспользоватьОрдернуюСхемуПриОтраженииИзлишковНедостач(Склад);
	
	Если ИспользоватьОрдернуюСхемуПриОтраженииИзлишковНедостач Тогда 
	
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ТоварыКОформлению.Номенклатура КАК Номенклатура,
		|	ТоварыКОформлению.Характеристика КАК Характеристика,
		|	ТоварыКОформлению.Назначение КАК Назначение,
		|	ТоварыКОформлению.Серия КАК Серия,
		|	СУММА(ТоварыКОформлению.КОформлениюАктовОстаток) КАК Количество
		|ПОМЕСТИТЬ ТоварыКОформлению
		|ИЗ
		|	(ВЫБРАТЬ
		|		ТоварыКОформлению.Номенклатура КАК Номенклатура,
		|		ТоварыКОформлению.Характеристика КАК Характеристика,
		|		ТоварыКОформлению.Серия КАК Серия,
		|		ТоварыКОформлению.Назначение КАК Назначение,
		|		ТоварыКОформлению.КОформлениюАктовОстаток КАК КОформлениюАктовОстаток
		|	ИЗ
		|		РегистрНакопления.ТоварыКОформлениюИзлишковНедостач.Остатки(, Склад = &Склад) КАК ТоварыКОформлению
		|	ГДЕ
		|		ТоварыКОформлению.КОформлениюАктовОстаток > 0
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		ТоварыКОформлению.Номенклатура,
		|		ТоварыКОформлению.Характеристика,
		|		ТоварыКОформлению.Серия,
		|		ТоварыКОформлению.Назначение,
		|		ТоварыКОформлению.КОформлениюАктов
		|	ИЗ
		|		РегистрНакопления.ТоварыКОформлениюИзлишковНедостач КАК ТоварыКОформлению
		|	ГДЕ
		|		ТоварыКОформлению.Регистратор = &Ссылка
		|		И ТоварыКОформлению.Активность = ИСТИНА) КАК ТоварыКОформлению
		|
		|СГРУППИРОВАТЬ ПО
		|	ТоварыКОформлению.Номенклатура,
		|	ТоварыКОформлению.Характеристика,
		|	ТоварыКОформлению.Назначение,
		|	ТоварыКОформлению.Серия
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ТоварыКОформлению.Номенклатура,
		|	ТоварыКОформлению.Характеристика,
		|	ТоварыКОформлению.Серия,
		|	ТоварыКОформлению.Назначение,
		|	ТоварыКОформлению.Количество
		|ИЗ
		|	ТоварыКОформлению КАК ТоварыКОформлению
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПересчетТоваров.Товары КАК ПересчетТоваровТовары
		|		ПО (&НаОснованииПересчета)
		|			И ТоварыКОформлению.Номенклатура = ПересчетТоваровТовары.Номенклатура
		|			И ТоварыКОформлению.Характеристика = ПересчетТоваровТовары.Характеристика
		|			И ТоварыКОформлению.Назначение = ПересчетТоваровТовары.Назначение
		|			И (ПересчетТоваровТовары.СтатусУказанияСерий <> 14
		|				ИЛИ ТоварыКОформлению.Серия = ПересчетТоваровТовары.Серия)
		|			И (ПересчетТоваровТовары.Количество <> ПересчетТоваровТовары.КоличествоФакт)
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ОрдерНаОтражениеИзлишковТоваров.Товары КАК ОрдерНаОтражениеИзлишковТоваровТовары
		|		ПО (&НаОснованииОрдера)
		|			И ТоварыКОформлению.Номенклатура = ОрдерНаОтражениеИзлишковТоваровТовары.Номенклатура
		|			И ТоварыКОформлению.Характеристика = ОрдерНаОтражениеИзлишковТоваровТовары.Характеристика
		|			И ТоварыКОформлению.Назначение = ОрдерНаОтражениеИзлишковТоваровТовары.Назначение
		|			И (ОрдерНаОтражениеИзлишковТоваровТовары.СтатусУказанияСерий <> 14
		|				ИЛИ ТоварыКОформлению.Серия = ОрдерНаОтражениеИзлишковТоваровТовары.Серия)
		|ГДЕ
		|	(НЕ &НаОснованииПересчета
		|			ИЛИ &НаОснованииПересчета
		|				И НЕ ПересчетТоваровТовары.Номенклатура ЕСТЬ NULL 
		|				И ПересчетТоваровТовары.Ссылка = &ДокументОснование)
		|	И (НЕ &НаОснованииОрдера
		|			ИЛИ &НаОснованииОрдера
		|				И НЕ ОрдерНаОтражениеИзлишковТоваровТовары.Номенклатура ЕСТЬ NULL 
		|				И ОрдерНаОтражениеИзлишковТоваровТовары.Ссылка = &ДокументОснование)";
		
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		Запрос.УстановитьПараметр("Склад", Склад);
		Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
		НаОснованииПересчета = ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ПересчетТоваров");
		Запрос.УстановитьПараметр("НаОснованииПересчета", НаОснованииПересчета);
		НаОснованииОрдера = ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ОрдерНаОтражениеИзлишковТоваров");
		Запрос.УстановитьПараметр("НаОснованииОрдера", НаОснованииОрдера);
		
	Иначе 
		
		// На неордерном складе ДокументОснование будет только пересчет
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПересчетТоваровТовары.Номенклатура,
		|	ПересчетТоваровТовары.Характеристика,
		|	ПересчетТоваровТовары.Назначение,
		|	ПересчетТоваровТовары.Серия,
		|	ПересчетТоваровТовары.КоличествоФакт - ПересчетТоваровТовары.Количество КАК Количество
		|ИЗ
		|	Документ.ПересчетТоваров.Товары КАК ПересчетТоваровТовары
		|ГДЕ
		|	ПересчетТоваровТовары.Ссылка = &Ссылка
		|	И ПересчетТоваровТовары.КоличествоФакт - ПересчетТоваровТовары.Количество > 0";
		
		Запрос.УстановитьПараметр("Ссылка", ДокументОснование);
			
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	Результат = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Если Не Результат.Пустой() Тогда
		
		Товары.Загрузить(Результат.Выгрузить());
		
		Если ЗначениеЗаполнено(ВидЦены) И Товары.Количество() > 0 Тогда
			
			ПараметрыЗаполнения = Новый Структура;
			КолонкиПоЗначению = Новый Структура("Упаковка", Справочники.УпаковкиЕдиницыИзмерения.ПустаяСсылка());
			
			ПараметрыЗаполнения.Вставить("Дата",				Дата);
			ПараметрыЗаполнения.Вставить("Валюта",				Валюта);
			ПараметрыЗаполнения.Вставить("ВидЦены",				ВидЦены);
			ПараметрыЗаполнения.Вставить("КолонкиПоЗначению",	КолонкиПоЗначению);
			
			СтруктураДействий = Новый Структура("ПересчитатьСумму", "Количество");
			
			ПродажиСервер.ЗаполнитьЦены(
				Товары,,
				ПараметрыЗаполнения, 
				СтруктураДействий);
		КонецЕсли;
		
	ИначеЕсли ЗначениеЗаполнено(ДокументОснование) Тогда
		
		ТекстСообщения = НСтр("ru = 'В документе ""%ДокументОснование%"" отсутствуют товары, по которым необходимо оформить оприходование.'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДокументОснование%", ДокументОснование);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект);
		
	КонецЕсли;

КонецПроцедуры

Процедура ЗаполнитьСтатьюДоходовПоУмолчанию()
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	ДанныеДокумента.АналитикаДоходов,
	|	ДанныеДокумента.СтатьяДоходов
	|ИЗ
	|	Документ.ОприходованиеИзлишковТоваров КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ответственный = &Ответственный
	|	И ДанныеДокумента.Проведен
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДанныеДокумента.Дата УБЫВ
	|");
	
	Запрос.УстановитьПараметр("Ответственный", Ответственный);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		СтатьяДоходов    = Выборка.СтатьяДоходов;
		АналитикаДоходов = Выборка.АналитикаДоходов;
	КонецЕсли;
	
КонецПроцедуры

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Ответственный = Пользователи.ТекущийПользователь();
	Организация   = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Склад         = ЗначениеНастроекПовтИсп.ПолучитьСкладПоУмолчанию(Склад);
	Подразделение = ЗначениеНастроекПовтИсп.ПодразделениеПользователя(Ответственный, Подразделение);
	
	Если Не ЗначениеЗаполнено(ВидЦены) Тогда
		ВидЦены = Справочники.Склады.УчетныйВидЦены(Склад);
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Валюта) Тогда
		Валюта = ДоходыИРасходыСервер.ПолучитьВалютуУправленческогоУчета(
			Справочники.ВидыЦен.ПолучитьРеквизитыВидаЦены(ВидЦены).ВалютаЦены);
	КонецЕсли;
	
	ЗаполнитьСтатьюДоходовПоУмолчанию();
	
КонецПроцедуры

Процедура ЗаполнитьДокументНаОснованииАктаПриемки(ДанныеЗаполнения);
	
	ТипАктаПриемка = ТипАктаОРасхожденияхПриемка(ДанныеЗаполнения.АктОРасхождениях);
	ИспользоватьОрдернуюСхемуПриОтраженииИзлишковНедостач = СкладыСервер.ИспользоватьОрдернуюСхемуПриОтраженииИзлишковНедостач(ДанныеЗаполнения.Склад);
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	АктОРасхожденияхПослеПриемки.Организация КАК Организация,
	|	АктОРасхожденияхПослеПриемки.Менеджер КАК Ответственный,
	|	АктОРасхожденияхПослеПриемки.Подразделение КАК Подразделение,
	|	&Склад КАК Склад,
	|	&Основание КАК Основание
	|ИЗ
	|	Документ.АктОРасхожденияхПослеПриемки КАК АктОРасхожденияхПослеПриемки
	|ГДЕ
	|	АктОРасхожденияхПослеПриемки.Ссылка = &АктОРасхождениях
	|;";
	
	Запрос.УстановитьПараметр("АктОРасхождениях", ДанныеЗаполнения.АктОРасхождениях);
	Запрос.УстановитьПараметр("Склад",            ДанныеЗаполнения.Склад);
	
	Если ТипАктаПриемка Тогда
		Запрос.УстановитьПараметр("Основание", ДанныеЗаполнения.АктОРасхождениях);
	Иначе
		Запрос.УстановитьПараметр("Основание", ДанныеЗаполнения.ОснованиеАкта);
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	ВыборкаШапка = РезультатЗапроса.Выбрать();
	Если ВыборкаШапка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ВыборкаШапка);
	КонецЕсли;
	
	//Заполнение ТЧ
	
	Запрос.Текст =  "
	|ВЫБРАТЬ
	|	АктОРасхожденияхПослеПриемкиТовары.Номенклатура,
	|	АктОРасхожденияхПослеПриемкиТовары.Характеристика,
	|	АктОРасхожденияхПослеПриемкиТовары.Назначение,
	|	АктОРасхожденияхПослеПриемкиТовары.Количество - АктОРасхожденияхПослеПриемкиТовары.КоличествоПоДокументу КАК Количество,
	|	АктОРасхожденияхПослеПриемкиТовары.Серия,
	|	АктОРасхожденияхПослеПриемкиТовары.СтатусУказанияСерий
	|ИЗ
	|	Документ.АктОРасхожденияхПослеПриемки.Товары КАК АктОРасхожденияхПослеПриемкиТовары
	|ГДЕ
	|	АктОРасхожденияхПослеПриемкиТовары.Ссылка = &Ссылка
	|	И (АктОРасхожденияхПослеПриемкиТовары.ДокументОснование = &Основание
	|		Или &ТипАктаПриемка)
	|	И АктОРасхожденияхПослеПриемкиТовары.Количество - АктОРасхожденияхПослеПриемкиТовары.КоличествоПоДокументу > 0
	|	И АктОРасхожденияхПослеПриемкиТовары.Склад = &Склад
	|	И АктОРасхожденияхПослеПриемкиТовары.Действие = ЗНАЧЕНИЕ(Перечисление.ВариантыДействийПоРасхождениямВАктеПослеПриемки.ОтнестиПерепоставленноеНаПрочиеДоходы)
	|
	|УПОРЯДОЧИТЬ ПО
	|	АктОРасхожденияхПослеПриемкиТовары.НомерСтроки";
	
	Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения.АктОРасхождениях);
	Запрос.УстановитьПараметр("Склад", ДанныеЗаполнения.Склад);
	Запрос.УстановитьПараметр("Основание", ДанныеЗаполнения.ОснованиеАкта);
	Запрос.УстановитьПараметр("ТипАктаПриемка", ТипАктаПриемка);

	УстановитьПривилегированныйРежим(Истина);
	Результат = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Если Не Результат.Пустой() Тогда
		
		Товары.Загрузить(Результат.Выгрузить());
		
		Если ЗначениеЗаполнено(ВидЦены) И Товары.Количество() > 0 Тогда
			
			ПараметрыЗаполнения = Новый Структура;
			КолонкиПоЗначению = Новый Структура("Упаковка", Справочники.УпаковкиЕдиницыИзмерения.ПустаяСсылка());
			
			ПараметрыЗаполнения.Вставить("Дата",				Дата);
			ПараметрыЗаполнения.Вставить("Валюта",				Валюта);
			ПараметрыЗаполнения.Вставить("ВидЦены",				ВидЦены);
			ПараметрыЗаполнения.Вставить("КолонкиПоЗначению",	КолонкиПоЗначению);
			
			СтруктураДействий = Новый Структура("ПересчитатьСумму", "Количество");
			
			ПродажиСервер.ЗаполнитьЦены(
				Товары,,
				ПараметрыЗаполнения, 
				СтруктураДействий);
			
		КонецЕсли;
		
	ИначеЕсли ЗначениеЗаполнено(ДанныеЗаполнения.АктОРасхождениях) Тогда  
		
		ТекстСообщения = НСтр("ru = 'В документе ""%ДокументОснование%"" отсутствуют товары, по которым необходимо оформить оприходование.'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДокументОснование%", ДанныеЗаполнения.АктОРасхождениях);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ВидыЗапасов

Процедура ЗаполнитьВидыЗапасовДокумента()
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки КАК НомерСтроки,
	|	ТаблицаТоваров.Номенклатура КАК Номенклатура,
	|	ТаблицаТоваров.ВидЗапасов КАК ВидЗапасов
	|ПОМЕСТИТЬ ВтИсходнаяТаблицаТоваров
	|ИЗ
	|	&ТаблицаТоваров КАК ТаблицаТоваров
	|ГДЕ
	|	ТаблицаТоваров.ВидЗапасов = ЗНАЧЕНИЕ(Справочник.ВидыЗапасов.ПустаяСсылка)
	|	ИЛИ &ПерезаполнитьВидыЗапасов
	|;
	|///////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки КАК НомерСтроки,
	|	ТаблицаТоваров.Номенклатура КАК Номенклатура,
	|	ВЫБОР
	|		КОГДА &Проведен
	|			ТОГДА ТаблицаТоваров.ВидЗапасов
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ВидыЗапасов.ПустаяСсылка)
	|	КОНЕЦ КАК ТекущийВидЗапасов,
	|	ЛОЖЬ КАК ЭтоВозвратнаяТара,
	|	&Организация КАК Организация,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОприходованиеТоваров) КАК ХозяйственнаяОперация,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.Товар) КАК ТипЗапасов,
	|	ЗНАЧЕНИЕ(Справочник.СоглашенияСПоставщиками.ПустаяСсылка) КАК Соглашение,
	|	ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка) КАК Контрагент,
	|	ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка) КАК Договор,
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК Валюта,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПустаяСсылка) КАК НалогообложениеНДС,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПустаяСсылка) КАК НалогообложениеОрганизации,
	|	НЕОПРЕДЕЛЕНО КАК ВладелецТовара,
	|	ЗНАЧЕНИЕ(Справочник.ВидыЦенПоставщиков.ПустаяСсылка) КАК ВидЦены
	|ПОМЕСТИТЬ ИсходнаяТаблицаТоваров
	|ИЗ
	|	ВтИсходнаяТаблицаТоваров КАК ТаблицаТоваров
	|;
	|///////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВтИсходнаяТаблицаТоваров
	|");
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("ТаблицаТоваров", Товары.Выгрузить(, "НомерСтроки, Номенклатура, ВидЗапасов"));
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Проведен", Проведен);
	
	ЗапасыСервер.ДополнитьВременныеТаблицыОбязательнымиКолонками(Запрос);
	ЗапасыСервер.ПроверитьНеобходимостьПерезаполненияВидовЗапасовДокумента(ЭтотОбъект, Запрос);
	
	Запрос.Выполнить();
	
	ЗапасыСервер.ЗаполнитьВидыЗапасовПоУмолчанию(МенеджерВременныхТаблиц, Товары);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Процедура СформироватьСписокРегистровДляКонтроля()
	
	Массив = Новый Массив;
	// Приходы в регистр (сторно расхода из регистра) контролируем при перепроведении и отмене проведения
	Если Не ДополнительныеСвойства.ЭтоНовый Тогда
		Массив.Добавить(Движения.ТоварыОрганизаций);
	КонецЕсли;
	
	Массив.Добавить(Движения.ОбеспечениеЗаказов);
	
	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Массив);
	
КонецПроцедуры

Функция ТипАктаОРасхожденияхПриемка(АктОРасхождениях)
	
	ТипОснованияАктаОРасхождении = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(АктОРасхождениях,
		"ТипОснованияАктаОРасхождении");
	
	Если ТипОснованияАктаОРасхождении = Перечисления.ТипыОснованияАктаОРасхождении.ПриемкаТоваровНаХранение Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
