#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьКоличествоДокументовКОплате(ПараметрыЗапроса, ПоВсемДокументам = Ложь) Экспорт
	
	Если ПараметрыЗапроса.Свойство("МассивОрганизаций") Тогда
		МассивОрганизаций = ПараметрыЗапроса.МассивОрганизаций;
	ИначеЕсли НЕ ЗначениеЗаполнено(ПараметрыЗапроса.Организация) Тогда
		МассивОрганизаций = Справочники.Организации.ДоступныеОрганизации();
	Иначе
		МассивОрганизаций = ОбщегоНазначенияУТКлиентСервер.Массив(ПараметрыЗапроса.Организация);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ПараметрыЗапроса.КонецПериода) Тогда
		ПараметрыЗапроса.КонецПериода = Дата('209901010000');
	КонецЕсли;
	
	Запрос = Новый Запрос;
	
	Если ПоВсемДокументам Тогда
		Запрос.Текст = "
		|ВЫБРАТЬ
		|	КОЛИЧЕСТВО(1) КАК Количество
		|ИЗ
		|	РегистрСведений.ПодтверждениеОплатыНДСВБюджет КАК ПодтверждениеОплатыНДСВБюджет
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.РеестрДокументов КАК РеестрДокументов
		|		ПО ПодтверждениеОплатыНДСВБюджет.СчетФактура = РеестрДокументов.Ссылка
		|ГДЕ
		|	РеестрДокументов.Организация В (&МассивОрганизаций)
		|	И ПодтверждениеОплатыНДСВБюджет.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияОплатыНДСВБюджет.ОжидаетОплаты)
		|	И РеестрДокументов.ДатаДокументаИБ <= &КонецПериода
		|	И РеестрДокументов.Проведен";
	Иначе
		Запрос.Текст = "
		|ВЫБРАТЬ
		|	КОЛИЧЕСТВО(1) КАК Количество
		|ИЗ
		|	РегистрСведений.ПодтверждениеОплатыНДСВБюджет КАК ПодтверждениеОплатыНДСВБюджет
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.РеестрДокументов КАК РеестрДокументов
		|		ПО ПодтверждениеОплатыНДСВБюджет.СчетФактура = РеестрДокументов.Ссылка
		|ГДЕ
		|	РеестрДокументов.Организация В (&МассивОрганизаций)
		|	И ПодтверждениеОплатыНДСВБюджет.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияОплатыНДСВБюджет.ОжидаетОплаты)
		|	И ПодтверждениеОплатыНДСВБюджет.ВидАгентскогоДоговора В 
		|			(ЗНАЧЕНИЕ(Перечисление.ВидыАгентскихДоговоров.Нерезидент), 
		|			 ЗНАЧЕНИЕ(Перечисление.ВидыАгентскихДоговоров.НерезидентЭлектронныеУслуги))
		|	И РеестрДокументов.ДатаДокументаИБ <= &КонецПериода
		|	И РеестрДокументов.Проведен";
	КонецЕсли;
	
	Запрос.УстановитьПараметр("МассивОрганизаций",	МассивОрганизаций);
	Запрос.УстановитьПараметр("НачалоПериода",		ПараметрыЗапроса.НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода",		ПараметрыЗапроса.КонецПериода);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Количество;
	Иначе
		Возврат 0;
	КонецЕсли;
		
КонецФункции

Функция ПолучитьКоличествоЗаявленийКПодтверждениюОплаты(ПараметрыЗапроса) Экспорт
	
	Если НЕ ЗначениеЗаполнено(ПараметрыЗапроса.КонецПериода) Тогда
		ПараметрыЗапроса.КонецПериода = Дата('209901010000');
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Оплачено.СчетФактура) КАК Количество
	|ИЗ
	|	РегистрСведений.ПодтверждениеОплатыНДСВБюджет КАК Оплачено
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.РеестрДокументов КАК РеестрДокументов
	|		ПО Оплачено.СчетФактура = РеестрДокументов.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПодтверждениеОплатыНДСВБюджет КАК Подтверждено
	|		ПО Оплачено.СчетФактура = Подтверждено.СчетФактура
	|			И (Подтверждено.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияОплатыНДСВБюджет.ПолученоПодтверждение))
	|ГДЕ
	|	Оплачено.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияОплатыНДСВБюджет.Оплачено)
	|	И Оплачено.СчетФактура ССЫЛКА Документ.ЗаявлениеОВвозеТоваров
	|	И Подтверждено.СчетФактура ЕСТЬ NULL
	|	И РеестрДокументов.ДатаДокументаИБ <= &КонецПериода
	|	И РеестрДокументов.Проведен
	|	И РеестрДокументов.Организация В (&МассивОрганизаций)";
	
	Запрос.УстановитьПараметр("МассивОрганизаций",	ПараметрыЗапроса.МассивОрганизаций);
	Запрос.УстановитьПараметр("КонецПериода",		ПараметрыЗапроса.КонецПериода);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Количество;
	КонецЕсли;
	
	Возврат 0;
	
КонецФункции

Функция КлючНазначенияФормыПоУмолчанию() Экспорт
	
	Возврат "ДокументыКОплате";
	
КонецФункции


#Область ФормированиеГиперссылкиВЖурналеДокументыПродажи

Функция СформироватьГиперссылкуСмТакжеВРаботе(Параметры) Экспорт
	
	Если Не ПравоДоступа("Просмотр", Метаданные.Обработки.ПеречислениеНДСВБюджетПоОтдельнымОперациям) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ТекстГиперссылки = НСтр("ru = 'Перечисление НДС в бюджет по отдельным операциям'");
	
	Если ПолучитьКоличествоДокументовКОплате(Параметры, Истина) > 0 Тогда
		Возврат Новый ФорматированнаяСтрока(ТекстГиперссылки,,,, ИмяФормыРабочееМесто());
	Иначе
		Возврат Новый ФорматированнаяСтрока(ТекстГиперссылки,,ЦветаСтиля.НезаполненноеПолеТаблицы,, ИмяФормыРабочееМесто());
	КонецЕсли;
	
КонецФункции

Функция ИмяФормыРабочееМесто() Экспорт
	
	Возврат "Обработка.ПеречислениеНДСВБюджетПоОтдельнымОперациям.Форма.СписокДокументов";
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
