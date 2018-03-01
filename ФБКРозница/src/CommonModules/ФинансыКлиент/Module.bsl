
#Область ПрограммныйИнтерфейс

// Процедура получает банк по указанному БИК или корреспондентскому счету.
//
// Параметры:
//	Форма - УправляемаяФорма - Текущая форма
//	Элемент - ПолеУправляемойФормы - Поле, в котором произведен выбор значения.
//	Значение - Строка - Значение, выбранное в поле.
//	СписокБанков - СписокЗначений - Список найденных банков
//	Банк - СправочникСсылка.КлассификаторБанков - Значение поля для указания банка
//
Процедура ПолучитьБанкПоРеквизитам(Форма, Элемент, Значение, СписокБанков, Банк) Экспорт

	// Если возвращен список банков, произведем выбор банка из списка.
	Если СписокБанков.Количество() > 1 Тогда
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("Форма", Форма);
		ДополнительныеПараметры.Вставить("Банк", Банк);
		ОписаниеОповещенияВыбораИзСписка = Новый ОписаниеОповещения("ВыборБанкаИзСпискаЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		Форма.ПоказатьВыборИзСписка(ОписаниеОповещенияВыбораИзСписка, СписокБанков, Элемент);
		
	ИначеЕсли СписокБанков.Количество() = 0 Тогда
		
		Если Не ПустаяСтрока(Значение) Тогда
			
			СписокВариантовОтветовНаВопрос = Новый СписокЗначений;
			СписокВариантовОтветовНаВопрос.Добавить("ВыбратьИзСписка", НСтр("ru='Выбрать из списка'"));
			СписокВариантовОтветовНаВопрос.Добавить("ОтменитьВвод", НСтр("ru='Отменить ввод'"));
			
			ТекстВопроса = НСтр("ru = 'Банк с %Поле%  %Значение% не найден в классификаторе банков.'");
			ТекстВопроса = СтрЗаменить(ТекстВопроса,"%Поле%", Элемент.Имя);
			ТекстВопроса = СтрЗаменить(ТекстВопроса,"%Значение%", Значение);
			
			ОписаниеОповещения = Новый ОписаниеОповещения(
				"ПолучитьБанкПоРеквизитамЗавершение",
				ЭтотОбъект,
				Новый Структура("Элемент, Форма", Элемент, Форма)
				);
			ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, СписокВариантовОтветовНаВопрос, 0, , НСтр("ru = 'Выбор банка из классификатора'"));
			
		Иначе
			Результат = "ВыбратьИзСписка";
			ПолучитьБанкПоРеквизитамЗавершение(Результат, Новый Структура("Элемент, Форма", Элемент, Форма));
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыборБанкаИзСпискаЗавершение(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныйЭлемент <> Неопределено Тогда
		ДополнительныеПараметры.Банк = ВыбранныйЭлемент.Значение;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПолучитьБанкПоРеквизитамЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт

	Элемент = ДополнительныеПараметры.Элемент;
	Форма = ДополнительныеПараметры.Форма;
	
	Ответ = РезультатВопроса;
	
	Если Ответ = "ОтменитьВвод" Тогда
		Форма.БИКБанка = "";
	ИначеЕсли Ответ = "ВыбратьИзСписка" Тогда
		СтруктураПараметров = Новый Структура;
		ОткрытьФорму("Справочник.КлассификаторБанков.Форма.ФормаВыбора", , Элемент);
	КонецЕсли;

КонецПроцедуры

// Процедура выводит сообщения пользователю, если заполнение на основании
// не было выполнено.
//
// Параметры:
//	Объект - ДанныеФорма - Текущий объект
//	Параметры - Структура - Коллекция параметров формы
//
Процедура ПроверитьЗаполнениеДокументаНаОсновании(Объект, Основание) Экспорт
	
	Если ЗначениеЗаполнено(Основание)
	   И Объект.СуммаДокумента = 0 Тогда
	   
		Если ТипЗнч(Основание) = Тип("ДокументСсылка.СчетНаОплатуКлиенту") Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Остаток задолженности по счету ""%1"" равен 0. Укажите сумму документа вручную'"),
				Основание);
		ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.ЗаявкаНаРасходованиеДенежныхСредств") Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Остаток по заявке ""%1"" равен 0. Выберите неоплаченную заявку'"),
				Основание);
		ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.РаспоряжениеНаПеремещениеДенежныхСредств") Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Остаток по распоряжению ""%1"" равен 0. Выберите неоплаченное распоряжение'"),
				Основание);
		ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.РасходныйКассовыйОрдер") Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Остаток денежных средств к поступлению по документу ""%1"" равен 0. Укажите сумму документа вручную'"),
				Основание);
		Иначе
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Остаток задолженности по документу ""%1"" равен 0. Укажите сумму документа вручную'"),
				Основание);
		КонецЕсли;
				
		Если Не ПустаяСтрока(Текст) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				,
				"Объект.СуммаДокумента",
				// Отказ
			);
		КонецЕсли;
	   
	КонецЕсли;
	
КонецПроцедуры

// Проверяет необходимость пересчета сумм документа из валюты в валюту
//
// Параметры:
//	Объект - ДанныеФормыСтруктура - Текущий документ
//	ТекущаяВалюта - СправочникСсылка.Валюты - Текущая валюта
//	НоваяВалюта - СправочникСсылка.Валюты - Новая валюта
//
// Возвращаемое значение:
//	Булево - Истина, если требуется пересчет сумм
//
Функция НеобходимПересчетВВалюту(Объект, ТекущаяВалюта, НоваяВалюта) Экспорт
	
	НеобходимПересчет = Ложь;
	
	Если ЗначениеЗаполнено(ТекущаяВалюта)
	 И ЗначениеЗаполнено(НоваяВалюта)
	 И ТекущаяВалюта <> НоваяВалюта Тогда
	
		МассивТабличныйЧастей = Новый Массив;
		МассивТабличныйЧастей.Добавить("РасшифровкаПлатежа");
		МассивТабличныйЧастей.Добавить("ДебиторскаяЗадолженность");
		МассивТабличныйЧастей.Добавить("КредиторскаяЗадолженность");
		
		Если Объект.СуммаДокумента <> 0 Тогда
			НеобходимПересчет = Истина;
		Иначе
			Для Каждого ТабличнаяЧасть Из МассивТабличныйЧастей Цикл
				
				Если Объект.Свойство(ТабличнаяЧасть)
				 И Объект[ТабличнаяЧасть].Итог("Сумма") <> 0 Тогда
					НеобходимПересчет = Истина;
					Прервать;
				КонецЕсли;
				
			КонецЦикла;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат НеобходимПересчет;
	
КонецФункции

// Процедура при необходимости очищает сумму взаиморасчетов в табличной части "Расшифровка платежа".
//
// Параметры:
//	Объект - ДанныеФормыСтруктура - Текущий документ
//
Процедура ОчиститьСуммуВзаиморасчетовРасшифровкиПлатежа(Объект) Экспорт
	
	Для Каждого СтрокаТаблицы Из Объект.РасшифровкаПлатежа Цикл
		
		Если СтрокаТаблицы.СуммаВзаиморасчетов > 0
			И СтрокаТаблицы.ВалютаВзаиморасчетов <> Объект.Валюта Тогда
		
			СтрокаТаблицы.СуммаВзаиморасчетов = 0;
			
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Процедура очищает сумму взаиморасчетов и валюту взаиморасчетов в табличной части "Расшифровка платежа".
//
// Параметры:
//	Объект - ДанныеФормыСтруктура - Текущий документ
//
Процедура ОчиститьСуммуИВалютуВзаиморасчетовРасшифровкиПлатежа(Объект) Экспорт
	
	Для Каждого СтрокаТаблицы Из Объект.РасшифровкаПлатежа Цикл
		
		Если ЗначениеЗаполнено(СтрокаТаблицы.Заказ) Тогда
			Если СтрокаТаблицы.ВалютаВзаиморасчетов = Объект.Валюта Тогда
				СтрокаТаблицы.СуммаВзаиморасчетов = 0;
			КонецЕсли;
		Иначе
			СтрокаТаблицы.ВалютаВзаиморасчетов = Неопределено;
			СтрокаТаблицы.СуммаВзаиморасчетов = 0;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Открытие формы просмотра/редактирования видов запасов документа.
//
// Параметры:
//	Объект  - ДанныеФормыСтруктура - Текущий документ
//	АдресТоваровВХранилище - Строка - Адрес
//	АдресВидовЗапасовВХранилище - Строка - Адрес
//	Форма - Текущая форма
//	РедактироватьВидыЗапасов - Булево - Разрешено редактирование видов запасов в форме
//	ОтображатьДокументРеализации - Булево - Признак видимости документа реализации
//	Склад - СправочникСсылка.Склады - Склад
//
Процедура ОткрытьВидыЗапасов(Объект, АдресТоваровВХранилище, АдресВидовЗапасовВХранилище, Форма, РедактироватьВидыЗапасов = Истина, ОтображатьДокументРеализации = Ложь, Склад = Неопределено) Экспорт
	ПараметрыВвода = Новый Структура("
		|АдресТоваровВХранилище,
		|АдресВидовЗапасовВХранилище,
		|Организация,
		|Склад,
		|ЦенаВключаетНДС,
		|РедактироватьВидыЗапасов,
		|ДокументМодифицирован,
		|ОтображатьДокументРеализации,
		|ВидыЗапасовУказаныВручную
		|");
	ЗаполнитьЗначенияСвойств(ПараметрыВвода, Объект); // Организация, Склад, ЦенаВключаетНДС, ВидыЗапасовУказаныВручную
	Если ЗначениеЗаполнено(Склад) Тогда
		ПараметрыВвода.Склад = Склад;
	КонецЕсли;
	
	ПараметрыВвода.АдресТоваровВХранилище = АдресТоваровВХранилище;
	ПараметрыВвода.АдресВидовЗапасовВХранилище = АдресВидовЗапасовВХранилище;
	ПараметрыВвода.ОтображатьДокументРеализации = ОтображатьДокументРеализации;
	ПараметрыВвода.ДокументМодифицирован = Форма.Модифицированность;
	
	ПараметрыВвода.РедактироватьВидыЗапасов =
		РедактироватьВидыЗапасов И (Не Форма.ТолькоПросмотр) И Форма.Доступность
		И ЗначениеЗаполнено(ПараметрыВвода.ВидыЗапасовУказаныВручную);
	
	ФормаВвода = ОткрытьФорму("Справочник.ВидыЗапасов.Форма.ФормаВводаВидовЗапасов", ПараметрыВвода, Форма);
	Если ПараметрыВвода.РедактироватьВидыЗапасов И ФормаВвода.РедактироватьВидыЗапасов Тогда
		Форма.ЗаблокироватьДанныеФормыДляРедактирования();
		Форма.Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры

// Определяет относится ли хозяйственная операция документа к расчетами с клиентами.
//
// Параметры:
//	ХозяйственнаяОперация - ПеречислениеСсылка.ХозяйственныеОперации - Хозяйственная операция документа
//
// Возвращаемое значение:
//	Булево - Хозяйственная операция относится к расчетам с клиентами
//
Функция ЭтоРасчетыСКлиентами(ХозяйственнаяОперация) Экспорт
	
	Если ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПоступлениеОплатыОтКлиента")
	 ИЛИ ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВозвратОплатыКлиенту") Тогда
		ЭтоРасчетыСКлиентами = Истина;
	Иначе
		ЭтоРасчетыСКлиентами = Ложь;
	КонецЕсли;
	
	Возврат ЭтоРасчетыСКлиентами;
	
КонецФункции

// Процедура выбора документа расчетов с клиентами или поставщиками.
//
// Параметры:
//	ЗначенияОтбора - Структура - Содержит отборы документа по реквизитам.
//	ПараметрыВыбора - Структура - Настройки выбора, см. ФинансыКлиент.ПараметрыВыбораДокументаРасчетов().
//	Элемент - ПолеФормы - Поле для выбора документа расчетов
//	СтандартнаяОбработка - Булево - Признак выполнения стандартной (системной) обработки
//
Процедура ДокументРасчетовНачалоВыбора(ЗначенияОтбора, ПараметрыВыбора, Элемент, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыВыбора.Вставить("Отбор", ЗначенияОтбора);
	
	ОткрытьФорму("ОбщаяФорма.ВыборДокументаРасчетов", ПараметрыВыбора, Элемент);
	
КонецПроцедуры

// Получает пустую ссылку на заказ клиента или на заказ поставщику.
//
// Параметры:
//	Заказ - ДокументСсылка - Заказ
//	ЭтоРасчетыСКлиентами - Булево - Признак отражения расчетов с клиентами
//
Процедура УстановитьПустуюСсылкуНаЗаказ(Заказ, ЭтоРасчетыСКлиентами) Экспорт
	
	Если Заказ = Неопределено Тогда
		Если ЭтоРасчетыСКлиентами Тогда
			Заказ = ПредопределенноеЗначение("Документ.ЗаказКлиента.ПустаяСсылка");
		Иначе
			Заказ = ПредопределенноеЗначение("Документ.ЗаказПоставщику.ПустаяСсылка");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Пересчитывает сумму в шапке документа, если она отличается от сумм в табличной части.
//
// Параметры:
//    Форма - УправляемаяФорма - Форма, из которой подбирается многооборотная тара
//    ОписаниеОповещения - ОписаниеОповещения - Описание оповещения формы документа
//    ИмяТаблицы - Строка - Имя табличной части, содержащей расшифровку платежа
//
Процедура ПересчитатьСуммуДокументаПоРасшифровкеПлатежа(
	Знач Форма,
	ОписаниеОповещения,
	Знач ИмяТабличнойЧасти = "") Экспорт
	
	Если Не ЗначениеЗаполнено(ИмяТабличнойЧасти) Тогда
		ТабличнаяЧасть = Форма.Объект.РасшифровкаПлатежа;
	Иначе
		ТабличнаяЧасть = Форма.Объект[ИмяТабличнойЧасти];
	КонецЕсли;
	
	Если ТабличнаяЧасть.Количество() > 0
		И Форма.Объект.СуммаДокумента <> ТабличнаяЧасть.Итог("Сумма") Тогда
		
		ТекстВопроса = НСтр("ru = 'Сумма по строкам в табличной части не равна сумме документа, пересчитать сумму документа?'");
		
		ДопПараметры = Новый Структура;
		ДопПараметры.Вставить("Форма", Форма);
		ДопПараметры.Вставить("ОписаниеОповещения", ОписаниеОповещения);
		ДопПараметры.Вставить("ИмяТабличнойЧасти", ИмяТабличнойЧасти);
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПересчитатьСуммуДокументаПоРасшифровкеПлатежаЗавершение", ФинансыКлиент, ДопПараметры);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	Иначе
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, Истина);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПересчитатьСуммуДокументаПоРасшифровкеПлатежаЗавершение(ОтветНаВопрос, ДополнительныеПараметры) Экспорт
	
	Если ОтветНаВопрос = КодВозвратаДиалога.Да Тогда
		
		Если ДополнительныеПараметры.Свойство("ИмяТабличнойЧасти")
			И ЗначениеЗаполнено(ДополнительныеПараметры.ИмяТабличнойЧасти) Тогда
			ТабличнаяЧасть = ДополнительныеПараметры.Форма.Объект[ДополнительныеПараметры.ИмяТабличнойЧасти];
		Иначе
			ТабличнаяЧасть = ДополнительныеПараметры.Форма.Объект.РасшифровкаПлатежа;
		КонецЕсли;
		
		ДополнительныеПараметры.Форма.Объект.СуммаДокумента = ТабличнаяЧасть.Итог("Сумма");
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОписаниеОповещения, Истина);
	Иначе
		
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОписаниеОповещения, Ложь);
	КонецЕсли;
	
