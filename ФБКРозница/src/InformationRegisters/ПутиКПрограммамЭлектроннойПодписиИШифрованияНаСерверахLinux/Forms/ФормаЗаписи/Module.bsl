#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.ЗначенияЗаполнения.Свойство("Программа")
	   И ЗначениеЗаполнено(Параметры.ЗначенияЗаполнения.Программа) Тогда
		
		АвтоЗаголовок = Ложь;
		Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Путь к программе %1 на сервере Linux'"),
			Параметры.ЗначенияЗаполнения.Программа);
		
		Элементы.Программа.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// Требуется для обновления списка программ и
	// их параметров на сервере и на клиенте.
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ПутиКПрограммамЭлектроннойПодписиИШифрованияНаСерверахLinux",
		Новый Структура("Программа", Запись.Программа), Запись.ИсходныйКлючЗаписи);
	
КонецПроцедуры

#КонецОбласти
