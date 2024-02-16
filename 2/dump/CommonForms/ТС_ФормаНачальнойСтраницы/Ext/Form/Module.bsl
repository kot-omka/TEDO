﻿///////////////////////////////////////////////////////////////
// СОБЫТИЯ ФОРМЫ

//***********************************************************************
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЭтаФорма.ТекущийПользователь = ПараметрыСеанса.ТС_ТекущийПользователь;
	ЭтаФорма.ПрограммыОбучения.Параметры.УстановитьЗначениеПараметра("Пользователь",ЭтаФорма.ТекущийПользователь);
	
	ЭтаФорма.Элементы.ГруппаПрограммыОбучения.Видимость = Константы.ТС_ИспользоватьПрограммыОбучения.Получить();

КонецПроцедуры



///////////////////////////////////////////////////////////////
// ДЕЙСТВИЯ ФОРМЫ

//***********************************************************************
&НаКлиенте
Процедура НастройкиПользователя(Команда)
	
	ОбработкаЗакрытия = Новый ОписаниеОповещения("НастройкиПользователяЗавершение",ЭтаФорма,);
	СтруктураПараметров = Новый Структура("Ключ",ЭтаФорма.ТекущийПользователь);
	ОткрытьФорму("Справочник.ТС_Пользователи.Форма.ФормаЭлемента",СтруктураПараметров,,,,,ОбработкаЗакрытия);
	
КонецПроцедуры

//***********************************************************************
&НаКлиенте
Процедура НастройкиПользователяЗавершение(РезультатЗакрытия,ДополнительныеПараметры) Экспорт
	
	ОбновитьФорму(Неопределено);
	
КонецПроцедуры

//***********************************************************************
&НаКлиенте
Процедура ОбновитьФорму(Команда)
	
	ЭтаФорма.ОбновитьОтображениеДанных();
	Элементы.ПрограммыОбучения.Обновить(); 
	
КонецПроцедуры 

//***********************************************************************
&НаКлиенте
Процедура ПродолжитьОбучение(Команда)
	
	ТекущиеДанные = Элементы.ПрограммыОбучения.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		НачатьНовоеОбучение(Неопределено);	
	Иначе	
		СтруктураПараметров = Новый Структура(
			"Курс,Пользователь,ПрограммаОбучения",
			ТекущиеДанные.Курс,ЭтаФорма.ТекущийПользователь,ТекущиеДанные.ПрограммаОбучения);
		ФормаТестирования = ПолучитьФорму("Обработка.ТС_Тестирование.Форма.ФормаТестирования",СтруктураПараметров);
		ФормаТестирования.Открыть();
	КонецЕсли;	
	
КонецПроцедуры

//***********************************************************************
&НаКлиенте
Процедура НачатьНовоеОбучение(Команда)
	
	ФормаТестирования = ПолучитьФорму("Обработка.ТС_Тестирование.Форма.Форма");
	ФормаТестирования.Открыть();
	
КонецПроцедуры

//***********************************************************************
&НаКлиенте
Процедура ПрограммыОбученияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ПродолжитьОбучение(Неопределено);
	
КонецПроцедуры