КонецПроцедуры

// Открывает файл для просмотра
//
// Параметры:
//    ЭлементПривязки - Строка - К указанному элементу будет привязано сообщение в случае ошибки
//    ИмяФайла - Строка - Полное имя файла
//    Кодировка - Строка - "DOS" или "Windows"
//    Заголовок - Строка - Заголовок формы, в которой будет открыт файл
//
Процедура ОткрытьФайлДляПросмотра(ЭлементПривязки, ИмяФайла, Кодировка, Заголовок) Экспорт
	
	ДополнительныеПараметры = Новый Структура("ИмяФайла, Кодировка, Заголовок, ЭлементПривязки", ИмяФайла, Кодировка, Заголовок, ЭлементПривязки);
	ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьФайлДляПросмотраСозданиеФайла", ЭтотОбъект, ДополнительныеПараметры);
	
	Файл = Новый Файл();
	Файл.НачатьИнициализацию(ОписаниеОповещения, ДополнительныеПараметры.ИмяФайла);
	
КонецПроцедуры

Процедура ОткрытьФайлДляПросмотраСозданиеФайла(Файл, ДополнительныеПараметры) Экспорт
	
	ДополнительныеПараметры.Вставить("Файл", Файл);
	ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьФайлДляПросмотраПроверкаСуществования", ЭтотОбъект, ДополнительныеПараметры);
	Файл.НачатьПроверкуСуществования(ОписаниеОповещения);
	
КонецПроцедуры

Процедура ОткрытьФайлДляПросмотраПроверкаСуществования(Существует, ДополнительныеПараметры) Экспорт
	
	Если НЕ Существует Тогда
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1 не обнаружен'"), ДополнительныеПараметры.Заголовок);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения
			,, ДополнительныеПараметры.ЭлементПривязки);
		
		Возврат;
	КонецЕсли;
	
	Файл = ДополнительныеПараметры.Файл;
	ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьФайлДляПросмотраПроверкаНаКаталог", ЭтотОбъект, ДополнительныеПараметры);
	Файл.НачатьПроверкуЭтоКаталог(ОписаниеОповещения);
	
КонецПроцедуры

Процедура ОткрытьФайлДляПросмотраПроверкаНаКаталог(ЭтоКаталог, ДополнительныеПараметры) Экспорт
	
	Если ЭтоКаталог Тогда
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1 не корректен - выбран ""каталог"".
			|Выберите %1'"), ДополнительныеПараметры.Заголовок);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения
			,, ДополнительныеПараметры.ЭлементПривязки);
		
		Возврат;
	КонецЕсли;
	
	ПомещаемыеФайлы = Новый Массив;
	ПомещаемыеФайлы.Добавить(Новый ОписаниеПередаваемогоФайла(ДополнительныеПараметры.ИмяФайла));
	
	ПомещениеФайловЗавершение = Новый ОписаниеОповещения("ОткрытьФайлДляПросмотраЗавершениеПомещения", ЭтотОбъект, ДополнительныеПараметры);
	НачатьПомещениеФайлов(ПомещениеФайловЗавершение, ПомещаемыеФайлы,, Ложь, );
	
КонецПроцедуры

Процедура ОткрытьФайлДляПросмотраЗавершениеПомещения(ПомещенныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ПомещенныеФайлы <> Неопределено И ПомещенныеФайлы.Количество() > 0 Тогда
		ОписаниеФайлов = ПомещенныеФайлы.Получить(0);
		АдресФайла     = ОписаниеФайлов.Хранение;
		
		Если АдресФайла = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		Текст = ДенежныеСредстваВызовСервера.ТекстовыйДокументИзВременногоХранилищаФайла(АдресФайла, ДополнительныеПараметры.Кодировка);
		Текст.Показать(ДополнительныеПараметры.Заголовок, ДополнительныеПараметры.ИмяФайла);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает параметры, используемые при выборе документа расчетов с клиентами.
// Используются в функции ФинансыКлиент.ДокументРасчетовНачалоВыбора
// 
// Возвращаемое значение: 
// Структура с ключами
//	ЭтоРасчетыСКлиентами - Булево - Признак подбора документа по расчетам с клиентами.
//	ВыборОснованияПлатежа - Булево - Выбор основания платежа, а не обьъекта расчетов.
//	ОтборПоОрганизацииИКонтрагенту - Булево - Есть отбор по организации и конрагенту.
//	ИсключитьХозяйственнуюОперацию - Булево - Органичить документы к выбору по хозяйственной операции.
//	ЗапретитьДоговорыПоДокументам - Булево - Запретить договоры с порядком расчетов "по заказам/накладным".
//	УчитыатьФилиалы - Булево - Показывать документы по филиалам организации.
//	РедактируемыйДокумент - ДокументСсылка - Документ из которого вызывается выбор документа расчетов.
//
Функция ПараметрыВыбораДокументаРасчетов() Экспорт
	
	ПараметрыВыбора = Новый Структура;
	ПараметрыВыбора.Вставить("ЭтоРасчетыСКлиентами",           Ложь);
	ПараметрыВыбора.Вставить("ВыборОснованияПлатежа",          Ложь);
	ПараметрыВыбора.Вставить("ИсключитьХозяйственнуюОперацию", Ложь);
	ПараметрыВыбора.Вставить("ЗапретитьДоговорыПоДокументам",  Ложь);
	ПараметрыВыбора.Вставить("УчитыватьФилиалы",               Истина);
	ПараметрыВыбора.Вставить("РедактируемыйДокумент",          Неопределено);
	ПараметрыВыбора.Вставить("Валюта",                         Неопределено);
	ПараметрыВыбора.Вставить("Сумма",                          0);
	
	
	Возврат ПараметрыВыбора;
	
КонецФункции

// Показывает оповещение пользователю о заполнении номеров ГТД в строках табличной части документа.
//
Процедура ОповеститьОЗаполненииНомеровГТДвТабличнойЧасти(НомерГТД, ЗаполненыНомераГТД) Экспорт
	
	Если ЗаполненыНомераГТД <> Неопределено И ЗаполненыНомераГТД Тогда
		Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='В строках документа заполнен номер ГТД %1'"),
			Строка(НомерГТД));
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Номера ГТД заполнены'"),
			,
			Текст,
			БиблиотекаКартинок.Информация32);
	Иначе
		Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Ни в одной строке номер ГТД не заполнен'"),
			Строка(НомерГТД));
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Номера ГТД не заполнены'"),
			,
			Текст,
			БиблиотекаКартинок.Информация32);
	КонецЕсли;
	
КонецПроцедуры

// Процедура обработки события "ПриНачалеРедактирования" табличной части "РасшифровкаПлатежа".
//
Процедура РасшифровкаПлатежаПриНачалеРедактирования(
	Объект,
	Партнер,
	ДоговорКонтрагента,
	СтрокаТаблицы,
	НоваяСтрока,
	Копирование,
	СтатьяДвиженияДенежныхСредств = Неопределено) Экспорт
	
	ЭтоРасчетыСКлиентами = ЭтоРасчетыСКлиентами(Объект.ХозяйственнаяОперация);
	
	УстановитьПустуюСсылкуНаЗаказ(
		СтрокаТаблицы.Заказ,
		ЭтоРасчетыСКлиентами);
	
	Если СтрокаТаблицы.Свойство("ОснованиеПлатежа") Тогда
		УстановитьПустуюСсылкуНаЗаказ(
			СтрокаТаблицы.ОснованиеПлатежа,
			ЭтоРасчетыСКлиентами);
	КонецЕсли;
	
	Если НоваяСтрока Тогда
		
		Если Копирование Тогда
			
			СуммаОстаток = Объект.СуммаДокумента - Объект.РасшифровкаПлатежа.Итог("Сумма")
				+ Объект.РасшифровкаПлатежа[Объект.РасшифровкаПлатежа.Количество()-1].Сумма;
			
		Иначе
			
			СуммаОстаток = Объект.СуммаДокумента - Объект.РасшифровкаПлатежа.Итог("Сумма");
			
			Если ЗначениеЗаполнено(Партнер) Тогда
				СтрокаТаблицы.Партнер = Партнер;
			КонецЕсли;
			
			Если ЗначениеЗаполнено(ДоговорКонтрагента) Тогда
				СтрокаТаблицы.Заказ = ДоговорКонтрагента;
				Если СтрокаТаблицы.Свойство("ОснованиеПлатежа") Тогда
					СтрокаТаблицы.ОснованиеПлатежа = ДоговорКонтрагента;
				КонецЕсли;
				Если ЗначениеЗаполнено(СтатьяДвиженияДенежныхСредств) Тогда
					СтрокаТаблицы.СтатьяДвиженияДенежныхСредств = СтатьяДвиженияДенежныхСредств;
				КонецЕсли;
			КонецЕсли;
			
		КонецЕсли;
		
		СтрокаТаблицы.Сумма = СуммаОстаток;
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик события "ПриИзменении" поля "СтатьяДоходов".
//
Процедура СтатьяДоходовПриИзменении(Объект, Элементы) Экспорт
	
	Элементы.АналитикаДоходов.ТолькоПросмотр = Не ЗначениеЗаполнено(Объект.СтатьяДоходов);
	
	Если Не ЗначениеЗаполнено(Объект.СтатьяДоходов) Тогда
		Объект.АналитикаДоходов = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик события "ПриИзменении" поля "СтатьяРасходов".
//
Процедура СтатьяРасходовПриИзменении(Объект, Элементы) Экспорт
	
	Элементы.АналитикаРасходов.ТолькоПросмотр = Не ЗначениеЗаполнено(Объект.СтатьяРасходов);
	
	Если Не ЗначениеЗаполнено(Объект.СтатьяРасходов) Тогда
		Объект.АналитикаРасходов = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
