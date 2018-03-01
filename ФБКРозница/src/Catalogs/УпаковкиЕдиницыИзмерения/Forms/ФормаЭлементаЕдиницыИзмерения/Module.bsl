
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	ПриЧтенииСозданииНаСервере()
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ОбновитьЗаголовокФормы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипЕдиницыИзмеренияПриИзменении(Элемент)
	НастроитьФорму();
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	НастроитьФорму();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	НастроитьФорму();
	ОбновитьЗаголовокФормы();
	
КонецПроцедуры

&НаСервере
Процедура НастроитьФорму()
	
	Если Объект.ТипИзмеряемойВеличины = Перечисления.ТипыИзмеряемыхВеличин.Длина
		Или Объект.ТипИзмеряемойВеличины = Перечисления.ТипыИзмеряемыхВеличин.Площадь
		Или Объект.ТипИзмеряемойВеличины = Перечисления.ТипыИзмеряемыхВеличин.Объем
		Или Объект.ТипИзмеряемойВеличины = Перечисления.ТипыИзмеряемыхВеличин.Вес
		Или Объект.ТипИзмеряемойВеличины = Перечисления.ТипыИзмеряемыхВеличин.Энергия
		Или Объект.ТипИзмеряемойВеличины = Перечисления.ТипыИзмеряемыхВеличин.ЭлектрическийЗаряд
		Или Объект.ТипИзмеряемойВеличины = Перечисления.ТипыИзмеряемыхВеличин.Мощность
		Или Объект.ТипИзмеряемойВеличины = Перечисления.ТипыИзмеряемыхВеличин.Время Тогда
		Элементы.ГруппаКратность.Видимость = Истина;
		ЗаголовокДекорации = НСтр("ru = '%ЕдиницаИзмерения% ='");
		Элементы.Декорация1.Заголовок = СтрЗаменить(ЗаголовокДекорации, "%ЕдиницаИзмерения%", Объект.Наименование);
	Иначе 
		Элементы.ГруппаКратность.Видимость = Ложь;
		Объект.Числитель = 0;
		Объект.Знаменатель = 0;		
	КонецЕсли;
	
	Если Объект.ТипИзмеряемойВеличины = Перечисления.ТипыИзмеряемыхВеличин.Длина Тогда
		ПредставлениеБазовойЕдиницыИзмерения = НСтр("ru = 'м'");
	ИначеЕсли Объект.ТипИзмеряемойВеличины = Перечисления.ТипыИзмеряемыхВеличин.Площадь Тогда
		ПредставлениеБазовойЕдиницыИзмерения = НСтр("ru = 'м2'");
	ИначеЕсли Объект.ТипИзмеряемойВеличины = Перечисления.ТипыИзмеряемыхВеличин.Объем Тогда
		ПредставлениеБазовойЕдиницыИзмерения = НСтр("ru = 'м3'");
	ИначеЕсли Объект.ТипИзмеряемойВеличины = Перечисления.ТипыИзмеряемыхВеличин.Вес Тогда
		ПредставлениеБазовойЕдиницыИзмерения = НСтр("ru = 'кг'");
	ИначеЕсли Объект.ТипИзмеряемойВеличины = Перечисления.ТипыИзмеряемыхВеличин.Энергия Тогда
		ПредставлениеБазовойЕдиницыИзмерения = НСтр("ru = 'ватт-час'");
	ИначеЕсли Объект.ТипИзмеряемойВеличины = Перечисления.ТипыИзмеряемыхВеличин.Мощность Тогда
		ПредставлениеБазовойЕдиницыИзмерения = НСтр("ru = 'ватт'");
	ИначеЕсли Объект.ТипИзмеряемойВеличины = Перечисления.ТипыИзмеряемыхВеличин.ЭлектрическийЗаряд Тогда
		ПредставлениеБазовойЕдиницыИзмерения = НСтр("ru = 'ампер-час'");
	ИначеЕсли Объект.ТипИзмеряемойВеличины = Перечисления.ТипыИзмеряемыхВеличин.Время Тогда
		ПредставлениеБазовойЕдиницыИзмерения = НСтр("ru = 'с'");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЗаголовокФормы()
	
	ПредставлениеТипа = НСтр("ru='Единица измерения'");
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='%1 (создание)'"),
			ПредставлениеТипа);
	Иначе
		Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='%1 (%2)'"),
			Объект.Наименование,
			ПредставлениеТипа);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти




