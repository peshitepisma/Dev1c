
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура("Основание", Новый Структура("МассивВедомостей", ПараметрКоманды));
	
	ОткрытьФорму("Документ.ЗаявкаНаРасходованиеДенежныхСредств.ФормаОбъекта", ПараметрыФормы);
	
КонецПроцедуры

