#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Печать

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ТранспортнаяНакладная") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
						КоллекцияПечатныхФорм,
						"ТранспортнаяНакладная", НСтр("ru = 'Транспортная накладная'"),
						СформироватьПечатнуюФормуТранспортнойНакладной(МассивОбъектов, ОбъектыПечати));
	КонецЕсли;
	
	ФормированиеПечатныхФорм.ЗаполнитьПараметрыОтправки(ПараметрыВывода.ПараметрыОтправки, МассивОбъектов, КоллекцияПечатныхФорм);
	
КонецПроцедуры

Функция СформироватьПечатнуюФормуТранспортнойНакладной(МассивОбъектов, ОбъектыПечати, КомплектыПечати = Неопределено) Экспорт
	
	ТипДокументов = ТипЗнч(МассивОбъектов[0]);

	Если ТипДокументов <> Тип("ДокументСсылка.ТранспортнаяНакладная") Тогда 
		
		СтруктураВозврата = УправлениеПечатьюУТВызовСервера.ПолучитьТранспортныеНакладныеНаПечать(МассивОбъектов);
		ТранспортныеНакладныеНаПечать = СтруктураВозврата.ТранспортныеНакладныеНаПечать;
		
		Для Каждого Документ Из СтруктураВозврата.МассивДокументовБезНакладных Цикл
			
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Для документа %1 не создана ""Транспортная накладная"". Печать документа ""Транспортная накладная"" невозможна.'"),
					Документ);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					Текст,
					Документ)
					
		КонецЦикла	
			
	Иначе
		ТранспортныеНакладныеНаПечать = МассивОбъектов;	
	КонецЕсли;
	
	ТаблицаНакладныхНаПечать = Новый ТаблицаЗначений;
	ОписаниеТипаТранспортнаяНакладная = Новый ОписаниеТипов("ДокументСсылка.ТранспортнаяНакладная");
	ОписаниеТипаЧисло = Новый ОписаниеТипов("Число");
	ТаблицаНакладныхНаПечать.Колонки.Добавить("ТранспортнаяНакладная", ОписаниеТипаТранспортнаяНакладная);
	ТаблицаНакладныхНаПечать.Колонки.Добавить("ПорядковыйНомер", ОписаниеТипаЧисло);
	
	ПорядковыйНомер = 0;
	Для Каждого Накладная Из ТранспортныеНакладныеНаПечать Цикл 
		СтрокаТаблицы = ТаблицаНакладныхНаПечать.Добавить();	
		СтрокаТаблицы.ТранспортнаяНакладная = Накладная;
		СтрокаТаблицы.ПорядковыйНомер = ПорядковыйНомер;
		ПорядковыйНомер = ПорядковыйНомер  + 1;
	КонецЦикла;
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.АвтоМасштаб = Истина;
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ТРАНСПОРТНАЯ_НАКЛАДНАЯ";
		
	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени("Документ.ТранспортнаяНакладная");
	ДанныеДляПечати = МенеджерОбъекта.ПолучитьДанныеДляПечатнойФормыТранспортнаяНакладная(ТаблицаНакладныхНаПечать);
		
	ЗаполнитьТабличныйДокументТН(
			ТабличныйДокумент,
			ДанныеДляПечати,
			ОбъектыПечати,
			КомплектыПечати);

	Возврат ТабличныйДокумент;
	
КонецФункции

Процедура ЗаполнитьТабличныйДокументТН(ТабличныйДокумент, СтруктураДанных, ОбъектыПечати, КомплектыПечати)
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Обработка.ПечатьТранспортнойНакладной.ПФ_MXL_ТранспортнаяНакладная");
	
	ТаблицаДанныхДляПечати = СтруктураДанных.ТаблицаРезультата;
	ДанныеСсылкиДокументов = СтруктураДанных.РезультатИменаТоваров.Выбрать();
		
	ПервыйДокумент = Истина;
	
	Для Каждого ДанныеПечати Из ТаблицаДанныхДляПечати Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
			
		ПервыйДокумент    = Ложь;
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// Если ТТН с доставкой и нашли связанные с доставкой ошибки - перейдем к следующему документу
		СтруктураЗаданиеНаПеревозку = Новый Структура("НеНайденоЗаданиеНаПеревозку,
													  |БолееОдногоВхожденияВЗаданияНаПеревозку,
													  |РаспоряжениеНеПроведено",
													  Ложь,Ложь,Ложь);
		ЕстьОшибкиДоставки = Ложь;
		ЗаполнитьЗначенияСвойств(СтруктураЗаданиеНаПеревозку,ДанныеПечати);
		
		Если СтруктураЗаданиеНаПеревозку.НеНайденоЗаданиеНаПеревозку Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Для документа %1 не найдено задание на перевозку. 
					|Печать формы 1-Т для документов с доставкой возможна после включения документа в задание на перевозку.'"),
				ДанныеПечати.Ссылка);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				ДанныеПечати.Ссылка);
			ЕстьОшибкиДоставки = Истина;
		КонецЕсли;
		
		Если СтруктураЗаданиеНаПеревозку.БолееОдногоВхожденияВЗаданияНаПеревозку Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Невозможно напечатать форму 1-Т для %1, т.к. найдено более одного задания на перевозку, 
					|в которые включен этот документ.'"),
				ДанныеПечати.Ссылка);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				ДанныеПечати.Ссылка);
			ЕстьОшибкиДоставки = Истина;
		КонецЕсли;
		
		Если СтруктураЗаданиеНаПеревозку.РаспоряжениеНеПроведено Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Документ %1 не проведен. Печать товарно - транспортной накладной не будет выполнена.'"),
				ДанныеПечати.Ссылка);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				ДанныеПечати.Ссылка);
			ЕстьОшибкиДоставки = Истина;
		КонецЕсли;
		
		Если ЕстьОшибкиДоставки Тогда
			Продолжить;
		КонецЕсли;
		
		Если ДанныеПечати.ЕстьНепроведенныеДокументыОснования Тогда
			
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'В документе %1 присутствуют непроведенные документы-основания. Печать транспортной накладной невозможна.'"),
				ДанныеПечати.Ссылка);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				ДанныеПечати.Ссылка);
				
			Продолжить;
			
		КонецЕсли;
				
		ОбластьМакета = Макет.ПолучитьОбласть("ГоризонтальнаяЛицеваяСторона");
		ШтрихкодированиеПечатныхФорм.ВывестиШтрихкодВТабличныйДокумент(ТабличныйДокумент, Макет, ОбластьМакета, ДанныеПечати.Ссылка);
		
		ОбластьМакетаОборотная = Макет.ПолучитьОбласть("ГоризонтальнаяОборотнаяСторона");
		
		СведенияОГрузополучателе  = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ДанныеПечати.Грузополучатель,  ДанныеПечати.Дата);
		СведенияОГрузоотправитель = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ДанныеПечати.Грузоотправитель, ДанныеПечати.Дата);
		СведенияОПеревозчике      = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ДанныеПечати.Перевозчик, ДанныеПечати.Дата);
		СведенияОВодителе         = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ДанныеПечати.Водитель, ДанныеПечати.Дата);
		
		ПредставлениеГрузоотправителя = "";
		ПредставлениеПеревозчика      = "";
		Перевозчик                    = "";
		Грузоотправитель              = "";
		
		РеквизитыМакета = Новый Структура;
		
		Если ЗначениеЗаполнено(ДанныеПечати.Грузополучатель) Тогда 
			Если СведенияОГрузополучателе.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ФизЛицо
				Или СведенияОГрузополучателе.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ИндивидуальныйПредприниматель Тогда
				РеквизитыМакета.Вставить("Пункт2_1", ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОГрузополучателе, 
					"ПолноеНаименование,ИНН,ЮридическийАдрес"));
			Иначе
				РеквизитыМакета.Вставить("Пункт2_2", ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОГрузополучателе, 
					"ПолноеНаименование,ЮридическийАдрес,Телефоны"));
			КонецЕсли;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ДанныеПечати.Грузоотправитель) Тогда 
			Если СведенияОГрузоотправитель.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ФизЛицо
			 Или СведенияОГрузоотправитель.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ИндивидуальныйПредприниматель Тогда
				ПредставлениеГрузоотправителя = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОГрузоотправитель, 
					"ПолноеНаименование,ИНН,ЮридическийАдрес");
				РеквизитыМакета.Вставить("Пункт1_1", ПредставлениеГрузоотправителя);
				Грузоотправитель = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОГрузоотправитель, "ПолноеНаименование");
			Иначе
				ПредставлениеГрузоотправителя = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОГрузоотправитель, 
					"ПолноеНаименование,ЮридическийАдрес,Телефоны");
				РеквизитыМакета.Вставить("Пункт1_2", ПредставлениеГрузоотправителя);
				Грузоотправитель = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОГрузоотправитель, "ПолноеНаименование");
			КонецЕсли;
		КонецЕсли;

		
		СтруктураПоиска = Новый Структура("ПорядковыйНомер", ДанныеПечати.ПорядковыйНомер);
		
		ИменаТоваров = "";
		Пока ДанныеСсылкиДокументов.НайтиСледующий(СтруктураПоиска) Цикл								
			ИменаТоваров = ИменаТоваров + ДанныеСсылкиДокументов.НаименованиеВидаНоменклатуры + ", ";
		КонецЦикла;			
		
		Если СтрДлина(ИменаТоваров) >= 2 Тогда
			ИменаТоваров = Лев(ИменаТоваров, СтрДлина(ИменаТоваров) - 2);
		КонецЕсли;
		
		РеквизитыМакета.Вставить("Пункт3_1", ИменаТоваров);
		РеквизитыМакета.Вставить("Пункт6_1", ДанныеПечати.ПунктПогрузки);
		РеквизитыМакета.Вставить("Пункт7_1", ДанныеПечати.ПунктРазгрузки);
		
		МассаБруттоСтрока = НСтр("ru = '%МассаБрутто% кг'");
		МассаБруттоСтрока = СтрЗаменить(МассаБруттоСтрока, "%МассаБрутто%", ДанныеПечати.МассаБрутто);
		
		РеквизитыМакета.Вставить("Пункт6_5", МассаБруттоСтрока);
		
		ОбластьМакета.Параметры.Заполнить(РеквизитыМакета);
		
		ТабличныйДокумент.Вывести(ОбластьМакета);
		ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		
		РеквизитыМакета.Очистить();
		
		Если ЗначениеЗаполнено(ДанныеПечати.Перевозчик) Тогда 
			Если СведенияОПеревозчике.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ФизЛицо
			 Или СведенияОПеревозчике.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ИндивидуальныйПредприниматель Тогда
				ПредставлениеПеревозчика = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОПеревозчике, 
					"ПолноеНаименование,ФактическийАдрес,Телефоны");
				Перевозчик = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОПеревозчике, "ПолноеНаименование");
				РеквизитыМакета.Вставить("Пункт10_1", ПредставлениеПеревозчика);
			Иначе
				ПредставлениеПеревозчика = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОПеревозчике, 
					"ПолноеНаименование,ИНН,ФактическийАдрес,Телефоны");
				Перевозчик = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОПеревозчике, "ПолноеНаименование");
				РеквизитыМакета.Вставить("Пункт10_2", ПредставлениеПеревозчика);
			КонецЕсли;
		КонецЕсли;
		
		ПредставлениеВодителя = ФизическиеЛицаУТ.ФамилияИнициалыФизЛица(ДанныеПечати.Водитель, ДанныеПечати.Дата);
		
		РеквизитыМакета.Вставить("Пункт10_3", ПредставлениеВодителя);
		
		ГрузоподъемностьВТоннахАвтомобиля      = Формат(ДанныеПечати.ГрузоподъемностьВТоннахАвтомобиля,"");
		ВместимостьВКубическихМетрахАвтомобиля = Формат(ДанныеПечати.ВместимостьВКубическихМетрахАвтомобиля,"");
		
		ИнформацияОбАвтомобиле = ""
			+ ?(ПустаяСтрока(ДанныеПечати.ТипАвтомобиля),"",Строка(ДанныеПечати.ТипАвтомобиля) + ", ")
			+ ?(ПустаяСтрока(ДанныеПечати.МаркаАвтомобиля),"",ДанныеПечати.МаркаАвтомобиля  + ", ")
			+ ?(ПустаяСтрока(ГрузоподъемностьВТоннахАвтомобиля),"",ГрузоподъемностьВТоннахАвтомобиля + " " + НСтр("ru = 'т'")  + ", ")
			+ ?(ПустаяСтрока(ВместимостьВКубическихМетрахАвтомобиля),"",ВместимостьВКубическихМетрахАвтомобиля + " " + НСтр("ru = 'куб. м'"));
		
		ИнформацияОбАвтомобиле = СокрЛП(ИнформацияОбАвтомобиле);
		
		Пока Прав(ИнформацияОбАвтомобиле,1) = "," Цикл
			ИнформацияОбАвтомобиле = Лев(ИнформацияОбАвтомобиле, СтрДлина(ИнформацияОбАвтомобиле)-1)
		КонецЦикла;
		
		РеквизитыМакета.Вставить("Пункт11_1", ИнформацияОбАвтомобиле);
		РеквизитыМакета.Вставить("Пункт11_2", ДанныеПечати.ГосНомерАвтомобиля);
		
		СведенияОЗаказчикеПеревозок = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ДанныеПечати.ЗаказчикПеревозки, ДанныеПечати.Дата,,ДанныеПечати.БанковскийСчетЗаказчикаПеревозки);

		РеквизитыМакета.Вставить("Пункт15_6", ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОЗаказчикеПеревозок, 
			"ПолноеНаименование,ФактическийАдрес,Телефоны,НомерСчета,Банк,БИК,КоррСчет"));
				
		РеквизитыМакета.Вставить("Пункт16_1", Грузоотправитель);
		РеквизитыМакета.Вставить("Пункт16_2", Перевозчик);
		
		РеквизитыМакета.Вставить("Пункт16_11", ДанныеПечати.Дата);
		РеквизитыМакета.Вставить("Пункт16_21", ДанныеПечати.Дата);
		
		ОбластьМакетаОборотная.Параметры.Заполнить(РеквизитыМакета);
		
		ТабличныйДокумент.Вывести(ОбластьМакетаОборотная);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ДанныеПечати.Ссылка);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
