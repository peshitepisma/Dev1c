
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	УстановитьУсловноеОформление();
	
	Список.ТекстЗапроса = ТекстЗапросаСписка();
	Авансы.Параметры.УстановитьЗначениеПараметра("ТекущаяДата", Новый Граница(КонецДня(ТекущаяДатаСеанса())));
	
	КонтролироватьВыдачуПодОтчетВРазрезеЦелей = ПолучитьФункциональнуюОпцию("КонтролироватьВыдачуПодОтчетВРазрезеЦелей");
	Элементы.АвансыСтатьяЦельВыдачи.Видимость = КонтролироватьВыдачуПодОтчетВРазрезеЦелей;
	Элементы.АвансыОрганизация.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций");
	
	ВидимостьСозданияАО = ПравоДоступа("Добавление", Метаданные.Документы.АвансовыйОтчет);
	ВидимостьСозданияПоступленияТоваров = ПравоДоступа("Добавление", Метаданные.Документы.ПриобретениеТоваровУслуг);
	
	Элементы.СписокСоздатьАвансовыйОтчет.Видимость                 = ВидимостьСозданияАО;
	Элементы.СписокСоздатьПриобретениеТоваровУслуг.Видимость        = ВидимостьСозданияПоступленияТоваров;
	
	Элементы.СписокКонтекстноеМенюСоздатьАвансовыйОтчет.Видимость                 = ВидимостьСозданияАО;
	Элементы.СписокКонтекстноеМенюСоздатьПриобретениеТоваровУслуг.Видимость        = ВидимостьСозданияПоступленияТоваров;
	
	КнопокСоздания = 0;
	Если ВидимостьСозданияАО Тогда
		КнопокСоздания = КнопокСоздания + 1;
	КонецЕсли;
	Если ВидимостьСозданияПоступленияТоваров Тогда
		КнопокСоздания = КнопокСоздания + 1;
	КонецЕсли;
	
	Если КнопокСоздания = 1 Тогда
		Если ВидимостьСозданияАО Тогда
			ЭлементСоздания = Элементы.СписокСоздатьАвансовыйОтчет;
		ИначеЕсли ВидимостьСозданияПоступленияТоваров Тогда
			ЭлементСоздания = Элементы.СписокСоздатьПриобретениеТоваровУслуг;
		КонецЕсли;
		
		ЭлементСоздания.Заголовок = НСтр("ru = 'Создать'");
		Элементы.Переместить(ЭлементСоздания, Элементы.ГруппаКоманднаяПанель, Элементы.ПодменюСоздать);
	КонецЕсли;
	
	Элементы.АвансыАвансовыйОтчет.Видимость                        = ПравоДоступа("Добавление", Метаданные.Документы.АвансовыйОтчет);
	Элементы.АвансыПриходныйКассовыйОрдер.Видимость                = ПравоДоступа("Добавление", Метаданные.Документы.ПриходныйКассовыйОрдер);
	Элементы.АвансыПоступлениеБезналичныхДенежныхСредств.Видимость = ПравоДоступа("Добавление", Метаданные.Документы.ПоступлениеБезналичныхДенежныхСредств);
	Элементы.АвансыЗаявкаНаВозвратДенежныхСредств.Видимость        = ПравоДоступа("Добавление", Метаданные.Документы.ЗаявкаНаРасходованиеДенежныхСредств);
	Элементы.АвансыРасходныйКассовыйОрдер.Видимость                = ПравоДоступа("Добавление", Метаданные.Документы.РасходныйКассовыйОрдер);
	Элементы.АвансыСписаниеБезналичныхДенежныхСредств.Видимость    = ПравоДоступа("Добавление", Метаданные.Документы.СписаниеБезналичныхДенежныхСредств);
	
	Элементы.КонтрольДенежныхСредств.Видимость                     = ПравоДоступа("Просмотр", Метаданные.Отчеты.КонтрольОперацийСДенежнымиСредствами);
	
	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПриСозданииНаСервереСписокДокументов(Список);
	
	Если Не ПроверкаКонтрагентовВызовСервера.ИспользованиеПроверкиВозможно() Тогда
		Элементы.ЕстьОшибкиПроверкиКонтрагентов.Видимость = Ложь;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма, Элементы.ГруппаГлобальныеКоманды);
	// Конец ИнтеграцияС1СДокументооборотом
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список.Дата", Элементы.Дата.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МенеджерОборудованияКлиентПереопределяемый.НачатьПодключениеОборудованиеПриОткрытииФормы(ЭтаФорма, "СканерШтрихкода");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	МенеджерОборудованияКлиентПереопределяемый.НачатьОтключениеОборудованиеПриЗакрытииФормы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияКлиентПереопределяемый.ЕстьНеобработанноеСобытие() Тогда
			ОбработатьШтрихкоды(МенеджерОборудованияКлиент.ПреобразоватьДанныеСоСканераВСтруктуру(Параметр));
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
	Если ИмяСобытия = "Запись_АвансовыйОтчет" Тогда
		Элементы.Авансы.Обновить();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ПодотчетноеЛицо       = Настройки.Получить("ПодотчетноеЛицо");
	Организация           = Настройки.Получить("Организация");
	ТолькоПодготовленные  = Настройки.Получить("ТолькоПодготовленные");
	
	ПодотчетноеЛицоОтборПриИзмененииСервер();
	ОрганизацияОтборПриИзмененииСервер();
	ТолькоПодготовленныеПриИзмененииСервер();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПодотчетноеЛицоОтборПриИзменении(Элемент)
	
	ПодотчетноеЛицоОтборПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияОтборПриИзменении(Элемент)
	
	ОрганизацияОтборПриИзмененииСервер();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовСписка

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
	Если Копирование Тогда
		ОбщегоНазначенияУТКлиент.СкопироватьЭлемент(Элемент);
	Иначе
		СоздатьАвансовыйОтчет(Неопределено);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
//Конец ИнтеграцияС1СДокументооборотом

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьАвансовыйОтчет(Команда)
	
	СтруктураОтбор = Новый Структура;
	СтруктураОтбор.Вставить("ПодотчетноеЛицо", ПодотчетноеЛицо);
	СтруктураОтбор.Вставить("Организация", Организация);
	
	СтруктураПараметры = Новый Структура("Основание", СтруктураОтбор);
	
	ОткрытьФорму("Документ.АвансовыйОтчет.ФормаОбъекта", СтруктураПараметры, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПриобретениеТоваровУслуг(Команда)
	
	СтруктураОтбор = Новый Структура;
	СтруктураОтбор.Вставить("ХозяйственнаяОперация",
		ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ЗакупкаЧерезПодотчетноеЛицо"));
	СтруктураОтбор.Вставить("ПодотчетноеЛицо", ПодотчетноеЛицо);
	СтруктураОтбор.Вставить("Организация", Организация);
	СтруктураОтбор.Вставить("НалогообложениеНДС",
		ПредопределенноеЗначение("Перечисление.ТипыНалогообложенияНДС.ПродажаНеОблагаетсяНДС"));
	
	СтруктураПараметры = Новый Структура("Основание", СтруктураОтбор);
	
	ОткрытьФорму("Документ.ПриобретениеТоваровУслуг.ФормаОбъекта", СтруктураПараметры, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПоступлениеДенежныхДокументов(Команда)
	
	Возврат;
	
КонецПроцедуры

&НаКлиенте
Процедура ОформитьАвансовыйОтчетПоРаспоряжению(Команда)
	
	Если Элементы.Авансы.ВыделенныеСтроки.Количество() = 1 Тогда
		
		ТекущиеДанные = Элементы.Авансы.ТекущиеДанные;
		Если ТекущиеДанные <> Неопределено Тогда
			
			СтруктураОтбор = Новый Структура("ПодотчетноеЛицо, Организация, Подразделение, Валюта, ЦельВыдачи");
			ЗаполнитьЗначенияСвойств(СтруктураОтбор, ТекущиеДанные);
			СтруктураОтбор.Вставить("СуммаИзрасходовано", ТекущиеДанные.СуммаОстаток);
			
			СтруктураПараметры = Новый Структура("Основание", СтруктураОтбор);
			
			ОткрытьФорму("Документ.АвансовыйОтчет.ФормаОбъекта", СтруктураПараметры, ЭтаФорма);
		КонецЕсли;
	Иначе
		
		МассивАвансов = Новый Массив;
		
		Для Каждого Аванс Из Элементы.Авансы.ВыделенныеСтроки Цикл
		
			Если ТипЗнч(Аванс) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
				Продолжить;
			КонецЕсли;
			
			ДанныеСтроки = Элементы.Авансы.ДанныеСтроки(Аванс);
			
			Если Не ЗначениеЗаполнено(ДанныеСтроки.СуммаОстаток) Тогда
				Продолжить;
			КонецЕсли;
			
			ЗначенияАванса = Новый Структура("ПодотчетноеЛицо, Организация, Подразделение, ЦельВыдачи, Валюта, СуммаОстаток");
			ЗаполнитьЗначенияСвойств(ЗначенияАванса, ДанныеСтроки);
			МассивАвансов.Добавить(ЗначенияАванса);
		КонецЦикла;
		
		Если Не МассивАвансов.Количество() Тогда
			ТекстПредупреждения = НСтр("ru = 'По выделенным строкам не может быть сформирован Авансовый отчет.'");
			ПоказатьПредупреждение(Неопределено, ТекстПредупреждения);
			Возврат;
		КонецЕсли;
		
		ОчиститьСообщения();
		
		Если ФормированиеДокументаВозможно(МассивАвансов) Тогда
			СтруктураПараметры = Новый Структура("Основание", МассивАвансов);
			ОткрытьФорму("Документ.АвансовыйОтчет.ФормаОбъекта", СтруктураПараметры, ЭтаФорма);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриходныйКассовыйОрдер(Команда)
	
	ТекущиеДанные = Элементы.Авансы.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
	
		СтруктураОтбор = Новый Структура;
		СтруктураОтбор.Вставить("ХозяйственнаяОперация",
			ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВозвратДенежныхСредствОтПодотчетника"));
		СтруктураОтбор.Вставить("ПодотчетноеЛицо", ТекущиеДанные.ПодотчетноеЛицо);
		СтруктураОтбор.Вставить("Организация", ТекущиеДанные.Организация);
		СтруктураОтбор.Вставить("Валюта", ТекущиеДанные.Валюта);
		СтруктураОтбор.Вставить("СтатьяДвиженияДенежныхСредств", ТекущиеДанные.ЦельВыдачи);
		СтруктураОтбор.Вставить("Подразделение", ТекущиеДанные.Подразделение);
		СтруктураОтбор.Вставить("СуммаДокумента", ТекущиеДанные.СуммаОстаток);
		
		СтруктураПараметры = Новый Структура("Основание", СтруктураОтбор);
		
		ОткрытьФорму("Документ.ПриходныйКассовыйОрдер.ФормаОбъекта", СтруктураПараметры, ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоступлениеБезналичныхДенежныхСредств(Команда)
	
	ТекущиеДанные = Элементы.Авансы.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		
		СтруктураОтбор = Новый Структура;
		СтруктураОтбор.Вставить("ХозяйственнаяОперация",
			ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВозвратДенежныхСредствОтПодотчетника"));
		СтруктураОтбор.Вставить("ПодотчетноеЛицо", ТекущиеДанные.ПодотчетноеЛицо);
		СтруктураОтбор.Вставить("Организация", ТекущиеДанные.Организация);
		СтруктураОтбор.Вставить("Валюта", ТекущиеДанные.Валюта);
		СтруктураОтбор.Вставить("СтатьяДвиженияДенежныхСредств", ТекущиеДанные.ЦельВыдачи);
		СтруктураОтбор.Вставить("Подразделение", ТекущиеДанные.Подразделение);
		СтруктураОтбор.Вставить("СуммаДокумента", ТекущиеДанные.СуммаОстаток);
		
		СтруктураПараметры = Новый Структура("Основание", СтруктураОтбор);
		
		ОткрытьФорму("Документ.ПоступлениеБезналичныхДенежныхСредств.ФормаОбъекта", СтруктураПараметры, ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаявкаНаВыдачуПодОтчет(Команда)
	
	ТекущиеДанные = Элементы.Авансы.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		
		СтруктураОтбор = Новый Структура;
		СтруктураОтбор.Вставить("ХозяйственнаяОперация",
			ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВыдачаДенежныхСредствПодотчетнику"));
		СтруктураОтбор.Вставить("ПодотчетноеЛицо", ТекущиеДанные.ПодотчетноеЛицо);
		СтруктураОтбор.Вставить("Организация", ТекущиеДанные.Организация);
		СтруктураОтбор.Вставить("Валюта", ТекущиеДанные.Валюта);
		СтруктураОтбор.Вставить("СтатьяДвиженияДенежныхСредств", ТекущиеДанные.ЦельВыдачи);
		СтруктураОтбор.Вставить("Подразделение", ТекущиеДанные.Подразделение);
		СтруктураОтбор.Вставить("СуммаДокумента", ТекущиеДанные.Перерасход);
		СтруктураОтбор.Вставить("Сумма", ТекущиеДанные.Перерасход);
		СтруктураОтбор.Вставить("ДатаАвансовогоОтчета", ТекущаяДата());
		
		СтруктураПараметры = Новый Структура("Основание", СтруктураОтбор);
		
		ОткрытьФорму("Документ.ЗаявкаНаРасходованиеДенежныхСредств.ФормаОбъекта", СтруктураПараметры, ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РасходныйКассовыйОрдер(Команда)
	
	ТекущиеДанные = Элементы.Авансы.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		
		СтруктураОтбор = Новый Структура;
		СтруктураОтбор.Вставить("ХозяйственнаяОперация",
			ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВыдачаДенежныхСредствПодотчетнику"));
		СтруктураОтбор.Вставить("ПодотчетноеЛицо", ТекущиеДанные.ПодотчетноеЛицо);
		СтруктураОтбор.Вставить("Организация", ТекущиеДанные.Организация);
		СтруктураОтбор.Вставить("Валюта", ТекущиеДанные.Валюта);
		СтруктураОтбор.Вставить("СтатьяДвиженияДенежныхСредств", ТекущиеДанные.ЦельВыдачи);
		СтруктураОтбор.Вставить("Подразделение", ТекущиеДанные.Подразделение);
		СтруктураОтбор.Вставить("СуммаДокумента", ТекущиеДанные.Перерасход);
		СтруктураОтбор.Вставить("Сумма", ТекущиеДанные.Перерасход);
		СтруктураОтбор.Вставить("ДатаАвансовогоОтчета", ТекущаяДата());
		
		СтруктураПараметры = Новый Структура("Основание", СтруктураОтбор);
		
		ОткрытьФорму("Документ.РасходныйКассовыйОрдер.ФормаОбъекта", СтруктураПараметры, ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписаниеБезналичныхДенежныхСредств(Команда)
	
	ТекущиеДанные = Элементы.Авансы.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		
		СтруктураОтбор = Новый Структура;
		СтруктураОтбор.Вставить("ХозяйственнаяОперация",
			ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВыдачаДенежныхСредствПодотчетнику"));
		СтруктураОтбор.Вставить("ПодотчетноеЛицо", ТекущиеДанные.ПодотчетноеЛицо);
		СтруктураОтбор.Вставить("Организация", ТекущиеДанные.Организация);
		СтруктураОтбор.Вставить("Валюта", ТекущиеДанные.Валюта);
		СтруктураОтбор.Вставить("СтатьяДвиженияДенежныхСредств", ТекущиеДанные.ЦельВыдачи);
		СтруктураОтбор.Вставить("Подразделение", ТекущиеДанные.Подразделение);
		СтруктураОтбор.Вставить("СуммаДокумента", ТекущиеДанные.Перерасход);
		СтруктураОтбор.Вставить("Сумма", ТекущиеДанные.Перерасход);
		СтруктураОтбор.Вставить("ДатаАвансовогоОтчета", ТекущаяДата());
		
		СтруктураПараметры = Новый Структура("Основание", СтруктураОтбор);
		
		ОткрытьФорму("Документ.СписаниеБезналичныхДенежныхСредств.ФормаОбъекта", СтруктураПараметры, ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрольДенежныхСредств(Команда)
	
	ПараметрыФормы = Новый Структура("Отбор, КлючВарианта, КлючНазначенияИспользования, СформироватьПриОткрытии");
	ПараметрыФормы.СформироватьПриОткрытии = Истина;
	
	ПараметрыФормы.КлючВарианта = "КонтрольДенежныхСредствУПодотчетныхЛиц";
	ПараметрыФормы.КлючНазначенияИспользования = "КонтрольДенежныхСредствУПодотчетныхЛиц";
	
	Отбор = Новый Структура;
	Если ЗначениеЗаполнено(ПодотчетноеЛицо) Тогда
		Отбор.Вставить("ПодотчетноеЛицо", ПодотчетноеЛицо);
	КонецЕсли;
	Если ЗначениеЗаполнено(Организация) Тогда
		Отбор.Вставить("Организация", Организация);
	КонецЕсли;
	ПараметрыФормы.Отбор = Отбор;
	
	ОткрытьФорму("Отчет.КонтрольОперацийСДенежнымиСредствами.Форма",
		ПараметрыФормы,
		ЭтаФорма,
		);
	
	
КонецПроцедуры

&НаКлиенте
Процедура ТолькоПодготовленные(Команда)
	
	Элементы.СписокТолькоПодготовленные.Пометка = Не Элементы.СписокТолькоПодготовленные.Пометка;
	
	ТолькоПодготовленные = ?(Элементы.СписокТолькоПодготовленные.Пометка, 1, 0);
	ТолькоПодготовленныеПриИзмененииСервер();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПриИзмененииРеквизитов

&НаСервере
Процедура ПодотчетноеЛицоОтборПриИзмененииСервер()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"ПодотчетноеЛицо",
		ПодотчетноеЛицо,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ЗначениеЗаполнено(ПодотчетноеЛицо));
		
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Авансы,
		"ПодотчетноеЛицо",
		ПодотчетноеЛицо,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ЗначениеЗаполнено(ПодотчетноеЛицо));
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияОтборПриИзмененииСервер()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Организация",
		Организация,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ЗначениеЗаполнено(Организация));
		
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Авансы,
		"Организация",
		Организация,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ЗначениеЗаполнено(Организация));
	
КонецПроцедуры

&НаСервере
Процедура ТолькоПодготовленныеПриИзмененииСервер()

	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Статус",
		Перечисления.СтатусыАвансовогоОтчета.Подготовлен,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ТолькоПодготовленные = 1);
	
КонецПроцедуры

#КонецОбласти

#Область ШтрихкодыИТорговоеОборудование

&НаКлиенте
Функция СсылкаНаЭлементСпискаПоШтрихкоду(Штрихкод)
	
	Менеджеры = Новый Массив();
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.АвансовыйОтчет.ПустаяСсылка"));
	Возврат ШтрихкодированиеПечатныхФормКлиент.ПолучитьСсылкуПоШтрихкодуТабличногоДокумента(Штрихкод, Менеджеры);
	
КонецФункции

&НаКлиенте
Процедура ОбработатьШтрихкоды(Данные)
	
	МассивСсылок = СсылкаНаЭлементСпискаПоШтрихкоду(Данные.Штрихкод);
	Если МассивСсылок.Количество() > 0 Тогда
		Элементы.Список.ТекущаяСтрока = МассивСсылок[0];
		ПоказатьЗначение(Неопределено, МассивСсылок[0]);
	Иначе
		ШтрихкодированиеПечатныхФормКлиент.ОбъектНеНайден(Данные.Штрихкод);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	Список.УсловноеОформление.Элементы.Очистить();
	
	//
	
	Элемент = Список.УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Валюта.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Ссылка.Мультивалютный");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<Мультивалютный>'"));
	
	
КонецПроцедуры

&НаСервере
Функция ТекстЗапросаСписка()
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка,
	|	ДанныеДокумента.Дата,
	|	ДанныеДокумента.ПометкаУдаления,
	|	ДанныеДокумента.Номер,
	|	ДанныеДокумента.Проведен,
	|	ДанныеДокумента.Организация,
	|	ДанныеДокумента.ПодотчетноеЛицо,
	|	ДанныеДокумента.Подразделение,
	|	ДанныеДокумента.Валюта,
	|	ДанныеДокумента.Израсходовано,
	|	ДанныеДокумента.Отклонено,
	|	ДанныеДокумента.Тип,
	|	ДанныеДокумента.Статус,
	|	ДанныеДокумента.НазначениеАванса,
	|	ВЫБОР
	|		КОГДА ДокументыСОшибкамиПроверкиКонтрагентов.Документ ЕСТЬ NULL
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК ЕстьОшибкиПроверкиКонтрагентов
	|ИЗ
	|	ЖурналДокументов.АвансовыеОтчеты КАК ДанныеДокумента
	|		{ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДокументыСОшибкамиПроверкиКонтрагентов КАК ДокументыСОшибкамиПроверкиКонтрагентов
	|		ПО ДанныеДокумента.Ссылка = ДокументыСОшибкамиПроверкиКонтрагентов.Документ
	|			И (&ИспользованиеПроверкиВозможно)}
	|	
	|ГДЕ
	|	ДанныеДокумента.Тип В (
	|		ТИП(Документ.ПриобретениеТоваровУслуг),
	|		ТИП(Документ.ПриобретениеУслугПрочихАктивов)
	|	)
	|	И ДанныеДокумента.ХозяйственнаяОперация В (
	|		ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ЗакупкаЧерезПодотчетноеЛицо),
	|		ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПоступлениеДенежныхДокументовОтПодотчетника)
	|	)
	|	ИЛИ ДанныеДокумента.Тип = ТИП(Документ.АвансовыйОтчет)
	|
	|";
	
	Возврат ТекстЗапроса;
	
КонецФункции

&НаСервереБезКонтекста
Функция ФормированиеДокументаВозможно(МассивАвансов)
	
	МассивОрганизаций = Новый Массив;
	МассивПодотчетныхЛиц = Новый Массив;
	МассивПодразделений = Новый Массив;
	МассивВалют = Новый Массив;
	
	Для каждого Аванс Из МассивАвансов Цикл
		МассивОрганизаций.Добавить(Аванс.Организация);
		МассивПодотчетныхЛиц.Добавить(Аванс.ПодотчетноеЛицо);
		МассивПодразделений.Добавить(Аванс.Подразделение);
		МассивВалют.Добавить(Аванс.Валюта);
	КонецЦикла;
	
	МассивОрганизаций = ОбщегоНазначенияУТ.УдалитьПовторяющиесяЭлементыМассива(МассивОрганизаций);
	МассивПодотчетныхЛиц = ОбщегоНазначенияУТ.УдалитьПовторяющиесяЭлементыМассива(МассивПодотчетныхЛиц);
	МассивПодразделений = ОбщегоНазначенияУТ.УдалитьПовторяющиесяЭлементыМассива(МассивПодразделений);
	МассивВалют = ОбщегоНазначенияУТ.УдалитьПовторяющиесяЭлементыМассива(МассивВалют);
	
	Если МассивОрганизаций.Количество() > 1
		Или МассивПодотчетныхЛиц.Количество() > 1
		Или МассивПодразделений.Количество() > 1
		Или МассивВалют.Количество() > 1 Тогда
		
		ТекстОшибки = НСтр("ru='Ввод одного документа Авансовый отчет на основании выделенных авансов невозможен.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
		
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецОбласти
