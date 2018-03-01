#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает структуру с именем и праметрами открытия формы
//
// Параметры:
//	ЗадачаСсылка - ЗадачаСсылка.ЗадачаИсполнителя - ссылка на задачу, для которой необходимо получить форму
//	ТочкаМаршрутаСсылка - ТочкаМаршрутаБизнесПроцессаСсылка - ссылка на точку маршрута
//							бизнес-процесса, для которой необходимо получить форму
//
// Возвращаемое значение:
//	Структура - поля ПараметрыФормы, ИмяФормы
//
Функция ФормаВыполненияЗадачи(Знач ЗадачаСсылка, Знач ТочкаМаршрутаСсылка) Экспорт
	
	Если ТочкаМаршрутаСсылка = БизнесПроцессы.СогласованиеЗакупки.ТочкиМаршрута.СогласоватьЛогистическиеУсловия Или
		ТочкаМаршрутаСсылка = БизнесПроцессы.СогласованиеЗакупки.ТочкиМаршрута.СогласоватьФинансовыеУсловия Или
		ТочкаМаршрутаСсылка = БизнесПроцессы.СогласованиеЗакупки.ТочкиМаршрута.СогласоватьЦеновыеУсловия Тогда
		ИмяФормы = "БизнесПроцесс.СогласованиеЗакупки.Форма.ФормаЗадачиРецензента";
	ИначеЕсли ТочкаМаршрутаСсылка = БизнесПроцессы.СогласованиеЗакупки.ТочкиМаршрута.ОзнакомитьсяСРезультатами Тогда
		ИмяФормы = "БизнесПроцесс.СогласованиеЗакупки.Форма.ФормаЗадачиОзнакомиться";
	ИначеЕсли ТочкаМаршрутаСсылка = БизнесПроцессы.СогласованиеЗакупки.ТочкиМаршрута.ПодвестиИтогиСогласования Тогда
		ИмяФормы = "БизнесПроцесс.СогласованиеЗакупки.Форма.ФормаЗадачиПодвестиИтоги";
	КонецЕсли;
		
	Результат = Новый Структура;
	Результат.Вставить("ПараметрыФормы", Новый Структура("Ключ", ЗадачаСсылка));
	Результат.Вставить("ИмяФормы", ИмяФормы);
	
	Возврат Результат;
	
КонецФункции

// Вызывается при выполнении задачи из формы списка
//
// Параметры:
//   ЗадачаСсылка                – ЗадачаСсылка.ЗадачаИсполнителя                        – текущая выполняемая задача.
//   БизнесПроцессСсылка         - БизнесПроцессСсылка.СогласованиеЗакупки               - текущий процесс согласования.
//   ТочкаМаршрутаБизнесПроцесса – ТочкаМаршрутаБизнесПроцессаСсылка - точка маршрута согласования.
//
Процедура ОбработкаВыполненияПоУмолчанию(Знач ЗадачаСсылка, БизнесПроцессСсылка, Знач ТочкаМаршрутаБизнесПроцесса) Экспорт
	
	// устанавливаем значения по умолчанию для пакетного выполнения задач
	Если ТочкаМаршрутаБизнесПроцесса = БизнесПроцессы.СогласованиеЗакупки.ТочкиМаршрута.СогласоватьЛогистическиеУсловия Или
		ТочкаМаршрутаБизнесПроцесса = БизнесПроцессы.СогласованиеЗакупки.ТочкиМаршрута.СогласоватьФинансовыеУсловия Или
		ТочкаМаршрутаБизнесПроцесса = БизнесПроцессы.СогласованиеЗакупки.ТочкиМаршрута.СогласоватьЦеновыеУсловия Или
		ТочкаМаршрутаБизнесПроцесса = БизнесПроцессы.СогласованиеЗакупки.ТочкиМаршрута.ПодвестиИтогиСогласования Тогда
		
		Попытка
			ЗаблокироватьДанныеДляРедактирования(БизнесПроцессСсылка);
		Исключение
				
			ТекстОшибки = НСтр("ru='При выполнении задачи не удалось заблокировать %Ссылка%. %ОписаниеОшибки%'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Ссылка%",         БизнесПроцессСсылка);
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ОписаниеОшибки%", КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
				
			ВызватьИсключение ТекстОшибки;
			
		КонецПопытки;
		
		УстановитьПривилегированныйРежим(Истина);
	
		СогласованиеОбъект = БизнесПроцессСсылка.ПолучитьОбъект();
		
		СогласованиеОбъект.ДобавитьРезультатСогласования(
			ТочкаМаршрутаБизнесПроцесса,
			Пользователи.ТекущийПользователь(),
			Перечисления.РезультатыСогласования.Согласовано,
			,
			ТекущаяДатаСеанса());
		
		Если ТочкаМаршрутаБизнесПроцесса = БизнесПроцессы.СогласованиеЗакупки.ТочкиМаршрута.ПодвестиИтогиСогласования Тогда
			СогласованиеОбъект.РезультатСогласования = Перечисления.РезультатыСогласования.Согласовано;
		КонецЕсли;
		
		СогласованиеОбъект.Записать();
		УстановитьПривилегированныйРежим(Ложь);
		
		РазблокироватьДанныеДляРедактирования(БизнесПроцессСсылка);

	КонецЕсли;
	
КонецПроцедуры

// Возвращает результат согласования рецензентом по точке маршрута
//
// Параметры:
//   БизнесПроцесс - БизнесПроцессСсылка.СогласованиеЗакупки - бизнес-процесс согласования.
//   ТочкаМаршрута - ТочкаМаршрутаБизнесПроцессаСсылка - точка, в которой находится бизнес-процесс.
//
// Возвращаемое значение:
//   ПеречислениеСсылка.РезультатыСогласования - результат согласования в точке маршрута.
//
Функция РезультатСогласованияПоТочкеМаршрута(Знач БизнесПроцесс, Знач ТочкаМаршрута) Экспорт
	
	Запрос = Новый Запрос("
		|ВЫБРАТЬ
		|	СогласованиеЗакупкиРезультатыСогласования.РезультатСогласования КАК РезультатСогласования
		|
		|ИЗ
		|	БизнесПроцесс.СогласованиеЗакупки.РезультатыСогласования КАК СогласованиеЗакупкиРезультатыСогласования
		|ГДЕ
		|	СогласованиеЗакупкиРезультатыСогласования.Ссылка = &Ссылка
		|	И СогласованиеЗакупкиРезультатыСогласования.ТочкаМаршрута = &ТочкаМаршрута
		|");
		
	Запрос.УстановитьПараметр("Ссылка",        БизнесПроцесс);
	Запрос.УстановитьПараметр("ТочкаМаршрута", ТочкаМаршрута);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.РезультатСогласования;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
		
КонецФункции

// Возвращает номер последней версии предмета.
//
// Параметры:
//   БизнесПроцесс - БизнесПроцессСсылка.СогласованиеЗакупки - бизнес-процесс, для которого получается номер версии.
//
// Возвращаемое значение:
//   Число - Номер последней версии документа.
//
Функция НомерПоследнейВерсииПредмета(Знач БизнесПроцесс) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос("
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	ВерсииОбъектов.НомерВерсии КАК НомерВерсии
		|ИЗ
		|	РегистрСведений.ВерсииОбъектов КАК ВерсииОбъектов
		|ГДЕ
		|	ВерсииОбъектов.Объект = ВЫРАЗИТЬ (&БизнесПроцесс КАК БизнесПроцесс.СогласованиеЗакупки).Предмет
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерВерсии УБЫВ
		|
		|");
		
	Запрос.УстановитьПараметр("БизнесПроцесс", БизнесПроцесс);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		НомерВерсии = Выборка.НомерВерсии;
	Иначе
		НомерВерсии = 0;
	КонецЕсли;
	
	Возврат НомерВерсии;

КонецФункции

// Осуществляет проверку на отличия последней версии предмета от согласованных.
//
// Параметры:
//   БизнесПроцесс - БизнесПроцессСсылка.СогласованиеЗакупки - бизнес-процесс, чей предмет проверяется на отличия.
//
// Возвращаемое значение:
//   Булево - Истина, если отличия есть, иначе ложь.
//
Функция ПоследняяВерсияПредметаОтличаетсяОтСогласованных(Знач БизнесПроцесс) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос("
		|ВЫБРАТЬ
		|	ЕСТЬNULL(МАКСИМУМ(РезультатыСогласования.НомерВерсии),0) КАК НомерСогласованнойВерсии,
		|	ЕСТЬNULL(МАКСИМУМ(ВерсииОбъектов.НомерВерсии),0)         КАК НомерПоследнейВерсии
		|ИЗ
		|	БизнесПроцесс.СогласованиеЗакупки.РезультатыСогласования КАК РезультатыСогласования
		|ЛЕВОЕ СОЕДИНЕНИЕ
		|	РегистрСведений.ВерсииОбъектов КАК ВерсииОбъектов
		|ПО
		|	ВерсииОбъектов.Объект = РезультатыСогласования.Ссылка.Предмет
		|ГДЕ
		|	РезультатыСогласования.Ссылка = &БизнесПроцесс
		|");
		
	Запрос.УстановитьПараметр("БизнесПроцесс", БизнесПроцесс);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Если Выборка.НомерСогласованнойВерсии <> Выборка.НомерПоследнейВерсии Тогда
			ЕстьОтличия = Истина;
		Иначе
			ЕстьОтличия = Ложь;
		КонецЕсли;
	Иначе
		ЕстьОтличия = Ложь;
	КонецЕсли;
	
	Возврат ЕстьОтличия;
	
КонецФункции

// Осуществляет проверку использования версионирования предмета согласования
//
// Параметры:
//	ТипПредмета - Строка - полное имя объекта, например "Документ.ЗаказКлиента"
//
// Возвращаемое значение:
//	Истина, если версионирование используется, иначе ложь - Булево
//
Функция ИспользуетсяВерсионированиеПредмета(Знач ТипПредмета) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ИспользоватьВерсионированиеОбъектов = ПолучитьФункциональнуюОпцию("ИспользоватьВерсионированиеОбъектов");
	
	Если Не ИспользоватьВерсионированиеОбъектов Тогда
		Возврат Ложь;
	КонецЕсли;
		
	ПараметрыОпции = Новый Структура();
	ПараметрыОпции.Вставить("ТипОбъекта", ТипПредмета);
		
	ИспользоватьВерсионированиеОбъекта = ПолучитьФункциональнуюОпцию("ИспользоватьВерсионированиеОбъекта", ПараметрыОпции);
	
	Возврат ИспользоватьВерсионированиеОбъекта;
	
КонецФункции

// Вызывается при перенаправлении задачи
//
// Параметры:
//   ЗадачаСсылка – ЗадачаСсылка.ЗадачаИсполнителя – перенаправляемая задача.
//  НоваяЗадачаСсылка – ЗадачаСсылка.ЗадачаИсполнителя – задача для нового исполнителя.
//
Процедура ПриПеренаправленииЗадачи(ЗадачаСсылка, НоваяЗадачаСсылка) Экспорт
	
	ЗадачаОбъект = НоваяЗадачаСсылка.ПолучитьОбъект();
	ЗаблокироватьДанныеДляРедактирования(НоваяЗадачаСсылка);
	ЗадачаОбъект.РезультатВыполнения = РезультатВыполненияПриПеренаправлении(ЗадачаСсылка) + 
		ЗадачаОбъект.РезультатВыполнения;
	ЗадачаОбъект.Записать();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

// Установка значений реквизитов предопределенных элементов справочника РолиИсполнителей,
// относящихся к согласованию закупок
// Вызывается при первоначальном заполнении ИБ.
//
Процедура ИнициализироватьРолиИсполнителей() Экспорт
	
	РольОбъект = Справочники.РолиИсполнителей.СогласующийЦеновыеУсловияЗакупок.ПолучитьОбъект();
	РольОбъект.ИспользуетсяБезОбъектовАдресации = Истина;
	РольОбъект.Записать();
	
	РольОбъект = Справочники.РолиИсполнителей.СогласующийЛогистическиеУсловияЗакупок.ПолучитьОбъект();
	РольОбъект.ИспользуетсяБезОбъектовАдресации = Истина;
	РольОбъект.Записать();
	
	РольОбъект = Справочники.РолиИсполнителей.СогласующийФинансовыеУсловияЗакупок.ПолучитьОбъект();
	РольОбъект.ИспользуетсяБезОбъектовАдресации = Истина;
	РольОбъект.Записать();
	
	РольОбъект = Справочники.РолиИсполнителей.СогласующийКоммерческиеУсловияЗакупок.ПолучитьОбъект();
	РольОбъект.ИспользуетсяБезОбъектовАдресации = Истина;
	РольОбъект.Записать();
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Функция РезультатВыполненияПриПеренаправлении(Знач ЗадачаСсылка)
	
	СтрокаФормат = НСтр("ru = '%1, %2 перенаправил(а) задачу:'");
	СтрокаФормат = СтрокаФормат + Символы.ПС + "%3" + Символы.ПС;
	
	Комментарий = СокрЛП(ЗадачаСсылка.РезультатВыполнения);
	Комментарий = ?(ПустаяСтрока(Комментарий), "", Комментарий + Символы.ПС);
	Результат = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаФормат,
		ЗадачаСсылка.ДатаИсполнения,
		ЗадачаСсылка.Исполнитель,
		Комментарий);
	
	Возврат Результат;

КонецФункции

#КонецОбласти

#Область Отчеты

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - Таблица с командами отчетов. Для изменения.
//       См. описание 1 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	КомандаОтчет = ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуРезультатыСогласованияЗакупки(КомандыОтчетов);
	Если КомандаОтчет <> Неопределено Тогда
		КомандаОтчет.ВидимостьВФормах = "ФормаБизнесПроцесса,ФормаСписка";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли


