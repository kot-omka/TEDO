﻿
&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	Если Элементы.Список.ТекущаяСтрока <> Неопределено И ЗначениеЗаполнено(Элементы.Список.ТекущаяСтрока) Тогда
		ИнициализироватьОтборПоКурсу(Элементы.Список.ТекущиеДанные.Ссылка)
	Иначе
		ИнициализироватьОтборПоКурсу()
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьОтборПоКурсу(Курс = Неопределено)
	
	ЭлементыОтбора = НаборыТестов.КомпоновщикНастроек.Настройки.Отбор.Элементы;
	ОтборДобавлен = Ложь;
	ПолеКДВладелец = Новый ПолеКомпоновкиДанных("Владелец");
	
	Если Курс = Неопределено Тогда
		Курс = Справочники.ТС_Курсы.ПустаяСсылка()
	КонецЕсли;

	//Изменим существующий отбор
	Для Каждого Элемент Из ЭлементыОтбора Цикл
		Если Элемент.ЛевоеЗначение = ПолеКДВладелец Тогда
			Элемент.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
			Элемент.Использование = Истина;
			Элемент.ПравоеЗначение = Курс;
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
		ОтборПоКурсу.ПравоеЗначение = Курс;
		ОтборПоКурсу.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	//
	//Если НЕ Курс.Пустая() Тогда
	//	ИнициализироватьОтборПоКурсу(Курс);
	//КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Элементы.Список.ТекущаяСтрока <> Неопределено Тогда
		ИнициализироватьОтборПоКурсу(Элементы.Список.ТекущиеДанные.Ссылка)
	КонецЕсли;
КонецПроцедуры
