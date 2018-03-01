&НаКлиенте
Перем КэшированныеЗначения;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	УстановитьУсловноеОформление();
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
		НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(Объект,ПараметрыУказанияСерий);
	КонецЕсли;
	
	УстановитьДоступностьКомандБуфераОбмена();
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	МодификацияКонфигурацииПереопределяемый.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриЧтенииСозданииНаСервере();
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Элементы.СтраницаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);
	ЗаполнитьСлужебныеРеквизитыТЧТовары();
	УпаковочныеЛистыСервер.ПеренумероватьСтроки(ЭтаФорма, Объект.Товары);
	УпаковочныеЛистыСервер.СформироватьНавигационнуюНадпись(ЭтаФорма,
		ЗаголовокНачальногоУровня(Объект.Ссылка, Объект.Код));
	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	Если ИсточникВыбора.ИмяФормы = "Обработка.ЗагрузкаДанныхИзВнешнихФайлов.Форма.Форма" Тогда
		
		ПолучитьЗагруженныеТоварыИзХранилища(ВыбранноеЗначение.АдресТоваровВХранилище);
		
	ИначеЕсли ИсточникВыбора.ИмяФормы = "Справочник.Номенклатура.Форма.ФормаВыбора" Тогда
		
		ТекущиеДанные.Номенклатура = ВыбранноеЗначение;
		НоменклатураУпаковочныйЛистПриИзменении("ТоварыНоменклатура", КэшированныеЗначения);
		Элементы.Товары.ТекущийЭлемент = Элементы.ТоварыКоличествоУпаковок;
		Элементы.Товары.ТекущийЭлемент = Элементы.ТоварыНоменклатура;
		
	ИначеЕсли ИсточникВыбора.ИмяФормы = "Документ.УпаковочныйЛист.Форма.ФормаВыбора" Тогда
		
		ТекущиеДанные.УпаковочныйЛист = ВыбранноеЗначение;
		НоменклатураУпаковочныйЛистПриИзменении("ТоварыУпаковочныйЛист", КэшированныеЗначения);
		Элементы.Товары.ЗакончитьРедактированиеСтроки(Ложь);
		
	ИначеЕсли НоменклатураКлиент.ЭтоУказаниеСерий(ИсточникВыбора) Тогда
		
		НоменклатураКлиент.ОбработатьУказаниеСерии(ЭтаФорма, ПараметрыУказанияСерий, ВыбранноеЗначение);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
	Если Не Объект.РежимПросмотраПоТоварам Тогда
		
		ДокументОбъект = РеквизитФормыВЗначение("Объект");
		
		Если Не ДокументОбъект.ПроверитьЗаполнение() Тогда
			Объект.РежимПросмотраПоТоварам = Истина;
			РежимПросмотраПриИзмененииСервер();
			Отказ = Истина;
		КонецЕсли;
		
		ПроверяемыеРеквизиты.Очистить();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "КопированиеСтрокВБуферОбмена" Тогда
		УстановитьДоступностьКомандБуфераОбменаНаКлиенте();
	КонецЕсли;
	
	// СтандартныеПодсистемы.Свойства 
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидПриИзменении(Элемент)
	
	ВидПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьНавигацияОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПриПереходеНаДругойУровеньСервер(НавигационнаяСсылка);
	
КонецПроцедуры

&НаКлиенте
Процедура РежимПросмотраПриИзменении(Элемент)
	РежимПросмотраПриИзмененииСервер();
	УпаковочныеЛистыКлиент.ОбновитьКешированныеЗначенияДляТЧСУпаковочнымиЛистами(Элементы.Товары, КэшированныеЗначения);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиТаблицыФормыТовары

&НаКлиенте
Процедура ТоварыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если УпаковочныеЛистыКлиент.ПроверитьПодготовитьПереходВУпаковочныйЛистПриВыборе(Элементы.Товары, Поле.Имя) Тогда
		ПриПереходеНаДругойУровеньСервер(Элементы.Товары.ТекущиеДанные.УпаковочныйЛист);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	УпаковочныеЛистыКлиент.ПриНачалеРедактированияТЧСУпаковочнымиЛистами(ЭтаФорма, КэшированныеЗначения, НоваяСтрока)
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	УпаковочныеЛистыКлиент.ПриОкончанииРедактированияТЧСУпаковочнымиЛистами(ЭтаФорма, НоваяСтрока, ОтменаРедактирования);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	УпаковочныеЛистыКлиент.ПередНачаломДобавленияВТЧСУпаковочнымиЛистами(Элементы.Товары, Отказ, Копирование, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПередУдалением(Элемент, Отказ)
	
	УпаковочныеЛистыКлиент.ПередУдалениемСтрокТЧСУпаковочнымиЛистами(Элементы.Товары, КэшированныеЗначения, Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПослеУдаления(Элемент)
	
	ТоварыПослеУдаленияСервер(КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураПоставщикаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ЗаполнитьНоменклатуруПоНоменклатуреПоставщика");
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
	СтруктураДействий.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются", Новый Структура("Номенклатура", "ХарактеристикиИспользуются"));
	СтруктураДействий.Вставить("ЗаполнитьПризнакТипНоменклатуры", Новый Структура("Номенклатура", "ТипНоменклатуры"));
	СтруктураДействий.Вставить("ЗаполнитьПризнакАртикул", Новый Структура("Номенклатура", "Артикул"));
	СтруктураДействий.Вставить("ПроверитьСериюРассчитатьСтатус",
		Новый Структура("ПараметрыУказанияСерий, Склад", ПараметрыУказанияСерий, Неопределено));
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураУпаковочныйЛистПриИзменении(Элемент)
	
	НоменклатураУпаковочныйЛистПриИзменении(Элемент.Имя, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыУпаковкаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыКоличествоУпаковокПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	Если Не ЗначениеЗаполнено(ТекущаяСтрока.УпаковочныйЛистРодитель) Тогда
		ПересчитатьКоличествоМест();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	УпаковочныеЛистыКлиент.НачалоВыбораТоварногоМеста(ЭтаФорма, Элемент, СтандартнаяОбработка, Объект.РежимПросмотраПоТоварам);
	
КонецПроцедуры

&НаСервере
Процедура ТоварыПослеУдаленияСервер(КэшированныеЗначения)
	
	УпаковочныеЛистыСервер.ПослеУдаленияВТЧСУпаковочнымиЛистами(ЭтаФорма, Объект.Товары, Объект.РежимПросмотраПоТоварам);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыУпаковочныйЛистРодительОткрытие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ПоказатьЗначение(Неопределено, Элементы.Товары.ТекущиеДанные.УпаковочныйЛистРодитель);
КонецПроцедуры

&НаКлиенте
Процедура ТоварыУпаковочныйЛистРодительОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСерияПриИзменении(Элемент)
	ВыбранноеЗначение = НоменклатураКлиентСервер.ВыбраннаяСерия();
	
	ВыбранноеЗначение.Значение            		 = Элементы.Товары.ТекущиеДанные.Серия;
	ВыбранноеЗначение.ИдентификаторТекущейСтроки = Элементы.Товары.ТекущиеДанные.ПолучитьИдентификатор();
	
	НоменклатураКлиент.ОбработатьУказаниеСерии(ЭтаФорма, ПараметрыУказанияСерий, ВыбранноеЗначение);
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСерияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОткрытьПодборСерий(Элемент.ТекстРедактирования);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗагрузитьИзВнешнегоФайла(Команда)
	
	ПараметрыФормы = Новый Структура();
	
	ПараметрыФормы.Вставить("ОтборПоТипуНоменклатуры", Новый ФиксированныйМассив(НоменклатураКлиентСервер.ОтборПоТоваруМногооборотнойТаре(Ложь)));
	ПараметрыФормы.Вставить("ЗагружатьУпаковочныеЛисты", Истина);
	
	ОткрытьФорму("Обработка.ЗагрузкаДанныхИзВнешнихФайлов.Форма.Форма",
		ПараметрыФормы,
		ЭтаФорма,
		УникальныйИдентификатор);
		
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура НаУровеньВверх(Команда)
	
	НаУровеньВверхСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура Распаковать(Команда)
	
	УпаковочныеЛистыКлиент.РаспаковатьУпаковочныйЛист(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Упаковать(Команда)
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		ТекстПредупреждения = НСтр("ru='Выберите строки для объединения.'");
		ПоказатьПредупреждение(,ТекстПредупреждения);
		Возврат;
	КонецЕсли;
	
	НовыйУпаковочныйЛист = УпаковатьСервер();
	
	Если ЗначениеЗаполнено(НовыйУпаковочныйЛист) Тогда
		ТекстОповещения = НСтр("ru='Создание:'");
		ПоказатьОповещениеПользователя(ТекстОповещения,
			ПолучитьНавигационнуюСсылку(НовыйУпаковочныйЛист),
			НовыйУпаковочныйЛист,
			БиблиотекаКартинок.Информация32);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СкопироватьСтроки(Команда)
	
	Если КопированиеСтрокКлиент.ВозможноКопированиеСтрок(Элементы.Товары.ТекущаяСтрока) Тогда
		СкопироватьСтрокиНаСервере();
		КопированиеСтрокКлиент.ОповеститьПользователяОКопированииСтрок(Элементы.Товары.ВыделенныеСтроки.Количество());
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВставитьСтроки(Команда)
	
	КоличествоТоваровДоВставки = Объект.Товары.Количество();
	
	ПолучитьСтрокиИзБуфераОбмена();
	
	КоличествоВставленных = Объект.Товары.Количество() - КоличествоТоваровДоВставки;
	КопированиеСтрокКлиент.ОповеститьПользователяОВставкеСтрок(КоличествоВставленных);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Провести(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиИЗакрыть(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура РазбитьСтроку(Команда)
	
	ТаблицаФормы  = Элементы.Товары;
	ДанныеТаблицы = Объект.Товары;
	
	Оповещение = Новый ОписаниеОповещения("РазбитьСтрокуЗавершение", ЭтотОбъект);
	УпаковочныеЛистыКлиент.РазбитьСтрокуТЧСУпаковочнымиЛистами(ДанныеТаблицы, ТаблицаФормы, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура РазбитьСтрокуЗавершение(НоваяСтрока, ДополнительныеПараметры) Экспорт 
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	Если НоваяСтрока <> Неопределено Тогда
		
		СтруктураДействий = Новый Структура;
		СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
		
		ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
		ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(НоваяСтрока, СтруктураДействий, КэшированныеЗначения);
		
	КонецЕсли;
	
КонецПроцедуры

// СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура СортироватьПоВозрастанию(Команда)
	ТекущаяКолонка = Элементы.Товары.ТекущийЭлемент;
	
	Если ТекущаяКолонка <> Неопределено Тогда
		СортироватьСтроки(ТекущаяКолонка.Имя, "ВОЗР");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СортироватьПоУбыванию(Команда)
	ТекущаяКолонка = Элементы.Товары.ТекущийЭлемент;
	
	Если ТекущаяКолонка <> Неопределено Тогда
		СортироватьСтроки(ТекущаяКолонка.Имя, "УБЫВ");
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область СтандартныеПодсистемы_Печать

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	ПараметрыУказанияСерий = НоменклатураСервер.ПараметрыУказанияСерий(Объект, Документы.УпаковочныйЛист);
	
	УпаковочныеЛистыСервер.ПриЧтенииСозданииФормыСУпаковочнымиЛистами(ЭтаФорма, Объект.Товары,
		ЗаголовокНачальногоУровня(Объект.Ссылка, Объект.Код));
	ЗаполнитьСлужебныеРеквизитыТЧТовары();
	
	ВидПриИзмененииСервер();
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьЗагруженныеТоварыИзХранилища(АдресТоваровВХранилище)
	
	ТоварыИзХранилища = ПолучитьИзВременногоХранилища(АдресТоваровВХранилище);
	
	СтрокиДляДополнения = Новый Массив;
	Для Каждого СтрокаТоваров Из ТоварыИзХранилища Цикл
		Если ЗначениеЗаполнено(СтрокаТоваров.УпаковочныйЛист)
			И СтрокаТоваров.УпаковочныйЛист = Объект.Ссылка Тогда
			ТекстСообщения = НСтр("ru='Нельзя включить %УпаковочныйЛист% в состав самого себя.'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%УпаковочныйЛист%", СтрокаТоваров.УпаковочныйЛист);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			Продолжить;
		КонецЕсли;
		Если ЗначениеЗаполнено(СтрокаТоваров.УпаковочныйЛист)
			И УпаковочныеЛисты.НайтиСтроки(Новый Структура("УпаковочныйЛист",СтрокаТоваров.УпаковочныйЛист)).Количество() > 0 Тогда
			ТекстСообщения = НСтр("ru='%УпаковочныйЛист% уже был добавлен в табличную часть.'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%УпаковочныйЛист%", СтрокаТоваров.УпаковочныйЛист);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			Продолжить;
		КонецЕсли;
		СтрокаТЧТовары = Объект.Товары.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТЧТовары, СтрокаТоваров);
		Если ЗначениеЗаполнено(СтрокаТоваров.УпаковочныйЛист) Тогда
			СтрокиДляДополнения.Добавить(СтрокаТЧТовары);
			СтрокаТЧТовары.ЭтоУпаковочныйЛист = Истина;
			СтрокаТЧТовары.Количество = 1;
			СтрокаТЧТовары.КоличествоУпаковок = 1;
		КонецЕсли;
	КонецЦикла;
	
	УпаковочныеЛистыСервер.ДополнитьСтрокамиПоУпаковочнымЛистам(ЭтаФорма, Объект.Товары, СтрокиДляДополнения);
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются", Новый Структура("Номенклатура", "ХарактеристикиИспользуются"));
	СтруктураДействий.Вставить("ЗаполнитьПризнакТипНоменклатуры", Новый Структура("Номенклатура", "ТипНоменклатуры"));
	СтруктураДействий.Вставить("ЗаполнитьПризнакАртикул", Новый Структура("Номенклатура", "Артикул"));
	УпаковочныеЛистыСервер.ЗаполнитьСлужебныеРеквизиты(ЭтаФорма, Объект.Товары, СтруктураДействий);
	
	НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(Объект,ПараметрыУказанияСерий);
	
	// Загрузка идет в верхний уровень, нужно перейти
	Если Не Объект.РежимПросмотраПоТоварам Тогда
		УпаковочныеЛистыСервер.ПриПереходеНаДругойУровень(ЭтаФорма,
			Объект.Товары, "0", ЗаголовокНачальногоУровня(Объект.Ссылка,Объект.Код));
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//
	
	НоменклатураСервер.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтаФорма);
	
	//
	
	НоменклатураСервер.УстановитьУсловноеОформлениеЕдиницИзмерения(ЭтаФорма);
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТоварыНоменклатураПоставщика.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Товары.ЭтоУпаковочныйЛист");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаОтмененнойСтрокиДокумента);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<номенклатура поставщика не используется>'"));
	
	//
	
	НоменклатураСервер.УстановитьУсловноеОформлениеСерийНоменклатуры(ЭтаФорма, "СерииВсегдаВТЧТовары");
	
	//
	
	УпаковочныеЛистыСервер.УстановитьУсловноеОформлениеСУчетомУпаковочныхЛистов(ЭтаФорма);
	
КонецПроцедуры

// Обработчик, вызываемый после закрытия вопроса пользователю о распаковке
//
&НаКлиенте
Процедура ПослеЗакрытияВопросаОРаспаковке(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		РаспаковатьСервер();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НоменклатураУпаковочныйЛистПриИзменении(ИмяПоля, КэшированныеЗначения)
	
	ТекущаяСтрока = Объект.Товары.НайтиПоИдентификатору(Элементы.Товары.ТекущаяСтрока);
	
	Если ЗначениеЗаполнено(Объект.Ссылка)
		И ТекущаяСтрока.УпаковочныйЛист = Объект.Ссылка Тогда
		
		ТекстОшибки = НСтр("ru='Нельзя включить %УпаковочныйЛист% в состав самого себя.'");
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%УпаковочныйЛист%", ТекущаяСтрока.УпаковочныйЛист);
		Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Объект.Товары", ТекущаяСтрока.НомерСтроки, "УпаковочныйЛист");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки,,Поле);
		ТекущаяСтрока.УпаковочныйЛист = КэшированныеЗначения.УпаковочныйЛист;
		
	КонецЕсли;
	
	СтруктураДействийСТекущейСтрокой = Новый Структура;
	СтруктураДействийСТекущейСтрокой.Вставить("ЗаполнитьПризнакТипНоменклатуры", Новый Структура("Номенклатура", "ТипНоменклатуры"));
	СтруктураДействийСТекущейСтрокой.Вставить("ЗаполнитьПризнакАртикул", Новый Структура("Номенклатура", "Артикул"));
	СтруктураДействийСТекущейСтрокой.Вставить("ПроверитьХарактеристикуПоВладельцу", ТекущаяСтрока.Характеристика);
	СтруктураДействийСТекущейСтрокой.Вставить("ПроверитьЗаполнитьУпаковкуПоВладельцу", ТекущаяСтрока.Упаковка);
	СтруктураДействийСТекущейСтрокой.Вставить("ПересчитатьКоличествоЕдиниц");
	СтруктураДействийСТекущейСтрокой.Вставить("НоменклатураПриИзмененииПереопределяемый", Новый Структура("ИмяФормы, ИмяТабличнойЧасти",
		ЭтаФорма.ИмяФормы, "Товары"));
	СтруктураДействийСТекущейСтрокой.Вставить("ПроверитьСериюРассчитатьСтатус",
		Новый Структура("ПараметрыУказанияСерий, Склад", ПараметрыУказанияСерий, Неопределено));
	
	Если ИмяПоля = "ТоварыУпаковочныйЛист" Тогда
		СтруктураДействийСДобавляемымиСтроками = Новый Структура;
		СтруктураДействийСДобавляемымиСтроками.Вставить("ЗаполнитьПризнакТипНоменклатуры", Новый Структура("Номенклатура", "ТипНоменклатуры"));
		СтруктураДействийСДобавляемымиСтроками.Вставить("ЗаполнитьПризнакАртикул", Новый Структура("Номенклатура", "Артикул"));
		СтруктураДействийСДобавляемымиСтроками.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются",
		Новый Структура("Номенклатура", "ХарактеристикиИспользуются"));
	Иначе
		СтруктураДействийСДобавляемымиСтроками = Неопределено;
	КонецЕсли;
	
	УпаковочныеЛистыСервер.НоменклатураУпаковочныйЛистПриИзменении(ЭтаФорма, Объект.Товары,
		ИмяПоля, КэшированныеЗначения, СтруктураДействийСТекущейСтрокой, СтруктураДействийСДобавляемымиСтроками);
	
КонецПроцедуры

&НаСервере
Процедура РежимПросмотраПриИзмененииСервер()
	
	УпаковочныеЛистыСервер.РежимПросмотраПриИзменении(ЭтаФорма, Объект.Товары, ЗаголовокНачальногоУровня(Объект.Ссылка, Объект.Код));
	
КонецПроцедуры

&НаСервере
Процедура ПриПереходеНаДругойУровеньСервер(НавигационнаяСсылка)
	
	УпаковочныеЛистыСервер.ПриПереходеНаДругойУровень(ЭтаФорма,
		Объект.Товары, НавигационнаяСсылка, ЗаголовокНачальногоУровня(Объект.Ссылка,Объект.Код));
	
КонецПроцедуры

#Область РаботаСБуферомОбмена

&НаСервере
Процедура УстановитьДоступностьКомандБуфераОбмена()
	
	МассивЭлементов = Новый Массив();
	МассивЭлементов.Добавить("ТоварыВставитьСтроки");
	МассивЭлементов.Добавить("ТоварыКонтекстноеМенюВставитьСтроки");
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементовФормы(Элементы, МассивЭлементов, "Доступность",
		НЕ ОбщегоНазначения.ПустойБуферОбмена("Строки"));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьКомандБуфераОбменаНаКлиенте()
	
	МассивЭлементов = Новый Массив();
	МассивЭлементов.Добавить("ТоварыВставитьСтроки");
	МассивЭлементов.Добавить("ТоварыКонтекстноеМенюВставитьСтроки");
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементовФормы(Элементы, МассивЭлементов, "Доступность", Истина);
	
КонецПроцедуры

&НаСервере
Процедура СкопироватьСтрокиНаСервере()
	
	КопированиеСтрокСервер.ПоместитьВыделенныеСтрокиВБуферОбмена(Элементы.Товары.ВыделенныеСтроки, Объект.Товары);
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьСтрокиИзБуфераОбмена()
	
	СтрокиДляДополнения = Новый Массив;
	ТаблицаТоваров      = КопированиеСтрокСервер.ПолучитьСтрокиИзБуфераОбмена();
	
	ОбработатьТаблицуТоваровБуфераОбмена(ТаблицаТоваров);
	
	Для Каждого СтрокаТоваров Из ТаблицаТоваров Цикл
		
		Если ЗначениеЗаполнено(СтрокаТоваров.УпаковочныйЛист)
			И СтрокаТоваров.УпаковочныйЛист = Объект.Ссылка Тогда
			
			ТекстСообщения = НСтр("ru='Нельзя включить %УпаковочныйЛист% в состав самого себя.'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%УпаковочныйЛист%", СтрокаТоваров.УпаковочныйЛист);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			Продолжить;
			
		КонецЕсли;
		
		ОтборПоУпаковочномуЛисту = Новый Структура("УпаковочныйЛист", СтрокаТоваров.УпаковочныйЛист);
		
		Если ЗначениеЗаполнено(СтрокаТоваров.УпаковочныйЛист)
			И УпаковочныеЛисты.НайтиСтроки(ОтборПоУпаковочномуЛисту).Количество() > 0 Тогда
			
			ТекстСообщения = НСтр("ru='%УпаковочныйЛист% уже был добавлен в табличную часть.'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%УпаковочныйЛист%", СтрокаТоваров.УпаковочныйЛист);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			Продолжить;
			
		КонецЕсли;
		
		ТекущаяСтрока = Объект.Товары.Добавить();
		ЗаполнитьЗначенияСвойств(ТекущаяСтрока, СтрокаТоваров);
		
		Если ЗначениеЗаполнено(СтрокаТоваров.УпаковочныйЛист) Тогда
			СтрокиДляДополнения.Добавить(ТекущаяСтрока);
			
			ТекущаяСтрока.ЭтоУпаковочныйЛист = Истина;
			ТекущаяСтрока.Количество         = 1;
			ТекущаяСтрока.КоличествоУпаковок = 1;
		КонецЕсли;
		
	КонецЦикла;
	
	УпаковочныеЛистыСервер.ДополнитьСтрокамиПоУпаковочнымЛистам(ЭтаФорма, Объект.Товары, СтрокиДляДополнения);
	
	ПризнакАртикул                    = Новый Структура("Номенклатура", "Артикул");
	ПризнакТипНоменклатуры            = Новый Структура("Номенклатура", "ТипНоменклатуры");
	ПризнакХарактеристикиИспользуются = Новый Структура("Номенклатура", "ХарактеристикиИспользуются");
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ЗаполнитьПризнакАртикул",                    ПризнакАртикул);
	СтруктураДействий.Вставить("ЗаполнитьПризнакТипНоменклатуры",            ПризнакТипНоменклатуры);
	СтруктураДействий.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются", ПризнакХарактеристикиИспользуются);
	
	УпаковочныеЛистыСервер.ЗаполнитьСлужебныеРеквизиты(ЭтаФорма, Объект.Товары, СтруктураДействий);
	
	НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(Объект, ПараметрыУказанияСерий);
	
	// Загрузка идет в верхний уровень, нужно выполнить переход.
	Если Не Объект.РежимПросмотраПоТоварам Тогда
		
		УпаковочныеЛистыСервер.ПриПереходеНаДругойУровень(ЭтаФорма, Объект.Товары, "0",
			ЗаголовокНачальногоУровня(Объект.Ссылка, Объект.Код));
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработатьТаблицуТоваровБуфераОбмена(ТаблицаТоваров)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Товары.ТоварнаяКатегория                                      КАК ТоварнаяКатегория,
	|	Товары.НоменклатураНабора                                     КАК НоменклатураНабора,
	|	ВЫРАЗИТЬ(Товары.Номенклатура КАК Справочник.Номенклатура)     КАК Номенклатура,
	|	Товары.ТипНоменклатуры                                        КАК ТипНоменклатуры,
	|	Товары.Характеристика                                         КАК Характеристика,
	|	Товары.Упаковка                                               КАК Упаковка,
	|	ВЫРАЗИТЬ(Товары.УпаковочныйЛист КАК Документ.УпаковочныйЛист) КАК УпаковочныйЛист,
	|	Товары.Количество                                             КАК Количество,
	|	Товары.КоличествоУпаковок                                     КАК КоличествоУпаковок
	|ПОМЕСТИТЬ Товары
	|ИЗ
	|	&ТаблицаТоваров КАК Товары
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА Товары.Номенклатура <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|			ТОГДА Товары.Номенклатура.ТоварнаяКатегория
	|		ИНАЧЕ Товары.ТоварнаяКатегория
	|	КОНЕЦ КАК ТоварнаяКатегория,
	|	Товары.НоменклатураНабора,
	|	Товары.Номенклатура,
	|	Товары.Номенклатура.ТипНоменклатуры КАК ТипНоменклатуры,
	|	Товары.Характеристика,
	|	Товары.Упаковка,
	|	Товары.УпаковочныйЛист,
	|	Товары.Количество,
	|	Товары.КоличествоУпаковок
	|ИЗ
	|	Товары КАК Товары
	|ГДЕ
	|	(Товары.Номенклатура = ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|		И Товары.УпаковочныйЛист <> ЗНАЧЕНИЕ(Документ.УпаковочныйЛист.ПустаяСсылка))
	|	ИЛИ Товары.Номенклатура.ТипНоменклатуры В (&ОтборПоТипуНоменклатуры)";
	
	ПараметрыОтбора = Новый Массив;
	ПараметрыОтбора.Добавить(ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Товар"));
	ПараметрыОтбора.Добавить(ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.МногооборотнаяТара"));
	
	Запрос.УстановитьПараметр("ТаблицаТоваров",          ТаблицаТоваров);
	Запрос.УстановитьПараметр("ОтборПоТипуНоменклатуры", ПараметрыОтбора);
	
	ТаблицаТоваров = Запрос.Выполнить().Выгрузить();
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Функция УпаковатьСервер()
	
	Возврат УпаковочныеЛистыСервер.УпаковатьСервер(ЭтаФорма);
	
КонецФункции

&НаСервере
Процедура РаспаковатьСервер()
	
	УпаковочныеЛистыСервер.РаспаковатьУпаковочныйЛист(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСлужебныеРеквизитыТЧТовары()
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются", Новый Структура("Номенклатура", "ХарактеристикиИспользуются"));
	СтруктураДействий.Вставить("ЗаполнитьПризнакТипНоменклатуры", Новый Структура("Номенклатура", "ТипНоменклатуры"));
	СтруктураДействий.Вставить("ЗаполнитьПризнакАртикул", Новый Структура("Номенклатура", "Артикул"));
	УпаковочныеЛистыСервер.ЗаполнитьСлужебныеРеквизиты(ЭтаФорма, Объект.Товары, СтруктураДействий);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ЗаголовокНачальногоУровня(Ссылка, Код)
	
	ПредставлениеОбъекта = Ссылка.Метаданные().ПредставлениеОбъекта;
	
	Если ЗначениеЗаполнено(Ссылка) Тогда
		Возврат ПредставлениеОбъекта + " " + Код;
	Иначе
		Возврат ПредставлениеОбъекта + " " + НСтр("ru='(создание)'");
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура НаУровеньВверхСервер()
	
	НайденныеСтроки = УпаковочныеЛисты.НайтиСтроки(Новый Структура("УпаковочныйЛист",УпаковочныйЛистРодитель));
	ПриПереходеНаДругойУровеньСервер(НайденныеСтроки[0].УпаковочныйЛистРодитель);
	
КонецПроцедуры

&НаСервере
Процедура ВидПриИзмененииСервер()
	
	Если Объект.Вид = Перечисления.ВидыУпаковочныхЛистов.Входящий Тогда
		Элементы.Код.ОтображениеПредупрежденияПриРедактировании = ОтображениеПредупрежденияПриРедактировании.НеОтображать;
		Элементы.Код.АвтоОтметкаНезаполненного = Истина;
	Иначе
		Элементы.Код.ОтображениеПредупрежденияПриРедактировании = ОтображениеПредупрежденияПриРедактировании.Отображать;
		Элементы.Код.АвтоОтметкаНезаполненного = Ложь;
		Элементы.Код.ОтметкаНезаполненного = Ложь;
	КонецЕсли;
	Элементы.ГруппаПодвал.Видимость = (Объект.Вид = Перечисления.ВидыУпаковочныхЛистов.Исходящий);
	
КонецПроцедуры

&НаСервере
Процедура ПересчитатьКоличествоМест()
	
	УпаковочныеЛистыСервер.ПересчитатьКоличествоМест(ЭтаФорма, Объект.Товары)
	
КонецПроцедуры

#Область Серии

&НаКлиенте
Процедура ОткрытьПодборСерий(Текст = "", ТекущиеДанные = Неопределено)
	
	Если ТекущиеДанные = Неопределено Тогда
		ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
		Если ТекущиеДанные = Неопределено Тогда
			ТекстСообщения = НСтр("ru='Выберите строку товаров, для которой необходимо указать серии.'");
			ПоказатьПредупреждение(Неопределено, ТекстСообщения);
			Возврат;
		КонецЕсли;
	КонецЕсли;
	ТекущиеДанныеИдентификатор = ТекущиеДанные.ПолучитьИдентификатор();
	ПараметрыФормыУказанияСерий = ПараметрыФормыУказанияСерий(ТекущиеДанныеИдентификатор);
	
	ЗначениеВозврата = Неопределено;

	
	ОткрытьФорму(ПараметрыФормыУказанияСерий.ИмяФормы,ПараметрыФормыУказанияСерий,ЭтаФорма,,,, Новый ОписаниеОповещения("ОткрытьПодборСерийЗавершение", ЭтотОбъект, Новый Структура("ПараметрыФормыУказанияСерий", ПараметрыФормыУказанияСерий)), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПодборСерийЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    ПараметрыФормыУказанияСерий = ДополнительныеПараметры.ПараметрыФормыУказанияСерий;
    
    
    ЗначениеВозврата = Результат;
    
    Если ЗначениеВозврата <> Неопределено Тогда
        ОбработатьУказаниеСерийНаСервере(ПараметрыФормыУказанияСерий, КэшированныеЗначения);
    КонецЕсли;

КонецПроцедуры

&НаСервере
Функция ПараметрыФормыУказанияСерий(ТекущиеДанныеИдентификатор)
	
	Возврат НоменклатураСервер.ПараметрыФормыУказанияСерий(Объект, ПараметрыУказанияСерий, ТекущиеДанныеИдентификатор, ЭтаФорма);
	
КонецФункции

&НаСервере
Процедура ОбработатьУказаниеСерийНаСервере(ПараметрыФормыУказанияСерий, КэшированныеЗначения)
	
	НоменклатураСервер.ОбработатьУказаниеСерий(Объект,ПараметрыУказанияСерий,ПараметрыФормыУказанияСерий,,КэшированныеЗначения);
	ЗаполнитьСлужебныеРеквизитыТЧТовары();
	
КонецПроцедуры

#КонецОбласти

// СтандартныеПодсистемы.Свойства 

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()

	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);

КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

&НаСервере
Процедура СортироватьСтроки(ИмяКолонки, Направление)
	ИмяКолонкиНаправление = СтрЗаменить(Элементы[ИмяКолонки].ПутьКДанным, "Объект.Товары.","") + " " + Направление; 
	
	Объект.Товары.Сортировать(ИмяКолонкиНаправление);
	Если ИспользоватьУпаковочныеЛисты Тогда
		УпаковочныеЛистыСервер.ПеренумероватьСтроки(ЭтотОбъект, Объект.Товары);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
