#Область ПрограммныйИнтерфейс

// Определяет объекты конфигурации, в модулях менеджеров которых размещена процедура ДобавитьКомандыПечати,
// формирующая список команд печати, предоставляемых этим объектом.
// Синтаксис процедуры ДобавитьКомандыПечати см. в документации к подсистеме.
//
// Параметры:
//  СписокОбъектов - Массив - менеджеры объектов с процедурой ДобавитьКомандыПечати.
//
Процедура ПриОпределенииОбъектовСКомандамиПечати(СписокОбъектов) Экспорт
	
	//++ НЕ ГИСМ
	
	
	
	СписокОбъектов.Добавить(Документы.БлокировкаВычетаНДС);
	СписокОбъектов.Добавить(Документы.ОперацияПоЯндексКассе);
	СписокОбъектов.Добавить(Документы.ОрдерНаОтражениеПересортицыТоваров);
	СписокОбъектов.Добавить(Документы.СписаниеНДСНаРасходы);
	СписокОбъектов.Добавить(Обработки.ЖурналДокументовНДС);
	СписокОбъектов.Добавить(Обработки.УправлениеПринятойВозвратнойТарой);
	СписокОбъектов.Добавить(Справочники.ДоговорыМеждуОрганизациями);
	СписокОбъектов.Добавить(Справочники.СтруктураПредприятия);
	
	СписокОбъектов.Добавить(Справочники.ВариантыГрафиковКредитовИДепозитов);
	СписокОбъектов.Добавить(Справочники.ГорячиеКлавиши);
	СписокОбъектов.Добавить(Справочники.ГруппыАналитическогоУчетаНоменклатуры);
	СписокОбъектов.Добавить(Справочники.ГруппыФинансовогоУчетаНоменклатуры);
	СписокОбъектов.Добавить(Справочники.ДоговорыКонтрагентов);
	СписокОбъектов.Добавить(Справочники.ДоговорыКредитовИДепозитов);
	СписокОбъектов.Добавить(Справочники.КартыЛояльности);
	СписокОбъектов.Добавить(Справочники.Контрагенты);
	СписокОбъектов.Добавить(Справочники.Номенклатура);
	СписокОбъектов.Добавить(Справочники.ОбластиХранения);
	СписокОбъектов.Добавить(Справочники.Организации);
	СписокОбъектов.Добавить(Справочники.Партнеры);
	СписокОбъектов.Добавить(Справочники.ПодарочныеСертификаты);
	СписокОбъектов.Добавить(Справочники.ПравилаОбменаСПодключаемымОборудованиемOffline);
	СписокОбъектов.Добавить(Справочники.ПретензииКлиентов);
	СписокОбъектов.Добавить(Справочники.РабочиеУчастки);
	СписокОбъектов.Добавить(Справочники.СделкиСКлиентами);
	СписокОбъектов.Добавить(Справочники.СертификатыНоменклатуры);
	СписокОбъектов.Добавить(Справочники.СкладскиеПомещения);
	СписокОбъектов.Добавить(Справочники.СкладскиеЯчейки);
	СписокОбъектов.Добавить(Справочники.Склады);
	СписокОбъектов.Добавить(Справочники.СоглашенияСКлиентами);
	СписокОбъектов.Добавить(Справочники.СоглашенияСПоставщиками);
	СписокОбъектов.Добавить(Справочники.ФизическиеЛица);
	СписокОбъектов.Добавить(Документы.АвансовыйОтчет);
	СписокОбъектов.Добавить(Документы.АктВыполненныхРабот);
	СписокОбъектов.Добавить(Документы.АктОРасхожденияхПослеОтгрузки);
	СписокОбъектов.Добавить(Документы.АктОРасхожденияхПослеПеремещения);
	СписокОбъектов.Добавить(Документы.АктОРасхожденияхПослеПриемки);
	СписокОбъектов.Добавить(Документы.АктПостановкиНаБалансЕГАИС);
	СписокОбъектов.Добавить(Документы.АктСписанияЕГАИС);
	СписокОбъектов.Добавить(Документы.ВводОстатков);
	СписокОбъектов.Добавить(Документы.ВзаимозачетЗадолженности);
	СписокОбъектов.Добавить(Документы.ВнесениеДенежныхСредствВКассуККМ);
	СписокОбъектов.Добавить(Документы.ВнутреннееПотреблениеТоваров);
	СписокОбъектов.Добавить(Документы.ВозвратИзРегистра2ЕГАИС);
	СписокОбъектов.Добавить(Документы.ВозвратПодарочныхСертификатов);
	СписокОбъектов.Добавить(Документы.ВозвратТоваровМеждуОрганизациями);
	СписокОбъектов.Добавить(Документы.ВозвратТоваровОтКлиента);
	СписокОбъектов.Добавить(Документы.ВозвратТоваровПоставщику);
	СписокОбъектов.Добавить(Документы.ВыемкаДенежныхСредствИзКассыККМ);
	СписокОбъектов.Добавить(Документы.ВыкупВозвратнойТарыКлиентом);
	СписокОбъектов.Добавить(Документы.ДоверенностьВыданная);
	СписокОбъектов.Добавить(Документы.ЗаданиеНаПеревозку);
	СписокОбъектов.Добавить(Документы.ЗаданиеТорговомуПредставителю);
	СписокОбъектов.Добавить(Документы.ЗаказКлиента);
	СписокОбъектов.Добавить(Документы.ЗаказНаВнутреннееПотребление);
	СписокОбъектов.Добавить(Документы.ЗаказНаПеремещение);
	СписокОбъектов.Добавить(Документы.ЗаказНаСборку);
	СписокОбъектов.Добавить(Документы.ЗаказПоставщику);
	СписокОбъектов.Добавить(Документы.ЗаписьКнигиПокупок);
	СписокОбъектов.Добавить(Документы.ЗаписьКнигиПродаж);
	СписокОбъектов.Добавить(Документы.ЗапросАкцизныхМарокЕГАИС);
	СписокОбъектов.Добавить(Документы.ЗаявкаНаВозвратТоваровОтКлиента);
	СписокОбъектов.Добавить(Документы.ЗаявкаНаРасходованиеДенежныхСредств);
	СписокОбъектов.Добавить(Документы.ЗаявлениеОВвозеТоваров);
	СписокОбъектов.Добавить(Документы.ИзменениеАссортимента);
	СписокОбъектов.Добавить(Документы.ИнвентаризационнаяОпись);
	СписокОбъектов.Добавить(Документы.ИнвентаризацияНаличныхДенежныхСредств);
	СписокОбъектов.Добавить(Документы.КоммерческоеПредложениеКлиенту);
	СписокОбъектов.Добавить(Документы.КорректировкаПоОрдеруНаТовары);
	СписокОбъектов.Добавить(Документы.КорректировкаПриобретения);
	СписокОбъектов.Добавить(Документы.КорректировкаРеализации);
	СписокОбъектов.Добавить(Документы.КорректировкаРегистров);
	СписокОбъектов.Добавить(Документы.ЛимитыРасходаДенежныхСредств);
	СписокОбъектов.Добавить(Документы.ЛистКассовойКниги);
	СписокОбъектов.Добавить(Документы.НормативРаспределенияПлановПродажПоКатегориям);
	СписокОбъектов.Добавить(Документы.ОжидаемоеПоступлениеДенежныхСредств);
	СписокОбъектов.Добавить(Документы.ОперацияПоПлатежнойКарте);
	СписокОбъектов.Добавить(Документы.ОприходованиеИзлишковТоваров);
	СписокОбъектов.Добавить(Документы.ОрдерНаОтражениеИзлишковТоваров);
	СписокОбъектов.Добавить(Документы.ОрдерНаОтражениеНедостачТоваров);
	СписокОбъектов.Добавить(Документы.ОрдерНаОтражениеПорчиТоваров);
	СписокОбъектов.Добавить(Документы.ОрдерНаПеремещениеТоваров);
	СписокОбъектов.Добавить(Документы.ОстаткиЕГАИС);
	СписокОбъектов.Добавить(Документы.ОтборРазмещениеТоваров);
	СписокОбъектов.Добавить(Документы.ОтражениеРасхожденийПриИнкассацииДенежныхСредств);
	СписокОбъектов.Добавить(Документы.ОтчетБанкаПоОперациямЭквайринга);
	СписокОбъектов.Добавить(Документы.ОтчетЕГАИС);
	СписокОбъектов.Добавить(Документы.ОтчетКомиссионера);
	СписокОбъектов.Добавить(Документы.ОтчетКомиссионераОСписании);
	СписокОбъектов.Добавить(Документы.ОтчетКомитенту);
	СписокОбъектов.Добавить(Документы.ОтчетКомитентуОСписании);
	СписокОбъектов.Добавить(Документы.ОтчетОРозничныхПродажах);
	СписокОбъектов.Добавить(Документы.ОтчетПоКомиссииМеждуОрганизациями);
	СписокОбъектов.Добавить(Документы.ОтчетПоКомиссииМеждуОрганизациямиОСписании);
	СписокОбъектов.Добавить(Документы.ПередачаВРегистр2ЕГАИС);
	СписокОбъектов.Добавить(Документы.ПередачаТоваровМеждуОрганизациями);
	СписокОбъектов.Добавить(Документы.ПеремещениеТоваров);
	СписокОбъектов.Добавить(Документы.ПересортицаТоваров);
	СписокОбъектов.Добавить(Документы.ПересчетТоваров);
	СписокОбъектов.Добавить(Документы.ПланЗакупок);
	СписокОбъектов.Добавить(Документы.ПланПродаж);
	СписокОбъектов.Добавить(Документы.ПланПродажПоКатегориям);
	СписокОбъектов.Добавить(Документы.ПланСборкиРазборки);
	СписокОбъектов.Добавить(Документы.ПорчаТоваров);
	СписокОбъектов.Добавить(Документы.ПоручениеЭкспедитору);
	СписокОбъектов.Добавить(Документы.ПоступлениеБезналичныхДенежныхСредств);
	СписокОбъектов.Добавить(Документы.ПоступлениеТоваров);
	СписокОбъектов.Добавить(Документы.ПриобретениеТоваровУслуг);
	СписокОбъектов.Добавить(Документы.ПриобретениеУслугПрочихАктивов);
	СписокОбъектов.Добавить(Документы.ПриходныйКассовыйОрдер);
	СписокОбъектов.Добавить(Документы.ПриходныйОрдерНаТовары);
	СписокОбъектов.Добавить(Документы.ПрочееОприходованиеТоваров);
	СписокОбъектов.Добавить(Документы.ПрочиеДоходыРасходы);
	СписокОбъектов.Добавить(Документы.РаспоряжениеНаПеремещениеДенежныхСредств);
	СписокОбъектов.Добавить(Документы.РаспределениеДоходовИРасходовПоНаправлениямДеятельности);
	СписокОбъектов.Добавить(Документы.РаспределениеНДС);
	СписокОбъектов.Добавить(Документы.РаспределениеРасходовБудущихПериодов);
	СписокОбъектов.Добавить(Документы.РасходныйКассовыйОрдер);
	СписокОбъектов.Добавить(Документы.РасходныйОрдерНаТовары);
	СписокОбъектов.Добавить(Документы.РасчетСебестоимостиТоваров);
	СписокОбъектов.Добавить(Документы.РеализацияПодарочныхСертификатов);
	СписокОбъектов.Добавить(Документы.РеализацияТоваровУслуг);
	СписокОбъектов.Добавить(Документы.РеализацияУслугПрочихАктивов);
	СписокОбъектов.Добавить(Документы.РегистрацияЦенНоменклатурыПоставщика);
	СписокОбъектов.Добавить(Документы.СборкаТоваров);
	СписокОбъектов.Добавить(Документы.СверкаВзаиморасчетов);
	СписокОбъектов.Добавить(Документы.СписаниеБезналичныхДенежныхСредств);
	СписокОбъектов.Добавить(Документы.СписаниеЗадолженности);
	СписокОбъектов.Добавить(Документы.СписаниеНедостачТоваров);
	СписокОбъектов.Добавить(Документы.СчетНаОплатуКлиенту);
	СписокОбъектов.Добавить(Документы.СчетФактураВыданный);
	СписокОбъектов.Добавить(Документы.СчетФактураВыданныйАванс);
	СписокОбъектов.Добавить(Документы.СчетФактураКомиссионеру);
	СписокОбъектов.Добавить(Документы.СчетФактураНалоговыйАгент);
	СписокОбъектов.Добавить(Документы.СчетФактураНаНеподтвержденнуюРеализацию0);
	СписокОбъектов.Добавить(Документы.СчетФактураПолученныйАванс);
	СписокОбъектов.Добавить(Документы.ТаможеннаяДекларацияИмпорт);
	СписокОбъектов.Добавить(Документы.ТранспортнаяНакладная);
	СписокОбъектов.Добавить(Документы.ТТНВходящаяЕГАИС);
	СписокОбъектов.Добавить(Документы.ТТНИсходящаяЕГАИС);
	СписокОбъектов.Добавить(Документы.УпаковочныйЛист);
	СписокОбъектов.Добавить(Документы.УстановкаБлокировокЯчеек);
	СписокОбъектов.Добавить(Документы.УстановкаКвотАссортимента);
	СписокОбъектов.Добавить(Документы.УстановкаЦенНоменклатуры);
	СписокОбъектов.Добавить(Документы.ЧекЕГАИС);
	СписокОбъектов.Добавить(Документы.ЧекЕГАИСВозврат);
	СписокОбъектов.Добавить(Документы.ЧекККМ);
	СписокОбъектов.Добавить(Документы.ЧекККМВозврат);
	СписокОбъектов.Добавить(Обработки.ПечатьЗаданияНаОтборРазмещениеТоваров);
	СписокОбъектов.Добавить(Обработки.РабочееМестоМенеджераПоДоставке);
	СписокОбъектов.Добавить(Обработки.СамообслуживаниеПартнеров);
	СписокОбъектов.Добавить(Обработки.УправлениеОтгрузкой);
	СписокОбъектов.Добавить(Обработки.УправлениеПереданнойВозвратнойТарой);
	СписокОбъектов.Добавить(Обработки.УправлениеПоступлением);
	СписокОбъектов.Добавить(Обработки.ЖурналСкладскихАктов);
	//-- НЕ ГИСМ
	
КонецПроцедуры

// Переопределяет таблицу возможных форматов для сохранения табличного документа.
// Вызывается из ОбщегоНазначения.НастройкиФорматовСохраненияТабличногоДокумента().
// Используется в случае, когда необходимо сократить список форматов сохранения, предлагаемый пользователю
// перед сохранением печатной формы в файл, либо перед отправкой по почте.
//
// Параметры:
//  ТаблицаФорматов - ТаблицаЗначений - коллекция форматов сохранения:
//   * ТипФайлаТабличногоДокумента - ТипФайлаТабличногоДокумента - значение в платформе, соответствующее формату;
//   * Ссылка        - ПеречислениеСсылка.ФорматыСохраненияОтчетов - ссылка на метаданные, где хранится представление;
//   * Представление - Строка - представление типа файла (заполняется из перечисления);
//   * Расширение    - Строка - тип файла для операционной системы;
//   * Картинка      - Картинка - значок формата.
//
Процедура ПриЗаполненииНастроекФорматовСохраненияТабличногоДокумента(ТаблицаФорматов) Экспорт
	
КонецПроцедуры

// Переопределяет список команд печати, получаемый функцией УправлениеПечатью.КомандыПечатиФормы.
// Используется для общих форм, у которых нет модуля менеджера для размещения в нем процедуры ДобавитьКомандыПечати,
// для случаев, когда штатных средств добавления команд в такие формы недостаточно. Например, если нужны свои команды,
// которых нет в других объектах.
// 
// Параметры:
//  ИмяФормы             - Строка - полное имя формы, в которой добавляются команды печати;
//  КомандыПечати        - ТаблицаЗначений - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати;
//  СтандартнаяОбработка - Булево - при установке значения Ложь не будет автоматически заполняться коллекция КомандыПечати.
//
Процедура ПередДобавлениемКомандПечати(ИмяФормы, КомандыПечати, СтандартнаяОбработка) Экспорт
	
	//++ НЕ ГИСМ
	
	Если ИмяФормы = "Документ.ОрдерНаОтражениеПорчиТоваров.Форма.ФормаСписка" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		КоллекцияКомандПечати = УправлениеПечатью.СоздатьКоллекциюКомандПечати();
		Документы.СписаниеБезналичныхДенежныхСредств.ДобавитьКомандыПечати(КоллекцияКомандПечати);
		Для Каждого КомандаПечати Из КоллекцияКомандПечати Цикл
			Если ПустаяСтрока(КомандаПечати.МенеджерПечати) Тогда
				КомандаПечати.МенеджерПечати = "Документ.ОрдерНаОтражениеПорчиТоваров";
			КонецЕсли;
		КонецЦикла;
		ДополнительныеОтчетыИОбработки.ПриПолученииКомандПечати(КоллекцияКомандПечати, "Документ.ОрдерНаОтражениеПорчиТоваров");
		КоллекцияКомандПечати.ЗаполнитьЗначения("СписокОрдеровКоманднаяПанель", "МестоРазмещения");
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(КоллекцияКомандПечати, КомандыПечати);
		
	
	ИначеЕсли ИмяФормы = "ЖурналДокументов.ОтчетыКомитентам.Форма.ФормаСпискаДокументов" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		Документы.ОтчетКомитенту.ДобавитьКомандыПечати(КомандыПечати);
		Для Каждого КомандаПечати Из КомандыПечати Цикл
			Если ПустаяСтрока(КомандаПечати.МенеджерПечати) Тогда
				КомандаПечати.МенеджерПечати = "Документ.ОтчетКомитенту";
			КонецЕсли;
		КонецЦикла;
		
		ДобавляемыеКомандыПечати = УправлениеПечатью.СоздатьКоллекциюКомандПечати();
		Документы.ОтчетКомитентуОСписании.ДобавитьКомандыПечати(ДобавляемыеКомандыПечати);
		Для Каждого КомандаПечати Из ДобавляемыеКомандыПечати Цикл
			Если ПустаяСтрока(КомандаПечати.МенеджерПечати) Тогда
				КомандаПечати.МенеджерПечати = "Документ.ОтчетКомитентуОСписании";
			КонецЕсли;
			Отбор = Новый Структура("Идентификатор,Представление,МенеджерПечати,Обработчик");
			ЗаполнитьЗначенияСвойств(Отбор, КомандаПечати);
			НайденныеКоманды = КомандыПечати.НайтиСтроки(Отбор);
			Если НайденныеКоманды.Количество() = 0 Тогда
				ЗаполнитьЗначенияСвойств(КомандыПечати.Добавить(), КомандаПечати);
			КонецЕсли;
		КонецЦикла;
		
		ДополнительныеОтчетыИОбработки.ПриПолученииКомандПечати(КомандыПечати, "Документ.ОтчетКомитенту");
		ДополнительныеОтчетыИОбработки.ПриПолученииКомандПечати(КомандыПечати, "Документ.ОтчетКомитентуОСписании");
	
	ИначеЕсли ИмяФормы = "Обработка.ЖурналДокументовЗакупки.Форма.ФормаВыбораРаспоряжения" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		Документы.ЗаказПоставщику.ДобавитьКомандыПечати(КомандыПечати);
		Для Каждого КомандаПечати Из КомандыПечати Цикл
			Если ПустаяСтрока(КомандаПечати.МенеджерПечати) Тогда
				КомандаПечати.МенеджерПечати = "Документ.ЗаказПоставщику";
			КонецЕсли;
		КонецЦикла;
		
		ДополнительныеОтчетыИОбработки.ПриПолученииКомандПечати(КомандыПечати, "Документ.ЗаказПоставщику");
	
	ИначеЕсли ИмяФормы = "Справочник.СертификатыНоменклатуры.Форма.ФормаСпискаКонтекст" 
	 ИЛИ ИмяФормы = "Справочник.СертификатыНоменклатуры.Форма.ФормаСписка" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		Справочники.СертификатыНоменклатуры.ДобавитьКомандыПечати(КомандыПечати);	
		КомандыПечати.ЗаполнитьЗначения("КоманднаяПанельСписокСертификатыНоменклатурыПечать", "МестоРазмещения");
		
		ДополнительныеОтчетыИОбработки.ПриПолученииКомандПечати(КомандыПечати, "Справочник.СертификатыНоменклатуры");
		
	ИначеЕсли ИмяФормы = "Документ.ОтчетКомитенту.Форма.ФормаОформленияСчетовФактур" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		КоллекцияКомандПечати = УправлениеПечатью.СоздатьКоллекциюКомандПечати();
		
		// Счет-фактура
		КомандаПечати = КоллекцияКомандПечати.Добавить();
		КомандаПечати.МенеджерПечати = "Обработка.ПечатьОбщихФорм";
		КомандаПечати.Идентификатор = "СчетФактура";
		КомандаПечати.Представление = НСтр("ru = 'Счет-фактура'");
		КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
		КомандаПечати.ДополнительныеПараметры.Вставить("ПечатьВВалюте", Ложь);
		КомандаПечати.Порядок = 1;
		
		Если НЕ ПраваПользователяПовтИсп.ЭтоПартнер() Тогда
			// Счет-фактура (в валюте)
			КомандаПечати = КоллекцияКомандПечати.Добавить();
			КомандаПечати.МенеджерПечати = "Обработка.ПечатьОбщихФорм";
			КомандаПечати.Идентификатор = "СчетФактураВВалюте";
			КомандаПечати.Представление = НСтр("ru = 'Счет-фактура (в валюте)'");
			КомандаПечати.ФункциональныеОпции = "ИспользоватьНесколькоВалют";
			КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
			КомандаПечати.ДополнительныеПараметры.Вставить("ПечатьВВалюте", Истина);
			КомандаПечати.Порядок = 2;
		КонецЕсли;
		КоллекцияКомандПечати.ЗаполнитьЗначения("ДокументыРеализацииКоманднаяПанель", "МестоРазмещения");
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(КоллекцияКомандПечати, КомандыПечати);
		
	ИначеЕсли ИмяФормы = "Документ.СчетФактураНалоговыйАгент.Форма.ФормаРабочееМесто" Тогда 
		
		СтандартнаяОбработка = Ложь; 
		КоллекцияКомандПечати = УправлениеПечатью.СоздатьКоллекциюКомандПечати(); 
		Документы.СчетФактураНалоговыйАгент.ДобавитьКомандыПечати(КоллекцияКомандПечати); 
		ДополнительныеОтчетыИОбработки.ПриПолученииКомандПечати(КоллекцияКомандПечати, "Документ.СчетФактураНалоговыйАгент"); 
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(КоллекцияКомандПечати, КомандыПечати);
		
	ИначеЕсли ИмяФормы = "РегистрСведений.НДССостояниеРеализации0.Форма.ФормаРабочееМесто" Тогда 
		
		СтандартнаяОбработка = Ложь; 
		КоллекцияКомандПечати = УправлениеПечатью.СоздатьКоллекциюКомандПечати(); 
		Документы.СчетФактураНаНеподтвержденнуюРеализацию0.ДобавитьКомандыПечати(КоллекцияКомандПечати); 
		ДополнительныеОтчетыИОбработки.ПриПолученииКомандПечати(КоллекцияКомандПечати, "Документ.СчетФактураНаНеподтвержденнуюРеализацию0"); 
		КоллекцияКомандПечати.ЗаполнитьЗначения("СписокКоманднаяПанель", "МестоРазмещения"); 
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(КоллекцияКомандПечати, КомандыПечати);
		
	ИначеЕсли ИмяФормы = "Документ.ЗапросАкцизныхМарокЕГАИС.Форма.ФормаДокумента"
		ИЛИ ИмяФормы = "Документ.ЗапросАкцизныхМарокЕГАИС.Форма.ФормаСписка" Тогда
		
		СтандартнаяОбработка = Ложь;
		Если НЕ ПраваПользователяПовтИсп.ПечатьЭтикетокИЦенников() Тогда
			Возврат;
		КонецЕсли;
		
		КоллекцияКомандПечати = УправлениеПечатью.СоздатьКоллекциюКомандПечати();
		
		КомандаПечати = КоллекцияКомандПечати.Добавить();
		КомандаПечати.Обработчик = "УправлениеПечатьюУТКлиент.ПечатьАкцизныхМарок";
		КомандаПечати.Идентификатор = "АкцизныеМарки";
		КомандаПечати.Представление = НСтр("ru = 'Печать акцизных марок'");
		КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
		
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(КоллекцияКомандПечати, КомандыПечати);
		
	КонецЕсли;
	
	//-- НЕ ГИСМ
	
КонецПроцедуры

// Дополнительные настройки списка команд печати в журналах документов.
//
// Параметры:
//  НастройкиСписка - Структура - модификаторы списка команд печати.
//   * МенеджерКомандПечати     - МенеджерОбъекта - менеджер объекта, в котором формируется список команд печати;
//   * АвтоматическоеЗаполнение - Булево - заполнять команды печати из объектов, входящих в состав журнала.
//                                         Если установлено значение Ложь, то список команд печати журнала будет
//                                         заполнен вызовом метода ДобавитьКомандыПечати из модуля менеджера журнала.
//                                         Значение по умолчанию: Истина - метод ДобавитьКомандыПечати будет вызван из
//                                         модулей менеджеров документов, входящих в состав журнала.
Процедура ПриПолученииНастроекСпискаКомандПечати(НастройкиСписка) Экспорт
	
	//++ НЕ ЕГАИС
	
	
	//-- НЕ ЕГАИС
	
КонецПроцедуры

// Вызывается после завершения вызова процедуры Печать менеджера печати объекта, имеет те же параметры.
// Может использоваться для постобработки всех печатных форм при их формировании.
// Например, можно вставить в колонтитул дату формирования печатной формы.
//
// Параметры:
//  МассивОбъектов - Массив - список объектов, для которых была выполнена процедура Печать;
//  ПараметрыПечати - Структура - произвольные параметры, переданные при вызове команды печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - содержит табличные документы и дополнительную информацию;
//  ОбъектыПечати - СписокЗначений - соответствие между объектами и именами областей в табличных документах, где
//                                   значение - Объект, представление - имя области с объектом в табличных документах;
//  ПараметрыВывода - Структура - параметры, связанные с выводом табличных документов:
//   * ПараметрыОтправки - Структура - информация для заполнения письма при отправке печатной формы по электронной почте.
//                                     Содержит следующие поля (описание см. в общем модуле конфигурации
//                                     РаботаСПочтовымиСообщениямиКлиент в процедуре СоздатьНовоеПисьмо):
//    ** Получатель;
//    ** Тема,
//    ** Текст.
Процедура ПриПечати(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	//++ НЕ ЕГАИС
	Если ТипЗнч(МассивОбъектов) = Тип("Массив")
		И МассивОбъектов.Количество()
		И ТипЗнч(МассивОбъектов[0]) = Тип("ДокументСсылка.ЗаданиеНаПеревозку") Тогда
		ДоставкаТоваров.ПриПечати(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
	ИначеЕсли ТипЗнч(МассивОбъектов) = Тип("ДокументСсылка.ЗаданиеНаПеревозку") Тогда
		МассивЗаданий = Новый Массив;
		МассивЗаданий.Добавить(МассивОбъектов);
		ДоставкаТоваров.ПриПечати(МассивЗаданий, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
	КонецЕсли;
	//-- НЕ ЕГАИС
	
КонецПроцедуры

// Переопределяет параметры отправки печатных форм при подготовке письма.
// Может использоваться, например, для подготовки текста письма.
//
// Параметры:
//  ПараметрыОтправки - Структура - коллекция параметров:
//   * Получатель - Массив - коллекция имен получателей;
//   * Тема - Строка - тема письма;
//   * Текст - Строка - текст письма;
//   * Вложения - Структура - коллекция вложений:
//    ** АдресВоВременномХранилище - Строка - адрес вложения во временном хранилище;
//    ** Представление - Строка - имя файла вложения.
//  ОбъектыПечати - Массив - коллекция объектов, по которым сформированы печатные формы.
//  ПараметрыВывода - Структура - параметр ПараметрыВывода в вызове процедуры Печать.
//  ПечатныеФормы - ТаблицаЗначений - коллекция табличных документов:
//   * Название - Строка - название печатной формы;
//   * ТабличныйДокумент - ТабличныйДокумент - печатая форма.
Процедура ПередОтправкойПоПочте(ПараметрыОтправки, ПараметрыВывода, ОбъектыПечати, ПечатныеФормы) Экспорт
	
КонецПроцедуры

#КонецОбласти
