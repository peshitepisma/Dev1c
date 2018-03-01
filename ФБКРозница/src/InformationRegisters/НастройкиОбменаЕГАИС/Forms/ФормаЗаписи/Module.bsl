
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Не Записано Тогда
		ЗагружатьВходящиеДокументы = Запись.ЗагружатьВходящиеДокументы;
		ПриСозданииЧтенииНаСервере();
	КонецЕсли;
	
	Элементы.Подсказка.Видимость = НЕ ОбщегоНазначения.РазделениеВключено();
	
	СобытияФормЕГАИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Не Записано
		И Не ЗначениеЗаполнено(Запись.РабочееМесто) Тогда
		МенеджерОборудованияКлиент.ОбновитьРабочееМестоКлиента();
		Запись.РабочееМесто = МенеджерОборудованияВызовСервера.ПолучитьРабочееМестоКлиента();
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Запись.АдресУТМ)
		И ЗначениеЗаполнено(Запись.ПортУТМ)
		И ЗначениеЗаполнено(Запись.ИдентификаторФСРАР) Тогда
		
		ПодключениеНастроеноКорректно = Ложь;
		УказанПравильныйКодФСРАР = Ложь;
		ОбновитьТекстСопоставления(ЭтотОбъект);
		Элементы.СтраницыПроверкаПодключения.ТекущаяСтраница = Элементы.СтраницыПроверкаПодключения.ПодчиненныеЭлементы.ВыполняетсяПроверкаПодключенияКУТМ;
		ПодключитьОбработчикОжидания("ПроверитьПодключениеКУТМ", 3, Истина);
		
	Иначе
		
		Элементы.СтраницыПроверкаПодключения.ТекущаяСтраница = Элементы.СтраницыПроверкаПодключения.ПодчиненныеЭлементы.ПроверкаНеПодключенияНеВыполнялась;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_КлассификаторОрганизацийЕГАИС" Тогда
		
		ЗаполнитьДанные();
		
	КонецЕсли;
	
	СобытияФормЕГАИСКлиентПереопределяемый.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	Записано = Истина;
	
	Запись.РабочееМесто   = ТекущийОбъект.РабочееМесто;
	РабочееМестоКеш       = ТекущийОбъект.РабочееМесто;
	ИдентификаторФСРАРКеш = ТекущийОбъект.ИдентификаторФСРАР;
	
	ОбменНаСервере             = ТекущийОбъект.ОбменНаСервере;
	ЗагружатьВходящиеДокументы = ТекущийОбъект.ЗагружатьВходящиеДокументы;
	
	Если Не ОбменНаСервере Тогда
		ОбменПоРасписанию = ТекущийОбъект.ОбменНаКлиентеПоРасписанию;
		РасписаниеОбмена  = ТекущийОбъект.ОбменНаКлиентеРасписание.Получить();
	Иначе
		ОбменПоРасписанию = Ложь;
		РасписаниеОбмена  = Неопределено;
	КонецЕсли;
	
	ПриСозданииЧтенииНаСервере();
	
	СобытияФормЕГАИСПереопределяемый.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	СобытияФормЕГАИСКлиентПереопределяемый.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.ОбменНаСервере             = ОбменНаСервере;
	ТекущийОбъект.ЗагружатьВходящиеДокументы = ЗагружатьВходящиеДокументы;
	
	Если Не ОбменНаСервере Тогда
		ТекущийОбъект.ОбменНаКлиентеПоРасписанию = ОбменПоРасписанию;
		ТекущийОбъект.ОбменНаКлиентеРасписание   = Новый ХранилищеЗначения(РасписаниеОбмена);
	Иначе
		ТекущийОбъект.ОбменНаКлиентеПоРасписанию = Ложь;
		ТекущийОбъект.ОбменНаКлиентеРасписание   = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	РабочееМестоКеш       = Запись.РабочееМесто;
	ИдентификаторФСРАРКеш = Запись.ИдентификаторФСРАР;
	Записано              = Истина;
	
	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("ИдентификаторФСРАР", Запись.ИдентификаторФСРАР);
	
	Оповестить("Запись_ПараметрыПодключенияЕГАИС", ПараметрыОповещения, ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	ТребуетсяПроверкаНаДубли = (РабочееМестоКеш <> Запись.РабочееМесто)
	                           Или (ИдентификаторФСРАРКеш <> Запись.ИдентификаторФСРАР)
	                           Или Не Записано;
	
	Если ТребуетсяПроверкаНаДубли Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	1 КАК Поле1
		|ИЗ
		|	РегистрСведений.НастройкиОбменаЕГАИС КАК НастройкиОбменаЕГАИС
		|ГДЕ
		|	НастройкиОбменаЕГАИС.ИдентификаторФСРАР = &ИдентификаторФСРАР
		|	И НастройкиОбменаЕГАИС.РабочееМесто = &РабочееМесто");
		
		Запрос.УстановитьПараметр("ИдентификаторФСРАР", Запись.ИдентификаторФСРАР);
		Запрос.УстановитьПараметр("РабочееМесто",       Запись.РабочееМесто);
		
		Если НЕ Запрос.Выполнить().Пустой() Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтрШаблон(
					НСтр("ru = 'Настройка обмена для организации с кодом ФСРАР %1 уже существует'"),
					Запись.ИдентификаторФСРАР),,
				"Запись.ИдентификаторФСРАР",,
				Отказ);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ИдентификаторФСРАРПриИзменении(Элемент)
	
	ЗаполнитьДанные();
	
	ПодключениеНастроеноКорректно = Ложь;
	УказанПравильныйКодФСРАР = Ложь;
	ОбновитьТекстСопоставления(ЭтотОбъект);
	Элементы.СтраницыПроверкаПодключения.ТекущаяСтраница = Элементы.СтраницыПроверкаПодключения.ПодчиненныеЭлементы.ВыполняетсяПроверкаПодключенияКУТМ;
	ПодключитьОбработчикОжидания("ПроверитьПодключениеКУТМ", 1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбменНаСервереПриИзменении(Элемент)
	
	ПриИзмененииВариантаПодключения(ЭтотОбъект);
	
	Если ОбменНаСервере = 1 Тогда
		
		Если ОбменНаКлиентеРасписаниеКеш <> РасписаниеОбмена
			И РасписаниеОбмена <> Неопределено Тогда
			
			ОбменНаКлиентеПоРасписаниюКеш = ОбменПоРасписанию;
			ОбменНаКлиентеРасписаниеКеш   = РасписаниеОбмена;
			
		КонецЕсли;
		
		ПрочитатьРасписаниеОбменаНаСервере();
		
	Иначе
		
		Если ОбменНаКлиентеРасписаниеКеш <> Неопределено Тогда
			
			ОбменПоРасписанию = ОбменНаКлиентеПоРасписаниюКеш;
			РасписаниеОбмена  = ОбменНаКлиентеРасписаниеКеш;
			
			ОбменНаКлиентеПоРасписаниюКеш = Неопределено;
			ОбменНаКлиентеРасписаниеКеш =   Неопределено;
			
		КонецЕсли;
		
		ИзменитьРасписаниеОбменаНаКлиенте(ЭтотОбъект, РасписаниеОбмена);
		
	КонецЕсли;
	
	ПодключениеНастроеноКорректно = Ложь;
	УказанПравильныйКодФСРАР = Ложь;
	ОбновитьТекстСопоставления(ЭтотОбъект);
	Элементы.СтраницыПроверкаПодключения.ТекущаяСтраница = Элементы.СтраницыПроверкаПодключения.ПодчиненныеЭлементы.ВыполняетсяПроверкаПодключенияКУТМ;
	ПодключитьОбработчикОжидания("ПроверитьПодключениеКУТМ", 1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура АдресУТМПриИзменении(Элемент)
	
	ПодключениеНастроеноКорректно = Ложь;
	УказанПравильныйКодФСРАР = Ложь;
	ОбновитьТекстСопоставления(ЭтотОбъект);
	Элементы.СтраницыПроверкаПодключения.ТекущаяСтраница = Элементы.СтраницыПроверкаПодключения.ПодчиненныеЭлементы.ВыполняетсяПроверкаПодключенияКУТМ;
	ПодключитьОбработчикОжидания("ПроверитьПодключениеКУТМ", 1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПортУТМПриИзменении(Элемент)
	
	ПодключениеНастроеноКорректно = Ложь;
	УказанПравильныйКодФСРАР = Ложь;
	ОбновитьТекстСопоставления(ЭтотОбъект);
	Элементы.СтраницыПроверкаПодключения.ТекущаяСтраница = Элементы.СтраницыПроверкаПодключения.ПодчиненныеЭлементы.ВыполняетсяПроверкаПодключенияКУТМ;
	ПодключитьОбработчикОжидания("ПроверитьПодключениеКУТМ", 1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ТаймаутПриИзменении(Элемент)
	
	ПодключениеНастроеноКорректно = Ложь;
	УказанПравильныйКодФСРАР = Ложь;
	ОбновитьТекстСопоставления(ЭтотОбъект);
	Элементы.СтраницыПроверкаПодключения.ТекущаяСтраница = Элементы.СтраницыПроверкаПодключения.ПодчиненныеЭлементы.ВыполняетсяПроверкаПодключенияКУТМ;
	ПодключитьОбработчикОжидания("ПроверитьПодключениеКУТМ", 1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбменПоРасписаниюПриИзменении(Элемент)
	
	Если ОбменНаСервере = 1 Тогда
		
		ИзменитьРасписаниеОбменаНаСервере();
		
	Иначе
		
		ИзменитьРасписаниеОбменаНаКлиенте(ЭтотОбъект, РасписаниеОбмена);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормЕГАИСКлиентПереопределяемый.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьКодФСРАР(Команда)
	
	ОчиститьСообщения();
	
	Если ПустаяСтрока(Запись.АдресУТМ) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Не указан IP-адрес (или доменное имя) компьютера с установленной службой УТМ.'"),,
			"АдресУТМ",
			"Запись");
		Возврат;
	КонецЕсли;
	
	Если Запись.ПортУТМ = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Не указан порт доступа к УТМ.'"),,
			"ПортУТМ",
			"Запись");
		Возврат;
	КонецЕсли;
	
	ПолучитьКодФСРАРИзУТМ(
		Новый ОписаниеОповещения("ПолучениеКодаФСРАР_Завершение", ЭтотОбъект),
		Запись.Таймаут);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьРасписание(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ИзменитьРасписаниеОбмена", ЭтотОбъект);
	
	ОткрытьНастройкуРасписанияОбмена(ОписаниеОповещения, РасписаниеОбмена);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьДанные()
	
	Если ЗначениеЗаполнено(СокрЛП(Запись.ИдентификаторФСРАР)) Тогда
		ДанныеСопоставления = ИнтеграцияЕГАИСПереопределяемый.ДанныеСопоставленияОрганизацииЕГАИС(СокрЛП(Запись.ИдентификаторФСРАР));
	Иначе
		ДанныеСопоставления = Неопределено;
	КонецЕсли;
	
	ТребуетсяЗапроситьДанныеОрганизацииЕГАИС = Истина;
	ОрганизацияЕГАИС = Справочники.КлассификаторОрганизацийЕГАИС.ПустаяСсылка();
	
	Если ДанныеСопоставления <> Неопределено И ЗначениеЗаполнено(ДанныеСопоставления.ОрганизацияЕГАИС) Тогда
		
		ОрганизацияКонтрагент = ДанныеСопоставления.Организация;
		ТорговыйОбъект        = ДанныеСопоставления.ТорговыйОбъект;
		ОрганизацияЕГАИС      = ДанныеСопоставления.ОрганизацияЕГАИС;
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ЕГАИСПрисоединенныеФайлы.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ЕГАИСПрисоединенныеФайлы КАК ЕГАИСПрисоединенныеФайлы
		|ГДЕ
		|	ЕГАИСПрисоединенныеФайлы.Операция = ЗНАЧЕНИЕ(Перечисление.ВидыДокументовЕГАИС.ЗапросДанныхОрганизации)
		|	И ЕГАИСПрисоединенныеФайлы.ТипСообщения = ЗНАЧЕНИЕ(Перечисление.ТипыЗапросовЕГАИС.Исходящий)
		|	И ЕГАИСПрисоединенныеФайлы.ВладелецФайла = &ВладелецФайла
		|
		|УПОРЯДОЧИТЬ ПО
		|	ЕГАИСПрисоединенныеФайлы.ДатаМодификацииУниверсальная УБЫВ");
		
		Запрос.УстановитьПараметр("ВладелецФайла", ОрганизацияЕГАИС);
		
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			ТекстСообщенияXML = ИнтеграцияЕГАИС.ТекстСообщенияXMLИзПротокола(Выборка.Ссылка);
			Если СтрНайти(ТекстСообщенияXML, СокрЛП(Запись.ИдентификаторФСРАР)) > 0 Тогда
				ТребуетсяЗапроситьДанныеОрганизацииЕГАИС = Ложь;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	ОбновитьТекстСопоставления(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьТекстСопоставления(Форма)
	
	МассивСтрок = Новый Массив;
	Если ЗначениеЗаполнено(Форма.ОрганизацияЕГАИС) Тогда
		
		МассивСтрок.Добавить(
			Новый ФорматированнаяСтрока(
				НСтр("ru = 'Организация ЕГАИС:'")));
		
		МассивСтрок.Добавить(" ");
		
		Если ЗначениеЗаполнено(Форма.ОрганизацияЕГАИС) Тогда
			ПредставлениеОрганизацииЕГАИС = Строка(Форма.ОрганизацияЕГАИС);
			Если ПредставлениеОрганизацииЕГАИС = "<>" Тогда
				ПредставлениеОрганизацииЕГАИС = НСтр("ru = '<Новая организация>'");
			КонецЕсли;
		Иначе
			ПредставлениеОрганизацииЕГАИС = НСтр("ru = '<не загружена из ЕГАИС>'");
		КонецЕсли;
		
		МассивСтрок.Добавить(
			Новый ФорматированнаяСтрока(
				ПредставлениеОрганизацииЕГАИС,
				Новый Шрифт(,,,,Истина),
				?(ЗначениеЗаполнено(Форма.ОрганизацияЕГАИС),
					Форма.ЦветаСтиляКлиент.ЦветГиперссылкиГИСМ,
					Форма.ЦветаСтиляКлиент.ЦветТекстаПроблемаЕГАИС),,
				"КомандаОткрытьОрганизациюЕГАИС"));
		
		МассивСтрок.Добавить(Символы.ПС);
		
		МассивСтрок.Добавить(
			Новый ФорматированнаяСтрока(
				НСтр("ru = 'Организация:'")));
		
		МассивСтрок.Добавить(" ");
		
		Если Не ЗначениеЗаполнено(Форма.ОрганизацияКонтрагент) Тогда
			
			МассивСтрок.Добавить(
				Новый ФорматированнаяСтрока(
					НСтр("ru = '<не сопоставлено>'"),
					Новый Шрифт(,,,,Истина),
					Форма.ЦветаСтиляКлиент.ЦветТекстаПроблемаЕГАИС,,
					"КомандаОткрытьОрганизациюЕГАИС"));
			
		Иначе
			
			МассивСтрок.Добавить(
				Новый ФорматированнаяСтрока(
					Строка(Форма.ОрганизацияКонтрагент),
					Новый Шрифт(,,,,Истина),
					Форма.ЦветаСтиляКлиент.ЦветГиперссылкиГИСМ,,
					"КомандаОткрытьОрганизацию"));
			
		КонецЕсли;
		
		МассивСтрок.Добавить(Символы.ПС);
		
		МассивСтрок.Добавить(
			Новый ФорматированнаяСтрока(
				НСтр("ru = 'Торговый объект:'")));
		
		МассивСтрок.Добавить(" ");
		
		Если Не ЗначениеЗаполнено(Форма.ТорговыйОбъект) Тогда
			
			МассивСтрок.Добавить(
				Новый ФорматированнаяСтрока(
					НСтр("ru = '<не сопоставлено>'"),
					Новый Шрифт(,,,,Истина),
					Форма.ЦветаСтиляКлиент.ЦветТекстаПроблемаЕГАИС,,
					"КомандаОткрытьОрганизациюЕГАИС"));
			
		Иначе
			
			МассивСтрок.Добавить(
				Новый ФорматированнаяСтрока(
					Строка(Форма.ТорговыйОбъект),
					Новый Шрифт(,,,,Истина),
					Форма.ЦветаСтиляКлиент.ЦветГиперссылкиГИСМ,,
					"КомандаОткрытьТорговыйОбъект"));
			
		КонецЕсли;
		
	ИначеЕсли ЗначениеЗаполнено(СокрЛП(Форма.Запись.ИдентификаторФСРАР))
		И Не Форма.ПодключениеНастроеноКорректно Тогда
		
		МассивСтрок.Добавить(
			Новый ФорматированнаяСтрока(
				НСтр("ru = 'Организация ЕГАИС не найдена по коду ФСРАР
				            |в классификаторе организаций.'"),,
				Форма.ЦветаСтиляКлиент.ЦветТекстаПроблемаЕГАИС));
		
	ИначеЕсли ЗначениеЗаполнено(СокрЛП(Форма.Запись.ИдентификаторФСРАР))
		И Форма.ПодключениеНастроеноКорректно Тогда
		
		Если Форма.УказанПравильныйКодФСРАР Тогда
			
			МассивСтрок.Добавить(
				Новый ФорматированнаяСтрока(
					НСтр("ru = 'Организация ЕГАИС не найдена по коду ФСРАР
					            |в классификаторе организаций.'"),,
					Форма.ЦветаСтиляКлиент.ЦветТекстаПроблемаЕГАИС));
			
			МассивСтрок.Добавить(" ");
			
			МассивСтрок.Добавить(
				Новый ФорматированнаяСтрока(
					НСтр("ru = 'Запросить из ЕГАИС'"),
					Новый Шрифт(,,,,Истина),
					Форма.ЦветаСтиляКлиент.ЦветГиперссылкиГИСМ,,
					"КомандаЗапроситьОрганизациюЕГАИС"));
			
		Иначе
			
			МассивСтрок.Добавить(
				Новый ФорматированнаяСтрока(
					НСтр("ru = 'Неверный код ФСРАР.'"),,
					Форма.ЦветаСтиляКлиент.ЦветТекстаПроблемаЕГАИС));
			
			МассивСтрок.Добавить(" ");
			
			МассивСтрок.Добавить(
				Новый ФорматированнаяСтрока(
					СтрШаблон(
						НСтр("ru = 'Использовать код %1'"),
						Форма.КодФСРАРИзУТМ),
					Новый Шрифт(,,,,Истина),
					Форма.ЦветаСтиляКлиент.ЦветГиперссылкиГИСМ,,
					"КомандаЗапроситьКодФСРАР"));
			
		КонецЕсли;
		
	Иначе
		
		МассивСтрок.Добавить(
			Новый ФорматированнаяСтрока(
				НСтр("ru = 'Не заполнен код ФСРАР'"),,
				Форма.ЦветаСтиляКлиент.ЦветТекстаПроблемаЕГАИС));
			
		Если Форма.ПодключениеНастроеноКорректно Тогда
			
			МассивСтрок.Добавить(" ");
			
			МассивСтрок.Добавить(
				Новый ФорматированнаяСтрока(
					НСтр("ru = 'Запросить код ФСРАР из УТМ'"),
					Новый Шрифт(,,,,Истина),
					Форма.ЦветаСтиляКлиент.ЦветГиперссылкиГИСМ,,
					"КомандаЗапроситьКодФСРАР"));
		КонецЕсли;
		
	КонецЕсли;
	
	Форма.ТекстСопоставление = Новый ФорматированнаяСтрока(МассивСтрок);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПриИзмененииВариантаПодключения(Форма)
	
	Если Форма.ОбменНаСервере = 0 Тогда
		Форма.Подсказка = Новый ФорматированнаяСтрока(
			НСтр("ru = 'Подключение к УТМ будет осуществляться с компьютера пользователя'"));
	ИначеЕсли Форма.ОбменНаСервере = 1 Тогда
		Форма.Подсказка = Новый ФорматированнаяСтрока(
			НСтр("ru = 'Подключение к УТМ будет осуществляться с компьютера, на котором установлен сервер 1С:Предприятия'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РабочееМестоОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если НЕ ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		СтандартнаяОбработка = Ложь;
		МенеджерОборудованияКлиент.ОбновитьРабочееМестоКлиента();
		Запись.РабочееМесто = МенеджерОборудованияВызовСервера.ПолучитьРабочееМестоКлиента();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТекстСопоставлениеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "КомандаОткрытьОрганизацию" Тогда
		
		ПоказатьЗначение(, ОрганизацияКонтрагент);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "КомандаОткрытьТорговыйОбъект" Тогда
		
		ПоказатьЗначение(, ТорговыйОбъект);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "КомандаОткрытьОрганизациюЕГАИС" Тогда
		
		ПоказатьЗначение(, ОрганизацияЕГАИС);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "КомандаЗапроситьОрганизациюЕГАИС" Тогда
		
		Если Модифицированность Тогда
			
			Кнопки = Новый СписокЗначений;
			Кнопки.Добавить(КодВозвратаДиалога.Да,     НСтр("ru='Записать и продолжить'"));
			Кнопки.Добавить(КодВозвратаДиалога.Отмена, НСтр("ru='Отмена'"));
			
			ПоказатьВопрос(
				Новый ОписаниеОповещения("ОбработатьОтветНаВопросОЗаписиНастроекПередЗапросомОрганизацииЕГАИС", ЭтотОбъект),
				НСтр("ru='Перед запросом данных организации ЕГАИС
				         |по коду ФСРАР текущая настройка обмена должна быть записана.'"),
				Кнопки,,
				КодВозвратаДиалога.Да);
			
		Иначе
			
			Если Не ЗначениеЗаполнено(ОрганизацияЕГАИС)
				И Не ЗаписатьНастройкуОбмена(Ложь) Тогда
				Возврат;
			КонецЕсли;
			
			НачатьФормированиеЗапросаНаЗагрузкуОрганизации();
			
		КонецЕсли;
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "КомандаЗапроситьКодФСРАР" Тогда
		
		ПолучитьКодФСРАР(Неопределено);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьОтветНаВопросОЗаписиНастроекПередЗапросомОрганизацииЕГАИС(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗаписатьНастройкуОбмена() Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("ИдентификаторФСРАР", Запись.ИдентификаторФСРАР);
	
	Оповестить("Запись_ПараметрыПодключенияЕГАИС", ПараметрыОповещения, ЭтотОбъект);
	
	Прочитать();
	
	НачатьФормированиеЗапросаНаЗагрузкуОрганизации();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьОтветНаВопросОЗапросеДанныхОрганизацииЕГАИСПередЗаписью(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
		ПринудительноЗакрытьФорму = Истина;
		Закрыть();
		Возврат;
	КонецЕсли;
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗаписатьНастройкуОбмена() Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("ИдентификаторФСРАР", Запись.ИдентификаторФСРАР);
	
	Оповестить("Запись_ПараметрыПодключенияЕГАИС", ПараметрыОповещения, ЭтотОбъект);
	
	Прочитать();
	
	НачатьФормированиеЗапросаНаЗагрузкуОрганизации(
		Новый ОписаниеОповещения("ПослеЗакрытияФормыЗапросаДанныхОрганизацииПередЗаписью", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияФормыЗапросаДанныхОрганизацииПередЗаписью(Результат, ДополнительныеПараметры) Экспорт
	
	ЗаполнитьДанные();
	
	Если ПодключениеНастроеноКорректно
		И УказанПравильныйКодФСРАР
		И Не ТребуетсяЗапроситьДанныеОрганизацииЕГАИС Тогда
		
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьФормированиеЗапросаНаЗагрузкуОрганизации(ОповещениеПриЗакрытии = Неопределено)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Операция",          ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЗапросДанныхОрганизации"));
	ПараметрыФормы.Вставить("ИмяПараметра",      "СИО");
	ПараметрыФормы.Вставить("ЗначениеПараметра", Запись.ИдентификаторФСРАР);
	
	ПараметрыФормы.Вставить("ОрганизацияЕГАИС",              ОрганизацияЕГАИС);
	Если ЗначениеЗаполнено(ОрганизацияЕГАИС)
		И Строка(ОрганизацияЕГАИС) <> "<>" Тогда
		ПараметрыФормы.Вставить("ОрганизацияЕГАИСПредставление", ОрганизацияЕГАИС);
	Иначе
		ПараметрыФормы.Вставить("ОрганизацияЕГАИСПредставление", НСтр("ru = '<Новая организация>'"));
	КонецЕсли;
	
	ОткрытьФорму(
		"ОбщаяФорма.ФормированиеИсходящегоЗапросаЕГАИС",
		ПараметрыФормы,
		ЭтотОбъект,,,,
		ОповещениеПриЗакрытии,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучениеКодаФСРАР_Завершение(Изменения, ДополнительныеПараметры) Экспорт
	
	Если Изменения.Количество() = 1 Тогда
		
		ТекстСообщения = Изменения[0].ТекстОшибки;
		
		Позиция = СтрНайти(ТекстСообщения, "RSA");
		
		Если Позиция <> 0 Тогда
			
			Запись.ИдентификаторФСРАР = КодФСРАРИзОписанияОшибки(ТекстСообщения);
			Модифицированность = Истина;
			ЗаполнитьДанные();
	
			ПодключениеНастроеноКорректно = Ложь;
			УказанПравильныйКодФСРАР = Ложь;
			ОбновитьТекстСопоставления(ЭтотОбъект);
			Элементы.СтраницыПроверкаПодключения.ТекущаяСтраница = Элементы.СтраницыПроверкаПодключения.ПодчиненныеЭлементы.ВыполняетсяПроверкаПодключенияКУТМ;
			ПодключитьОбработчикОжидания("ПроверитьПодключениеКУТМ", 1, Истина);
			
		Иначе
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтрШаблон(
					НСтр("ru = 'Внутренняя ошибка получения кода ФСРАР. Обратитесь к администратору.
					           |%1.'"),
					ТекстСообщения));
			
		КонецЕсли;
		
	Иначе
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Внутренняя ошибка получения кода ФСРАР. Обратитесь к администратору.'"));
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	ЦветаСтиляКлиент = Новый Структура;
	ЦветаСтиляКлиент.Вставить("ЦветГиперссылкиГИСМ",     ЦветаСтиля.ЦветГиперссылкиГИСМ);
	ЦветаСтиляКлиент.Вставить("ЦветТекстаПроблемаЕГАИС", ЦветаСтиля.ЦветТекстаПроблемаЕГАИС);
	
	ЗаполнитьДанные();
	
	ПриИзмененииВариантаПодключения(ЭтотОбъект);
	
	Если ОбменНаСервере Тогда
		
		ПрочитатьРасписаниеОбменаНаСервере();
		
	Иначе
		
		ИзменитьРасписаниеОбменаНаКлиенте(ЭтотОбъект, РасписаниеОбмена);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьРасписаниеОбменаНаСервере()
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Метаданные", "ОбработкаОтветовЕГАИС");
	
	ЗаданиеОбмена = РегламентныеЗаданияСервер.НайтиЗадания(ПараметрыОтбора)[0];
	РасписаниеОбмена = ЗаданиеОбмена.Расписание;
	ОбменПоРасписанию = ЗаданиеОбмена.Использование;
	
	Элементы.ОбработкаОтветовЕГАИС.Доступность = ЗаданиеОбмена.Использование;
	УстановитьТекстНадписиРегламентнойНастройки(ЗаданиеОбмена, Элементы.ОбработкаОтветовЕГАИС);
	
КонецПроцедуры

&НаСервере
Функция ЗаписатьНастройкуОбмена(ЗаписыватьНастройкуОбмена = Истина)
	
	НачатьТранзакцию();
	Попытка
		
		СоздатьЭлементКлассификатораОрганизацийЕГАИС();
		
		Если ЗаписыватьНастройкуОбмена Тогда
			Результат = Записать();
			Если Не Результат Тогда
				ОтменитьТранзакцию();
			КонецЕсли;
		Иначе
			Результат = Истина;
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		
		ЗаписьЖурналаРегистрации(НСтр("ru = 'ЕГАИС'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
	КонецПопытки;
	
	ЗаполнитьДанные();
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура СоздатьЭлементКлассификатораОрганизацийЕГАИС()
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	КлассификаторОрганизацийЕГАИС.Ссылка КАК ОрганизацияЕГАИС
	|ИЗ
	|	Справочник.КлассификаторОрганизацийЕГАИС КАК КлассификаторОрганизацийЕГАИС
	|ГДЕ
	|	КлассификаторОрганизацийЕГАИС.Код = &КодВФСРАР");
	Запрос.УстановитьПараметр("КодВФСРАР", Запись.ИдентификаторФСРАР);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	ОрганизацияОбъект = Справочники.КлассификаторОрганизацийЕГАИС.СоздатьЭлемент();
	ОрганизацияОбъект.Код = Запись.ИдентификаторФСРАР;
	ОрганизацияОбъект.ФорматОбмена = ИнтеграцияЕГАИСКлиентСервер.ФорматОбмена();
	ОрганизацияОбъект.СоответствуетОрганизации = Истина;
	ОрганизацияОбъект.Записать();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНастройкуРасписанияОбмена(ОписаниеОповещения, РасписаниеРегламентногоЗадания)
	
	Если РасписаниеРегламентногоЗадания = Неопределено Тогда
		РасписаниеРегламентногоЗадания = Новый РасписаниеРегламентногоЗадания;
	КонецЕсли;
	
	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(РасписаниеРегламентногоЗадания);
	Диалог.Показать(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьРасписаниеОбмена(РасписаниеЗадания, ДополнительныеПараметры) Экспорт
	
	Если РасписаниеЗадания = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РасписаниеОбмена = РасписаниеЗадания;
	
	Если ОбменНаСервере = 1 Тогда
		
		ИзменитьРасписаниеОбменаНаСервере();
		
	Иначе
		
		ИзменитьРасписаниеОбменаНаКлиенте(ЭтотОбъект, РасписаниеОбмена);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьРасписаниеОбменаНаКлиенте(Форма, НовоеРасписание)
	
	Если НовоеРасписание = Неопределено Тогда
		
		ТекстРасписания = НСтр("ru = '<Расписание не задано>'");
		
	Иначе
		
		Если Форма.ОбменПоРасписанию Тогда
			ТекстРасписания = СтрШаблон(НСтр("ru = 'Расписание: %1'"), Строка(НовоеРасписание));
		Иначе
			ТекстРасписания = СтрШаблон(НСтр("ru = 'Расписание (НЕ АКТИВНО): %1'"), Строка(НовоеРасписание));
		КонецЕсли;
		
	КонецЕсли;
	
	Форма.Элементы.ОбработкаОтветовЕГАИС.Доступность = Форма.ОбменПоРасписанию;
	Форма.Элементы.ОбработкаОтветовЕГАИС.Заголовок = ТекстРасписания;
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьРасписаниеОбменаНаСервере()
	
	ИзменитьИспользованиеЗадания("ОбработкаОтветовЕГАИС", ОбменПоРасписанию);
	ИзменитьРасписаниеЗадания("ОбработкаОтветовЕГАИС", РасписаниеОбмена);
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьИспользованиеЗадания(ИмяЗадания, Использование)
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Метаданные", ИмяЗадания);
	РегЗадание = РегламентныеЗаданияСервер.НайтиЗадания(ПараметрыОтбора)[0];

	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("Использование", Использование);
	РегламентныеЗаданияСервер.ИзменитьЗадание(РегЗадание.УникальныйИдентификатор, ПараметрыЗадания);
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Метаданные", ИмяЗадания);
	РегЗадание = РегламентныеЗаданияСервер.НайтиЗадания(ПараметрыОтбора)[0];
	
	Элемент = Элементы[ИмяЗадания];
	УстановитьТекстНадписиРегламентнойНастройки(РегЗадание, Элемент);
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьРасписаниеЗадания(ИмяЗадания, РасписаниеРегламентногоЗадания)
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Метаданные", ИмяЗадания);
	РегЗадание = РегламентныеЗаданияСервер.НайтиЗадания(ПараметрыОтбора)[0];

	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("Расписание", РасписаниеРегламентногоЗадания);
	РегламентныеЗаданияСервер.ИзменитьЗадание(РегЗадание.УникальныйИдентификатор, ПараметрыЗадания);
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Метаданные", ИмяЗадания);
	РегЗадание = РегламентныеЗаданияСервер.НайтиЗадания(ПараметрыОтбора)[0];
	
	Элемент = Элементы[ИмяЗадания];
	УстановитьТекстНадписиРегламентнойНастройки(РегЗадание, Элемент);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьТекстНадписиРегламентнойНастройки(Задание, Элемент)
	
	Перем ТекстРасписания;
	
	ПолучитьТекстЗаголовкаИРасписанияРегламентнойНастройки(Задание, ТекстРасписания, ОбменПоРасписанию);
	Элемент.Заголовок = ТекстРасписания;
	Элемент.Доступность = ОбменПоРасписанию;
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьТекстЗаголовкаИРасписанияРегламентнойНастройки(Задание, ТекстРасписания, РасписаниеАктивно) Экспорт
	
	РасписаниеАктивно = Ложь;
	
	Если Задание = Неопределено Тогда
		
		ТекстРасписания = НСтр("ru = '<Расписание не задано>'");
		
	Иначе
		
		Если Задание.Использование Тогда
			РасписаниеАктивно = Истина;
			ТекстРасписания = СтрШаблон(НСтр("ru = 'Расписание: %1'"), Строка(Задание.Расписание));
		Иначе
			ТекстРасписания = СтрШаблон(НСтр("ru = 'Расписание (НЕ АКТИВНО): %1'"), Строка(Задание.Расписание));
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция КодФСРАРИзОписанияОшибки(ОписаниеОшибки)
	
	Позиция = СтрНайти(ОписаниеОшибки, "RSA");
	
	Если Позиция <> 0 Тогда
		
		НачалоКода = СтрНайти(ОписаниеОшибки, "[",, Позиция);
		КонецКода = СтрНайти(ОписаниеОшибки, "]",, Позиция);
		
		Если НачалоКода <> 0 И КонецКода <> 0 Тогда
			
			НачалоКода = НачалоКода + 1;
			Возврат Сред(ОписаниеОшибки, НачалоКода, КонецКода - НачалоКода);
			
		КонецЕсли;
		
	Иначе
		
		Возврат ""
		
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ПолучитьКодФСРАРИзУТМ(ОписаниеОповещения, Таймаут)
	
	ИнтеграцияЕГАИСКлиент.ПроверитьПодключениеКУТМНемедленно(
		ОписаниеОповещения,
		Запись.АдресУТМ, Запись.ПортУТМ, Таймаут, ОбменНаСервере = 1);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьПодключениеКУТМ()
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОтображатьСообщенияОбОшибках", Ложь);
	
	ПолучитьКодФСРАРИзУТМ(
		Новый ОписаниеОповещения("ПослеПроверкиПодключенияКУТМ", ЭтотОбъект, ДополнительныеПараметры), 1);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеПроверкиПодключенияКУТМ(Изменения, ДополнительныеПараметры) Экспорт
	
	КодФСРАРИзУТМ = "";
	Если Изменения.Количество() = 1 Тогда
		
		РезультатВыполнения = Изменения[0];
		
		КодФСРАРИзУТМ = КодФСРАРИзОписанияОшибки(РезультатВыполнения.ТекстОшибки);
		
		Если ЗначениеЗаполнено(КодФСРАРИзУТМ)
			И КодФСРАРИзУТМ = Запись.ИдентификаторФСРАР Тогда
			
			ПодключениеНастроеноКорректно = Истина;
			УказанПравильныйКодФСРАР = Истина;
			Элементы.СтраницыПроверкаПодключения.ТекущаяСтраница = Элементы.СтраницыПроверкаПодключения.ПодчиненныеЭлементы.ПроверкаПодключенияКорректно;
			
		ИначеЕсли ЗначениеЗаполнено(КодФСРАРИзУТМ) Тогда
			
			ПодключениеНастроеноКорректно = Истина;
			УказанПравильныйКодФСРАР = Ложь;
			Элементы.СтраницыПроверкаПодключения.ТекущаяСтраница = Элементы.СтраницыПроверкаПодключения.ПодчиненныеЭлементы.ПереданНеверныйКодФСРАР;
			
			Если ДополнительныеПараметры.ОтображатьСообщенияОбОшибках Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(РезультатВыполнения.ТекстОшибки);
			КонецЕсли;
			
		Иначе
			
			Если ДополнительныеПараметры.ОтображатьСообщенияОбОшибках Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(РезультатВыполнения.ТекстОшибки);
			КонецЕсли;
			
			Элементы.СтраницыПроверкаПодключения.ТекущаяСтраница = Элементы.СтраницыПроверкаПодключения.ПодчиненныеЭлементы.НетСвязиСУТМ;
			
		КонецЕсли;
		
	Иначе
		
		Элементы.СтраницыПроверкаПодключения.ТекущаяСтраница = Элементы.СтраницыПроверкаПодключения.ПодчиненныеЭлементы.НетСвязиСУТМ;
		
	КонецЕсли;
	
	ОбновитьТекстСопоставления(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеОткрытияWebИнтерфейсаУТМ(Результат, ДополнительныеПараметры) Экспорт
	Возврат;
КонецПроцедуры

&НаКлиенте
Процедура ГруппаВыполняетсяПроверкаПодключенияКУТМНадписьОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	ОбработатьНавигационнуюСсылку(НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппаНетСвязиСУТМНадписьОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	ОбработатьНавигационнуюСсылку(НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппаПодключениеНастроеноКорректноНадписьОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	ОбработатьНавигационнуюСсылку(НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппаГруппаПроверкаНеПодключенияНеВыполняласьНадписьОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	ОбработатьНавигационнуюСсылку(НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьНавигационнуюСсылку(Знач НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОтображатьСообщенияОбОшибках", Истина);
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ПроверитьПодключениеКУТМ" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ПолучитьКодФСРАРИзУТМ(
		Новый ОписаниеОповещения("ПослеПроверкиПодключенияКУТМ", ЭтотОбъект, ДополнительныеПараметры), Запись.Таймаут)
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ОткрытьWebИнтерфейсУТМ" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		НачатьЗапускПриложения(
			Новый ОписаниеОповещения("ПослеОткрытияWebИнтерфейсаУТМ", ЭтотОбъект),
			"http://" + Запись.АдресУТМ + ":" + Формат(Запись.ПортУТМ, "ЧГ=0") + "/");
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "Повторить" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ПолучитьКодФСРАРИзУТМ(
			Новый ОписаниеОповещения("ПослеПроверкиПодключенияКУТМ", ЭтотОбъект, ДополнительныеПараметры), Запись.Таймаут);
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если ПринудительноЗакрытьФорму Тогда
		Возврат;
	КонецЕсли;
	
	Если ПодключениеНастроеноКорректно
		И УказанПравильныйКодФСРАР
		И ТребуетсяЗапроситьДанныеОрганизацииЕГАИС Тогда
		
		Отказ = Истина;
		
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(КодВозвратаДиалога.Да,     НСтр("ru='Запросить данные'"));
		Кнопки.Добавить(КодВозвратаДиалога.Нет,    НСтр("ru='Закрыть форму'"));
		Кнопки.Добавить(КодВозвратаДиалога.Отмена, НСтр("ru='Отмена'"));
		
		ПоказатьВопрос(
			Новый ОписаниеОповещения("ОбработатьОтветНаВопросОЗапросеДанныхОрганизацииЕГАИСПередЗаписью", ЭтотОбъект),
			СтрШаблон(
				НСтр("ru='Перед выполнением обмена данными с ЕГАИС рекомендуется
				         |запросить данные организации с кодом ФСРАР %1.'"),
				Запись.ИдентификаторФСРАР),
			Кнопки,,
			КодВозвратаДиалога.Да);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти