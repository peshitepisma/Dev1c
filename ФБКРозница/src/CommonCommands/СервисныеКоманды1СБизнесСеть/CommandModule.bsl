
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОчиститьСообщения();
	ФормаПодключения = "Обработка.БизнесСеть.Форма.НастройкаПодключения";
	ОткрытьФорму(ФормаПодключения);
	
КонецПроцедуры

#КонецОбласти
