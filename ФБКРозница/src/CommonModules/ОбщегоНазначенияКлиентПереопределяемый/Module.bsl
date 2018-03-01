#Область ПрограммныйИнтерфейс

// Выполняется перед интерактивным началом работы пользователя с областью данных или в локальном режиме.
// Соответствует обработчику ПередНачаломРаботыСистемы.
//
// Параметры:
//  Параметры - Структура - структура со свойствами:
//   * Отказ         - Булево - Возвращаемое значение. Если установить Истина, то работа программы будет прекращена.
//   * Перезапустить - Булево - Возвращаемое значение. Если установить Истина, и параметр Отказ тоже установлен
//                              в Истина, то выполняется перезапуск программы.
// 
//   * ДополнительныеПараметрыКоманднойСтроки - Строка - Возвращаемое значение. Имеет смысл, когда Отказ
//                              и Перезапустить установлены Истина.
//
//   * ИнтерактивнаяОбработка - ОписаниеОповещения - Возвращаемое значение. Для открытия окна, блокирующего вход в
//                              программу, следует присвоить в этот параметр описание обработчика
//                              оповещения, который открывает окно. Смотри пример ниже.
//
//   * ОбработкаПродолжения   - ОписаниеОповещения - если открывается окно, блокирующее вход в программу, то в обработке
//                              закрытия этого окна необходимо выполнить оповещение ОбработкаПродолжения. Смотри пример ниже.
//
//   * Модули                 - Массив - ссылки на модули, в которых нужно вызвать эту же процедуру после возврата.
//                              Модули можно добавлять только в рамках вызова в процедуру переопределяемого модуля.
//                              Используется для упрощения реализации нескольких последовательных асинхронных вызовов
//                              в разные подсистемы. См. пример ИнтеграцияПодсистемБСПКлиент.ПередНачаломРаботыСистемы.
//
// Пример:
//  Следующий код открывает окно, блокирующее вход в программу.
//
//		Если ОткрытьОкноПриЗапуске Тогда
//			Параметры.ИнтерактивнаяОбработка = Новый ОписаниеОповещения("ОткрытьОкно", ЭтотОбъект);
//		КонецЕсли;
//
//	Процедура ОткрытьОкно(Параметры, ДополнительныеПараметры) Экспорт
//		// Показываем окно, по закрытию которого вызывается обработчик оповещения ОткрытьОкноЗавершение.
//		Оповещение = Новый ОписаниеОповещения("ОткрытьОкноЗавершение", ЭтотОбъект, Параметры);
//		Форма = ОткрытьФорму(... ,,, ... Оповещение);
//		Если Не Форма.Открыта() Тогда // Если ПриСозданииНаСервере Отказ установлен Истина.
//			ВыполнитьОбработкуОповещения(Параметры.ОбработкаПродолжения);
//		КонецЕсли;
//	КонецПроцедуры
//
//	Процедура ОткрытьОкноЗавершение(Результат, Параметры) Экспорт
//		...
//		ВыполнитьОбработкуОповещения(Параметры.ОбработкаПродолжения);
//		
//	КонецПроцедуры
//
Процедура ПередНачаломРаботыСистемы(Параметры) Экспорт
	
	//++ НЕ ГИСМ
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске();
	
	Если ПараметрыРаботыКлиента.Свойство("ВозможенЗапускБазовойВерсии")
	 И НЕ ПараметрыРаботыКлиента.ВозможенЗапускБазовойВерсии Тогда
		Параметры.Отказ = Истина;
		ВызватьИсключение НСтр("ru = 'Базовая версия может использоваться только в файловом однопользовательском режиме.'");
	КонецЕсли;
	
	
	//-- НЕ ГИСМ
	
КонецПроцедуры

// Выполняется при интерактивном начале работы пользователя с областью данных или в локальном режиме.
// Соответствует обработчику ПриНачалеРаботыСистемы.
//
// Параметры:
//  Параметры - Структура - структура со свойствами:
//   * Отказ         - Булево - Возвращаемое значение. Если установить Истина, то работа программы будет прекращена.
//   * Перезапустить - Булево - Возвращаемое значение. Если установить Истина и параметр Отказ тоже установлен
//                              в Истина, то выполняется перезапуск программы.
//
//   * ДополнительныеПараметрыКоманднойСтроки - Строка - Возвращаемое значение. Имеет смысл
//                              когда Отказ и Перезапустить установлены Истина.
//
//   * ИнтерактивнаяОбработка - ОписаниеОповещения - Возвращаемое значение. Для открытия окна, блокирующего вход
//                              в программу, следует присвоить в этот параметр описание обработчика оповещения,
//                              который открывает окно. См. пример в ПередНачаломРаботыСистемы.
//
//   * ОбработкаПродолжения   - ОписаниеОповещения - если открывается окно, блокирующее вход в программу, то в
//                              обработке закрытия этого окна необходимо выполнить оповещение ОбработкаПродолжения.
//                              См. пример в ОбщегоНазначенияКлиентПереопределяемый.ПередНачаломРаботыСистемы.
//
Процедура ПриНачалеРаботыСистемы(Параметры) Экспорт
	
	//++ НЕ ГИСМ
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске();
	
	Если ПараметрыРаботыКлиента.ДоступноИспользованиеРазделенныхДанных Тогда
		
		//РаботаСВнешнимОборудованием
		МенеджерОборудованияКлиент.ПриНачалеРаботыСистемы();
		//Конец РаботаСВнешнимОборудованием
		
		//РаботаСМобильнымиПриложениями
		МобильныеПриложенияКлиент.ПриНачалеРаботыСистемы();
		//Конец РаботаСМобильнымиПриложениями
		
		//ОткрытиеФормПриНачалеРаботыСистемы
		ОткрытиеФормПриНачалеРаботыСистемыКлиент.ПриНачалеРаботыСистемы();
		//Конец ОткрытиеФормПриНачалеРаботыСистемы
		
		#Если НЕ ВебКлиент Тогда
		Если НЕ ПараметрыРаботыКлиента.РазделениеВключено
			И ПараметрыРаботыКлиента.ЭтоГлавныйУзел Тогда
			// ИнтернетПоддержкаПользователей
			ИнтернетПоддержкаПользователейКлиент.ПриНачалеРаботыСистемы();
			// Конец ИнтернетПоддержкаПользователей
		КонецЕсли;
		#КонецЕсли
		
		
	КонецЕсли;
	//-- НЕ ГИСМ
	
КонецПроцедуры

// Вызывается для обработки собственных параметров запуска программы,
// передаваемых с помощью ключа командной строки /C, например: 1cv8.exe ... /CРежимОтладки;ОткрытьИЗакрыть.
//
// Параметры:
//  ПараметрыЗапуска  - Массив - массив строк разделенных символом ";" в параметре запуска,
//                      переданным в конфигурацию с помощью ключа командной строки /C.
//  Отказ             - Булево - если установить Истина, то запуск будет прерван.
//
Процедура ПриОбработкеПараметровЗапуска(ПараметрыЗапуска, Отказ) Экспорт
	
КонецПроцедуры

// Выполняется при интерактивном начале работы пользователя с областью данных или в локальном режиме.
// Вызывается после завершения действий ПриНачалеРаботыСистемы.
// Используется для подключения обработчиков ожидания, которые не должны вызываться
// в случае интерактивных действий перед и при начале работы системы.
//
// Начальная страница (рабочий стол) в этот момент еще не открыта, поэтому запрещено открывать
// формы напрямую, а следует использовать для этих целей обработчик ожидания.
// Запрещено использовать это событие для интерактивного взаимодействия с пользователем
// (ПоказатьВопрос и аналогичные действия). Для этих целей следует размещать код в процедуре ПриНачалеРаботыСистемы.
//
Процедура ПослеНачалаРаботыСистемы() Экспорт
	
	//++ НЕ ГИСМ
	
	// ЭлектронноеВзаимодействие
	ЭлектронноеВзаимодействиеКлиент.ПослеНачалаРаботыСистемы();
	// Конец ЭлектронноеВзаимодействие
	
	ИнтеграцияЕГАИСКлиент.ПодключитьОбработчикВыполненияОбменаНаКлиентеПоРасписанию();
	//-- НЕ ГИСМ
	
КонецПроцедуры

// Выполняется перед интерактивном завершении работы пользователя с областью данных или в локальном режиме.
// Соответствует обработчику ПередЗавершениемРаботыСистемы.
// Позволяет определить список предупреждений, выводимых пользователю перед завершением работы.
//
// Параметры:
//  Отказ          - Булево - если установить данному параметру значение Истина, то работа с программой не будет 
//                            завершена.
//  Предупреждения - Массив - добавить элементы типа Структура, свойства которой описывают внешний вид предупреждения,
//                            а также дальнейшие действия.
//                            См. описание свойств в СтандартныеПодсистемыКлиент.ПредупреждениеПриЗавершенииРаботы.
//
Процедура ПередЗавершениемРаботыСистемы(Отказ, Предупреждения) Экспорт
	
	//++ НЕ ГИСМ
	
	Если НЕ Отказ Тогда
		
		//РаботаСВнешнимОборудованием
		МенеджерОборудованияКлиент.ПередЗавершениемРаботыСистемы();
		//Конец РаботаСВнешнимОборудованием
		
		Если глКомпонентаОбменаСМобильнымиПриложениями <> Неопределено Тогда
			
			Попытка
				глКомпонентаОбменаСМобильнымиПриложениями.Отключить(0);
			Исключение
				ИмяСобытия = НСтр("ru='Ошибка при отключении компоненты обмена данными'");
				ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(
				ИмяСобытия,
				"Ошибка",
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()),,Истина);
			КонецПопытки;
			
			глКомпонентаОбменаСМобильнымиПриложениями = Неопределено;
			
		КонецЕсли;
		
	КонецЕсли;
	//-- НЕ ГИСМ
	
КонецПроцедуры

// Позволяет переопределить заголовок программы.
//
// Параметры:
//  ЗаголовокПриложения - Строка - текст заголовка программы;
//  ПриЗапуске          - Булево - Истина, если вызывается при начале работы программы.
//                                 В этом случае недопустимо вызывать те серверные функции конфигурации,
//                                 которые рассчитывают на то, что запуск уже полностью завершен. 
//                                 Например, вместо СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента
//                                 следует вызывать СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске. 
//
// Пример:
//  Для того чтобы в начале заголовка программы вывести название текущего проекта, следует определить параметр 
//  ТекущийПроект в процедуре ОбщегоНазначенияПереопределяемый.ПриДобавленииПараметровРаботыКлиента и вписать код:
//
//  Если ПриЗапуске Тогда
//    Возврат;
//  КонецЕсли;
//  ПараметрыКлиента = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента();
//  ТекущийПроект = Неопределено;	
//  Если ПараметрыКлиента.ДоступноИспользованиеРазделенныхДанных И ПараметрыКлиента.Свойство("ТекущийПроект", ТекущийПроект) 
//	  И Не ПараметрыКлиента.ТекущийПроект.Пустая() Тогда
//	  ЗаголовокПриложения = Строка(ПараметрыКлиента.ТекущийПроект) + " / " + ЗаголовокПриложения;
//  КонецЕсли;
//
Процедура ПриУстановкеЗаголовкаКлиентскогоПриложения(ЗаголовокПриложения, ПриЗапуске) Экспорт
	
КонецПроцедуры

#КонецОбласти
