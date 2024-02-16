///////////////////////////////////////////////////////////////
// СОБЫТИЯ ФОРМЫ

//*************************************************************
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Видякин С. - устранение ошибки когда элемент не найден и изменить его нельзя, когда позже загрузится сохраненный
	//Если Параметры.Свойство("Отбор") И Параметры.Отбор.Свойство("Владелец") Тогда
	//	Курс = Параметры.Отбор.Владелец;
	//	Элементы.Курс.Доступность = Ложь;
	//Иначе
	//	ИнициализироватьОтборПоКурсу();
	//КонецЕсли;	
	
КонецПроцедуры

//*************************************************************
&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	// Видякин С. - если есть отбор, перекрываем сохраненное значение им, а если нет то инициируем отбор только если курс есть
	Если Параметры.Свойство("Отбор") И Параметры.Отбор.Свойство("Владелец") Тогда
		Курс = Параметры.Отбор.Владелец;
		Элементы.Курс.Доступность = Ложь;
	ИначеЕсли НЕ Курс.Пустая() Тогда
		ИнициализироватьОтборПоКурсу();
	КонецЕсли;	
	
КонецПроцедуры



///////////////////////////////////////////////////////////////
// ДЕЙСТВИЯ ФОРМЫ

//*************************************************************
&НаКлиенте
Процедура КурсПриИзменении(Элемент)
	
	ИнициализироватьОтборПоКурсу();
	
КонецПроцедуры

//*************************************************************
&НаСервере
Процедура ИнициализироватьОтборПоКурсу()
	
	ЭлементыОтбора = ЭтаФорма.Список.КомпоновщикНастроек.Настройки.Отбор.Элементы;
	ОтборДобавлен = Ложь;
	ПолеКДВладелец = Новый ПолеКомпоновкиДанных("Владелец");

	//Изменим существующий отбор
	Для Каждого Элемент Из ЭлементыОтбора Цикл
		Если Элемент.ЛевоеЗначение = ПолеКДВладелец Тогда
			Элемент.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
			Элемент.Использование = Истина;
			Элемент.ПравоеЗначение = ЭтаФорма.Курс;
			Элемент.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
			ОтборДобавлен = Истина;
		КонецЕсли
	КонецЦикла;
	
	//Добавим новый отбор
	Если НЕ ОтборДобавлен Тогда
		
		ОтборПоКурсу = ЭлементыОтбора.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборПоКурсу.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборПоКурсу.Использование = Истина;
		ОтборПоКурсу.ЛевоеЗначение = ПолеКДВладелец;		
		ОтборПоКурсу.ПравоеЗначение = ЭтаФорма.Курс;
		ОтборПоКурсу.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
		
	КонецЕсли;
	
КонецПроцедуры


