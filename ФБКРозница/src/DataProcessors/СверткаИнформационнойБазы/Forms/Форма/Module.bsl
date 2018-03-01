
&НаКлиенте
Перем ВыполняетсяЗакрытие;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	//Проверка прав - на всякий случай
	Если НЕ Пользователи.ЭтоПолноправныйПользователь() Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Недостаточно прав для выполнения операции'"));
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Картинки = Новый Структура;
	Картинки.Вставить("Картинка1",   Новый Картинка);
	Картинки.Вставить("Картинка2",   БиблиотекаКартинок.ДлительнаяОперация48);
	Картинки.Вставить("Картинка3",   БиблиотекаКартинок.ЗеленаяГалка);
	Картинки.Вставить("Картинка4",   БиблиотекаКартинок.Ошибка32);

	СтруктураПараметрыСверткиХранилище = Константы.ПараметрыСверткиИБ.Получить();
	СтруктураПараметрыСвертки = СтруктураПараметрыСверткиХранилище.Получить();
	Если ТипЗнч(СтруктураПараметрыСвертки) = Тип("Структура") Тогда
		Если СтруктураПараметрыСвертки.Свойство("ДатаСверткиИБ") Тогда
			Объект.ДатаСверткиИБ = СтруктураПараметрыСвертки.ДатаСверткиИБ;
		КонецЕсли;
		Если СтруктураПараметрыСвертки.Свойство("ЭтапСверткиЗапущен") Тогда
			ЭтапСверткиЗапущен = СтруктураПараметрыСвертки.ЭтапСверткиЗапущен;
		КонецЕсли;
		Если СтруктураПараметрыСвертки.Свойство("ЭтапСверткиЗавершен") Тогда
			ЭтапСверткиЗавершен = СтруктураПараметрыСвертки.ЭтапСверткиЗавершен;
		КонецЕсли;
		Если СтруктураПараметрыСвертки.Свойство("ИзмененыДокументы") Тогда
			ИзмененыДокументы = СтруктураПараметрыСвертки.ИзмененыДокументы;
		КонецЕсли;
	КонецЕсли;
	УстановитьВидимостьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// Устанавливаем текущую таблицу переходов
	ТаблицаПереходовПоСценарию();
	// Позиционируемся на первом шаге помощника
	УстановитьПорядковыйНомерПерехода(1);

	Если ЭтапСверткиЗапущен > 0 Тогда
		РежимСвертки = 1;
		ВыполняетсяОткрытиеФормы = Истина;
		УстановитьПорядковыйНомерПерехода(3);
		ВыполняетсяОткрытиеФормы = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если НЕ (ЗавершениеРаботы ИЛИ ВыполняетсяЗакрытие) Тогда
		
		НСтрока = НСтр("ru = 'Завершить работу с помощником?'");
		
		Отказ = Истина;
		ПоказатьВопрос(Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект), НСтрока, РежимДиалогаВопрос.ДаНет, ,КодВозвратаДиалога.Нет);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Ответ = РезультатВопроса;
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ВыполняетсяЗакрытие = Истина;
		Закрыть();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДекорацияРезервнаяКопияНажатие(Элемент)
	//Резервная копия ИБ
	ОткрытьФорму("Обработка.РезервноеКопированиеИБ.Форма");
КонецПроцедуры 

&НаКлиенте
Процедура ДекорацияГиперссылкаОграниченияНажатие(Элемент)
	Массив = Новый Массив;
	Массив.Добавить(ПредопределенноеЗначение("Документ.ВводОстатков.ПустаяСсылка"));
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
			"Обработка.СверткаИнформационнойБазы",
			"ОграниченияСвертки",
			Массив,
			ЭтаФорма,
			Новый Структура("ДатаСверткиИБ", Объект.ДатаСверткиИБ));
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияДокументыВводаОстатковНажатие(Элемент)
	ОткрытьФорму("Документ.ВводОстатков.ФормаСписка");
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияЖурналРегистрацииНажатие(Элемент)
	ОткрытьФорму("Обработка.ЖурналРегистрации.Форма", Новый Структура("СобытиеЖурналаРегистрации", НСтр("ru='СверткаИБ'")));
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияУдалениеПомеченныхОбъектовНажатие(Элемент)
	ОткрытьФорму("Обработка.УдалениеПомеченныхОбъектов.Форма");
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияУдалениеНеиспользуемыхЭлементовНажатие(Элемент)
	ОткрытьФорму("Обработка.УдалениеНеиспользуемыхЭлементовСправочников.Форма");
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаДалее(Команда)
	Если Элементы.ПанельОсновная.ТекущаяСтраница = Элементы.СтраницаСостояниеСвертки 
		И ЭтапСверткиЗавершен <> 3  Тогда
			Отказ = Ложь;
			ПередНачаломСвертки();
			ПодключитьОбработчикОжидания("ОбработчикОжиданияСвертка", 0.1, Истина);
		Возврат;
	КонецЕсли;
	
	ИзменитьПорядковыйНомерПерехода(+1);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаНазад(Команда)
	
	ИзменитьПорядковыйНомерПерехода(-1);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаГотово(Команда)
	//Очистить константу
	ЗаполнитьПараметрыСвертки("", Неопределено);
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	ЗаполнитьПараметрыСвертки("ДатаСверткиИБ", Объект.ДатаСверткиИБ);
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура НастройкиСинхронизацииДанных(Команда)
	ОткрытьФорму("ОбщаяФорма.СинхронизацияДанных", , ЭтаФорма);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область РазделИнициализацииПереходовПомощника

// Процедура определяет таблицу переходов по сценарию №1.
// Для заполнения таблицы переходов используется процедура ТаблицаПереходовНоваяСтрока()
//
&НаКлиенте
Процедура ТаблицаПереходовПоСценарию()
	
	ТаблицаПереходов.Очистить();
	
	ТаблицаПереходовНоваяСтрока(1, "СтраницаПриветствие", "СтраницаНавигацииНачало",, 
								"СтраницаПриветствие_ПриОткрытии", "СтраницаПриветствие_ПриПереходеДалее");
	ТаблицаПереходовНоваяСтрока(2, "СтраницаРежимСвертки", "СтраницаНавигацииРежимСвертки",,
								"СтраницаРежимСвертки_ПриОткрытии", "СтраницаРежимСвертки_ПриПереходеДалее");
	ТаблицаПереходовНоваяСтрока(3, "СтраницаСостояниеСвертки", "СтраницаНавигацииОжидание",,
								"СтраницаОжидания_ПриОткрытии", );
	ТаблицаПереходовНоваяСтрока(4, "СтраницаЗавершение", "СтраницаНавигацииОкончание",,
								"СтраницаЗавершение_ПриОткрытии");
	
КонецПроцедуры

// Добавляет новую строку в конец текущей таблицы переходов
//
// Параметры:
//
//  ПорядковыйНомерПерехода (обязательный) – Число. Порядковый номер перехода, который соответствует текущему шагу перехода
//  ИмяОсновнойСтраницы (обязательный) – Строка. Имя страницы панели "ПанельОсновная", которая соответствует текущему номеру перехода
//  ИмяСтраницыНавигации (обязательный) – Строка. Имя страницы панели "ПанельНавигации", которая соответствует текущему номеру перехода
//  ИмяСтраницыДекорации (необязательный) – Строка. Имя страницы панели "ПанельДекорации", которая соответствует текущему номеру перехода
//  ИмяОбработчикаПриОткрытии (необязательный) – Строка. Имя функции-обработчика события открытия текущей страницы помощника
//  ИмяОбработчикаПриПереходеДалее (необязательный) – Строка. Имя функции-обработчика события перехода на следующую страницу помощника
//  ИмяОбработчикаПриПереходеНазад (необязательный) – Строка. Имя функции-обработчика события перехода на предыдущую страницу помощника
// 
&НаСервере
Процедура ТаблицаПереходовНоваяСтрока(ПорядковыйНомерПерехода,
									ИмяОсновнойСтраницы,
									ИмяСтраницыНавигации,
									ИмяСтраницыДекорации = "",
									ИмяОбработчикаПриОткрытии = "",
									ИмяОбработчикаПриПереходеДалее = "",
									ИмяОбработчикаПриПереходеНазад = ""
									)
	//
	НоваяСтрока = ТаблицаПереходов.Добавить();
	
	НоваяСтрока.ПорядковыйНомерПерехода = ПорядковыйНомерПерехода;
	НоваяСтрока.ИмяОсновнойСтраницы     = ИмяОсновнойСтраницы;
	НоваяСтрока.ИмяСтраницыНавигации    = ИмяСтраницыНавигации;
	
	НоваяСтрока.ИмяОбработчикаПриПереходеДалее = ИмяОбработчикаПриПереходеДалее;
	НоваяСтрока.ИмяОбработчикаПриПереходеНазад = ИмяОбработчикаПриПереходеНазад;
	НоваяСтрока.ИмяОбработчикаПриОткрытии      = ИмяОбработчикаПриОткрытии;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьПорядковыйНомерПерехода(Итератор)
	
	ОчиститьСообщения();
	УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + Итератор);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПорядковыйНомерПерехода(Знач Значение)
	
	ЭтоПереходДалее = (Значение > ПорядковыйНомерПерехода);
	ПорядковыйНомерПерехода = Значение;
	Если ПорядковыйНомерПерехода < 0 Тогда
		ПорядковыйНомерПерехода = 0;
	КонецЕсли;
	ПорядковыйНомерПереходаПриИзменении(ЭтоПереходДалее);
	
