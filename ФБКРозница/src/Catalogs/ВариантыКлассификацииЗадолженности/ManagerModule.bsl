#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ОбновлениеИнформационнойБазы

//Выполняет первоначальное заполнение справочника
//
Процедура СоздатьВариантКлассификацииЗадолженностиПоУмолчаниюМонопольно() Экспорт
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	1 КАК Поле
	|ИЗ
	|	Справочник.ВариантыКлассификацииЗадолженности КАК ВариантыКлассификацииЗадолженности");
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		// Режим отсрочки - по календарным дням
		ЭлементПоУмолчанию = Справочники.ВариантыКлассификацииЗадолженности.СоздатьЭлемент();
		
		ЭлементПоУмолчанию.Наименование = НСтр("ru= 'Стандартная классификация'");
		
		НовыйИнтервал = ЭлементПоУмолчанию.Интервалы.Добавить();
		НовыйИнтервал.НижняяГраницаИнтервала = 1;
		НовыйИнтервал.ВерхняяГраницаИнтервала = 2;
		НовыйИнтервал.НаименованиеИнтервала = НСтр("ru= 'От 1 до 2 дней'");
		
		НовыйИнтервал = ЭлементПоУмолчанию.Интервалы.Добавить();
		НовыйИнтервал.НижняяГраницаИнтервала = 3;
		НовыйИнтервал.ВерхняяГраницаИнтервала = 14;
		НовыйИнтервал.НаименованиеИнтервала = НСтр("ru= 'От 3 до 14 дней'");
		
		НовыйИнтервал = ЭлементПоУмолчанию.Интервалы.Добавить();
		НовыйИнтервал.НижняяГраницаИнтервала = 15;
		НовыйИнтервал.ВерхняяГраницаИнтервала = 29;
		НовыйИнтервал.НаименованиеИнтервала = НСтр("ru= 'От 15 до 29 дней'");
		
		НовыйИнтервал = ЭлементПоУмолчанию.Интервалы.Добавить();
		НовыйИнтервал.НижняяГраницаИнтервала = 30;
		НовыйИнтервал.ВерхняяГраницаИнтервала = 44;
		НовыйИнтервал.НаименованиеИнтервала = НСтр("ru= 'От 30 до 44 дней'");
		
		НовыйИнтервал = ЭлементПоУмолчанию.Интервалы.Добавить();
		НовыйИнтервал.НижняяГраницаИнтервала = 45;
		НовыйИнтервал.ВерхняяГраницаИнтервала = 59;
		НовыйИнтервал.НаименованиеИнтервала = НСтр("ru= 'От 45 до 59 дней'");
		
		НовыйИнтервал = ЭлементПоУмолчанию.Интервалы.Добавить();
		НовыйИнтервал.НижняяГраницаИнтервала = 60;
		НовыйИнтервал.ВерхняяГраницаИнтервала = 179;
		НовыйИнтервал.НаименованиеИнтервала = НСтр("ru= 'От 60 до 179 дней'");
		
		НовыйИнтервал = ЭлементПоУмолчанию.Интервалы.Добавить();
		НовыйИнтервал.НижняяГраницаИнтервала = 180;
		НовыйИнтервал.ВерхняяГраницаИнтервала = 9999999999;
		НовыйИнтервал.НаименованиеИнтервала = НСтр("ru= 'Свыше 180 дней'");
		
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(ЭлементПоУмолчанию);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	Если ВидФормы = "ФормаСписка" 
		И НЕ Константы.ИспользоватьНесколькоКлассификацийЗадолженности.Получить() Тогда
		
		Параметры.Вставить("Ключ", ОбщегоНазначенияУТВызовСервера.ВариантКлассификацииЗадолженностиПоУмолчанию());
		ВыбраннаяФорма = "ФормаЭлемента";
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
