///////////////////////////////////////////////////////////////
// СОБЫТИЯ ФОРМЫ

//*************************************************************
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//отображение картинки при открытии формы справочника
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Изображение = ПолучитьНавигационнуюСсылку(Объект.Ссылка, "Изображение");
		Элементы.Изображение.Видимость = Истина;
	Иначе
		Элементы.Изображение.Видимость = Ложь;
	КонецЕсли;

КонецПроцедуры
