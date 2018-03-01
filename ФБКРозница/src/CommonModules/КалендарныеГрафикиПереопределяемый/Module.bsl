#Область ПрограммныйИнтерфейс

// Вызывается при изменении данных производственных календарей.
// В случае, если разделение включено, выполняется в не разделенном режиме.
//
// Параметры:
//	УсловияОбновления - ТаблицаЗначений - таблица с колонками:
//		* КодПроизводственногоКалендаря - Строка - код производственного календаря, данные которого изменились;
//		* Год                           - Число  - календарный год, за который изменились данные.
//
Процедура ПриОбновленииПроизводственныхКалендарей(УсловияОбновления) Экспорт
КонецПроцедуры

// Вызывается при изменении данных, зависимых от производственных календарей.
// В случае, если разделение включено, выполняется в областях данных.
//
// Параметры:
//	УсловияОбновления - ТаблицаЗначений - таблица с колонками:
//		* КодПроизводственногоКалендаря - Строка - код производственного календаря, данные которого изменились;
//		* Год                           - Число  - календарный год, за который изменились данные.
//
Процедура ПриОбновленииДанныхЗависимыхОтПроизводственныхКалендарей(УсловияОбновления) Экспорт
КонецПроцедуры

// Вызывается при регистрации отложенного обработчика обновления данных, зависимых от производственных календарей.
// В БлокируемыеОбъекты следует добавить имена метаданных объектов, 
// которые следует заблокировать от использования на период обновления производственных календарей.
//
// Параметры:
//	БлокируемыеОбъекты - Массив - имена метаданных блокируемых объектов.
//
Процедура ПриЗаполненииБлокируемыхОбъектовЗависимыхОтПроизводственныхКалендарей(БлокируемыеОбъекты) Экспорт
	
КонецПроцедуры

#КонецОбласти
