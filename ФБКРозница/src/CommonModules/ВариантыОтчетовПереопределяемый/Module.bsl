#Область ПрограммныйИнтерфейс

// Задает настройки, применяемые как умолчания для объектов подсистемы.
//
// Параметры:
//   Настройки - Структура - Коллекция настроек подсистемы. Реквизиты:
//       * ВыводитьОтчетыВместоВариантов - Булево - Умолчание для вывода гиперссылок в панели отчетов:
//           Истина - Варианты отчетов по умолчанию скрыты, а отчеты включены и видимы.
//           Ложь   - Варианты отчетов по умолчанию видимы, а отчеты отключены.
//           Значение по умолчанию: Ложь.
//       * ВыводитьОписания - Булево - Умолчание для вывода описаний в панели отчетов:
//           Истина - Значение по умолчанию. Выводить описания в виде подписей под гиперссылками вариантов
//           Ложь   - Выводить описания в виде всплывающих подсказок
//           Значение по умолчанию: Истина.
//       * Поиск - Структура - Настройки поиска вариантов отчетов.
//           ** ПодсказкаВвода - Строка - Текст подсказки выводится в поле поиска когда поиск не задан.
//               В качестве примера рекомендуется указывать часто используемые термины прикладной конфигурации.
//       * ДругиеОтчеты - Структура - Настройки формы "Другие отчеты":
//           ** ЗакрыватьПослеВыбора - Булево - Закрывать ли форму после выбора гиперссылки отчета.
//               Истина - Закрывать "Другие отчеты" после выбора.
//               Ложь   - Не закрывать.
//               Значение по умолчанию: Истина.
//           ** ПоказыватьФлажок - Булево - Показывать ли флажок ЗакрыватьПослеВыбора.
//               Истина - Показывать флажок "Закрывать это окно после перехода к другому отчету".
//               Ложь   - Не показывать флажок.
//               Значение по умолчанию: Ложь.
//       * РазрешеноИзменятьВарианты - Булево - Показывать расширенные настройки отчета
//               и команды изменения варианта отчета.
//
// Пример:
//	Настройки.Поиск.ПодсказкаВвода = НСтр("ru = 'Например, себестоимость'");
//	Настройки.ДругиеОтчеты.ЗакрыватьПослеВыбора = Ложь;
//	Настройки.ДругиеОтчеты.ПоказыватьФлажок = Истина;
//	Настройки.РазрешеноИзменятьВарианты = Ложь;
//
Процедура ПриОпределенииНастроек(Настройки) Экспорт
	
	Настройки.ВыводитьОтчетыВместоВариантов = Истина;
	
	Описание = Новый Структура;
	ИмяФормы = "ОбщаяФорма.ОписаниеМобильногоПриложения";
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ИмяМакетаОписания", "ОписаниеМобильногоПриложенияМониторERP");
	ПараметрыФормы.Вставить("НазваниеПриложения", НСтр("ru= '1С:Монитор ERP'"));
	Настройки.Вставить("ОписаниеМобильногоПриложения", Описание);	
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Настройки размещения отчетов

// Определяет разделы глобального командного интерфейса, в которых предусмотрены панели отчетов.
// В Разделы необходимо добавить метаданные тех подсистем первого уровня,
// в которых размещены команды вызова панелей отчетов.
//
// Параметры:
//   Разделы - СписокЗначений - разделы, в которые выведены команды открытия панели отчетов.
//       * Значение - ОбъектМетаданных: Подсистема, Строка - подсистема раздела глобального командного интерфейса,
//           либо ВариантыОтчетовКлиентСервер.ИдентификаторНачальнойСтраницы для начальной страницы.
//       * Представление - Строка - заголовок панели отчетов в этом разделе.
//
// Пример:
//	Разделы.Добавить(Метаданные.Подсистемы.Анкетирование, НСтр("ru = 'Отчеты по анкетированию'"));
//	Разделы.Добавить(ВариантыОтчетовКлиентСервер.ИдентификаторНачальнойСтраницы(), НСтр("ru = 'Основные отчеты'"));
//
Процедура ОпределитьРазделыСВариантамиОтчетов(Разделы) Экспорт
	
	//++ НЕ ЕГАИС
	ВариантыОтчетовУТПереопределяемый.ОпределитьРазделыСВариантамиОтчетов(Разделы);
	
	//-- НЕ ЕГАИС
	
