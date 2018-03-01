&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем ФормаДлительнойОперации;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	МИНИМУМ(ЧекККМ.Дата) КАК Дата
		|ИЗ
		|	Документ.ЧекККМ КАК ЧекККМ
		|ГДЕ
		|	ЧекККМ.Проведен
		|	И ЧекККМ.КассоваяСмена <> ЗНАЧЕНИЕ(Перечисление.СтатусыКассовойСмены.Открыта)");
		
	Результат = Запрос.Выполнить();
	Выборка   = Результат.Выбрать();
	Если Выборка.Следующий() Тогда
		ДатаНачала = Выборка.Дата;
	КонецЕсли;
	
	КоличествоДнейХраненияЧеков = Константы.КоличествоДнейХраненияЗаархивированныхЧеков.Получить() * 86400;
	ДатаОкончания = ТекущаяДатаСеанса() - КоличествоДнейХраненияЧеков;
	
	Если ДатаНачала > ДатаОкончания Тогда
		ДатаНачала = ДатаОкончания;
	КонецЕсли;
	
	ОбновитьСписокКассККМ();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьВыделенныеКассы(Команда)
	МассивСтрок = Элементы.ТаблицаКассы.ВыделенныеСтроки;
	ВыбратьВыделенныеКассыНаСервере(МассивСтрок);
КонецПроцедуры

&НаКлиенте
Процедура ИсключитьВыделенныеКассы(Команда)
	МассивСтрок = Элементы.ТаблицаКассы.ВыделенныеСтроки;
	ВыбратьВыделенныеКассыНаСервере(МассивСтрок, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбработкуЧеков(Команда)
	
	МассивВыбранныхСтрок = ТаблицаКассы.НайтиСтроки(Новый Структура("Выбран", Истина));
	
	Если МассивВыбранныхСтрок.Количество() = 0 Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Для обработки чеков ККМ необходимо выбрать хотя бы одну кассу ККМ.'"),
			,
			"ТаблицаКассы");
		Возврат
	КонецЕсли;
	
	СписокКнопок = Новый СписокЗначений;
	Если ВариантОбработки = 1 Тогда
		ТекстВопроса = НСтр("ru='ВНИМАНИЕ! Все чеки ККМ за выбранный период будут удалены. 
			|Это может занять продолжительное время. Удалить чеки ККМ?'");
		СписокКнопок.Добавить("Обработать", НСтр("ru = 'Удалить'"));
	Иначе
		ТекстВопроса = НСтр("ru='ВНИМАНИЕ! Все чеки ККМ за выбранный период будут заархивированы. 
			|Это может занять продолжительное время. Заархивировать чеки ККМ?'");
		СписокКнопок.Добавить("Обработать", НСтр("ru = 'Заархивировать'"));
	КонецЕсли;
	СписокКнопок.Добавить("Отмена", НСтр("ru = 'Отмена'"));
	
	ОтветНаВопрос = Неопределено;
	
	ПоказатьВопрос(Новый ОписаниеОповещения("ВыполнитьОбработкуЧековЗавершение", ЭтотОбъект), ТекстВопроса, СписокКнопок);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбработкуЧековЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт

	ОтветНаВопрос = РезультатВопроса;

	Если ОтветНаВопрос = "Обработать" Тогда
		РезультатОбработки = ОбработатьЧекиККМНаСервере();

		АдресХранилища = РезультатОбработки.АдресХранилища;
		Если НЕ РезультатОбработки.ЗаданиеВыполнено Тогда
			ИдентификаторЗадания = РезультатОбработки.ИдентификаторЗадания;
			ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
			ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтаФорма, ИдентификаторЗадания);
		Иначе
			ОповеститьПользователяОРезультатахВыполненияЗадания();
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура ПериодДатаНачалаПриИзменении(Элемент)
	ОбновитьСписокКассККМ();
КонецПроцедуры

&НаКлиенте
Процедура ПериодДатаОкончанияПриИзменении(Элемент)
	ОбновитьСписокКассККМ();
КонецПроцедуры

&НаКлиенте
Процедура УстановитьИнтервал(Команда)
	
	Диалог = Новый ДиалогРедактированияСтандартногоПериода();
	
	Диалог.Период.ДатаНачала    = ДатаНачала;
	Диалог.Период.ДатаОкончания = ДатаОкончания;
	Диалог.Показать(Новый ОписаниеОповещения("УстановитьИнтервалЗавершение", ЭтотОбъект, 
		Новый Структура("Диалог", Диалог)));

КонецПроцедуры

&НаКлиенте
Процедура УстановитьИнтервалЗавершение(Период, ДополнительныеПараметры) Экспорт
	
	Диалог = ДополнительныеПараметры.Диалог;
	Если ЗначениеЗаполнено(Период) Тогда
		ДатаНачала    = Диалог.Период.ДатаНачала;
		ДатаОкончания = Диалог.Период.ДатаОкончания;
		ОбновитьСписокКассККМ();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаКассыКассаККМ.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаКассыКоличествоЧеков.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаКассы.КоличествоЧеков");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.МеньшеИлиРавно;
	ОтборЭлемента.ПравоеЗначение = 0;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);

КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокКассККМ()

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	КассыККМ.Ссылка КАК КассаККМ
		|ПОМЕСТИТЬ КассыККМ
		|ИЗ
		|	Справочник.КассыККМ КАК КассыККМ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЧекККМ.Ссылка) КАК КоличествоЧековККМ,
		|	ЧекККМ.КассаККМ КАК КассаККМ
		|ПОМЕСТИТЬ ЧекиККМ
		|ИЗ
		|	Документ.ЧекККМ КАК ЧекККМ
		|ГДЕ
		|	ЧекККМ.КассоваяСмена.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
		|
		|СГРУППИРОВАТЬ ПО
		|	ЧекККМ.КассаККМ
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ 
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЧекККМВозврат.Ссылка) КАК КоличествоЧековККМ,
		|	ЧекККМВозврат.КассаККМ КАК КассаККМ
		|ИЗ
		|	Документ.ЧекККМВозврат КАК ЧекККМВозврат
		|ГДЕ
		|	ЧекККМ.КассоваяСмена.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
		|
		|СГРУППИРОВАТЬ ПО
		|	ЧекККМВозврат.КассаККМ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	КассыККМ.КассаККМ КАК КассаККМ,
		|	СУММА(ЕСТЬNULL(ЧекиККМ.КоличествоЧековККМ, 0)) КАК КоличествоЧеков,
		|	МАКСИМУМ(ВЫБОР
		|		КОГДА ЧекиККМ.КоличествоЧековККМ > 0
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ) КАК Выбран
		|ИЗ
		|	КассыККМ КАК КассыККМ
		|		ЛЕВОЕ СОЕДИНЕНИЕ ЧекиККМ КАК ЧекиККМ
		|		ПО КассыККМ.КассаККМ = ЧекиККМ.КассаККМ
		|СГРУППИРОВАТЬ ПО
		|	КассыККМ.КассаККМ";
		
	Запрос.УстановитьПараметр("ДатаНачала", ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания", ДатаОкончания);
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	
	ТаблицаКассы.Загрузить(РезультатЗапроса);
	
КонецПроцедуры

&НаСервере
Процедура ВыбратьВыделенныеКассыНаСервере(МассивСтрок, ЗначениеВыбора = Истина)
	
	Для Каждого ИдентификаторСтроки Из МассивСтрок Цикл
		СтрокаТаблицы = ТаблицаКассы.НайтиПоИдентификатору(ИдентификаторСтроки);
		Если СтрокаТаблицы.Выбран = (Не ЗначениеВыбора) Тогда
			СтрокаТаблицы.Выбран = ЗначениеВыбора;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

&НаСервере
Функция ОбработатьЧекиККМНаСервере()
	
	МассивВыбранныхСтрок = ТаблицаКассы.НайтиСтроки(Новый Структура("Выбран", Истина));
	
	ОбрабатываемыеКассы = Новый Массив;
	
	Для каждого ТекСтрока из МассивВыбранныхСтрок Цикл
		
		ОбрабатываемыеКассы.Добавить(ТекСтрока.КассаККМ);
		
	КонецЦикла;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КассоваяСмена.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.КассоваяСмена КАК КассоваяСмена
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.НастройкиРМК.КассыККМ КАК КассыККМ
	|		ПО КассыККМ.ПодключаемоеОборудование = КассоваяСмена.ФискальноеУстройство
	|		И НЕ КассыККМ.ИспользоватьБезПодключенияОборудования
	|ГДЕ
	|	КассоваяСмена.Проведен
	|	И (КассоваяСмена.КассаККМ В(&КассыККМ) ИЛИ КассыККМ.КассаККМ В(&КассыККМ))
	|	И КассоваяСмена.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
	|
	|СГРУППИРОВАТЬ ПО
	|	КассоваяСмена.Ссылка");
	
	Запрос.УстановитьПараметр("КассыККМ", ОбрабатываемыеКассы);
	Запрос.УстановитьПараметр("ДатаНачала", ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания", ДатаОкончания);
	
	Выборка = Запрос.Выполнить();
	
	ОбрабатываемыеКассовыеСмены = Выборка.Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("КассоваяСмена", ОбрабатываемыеКассовыеСмены);
	ПараметрыЗадания.Вставить("ОбработкаВыполнена", Ложь);
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		Результат = Новый Структура("ЗаданиеВыполнено,АдресХранилища", Истина, АдресХранилища);
		
		Если ВариантОбработки = 0 Тогда
			РозничныеПродажи.ВыполнитьАрхивациюЧековККМ(ПараметрыЗадания, АдресХранилища);
		Иначе
			РозничныеПродажи.ВыполнитьУдалениеЧековККМ(ПараметрыЗадания, АдресХранилища);
		КонецЕсли;
		ОбновитьСписокКассККМ();
	Иначе
		НаименованиеЗадания = НСтр("ru = 'Обработка чеков ККМ'");
		ПараметрыЗадания.Вставить("ЗаписыватьВЖурналРегистрации", Истина);
		
		Если ВариантОбработки = 0 Тогда
			Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
				УникальныйИдентификатор,
				"РозничныеПродажи.ВыполнитьАрхивациюЧековККМ",
				ПараметрыЗадания,
				НаименованиеЗадания);
		Иначе
			Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
				УникальныйИдентификатор,
				"РозничныеПродажи.ВыполнитьУдалениеЧековККМ",
				ПараметрыЗадания,
				НаименованиеЗадания);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
		
	Попытка
		Если ФормаДлительнойОперации.Открыта() 
			И ФормаДлительнойОперации.ИдентификаторЗадания = ИдентификаторЗадания Тогда
			Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда 
				ОповеститьПользователяОРезультатахВыполненияЗадания();
				ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
				ОбновитьСписокКассККМ();
			Иначе
				ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
				ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 
					ПараметрыОбработчикаОжидания.ТекущийИнтервал, 
					Истина);
			КонецЕсли;
		КонецЕсли;
	Исключение
		ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаКлиенте
Процедура ОповеститьПользователяОРезультатахВыполненияЗадания()
	
	ПараметрыОбработкиЧеков = ПолучитьИзВременногоХранилища(АдресХранилища);
	
	Если НЕ ПараметрыОбработкиЧеков.ОбработкаВыполнена Тогда
		Если СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента().ИнформационнаяБазаФайловая Тогда
			СообщениеОбОшибкеАрхивация = НСтр("ru='Архивация чеков ККМ завершена с ошибками.'");
			СообщениеОбОшибкеУдаление  = НСтр("ru='Удаление чеков ККМ завершено с ошибками.'");
		Иначе
			СообщениеОбОшибкеАрхивация = НСтр("ru='Архивация чеков ККМ завершена с ошибками. См. журнал регистрации.'");
			СообщениеОбОшибкеУдаление  = НСтр("ru='Удаление чеков ККМ завершено с ошибками. См. журнал регистрации.'");
		КонецЕсли;
		
		Если ВариантОбработки = 0 Тогда
			ПоказатьОповещениеПользователя(НСтр("ru='Архивация завершена.'"),
				,
				СообщениеОбОшибкеАрхивация,
				БиблиотекаКартинок.Информация32);
		ИначеЕсли ВариантОбработки = 1 Тогда
			ПоказатьОповещениеПользователя(НСтр("ru='Удаление завершено.'"),
				,
				СообщениеОбОшибкеУдаление,
				БиблиотекаКартинок.Информация32);
		КонецЕсли;
		
	Иначе
		Если ВариантОбработки = 0 Тогда
			ПоказатьОповещениеПользователя(НСтр("ru='Архивация завершена.'"),
				,
				НСтр("ru='Архивация чеков ККМ успешно завершена.'"),
				БиблиотекаКартинок.Информация32);
		ИначеЕсли ВариантОбработки = 1 Тогда
			ПоказатьОповещениеПользователя(НСтр("ru='Удаление завершено.'"),
				,
				НСтр("ru='Удаление чеков ККМ успешно завершено.'"),
				БиблиотекаКартинок.Информация32);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
