﻿//*******************************************************************
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ТС_РезультатТестирования") Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТС_РезультатТестированияТесты.Ссылка.Курс,
		|	ТС_РезультатТестированияТесты.Тест
		|ИЗ
		|	Документ.ТС_РезультатТестирования.Тесты КАК ТС_РезультатТестированияТесты
		|ГДЕ
		|	ТС_РезультатТестированияТесты.Ссылка = &Ссылка
		|
		|УПОРЯДОЧИТЬ ПО
		|	ТС_РезультатТестированияТесты.НомерСтроки";
		
		Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения);	
		ВыборкаДетальныеЗаписи = Запрос.Выполнить().Выбрать(); 	
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			
			Если Владелец = Справочники.ТС_Курсы.ПустаяСсылка() Тогда
				Владелец = ВыборкаДетальныеЗаписи.Курс;
			КонецЕсли;
			
			Содержание.Добавить().Тест = ВыборкаДетальныеЗаписи.Тест;		
			
		КонецЦикла;
	
	КонецЕсли;

КонецПроцедуры
