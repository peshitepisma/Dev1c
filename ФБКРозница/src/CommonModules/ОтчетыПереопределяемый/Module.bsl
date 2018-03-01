#Область ПрограммныйИнтерфейс

// В данной процедуре следует описать дополнительные зависимости объектов метаданных
//   конфигурации, которые будут использоваться для связи настроек отчетов.
//
// Параметры:
//   СвязиОбъектовМетаданных - ТаблицаЗначений - Таблица связей.
//       * ПодчиненныйРеквизит - Строка - Имя реквизита подчиненного объекта метаданных.
//       * ПодчиненныйТип      - Тип    - Тип подчиненного объекта метаданных.
//       * ВедущийТип          - Тип    - Тип ведущего объекта метаданных.
//
Процедура ДополнитьСвязиОбъектовМетаданных(СвязиОбъектовМетаданных) Экспорт
	//++ НЕ ЕГАИС
	ОтчетыУТПереопределяемый.ДополнитьСвязиОбъектовМетаданных(СвязиОбъектовМетаданных);
	//-- НЕ ЕГАИС
КонецПроцедуры

// Вызывается в форме отчета перед выводом настройки.
//
// Параметры:
//   Форма - УправляемаяФорма, Неопределено - Форма отчета.
//   СвойстваНастройки - Структура - Описание настройки отчета, которая будет выведена в форме отчета.
//       * ОписаниеТипов - ОписаниеТипов -
//           Тип настройки.
//       * ЗначенияДляВыбора - СписокЗначений -
//           Объекты, которые будут предложены пользователю в списке выбора.
//           Дополняет список объектов, уже выбранных пользователем ранее.
//       * ЗапросЗначенийВыбора - Запрос -
//           Возвращает объекты, которыми необходимо дополнить ЗначенияДляВыбора.
//           Первой колонкой (с 0м индексом) должен выбираться объект,
//           который следует добавить в ЗначенияДляВыбора.Значение.
//           Для отключения автозаполнения
//           в свойство ЗапросЗначенийВыбора.Текст следует записать пустую строку.
//       * ОграничиватьВыборУказаннымиЗначениями - Булево -
//           Когда Истина, то выбор пользователя будет ограничен значениями,
//           указанными в ЗначенияДляВыбора (его конечным состоянием).
//
Процедура ПриОпределенииПараметровВыбора(Форма, СвойстваНастройки) Экспорт
	//++ НЕ ЕГАИС
	ОтчетыУТПереопределяемый.ПриОпределенииПараметровВыбора(Форма, СвойстваНастройки);
	//-- НЕ ЕГАИС
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
// См. "УправляемаяФорма.ПриСозданииНаСервере" в синтакс-помощнике. и ОтчетыКлиентПереопределяемый.ОбработчикКоманды().
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   Отказ - Булево - Признак отказа от создания формы.
//   СтандартнаяОбработка - Булево - Признак выполнения стандартной (системной) обработки события.
//
// Пример:
//	//Добавление команды с обработчиком в ОтчетыКлиентПереопределяемый.ОбработчикКоманды:
//	Команда = ФормаОтчета.Команды.Добавить("МояОсобеннаяКоманда");
//	Команда.Действие  = "Подключаемый_Команда";
//	Команда.Заголовок = НСтр("ru = 'Моя команда...'");
//	
//	Кнопка = ФормаОтчета.Элементы.Добавить(Команда.Имя, Тип("КнопкаФормы"), ФормаОтчета.Элементы.<ИмяПодменю>);
//	Кнопка.ИмяКоманды = Команда.Имя;
//	
//	ФормаОтчета.ПостоянныеКоманды.Добавить(КомандаСоздать.Имя);
//
Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	//++ НЕ ЕГАИС
	ОтчетыУТПереопределяемый.ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка);
	//-- НЕ ЕГАИС
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
// См. "Расширение управляемой формы для отчета.ПередЗагрузкойВариантаНаСервере" в синтакс-помощнике.
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   НовыеНастройкиКД - НастройкиКомпоновкиДанных - Настройки для загрузки в компоновщик настроек.
//
Процедура ПередЗагрузкойВариантаНаСервере(Форма, НовыеНастройкиКД) Экспорт
	//++ НЕ ЕГАИС
	УстановитьМакетОформленияВРежимеТакси(Форма, НовыеНастройкиКД);
	
	ОтчетыУТПереопределяемый.ПередЗагрузкойВариантаНаСервере(Форма, НовыеНастройкиКД);
	//-- НЕ ЕГАИС
КонецПроцедуры

#КонецОбласти

//++ НЕ ЕГАИС
#Область СлужебныеПроцедурыИФункции

Процедура УстановитьМакетОформленияВРежимеТакси(Форма, НовыеНастройкиКД)
	Если ТекущийВариантИнтерфейсаКлиентскогоПриложения() = ВариантИнтерфейсаКлиентскогоПриложения.Такси Тогда
		ПараметрМакетОформления = НовыеНастройкиКД.ПараметрыВывода.Элементы.Найти("МакетОформления");
		Если ПараметрМакетОформления.Значение = "Main" 
			Или ПараметрМакетОформления.Значение = "Основной" Тогда
			ПараметрМакетОформления.Значение = "ОформлениеОтчетовБежевый";
			ПараметрМакетОформления.Использование = Истина;
		КонецЕсли;
		
		Для Каждого ЭлементСтруктуры Из НовыеНастройкиКД.Структура Цикл
			Если ТипЗнч(ЭлементСтруктуры) = Тип("НастройкиВложенногоОбъектаКомпоновкиДанных") Тогда
				ПараметрМакетОформления = ЭлементСтруктуры.Настройки.ПараметрыВывода.Элементы.Найти("МакетОформления");
				Если ПараметрМакетОформления.Значение = "Main" 
					Или ПараметрМакетОформления.Значение = "Основной" Тогда
					ПараметрМакетОформления.Значение = "ОформлениеОтчетовБежевый";
					ПараметрМакетОформления.Использование = Истина;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
		Форма.Элементы.ОтчетТабличныйДокумент.РежимМасштабированияПросмотра = РежимМасштабированияПросмотра.Обычный;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти 
//-- НЕ ЕГАИС