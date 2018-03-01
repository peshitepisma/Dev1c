#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект, МассивНепроверяемыхРеквизитов, Отказ);
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

// Создает документ РегистрацияЦенНоменклатурыПоставщика и заполняет данными обработки
//
// Параметры:
//	РегистрироватьИзмененныеЦены - Булево - если Истина - в табличную часть Товары копируются только измененные цены
//
// Возвращаемое значение:
//	ДокументСсылка.РегистрацияЦенНоменклатурыПоставщика - если документ создан успешно
//	Неопределено - если не удалось создать документ
//
Функция СоздатьДокументРегистрацииЦенНоменклатурыПоставщика(РегистрироватьИзмененныеЦены) Экспорт
	
	ДокументОбъект = Документы.РегистрацияЦенНоменклатурыПоставщика.СоздатьДокумент();
	
	НомерВПределахДня = УстановкаЦенВызовСервера.РассчитатьНомерВПределахДня(Дата, ДокументОбъект.Ссылка);
	
	ДокументОбъект.Дата              = УстановкаЦенКлиентСервер.РассчитатьДатуДокумента(Дата, НомерВПределахДня);
	ДокументОбъект.Партнер           = Партнер;
	ДокументОбъект.Комментарий       = Комментарий;
	ДокументОбъект.Ответственный     = Пользователи.ТекущийПользователь();
	
	ЕстьТовары = Ложь;
	
	Если РегистрироватьИзмененныеЦены = 0 Тогда
		Для Каждого ТекСтрока Из Товары Цикл
			НоваяСтрока = ДокументОбъект.Товары.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрока);
			НоваяСтрока.Цена = ТекСтрока.НоваяЦена;
			ЕстьТовары = Истина;
		КонецЦикла;
	Иначе
		Для Каждого ТекСтрока Из Товары Цикл
			Если ТекСтрока.Цена <> ТекСтрока.НоваяЦена Тогда
				НоваяСтрока = ДокументОбъект.Товары.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрока);
				НоваяСтрока.Цена = ТекСтрока.НоваяЦена;
				ЕстьТовары = Истина;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если ЕстьТовары Тогда
		Попытка
			ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
			Возврат ДокументОбъект.Ссылка;
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			Возврат Неопределено;
		КонецПопытки;
	Иначе
		
		Если РегистрироватьИзмененныеЦены = 1 Тогда
			
			ТекстОшибки = НСтр("ru='Отсутствуют измененные цены'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				,
				,
				,);
			
		КонецЕсли;
		
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
