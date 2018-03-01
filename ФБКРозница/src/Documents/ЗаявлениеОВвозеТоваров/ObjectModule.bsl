#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	Если ДанныеЗаполнения <> Неопределено И ТипДанныхЗаполнения <> Тип("Структура")
		И Метаданные().ВводитсяНаОсновании.Содержит(ДанныеЗаполнения.Метаданные()) Тогда
		                  
		ЗаполнитьПоДокументуОснованию(ДанныеЗаполнения, СтандартнаяОбработка);
		
	ИначеЕсли ДанныеЗаполнения <> Неопределено И ТипДанныхЗаполнения = Тип("Структура")
		И ДанныеЗаполнения.Свойство("ДокументОснование")
		И Метаданные().ВводитсяНаОсновании.Содержит(ДанныеЗаполнения.ДокументОснование.Метаданные()) Тогда
		
		ЗаполнитьПоДокументуОснованию(ДанныеЗаполнения.ДокументОснование, СтандартнаяОбработка);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	Документы.ЗаявлениеОВвозеТоваров.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	Документы.ЗаявлениеОВвозеТоваров.ОтразитьТоварыКОформлениюЗаявленийОВвозеТоваров(ДополнительныеСвойства, Движения, Отказ);
	ПартионныйУчетСервер.ОтразитьПартииРасходовНаСебестоимостьТоваров(ДополнительныеСвойства, Движения, Отказ);
	ДоходыИРасходыСервер.ОтразитьПартииПрочихРасходов(ДополнительныеСвойства, Движения, Отказ);
	ДоходыИРасходыСервер.ОтразитьСебестоимостьТоваров(ДополнительныеСвойства, Движения, Отказ);
	ДоходыИРасходыСервер.ОтразитьПрочиеАктивыПассивы(ДополнительныеСвойства, Движения, Отказ);
	ДоходыИРасходыСервер.ОтразитьНДСПредъявленный(ДополнительныеСвойства, Движения, Отказ);
	ДоходыИРасходыСервер.ОтразитьЖурналУчетаСчетовФактур(ДополнительныеСвойства, Движения, Отказ);
	
	УправленческийУчетПроведениеСервер.ОтразитьЗакупки(ДополнительныеСвойства, Движения, Отказ);
	
	РегистрыСведений.РеестрДокументов.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	РегистрыСведений.ПодтверждениеОплатыНДСВБюджет.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	
	СформироватьСписокРегистровДляКонтроля();
	
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУТ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	СформироватьСписокРегистровДляКонтроля();
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУТ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеСерверУТ.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	СуммаДокумента = Товары.Итог("СуммаНДС");
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ Отказ Тогда
		МассивДокументов = Новый Массив;
		МассивДокументов.Добавить(Ссылка);
		РегистрыСведений.ЗаданияКФормированиюЗаписейКнигиПокупокПродаж.СформироватьЗаданияПоДокументам(МассивДокументов);
	КонецЕсли;
	
	Если Не Отказ
		И Не ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		РегистрыСведений.РеестрДокументов.ИнициализироватьИЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ОплатаПодтверждена				= Ложь;
	ДатаПодтвержденияОплаты			= Неопределено;
	ДатаДокументаПеречисленияНалога = Неопределено;
	НомерДокументаПеречисленияНалога = "";
	ДатаОтправки					= Неопределено;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ЗаполнитьПоДокументуОснованию(Основание, СтандартнаяОбработка)
	
	Если ТипЗнч(Основание) = Тип("ДокументСсылка.ПриобретениеТоваровУслуг") Тогда
		Если НЕ (Основание.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ЗакупкаВСтранахЕАЭС
					Или Основание.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ЗакупкаВСтранахЕАЭСФактуровкаПоставки
					Или Основание.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ЗакупкаВСтранахЕАЭСТоварыВПути
					Или Основание.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ЗакупкаУПоставщикаРеглУчет) Тогда
			Ошибка = НСтр("ru='Ввод заявления на ввоз товаров из ЕАЭС на основании поступления с операцией %Операция% не требуется.'");
			ВызватьИсключение СтрЗаменить(Ошибка, "%Операция%", Основание.ХозяйственнаяОперация);
		КонецЕсли;
		
		ЗаполнитьДокументНаОснованииПриобретенияТоваровУслуг(Основание);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьДокументНаОснованииПриобретенияТоваровУслуг(Знач ПриобретениеТоваровУслуг)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ПриобретениеТоваровУслуг.Проведен КАК Проведен,
	|	ПриобретениеТоваровУслуг.Организация КАК Организация,
	|	ПриобретениеТоваровУслуг.Контрагент КАК Контрагент,
	|	ПриобретениеТоваровУслуг.Договор КАК Договор,
	|	ПриобретениеТоваровУслуг.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	ПриобретениеТоваровУслуг.НомерВходящегоДокумента КАК НомерВходящегоДокумента,
	|	ПриобретениеТоваровУслуг.ДатаВходящегоДокумента КАК ДатаВходящегоДокумента
	|ИЗ
	|	Документ.ПриобретениеТоваровУслуг КАК ПриобретениеТоваровУслуг
	|ГДЕ
	|	ПриобретениеТоваровУслуг.Ссылка = &ПриобретениеТоваровУслуг");
	Запрос.УстановитьПараметр("ПриобретениеТоваровУслуг", ПриобретениеТоваровУслуг);
	Реквизиты = Запрос.Выполнить().Выбрать();
	Реквизиты.Следующий();
	
	ОбщегоНазначенияУТ.ПроверитьВозможностьВводаНаОсновании(
		ПриобретениеТоваровУслуг,
		,
		НЕ Реквизиты.Проведен);
		
	//Заполнение шапки
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Реквизиты, "Организация, Контрагент, Договор");
	ЭтотОбъект.Валюта = Константы.ВалютаРегламентированногоУчета.Получить();
	
	ЭтотОбъект.Ответственный = Пользователи.ТекущийПользователь();
	ЭтотОбъект.Подразделение = ЗначениеНастроекПовтИсп.ПодразделениеПользователя(ЭтотОбъект.Ответственный, ЭтотОбъект.Подразделение);
	
	//Заполнение табличной части.
	ТаблицаТовары = Документы.ЗаявлениеОВвозеТоваров.ТаблицаОстатковТоваровКОформлениюЗаявленийОВвозеТоваров(ПриобретениеТоваровУслуг, Истина);
	
	Для каждого СтрокаТаблицыТовары Из ТаблицаТовары Цикл
		Если СтрокаТаблицыТовары.НалоговаяБазаНДС <> 0 Тогда
			СтрокаТаблицыТовары.СуммаНДС = УчетНДСКлиентСервер.РассчитатьСуммуНДС(
				СтрокаТаблицыТовары.НалоговаяБазаНДС,
				Ложь,
				УчетНДСВызовСервераПовтИсп.ПолучитьСтавкуНДС(СтрокаТаблицыТовары.СтавкаНДС));
		КонецЕсли;
	КонецЦикла; 
	
	Товары.Загрузить(ТаблицаТовары);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Процедура СформироватьСписокРегистровДляКонтроля()

	Массив = Новый Массив;
	
	// Контроль выполняется при проведении\отмене проведения не нового документа.
	Если Не ДополнительныеСвойства.ЭтоНовый Тогда
		Массив.Добавить(Движения.ТоварыКОформлениюЗаявленийОВвозе);
	КонецЕсли;
	
	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Массив);

КонецПроцедуры

// Устанавливает документу статус проведения банком
//
// Параметры:
//    НовыйСтатус - Строка - Не используется
//    ВыюраннаяДата - Дата - Дата проведения платежа банком
//
// Возвращаемое значение:
//    Булево - Истина, в случае успешной установки нового статуса
//
Функция УстановитьСтатус(НовыйСтатус, ДополнительныеПараметры) Экспорт
	
	ДатаПодтвержденияОплаты = ДополнительныеПараметры.ДатаПодтвержденияОплаты;
	ОплатаПодтверждена = Истина;
	
	Возврат ПроверитьЗаполнение();
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