КонецПроцедуры

// Задает настройки размещения вариантов отчетов в панели отчетов.
//   Отчет выступает в качестве контейнера вариантов.
//     Изменяя настройки отчета можно сразу изменять настройки всех его вариантов.
//     Однако, если явно получить настройки варианта отчета, то они станут самостоятельными,
//     т.е. более не будут наследовать изменения настроек от отчета.
//   
//   Начальная настройка размещения отчетов по подсистемам зачитывается из метаданных,
//     ее дублирование в коде не требуется.
//   
//   Функциональные опции варианта объединяются с функциональными опциями этого отчета по следующим правилам:
//     (ФО1_Отчета ИЛИ ФО2_Отчета) И (ФО3_Варианта ИЛИ ФО4_Варианта).
//   Функциональные опции отчетов не зачитываются из метаданных,
//     они применяются на этапе использования подсистемы пользователем.
//   Через ОписаниеОтчета можно добавлять функциональные опции, которые будут соединяться по указанным выше правилам,
//     но надо помнить, что эти функциональные опции будут действовать только для предопределенных вариантов отчетов.
//   Для пользовательских вариантов отчета действуют только функциональные опции отчета
//     - они отключаются только с отключением всего отчета.
//
// Параметры:
//   Настройки - Коллекция - настройки отчетов и вариантов отчетов конфигурации.
//                           Для их изменения предназначены следующие вспомогательные процедуры и функции:
//                           ВариантыОтчетов.ОписаниеОтчета, 
//                           ВариантыОтчетов.ОписаниеВарианта, 
//                           ВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов, 
//                           ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера.
//
// Пример:
//
//  //Добавление варианта отчета в подсистему.
//	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.ИмяОтчета, "<ИмяВарианта>");
//	НастройкиВарианта.Размещение.Вставить(Метаданные.Подсистемы.ИмяРаздела.Подсистемы.ИмяПодсистемы);
//
//  //Отключение варианта отчета.
//	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.ИмяОтчета, "<ИмяВарианта>");
//	НастройкиВарианта.Включен = Ложь;
//
//  //Отключение всех вариантов отчета, кроме одного.
//	НастройкиОтчета = ВариантыОтчетов.ОписаниеОтчета(Настройки, Метаданные.Отчеты.ИмяОтчета);
//	НастройкиОтчета.Включен = Ложь;
//	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "<ИмяВарианта>");
//	НастройкиВарианта.Включен = Истина;
//
//  //Заполнение настроек для поиска - наименования полей, параметров и отборов:
//	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.ИмяОтчетаБезСхемы, "");
//	НастройкиВарианта.НастройкиДляПоиска.НаименованияПолей =
//		НСтр("ru = 'Контрагент
//		|Договор
//		|Ответственный
//		|Скидка
//		|Дата'");
//	НастройкиВарианта.НастройкиДляПоиска.НаименованияПараметровИОтборов =
//		НСтр("ru = 'Период
//		|Ответственный
//		|Контрагент
//		|Договор'");
//
//  //Переключение режима вывода в панелях отчетов:
//  //Группировка вариантов отчета по этому отчету:
//	ВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, Метаданные.Отчеты.ИмяОтчета, Истина);
//  //Без группировки по отчету:
//	Отчет = ВариантыОтчетов.ОписаниеОтчета(Настройки, Метаданные.Отчеты.ИмяОтчета);
//	ВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, Отчет, Ложь);
//
Процедура НастроитьВариантыОтчетов(Настройки) Экспорт
	
	//++ НЕ ЕГАИС
	
	// ИнтернетПоддержкаПользователей
	ИнтернетПоддержкаПользователей.НастроитьВариантыОтчетов(Настройки);
	// Конец ИнтернетПоддержкаПользователей
	
	ВариантыОтчетовУТПереопределяемый.НастроитьВариантыОтчетов(Настройки);
	
	//-- НЕ ЕГАИС
	
КонецПроцедуры

// Регистрирует изменения в именах вариантов отчетов.
//   Используется при обновлении в целях сохранения ссылочной целостности,
//   в частности для сохранения пользовательских настроек и настроек рассылок отчетов.
//   Старое имя варианта резервируется и не может быть использовано в дальнейшем.
//   Если изменений было несколько, то каждое изменение необходимо зарегистрировать,
//   указывая в актуальном имени варианта последнее (текущее) имя варианта отчета.
//   Поскольку имена вариантов отчетов не выводятся в пользовательском интерфейсе,
//   то рекомендуется задавать их таким образом, что бы затем не менять.
//   В Изменения необходимо добавить описания изменений имен вариантов
//   отчетов, подключенных к подсистеме.
//
// Параметры:
//   Изменения - ТаблицаЗначений - Таблица изменений имен вариантов. Колонки:
//       * Отчет - ОбъектМетаданных - Метаданные отчета, в схеме которого изменилось имя варианта.
//       * СтароеИмяВарианта - Строка - Старое имя варианта, до изменения.
//       * АктуальноеИмяВарианта - Строка - Текущее (последнее актуальное) имя варианта.
//
// Пример:
//	Изменение = Изменения.Добавить();
//	Изменение.Отчет = Метаданные.Отчеты.<ИмяОтчета>;
//	Изменение.СтароеИмяВарианта = "<СтароеИмяВарианта>";
//	Изменение.АктуальноеИмяВарианта = "<АктуальноеИмяВарианта>";
//
Процедура ЗарегистрироватьИзмененияКлючейВариантовОтчетов(Изменения) Экспорт
	
	//++ НЕ ЕГАИС
	ВариантыОтчетовУТПереопределяемый.ЗарегистрироватьИзмененияКлючейВариантовОтчетов(Изменения);
	//-- НЕ ЕГАИС
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Настройки команд отчетов

// Определяет объекты конфигурации, в модулях менеджеров которых предусмотрена процедура ДобавитьКомандыОтчетов,
// описывающая команды открытия контекстных отчетов.
// Синтаксис процедуры ДобавитьКомандыОтчетов см. в документации.
//
// Параметры:
//   Объекты - Массив - объекты метаданных (ОбъектМетаданных) с командами отчетов.
//
Процедура ОпределитьОбъектыСКомандамиОтчетов(Объекты) Экспорт
	
	//++ НЕ ЕГАИС
	Объекты.Добавить(Метаданные.БизнесПроцессы.СогласованиеЗакупки);
	Объекты.Добавить(Метаданные.БизнесПроцессы.СогласованиеЗаявкиНаВозвратТоваровОтКлиента);
	Объекты.Добавить(Метаданные.БизнесПроцессы.СогласованиеПродажи);
	Объекты.Добавить(Метаданные.БизнесПроцессы.СогласованиеЦенНоменклатуры);
	Объекты.Добавить(Метаданные.Документы.АвансовыйОтчет);
	Объекты.Добавить(Метаданные.Документы.АктВыполненныхРабот);
	Объекты.Добавить(Метаданные.Документы.АктОРасхожденияхПослеОтгрузки);
	Объекты.Добавить(Метаданные.Документы.АктОРасхожденияхПослеПеремещения);
	Объекты.Добавить(Метаданные.Документы.АктОРасхожденияхПослеПриемки);
	Объекты.Добавить(Метаданные.Документы.АннулированиеПодарочныхСертификатов);
	Объекты.Добавить(Метаданные.Документы.БлокировкаВычетаНДС);
	Объекты.Добавить(Метаданные.Документы.ВводОстатков);
	Объекты.Добавить(Метаданные.Документы.ВзаимозачетЗадолженности);
	Объекты.Добавить(Метаданные.Документы.ВнесениеДенежныхСредствВКассуККМ);
	Объекты.Добавить(Метаданные.Документы.ВнутреннееПотреблениеТоваров);
	Объекты.Добавить(Метаданные.Документы.ВозвратПодарочныхСертификатов);
	Объекты.Добавить(Метаданные.Документы.ВозвратТоваровМеждуОрганизациями);
	Объекты.Добавить(Метаданные.Документы.ВозвратТоваровОтКлиента);
	Объекты.Добавить(Метаданные.Документы.ВозвратТоваровПоставщику);
	Объекты.Добавить(Метаданные.Документы.ВыемкаДенежныхСредствИзКассыККМ);
	Объекты.Добавить(Метаданные.Документы.ВыкупВозвратнойТарыКлиентом);
	Объекты.Добавить(Метаданные.Документы.ВыкупВозвратнойТарыУПоставщика);
	Объекты.Добавить(Метаданные.Документы.ГрафикИсполненияДоговора);
	Объекты.Добавить(Метаданные.Документы.ДвижениеПрочихАктивовПассивов);
	Объекты.Добавить(Метаданные.Документы.ДоверенностьВыданная);
	Объекты.Добавить(Метаданные.Документы.ЗаданиеНаПеревозку);
	Объекты.Добавить(Метаданные.Документы.ЗаданиеТорговомуПредставителю);
	Объекты.Добавить(Метаданные.Документы.ЗаказКлиента);
	Объекты.Добавить(Метаданные.Документы.ЗаказНаВнутреннееПотребление);
	Объекты.Добавить(Метаданные.Документы.ЗаказНаПеремещение);
	Объекты.Добавить(Метаданные.Документы.ЗаказНаСборку);
	Объекты.Добавить(Метаданные.Документы.ЗаказПоставщику);
	Объекты.Добавить(Метаданные.Документы.ЗаписьКнигиПокупок);
	Объекты.Добавить(Метаданные.Документы.ЗаписьКнигиПродаж);
	Объекты.Добавить(Метаданные.Документы.ЗаявкаНаВозвратТоваровОтКлиента);
	Объекты.Добавить(Метаданные.Документы.ЗаявкаНаРасходованиеДенежныхСредств);
	Объекты.Добавить(Метаданные.Документы.ЗаявлениеОВвозеТоваров);
	Объекты.Добавить(Метаданные.Документы.ИзменениеАссортимента);
	Объекты.Добавить(Метаданные.Документы.ИнвентаризационнаяОпись);
	Объекты.Добавить(Метаданные.Документы.ИнвентаризацияНаличныхДенежныхСредств);
	Объекты.Добавить(Метаданные.Документы.КоммерческоеПредложениеКлиенту);
	Объекты.Добавить(Метаданные.Документы.КорректировкаВидаДеятельностиНДС);
	Объекты.Добавить(Метаданные.Документы.КорректировкаИзлишковНедостачПоТоварнымМестам);
	Объекты.Добавить(Метаданные.Документы.КорректировкаНазначенияТоваров);
	Объекты.Добавить(Метаданные.Документы.КорректировкаНалогообложенияНДСПартийТоваров);
	Объекты.Добавить(Метаданные.Документы.КорректировкаОбособленногоУчетаЗапасов);
	Объекты.Добавить(Метаданные.Документы.КорректировкаПоОрдеруНаТовары);
	Объекты.Добавить(Метаданные.Документы.КорректировкаПриобретения);
	Объекты.Добавить(Метаданные.Документы.КорректировкаРеализации);
	Объекты.Добавить(Метаданные.Документы.КорректировкаРегистров);
	Объекты.Добавить(Метаданные.Документы.ЛимитыРасходаДенежныхСредств);
	Объекты.Добавить(Метаданные.Документы.ЛистКассовойКниги);
	Объекты.Добавить(Метаданные.Документы.НачислениеИСписаниеБонусныхБаллов);
	Объекты.Добавить(Метаданные.Документы.НачисленияКредитовИДепозитов);
	Объекты.Добавить(Метаданные.Документы.НормативРаспределенияПлановПродажПоКатегориям);
	Объекты.Добавить(Метаданные.Документы.ОжидаемоеПоступлениеДенежныхСредств);
	Объекты.Добавить(Метаданные.Документы.ОперацияПоПлатежнойКарте);
	Объекты.Добавить(Метаданные.Документы.ОперацияПоЯндексКассе);
	Объекты.Добавить(Метаданные.Документы.ОприходованиеИзлишковТоваров);
	Объекты.Добавить(Метаданные.Документы.ОрдерНаОтражениеИзлишковТоваров);
	Объекты.Добавить(Метаданные.Документы.ОрдерНаОтражениеНедостачТоваров);
	Объекты.Добавить(Метаданные.Документы.ОрдерНаОтражениеПересортицыТоваров);
	Объекты.Добавить(Метаданные.Документы.ОрдерНаОтражениеПорчиТоваров);
	Объекты.Добавить(Метаданные.Документы.ОрдерНаПеремещениеТоваров);
	Объекты.Добавить(Метаданные.Документы.ОтборРазмещениеТоваров);
	Объекты.Добавить(Метаданные.Документы.ОтражениеРасхожденийПриИнкассацииДенежныхСредств);
	Объекты.Добавить(Метаданные.Документы.ОтчетБанкаПоОперациямЭквайринга);
	Объекты.Добавить(Метаданные.Документы.ОтчетКомиссионера);
	Объекты.Добавить(Метаданные.Документы.ОтчетКомиссионераОСписании);
	Объекты.Добавить(Метаданные.Документы.ОтчетКомитенту);
	Объекты.Добавить(Метаданные.Документы.ОтчетКомитентуОСписании);
	Объекты.Добавить(Метаданные.Документы.ОтчетОРозничныхПродажах);
	Объекты.Добавить(Метаданные.Документы.ОтчетПоКомиссииМеждуОрганизациями);
	Объекты.Добавить(Метаданные.Документы.ОтчетПоКомиссииМеждуОрганизациямиОСписании);
	Объекты.Добавить(Метаданные.Документы.ПередачаТоваровМеждуОрганизациями);
	Объекты.Добавить(Метаданные.Документы.ПеремещениеТоваров);
	Объекты.Добавить(Метаданные.Документы.РасчетКурсовыхРазниц);
	Объекты.Добавить(Метаданные.Документы.ПересортицаТоваров);
	Объекты.Добавить(Метаданные.Документы.ПересчетТоваров);
	Объекты.Добавить(Метаданные.Документы.ПланЗакупок);
	Объекты.Добавить(Метаданные.Документы.ПланПродаж);
	Объекты.Добавить(Метаданные.Документы.ПланПродажПоКатегориям);
	Объекты.Добавить(Метаданные.Документы.ПланСборкиРазборки);
	Объекты.Добавить(Метаданные.Документы.ПоручениеЭкспедитору);
	Объекты.Добавить(Метаданные.Документы.ПорчаТоваров);
	Объекты.Добавить(Метаданные.Документы.ПоступлениеБезналичныхДенежныхСредств);
	Объекты.Добавить(Метаданные.Документы.ПоступлениеТоваров);
	Объекты.Добавить(Метаданные.Документы.ПриобретениеТоваровУслуг);
	Объекты.Добавить(Метаданные.Документы.ПриобретениеУслугПрочихАктивов);
	Объекты.Добавить(Метаданные.Документы.ПриходныйКассовыйОрдер);
	Объекты.Добавить(Метаданные.Документы.ПриходныйОрдерНаТовары);
	Объекты.Добавить(Метаданные.Документы.ПрочееОприходованиеТоваров);
	Объекты.Добавить(Метаданные.Документы.ПрочиеДоходыРасходы);
	Объекты.Добавить(Метаданные.Документы.РаспоряжениеНаПеремещениеДенежныхСредств);
	Объекты.Добавить(Метаданные.Документы.РаспределениеДоходовИРасходовПоНаправлениямДеятельности);
	Объекты.Добавить(Метаданные.Документы.РаспределениеНДС);
	Объекты.Добавить(Метаданные.Документы.РаспределениеРасходовБудущихПериодов);
	Объекты.Добавить(Метаданные.Документы.РассылкаКлиентам);
	Объекты.Добавить(Метаданные.Документы.РасходныйКассовыйОрдер);
	Объекты.Добавить(Метаданные.Документы.РасходныйОрдерНаТовары);
	Объекты.Добавить(Метаданные.Документы.РасчетСебестоимостиТоваров);
	Объекты.Добавить(Метаданные.Документы.РеализацияПодарочныхСертификатов);
	Объекты.Добавить(Метаданные.Документы.РеализацияТоваровУслуг);
	Объекты.Добавить(Метаданные.Документы.РеализацияУслугПрочихАктивов);
	Объекты.Добавить(Метаданные.Документы.РегистрацияЦенНоменклатурыПоставщика);
	Объекты.Добавить(Метаданные.Документы.СборкаТоваров);
	Объекты.Добавить(Метаданные.Документы.СверкаВзаиморасчетов);
	Объекты.Добавить(Метаданные.Документы.РегистраторГрафикаДвиженияТоваров);
	Объекты.Добавить(Метаданные.Документы.СписаниеБезналичныхДенежныхСредств);
	Объекты.Добавить(Метаданные.Документы.СписаниеЗадолженности);
	Объекты.Добавить(Метаданные.Документы.СписаниеНДСНаРасходы);
	Объекты.Добавить(Метаданные.Документы.СписаниеНедостачТоваров);
	Объекты.Добавить(Метаданные.Документы.СчетНаОплатуКлиенту);
	Объекты.Добавить(Метаданные.Документы.СчетФактураВыданный);
	Объекты.Добавить(Метаданные.Документы.СчетФактураВыданныйАванс);
	Объекты.Добавить(Метаданные.Документы.СчетФактураКомиссионеру);
	Объекты.Добавить(Метаданные.Документы.СчетФактураКомитента);
	Объекты.Добавить(Метаданные.Документы.СчетФактураНалоговыйАгент);
	Объекты.Добавить(Метаданные.Документы.СчетФактураНаНеподтвержденнуюРеализацию0);
	Объекты.Добавить(Метаданные.Документы.СчетФактураПолученный);
	Объекты.Добавить(Метаданные.Документы.СчетФактураПолученныйАванс);
	Объекты.Добавить(Метаданные.Документы.ТаможеннаяДекларацияИмпорт);
	Объекты.Добавить(Метаданные.Документы.ТранспортнаяНакладная);
	Объекты.Добавить(Метаданные.Документы.УпаковочныйЛист);
	Объекты.Добавить(Метаданные.Документы.УстановкаБлокировокЯчеек);
	Объекты.Добавить(Метаданные.Документы.УстановкаКвотАссортимента);
	Объекты.Добавить(Метаданные.Документы.УстановкаЦенНоменклатуры);
	Объекты.Добавить(Метаданные.Документы.ЧекККМ);
	Объекты.Добавить(Метаданные.Документы.ЧекККМВозврат);
	Объекты.Добавить(Метаданные.Обработки.ЖурналДокументовВнутреннегоТовародвижения);
	Объекты.Добавить(Метаданные.Обработки.ЖурналДокументовЗакупки);
	Объекты.Добавить(Метаданные.Обработки.ЖурналДокументовИнтеркампани);
	Объекты.Добавить(Метаданные.Обработки.ЖурналДокументовПродажи);
	Объекты.Добавить(Метаданные.Обработки.ЖурналДокументовНДС);
	Объекты.Добавить(Метаданные.Обработки.СамообслуживаниеПартнеров);
	Объекты.Добавить(Метаданные.ПланыВидовХарактеристик.СтатьиАктивовПассивов);
	Объекты.Добавить(Метаданные.Справочники.БизнесРегионы);
	Объекты.Добавить(Метаданные.Справочники.ВариантыАнализаЦелевыхПоказателей);
	Объекты.Добавить(Метаданные.Справочники.ВариантыГрафиковКредитовИДепозитов);
	Объекты.Добавить(Метаданные.Справочники.ДоговорыКонтрагентов);
	Объекты.Добавить(Метаданные.Справочники.ДоговорыКредитовИДепозитов);
	Объекты.Добавить(Метаданные.Справочники.ДоговорыМеждуОрганизациями);
	Объекты.Добавить(Метаданные.Справочники.Контрагенты);
	Объекты.Добавить(Метаданные.Справочники.Номенклатура);
	Объекты.Добавить(Метаданные.Справочники.ОбластиХранения);
	Объекты.Добавить(Метаданные.Справочники.Партнеры);
	Объекты.Добавить(Метаданные.Справочники.СделкиСКлиентами);
	Объекты.Добавить(Метаданные.Справочники.СегментыНоменклатуры);
	Объекты.Добавить(Метаданные.Справочники.СегментыПартнеров);
	Объекты.Добавить(Метаданные.Справочники.СкладскиеГруппыНоменклатуры);
	Объекты.Добавить(Метаданные.Справочники.СкладскиеПомещения);
	Объекты.Добавить(Метаданные.Справочники.СкладскиеЯчейки);
	Объекты.Добавить(Метаданные.Справочники.СоглашенияСКлиентами);
	Объекты.Добавить(Метаданные.Справочники.СоглашенияСПоставщиками);
	Объекты.Добавить(Метаданные.Справочники.СтруктураПредприятия);
	Объекты.Добавить(Метаданные.Справочники.СхемыОбеспечения);
	
	
	
	// ИнтеграцияГИСМ
	Объекты.Добавить(Метаданные.Документы.ЗаявкаНаВыпускКиЗГИСМ);
	Объекты.Добавить(Метаданные.Документы.МаркировкаТоваровГИСМ);
	Объекты.Добавить(Метаданные.Документы.ПеремаркировкаТоваровГИСМ);
	Объекты.Добавить(Метаданные.Документы.УведомлениеОбИмпортеМаркированныхТоваровГИСМ);
	Объекты.Добавить(Метаданные.Документы.УведомлениеОбОтгрузкеМаркированныхТоваровГИСМ);
	Объекты.Добавить(Метаданные.Документы.УведомлениеОВвозеМаркированныхТоваровИзЕАЭСГИСМ);
	Объекты.Добавить(Метаданные.Документы.УведомлениеОПоступленииМаркированныхТоваровГИСМ);
	Объекты.Добавить(Метаданные.Документы.УведомлениеОСписанииКиЗГИСМ);
	// Конец ИнтеграцияГИСМ
	
	// ИнтеграцияЕГАИС
	Объекты.Добавить(Метаданные.Документы.АктПостановкиНаБалансЕГАИС);
	Объекты.Добавить(Метаданные.Документы.АктСписанияЕГАИС);
	Объекты.Добавить(Метаданные.Документы.ВозвратИзРегистра2ЕГАИС);
	Объекты.Добавить(Метаданные.Документы.ОстаткиЕГАИС);
	Объекты.Добавить(Метаданные.Документы.ПередачаВРегистр2ЕГАИС);
	Объекты.Добавить(Метаданные.Документы.ТТНВходящаяЕГАИС);
	Объекты.Добавить(Метаданные.Документы.ТТНИсходящаяЕГАИС);
	Объекты.Добавить(Метаданные.Документы.ЧекЕГАИС);
	Объекты.Добавить(Метаданные.Документы.ЧекЕГАИСВозврат);
	// Конец ИнтеграцияЕГАИС
	
	// СтандартныеПодсистемы.Взаимодействия
	Объекты.Добавить(Метаданные.Документы.Встреча);
	Объекты.Добавить(Метаданные.Документы.ЗапланированноеВзаимодействие);
	Объекты.Добавить(Метаданные.Документы.СообщениеSMS);
	Объекты.Добавить(Метаданные.Документы.ТелефонныйЗвонок);
	// Конец СтандартныеПодсистемы.Взаимодействия
	
	//-- НЕ ЕГАИС
	
КонецПроцедуры

// Определение списка глобальных команд отчетов.
//   Событие возникает в процессе вызова модуля повторного использования.
//
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - Таблица команд для вывода в подменю. Для изменения.
//       * Идентификатор - Строка - Идентификатор команды.
//     
//     Настройки внешнего вида:
//       * Представление - Строка   - Представление команды в форме.
//       * Важность      - Строка   - Суффикс группы в подменю, в которой следует вывести эту команду.
//                                    Допустимо использовать: "Важное", "Обычное" и "СмТакже".
//       * Порядок       - Число    - Порядок размещения команды в группе. Используется для настройки под конкретное
//                                    рабочее место.
//       * Картинка      - Картинка - Картинка команды.
//       * СочетаниеКлавиш - СочетаниеКлавиш - Сочетание клавиш для быстрого вызова команды.
//     
//     Настройки видимости и доступности:
//       * ТипПараметра - ОписаниеТипов - Типы объектов, для которых предназначена эта команда.
//       * ВидимостьВФормах    - Строка - Имена форм через запятую, в которых должна отображаться команда.
//                                        Используется когда состав команд отличается для различных форм.
//       * ФункциональныеОпции - Строка - Имена функциональных опций через запятую, определяющих видимость команды.
//       * УсловияВидимости    - Массив - Определяет видимость команды в зависимости от контекста.
//                                        Для регистрации условий следует использовать процедуру
//                                        ПодключаемыеКоманды.ДобавитьУсловиеВидимостиКоманды().
//                                        Условия объединяются по "И".
//       * ИзменяетВыбранныеОбъекты - Булево - Определяет доступность команды в ситуации,
//                                        когда у пользователя нет прав на изменение объекта.
//                                        Если Истина, то в описанной выше ситуации кнопка будет недоступна.
//                                        Необязательный. Значение по умолчанию: Ложь.
//     
//     Настройки процесса выполнения:
//       * МножественныйВыбор - Булево, Неопределено - Если Истина, то команда поддерживает множественный выбор.
//             В этом случае в параметре выполнения будет передан список ссылок.
//             Необязательный. Значение по умолчанию: Истина.
//       * РежимЗаписи - Строка - Действия, связанные с записью объекта, которые выполняются перед обработчиком команды.
//             ** "НеЗаписывать"          - Объект не записывается, а в параметрах обработчика вместо ссылок передается
//                                       вся форма. В этом режиме рекомендуется работать напрямую с формой,
//                                       которая передается в структуре 2 параметра обработчика команды.
//             ** "ЗаписыватьТолькоНовые" - Записывать новые объекты.
//             ** "Записывать"            - Записывать новые и модифицированные объекты.
//             ** "Проводить"             - Проводить документы.
//             Перед записью и проведением у пользователя запрашивается подтверждение.
//             Необязательный. Значение по умолчанию: "Записывать".
//       * ТребуетсяРаботаСФайлами - Булево - Если Истина, то в веб-клиенте предлагается
//             установить расширение работы с файлами.
//             Необязательный. Значение по умолчанию: Ложь.
//     
//     Настройки обработчика:
//       * Менеджер - Строка - Полное имя объекта метаданных, отвечающего за выполнение команды.
//             Пример: "Отчет._ДемоКнигаПокупок".
//       * ИмяФормы - Строка - Имя формы, которую требуется открыть или получить для выполнения команды.
//             Если Обработчик не указан, то у формы вызывается метод "Открыть".
//       * КлючВарианта - Строка - Имя варианта отчета, открываемого при выполнении команды.
//       * ИмяПараметраФормы - Строка - Имя параметра формы, в который следует передать ссылку или массив ссылок.
//       * ПараметрыФормы - Неопределено, Структура - Параметры формы, указанной в ИмяФормы.
//       * Обработчик - Строка - Описание процедуры, обрабатывающей основное действие команды.
//             Формат "<ИмяОбщегоМодуля>.<ИмяПроцедуры>" используется когда процедура размещена в общем модуле.
//             Формат "<ИмяПроцедуры>" используется в следующих случаях:
//               - Если ИмяФормы заполнено то в модуле указанной формы ожидается клиентская процедура.
//               - Если ИмяФормы не заполнено то в модуле менеджера этого объекта ожидается серверная процедура.
//       * ДополнительныеПараметры - Структура - Параметры обработчика, указанного в Обработчик.
//   
//   Параметры - Структура - Сведения о контексте исполнения.
//       * ИмяФормы - Строка - Полное имя формы.
//   
//   СтандартнаяОбработка - Булево - Если установить в Ложь, то событие "ДобавитьКомандыОтчетов" менеджера объекта не
//                                   будет вызвано.
//
Процедура ПередДобавлениемКомандОтчетов(КомандыОтчетов, Параметры, СтандартнаяОбработка) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти
