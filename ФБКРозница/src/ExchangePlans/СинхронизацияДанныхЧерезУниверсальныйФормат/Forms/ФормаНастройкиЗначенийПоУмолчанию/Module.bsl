#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ИдентификаторНастройки") Тогда
		ИдентификаторНастройки = Параметры.ИдентификаторНастройки;
	КонецЕсли;
	
	ОбменДаннымиСервер.ФормаНастройкиЗначенийПоУмолчаниюПриСозданииНаСервере(ЭтаФорма, "СинхронизацияДанныхЧерезУниверсальныйФормат");
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"УстановитьДатуЗапретаПолученияДанных",
		"Доступность",
		ПравоДоступа("Изменение", Метаданные.РегистрыСведений.ДатыЗапретаИзменения));
	
	УстановитьВидимостьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	ОбменДаннымиКлиент.ФормаНастройкиПередЗакрытием(Отказ, ЭтотОбъект, ЗавершениеРаботы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	ОбменДаннымиКлиент.ФормаНастройкиЗначенийПоУмолчаниюКомандаЗакрытьФорму(ЭтаФорма);
	
КонецПроцедуры
#КонецОбласти

#Область Прочее
&НаСервере
Процедура УстановитьВидимостьНаСервере()
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ГруппаДатаЗапретаПолученияДанных",
		"Видимость",
		ПолучитьФункциональнуюОпцию("ИспользоватьДатыЗапретаЗагрузки"));
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ГруппаСкладПоУмолчанию",
		"Видимость",
		Не ИдентификаторНастройки = "ОбменУП2ЗУП3");
КонецПроцедуры
#КонецОбласти