КонецПроцедуры

&НаКлиенте
Процедура ПорядковыйНомерПереходаПриИзменении(Знач ЭтоПереходДалее)
	
	// Обработчики событий переходов
	Если ЭтоПереходДалее Тогда
		
		СтрокиПерехода = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода - 1));
		
		Если СтрокиПерехода.Количество() = 0 Тогда
			Возврат;
		КонецЕсли;
		
		СтрокаПерехода = СтрокиПерехода[0];
		
		// обработчик ПриПереходеДалее
		Если Не ПустаяСтрока(СтрокаПерехода.ИмяОбработчикаПриПереходеДалее) Тогда
			
			ИмяПроцедуры = "Подключаемый_[ИмяОбработчика](Отказ)";
			ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПерехода.ИмяОбработчикаПриПереходеДалее);
			
			Отказ = Ложь;
			
			Попытка
				Выполнить(ИмяПроцедуры);
			Исключение
			КонецПопытки;
			
			Если Отказ Тогда
				УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
				Возврат;
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		СтрокиПерехода = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода + 1));
		
		Если СтрокиПерехода.Количество() = 0 Тогда
			Возврат;
		КонецЕсли;
		
		СтрокаПерехода = СтрокиПерехода[0];
		
		// обработчик ПриПереходеНазад
		Если Не ПустаяСтрока(СтрокаПерехода.ИмяОбработчикаПриПереходеНазад) Тогда
			
			ИмяПроцедуры = "Подключаемый_[ИмяОбработчика](Отказ)";
			ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПерехода.ИмяОбработчикаПриПереходеНазад);
			
			Отказ = Ложь;
			
			Попытка
				Выполнить(ИмяПроцедуры);
			Исключение
			КонецПопытки;
			
			Если Отказ Тогда
				УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + 1);
				Возврат;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	СтрокиПереходаТекущие = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода));
	
	Если СтрокиПереходаТекущие.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаПереходаТекущая = СтрокиПереходаТекущие[0];
	
	// обработчик ПриОткрытии
	Если Не ПустаяСтрока(СтрокаПереходаТекущая.ИмяОбработчикаПриОткрытии) Тогда
		
		ИмяПроцедуры = "Подключаемый_[ИмяОбработчика](Отказ, ПропуститьСтраницу, ЭтоПереходДалее)";
		ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПереходаТекущая.ИмяОбработчикаПриОткрытии);
		
		Отказ = Ложь;
		ПропуститьСтраницу = Ложь;
		
		Попытка
			Выполнить(ИмяПроцедуры);
		Исключение
			Сообщить(ОписаниеОшибки());
		КонецПопытки;
		
		Если Отказ Тогда
			УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
			Возврат;
		ИначеЕсли ПропуститьСтраницу Тогда
			Если ЭтоПереходДалее Тогда
				УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + 1);
				Возврат;
			Иначе
				УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
				Возврат;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	// Установка отображения текущей страницы
	Элементы.ПанельОсновная.ТекущаяСтраница  = Элементы[СтрокаПереходаТекущая.ИмяОсновнойСтраницы];
	Элементы.ПанельНавигации.ТекущаяСтраница = Элементы[СтрокаПереходаТекущая.ИмяСтраницыНавигации];
	
КонецПроцедуры

#КонецОбласти

#Область РазделОбработчиковСобытийПерехода

// Обработчик выполняется при открытии страницы помощника "СтраницаПриветствие"
//
// Параметры:
//
//Отказ – Булево – флаг отказа от открытия страницы;
//			если в обработчике поднять этот флаг, то переход на страницу выполнен не будет,
//			останется открытой предыдущая страница помощника согласно направлению перехода (вперед или назад)
//
//ПропуститьСтраницу – Булево. Если поднять этот флаг, то страница будет пропущена
//			и управление перейдет на следующую страницу помощника согласно направлению перехода (вперед или назад)
//
//ЭтоПереходДалее (только чтение) – Булево – флаг определяет направление перехода.
//			Истина – выполняется переход далее; Ложь – выполняется переход назад
&НаКлиенте
Процедура Подключаемый_СтраницаПриветствие_ПриОткрытии(Отказ, ПропуститьСтраницу, Знач ЭтоПереходДалее)
	Элементы.КомандаДалее.КнопкаПоУмолчанию = Истина;
КонецПроцедуры

// Обработчик перехода далее (на следующую страницу) при уходе со страницы помощника "СтраницаПриветствие"
//
// Параметры:
// Отказ – Булево – флаг отказа от выполнения перехода далее;
//					если в обработчике поднять этот флаг, то переход на следующую страницу выполнен не будет.
//
&НаКлиенте
Процедура Подключаемый_СтраницаПриветствие_ПриПереходеДалее(Отказ)
	
	ОчиститьСообщения();
	
	Если НЕ ЗначениеЗаполнено(Объект.ДатаСверткиИБ) ТОгда
		ТекстСообщения = НСтр("ru = 'Поле ""Дата свертки"" не заполнено'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,"ДатаСверткиИБ", "Объект.ДатаСверткиИБ", Отказ);
		Возврат;
	КонецЕсли;
КонецПроцедуры

// Обработчик выполняется при открытии страницы помощника "РежимСвертки"
//
// Параметры:
//
//  Отказ – Булево – флаг отказа от открытия страницы;
//			если в обработчике поднять этот флаг, то переход на страницу выполнен не будет,
//			останется открытой предыдущая страница помощника согласно направлению перехода (вперед или назад)
//
//  ПропуститьСтраницу – Булево. Если поднять этот флаг, то страница будет пропущена
//			и управление перейдет на следующую страницу помощника согласно направлению перехода (вперед или назад)
//
//  ЭтоПереходДалее (только чтение) – Булево – флаг определяет направление перехода.
//			Истина – выполняется переход далее; Ложь – выполняется переход назад.
//
&НаКлиенте
Процедура Подключаемый_СтраницаРежимСвертки_ПриОткрытии(Отказ, ПропуститьСтраницу, Знач ЭтоПереходДалее)
	Элементы.КомандаДалее4.КнопкаПоУмолчанию = Истина;
	//Проверка на наличие ограничений свертки
	ЕстьОграничения = ЕстьОграниченияСвертки();
	Элементы.ГруппаОграничения.Видимость = ЕстьОграничения;
	Элементы.ПредупреждениеОтступ.Видимость = ЕстьОграничения;
КонецПроцедуры

// Обработчик перехода далее (на следующую страницу) при уходе со страницы помощника "РежимСвертки"
//
// Параметры:
// Отказ – Булево – флаг отказа от выполнения перехода далее;
//					если в обработчике поднять этот флаг, то переход на следующую страницу выполнен не будет.
//
&НаКлиенте
Процедура Подключаемый_СтраницаРежимСвертки_ПриПереходеДалее(Отказ)
	ИзменитьДатуНачалаВыгрузкиДокументов(Отказ);
КонецПроцедуры

// Обработчик выполняется при открытии страницы помощника "СтраницаЗавершение"
//
// Параметры:
//
//  Отказ – Булево – флаг отказа от открытия страницы;
//			если в обработчике поднять этот флаг, то переход на страницу выполнен не будет,
//			останется открытой предыдущая страница помощника согласно направлению перехода (вперед или назад)
//
//  ПропуститьСтраницу – Булево. Если поднять этот флаг, то страница будет пропущена
//			и управление перейдет на следующую страницу помощника согласно направлению перехода (вперед или назад)
//
//  ЭтоПереходДалее (только чтение) – Булево – флаг определяет направление перехода.
//			Истина – выполняется переход далее; Ложь – выполняется переход назад.
//
&НаКлиенте
Процедура Подключаемый_СтраницаЗавершение_ПриОткрытии(Отказ, ПропуститьСтраницу, Знач ЭтоПереходДалее)
	Элементы.НадписьПовторноеОткрытиеФормы.Видимость = Ложь;
	Элементы.НадписьГотово.Видимость = Истина;
	Элементы.КомандаГотово.КнопкаПоУмолчанию = Истина;
КонецПроцедуры

// Обработчик выполняется при открытии страницы помощника "СтраницаОжидания"
//
// Параметры:
// Отказ – Булево – флаг отказа от выполнения перехода далее;
//					если в обработчике поднять этот флаг, то переход на следующую страницу выполнен не будет.
//
&НаКлиенте
Процедура Подключаемый_СтраницаОжидания_ПриОткрытии(Отказ, ПропуститьСтраницу, Знач ЭтоПереходДалее)
	Если ЭтапСверткиЗапущен = 3 И ЭтапСверткиЗавершен = 3 Тогда
		//Все сделали
		ПропуститьСтраницу = Истина;
		Возврат;
	КонецЕсли;
	Элементы.ГруппаПродолжениеСвертки.Видимость = Ложь;

	Элементы.КомандаДалее3.КнопкаПоУмолчанию = Истина;
	//Прорисовать состояние свертки	
	ОтобразитьСостояниеСвертки();

	ФлЗапуститьСвертку = Истина;
	Если ВыполняетсяОткрытиеФормы Тогда
		Элементы.ГруппаПродолжениеСвертки.Видимость = Истина;
		Элементы.СтраницыПереключаемые.ТекущаяСтраница = Элементы.СтраницаПроцессОстановлен;
		Элементы.НадписьПовторноеОткрытиеФормы.Видимость = ?(РежимСвертки = 1, Истина, Ложь);
		
		ФлЗапуститьСвертку = Ложь;
	КонецЕсли;
	//Проверим текущее состояние
	Если ЭтапСверткиЗапущен > ЭтапСверткиЗавершен Тогда
		ФлЗапуститьСвертку = Ложь;
		Если РежимСвертки = 0 Тогда
			РежимСвертки = 1;
		КонецЕсли;
		
		ВключитьКартинкуЭтапа(ЭтапСверткиЗапущен,4);
		Элементы.СтраницыПереключаемые.ТекущаяСтраница = Элементы.СтраницаВозниклиОшибки;
		Элементы.ДекорацияВозниклиОшибки2.Видимость = Истина;
		Элементы.ДекорацияВозниклиОшибки3.Видимость = Ложь;
		//Были ошибки. Надо проверить можно ли сворачивать дальше
		//Этапы 2 и 3 можно продолжать без проблем
		//Для этапа 1 нужны специальные проверки
		Если ЭтапСверткиЗапущен = 1 Тогда
			Если ИзмененыДокументы Тогда
				Элементы.ДекорацияВозниклиОшибки2.Видимость = Ложь;
				Элементы.ДекорацияВозниклиОшибки3.Видимость = Истина;
				//Блокируем кнопку Далее
				Элементы.КомандаДалее3.Доступность = Ложь;
			Иначе
				ЭтапСверткиЗапущен = 0;
				УдалитьДокументыВводаОстатков = Истина;
			КонецЕсли;
		Иначе
			ЭтапСверткиЗапущен = ЭтапСверткиЗапущен - 1;
		КонецЕсли;
	КонецЕсли;

	Если НЕ ФлЗапуститьСвертку Тогда
		Возврат;
	КонецЕсли;
	ПередНачаломСвертки();
	
	ПодключитьОбработчикОжидания("ОбработчикОжиданияСвертка", 0.1, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ПроцедурыСвязанныеСОбменамиДанными

&НаСервере
Процедура ИзменитьДатуНачалаВыгрузкиДокументов(Отказ)
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьСинхронизациюДанных") Тогда
		Возврат;
	КонецЕсли;
	УстановитьПривилегированныйРежим(Истина);

	Запрос = Новый Запрос("
			|ВЫБРАТЬ
			|	РТ1.Ссылка,
			|	РТ1.ДатаНачалаВыгрузкиДокументов,
			|	РТ1.ПометкаУдаления
			|ПОМЕСТИТЬ УзлыОбмена
			|ИЗ
			|	ПланОбмена.ОбменУправлениеТорговлей_11_0_РозничнаяТорговля_1_0 КАК РТ1
			|ГДЕ
			|	РТ1.Ссылка <> &ЭтотУзелРТ1
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	БП2.Ссылка,
			|	БП2.ДатаНачалаВыгрузкиДокументов,
			|	БП2.ПометкаУдаления
			|ИЗ
			|	ПланОбмена.ОбменУправлениеТорговлейБухгалтерияПредприятия КАК БП2
			|ГДЕ
			|	БП2.Ссылка <> &ЭтотУзелБП2
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	БП3.Ссылка,
			|	БП3.ДатаНачалаВыгрузкиДокументов,
			|	БП3.ПометкаУдаления
			|ИЗ
			|	ПланОбмена.ОбменУправлениеТорговлейБухгалтерияПредприятия30 КАК БП3
			|ГДЕ
			|	БП3.Ссылка <> &ЭтотУзелБП3
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	БП2КОРП.Ссылка,
			|	БП2КОРП.ДатаНачалаВыгрузкиДокументов,
			|	БП2КОРП.ПометкаУдаления
			|ИЗ
			|	ПланОбмена.ОбменУправлениеТорговлейБухгалтерияПредприятияКОРП КАК БП2КОРП
			|ГДЕ
			|	БП2КОРП.Ссылка <> &ЭтотУзелБП2КОРП
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	РТ2.Ссылка,
			|	РТ2.ДатаНачалаВыгрузкиДокументов,
			|	РТ2.ПометкаУдаления
			|ИЗ
			|	ПланОбмена.ОбменУправлениеТорговлейРозница КАК РТ2
			|ГДЕ
			|	РТ2.Ссылка <> &ЭтотУзелРТ2
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	УзлыОбмена.Ссылка
			|ИЗ
			|	УзлыОбмена КАК УзлыОбмена
			|ГДЕ
			|	УзлыОбмена.ДатаНачалаВыгрузкиДокументов <= &ДатаСвертки");
			
	Запрос.УстановитьПараметр("ДатаСвертки",     Объект.ДатаСверткиИБ);
	Запрос.УстановитьПараметр("ЭтотУзелРТ1",     ПланыОбмена.ОбменУправлениеТорговлей_11_0_РозничнаяТорговля_1_0.ЭтотУзел());
	Запрос.УстановитьПараметр("ЭтотУзелБП2",     ПланыОбмена.ОбменУправлениеТорговлейБухгалтерияПредприятия.ЭтотУзел());
	Запрос.УстановитьПараметр("ЭтотУзелБП3",     ПланыОбмена.ОбменУправлениеТорговлейБухгалтерияПредприятия30.ЭтотУзел());
	Запрос.УстановитьПараметр("ЭтотУзелБП2КОРП", ПланыОбмена.ОбменУправлениеТорговлейБухгалтерияПредприятияКОРП.ЭтотУзел());
	Запрос.УстановитьПараметр("ЭтотУзелРТ2",     ПланыОбмена.ОбменУправлениеТорговлейРозница.ЭтотУзел());
	
	ВыборкаУзлов = Запрос.Выполнить().Выбрать();
	Пока ВыборкаУзлов.Следующий() Цикл
		
		Попытка
			ЗаблокироватьДанныеДляРедактирования(ВыборкаУзлов.Ссылка);
		Исключение
			
			ТекстОшибки = НСтр("ru='Не удалось заблокировать %Элемент%. %ОписаниеОшибки%'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Элемент%",        ВыборкаУзлов.Ссылка);
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ОписаниеОшибки%", КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки,,,,Отказ);
			
		КонецПопытки;
		
		Если Отказ Тогда
			УстановитьПривилегированныйРежим(Ложь);

			Возврат;
		КонецЕсли;
		
		УзелОбмена = ВыборкаУзлов.Ссылка.ПолучитьОбъект();
		УзелОбмена.ДатаНачалаВыгрузкиДокументов = Объект.ДатаСверткиИБ + 1*3600*24;
		
		Попытка
			
			УзелОбмена.ДополнительныеСвойства.Вставить("Загрузка", Истина);
			УзелОбмена.Записать();
			
		Исключение
			
			ТекстОшибки = НСтр("ru='Не удалось записать %Элемент%. %ОписаниеОшибки%'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Элемент%",        ВыборкаУзлов.Ссылка);
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ОписаниеОшибки%", КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки,,,,Отказ);
			
		КонецПопытки
		
	КонецЦикла;
	УстановитьПривилегированныйРежим(Ложь);

КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьНаСервере()
	ЗначениеВидимости = ПолучитьФункциональнуюОпцию("ИспользоватьСинхронизациюДанных");
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"СинхронизацияДанных",
		"Видимость",
		ЗначениеВидимости);
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"НадписьПовторноеОткрытиеФормы",
		"Видимость",
		Ложь);
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"НадписьГотово",
		"Видимость",
		Ложь);

КонецПроцедуры	

#КонецОбласти

#Область ПроцедурыСвязанныеСВыполнениемСвертки

&НаКлиенте
Процедура ПередНачаломСвертки()
	Если ЭтапСверткиЗавершен = 3 Тогда
		Возврат;
	КонецЕсли;
	Элементы.СтраницыПереключаемые.ТекущаяСтраница = Элементы.СтраницаИдетСвертка;
	Элементы.НадписьПовторноеОткрытиеФормы.Видимость = Ложь;
	Если РежимСвертки = 0 Тогда
		Элементы.КомандаДалее3.Видимость = Ложь;
	Иначе
		Элементы.КомандаДалее3.Доступность = Ложь;
	КонецЕсли;
	Элементы.КомандаОтмена3.Доступность = Ложь;
	ОтобразитьСостояниеСвертки();
	
	//Определить текущий этап
	Если ЭтапСверткиЗапущен = 0 Тогда
		ЭтапСверткиЗапущен = 1;
	ИначеЕсли ЭтапСверткиЗапущен = ЭтапСверткиЗавершен Тогда
		ЭтапСверткиЗапущен = ЭтапСверткиЗапущен + 1;
	КонецЕсли;
	ОтобразитьСостояниеСвертки();

КонецПроцедуры

&НаКлиенте
Процедура ОбработчикОжиданияСвертка()
	ЗапуститьСледующийЭтапСвертки();
	
	Элементы.СтраницыПереключаемые.ТекущаяСтраница = Элементы.СтраницаПроцессОстановлен;
	Элементы.НадписьПовторноеОткрытиеФормы.Видимость = ?(РежимСвертки = 1, Истина, Ложь);

	Если РежимСвертки = 1 Тогда
		Элементы.КомандаДалее3.Доступность = Истина;
	КонецЕсли;
	Элементы.КомандаОтмена3.Доступность = Истина;
	Элементы.Справка3.Доступность = Истина;

	Если ЭтапСверткиЗавершен = 3 Тогда
		КомандаДалее(Неопределено);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапуститьСледующийЭтапСвертки()
	Если ЭтапСверткиЗавершен = 3 Тогда
		Возврат;
	КонецЕсли;
	ОтобразитьСостояниеСвертки();

	Если РежимСвертки = 0 И ЭтапСверткиЗапущен = 1 Тогда
		//последовательное выполнение этапов
		Для счЭт=1 По 3 цикл
			ЭтапСверткиЗапущен = СчЭт;
			ОтобразитьСостояниеСвертки();
			ВыполнитьЭтапСвертки(ЭтапСверткиЗапущен);
		КонецЦикла;
	Иначе
		ВыполнитьЭтапСвертки(ЭтапСверткиЗапущен);
	КонецЕсли;  
	ОтобразитьСостояниеСвертки();

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПараметрыСвертки(ИмяПараметра, ЗначениеПараметра)
	Если ИмяПараметра = "" Тогда
		//Очистка
		Константы.ПараметрыСверткиИБ.Установить(Неопределено);
		Возврат;
	КонецЕсли;
	
	СтруктураПараметрыСвертки = Константы.ПараметрыСверткиИБ.Получить().Получить();
	Если ТипЗнч(СтруктураПараметрыСвертки) <> Тип("Структура") Тогда
		СтруктураПараметрыСвертки = Новый Структура;
	ИначеЕсли СтруктураПараметрыСвертки.Свойство(ИмяПараметра) Тогда
		//Возможно, уже установлено (так может быть с датой свертки)
		Если СтруктураПараметрыСвертки[ИмяПараметра] = ЗначениеПараметра Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	СтруктураПараметрыСвертки.Вставить(ИмяПараметра, ЗначениеПараметра);
	СтруктураПараметрыСверткиХранилище = Новый ХранилищеЗначения(СтруктураПараметрыСвертки);
	Константы.ПараметрыСверткиИБ.Установить(СтруктураПараметрыСверткиХранилище);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьЭтапСвертки(НомерЭтапа)
	УстановитьПривилегированныйРежим(Истина);

	ЗаполнитьПараметрыСвертки("ЭтапСверткиЗапущен", НомерЭтапа);
	
	ОтчетОбъект = РеквизитФормыВЗначение("Объект");
	Если НомерЭтапа = 1 Тогда
		//На первом этапе запоминаем дату свертки
		ЗаполнитьПараметрыСвертки("ДатаСверткиИБ", Объект.ДатаСверткиИБ);
		ОтчетОбъект.СформироватьДокументыВводаОстатков(УдалитьДокументыВводаОстатков);
	ИначеЕсли НомерЭтапа = 2 Тогда
		ОтчетОбъект.УдалитьДвиженияПоДатуСвертки()
	ИначеЕсли НомерЭтапа = 3 Тогда
		ОтчетОбъект.ПровестиДокументыВводаОстатков();
	КонецЕсли;
	ЭтапСверткиЗавершен = НомерЭтапа;
	ЗаполнитьПараметрыСвертки("ЭтапСверткиЗавершен", ЭтапСверткиЗавершен);
	УстановитьПривилегированныйРежим(Ложь);
КонецПроцедуры

#КонецОбласти

#Область ОграниченияСвертки

&НаСервере
Функция ЕстьОграниченияСвертки()
	ДанныеОбОграничениях = Обработки.СверткаИнформационнойБазы.ПолучитьИсходныеДанныеОбОграниченияхСвертки(Объект.ДатаСверткиИБ, Ложь);
	Возврат ДанныеОбОграничениях.ЕстьОграничения;
КонецФункции

#КонецОбласти

#Область Прочее

&НаКлиенте
Процедура ОтобразитьСостояниеСвертки()
	Для сч = ЭтапСверткиЗавершен+1 По 3 Цикл
		ВключитьКартинкуЭтапа(Сч,1);
	КонецЦикла;
	
	Если ЭтапСверткиЗавершен > 0 Тогда
		Для сч=1 По ЭтапСверткиЗавершен Цикл
			ВключитьКартинкуЭтапа(Сч,3);
		КонецЦикла;
	КонецЕсли;
	Если ЭтапСверткиЗапущен > ЭтапСверткиЗавершен Тогда
		ВключитьКартинкуЭтапа(ЭтапСверткиЗапущен,2);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВключитьКартинкуЭтапа(НомерЭтапа,НомерКартинки)
	Элементы["ГруппаЭтап"+НомерЭтапа].ПодчиненныеЭлементы["КартинкаЭтап"+НомерЭтапа].Картинка = Картинки["Картинка"+НомерКартинки];
КонецПроцедуры

#КонецОбласти

#КонецОбласти

ВыполняетсяЗакрытие = Ложь;