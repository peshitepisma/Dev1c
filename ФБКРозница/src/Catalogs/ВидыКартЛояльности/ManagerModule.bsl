#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Получает реквизиты объекта, которые необходимо блокировать от изменения.
//
// Возвращаемое значение:
//  Массив - блокируемые реквизиты объекта.
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт

	Результат = Новый Массив;
	Результат.Добавить("ДатаНачалаДействия");
	Результат.Добавить("ДатаОкончанияДействия; УстановитьИнтервал");
	Результат.Добавить("Персонализирована; ТипПерсонализации");
	Результат.Добавить("АвтоматическаяРегистрацияПриПервомСчитывании; ПорядокАктивации");
	Результат.Добавить("ТипКарты");
	Результат.Добавить("ШаблоныКодовКартЛояльности");
	Результат.Добавить("БонуснаяПрограммаЛояльности");
	
	Возврат Результат;

КонецФункции

//Возвращает имена реквизитов, которые не должны отображаться в списке реквизитов обработки ГрупповоеИзменениеОбъектов.
//
// Возвращаемое значение:
//  Массив - массив имен реквизитов.
//
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	НеРедактируемыеРеквизиты = Новый Массив;
	НеРедактируемыеРеквизиты.Добавить("ДатаНачалаДействия");
	НеРедактируемыеРеквизиты.Добавить("ДатаОкончанияДействия");
	НеРедактируемыеРеквизиты.Добавить("Персонализирована");
	НеРедактируемыеРеквизиты.Добавить("АвтоматическаяРегистрацияПриПервомСчитывании");
	НеРедактируемыеРеквизиты.Добавить("ТипКарты");
	
	Возврат НеРедактируемыеРеквизиты;
	
КонецФункции

#КонецОбласти

#КонецЕсли