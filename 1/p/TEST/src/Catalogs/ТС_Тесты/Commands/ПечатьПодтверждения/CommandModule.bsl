//*************************************************************
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура(
		"Параметры,ИмяМенеджераПечати,ЗаголовокФормы",
		ПараметрКоманды,"Справочники.ТС_Тесты.ПечатьПодтверждения","Подтверждение ответа теста");
	ОткрытьФорму("ОбщаяФорма.ТС_ФормаПечати", ПараметрыФормы);
	
КонецПроцедуры
