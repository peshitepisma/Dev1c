
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Если Параметры.Назначение = Перечисления.НазначенияШаблоновЭтикетокИЦенников.ЭтикеткаДляСкладскихЯчеек Тогда
		ПризнакПредопределенногоМакета = Врег("СкладскиеЯчейки");
	ИначеЕсли Параметры.Назначение = Перечисления.НазначенияШаблоновЭтикетокИЦенников.ЦенникДляТоваров Тогда
		ПризнакПредопределенногоМакета = Врег("Товары");
	ИначеЕсли Параметры.Назначение = Перечисления.НазначенияШаблоновЭтикетокИЦенников.ЭтикеткаДляТоваров Тогда
		ПризнакПредопределенногоМакета = Врег("Товары");
	ИначеЕсли Параметры.Назначение = Перечисления.НазначенияШаблоновЭтикетокИЦенников.ЭтикеткаДляДоставки Тогда
		ПризнакПредопределенногоМакета = Врег("Доставки");
	ИначеЕсли Параметры.Назначение = Перечисления.НазначенияШаблоновЭтикетокИЦенников.ЭтикеткаСерииНоменклатуры Тогда
		ПризнакПредопределенногоМакета = Врег("СерииНоменклатуры");
	ИначеЕсли Параметры.Назначение = Перечисления.НазначенияШаблоновЭтикетокИЦенников.ЭтикеткаУпаковочныхЛистов Тогда
		ПризнакПредопределенногоМакета = Врег("УпаковочныеЛисты");
	ИначеЕсли Параметры.Назначение = Перечисления.НазначенияШаблоновЭтикетокИЦенников.ЭтикеткаДляАкцизныхМарок Тогда
		ПризнакПредопределенногоМакета = Врег("АкцизныеМарки");
	КонецЕсли;
	
	ДлинаПризнакаПредопределенногоМакета = СтрДлина(ПризнакПредопределенногоМакета);
	Для каждого Макет из Метаданные.НайтиПоТипу(Тип("СправочникСсылка.ШаблоныЭтикетокИЦенников")).Макеты Цикл
		Если Макет.ТипМакета = Метаданные.СвойстваОбъектов.ТипМакета.ТабличныйДокумент Тогда
			Если ВРег(Прав(Макет.Имя, ДлинаПризнакаПредопределенногоМакета)) = ПризнакПредопределенногоМакета Тогда
				Шаблон = Макет.Имя;
				Элементы.Шаблон.СписокВыбора.Добавить(Макет.Имя, Макет.Синоним);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Закрыть(Шаблон);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти
