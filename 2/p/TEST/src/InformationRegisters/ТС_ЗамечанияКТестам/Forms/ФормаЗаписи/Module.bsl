///////////////////////////////////////////////////////////////
// СОБЫТИЯ ФОРМЫ

//*************************************************************
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//Если новая запись, заполним параметры
	Если НЕ ЗначениеЗаполнено(Запись.Дата) Тогда
		Если Параметры.Свойство("Курс") Тогда
			Запись.Курс = Параметры.Курс;
			ЭтаФорма.Элементы.Курс.Доступность = Ложь;
		КонецЕсли;
		Если Параметры.Свойство("Пользователь") Тогда
			Запись.Инициатор = Параметры.Пользователь;
			Этаформа.Элементы.Инициатор.Доступность = Ложь;
		КонецЕсли;
		Если Параметры.Свойство("Тест") Тогда
			Запись.Тест = Параметры.Тест;
			ЭтаФорма.Элементы.Тест.Доступность = Ложь;
		КонецЕсли;
		Если Параметры.Свойство("Вид") Тогда
			Запись.Вид = Параметры.Вид;
		КонецЕсли;
		Запись.Дата = ТекущаяДата();
	КонецЕсли;	
	
КонецПроцедуры	

//*************************************************************
&НаКлиенте
Процедура ИсполненПриИзменении(Элемент)
	
	ИсполненПриИзмененииСервер();
		
КонецПроцедуры

//*************************************************************
&НаСервере
Процедура ИсполненПриИзмененииСервер()
	
	Запись.Модератор = ПараметрыСеанса.ТС_ТекущийПользователь;
	
КонецПроцедуры	


