////////////////////////////////////////////////////////////////////////////////
// Обработки.ОблачныйАрхив.Команды.СозданиеРезервнойКопии: Модуль объекта.
//
////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)

	ИмяФормы = "Обработка.ОблачныйАрхив.Форма.МастерСозданияРезервнойКопии"; // Идентификатор

	ОткрытьФорму(
		ИмяФормы,
		Новый Структура,
		ПараметрыВыполненияКоманды.Источник,
		ИмяФормы + ?(ПараметрыВыполненияКоманды.Окно = Неопределено, ".ОтдельноеОкно", ""),
		ПараметрыВыполненияКоманды.Окно);

КонецПроцедуры

#КонецОбласти
