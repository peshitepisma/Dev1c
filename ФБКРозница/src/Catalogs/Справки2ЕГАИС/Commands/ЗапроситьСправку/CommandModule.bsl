
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Операция", ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЗапросСправки2"));
	
	ОткрытьФорму(
		"ОбщаяФорма.ФормированиеИсходящегоЗапросаЕГАИС",
		ПараметрыФормы,
		ЭтотОбъект,,,,,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти