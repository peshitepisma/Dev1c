#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура;
	ОткрытьФорму("Справочник.УсловияОбслуживанияПартнеровТорговымиПредставителями.Форма.ГрупповоеНазначениеУсловий",
					ПараметрыФормы,
					ПараметрыВыполненияКоманды.Источник,
					ПараметрыВыполненияКоманды.Уникальность,
					ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

#КонецОбласти