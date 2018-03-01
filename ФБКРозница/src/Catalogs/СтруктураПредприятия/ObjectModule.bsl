#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ВариантОбособленногоУчетаТоваров = Перечисления.ВариантыОбособленногоУчетаТоваров.НеВедется;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда 
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если ЭтоНовый() Тогда
		
		ТекущаяСсылка = Справочники.СтруктураПредприятия.ПолучитьСсылку();
		УстановитьСсылкуНового(ТекущаяСсылка);
		
		ИзменилсяПризнакПроизводственное = ПроизводственноеПодразделение;
		
	Иначе
		
		ТекущаяСсылка = Ссылка;
		
		ПроизводственноеПодразделениеСсылка = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка,"ПроизводственноеПодразделение");
		ИзменилсяПризнакПроизводственное = ПроизводственноеПодразделениеСсылка <> ПроизводственноеПодразделение;
		
		
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("Ссылка", ТекущаяСсылка);
	ДополнительныеСвойства.Вставить("ИзменилсяПризнакПроизводственное", ИзменилсяПризнакПроизводственное);
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	

	// Установка реквизита РеквизитДопУпорядочивания
	Если НЕ Отказ И РеквизитДопУпорядочивания = 0 Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	Таблица.РеквизитДопУпорядочивания КАК РеквизитДопУпорядочивания
		|ИЗ
		|	Справочник.СтруктураПредприятия КАК Таблица
		|
		|УПОРЯДОЧИТЬ ПО
		|	РеквизитДопУпорядочивания УБЫВ");
		
		Выборка = Запрос.Выполнить().Выбрать();
		Выборка.Следующий();
		
		РеквизитДопУпорядочивания = ?(Не ЗначениеЗаполнено(Выборка.РеквизитДопУпорядочивания), 1, Выборка.РеквизитДопУпорядочивания + 1);
		
	КонецЕсли;
	
	
КонецПроцедуры


#КонецОбласти

#Область СлужебныеПроцедурыИФункции


#КонецОбласти

#Область Прочее


#КонецОбласти

#КонецЕсли
