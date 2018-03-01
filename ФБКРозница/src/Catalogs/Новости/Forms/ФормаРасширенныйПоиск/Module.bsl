#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	ЭтаФорма.НастройкиПоиска = Параметры.НастройкиПоиска.Скопировать();
	Для каждого ТекущийЭлементСписка Из ЭтаФорма.НастройкиПоиска Цикл
		Если ТекущийЭлементСписка.Представление = "СтрокаПоиска" Тогда
			ЭтаФорма.СтрокаПоиска = ТекущийЭлементСписка.Значение;
		ИначеЕсли ТекущийЭлементСписка.Представление = "ПоискДатаОТ" Тогда
			ЭтаФорма.ПоискДатаОТ = ТекущийЭлементСписка.Значение;
		ИначеЕсли ТекущийЭлементСписка.Представление = "ПоискДатаДО" Тогда
			ЭтаФорма.ПоискДатаДО = ТекущийЭлементСписка.Значение;
		КонецЕсли;
	КонецЦикла;

	Если ПолнотекстовыйПоиск.ПолучитьРежимПолнотекстовогоПоиска() = РежимПолнотекстовогоПоиска.Разрешить Тогда
		Элементы.СтрокаПоиска.Подсказка = НСтр("ru='Полнотекстовый поиск включен.
			|Можно использовать символы подстановки * и ?'");
	Иначе
		Элементы.СтрокаПоиска.Подсказка = НСтр("ru='Полнотекстовый поиск отключен.
			|Доступен поиск только точных фраз'");
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)

	Если ПустаяСтрока(ЭтаФорма.СтрокаПоиска) Тогда
		Отказ = Истина;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru='Строка поиска пустая'");
		Сообщение.Поле = "СтрокаПоиска";
		Сообщение.ПутьКДанным = "";
		Сообщение.Сообщить();
	КонецЕсли;

	Если (ЭтаФорма.ПоискДатаОТ <> '00010101') И (ЭтаФорма.ПоискДатаДО <> '00010101') Тогда
		Если (ЭтаФорма.ПоискДатаОТ > ЭтаФорма.ПоискДатаДО) Тогда
			Отказ = Истина;
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = НСтр("ru='Неверно задан интервал поиска по датам: дата начала позже даты окончания'");
			Сообщение.Поле = "ПоискДатаОТ";
			Сообщение.ПутьКДанным = "";
			Сообщение.Сообщить();
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаПоиск(Команда)

	ТипМассив = Тип("Массив");

	Если ПроверитьЗаполнение() Тогда
		МассивНайденныхНовостей = ОбработкаНовостейКлиент.НайтиНовости(
			Новый Структура("СтрокаПоиска, ПоискДатаОТ, ПоискДатаДО",
				ЭтаФорма.СтрокаПоиска,
				ЭтаФорма.ПоискДатаОТ,
				ЭтаФорма.ПоискДатаДО));
		Если ТипЗнч(МассивНайденныхНовостей) = ТипМассив Тогда
			ЭтаФорма.НастройкиПоиска.Очистить();
			ЭтаФорма.НастройкиПоиска.Добавить(ЭтаФорма.СтрокаПоиска, "СтрокаПоиска");
			ЭтаФорма.НастройкиПоиска.Добавить(НачалоДня(ЭтаФорма.ПоискДатаОТ), "ПоискДатаОТ");
			ЭтаФорма.НастройкиПоиска.Добавить(КонецДня(ЭтаФорма.ПоискДатаДО), "ПоискДатаДО");
			Результат = Новый Структура("МассивНайденныхНовостей, НастройкиПоиска",
				МассивНайденныхНовостей,
				ЭтаФорма.НастройкиПоиска);
			ЭтаФорма.Закрыть(Результат);
		ИначеЕсли Результат = КодВозвратаДиалога.Отмена Тогда
			ЭтаФорма.Закрыть(Результат);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти
