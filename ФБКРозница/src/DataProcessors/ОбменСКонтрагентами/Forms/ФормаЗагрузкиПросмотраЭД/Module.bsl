
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураЭД = "";
	НаправлениеЭД = "";
	Если Параметры.Свойство("СтруктураЭД", СтруктураЭД) И ТипЗнч(СтруктураЭД) = Тип("Структура")
		И СтруктураЭД.Свойство("НаправлениеЭД", НаправлениеЭД) Тогда
		
		ЗагрузкаЭД = (НаправлениеЭД = Перечисления.НаправленияЭД.Входящий);
		
		СтруктураЭД.Свойство("ВладелецЭД", ДокументИБ);
		Если ЗагрузкаЭД Тогда
			СсылкаНаЗаполняемыйДокумент = "";
			Если СтруктураЭД.Свойство("СсылкаНаДокумент", СсылкаНаЗаполняемыйДокумент)
				И ЗначениеЗаполнено(СсылкаНаЗаполняемыйДокумент) Тогда
				СпособЗагрузкиДокумента = 1;
			КонецЕсли;
		КонецЕсли;
		ВыполнитьПросмотрЭДСервер(СтруктураЭД, Отказ);
	КонецЕсли;
	
	ЭлектронныйДокумент = Неопределено;
	Если Параметры.Свойство("ЭлектронныйДокумент", ЭлектронныйДокумент) Тогда
		ЗагрузкаЭД = Ложь;
		Параметры.Свойство("ВладелецЭД", ДокументИБ);
		ДанныеЭД = ФайлДанныхЭД(ЭлектронныйДокумент);
		Если ДанныеЭД = Неопределено Тогда
			Возврат;
		КонецЕсли;
		Если ТипЗнч(ДанныеЭД) = Тип("ТабличныйДокумент") Тогда
			ТабличныйДокументФормы = ДанныеЭД;
		КонецЕсли;
	КонецЕсли;
	
	ИзменитьВидимостьДоступностьПриСозданииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
 	ИзменитьВидимостьДоступность();
	
	Если ЭтоАдресВременногоХранилища(АдресСтруктурыРазбораЭД) И ЗначениеЗаполнено(РасширениеФайла) Тогда
		#Если ВебКлиент Тогда
			ПутьКФайлуПросмотра = АдресСтруктурыРазбораЭД;
		#Иначе
			ПутьКФайлуПросмотра = ПолучитьИмяВременногоФайла(РасширениеФайла);
			ДДФайла = ПолучитьИзВременногоХранилища(АдресСтруктурыРазбораЭД);
			ДДФайла.Записать(ПутьКФайлуПросмотра);
		#КонецЕсли
		Если СтрНайти("HTML PDF DOCX XLSX", ВРег(РасширениеФайла)) > 0 Тогда
			
			СформироватьТекстСлужебногоСообщения();
			
			Элементы.Панель.ТекущаяСтраница = Элементы.ПросмотрЭД;
			
		Иначе
			#Если НЕ ВебКлиент Тогда
				ЗапуститьПриложение(ПутьКФайлуПросмотра);
			#КонецЕсли
			Отказ = Истина;
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Элементы.КомандаОтображатьДополнительнуюИнформацию.Пометка = Не ОтключитьВыводДопДанных;
	Элементы.КомандаОтображатьОбластьКопияВерна.Пометка = Не ОтключитьВыводКопияВерна;
	СкрытьДополнительныеДанные();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СпособЗагрузкиДокументаПриИзменении(Элемент)
	
	ИзменитьВидимостьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура СпособЗагрузкиСправочникаПриИзменении(Элемент)
	
	ИзменитьВидимостьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ТипОбъектаПриИзменении(Элемент)
	
	ОбработатьВыборТипаОбъекта();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокТиповСправочниковПриИзменении(Элемент)
	
	ОбработатьВыборТипаОбъекта();
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументИБНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ДокументИБ = Неопределено Тогда
		ТекЭлемент = Неопределено;
		Если ЗначениеЗаполнено(ТипОбъекта) Тогда
			Для Каждого ЭлементСписка Из СписокТипов Цикл
				Если ТипОбъекта = ЭлементСписка.Представление Тогда
					ДокументИБ = ЭлементСписка.Значение;
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьДействие(Команда)
	
	Если ЗагрузкаЭД И ЗначениеЗаполнено(ИмяОбъектаМетаданных) Тогда
		
		ОчиститьСообщения();
		Если ВРег(ВидЭД) = ВРег("РеквизитыОрганизации") Тогда
			ЗагрузитьРеквизитыОрганизации();
		Иначе
			ЗагрузитьДокументЭДО();
		КонецЕсли;
		
	ИначеЕсли ВидЭД = ПредопределенноеЗначение("Перечисление.ВидыЭД.КаталогТоваров") Тогда
		
		ЗагрузитьКаталогТоваров();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьДействиеЗавершение(СсылкаНаОбъект = Неопределено, Отказ = Ложь)
	
	Если ЗначениеЗаполнено(СсылкаНаОбъект) Тогда
		ОповеститьОбИзменении(СсылкаНаОбъект);
	КонецЕсли;
	
	Если НЕ Отказ Тогда
		ЭтотОбъект.Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтображатьДополнительнуюИнформацию(Команда)
	
	ОтключитьВыводДопДанных = Не ОтключитьВыводДопДанных;
	СкрытьДополнительныеДанные();
	ОбновитьОтображениеДанных();
	Элементы.КомандаОтображатьДополнительнуюИнформацию.Пометка = Не ОтключитьВыводДопДанных;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтображатьОбластьКопияВерна(Команда)
	
	ОтключитьВыводКопияВерна = Не ОтключитьВыводКопияВерна;
	СкрытьДополнительныеДанные();
	ОбновитьОтображениеДанных();
	Элементы.КомандаОтображатьОбластьКопияВерна.Пометка = Не ОтключитьВыводКопияВерна;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция СоздатьОбъектыИБ(АдресВременногоХранилища, ОшибкаЗаписи)
	
	Перем ДеревоРазбора;
	
	СтруктураРазбора = ПолучитьИзВременногоХранилища(АдресВременногоХранилища);
	
	Если СтруктураРазбора <> Неопределено И СтруктураРазбора.Свойство("ДеревоРазбора", ДеревоРазбора) Тогда
		// Заполним ссылки на объекты из дерева соответствий, если ссылок нет, тогда будем создавать объекты.
		ОбменСКонтрагентамиВнутренний.ЗаполнитьСсылкиНаОбъектыВДереве(ДеревоРазбора, ОшибкаЗаписи);
	КонецЕсли;
	
КонецФункции

&НаСервереБезКонтекста
Функция СохранитьДанныеОбъектаВБД(АдресВременногоХранилища)
	
	СтруктураРазбора = ПолучитьИзВременногоХранилища(АдресВременногоХранилища);
	
	Если СтруктураРазбора <> Неопределено И СтруктураРазбора.Свойство("ДеревоРазбора") Тогда
		ОбменСКонтрагентамиПереопределяемый.СохранитьДанныеОбъектаВБД(
										СтруктураРазбора.СтрокаОбъекта,
										СтруктураРазбора.ДеревоРазбора);
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура СопоставитьНоменклатуру(ОбработчикОповещения)
	
	ЗначениеВозврата = Неопределено;
	СтруктураЭД = Новый Структура;
	СтруктураЭД.Вставить("ВидЭД", ВидЭД);
	СтруктураЭД.Вставить("СпособОбменаЭД",		ПредопределенноеЗначение("Перечисление.СпособыОбменаЭД.БыстрыйОбмен"));
	СтруктураЭД.Вставить("Контрагент", 			Контрагент);
	СтруктураЭД.Вставить("ДанныеФайлаРазбора",	ДанныеФайлаРазбора);
	СтруктураЭД.Вставить("НаправлениеЭД",		ПредопределенноеЗначение("Перечисление.НаправленияЭД.Входящий"));
	СтруктураЭД.Вставить("ВладелецФайла",		?(СпособЗагрузкиДокумента = 0, Неопределено, ДокументИБ));
	
	СтруктураПараметров = ОбменСКонтрагентамиСлужебныйВызовСервера.ПолучитьПараметрыФормыСопоставленияНоменклатуры(СтруктураЭД);
	Если ЗначениеЗаполнено(СтруктураПараметров) Тогда
		ОткрытьФорму(СтруктураПараметров.ИмяФормы, СтруктураПараметров.ПараметрыОткрытияФормы,,,,, ОбработчикОповещения);
	Иначе
		ЗагрузитьДокументВИБ(Истина);
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВидимостьДоступность()
	
	Если ВРег(ВидЭД) = ВРег("РеквизитыОрганизации") Тогда
		
		Элементы.ЭлементСправочникаИБ.Доступность = (СпособЗагрузкиДокумента = 1);
		
	Иначе	
		Если ЗагрузкаЭД Тогда
			Элементы.ДокументИБ.Доступность = (СпособЗагрузкиДокумента = 1);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьВидимостьДоступностьПриСозданииНаСервере()
	
	Элементы.ГруппаСодержимоеДокумента.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	
	Если ЗагрузкаЭД Тогда
		
		Элементы.ГруппаКнопок.Видимость = Истина;
		Элементы.ГруппаГиперссылка.Видимость = Ложь;

		Если ВРег(ВидЭД) = ВРег("РеквизитыОрганизации") Тогда
			
			Заголовок = НСтр("ru = 'Загрузка данных из файла'");
			
			Элементы.ГруппаНастроекСправочники.Видимость = Истина;
			Элементы.ГруппаНастроекДокументы.Видимость = Ложь;
		Иначе
			
			Заголовок = НСтр("ru = 'Загрузка документа из файла'");
			
			Элементы.ГруппаНастроекСправочники.Видимость = Ложь;
			Элементы.ГруппаНастроекДокументы.Видимость = Истина;
		КонецЕсли;
		
	Иначе
		Текст = НСтр("ru = 'Электронный документ'");
		Заголовок = Текст;
		Элементы.ГруппаНастроекСправочники.Видимость = Ложь;
		Элементы.ГруппаНастроекДокументы.Видимость = Ложь;
		Элементы.ГруппаКнопок.Видимость = Ложь;
		Элементы.ГруппаГиперссылка.Видимость = Истина;
	КонецЕсли;
	
	Если ВидЭД = Перечисления.ВидыЭД.КаталогТоваров Тогда
		Элементы.ГруппаПраво.Видимость = Ложь;
		Элементы.ТипОбъекта.Заголовок = НСтр("ru = 'Загрузить'");
		ТипОбъекта = НСтр("ru = 'Каталог товаров'");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьПросмотрЭДСервер(СтруктураЭД, Отказ)
	
	Перем ПереЗаполняемыйДокумент, ДеревоРазбора, СтрокаОбъекта;
	
	ФайлПросмотра = Неопределено;
	ИмяФайлаКартинок = Неопределено;
	ФайлДопДанных = Неопределено;
	ПоддерживаемыеКодыТранзакций = Новый Массив;
	ПоддерживаемыеКодыТранзакций.Добавить("MainDocument");
	ПоддерживаемыеКодыТранзакций.Добавить("VendorTitle");
	ПоддерживаемыеКодыТранзакций.Добавить("Invoice");
	
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(СтруктураЭД.АдресХранилища);
	
	Если СтруктураЭД.ФайлАрхива Тогда
		ПапкаДляРаспаковки = ЭлектронноеВзаимодействиеСлужебный.РабочийКаталог("ext", СтруктураЭД.УникальныйИдентификатор);
		ИмяФайлаАрхива = ОбменСКонтрагентамиСлужебный.ТекущееИмяВременногоФайла("zip");
		ДвоичныеДанные.Записать(ИмяФайлаАрхива);
		
		ЭлектронноеВзаимодействиеСлужебный.УдалитьВременныеФайлы(ПапкаДляРаспаковки, "*");
		
		ЧтениеЗИП = Новый ЧтениеZIPФайла(ИмяФайлаАрхива);
		Попытка
			ЧтениеЗИП.ИзвлечьВсе(ПапкаДляРаспаковки);
		Исключение
			ТекстОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
			Если НЕ ЭлектронноеВзаимодействиеСлужебный.ВозможноИзвлечьФайлы(ЧтениеЗИП, ПапкаДляРаспаковки) Тогда
				ТекстСообщения = ЭлектронноеВзаимодействиеСлужебныйПовтИсп.ПолучитьСообщениеОбОшибке("006");
			КонецЕсли;
			ЭлектронноеВзаимодействиеСлужебныйВызовСервера.ОбработатьОшибку(НСтр("ru = 'Распаковка архива ЭД'"),
			ТекстОшибки, ТекстСообщения);
			
			ЭлектронноеВзаимодействиеСлужебный.УдалитьВременныеФайлы(ИмяФайлаАрхива);
			ЭлектронноеВзаимодействиеСлужебный.УдалитьВременныеФайлы(ПапкаДляРаспаковки);
			Возврат;
		КонецПопытки;
		
		ЭлектронноеВзаимодействиеСлужебный.УдалитьВременныеФайлы(ИмяФайлаАрхива);
		
		// скопируем файл просмотра
		МассивФайловПросмотра = НайтиФайлы(ПапкаДляРаспаковки, "*.pdf", Истина);
		Если МассивФайловПросмотра.Количество() > 0 Тогда
			ФайлПросмотра = МассивФайловПросмотра[0];
		КонецЕсли;
		
		// Расшифровать файл с данными
		МассивФайлИнформации = НайтиФайлы(ПапкаДляРаспаковки, "meta*.xml", Истина);
		Если МассивФайлИнформации.Количество() > 0 Тогда
			ФайлИнформации = МассивФайлИнформации[0];
		КонецЕсли;
		
		МассивФайлКарточки = НайтиФайлы(ПапкаДляРаспаковки, "card*.xml", Истина);
		Если МассивФайлКарточки.Количество() > 0 Тогда
			ФайлКарточки = МассивФайлКарточки[0];
		КонецЕсли;
		
		// скопируем файл просмотра
		МассивФайловКартинок = НайтиФайлы(ПапкаДляРаспаковки, "*.zip", Истина);
		Если МассивФайловКартинок.Количество() > 0 Тогда
			ФайлКартинок = МассивФайловКартинок[0];
			ИмяФайлаКартинок = ФайлКартинок.ПолноеИмя;
		КонецЕсли;
		
		Если ФайлКарточки = Неопределено Или ФайлИнформации = Неопределено Тогда
			
			ШаблонСообщения = НСтр("ru = 'Возникла ошибка при чтении данных из файла ""%1"".'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, СтруктураЭД.ИмяФайла);
			
			ШаблонСообщения = НСтр("ru = 'Файл ""%1"" не содержит электронных документов.'");
			ПредставлениеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, СтруктураЭД.ИмяФайла);
			ЭлектронноеВзаимодействиеСлужебныйВызовСервера.ОбработатьОшибку(НСтр("ru = 'Чтение ЭД.'"),
			ПредставлениеОшибки,
			ТекстСообщения);
			ЭлектронноеВзаимодействиеСлужебный.УдалитьВременныеФайлы(ПапкаДляРаспаковки);
			Отказ = Истина;
			Возврат;
			
		КонецЕсли;
		
		СоответствиеФайлПараметры = ОбменСКонтрагентамиВнутренний.ПараметрыФайловЭДО(ФайлИнформации, ФайлКарточки);
		СообщениеОбОшибке = "";
		Для Каждого ЭлементСоответствия Из СоответствиеФайлПараметры Цикл
			Если ПоддерживаемыеКодыТранзакций.Найти(ЭлементСоответствия.Значение.КодТранзакции) = Неопределено Тогда
				СообщениеОбОшибке = НСтр("ru = 'Загрузка документов данного вида невозможна. Поддерживается только загрузка первичных документов (титул продавца / исполнителя, произвольный документ).'");
				Продолжить;
			КонецЕсли;
			МассивФайловИсточник = НайтиФайлы(ПапкаДляРаспаковки, ЭлементСоответствия.Ключ, Истина);
			Если МассивФайловИсточник.Количество() > 0 Тогда
				
				Если МассивФайловИсточник[0].Расширение = ".zip" Тогда
					
					ПапкаДляРаспаковкиФайлаЭД = ЭлектронноеВзаимодействиеСлужебный.РабочийКаталог("ext", УникальныйИдентификатор);
					ИмяФайлаАрхива = МассивФайловИсточник[0].ПолноеИмя;
					ЭлектронноеВзаимодействиеСлужебный.УдалитьВременныеФайлы(ПапкаДляРаспаковкиФайлаЭД, "*");
					
					ЧтениеЗИП = Новый ЧтениеZIPФайла(ИмяФайлаАрхива);
					Попытка
						ЧтениеЗИП.ИзвлечьВсе(ПапкаДляРаспаковкиФайлаЭД);
					Исключение
						ТекстОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
						Если НЕ ЭлектронноеВзаимодействиеСлужебный.ВозможноИзвлечьФайлы(ЧтениеЗИП, ПапкаДляРаспаковкиФайлаЭД) Тогда
							ТекстСообщения = ЭлектронноеВзаимодействиеСлужебныйПовтИсп.ПолучитьСообщениеОбОшибке("006");
						КонецЕсли;
						ЭлектронноеВзаимодействиеСлужебныйВызовСервера.ОбработатьОшибку(НСтр("ru = 'Распаковка архива ЭД'"),
							ТекстОшибки, ТекстСообщения);
						
						ЭлектронноеВзаимодействиеСлужебный.УдалитьВременныеФайлы(ПапкаДляРаспаковкиФайлаЭД);
						Возврат;
					КонецПопытки;
					
					// скопируем файл просмотра
					МассивФайловИсточник = НайтиФайлы(ПапкаДляРаспаковкиФайлаЭД, "*.xml", Истина);
				КонецЕсли;
				ИмяФайла = ОбменСКонтрагентамиСлужебный.ТекущееИмяВременногоФайла("xml");
				КопироватьФайл(МассивФайловИсточник[0].ПолноеИмя, ИмяФайла);
				
			КонецЕсли;
			
			ДопДанные = Неопределено;
			Если ЭлементСоответствия.Значение.Свойство("ДопДанные", ДопДанные) И ТипЗнч(ДопДанные) = Тип("Структура") Тогда
				
				ИмяФайлаДопДанных = Неопределено;
				Если ДопДанные.Свойство("ФайлДопДанных",ИмяФайлаДопДанных) И ЗначениеЗаполнено(ИмяФайлаДопДанных) Тогда
					
					МассивФайловДопДанных = НайтиФайлы(ПапкаДляРаспаковки, ИмяФайлаДопДанных, Истина);
					Если МассивФайловДопДанных.Количество() > 0 Тогда
						
						ФайлДопДанных = ОбменСКонтрагентамиСлужебный.ТекущееИмяВременногоФайла("xml");
						КопироватьФайл(МассивФайловДопДанных[0].ПолноеИмя, ФайлДопДанных);
						
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
	Иначе
		ИмяФайла = ОбменСКонтрагентамиСлужебный.ТекущееИмяВременногоФайла("xml");
		ДвоичныеДанные.Записать(ИмяФайла);
	КонецЕсли;

	Если Не ЗначениеЗаполнено(ИмяФайла) И ЗначениеЗаполнено(СообщениеОбОшибке) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке,,,, Отказ);
	Иначе
		СтруктураЭД.Свойство("СсылкаНаДокумент", ПереЗаполняемыйДокумент);
		
		СтруктураРазбора = ОбменСКонтрагентамиВнутренний.СформироватьДеревоРазбора(ИмяФайла,
																					Перечисления.НаправленияЭД.Входящий,
																					ФайлДопДанных,
																					ИмяФайлаКартинок);
		ДвоичныеДанныеФайлаРазбора = Новый ДвоичныеДанные(ИмяФайла);
		ДанныеФайлаРазбора = ПоместитьВоВременноеХранилище(ДвоичныеДанныеФайлаРазбора, УникальныйИдентификатор);
		
		Если ЗначениеЗаполнено(ФайлДопДанных) Тогда
			ДвоичныеДанныеФайлаДопДанных = Новый ДвоичныеДанные(ФайлДопДанных);
			ДанныеФайлаДопДанных = ПоместитьВоВременноеХранилище(ДвоичныеДанныеФайлаДопДанных, УникальныйИдентификатор);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ИмяФайлаКартинок) Тогда
			ДвоичныеДанныеФайлаКартинок = Новый ДвоичныеДанные(ИмяФайлаКартинок);
			ДанныеФайлаКартинок = ПоместитьВоВременноеХранилище(ДвоичныеДанныеФайлаКартинок, УникальныйИдентификатор);
		КонецЕсли;
		
		ДанныеЭД = Неопределено;
		
		Если ТипЗнч(СтруктураРазбора) = Тип("Структура") Тогда
			
			АдресСтруктурыРазбораЭД = ПоместитьВоВременноеХранилище(СтруктураРазбора, УникальныйИдентификатор);
			
			ПараметрыПечати = Новый Структура;
			ПараметрыПечати.Вставить("ИД", СтруктураЭД.УникальныйИдентификатор);
			
			// Для ответных титулов передадим номер и дату документа ИБ первого титула.
			ПараметрыПечати.Вставить("СвойстваДокументаПервогоТитула",
				Новый Структура("НомерДокументаОтправителя, ДатаДокументаОтправителя"));
			
			ДанныеЭД = ОбменСКонтрагентамиВнутренний.ПечатнаяФормаЭД(СтруктураРазбора, СтруктураЭД.НаправлениеЭД, ПараметрыПечати);
			
			ВидЭД = СтруктураРазбора.СтрокаОбъекта.ВидЭД;
			
		КонецЕсли;
		
		Если ТипЗнч(ДанныеЭД) = Тип("ТабличныйДокумент") Тогда
			
			Если ЗагрузкаЭД Тогда
				Если (НЕ ЗначениеЗаполнено(ДокументИБ) ИЛИ СпособЗагрузкиДокумента = 0) И СтруктураРазбора <> Неопределено
						И СтруктураРазбора.Свойство("ДеревоРазбора", ДеревоРазбора)
						И СтруктураРазбора.Свойство("СтрокаОбъекта", СтрокаОбъекта) Тогда
					ОшибкаЗаписи = Ложь;
					СтрокаДерева = ОбменСКонтрагентамиСлужебный.НайтиСтрокуВДереве(ДеревоРазбора, СтрокаОбъекта, "Контрагент");
					Если СтрокаДерева <> Неопределено Тогда
						Контрагент = СтрокаДерева.СсылкаНаОбъект;
					КонецЕсли;
				КонецЕсли;
				
				ОбменСКонтрагентамиПереопределяемый.СписокТиповДокументовПоВидуЭД(ВидЭД, СписокТипов);
				
				Для Каждого ТекЗначение Из СписокТипов Цикл
					
					ТекЭлемент = Элементы.ТипОбъекта.СписокВыбора.Добавить();
					ТекЭлемент.Значение = ТекЗначение.Представление;
					
					// Если реквизит ДокументИБ еще не заполнен и зачитано первое по списку значение, то заполним имеющимися данными:
					Если НЕ ЗначениеЗаполнено(ДокументИБ) И СписокТипов.Индекс(ТекЗначение) = 0 Тогда
						ТипОбъекта = ТекЗначение.Представление;
						ДокументИБ = ТекЗначение.Значение;
						ИмяОбъектаМетаданных = ТекЗначение.Значение.Метаданные().ПолноеИмя();
					КонецЕсли;
					
					Если ВРег(ВидЭД) = ВРег("РеквизитыОрганизации") Тогда
						Если ЗначениеЗаполнено(Контрагент) Тогда
							ДокументИБ = Контрагент;
							СпособЗагрузкиДокумента = 1;
						КонецЕсли;
					КонецЕсли;
					
					// Если в структуре параметров есть ссылка на (перезаполняемый) документ ИБ и его тип совпал с типом одного из значений
					// списка типов, то заполним этими данными соответствующие реквизиты формы.
					// Данное условие необходимо для корректной обработки ситуации, когда в качестве перезаполняемого документа, выбран
					// документ с типом не совпадающим ни с одним из доступных в списке или не совпадает с типом первого элемента списка.
					Если ЗначениеЗаполнено(ПереЗаполняемыйДокумент) И ТипЗнч(ПереЗаполняемыйДокумент) = ТипЗнч(ТекЗначение.Значение) Тогда
						ТипОбъекта = ТекЗначение.Представление;
						ДокументИБ = ПереЗаполняемыйДокумент;
						ИмяОбъектаМетаданных = ТекЗначение.Значение.Метаданные().ПолноеИмя();
					КонецЕсли;
					
				КонецЦикла;
			КонецЕсли;
			
			Если НЕ ЗначениеЗаполнено(Контрагент) И ЗначениеЗаполнено(ПереЗаполняемыйДокумент) Тогда
				
				ИмяСправочникаКонтрагенты = ИмяСправочника("Контрагенты");
				
				Если Не ЗначениеЗаполнено(ИмяСправочникаКонтрагенты) Тогда
					ИмяСправочникаКонтрагенты = "Контрагенты";
				КонецЕсли;
				
				Если ТипЗнч(ПереЗаполняемыйДокумент) = Тип("СправочникСсылка."+ ИмяСправочникаКонтрагенты) Тогда
					Контрагент = ПереЗаполняемыйДокумент;
				Иначе
					Если ПереЗаполняемыйДокумент.Метаданные().Реквизиты.Найти("Контрагент") <> Неопределено Тогда
						Контрагент = ПереЗаполняемыйДокумент.Контрагент;
					КонецЕсли;
				КонецЕсли;
				
			КонецЕсли;
			
			ТабличныйДокументФормы = ДанныеЭД;
			ИсходныйТабличныйДокумент = ДанныеЭД;
			Элементы.ГруппаСодержимоеДокумента.ТекущаяСтраница = Элементы.СтраницаТабличныйДокумент;
			
		Иначе
			
			Если Не ФайлПросмотра = Неопределено Тогда
				
				
				ПутьКФайлу = ФайлПросмотра.ПолноеИмя;
				РасширениеФайла = СтрЗаменить(ФайлПросмотра.Расширение, ".", "");
				
				ДДФайла = Новый ДвоичныеДанные(ПутьКФайлу);
				
				// Передадим на клиента двоичные данные файла для просмотра:
				АдресСтруктурыРазбораЭД = ПоместитьВоВременноеХранилище(ДДФайла, УникальныйИдентификатор);
				
			КонецЕсли;
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ПапкаДляРаспаковки) Тогда
			ЭлектронноеВзаимодействиеСлужебный.УдалитьВременныеФайлы(ПапкаДляРаспаковки);
		КонецЕсли;
		
		Если СтруктураРазбора = Неопределено
			И ДанныеЭД = Неопределено
			И ПустаяСтрока(АдресСтруктурыРазбораЭД) Тогда 
			Отказ = Истина; // Если нечего открывать, то и форму открывать незачем.
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ИмяСправочника(ИмяСправочника)
	
	ИмяСправочника = ЭлектронноеВзаимодействиеСлужебныйПовтИсп.ИмяПрикладногоСправочника(ИмяСправочника);
	
	Возврат ИмяСправочника;
	
КонецФункции

&НаСервере
Процедура СформироватьДокументИБ(ДокументСсылка, ТекстСообщения, Записывать = Ложь, ОбновитьСтруктуруРазбора = Ложь, Отказ = Ложь)
	
	Перем СтрокаОбъекта, ДеревоРазбора;
	
	// В том случае если номенклатура уже была сопоставлена - пользуемся временным хранилищем,
	// если сопоставляли руками - формируем структуру разбора заново.
	
	Если Не ОбновитьСтруктуруРазбора
		И ЗначениеЗаполнено(АдресСтруктурыРазбораЭД)
		И ЭтоАдресВременногоХранилища(АдресСтруктурыРазбораЭД) Тогда
		
			СтруктураРазбора = ПолучитьИзВременногоХранилища(АдресСтруктурыРазбораЭД);
	Иначе
		ИмяФайла = ПолучитьИмяВременногоФайла("xml");
		ДвоичныеДанныеФайла = ПолучитьИзВременногоХранилища(ДанныеФайлаРазбора);
		ДвоичныеДанныеФайла.Записать(ИмяФайла);
		
		ИмяФайлаДопДанных = Неопределено;
		Если ЭтоАдресВременногоХранилища(ДанныеФайлаДопДанных) Тогда
			ИмяФайлаДопДанных = ПолучитьИмяВременногоФайла("xml");
			ДвоичныеДанныеФайла = ПолучитьИзВременногоХранилища(ДанныеФайлаДопДанных);
			ДвоичныеДанныеФайла.Записать(ИмяФайлаДопДанных);
		КонецЕсли;
		ИмяФайлаКартинок = Неопределено;
		Если ЭтоАдресВременногоХранилища(ДанныеФайлаКартинок) Тогда
			ИмяФайлаКартинок = ПолучитьИмяВременногоФайла("zip");
			ДвоичныеДанныеФайла = ПолучитьИзВременногоХранилища(ДанныеФайлаКартинок);
			ДвоичныеДанныеФайла.Записать(ИмяФайлаКартинок);
		КонецЕсли;
		
		СтруктураРазбора = ОбменСКонтрагентамиВнутренний.СформироватьДеревоРазбора(ИмяФайла, 
			Перечисления.НаправленияЭД.Входящий, ИмяФайлаДопДанных, ИмяФайлаКартинок);
		ЭлектронноеВзаимодействиеСлужебный.УдалитьВременныеФайлы(ИмяФайла);
		
		Если ЗначениеЗаполнено(ИмяФайлаДопДанных) Тогда
			ЭлектронноеВзаимодействиеСлужебный.УдалитьВременныеФайлы(ИмяФайлаДопДанных);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ИмяФайлаКартинок) Тогда
			ЭлектронноеВзаимодействиеСлужебный.УдалитьВременныеФайлы(ИмяФайлаКартинок);
		КонецЕсли;
	КонецЕсли;
	
	Если СтруктураРазбора <> Неопределено И СтруктураРазбора.Свойство("ДеревоРазбора", ДеревоРазбора)
		И СтруктураРазбора.Свойство("СтрокаОбъекта", СтрокаОбъекта) Тогда
		
		ДокументСсылка = ?(СпособЗагрузкиДокумента = 1, ДокументИБ.Ссылка, Неопределено);
		ОбменСКонтрагентамиСлужебный.СформироватьДокумент(ДеревоРазбора, СтрокаОбъекта, ДокументСсылка, Контрагент, Записывать, ТекстСообщения, Отказ);
		
	Иначе
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция МожноЗагрузитьЭДВида(Знач ВидЭД)
	
	МожноЗагрузить = Истина;
	МассивАктуальныхВидовЭД = ОбменСКонтрагентамиПовтИсп.ПолучитьАктуальныеВидыЭД();
	Если МассивАктуальныхВидовЭД.Найти(ВидЭД) = Неопределено
		ИЛИ ВидЭД = Перечисления.ВидыЭД.СчетФактура
		ИЛИ ВидЭД = Перечисления.ВидыЭД.КорректировочныйСчетФактура Тогда
		
		МожноЗагрузить = Ложь;
	КонецЕсли;
	
	Возврат МожноЗагрузить;
	
КонецФункции

&НаСервере
Функция ФайлДанныхЭД(СсылкаНаЭД, Знач ИмяФайлаПодчиненногоЭД = Неопределено)
	
	ПараметрыПросмотра = Новый Структура;
	ПараметрыПросмотра.Вставить("ИмяФайлаПодчиненногоЭД", ИмяФайлаПодчиненногоЭД);
	ПараметрыПросмотра.Вставить("СкрыватьКопияВерна", Истина);
	ТабличныйДокумент = ОбменСКонтрагентамиВнутренний.ФайлДанныхЭД(СсылкаНаЭД, ПараметрыПросмотра);
	
	Возврат ТабличныйДокумент;
	
КонецФункции

&НаКлиенте
Процедура ОбработатьВыборТипаОбъекта()
	
	Если ЗначениеЗаполнено(ТипОбъекта) Тогда
		Для Каждого Элемент Из СписокТипов Цикл
			Если Элемент.Представление = ТипОбъекта Тогда
				ВыбраннаяСсылка = Элемент.Значение;
				Если НЕ ЗначениеЗаполнено(ДокументИБ) ИЛИ ТипЗнч(ДокументИБ) <> ТипЗнч(ВыбраннаяСсылка) Тогда
					ДокументИБ = ВыбраннаяСсылка;
				КонецЕсли;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СформироватьТекстСлужебногоСообщения()
	
	Если ЗначениеЗаполнено(ИмяФайлаХМЛ) Тогда
		
		ЗаголовокЭлемента = НСтр("ru = 'Не удалось прочитать файл """+ ИмяФайлаХМЛ+".""'");
		
	Иначе
		
		ЗаголовокЭлемента = НСтр("ru = 'Не найден файл электронного документа ""* .xml.""'");
		
	КонецЕсли;
	
	Элементы.КомментарийСлужебноеСообщение.Заголовок = ЗаголовокЭлемента;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьРеквизитыОрганизации()
	
	Отказ = Ложь;
	ТекстСообщения = "";
	
	Если СпособЗагрузкиДокумента = 1 И Не ЗначениеЗаполнено(ДокументИБ) Тогда
		ТекстСообщения = НСтр("ru = 'Не указан элемент справочника для перезаполнения.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Отказ = Истина;
	КонецЕсли;
	
	СоздатьОбъектыИБ(АдресСтруктурыРазбораЭД, Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
		
	ДанныеФормы = Неопределено;
	СформироватьДокументИБ(ДанныеФормы, ТекстСообщения, Истина,, Отказ);
	Если Отказ Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("Ключ", ДанныеФормы);
	РежимОткрытия = РежимОткрытияОкнаФормы.Независимый;
	
	Оповестить("ЗагрузкаРеквизитовКонтрагентаИзФайла", ДанныеФормы);
		
	ФормаЭлемента = ОткрытьФорму(ИмяОбъектаМетаданных +".Форма.ФормаЭлемента",
		ПараметрыФормы,,,,,,РежимОткрытияОкнаФормы.Независимый);
	
	ВыполнитьДействиеЗавершение(ДанныеФормы, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьКаталогТоваров()
	
	СоздатьОбъектыИБ(АдресСтруктурыРазбораЭД, Ложь);
	
	ОбработчикОповещения = Новый ОписаниеОповещения("ЗагрузитьКаталогОповещение", ЭтотОбъект) ;
	
	СопоставитьНоменклатуру(ОбработчикОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьКаталогОповещение(Результат, ДополнительныеПараметры) Экспорт
	
	СохранитьДанныеОбъектаВБД(АдресСтруктурыРазбораЭД);
	
	ВыполнитьДействиеЗавершение();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьДокументЭДО()
	
	Отказ = Ложь;
	ТекстСообщения = "";
	
	Если НЕ МожноЗагрузитьЭДВида(ВидЭД) Тогда
		ТекстСообщения = НСтр("ru = 'Не поддерживается загрузка электронных документов вида ""%1"".'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%1", ВидЭД);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Отказ = Истина;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Контрагент) Тогда
		ТекстСообщения = НСтр("ru = 'Не указан контрагент.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Отказ = Истина;
	КонецЕсли;
	
	Если СпособЗагрузкиДокумента = 1 Тогда
		
		Если Не ЗначениеЗаполнено(ДокументИБ) Тогда
			ТекстСообщения = НСтр("ru = 'Не указан документ для перезаполнения.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			Отказ = Истина;
		КонецЕсли;
		
		Если ДокументПроведен() Тогда
			Шаблон = НСтр("ru = 'Обработка документа %1.
						|Операция возможна только для непроведенных документов.'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Шаблон, ДокументИБ);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			Отказ = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	СоздатьОбъектыИБ(АдресСтруктурыРазбораЭД, Отказ);
	
	Если Отказ Тогда
		ЗакрытьФорму = Ложь;
		Возврат;
	КонецЕсли;
	
	СопоставлятьНоменклатуруПередЗаполнениемДокумента = Ложь;
	ОбменСКонтрагентамиКлиентПереопределяемый.СопоставлятьНоменклатуруПередЗаполнениемДокумента(СопоставлятьНоменклатуруПередЗаполнениемДокумента);
	
	Если СопоставлятьНоменклатуруПередЗаполнениемДокумента Тогда
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ВыполнялосьСопоставление", Ложь);
		ДополнительныеПараметры.Вставить("ОтказЗаполнения", Ложь);
		
		ОбработчикОповещенияПередЗаполнением = Новый ОписаниеОповещения("СопоставитьПередЗаполнениемОповещение",
			ЭтотОбъект,
			ДополнительныеПараметры);
		СопоставитьНоменклатуру(ОбработчикОповещенияПередЗаполнением);
		
			
		#Если ТолстыйКлиентОбычноеПриложение Тогда
		Если Не ДополнительныеПараметры.ВыполнялосьСопоставление Тогда
			ЗагрузитьДокументВИБ(СопоставлятьНоменклатуруПередЗаполнениемДокумента);
		КонецЕсли;
		#КонецЕсли
			
			
	Иначе
		ЗагрузитьДокументВИБ(СопоставлятьНоменклатуруПередЗаполнениемДокумента);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СопоставитьПередЗаполнениемОповещение(Результат, ДополнительныеПараметры) Экспорт
	
	ОтказЗаполнения = ДополнительныеПараметры.ОтказЗаполнения;
	Если ОтказЗаполнения Тогда
		Возврат;
	КонецЕсли;
	
	ВыполнялосьСопоставление = ДополнительныеПараметры.ВыполнялосьСопоставление;
	ОбновитьСтруктуруРазбора = ВыполнялосьСопоставление;
	
	ЗагрузитьДокументВИБ(Истина, ВыполнялосьСопоставление);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьДокументВИБ(СопоставлятьНоменклатуруПередЗаполнениемДокумента, ОбновитьСтруктуруРазбора = Ложь)
	
	Отказ = Ложь;
	ДокументСсылка = Неопределено;
	ТекстСообщения = "";
	
	СформироватьДокументИБ(ДокументСсылка, ТекстСообщения, Истина, ОбновитьСтруктуруРазбора, Отказ);
	Если Отказ Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	Иначе
		
		ТекстОповещения	= НСтр("ru = 'Документ загружен.'");
		ТекстПояснения	= ДокументСсылка;
		ПоказатьОповещениеПользователя(ТекстОповещения, ПолучитьНавигационнуюСсылку(ДокументСсылка), ТекстПояснения);
	
		МассивОповещения = Новый Массив;
		МассивОповещения.Добавить(ДокументСсылка);
		Оповестить("ОбновитьДокументИБПослеЗаполнения", МассивОповещения);
		
		ПоказатьЗначение(Неопределено, ДокументСсылка);
		
	КонецЕсли;
	
	ВыполнитьДействиеЗавершение(ДокументСсылка, Отказ);
	
КонецПроцедуры

&НаСервере
Функция ДокументПроведен()
	
	Проведен = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументИБ, "Проведен");
	Возврат Проведен;
	
КонецФункции

&НаСервере
Процедура СкрытьДополнительныеДанные()
	
	ТабличныйДокументФормы = ИсходныйТабличныйДокумент.ПолучитьОбласть();
	
	Если ОтключитьВыводДопДанных Тогда
		ИменаОбластей = "ОбластьДД, ОбластьДДСЭП, ОбластьДДБезЭП, ОбластьДДСЭП_УС, ОбластьДДСЭП_У, ОбластьДДСЭП_С";
		ЭлектронноеВзаимодействиеСлужебный.СкрытьОбластиТабличногоДокумента(ТабличныйДокументФормы, ИменаОбластей);
		ИменаОбластей = "ДопДанныеШапки_Шапка";
		ЭлектронноеВзаимодействиеСлужебный.СкрытьОбластиТабличногоДокумента(ТабличныйДокументФормы, ИменаОбластей,
			ТипСмещенияТабличногоДокумента.ПоВертикали);
	КонецЕсли;
		
	Если ОтключитьВыводКопияВерна И Не ОтключитьВыводДопДанных Тогда
		ИменаОбластей = "КопияВерна";
		ЭлектронноеВзаимодействиеСлужебный.СкрытьОбластиТабличногоДокумента(ТабличныйДокументФормы, ИменаОбластей,
			ТипСмещенияТабличногоДокумента.ПоВертикали);
	ИначеЕсли Не ОтключитьВыводКопияВерна И ОтключитьВыводДопДанных Тогда
		ТабличныйДокументКопияВерна = ИсходныйТабличныйДокумент.ПолучитьОбласть("КопияВерна");
		Если ТабличныйДокументКопияВерна <> Неопределено Тогда
			ЭлектронноеВзаимодействиеСлужебный.ВывестиОбластьВТабличныйДокумент(ТабличныйДокументФормы, ТабличныйДокументКопияВерна,
				"КопияВерна");
		КонецЕсли;		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
