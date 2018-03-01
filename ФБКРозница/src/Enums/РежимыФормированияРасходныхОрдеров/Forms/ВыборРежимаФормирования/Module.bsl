#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	РежимФормированияРасходныхОрдеров = Параметры.РежимФормированияРасходныхОрдеров;
	
	Элементы.РежимФормированияРасходныхОрдеровАвтоматически.Подсказка =
		Перечисления.РежимыФормированияРасходныхОрдеров.ПодсказкаПоРежимуФормирования(Перечисления.РежимыФормированияРасходныхОрдеров.Автоматически);
	Элементы.РежимФормированияРасходныхОрдеровМенеджером.Подсказка =
		Перечисления.РежимыФормированияРасходныхОрдеров.ПодсказкаПоРежимуФормирования(Перечисления.РежимыФормированияРасходныхОрдеров.Менеджером);
	Элементы.РежимФормированияРасходныхОрдеровКладовщиком.Подсказка =
		Перечисления.РежимыФормированияРасходныхОрдеров.ПодсказкаПоРежимуФормирования(Перечисления.РежимыФормированияРасходныхОрдеров.Кладовщиком);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	Если РежимФормированияРасходныхОрдеров = ПредопределенноеЗначение("Перечисление.РежимыФормированияРасходныхОрдеров.Автоматически") Тогда
		
		ТекстВопроса = НСтр("ru = 'После изменения режима на ""Автоматически"" для всех ордерных складов будет:
			| - включено использование статусов расходных ордеров;
			| - запущено фоновое формирование расходных ордеров.
			|Проверить выполнение фонового задания ""Формирование очереди переоформления расходных ордеров"" можно в рабочем месте Администрирование - Поддержка и обслуживание - Регламентные и фоновые задания.
			|Продолжить?'");
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ОКЗавершение", ЭтотОбъект);
		
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);
		
	Иначе
		ОповеститьОВыборе(РежимФормированияРасходныхОрдеров);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОКЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.ОК Тогда
		ОповеститьОВыборе(РежимФормированияРасходныхОрдеров);
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	Закрыть();
КонецПроцедуры

#КонецОбласти

