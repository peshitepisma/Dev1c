#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("Дата", Дата);
	Параметры.Свойство("Организация", Организация);
	Параметры.Свойство("ВыбранныеСчетаФактуры", СписокВыбранныхСчетовФактур);
	
	ЗаполнитьСчетаФактуры();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Для каждого Строка из СчетаФактуры Цикл
		
		ОбновитьИтоговыеСуммы(Строка);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПеренестиВДокумент(Команда)
	
	СтруктураРеквизитовФормы = Новый Структура;
	
	МассивДокументов = Новый Массив;
	Для каждого Строка  Из ЭтаФорма.СчетаФактуры Цикл
		Если Строка.Флаг Тогда
			МассивДокументов.Добавить(Строка.СчетФактура);
		КонецЕсли;
	КонецЦикла; 
	СтруктураРеквизитовФормы.Вставить("СчетаФактуры", МассивДокументов);
	
	Закрыть(СтруктураРеквизитовФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	
	УстановитьЗначениеФлага(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	
	УстановитьЗначениеФлага(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СчетаФактурыФлагПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.СчетаФактуры.ТекущиеДанные;
	
	ОбновитьИтоговыеСуммы(ТекущаяСтрока);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьСчетаФактуры() 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СостоянияБлокировкиВычетаНДСПоСчетамФактурамСрезПоследних.Организация,
	|	СостоянияБлокировкиВычетаНДСПоСчетамФактурамСрезПоследних.СчетФактура
	|ПОМЕСТИТЬ ВТ_ЗаблокированныеСФ
	|ИЗ
	|	РегистрСведений.СостоянияБлокировкиВычетаНДСПоСчетамФактурам.СрезПоследних(&КонецПериода, ) КАК СостоянияБлокировкиВычетаНДСПоСчетамФактурамСрезПоследних
	|ГДЕ
	|	СостоянияБлокировкиВычетаНДСПоСчетамФактурамСрезПоследних.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияБлокировкиВычетаНДС.Установлена)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НДСПредъявленный.Организация КАК Организация,
	|	НДСПредъявленный.СчетФактура КАК СчетФактура,
	|	НДСПредъявленный.Поставщик КАК Поставщик,
	|	НДСПредъявленный.НДСОстаток КАК НДС
	|ПОМЕСТИТЬ ВТ_НДСПредъявленный
	|ИЗ
	|	РегистрНакопления.НДСПредъявленный.Остатки(&КонецПериода, Организация = &Организация) КАК НДСПредъявленный
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДанныеПервичныхДокументов КАК ДанныеПервичныхДокументов
	|		ПО НДСПредъявленный.Организация = ДанныеПервичныхДокументов.Организация
	|			И НДСПредъявленный.СчетФактура = ДанныеПервичныхДокументов.Документ
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	НДСПредъявленный.Организация,
	|	НДСПредъявленный.СчетФактура,
	|	НДСПредъявленный.Поставщик,
	|	НДСПредъявленный.НДС
	|ИЗ
	|	РегистрНакопления.НДСПредъявленный КАК НДСПредъявленный
	|ГДЕ
	|	НДСПредъявленный.Период МЕЖДУ &НачалоПериода И &КонецПериода
	|	И НДСПредъявленный.Организация = &Организация
	|	И НДСПредъявленный.Событие = ЗНАЧЕНИЕ(Перечисление.СобытияНДСПредъявленный.НДСПринятКВычету)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Данные.Организация КАК Организация,
	|	Данные.СчетФактура КАК СчетФактура,
	|	Данные.Поставщик КАК Поставщик,
	|	ВЫБОР
	|		КОГДА Данные.СчетФактура ССЫЛКА Документ.ЗаявлениеОВвозеТоваров
	|			ТОГДА ВЫРАЗИТЬ(Данные.СчетФактура КАК Документ.ЗаявлениеОВвозеТоваров).Дата
	|		КОГДА Данные.СчетФактура ССЫЛКА Документ.ТаможеннаяДекларацияИмпорт
	|			ТОГДА ВЫРАЗИТЬ(Данные.СчетФактура КАК Документ.ТаможеннаяДекларацияИмпорт).Дата
	|		ИНАЧЕ ЕСТЬNULL(СФПолученный.Ссылка.Дата, СФВыданный.Ссылка.Дата)
	|	КОНЕЦ КАК ДатаПолученияСчетаФактуры,
	|	ВЫБОР
	|		КОГДА Данные.СчетФактура ССЫЛКА Документ.ЗаявлениеОВвозеТоваров
	|				ИЛИ Данные.СчетФактура ССЫЛКА Документ.ТаможеннаяДекларацияИмпорт
	|			ТОГДА Данные.СчетФактура
	|		ИНАЧЕ ЕСТЬNULL(СФПолученный.Ссылка, СФВыданный.Ссылка)
	|	КОНЕЦ КАК СчетФактураСсылка,
	|	СУММА(Данные.НДС) КАК НДС,
	|	ВЫБОР
	|		КОГДА Данные.СчетФактура В (&СписокВыбранныхСчетовФактур)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ДокументУжеВыбран,
	|	ВЫБОР
	|		КОГДА Данные.СчетФактура В (&СписокВыбранныхСчетовФактур)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК Флаг
	|ИЗ
	|	(ВЫБРАТЬ
	|		ВТ_НДСПредъявленный.Организация КАК Организация,
	|		ВТ_НДСПредъявленный.СчетФактура КАК СчетФактура,
	|		ВТ_НДСПредъявленный.Поставщик КАК Поставщик,
	|		ВТ_НДСПредъявленный.НДС КАК НДС
	|	ИЗ
	|		ВТ_НДСПредъявленный КАК ВТ_НДСПредъявленный
	|			ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ЗаблокированныеСФ КАК ВТ_ЗаблокированныеСФ
	|			ПО (ВТ_ЗаблокированныеСФ.Организация = ВТ_НДСПредъявленный.Организация)
	|				И (ВТ_ЗаблокированныеСФ.СчетФактура = ВТ_НДСПредъявленный.СчетФактура)
	|	ГДЕ
	|		ВТ_ЗаблокированныеСФ.СчетФактура ЕСТЬ NULL) КАК Данные
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.СчетФактураПолученный.ДокументыОснования КАК СФПолученный
	|		ПО Данные.СчетФактура = СФПолученный.ДокументОснование
	|			И (СФПолученный.Ссылка.Проведен)
	|			И (НЕ СФПолученный.Ссылка.Исправление)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.СчетФактураВыданный.ДокументыОснования КАК СФВыданный
	|		ПО Данные.СчетФактура = СФВыданный.ДокументОснование
	|			И (СФВыданный.Ссылка.Проведен)
	|			И (НЕ СФВыданный.Ссылка.Исправление)
	|ГДЕ
	|	(НЕ СФПолученный.Ссылка ЕСТЬ NULL
	|			ИЛИ НЕ СФВыданный.Ссылка ЕСТЬ NULL
	|			ИЛИ ТИПЗНАЧЕНИЯ(Данные.СчетФактура) В (ТИП(Документ.ТаможеннаяДекларацияИмпорт), ТИП(Документ.ЗаявлениеОВвозеТоваров)))
	|
	|СГРУППИРОВАТЬ ПО
	|	Данные.Организация,
	|	Данные.СчетФактура,
	|	Данные.Поставщик,
	|	СФПолученный.Ссылка,
	|	СФВыданный.Ссылка,
	|	ВЫБОР
	|		КОГДА Данные.СчетФактура ССЫЛКА Документ.ЗаявлениеОВвозеТоваров
	|			ТОГДА ВЫРАЗИТЬ(Данные.СчетФактура КАК Документ.ЗаявлениеОВвозеТоваров).Дата
	|		КОГДА Данные.СчетФактура ССЫЛКА Документ.ТаможеннаяДекларацияИмпорт
	|			ТОГДА ВЫРАЗИТЬ(Данные.СчетФактура КАК Документ.ТаможеннаяДекларацияИмпорт).Дата
	|		ИНАЧЕ ЕСТЬNULL(СФПолученный.Ссылка.Дата, СФВыданный.Ссылка.Дата)
	|	КОНЕЦ";
	
	
	Запрос.УстановитьПараметр("КонецПериода",  КонецМесяца(Дата));
	Запрос.УстановитьПараметр("НачалоПериода", НачалоМесяца(Дата));
	Запрос.УстановитьПараметр("Организация",   Организация);
	Запрос.УстановитьПараметр("СписокВыбранныхСчетовФактур", СписокВыбранныхСчетовФактур);
	
	СчетаФактуры.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьЗначениеФлага(ЗначениеФлага)
	
	Для каждого Строка из СчетаФактуры Цикл
		
		Строка.Флаг = ЗначениеФлага;
		ОбновитьИтоговыеСуммы(Строка);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИтоговыеСуммы(ТекущаяСтрока)
	
	Если ТекущаяСтрока.Флаг Тогда
		ВыбраноНаСумму = ВыбраноНаСумму + ТекущаяСтрока.НДС;
	Иначе
		ВыбраноНаСумму = ВыбраноНаСумму - ТекущаяСтрока.НДС;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти