#Область ПрограммныйИнтерфейс

// Открывает форму создания резервной копии.
//
// Параметры:
//    Параметры - Структура - Параметры формы создания резервной копии.
//
Процедура ОткрытьФормуРезервногоКопирования(Параметры = Неопределено) Экспорт
	
	ОткрытьФорму("Обработка.РезервноеКопированиеИБ.Форма.РезервноеКопированиеДанных", Параметры);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем конфигурации.

// См. ОбщегоНазначенияКлиентПереопределяемый.ПриНачалеРаботыСистемы.
Процедура ПриНачалеРаботыСистемы(Параметры) Экспорт
	
	Если Не ОбщегоНазначенияКлиентСервер.ЭтоWindowsКлиент() Или ОбщегоНазначенияКлиентСервер.ЭтоВебКлиент() Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыРаботы = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске();
	Если ПараметрыРаботы.РазделениеВключено Тогда
		Возврат;
	КонецЕсли;
	
	ФиксированныеПараметрыРезервногоКопированияИБ = Неопределено;
	Если Не ПараметрыРаботы.Свойство("РезервноеКопированиеИБ", ФиксированныеПараметрыРезервногоКопированияИБ) Тогда
		Возврат;
	КонецЕсли;
	Если ТипЗнч(ФиксированныеПараметрыРезервногоКопированияИБ) <> Тип("ФиксированнаяСтруктура") Тогда
		Возврат;
	КонецЕсли;
	
	// Заполнение глобальных переменных.
	ЗаполнитьЗначенияГлобальныхПеременных(ФиксированныеПараметрыРезервногоКопированияИБ);
	
	ПроверитьРезервноеКопированиеИБ(ФиксированныеПараметрыРезервногоКопированияИБ);
	
	Если ФиксированныеПараметрыРезервногоКопированияИБ.ПроведеноВосстановление Тогда
		ТекстОповещения = НСтр("ru = 'Восстановление данных проведено успешно.'");
		ПоказатьОповещениеПользователя(НСтр("ru = 'Данные восстановлены.'"), , ТекстОповещения);
	КонецЕсли;
	
	ВариантОповещения = ФиксированныеПараметрыРезервногоКопированияИБ.ПараметрОповещения;
	
	Если ВариантОповещения = "НеОповещать" Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ТекущиеДела") Тогда
		ПоказыватьПредупреждение = Ложь;
		РезервноеКопированиеИБКлиентПереопределяемый.ПриОпределенииНеобходимостиПоказаПредупрежденийОРезервномКопировании(ПоказыватьПредупреждение);
	Иначе
		ПоказыватьПредупреждение = Истина;
	КонецЕсли;
	
	Если ПоказыватьПредупреждение
		И (ВариантОповещения = "Просрочено" Или ВариантОповещения = "ЕщеНеНастроено") Тогда
		ОповеститьПользователяОРезервномКопировании(ВариантОповещения);
	КонецЕсли;
	
	ПодключитьОбработчикОжиданияРезервногоКопирования();
	
КонецПроцедуры

// См. ОбщегоНазначенияКлиентПереопределяемый.ПередЗавершениемРаботыСистемы.
Процедура ПередЗавершениемРаботыСистемы(Отказ, Предупреждения) Экспорт
	
	#Если ВебКлиент Тогда
		Возврат;
	#КонецЕсли
	
	Если Не ОбщегоНазначенияКлиентСервер.ЭтоWindowsКлиент() Тогда
		Возврат;
	КонецЕсли;
	
	Параметры = СтандартныеПодсистемыКлиент.ПараметрКлиента();
	Если Параметры.РазделениеВключено Или Не Параметры.ИнформационнаяБазаФайловая Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Параметры.РезервноеКопированиеИБПриЗавершенииРаботы.ДоступностьРолейОповещения
		Или Не Параметры.РезервноеКопированиеИБПриЗавершенииРаботы.ВыполнятьПриЗавершенииРаботы Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыПредупреждения = СтандартныеПодсистемыКлиент.ПредупреждениеПриЗавершенииРаботы();
	ПараметрыПредупреждения.ТекстФлажка = НСтр("ru = 'Выполнить резервное копирование'");
	ПараметрыПредупреждения.Приоритет = 50;
	ПараметрыПредупреждения.ТекстПредупреждения = НСтр("ru = 'Не выполнено резервное копирование при завершении работы.'");
	
	ДействиеПриУстановленномФлажке = ПараметрыПредупреждения.ДействиеПриУстановленномФлажке;
	ДействиеПриУстановленномФлажке.Форма = "Обработка.РезервноеКопированиеИБ.Форма.РезервноеКопированиеДанных";
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("РежимРаботы", "ВыполнитьПриЗавершенииРаботы");
	ДействиеПриУстановленномФлажке.ПараметрыФормы = ПараметрыФормы;
	
	Предупреждения.Добавить(ПараметрыПредупреждения);
	
КонецПроцедуры

// См. ИнтеграцияПодсистемБСПКлиент.ПриПроверкеВозможностиРезервногоКопированияВПользовательскомРежиме.
Процедура ПриПроверкеВозможностиРезервногоКопированияВПользовательскомРежиме(Результат) Экспорт
	
	Если ОбщегоНазначенияКлиент.ИнформационнаяБазаФайловая() Тогда
		Результат = Истина;
	КонецЕсли;
	
КонецПроцедуры

// См. ИнтеграцияПодсистемБСПКлиент.ПриПредложенииПользователюСоздатьРезервнуюКопию.
Процедура ПриПредложенииПользователюСоздатьРезервнуюКопию() Экспорт
	
	ОткрытьФормуРезервногоКопирования();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Заполнение глобальных переменных.
Процедура ЗаполнитьЗначенияГлобальныхПеременных(ФиксированныеПараметрыРезервногоКопированияИБ) Экспорт
	
	ИмяПараметра = "СтандартныеПодсистемы.ПараметрыРезервногоКопированияИБ";
	ПараметрыПриложения.Вставить(ИмяПараметра, Новый Структура);
	ПараметрыПриложения[ИмяПараметра].Вставить("ПроцессВыполняется");
	ПараметрыПриложения[ИмяПараметра].Вставить("МинимальнаяДатаСледующегоАвтоматическогоРезервногоКопирования");
	ПараметрыПриложения[ИмяПараметра].Вставить("ДатаПоследнегоРезервногоКопирования");
	ПараметрыПриложения[ИмяПараметра].Вставить("ПараметрОповещения");
	
	ЗаполнитьЗначенияСвойств(ПараметрыПриложения[ИмяПараметра], ФиксированныеПараметрыРезервногоКопированияИБ);
	ПараметрыПриложения[ИмяПараметра].Вставить("РасписаниеЗначение", ОбщегоНазначенияКлиентСервер.СтруктураВРасписание(ФиксированныеПараметрыРезервногоКопированияИБ.РасписаниеКопирования));
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Экспортные служебные процедуры и функции.

// Проверяет необходимость запуска автоматического резервного копирования
// в процессе работы пользователя, а также повторного оповещения после игнорировании первоначального.
//
Процедура ОбработчикОжиданияЗапуска() Экспорт
	
	Если Не ОбщегоНазначенияКлиентСервер.ЭтоWindowsКлиент() Или ОбщегоНазначенияКлиентСервер.ЭтоВебКлиент() Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиент.ИнформационнаяБазаФайловая()
	   И НеобходимостьАвтоматическогоРезервногоКопирования() Тогда
		
		ПровестиРезервноеКопирование();
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ТекущиеДела") Тогда
		ПоказыватьПредупреждение = Ложь;
		РезервноеКопированиеИБКлиентПереопределяемый.ПриОпределенииНеобходимостиПоказаПредупрежденийОРезервномКопировании(ПоказыватьПредупреждение);
	Иначе
		ПоказыватьПредупреждение = Истина;
	КонецЕсли;
	
	ВариантОповещения = ПараметрыПриложения["СтандартныеПодсистемы.ПараметрыРезервногоКопированияИБ"].ПараметрОповещения;
	Если ПоказыватьПредупреждение
		И (ВариантОповещения = "Просрочено" Или ВариантОповещения = "ЕщеНеНастроено") Тогда
		ОповеститьПользователяОРезервномКопировании(ВариантОповещения);
	КонецЕсли;
	
КонецПроцедуры

// Проверяет необходимость проведения автоматического резервного копирования.
//
// Возвращаемое значение - Булево - Истина, если необходима, Ложь - иначе.
//
Функция НеобходимостьАвтоматическогоРезервногоКопирования()
	Перем РасписаниеЗначение;
	
	ПараметрыРезервногоКопированияИБ = ПараметрыПриложения["СтандартныеПодсистемы.ПараметрыРезервногоКопированияИБ"];
	Если ПараметрыРезервногоКопированияИБ = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ПараметрыРезервногоКопированияИБ.ПроцессВыполняется
		ИЛИ НЕ ПараметрыРезервногоКопированияИБ.Свойство("МинимальнаяДатаСледующегоАвтоматическогоРезервногоКопирования")
		ИЛИ НЕ ПараметрыРезервногоКопированияИБ.Свойство("РасписаниеЗначение", РасписаниеЗначение)
		ИЛИ НЕ ПараметрыРезервногоКопированияИБ.Свойство("ДатаПоследнегоРезервногоКопирования") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если РасписаниеЗначение = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ДатаПроверки = ОбщегоНазначенияКлиент.ДатаСеанса();
	
	ДатаСледующегоКопирования = ПараметрыРезервногоКопированияИБ.МинимальнаяДатаСледующегоАвтоматическогоРезервногоКопирования;
	Если ДатаСледующегоКопирования = '29990101' Или ДатаСледующегоКопирования > ДатаПроверки Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат РасписаниеЗначение.ТребуетсяВыполнение(ДатаПроверки, ПараметрыРезервногоКопированияИБ.ДатаПоследнегоРезервногоКопирования);
КонецФункции

// Запускает резервное копирование по расписанию.
// 
Процедура ПровестиРезервноеКопирование()
	
	Кнопки = Новый СписокЗначений;
	Кнопки.Добавить("Да", НСтр("ru = 'Да'"));
	Кнопки.Добавить("Нет", НСтр("ru = 'Нет'"));
	Кнопки.Добавить("Отложить", НСтр("ru = 'Отложить на 15 минут'"));
	
	ОписаниеОповещение = Новый ОписаниеОповещения("ПровестиРезервноеКопированиеЗавершение", ЭтотОбъект);
	ПоказатьВопрос(ОписаниеОповещение, НСтр("ru = 'Все готово для выполнения резервного копирования по расписанию.
		|Выполнить резервное копирование сейчас?'"),
		Кнопки, 30, "Да", НСтр("ru = 'Резервное копирование по расписанию'"), "Да");
	
КонецПроцедуры

Процедура ПровестиРезервноеКопированиеЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	ВыполнитьРезервноеКопирование = РезультатВопроса = "Да" Или РезультатВопроса = КодВозвратаДиалога.Таймаут;
	ОтложитьРезервноеКопирование = РезультатВопроса = "Отложить";
	
	ДатаСледующегоАвтоматическогоКопирования = РезервноеКопированиеИБВызовСервера.ДатаСледующегоАвтоматическогоКопирования(
		ОтложитьРезервноеКопирование);
	ЗаполнитьЗначенияСвойств(ПараметрыПриложения["СтандартныеПодсистемы.ПараметрыРезервногоКопированияИБ"],
		ДатаСледующегоАвтоматическогоКопирования);
	
	Если ВыполнитьРезервноеКопирование Тогда
		ПараметрыФормы = Новый Структура("РежимРаботы", "ВыполнитьСейчас");
		ОткрытьФорму("Обработка.РезервноеКопированиеИБ.Форма.РезервноеКопированиеДанных", ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры

// Удаляет резервные копии по заданным настройкам.
//
Процедура УдалитьРезервныеКопииПоНастройке() Экспорт
	
	// Очистка архива с копиями.
	ФиксированныеПараметрыРезервногоКопированияИБ = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента().РезервноеКопированиеИБ;
	КаталогХранения = ФиксированныеПараметрыРезервногоКопированияИБ.КаталогХраненияРезервныхКопий;
	ПараметрыУдаления = ФиксированныеПараметрыРезервногоКопированияИБ.ПараметрыУдаления;
	
	Если ПараметрыУдаления.ТипОграничения <> "ХранитьВсе" И КаталогХранения <> Неопределено Тогда
		
		Попытка
			Файл = Новый Файл(КаталогХранения);
			Если НЕ Файл.ЭтоКаталог() Тогда
				Возврат;
			КонецЕсли;
			
			МассивФайлов = НайтиФайлы(КаталогХранения, "backup*.zip", Ложь);
			СписокУдаляемыхФайлов = Новый Массив;
			
			// Удаление резервных копий.
			Если ПараметрыУдаления.ТипОграничения = "ПоПериоду" Тогда
				Для Каждого ЭлементФайл Из МассивФайлов Цикл
					ТекущаяДата = ОбщегоНазначенияКлиент.ДатаСеанса();
					ЗначениеВСекундах = КоличествоСекундВПериоде(ПараметрыУдаления.ЗначениеВЕдиницахИзмерения, ПараметрыУдаления.ЕдиницаИзмеренияПериода);
					ПроизводитьУдаление = ((ТекущаяДата - ЗначениеВСекундах) > ЭлементФайл.ПолучитьВремяИзменения());
					Если ПроизводитьУдаление Тогда
						СписокУдаляемыхФайлов.Добавить(ЭлементФайл);
					КонецЕсли;
				КонецЦикла;
				
			ИначеЕсли МассивФайлов.Количество() >= ПараметрыУдаления.КоличествоКопий Тогда
				СписокФайлов = Новый СписокЗначений;
				СписокФайлов.ЗагрузитьЗначения(МассивФайлов);
				
				Для Каждого Файл Из СписокФайлов Цикл
					Файл.Значение = Файл.Значение.ПолучитьВремяИзменения();
				КонецЦикла;
				
				СписокФайлов.СортироватьПоЗначению(НаправлениеСортировки.Убыв);
				ДатаПоследнегоАрхива = СписокФайлов[ПараметрыУдаления.КоличествоКопий-1].Значение;
				
				Для Каждого ЭлементФайл Из МассивФайлов Цикл
					
					Если ЭлементФайл.ПолучитьВремяИзменения() <= ДатаПоследнегоАрхива Тогда
						СписокУдаляемыхФайлов.Добавить(ЭлементФайл);
					КонецЕсли;
					
				КонецЦикла;
				
			КонецЕсли;
			
			Для Каждого УдаляемыйФайл Из СписокУдаляемыхФайлов Цикл
				УдалитьФайлы(УдаляемыйФайл.ПолноеИмя);
			КонецЦикла;
			
		Исключение
			
			ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(СобытиеЖурналаРегистрации(), "Ошибка",
				НСтр("ru = 'Не удалось провести очистку каталога с резервными копиями.'") + Символы.ПС 
				+ ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()),,Истина);
			
		КонецПопытки;
		
	КонецЕсли;
	
КонецПроцедуры

// При старте системы проверяет, первый ли это запуск после проведения резервного копирования. 
// Если да - выводит форму обработчика с результатами резервного копирования.
//
// Параметры:
//	Параметры - Структура - параметры резервного копирования.
//
Процедура ПроверитьРезервноеКопированиеИБ(Параметры)
	
	Если Не Параметры.ПроведеноКопирование Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.РучнойЗапускПоследнегоРезервногоКопирования Тогда
		
		ПараметрыФормы = Новый Структура();
		ПараметрыФормы.Вставить("РежимРаботы", ?(Параметры.РезультатКопирования, "УспешноВыполнено", "НеВыполнено"));
		ПараметрыФормы.Вставить("ИмяФайлаРезервнойКопии", Параметры.ИмяФайлаРезервнойКопии);
		ОткрытьФорму("Обработка.РезервноеКопированиеИБ.Форма.РезервноеКопированиеДанных", ПараметрыФормы);
		
	Иначе
		
		ПоказатьОповещениеПользователя(НСтр("ru = 'Резервное копирование'"),
			"e1cib/command/ОбщаяКоманда.ПоказатьРезультатРезервногоКопирования",
			НСтр("ru = 'Резервное копирование проведено успешно'"), БиблиотекаКартинок.Информация32);
		РезервноеКопированиеИБВызовСервера.УстановитьЗначениеНастройки("ПроведеноКопирование", Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

// По результатам анализа параметров резервного копирования выдает соответствующее оповещение.
//
// Параметры: 
//   ВариантОповещения - Строка - результат проверки на посылку оповещения.
//
Процедура ОповеститьПользователяОРезервномКопировании(ВариантОповещения)
	
	ТекстПояснения = "";
	Если ВариантОповещения = "Просрочено" Тогда
		
		ТекстПояснения = НСтр("ru = 'Автоматическое резервное копирование не было выполнено.'"); 
		ПоказатьОповещениеПользователя(НСтр("ru = 'Резервное копирование'"),
			"e1cib/app/Обработка.РезервноеКопированиеИБ", ТекстПояснения, БиблиотекаКартинок.Предупреждение32);
		
	ИначеЕсли ВариантОповещения = "ЕщеНеНастроено" Тогда
		
		ИмяФормыНастроек = "e1cib/app/Обработка.НастройкаРезервногоКопированияИБ/";
		ТекстПояснения = НСтр("ru = 'Рекомендуется настроить резервное копирование информационной базы.'"); 
		ПоказатьОповещениеПользователя(НСтр("ru = 'Резервное копирование'"),
			ИмяФормыНастроек, ТекстПояснения, БиблиотекаКартинок.Предупреждение32);
			
	КонецЕсли;
	
	ТекущаяДата = ОбщегоНазначенияКлиент.ДатаСеанса();
	РезервноеКопированиеИБВызовСервера.УстановитьДатуПоследнегоНапоминания(ТекущаяДата);
	
КонецПроцедуры

// Возвращает тип события журнала регистрации для данной подсистемы.
//
// Возвращаемое значение - Строка - тип события журнала регистрации.
//
Функция СобытиеЖурналаРегистрации() Экспорт
	
	Возврат НСтр("ru = 'Резервное копирование информационной базы'",
		СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске().КодОсновногоЯзыка);
	
КонецФункции

// Возвращает параметры скрипта резервного копирования.
//
// Возвращаемое значение - Структура - структура скрипта резервного копирования.
//
Функция КлиентскиеПараметрыРезервногоКопирования() Экспорт
	#Если НЕ ВебКлиент Тогда
		
		СтруктураПараметров = Новый Структура();
		СтруктураПараметров.Вставить("ИмяФайлаПрограммы", СтандартныеПодсистемыКлиент.ИмяИсполняемогоФайлаПриложения());
		СтруктураПараметров.Вставить("СобытиеЖурналаРегистрации", НСтр("ru = 'Резервное копирование ИБ'"));
		
		// Вызов КаталогВременныхФайлов вместо ПолучитьИмяВременногоФайла, так как каталог не должен удаляться 
		// автоматически при завершении клиентского приложения.
		КаталогВременныхФайловОбновления = КаталогВременныхФайлов() + "1Cv8Backup." + Формат(ОбщегоНазначенияКлиент.ДатаСеанса(), "ДФ=ггММддЧЧммсс") + "\";
		СтруктураПараметров.Вставить("КаталогВременныхФайловОбновления", КаталогВременныхФайловОбновления);
		
		Возврат СтруктураПараметров;
	#КонецЕсли
КонецФункции

// Получение параметров аутентификации пользователя для обновления.
// Создает виртуального пользователя, если в этом есть необходимость.
//
// Возвращаемое значение
//  Структура       - параметры виртуального пользователя.
//
Функция ПараметрыАутентификацииАдминистратораОбновления(ПарольАдминистратора) Экспорт
	
	Результат = Новый Структура("ИмяПользователя, ПарольПользователя, СтрокаПодключения, СтрокаСоединенияИнформационнойБазы");
	
	ТекущиеСоединения = СоединенияИБВызовСервера.ИнформацияОСоединениях(Истина,
		ПараметрыПриложения["СтандартныеПодсистемы.СообщенияДляЖурналаРегистрации"]);
	Результат.СтрокаСоединенияИнформационнойБазы = ТекущиеСоединения.СтрокаСоединенияИнформационнойБазы;
	// Диагностика случая, когда ролевой безопасности в системе не предусмотрено.
	// Т.е. ситуация, когда любой пользователь «может» в системе все.
	Если Не ТекущиеСоединения.ЕстьАктивныеПользователи Тогда
		Возврат Результат;
	КонецЕсли;
	
	Результат.ИмяПользователя    = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске().ИмяТекущегоПользователя;
	Результат.ПарольПользователя = СтрокаUnicode(ПарольАдминистратора);
	Результат.СтрокаПодключения  = "Usr=""{0}"";Pwd=""{1}""";
	Возврат Результат;
	
КонецФункции

Функция СтрокаUnicode(Строка) Экспорт
	
	Результат = "";
	
	Для НомерСимвола = 1 По СтрДлина(Строка) Цикл
		
		Символ = Формат(КодСимвола(Сред(Строка, НомерСимвола, 1)), "ЧГ=0");
		Символ = СтроковыеФункцииКлиентСервер.ДополнитьСтроку(Символ, 4);
		Результат = Результат + Символ;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Проверят возможность подключения к информационной базе.
//
Функция ПроверитьДоступКИнформационнойБазе(ПарольАдминистратора) Экспорт
	
	// В базовых версиях проверку подключения не осуществляем;
	// при некорректном вводе имени и пароля обновление завершится неуспешно.
	РезультатПодключения = Новый Структура("ОшибкаПодключенияКомпоненты, КраткоеОписаниеОшибки", Ложь, "");
	ПараметрыРаботыКлиентаПриЗапуске = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске();
	Если ПараметрыРаботыКлиентаПриЗапуске.ЭтоБазоваяВерсияКонфигурации Тогда
		Возврат РезультатПодключения;
	КонецЕсли;
	
	ОбщегоНазначенияКлиент.ЗарегистрироватьCOMСоединитель(Ложь);
	
	ПараметрыПодключения = ОбщегоНазначенияКлиентСервер.СтруктураПараметровДляУстановкиВнешнегоСоединения();
	ПараметрыПодключения.КаталогИнформационнойБазы = СтрРазделить(СтрокаСоединенияИнформационнойБазы(), """")[1];
	ПараметрыПодключения.ИмяПользователя = ПараметрыРаботыКлиентаПриЗапуске.ИмяТекущегоПользователя;
	ПараметрыПодключения.ПарольПользователя = ПарольАдминистратора;
	
	Результат = ОбщегоНазначенияКлиентСервер.УстановитьВнешнееСоединениеСБазой(ПараметрыПодключения);
	
	Если Результат.ОшибкаПодключенияКомпоненты Тогда
		
		ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(
			СобытиеЖурналаРегистрации(),"Ошибка", Результат.ПодробноеОписаниеОшибки, , Истина);
		
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(РезультатПодключения, Результат);
	
	Возврат РезультатПодключения;
	
КонецФункции

// Подключение глобального обработчика ожидания.
//
Процедура ПодключитьОбработчикОжиданияРезервногоКопирования() Экспорт
	
	ПодключитьОбработчикОжидания("ОбработчикДействийРезервногоКопирования", 60);
	
КонецПроцедуры

// Отключение глобального обработчика ожидания.
//
Процедура ОтключитьОбработчикОжиданияРезервногоКопирования() Экспорт
	
	ОтключитьОбработчикОжидания("ОбработчикДействийРезервногоКопирования");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Локальные служебные процедуры и функции.

Функция КоличествоСекундВПериоде(Период, ТипПериода)
	
	Если ТипПериода = "День" Тогда
		Множитель = 3600 * 24;
	ИначеЕсли ТипПериода = "Неделя" Тогда
		Множитель = 3600 * 24 * 7; 
	ИначеЕсли ТипПериода = "Месяц" Тогда
		Множитель = 3600 * 24 * 30;
	ИначеЕсли ТипПериода = "Год" Тогда
		Множитель = 3600 * 24 * 365;
	КонецЕсли;
	
	Возврат Множитель * Период;
	
КонецФункции

#КонецОбласти
