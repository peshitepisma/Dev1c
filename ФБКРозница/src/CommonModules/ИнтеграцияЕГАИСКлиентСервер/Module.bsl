
#Область ПрограммныйИнтерфейс

#Область ОтборПоОрганизацииЕГАИС

Процедура НастроитьОтборПоОрганизацииЕГАИС(Форма, Результат, Префикс = Неопределено, Знач ЗначениеПрефиксы = Неопределено) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Массив") Тогда
		Форма.ОрганизацииЕГАИС.ЗагрузитьЗначения(Результат);
	ИначеЕсли ТипЗнч(Результат) = Тип("СправочникСсылка.КлассификаторОрганизацийЕГАИС") Тогда
		Форма.ОрганизацииЕГАИС.Очистить();
		Форма.ОрганизацииЕГАИС.Добавить(Результат);
	ИначеЕсли ТипЗнч(Результат) = Тип("СписокЗначений") Тогда
	Иначе
		Форма.ОрганизацииЕГАИС.Очистить();
	КонецЕсли;
	
	Если Форма.ОрганизацииЕГАИС.Количество() = 1 Тогда
		Форма.ОрганизацияЕГАИС = Форма.ОрганизацииЕГАИС.Получить(0).Значение;
		Форма.ОрганизацииЕГАИСПредставление = Строка(Форма.ОрганизацияЕГАИС);
	ИначеЕсли Форма.ОрганизацииЕГАИС.Количество() = 0 Тогда
		Форма.ОрганизацияЕГАИС = Неопределено;
		Форма.ОрганизацииЕГАИСПредставление = "";
	Иначе
		Форма.ОрганизацияЕГАИС = Неопределено;
		Форма.ОрганизацииЕГАИСПредставление = Строка(Форма.ОрганизацииЕГАИС);
	КонецЕсли;
	
	Если ЗначениеПрефиксы = Неопределено Тогда
		Префиксы = Новый Массив;
		Префиксы.Добавить("Оформлено");
		Префиксы.Добавить("КОформлению");
	Иначе
		Если ТипЗнч(ЗначениеПрефиксы) = Тип("Строка") Тогда
			Префиксы = Новый Массив();
			Префиксы.Добавить(ЗначениеПрефиксы);
		Иначе
			Префиксы = ЗначениеПрефиксы;
		КонецЕсли;
	КонецЕсли;
	
	Для Каждого Значение Из Префиксы Цикл
		
		Окончание = "ОрганизацияЕГАИС";
		Если Значение = "Отбор" Тогда
			Постфикс = Окончание;
		Иначе
			Постфикс = "Отбор" + Окончание;
		КонецЕсли;
		
		Форма.Элементы["Страницы" + Значение + Постфикс].ТекущаяСтраница = 
			?(Форма.ОрганизацииЕГАИС.Количество() > 1,
				Форма.Элементы["Страница" + Значение + Окончание],
				Форма.Элементы["Страница" + Значение + Окончание]);
	КонецЦикла;
	
	Если Префикс <> Неопределено Тогда
		Форма.ТекущийЭлемент = ?(
			Форма.ОрганизацииЕГАИС.Количество() > 1,
			Форма.Элементы[Префикс + "ОрганизацииЕГАИС"],
			Форма.Элементы[Префикс + "ОрганизацияЕГАИС"]);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

// Возвращает используемый формат обмена.
//
// Параметры:
//  ФорматОбмена - ПеречислениеСсылка.ФорматыОбменаЕГАИС - Формат обмена с ЕГАИС.
// 
// Возвращаемое значение:
//  ПеречислениеСсылка.ФорматыОбменаЕГАИС - Формат обмена с ЕГАИС.
//
Функция ФорматОбмена(ФорматОбмена = Неопределено) Экспорт
	
	Если Не ЗначениеЗаполнено(ФорматОбмена) Тогда
		Возврат ПредопределенноеЗначение("Перечисление.ФорматыОбменаЕГАИС.V2");
	Иначе
		Возврат ФорматОбмена;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Проверяет наличие у произвольного объекта реквизита с указанным именем.
//
Функция ЕстьРеквизитОбъекта(Объект, ИмяРеквизита) Экспорт
	
	КлючУникальности   = Новый УникальныйИдентификатор;
	СтруктураРеквизита = Новый Структура(ИмяРеквизита, КлючУникальности);

	ЗаполнитьЗначенияСвойств(СтруктураРеквизита, Объект);
	
	Возврат СтруктураРеквизита[ИмяРеквизита] <> КлючУникальности;
	
КонецФункции

// Возвращает структуру, необходимую для записи справки 1.
//
Функция СтруктураДанныхСправки1() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("РегистрационныйНомер"   , "");
	Результат.Вставить("Наименование"           , "");
	Результат.Вставить("НомерТТН"               , Неопределено);
	Результат.Вставить("ДатаТТН"                , Неопределено);
	Результат.Вставить("Грузоотправитель"       , Неопределено);
	Результат.Вставить("Грузополучатель"        , Неопределено);
	Результат.Вставить("ДатаОтгрузки"           , Неопределено);
	Результат.Вставить("АлкогольнаяПродукция"   , Неопределено);
	Результат.Вставить("ДатаРозлива"            , Неопределено);
	Результат.Вставить("Количество"             , Неопределено);
	Результат.Вставить("НомерПодтвержденияЕГАИС", Неопределено);
	Результат.Вставить("ДатаПодтвержденияЕГАИС" , Неопределено);
	
	Возврат Результат;
	
КонецФункции

// Возвращает структуру, необходимую для записи справки 2.
//
Функция СтруктураДанныхСправки2() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("РегистрационныйНомер",    "");
	Результат.Вставить("Наименование",            "");
	Результат.Вставить("АлкогольнаяПродукция",    Неопределено);
	Результат.Вставить("Количество",              Неопределено);
	Результат.Вставить("НомерСправки1",           "");
	Результат.Вставить("Справка1",                Неопределено);
	Результат.Вставить("ДокументОснование",       Неопределено);
	Результат.Вставить("НомерПодтвержденияЕГАИС", Неопределено);
	Результат.Вставить("ДатаПодтвержденияЕГАИС",  Неопределено);
	Результат.Вставить("ДиапазоныМарок" ,         Новый Массив);
	
	Возврат Результат;
	
КонецФункции

Функция СтруктураИзменения() Экспорт
	
	СтруктураИзменения = Новый Структура;
	СтруктураИзменения.Вставить("ОрганизацияЕГАИС");
	СтруктураИзменения.Вставить("Операция");
	СтруктураИзменения.Вставить("ФорматОбмена");
	
	СтруктураИзменения.Вставить("ТекстОшибки",           "");
	СтруктураИзменения.Вставить("ПодготовленоКПередаче", Ложь);
	СтруктураИзменения.Вставить("ПереданоВУТМ",          Ложь);
	СтруктураИзменения.Вставить("Принято",               Ложь);
	
	СтруктураИзменения.Вставить("ИсходящееСообщение");
	СтруктураИзменения.Вставить("ВходящееСообщение");
	
	СтруктураИзменения.Вставить("Объект");
	СтруктураИзменения.Вставить("ДокументОснование");
	СтруктураИзменения.Вставить("НовыйСтатус");
	
	// Результат чека ЕГАИС
	СтруктураИзменения.Вставить("ИдентификаторЗапроса");
	СтруктураИзменения.Вставить("Подпись");
	
	Возврат СтруктураИзменения;
	
КонецФункции

#Область ПроцедурыПересчетаСуммы

// Возвращает структуру, содержащую поля для пересчета суммы в табличной части документа
//
// Параметры:
//  Реквизиты - Строка - Содержит имена полей, заданных через запятую,
//  ЗависимыеРеквизиты - Структура - структура, каждое элемент которой есть структура с именами реквизитов без префикса,
//                       ключ элемента содержит префикс. Например Новый Структура("Тара", "Сумма, СуммаНДС") означает
//                       наличие реквизитов: "СуммаТара" и "СуммаНДСТара".
//  ИмяПоляКоличество     - Строка - Имя поля, по которому считается коэффициент пропорциональности.
//  РазрядностиОкругления - Структура - структура, в формате ИмяПоля => Количество знаков дробной части, которая будет
//                                      использоваться при пересчете реквизитов.
//
// Возвращаемое значение:
//  Структура - Структура со следующими полями:
//              Поля - Структура - содержит поля для пересчета суммы в табличной части документа,
//              Строки - Массив - содержит элементы типа ДанныеФормыЭлементКоллекции, ссылки нас строки для пересчета сумм,
//              ИтогКоличество - Число - сумма значений в поле "Количество" в строках переданных в параметре "Строки".
//
Функция СтруктураПересчетаСуммы(Реквизиты, ЗависимыеРеквизиты = Неопределено, ИмяПоляКоличество = "Количество", РазрядностиОкругления = Неопределено) Экспорт

	Поля = Новый Структура(Реквизиты);
	Если ЗависимыеРеквизиты <> Неопределено Тогда
		
		Для Каждого ПолеСтруктуры Из ЗависимыеРеквизиты цикл

			Реквизиты = Новый Структура(ПолеСтруктуры.Значение);
			Для Каждого Поле Из Реквизиты цикл
				Поля.Вставить(Поле.Ключ + ПолеСтруктуры.Ключ);
			КонецЦикла;

		КонецЦикла;

	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("Поля", Поля);
	Результат.Вставить("Строки", Новый Массив());
	Результат.Вставить("ИтогКоличество", 0);
	Результат.Вставить("ИмяПоляКоличество", ИмяПоляКоличество);
	Результат.Вставить("РазрядностиОкругления", РазрядностиОкругления);

	Возврат Результат;

КонецФункции

// Инициализирует структуру для пересчета суммы в табличной части документа
//
// Параметры:
//  СтруктураПересчетаСуммы - Структура - структура подлежащая инициализации, описание см. функция
//                            ОбработкаТабличнойЧастиКлиентСервер.СтруктураПересчетаСуммы.
//  ДанныеЗаполнения - ДанныеФормыЭлементКоллекции - строка, содержащая значения суммовых показателей,
//                     которые необходимо будет распределить между строками при пересчете сумм.
//
// Возвращаемое значение:
//  Структура - Структура со следующими полями:
//              Поля - Структура - содержит поля для пересчета суммы в табличной части документа,
//              Строки - Массив - содержит элементы типа ДанныеФормыЭлементКоллекции, ссылки нас строки для пересчета сумм,
//              ИтогКоличество - Число - сумма значений в поле "Количество" в строках переданных в параметре "Строки".
//
Процедура ЗаполнитьСтруктуруПересчетаСуммы(СтруктураПересчетаСуммы, ДанныеЗаполнения) Экспорт

	ЗаполнитьЗначенияСвойств(СтруктураПересчетаСуммы.Поля, ДанныеЗаполнения);

	СтруктураПересчетаСуммы.ИтогКоличество = 0;
	СтруктураПересчетаСуммы.Строки.Очистить();

КонецПроцедуры

// Добавляет строку для пересчета суммы в структуру пересчета суммы, описание см. функция
//                            ОбработкаТабличнойЧастиКлиентСервер.СтруктураПересчетаСуммы.
//
// Параметры:
//  СтруктураПересчетаСуммы - Структура - структура пересчета суммы, описание см. функция
//                            ОбработкаТабличнойЧастиКлиентСервер.СтруктураПересчетаСуммы.
//  Строка - ДанныеФормыЭлементКоллекции - строка, для которой необходимо рассчитать значения сумм.
//
Процедура ДобавитьСтрокуДляПересчетаСуммы(СтруктураПересчетаСуммы, Строка) Экспорт

	СтруктураПересчетаСуммы.Строки.Добавить(Строка);
	СтруктураПересчетаСуммы.ИтогКоличество = СтруктураПересчетаСуммы.ИтогКоличество + Строка[СтруктураПересчетаСуммы.ИмяПоляКоличество];

Конецпроцедуры

// Пересчитывает суммы в строках, добавленных в структуру пересчета суммы, описание см. функция
//                            ОбработкаТабличнойЧастиКлиентСервер.СтруктураПересчетаСуммы.
//
// Параметры:
//  СтруктураПересчетаСуммы - Структура - структура пересчета суммы, описание см. функция
//                            ОбработкаТабличнойЧастиКлиентСервер.СтруктураПересчетаСуммы.
//
Процедура ПересчитатьСуммы(СтруктураПересчетаСуммы) Экспорт
	
	РазрядностиОкругления = Неопределено;
	Если СтруктураПересчетаСуммы.Свойство("РазрядностиОкругления") Тогда
		РазрядностиОкругления = СтруктураПересчетаСуммы.РазрядностиОкругления;
	КонецЕсли;
	
	Для Каждого Строка Из СтруктураПересчетаСуммы.Строки Цикл
		
		Если СтруктураПересчетаСуммы.ИтогКоличество = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		Коэффициент = Строка[СтруктураПересчетаСуммы.ИмяПоляКоличество] / СтруктураПересчетаСуммы.ИтогКоличество;
		СтруктураПересчетаСуммы.ИтогКоличество = СтруктураПересчетаСуммы.ИтогКоличество - Строка[СтруктураПересчетаСуммы.ИмяПоляКоличество];

		Для Каждого Поле Из СтруктураПересчетаСуммы.Поля Цикл
			
			НовоеЗначение = Поле.Значение * Коэффициент;
			
			Если РазрядностиОкругления <> Неопределено Тогда
				Строка[Поле.Ключ] = Окр(НовоеЗначение, РазрядностиОкругления[Поле.Ключ]);
			Иначе
				Строка[Поле.Ключ] = НовоеЗначение;
			КонецЕсли;
			
			СтруктураПересчетаСуммы.Поля[Поле.Ключ] = Поле.Значение - Строка[Поле.Ключ];

		КонецЦикла;

	КонецЦикла;

КонецПроцедуры

#КонецОбласти

// Добавляет в свойство структуры сообщения текст ошибки
//
// Параметры:
//  Сообщение    - Структура - сообщение, в которое добавляется текст ошибки.
//  ТекстОшибки  - Строка - добавляемый текст ошибки.
//
Процедура ДобавитьТекстОшибки(Сообщение, ТекстОшибки) Экспорт
	
	Если Сообщение.Ошибки.Получить(ТекстОшибки) <> Неопределено Тогда
		Возврат;
	Иначе
		Сообщение.Ошибки.Вставить(ТекстОшибки, Истина);
	КонецЕсли;
	
	Если Сообщение.ТекстОшибки = "" Тогда
		Сообщение.ТекстОшибки = ТекстОшибки;
	Иначе
		Сообщение.ТекстОшибки = Сообщение.ТекстОшибки + Символы.ПС + ТекстОшибки;
	КонецЕсли;
	
КонецПроцедуры

Функция НоваяНастройкаОбменаЕГАИС() Экспорт
	
	НастройкиОбменаЕГАИС = Новый Структура;
	НастройкиОбменаЕГАИС.Вставить("АдресУТМ",                   "127.0.0.1");
	НастройкиОбменаЕГАИС.Вставить("ПортУТМ",                    8080);
	НастройкиОбменаЕГАИС.Вставить("Таймаут",                    60);
	НастройкиОбменаЕГАИС.Вставить("ЗагружатьВходящиеДокументы", Ложь);
	
	Возврат НастройкиОбменаЕГАИС;
	
КонецФункции

Функция ПараметрыHTTPЗапроса(ТекстСообщенияXML, АдресЗапроса) Экспорт
	
	Параметры = ИнтеграцияЕГАИСКлиентСервер.СтруктураДанныхHTTPЗапроса("POST");
	
	ВремГраница = СтрЗаменить(Строка(Новый УникальныйИдентификатор()), "-", "");
	
	ТелоЗапроса = Новый ТекстовыйДокумент();
	ТелоЗапроса.ДобавитьСтроку("--" + ВремГраница);
	ТелоЗапроса.ДобавитьСтроку("Content-Disposition: form-data; name=""xml_file""");
	ТелоЗапроса.ДобавитьСтроку("Content-Type: text/xml; charset=utf-8");
	ТелоЗапроса.ДобавитьСтроку("");
	ТелоЗапроса.ДобавитьСтроку(ТекстСообщенияXML);
	ТелоЗапроса.ДобавитьСтроку("--" + ВремГраница + "--");
	
	Параметры.АдресЗапроса = АдресЗапроса;
	Параметры.ТелоЗапроса  = ТелоЗапроса.ПолучитьТекст();
	Параметры.ТекстXML     = ТекстСообщенияXML;
	
	Параметры.Заголовки.Вставить("Content-Type", "multipart/form-data; boundary=" + ВремГраница);
	
	Возврат Параметры;
	
КонецФункции

// Инициализирует структуру результата исходящего сообщения после получения ответа.
// 
// Возвращаемое значение:
// Структура:
//   ТекстСообщенияXMLОтправлен  - Булево - признак того, что сообщеие отправлено.
//   ТекстСообщенияXMLПолучен    - Булево - признак того, что сообщение получено.
//   ТекстОшибки                 - Строка - текст ошибки, если таковая возникла.
//   ТекстВходящегоСообщенияXML  - Строка - текст ответа, на отправленное сообщение.
//
Функция ОтветТекстСообщенияXMLПолучен(ТекстВходящегоСообщенияXML)
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("ТекстСообщенияXMLОтправлен",  Истина);
	ВозвращаемоеЗначение.Вставить("ТекстСообщенияXMLПолучен",    Истина);
	
	ВозвращаемоеЗначение.Вставить("ТекстОшибки",                "");
	ВозвращаемоеЗначение.Вставить("ТекстВходящегоСообщенияXML", ТекстВходящегоСообщенияXML);
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Инициализирует структуру результата исходящего сообщения после отправки сообщения, но до получения ответа.
// 
// Возвращаемое значение:
// Структура:
//   ТекстСообщенияXMLОтправлен  - Булево - признак того, что сообщеие отправлено.
//   ТекстСообщенияXMLПолучен    - Булево - признак того, что сообщение получено.
//   ТекстОшибки                 - Строка - текст ошибки, если таковая возникла.
//   ТекстВходящегоСообщенияXML  - Строка - текст ответа, на отправленное сообщение.
//
Функция ОтветТекстСообщенияXMLНеПолучен(Ошибка, ТекстСообщенияXMLОтправлен)
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("ТекстСообщенияXMLОтправлен",  ТекстСообщенияXMLОтправлен);
	ВозвращаемоеЗначение.Вставить("ТекстСообщенияXMLПолучен",    Ложь);
	
	ВозвращаемоеЗначение.Вставить("ТекстОшибки",                Строка(Ошибка));
	ВозвращаемоеЗначение.Вставить("ТекстВходящегоСообщенияXML", "");
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Получает организации ЕГАИС из настроек обмена.
//
// Параметры:
//  НастройкиОбменаЕГАИС - Соответствие - Настройки обмена ЕГАИС по организациям:
//   * Ключ - СправочникСсылка.КлассификаторОрганизацийЕГАИС - Ораганизация ЕГАИС.
//   * Значение - Структура - Настройки обмена ЕГАИС, см. функцию ИнтеграцияЕГАИСКлиентСервер.НоваяНастройкаОбменаЕГАИС().
//
Функция ОрганизацииЕГАИС(НастройкиОбменаЕГАИС) Экспорт
	
	ОрганизацииЕГАИС = Новый Массив;
	
	Для Каждого КлючИЗначение Из НастройкиОбменаЕГАИС Цикл
		
		ОрганизацииЕГАИС.Добавить(КлючИЗначение.Ключ);
		
	КонецЦикла;
	
	Возврат ОрганизацииЕГАИС;
	
КонецФункции

#Если НЕ ВебКлиент Тогда

Функция ОбработатьРезультатОтправкиHTTPЗапроса(РезультатОтправкиHTTPЗапроса) Экспорт
	
	Если РезультатОтправкиHTTPЗапроса.КодСостояния = 200 Тогда
		
		Возврат ОтветТекстСообщенияXMLПолучен(РезультатОтправкиHTTPЗапроса.ТекстОтвета);
		
	ИначеЕсли РезультатОтправкиHTTPЗапроса.КодСостояния = 500
		И ЗначениеЗаполнено(РезультатОтправкиHTTPЗапроса.ТекстОтвета) Тогда
		
		Возврат ОтветТекстСообщенияXMLПолучен(РезультатОтправкиHTTPЗапроса.ТекстОтвета);
		
	Иначе
		
		Если Не ЗначениеЗаполнено(РезультатОтправкиHTTPЗапроса.КодСостояния) Тогда
			ТекстСообщенияXMLОтправлен = Ложь;
			ЗаголовокОшибки = НСтр("ru = 'HTTP-запрос не отправлен.'");
		Иначе
			ТекстСообщенияXMLОтправлен = Истина;
			ЗаголовокОшибки = СтрШаблон(НСтр("ru = 'Код состояния HTTP: %1.'"), РезультатОтправкиHTTPЗапроса.КодСостояния);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(РезультатОтправкиHTTPЗапроса.ТекстОшибки) Тогда
			ТекстОшибки = ЗаголовокОшибки + Символы.ПС + РезультатОтправкиHTTPЗапроса.ТекстОшибки;
		ИначеЕсли ЗначениеЗаполнено(РезультатОтправкиHTTPЗапроса.ТекстОтвета) Тогда
			ТекстОшибки = ЗаголовокОшибки + Символы.ПС + ОбработатьОтветНаПередачуДанных(РезультатОтправкиHTTPЗапроса.ТекстОтвета).Ошибка;
		Иначе
			ТекстОшибки = ЗаголовокОшибки;
		КонецЕсли;
		
		Возврат ОтветТекстСообщенияXMLНеПолучен(ТекстОшибки, ТекстСообщенияXMLОтправлен);
		
	КонецЕсли;
	
КонецФункции

// Отправляет HTTP-запрос в УТМ ЕГАИС.
//
Функция ОтправитьHTTPЗапрос(ТранспортныйМодуль, Параметры) Экспорт
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("КодСостояния");
	ВозвращаемоеЗначение.Вставить("Заголовки");
	ВозвращаемоеЗначение.Вставить("ТекстОтвета");
	ВозвращаемоеЗначение.Вставить("ТекстОшибки");
	
	HTTPЗапрос = Новый HTTPЗапрос(Параметры.АдресЗапроса, Параметры.Заголовки);
	
	Если Параметры.ТипЗапроса = "POST" Тогда
		HTTPЗапрос.УстановитьТелоИзСтроки(Параметры.ТелоЗапроса, КодировкаТекста.UTF8, ИспользованиеByteOrderMark.НеИспользовать);
	КонецЕсли;
	
	ИнтернетПрокси = ПолучениеФайловИзИнтернетаКлиентСервер.ПолучитьПрокси("HTTP");
	
	HTTPОтвет   = Неопределено;
	ТекстОшибки = "";
	
	Попытка
		
		Соединение = Новый HTTPСоединение(
			СокрЛП(ТранспортныйМодуль.АдресУТМ),
			ТранспортныйМодуль.ПортУТМ,,,
			ИнтернетПрокси,
			ТранспортныйМодуль.Таймаут);
		
		Если Параметры.ТипЗапроса = "GET" Тогда
			HTTPОтвет = Соединение.Получить(HTTPЗапрос);
		ИначеЕсли Параметры.ТипЗапроса = "POST" Тогда
			HTTPОтвет = Соединение.ОтправитьДляОбработки(HTTPЗапрос);
		ИначеЕсли Параметры.ТипЗапроса = "DELETE" Тогда
			HTTPОтвет = Соединение.Удалить(HTTPЗапрос);
		КонецЕсли;
		
	Исключение
		
		ТекстОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		#Если НЕ ТонкийКлиент Тогда
			ЗаписьЖурналаРегистрации(
				СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Ошибка,,,
				СтрШаблон(
					НСтр("ru = 'Ошибка отправки %1-запроса по адресу %2'"),
					Параметры.ТипЗапроса,
					Параметры.АдресЗапроса) + Символы.ПС + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		#КонецЕсли
		
	КонецПопытки;
	
	ВозвращаемоеЗначение.ТекстОшибки = ТекстОшибки;
	Если HTTPОтвет <> Неопределено Тогда
		ВозвращаемоеЗначение.КодСостояния = HTTPОтвет.КодСостояния;
		ВозвращаемоеЗначение.Заголовки    = HTTPОтвет.Заголовки;
		ВозвращаемоеЗначение.ТекстОтвета  = HTTPОтвет.ПолучитьТелоКакСтроку();
	КонецЕсли;
	
	Возврат ВозвращаемоеЗначение;

КонецФункции

// Разбирает ответ, полученный из УТМ.
//
// Параметры:
//  ТекстВходящегоСообщенияXML - Строка - Текст входящего сообщения XML/
//
// Возвращаемое значение:
//  Структура - Структура со свойствами:
//   * ИдентификаторЗапроса - Строка - Идентификатор запроса.
//   * Подпись - Строка - Подпись.
//   * Ошибка - Строка - Текст ошибки.
//
Функция ОбработатьОтветНаПередачуДанных(ТекстВходящегоСообщенияXML) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ИдентификаторЗапроса");
	Результат.Вставить("Подпись");
	Результат.Вставить("Ошибка");
	
	Попытка
		
		ЧтениеXML = Новый ЧтениеXML;
		ЧтениеXML.УстановитьСтроку(ТекстВходящегоСообщенияXML);
		
		ПостроительDOM = Новый ПостроительDOM;
		ДокументDOM = ПостроительDOM.Прочитать(ЧтениеXML);
		
		УзлыURL = ДокументDOM.ПолучитьЭлементыПоИмени("*");
		
		Для Каждого УзелURL Из УзлыURL Цикл
			Если УзелURL.ИмяУзла = "url" Тогда
				Результат.ИдентификаторЗапроса = УзелURL.ТекстовоеСодержимое;
			ИначеЕсли УзелURL.ИмяУзла = "sign" Тогда
				Результат.Подпись = УзелURL.ТекстовоеСодержимое;
			ИначеЕсли УзелURL.ИмяУзла = "error" Тогда
				Результат.Ошибка = УзелURL.ТекстовоеСодержимое;
			КонецЕсли;
		КонецЦикла;
		
		ЧтениеXML.Закрыть();
		
	Исключение
		
		Результат.Ошибка = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

// Разбирает список входящих документов и подготавливает список URL-адресов документов к загрузке.
//
// Параметры:
//  РезультатыПолученияСписковДокументовПоОрганизациямЕГАИС - Соответствие - Соответствие со значениями:
//   * Ключ - СправочникСсылка.КлассификаторОрганизацийЕГАИС - Организация ЕГАИС.
//   * Значение - Массив - Полученные ответы от ЕГАИС
// Возвращаемое значение:
//  Массив - Массив обработанных данных:
//   * ОрганизацияЕГАИС - СправочникСсылка.КлассификаторОрганизацийЕГАИС - Организация ЕГАИС.
//   * ИдентификаторЗапроса - Строка - Идентификатор запроса.
//   * АдресURL - Строка - Адрес URL.
//
Функция ОбработатьОтветНаЗапросПолученияДокументов(РезультатыПолученияСписковДокументовПоОрганизациямЕГАИС) Экспорт
	
	ВозвращаемоеЗначение = Новый Массив;
	
	Для Каждого КлючИЗначение Из РезультатыПолученияСписковДокументовПоОрганизациямЕГАИС Цикл
		
		ОрганизацияЕГАИС = КлючИЗначение.Ключ;
		
		Для Каждого ТекстВходящегоСообщенияXML Из КлючИЗначение.Значение Цикл
			
			ЧтениеXML = Новый ЧтениеXML;
			ЧтениеXML.УстановитьСтроку(ТекстВходящегоСообщенияXML);
			
			ПостроительDOM = Новый ПостроительDOM;
			ДокументDOM = ПостроительDOM.Прочитать(ЧтениеXML);
			
			УзлыURL = ДокументDOM.ПолучитьЭлементыПоИмени("url");
			
			Для Каждого УзелURL Из УзлыURL Цикл
				
				АтрибутDOM = УзелURL.Атрибуты.ПолучитьИменованныйЭлемент("replyId");
				
				Если АтрибутDOM <> Неопределено Тогда
					ИдентификаторЗапроса = АтрибутDOM.Значение;
				Иначе
					ИдентификаторЗапроса = "";
				КонецЕсли;
				
				ВозвращаемоеЗначение.Добавить(
					Новый Структура(
						"ОрганизацияЕГАИС, ИдентификаторЗапроса, АдресURL",
						ОрганизацияЕГАИС,
						ИдентификаторЗапроса,
						УзелURL.ТекстовоеСодержимое));
				
			КонецЦикла;
			
			ЧтениеXML.Закрыть();
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Получает список входящих документов из транспортного модуля.
//
// Параметры:
//  НастройкиОбменаЕГАИС - Соответствие - Настройки обмена ЕГАИС по организациям:
//   * Ключ - СправочникСсылка.КлассификаторОрганизацийЕГАИС - Ораганизация ЕГАИС.
//   * Значение - Структура - Настройки обмена ЕГАИС, см. функцию ИнтеграцияЕГАИСКлиентСервер.НоваяНастройкаОбменаЕГАИС().
//
// Возвращаемое значение:
//  Структура со свойствами:
//   * ТекстОшибки - Строка - Текст ошибки.
//   * ДанныеОбработки - Массив - Массив структур со свойстами:
//      ** ОрганизацияЕГАИС - СправочникСсылка.КлассификаторОрганизацийЕГАИС - Организация ЕГАИС.
//      ** ИдентификаторЗапроса - Строка - Идентификатор запроса.
//      ** АдресURL - Строка - Адрес URL.
//
Функция АдресаURLВходящихДокументов(НастройкиОбменаЕГАИС, ОрганизацияЕГАИС) Экспорт
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("ТекстОшибки",     "");
	ВозвращаемоеЗначение.Вставить("ДанныеОбработки", Неопределено);
	
	НастройкаОбменаЕГАИС = НастройкиОбменаЕГАИС.Получить(ОрганизацияЕГАИС);
	
	РезультатОперации = ИнтеграцияЕГАИСКлиентСервер.ОбработатьРезультатОтправкиHTTPЗапроса(
		ИнтеграцияЕГАИСКлиентСервер.ОтправитьHTTPЗапрос(
			НастройкаОбменаЕГАИС,
			ИнтеграцияЕГАИСКлиентСервер.СтруктураДанныхHTTPЗапроса("GET", "/opt/out")));
	
	Если Не РезультатОперации.ТекстСообщенияXMLПолучен Тогда
		ВозвращаемоеЗначение.ТекстОшибки = РезультатОперации.ТекстОшибки;
		Возврат ВозвращаемоеЗначение;
	КонецЕсли;
	
	Данные = Новый Массив;
	Данные.Добавить(РезультатОперации.ТекстВходящегоСообщенияXML);
	
	РезультатыПолученияСписковДокументовПоОрганизациямЕГАИС = Новый Соответствие;
	РезультатыПолученияСписковДокументовПоОрганизациямЕГАИС.Вставить(ОрганизацияЕГАИС, Данные);
	
	ВозвращаемоеЗначение.ДанныеОбработки = ИнтеграцияЕГАИСКлиентСервер.ОбработатьОтветНаЗапросПолученияДокументов(
		РезультатыПолученияСписковДокументовПоОрганизациямЕГАИС);
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

#КонецЕсли

// Имя события для записи в журнал регистрации.
//
Функция СобытиеЖурналаРегистрации() Экспорт
	
	Возврат НСтр("ru = 'Интеграция с ЕГАИС'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	
КонецФункции

// Возвращает структуру, необходимую для отправки запроса в УТМ.
//
Функция СтруктураДанныхHTTPЗапроса(ТипЗапроса = "", АдресЗапроса = "") Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ТипЗапроса"  , ТипЗапроса);
	Результат.Вставить("АдресЗапроса", АдресЗапроса);
	Результат.Вставить("ТелоЗапроса" , "");
	Результат.Вставить("ТекстXML"    , "");
	Результат.Вставить("Заголовки"   , Новый Соответствие);
	
	Возврат Результат;
	
КонецФункции

// Заполняет структуру обработки входящего документов.
//
Функция СтруктураЗагрузкиВходящегоДокумента(ОрганизацияЕГАИС, ИдентификаторЗапроса, АдресЗапроса, ТекстXML) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ОрганизацияЕГАИС",     ОрганизацияЕГАИС);
	Результат.Вставить("ИдентификаторЗапроса", ИдентификаторЗапроса); // Заполняется, если получен ответ на исходящий запрос.
	Результат.Вставить("АдресЗапроса",         АдресЗапроса); // URL-адрес документа в УТМ.
	Результат.Вставить("ТекстXML",             ТекстXML); // Текст XML входящего документа.
	
	Возврат Результат;
	
КонецФункции

// Устанавливает отбор в списке по указанному значению для нужной колонки
// с учетом переданной структуры быстрого отбора
//
// Параметры:
//  Список - динамический список, для которого требуется установить отбор
//  ИмяКолонки - Строка - Имя колонки, по которой устанавливается отбор
//  Значение - устанавливаемое значение отбора
//  СтруктураБыстрогоОтбора - Неопределено, Структура - Структура, содержащая ключи и значения отбора
//  Использование - Неопределено, Булево - Признак использования элемента отбора
//  ВидСравнения - Неопределено, ВидСравненияКомпоновкиДанных - вид сравнения, устанавливаемый для элемента отбора
//  ПриводитьЗначениеКЧислу - Булево - Признак приведения значения к числу.
//
Процедура ОтборПоЗначениюСпискаПриСозданииНаСервере(Список, ИмяКолонки, Значение, Знач СтруктураБыстрогоОтбораРасширенная,
			Использование = Неопределено, ВидСравнения = Неопределено, ПриводитьЗначениеКЧислу = Ложь) Экспорт
	
	Если СтруктураБыстрогоОтбораРасширенная <> Неопределено Тогда
		
		Если СтруктураБыстрогоОтбораРасширенная.Количество() = 2
			И СтруктураБыстрогоОтбораРасширенная.Свойство("ИмяПоля")
			И СтруктураБыстрогоОтбораРасширенная.Свойство("Настройки") Тогда
			СтруктураБыстрогоОтбора = СтруктураБыстрогоОтбораРасширенная.Настройки;
			ИмяКолонкиДляПоиска = СтруктураБыстрогоОтбораРасширенная.ИмяПоля;
		Иначе
			СтруктураБыстрогоОтбора = СтруктураБыстрогоОтбораРасширенная;
			ИмяКолонкиДляПоиска = ИмяКолонки;
		КонецЕсли;
		
		Если СтруктураБыстрогоОтбора <> Неопределено
			И СтруктураБыстрогоОтбора.Свойство(ИмяКолонкиДляПоиска) Тогда
			
			ЗначениеОтбора = СтруктураБыстрогоОтбора[ИмяКолонкиДляПоиска];
			Если ТипЗнч(Значение) = Тип("СписокЗначений") Тогда
				
				Если ТипЗнч(ЗначениеОтбора) = Тип("СписокЗначений") Тогда
					Значение.ЗагрузитьЗначения(ЗначениеОтбора.ВыгрузитьЗначения());
				ИначеЕсли ТипЗнч(ЗначениеОтбора) = Тип("Массив") Тогда
					Значение.ЗагрузитьЗначения(ЗначениеОтбора);
				Иначе
					Значение.Очистить();
					Если ЗначениеЗаполнено(ЗначениеОтбора) Тогда
						Значение.Добавить(ЗначениеОтбора);
					КонецЕсли;
				КонецЕсли;
				
			Иначе
				
				Значение = ЗначениеОтбора;
				
			КонецЕсли;
			
			Если ПриводитьЗначениеКЧислу Тогда
				Значение = ?(ЗначениеЗаполнено(Значение), Число(Значение), Значение);
			КонецЕсли;
			
			Если ТипЗнч(Значение) = Тип("СписокЗначений") Тогда
				ИспользованиеЭлементаОтбора = ?(Использование = Неопределено, Значение.Количество() > 0, Использование);
			Иначе
				ИспользованиеЭлементаОтбора = ?(Использование = Неопределено, ЗначениеЗаполнено(Значение), Использование);
			КонецЕсли;
			
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, ИмяКолонки, Значение, ВидСравнения,,ИспользованиеЭлементаОтбора);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Устанавливает отбор в списке по указанному значению для нужной колонки
// с учетом переданной структуры быстрого отбора и переданных настроек
//
// Параметры:
//  Список - динамический список, для которого треюуется установить отбор
//  ИмяКолонки - Строка - Имя колонки, по которой устанавливается отбор
//  Значение - устанавливаемое значение отбора
//  СтруктураБыстрогоОтбора - Неопределено, Структура - Структура, содержащая ключи и значения отбора
//  Настройки - настройки, из которых могут получаться значения отбора
//  Использование - Неопределено, Булево - Признак использования элемента отбора
//  ВидСравнения - Неопределено, ВидСравненияКомпоновкиДанных - вид сравнения, устанавливаемый для элемента отбора
//  ПриводитьЗначениеКЧислу - Булево - Признак приведения значения к числу.
//
Процедура ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(Список, ИмяКолонки, Значение, Знач СтруктураБыстрогоОтбораРасширенная,
			НастройкиРасширенные, Использование = Неопределено, ВидСравнения = Неопределено, ПриводитьЗначениеКЧислу = Ложь) Экспорт
	
	Если ТипЗнч(НастройкиРасширенные) = Тип("Структура")
		И НастройкиРасширенные.Количество() = 2
		И НастройкиРасширенные.Свойство("ИмяПоля")
		И НастройкиРасширенные.Свойство("Настройки") Тогда
		Настройки           = НастройкиРасширенные.Настройки;
		ИмяКолонкиДляПоиска = НастройкиРасширенные.ИмяПоля;
	Иначе
		Настройки           = НастройкиРасширенные;
		ИмяКолонкиДляПоиска = ИмяКолонки;
	КонецЕсли;
	
	Если СтруктураБыстрогоОтбораРасширенная <> Неопределено Тогда
		
		Если СтруктураБыстрогоОтбораРасширенная.Количество() = 2
			И СтруктураБыстрогоОтбораРасширенная.Свойство("ИмяПоля")
			И СтруктураБыстрогоОтбораРасширенная.Свойство("СтруктураБыстрогоОтбора") Тогда
			СтруктураБыстрогоОтбора = СтруктураБыстрогоОтбораРасширенная.СтруктураБыстрогоОтбора;
			ИмяКолонкиДляПоиска = СтруктураБыстрогоОтбораРасширенная.ИмяПоля;
		Иначе
			СтруктураБыстрогоОтбора = СтруктураБыстрогоОтбораРасширенная;
			ИмяКолонкиДляПоиска = ИмяКолонки;
		КонецЕсли;
		
		Если СтруктураБыстрогоОтбора.Свойство(ИмяКолонкиДляПоиска) Тогда
			
			ЗначениеОтбора = СтруктураБыстрогоОтбора[ИмяКолонкиДляПоиска];
			Если ТипЗнч(Значение) = Тип("СписокЗначений") Тогда
				
				Если ТипЗнч(ЗначениеОтбора) = Тип("СписокЗначений") Тогда
					Значение.ЗагрузитьЗначения(ЗначениеОтбора.ВыгрузитьЗначения());
				ИначеЕсли ТипЗнч(ЗначениеОтбора) = Тип("Массив") Тогда
					Значение.ЗагрузитьЗначения(ЗначениеОтбора);
				Иначе
					Значение.Очистить();
					Если ЗначениеЗаполнено(ЗначениеОтбора) Тогда
						Значение.Добавить(ЗначениеОтбора);
					КонецЕсли;
				КонецЕсли;
				
			Иначе
				
				Значение = ЗначениеОтбора;
				
			КонецЕсли;
			
			Если ПриводитьЗначениеКЧислу Тогда
				Значение = ?(ЗначениеЗаполнено(Значение), Число(Значение), Значение);
			КонецЕсли;
			
			Если ТипЗнч(Значение) = Тип("СписокЗначений") Тогда
				ИспользованиеЭлементаОтбора = ?(Использование = Неопределено, Значение.Количество() > 0, Использование);
			Иначе
				ИспользованиеЭлементаОтбора = ?(Использование = Неопределено, ЗначениеЗаполнено(Значение), Использование);
			КонецЕсли;
			
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, ИмяКолонки, Значение, ВидСравнения,,ИспользованиеЭлементаОтбора);
			
		КонецЕсли;
		
	Иначе
		
		ЗначениеОтбора = Настройки.Получить(ИмяКолонкиДляПоиска);
		
		Если ТипЗнч(Значение) = Тип("СписокЗначений") Тогда
			
			Если ТипЗнч(ЗначениеОтбора) = Тип("СписокЗначений") Тогда
				Значение.ЗагрузитьЗначения(ЗначениеОтбора.ВыгрузитьЗначения());
			ИначеЕсли ТипЗнч(ЗначениеОтбора) = Тип("Массив") Тогда
				Значение.ЗагрузитьЗначения(ЗначениеОтбора);
			Иначе
				Значение.Очистить();
				Если ЗначениеЗаполнено(ЗначениеОтбора) Тогда
					Значение.Добавить(ЗначениеОтбора);
				КонецЕсли;
			КонецЕсли;
			
		Иначе
			
			Значение = ЗначениеОтбора;
			
		КонецЕсли;
		
		Если ПриводитьЗначениеКЧислу Тогда
			Значение = ?(ЗначениеЗаполнено(Значение), Число(Значение), Значение);
		КонецЕсли;
		
		Если ТипЗнч(Значение) = Тип("СписокЗначений") Тогда
			ИспользованиеЭлементаОтбора = ?(Использование = Неопределено, Значение.Количество() > 0, Использование);
		Иначе
			ИспользованиеЭлементаОтбора = ?(Использование = Неопределено, ЗначениеЗаполнено(Значение), Использование);
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, ИмяКолонки, Значение, ВидСравнения,,ИспользованиеЭлементаОтбора);
		
	КонецЕсли;
	
КонецПроцедуры

// Создает структура поиска поля для загрузки из настроек.
//
// Параметры:
//  ИмяПоля - Строка - Имя поля для загрузки.
//  СтруктураБыстрогоОтбора - Структура - Структура быстрого отбора.
// 
// Возвращаемое значение:
//  Структура - Структура со свойствами:
//   * ИмяПоля - Строка - Имя поля для загрузки.
//   * СтруктураБыстрогоОтбора - Структура - Структура быстрого отбора.
//
Функция СтруктураПоискаПоляДляЗагрузкиИзНастроек(ИмяПоля, Настройки) Экспорт
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("ИмяПоля",   ИмяПоля);
	ВозвращаемоеЗначение.Вставить("Настройки", Настройки);
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Проверяет передан ли в форму списка документов отбор по дальнейшему действию ЕГАИС
//
// Параметры:
// ДальнейшееДействиеГИСМ - Строка, ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюГИСМ - поле отбора
// СтруктураБыстрогоОтбора - Структура - переданный в форму списка документов отбор
//
// Возвращаемое значение:
// Булево
// Истина, если необходимо установить отбор по состоянию, иначе Ложь
//
Функция НеобходимОтборПоДальнейшемуДействиюЕГАИСПриСозданииНаСервере(ДальнейшееДействиеЕГАИС, Знач СтруктураБыстрогоОтбора) Экспорт
	
	Если СтруктураБыстрогоОтбора <> Неопределено Тогда
		Если СтруктураБыстрогоОтбора.Свойство("ДальнейшееДействиеЕГАИС", ДальнейшееДействиеЕГАИС) Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

// Проверяет, нужно ли устанавливать отбор по дальнейшему действию ГИСМ, загруженный из настроек или переданный в форму извне
//
// Отбор из настроек устанавливается только если отбор не передан в форму извне
//
// Параметры:
// ДальнейшееДействиеГИСМ -  Строка, ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюГИСМ - поле отбора по дальнейшему действию ГИСМ
// СтруктураБыстрогоОтбора - Структура - переданный в форму списка документов отбор
// Настройки - Соответствие - настройки формы
//
Функция НеобходимОтборПоДальнейшемуДействиюЕГАИСПередЗагрузкойИзНастроек(ДальнейшееДействиеЕГАИС, Знач СтруктураБыстрогоОтбора, Настройки) Экспорт
	
	НеобходимОтбор = Ложь;
	
	Если СтруктураБыстрогоОтбора = Неопределено Тогда
		
		ДальнейшееДействиеЕГАИС = Настройки.Получить("ДальнейшееДействиеЕГАИС");
		НеобходимОтбор = Истина;
		
	Иначе
	
		Если Не СтруктураБыстрогоОтбора.Свойство("ДальнейшееДействиеЕГАИС") Тогда
			ДальнейшееДействиеЕГАИС = Настройки.Получить("ДальнейшееДействиеЕГАИС");
			НеобходимОтбор = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат НеобходимОтбор;
	
КонецФункции

#КонецОбласти