
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Возврат при получении формы для анализа.
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ВариантЗавершенияПроверкиОрдера = ?(ЗначениеЗаполнено(Параметры.ВариантЗавершенияПроверкиОрдера),
		Параметры.ВариантЗавершенияПроверкиОрдера, "ЗапрашиватьВыборДействияПослеПроверки");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Оповестить("ИзмененВариантЗавершенияПроверкиОрдера", ВариантЗавершенияПроверкиОрдера, ЭтаФорма.ИмяФормы);
	
	Закрыть(КодВозвратаДиалога.ОК);
	
КонецПроцедуры

#КонецОбласти
