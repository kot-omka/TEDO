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
	
	Если Параметры.Свойство("Отбор") И Параметры.Отбор.Свойство("Владелец") Тогда
		Курс = Параметры.Отбор.Владелец;
		Элементы.Курс.Доступность = Ложь;
	ИначеЕсли НЕ Курс.Пустая() Тогда
		ИнициализироватьОтборПоКурсу(Курс);
	КонецЕсли;	
	
КонецПроцедуры



///////////////////////////////////////////////////////////////
// ДЕЙСТВИЯ ФОРМЫ

//*************************************************************
//&НаКлиенте
//Процедура КурсПриИзменении(Элемент)
//	
//	ИнициализироватьОтборПоКурсу(Курс);
//	
//КонецПроцедуры

//*************************************************************
&НаСервере
Процедура ИнициализироватьОтборПоКурсу(Курс)
	
	ЭлементыОтбора = Список.КомпоновщикНастроек.Настройки.Отбор.Элементы;
	ОтборДобавлен = Ложь;
	ПолеКДВладелец = Новый ПолеКомпоновкиДанных("Владелец");

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

//*************************************************************
&НаКлиенте
Процедура ПройтиТестирование(Команда)
	
	Если Не ЗначениеЗаполнено(ЭтаФорма.Курс) Тогда
		ПоказатьПредупреждение(,"Выберите курс!");
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		ПоказатьПредупреждение(,"Выберите элемент справочника для прохождения тестирования!");
		Возврат;
	КонецЕсли;
	
	ТекЭлемент = ТекущиеДанные.Ссылка;
	Если ТипЗнч(ТекЭлемент) <> Тип("СправочникСсылка.ТС_НаборыТестов") 
		ИЛИ ЭтоГруппа(ТекЭлемент) Тогда
		ПоказатьПредупреждение(,"Выберите элемент справочника для прохождения тестирования!");
		Возврат;
	КонецЕсли;
	
	//Откроем форму тестирования
	СтруктураПараметров = Новый Структура(
		"Курс,Пользователь,НаборТестов,
		|Избранное,УдалятьТестыИзИзбранного",
		Этаформа.Курс,ТС_ОбщегоНазначенияКлиент.ПолучитьТекущегоПользователя(),ТекЭлемент,
		Ложь,Ложь);
	ФормаТестирования = ПолучитьФорму("Обработка.ТС_Тестирование.Форма.ФормаТестирования",СтруктураПараметров);
	ФормаТестирования.Открыть();
	
КонецПроцедуры

&НаСервере 
//*************************************************************
Функция ЭтоГруппа(Ссылка)
	
	Возврат Ссылка.ЭтоГруппа;
	
КонецФункции

&НаСервереБезКонтекста
Процедура СлучайныйПодборНаСервере(Набор, Курс)
	
	МассивВопросов = Справочники.ТС_НаборыТестов.ПолучитьРандомныйНаборВопросов(Курс);
	
	НаборОбъект = Набор.ПолучитьОбъект();
	НаборОбъект.Содержание.Очистить();
	Для Каждого Вопрос Из МассивВопросов Цикл
		НоваяСтрока = НаборОбъект.Содержание.Добавить();
		НоваяСтрока.Тест = Вопрос;
	КонецЦикла; 
	Попытка
		НаборОбъект.Записать();
	Исключение
	    Сообщить(ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки; 
КонецПроцедуры


&НаКлиенте
Процедура СлучайныйПодбор(Команда)
	Если Не ЗначениеЗаполнено(ЭтаФорма.Курс) Тогда
		ПоказатьПредупреждение(,"Выберите курс!");
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		ПоказатьПредупреждение(,"Выберите элемент справочника для генерирования!");
		Возврат;
	КонецЕсли;
	
	ТекЭлемент = ТекущиеДанные.Ссылка;
	Если ТипЗнч(ТекЭлемент) <> Тип("СправочникСсылка.ТС_НаборыТестов") 
		ИЛИ ЭтоГруппа(ТекЭлемент) Тогда
		ПоказатьПредупреждение(,"Выберите элемент справочника для прохождения тестирования!");
		Возврат;
	КонецЕсли;
	
	СлучайныйПодборНаСервере(ТекЭлемент, ЭтаФорма.Курс);
	
КонецПроцедуры


&НаКлиенте
Процедура Перемешать(Команда)
	Если Не ЗначениеЗаполнено(ЭтаФорма.Курс) Тогда
		ПоказатьПредупреждение(,"Выберите курс!");
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		ПоказатьПредупреждение(,"Выберите элемент справочника для генерирования!");
		Возврат;
	КонецЕсли;
	
	ТекЭлемент = ТекущиеДанные.Ссылка;
	Если ТипЗнч(ТекЭлемент) <> Тип("СправочникСсылка.ТС_НаборыТестов") 
		ИЛИ ЭтоГруппа(ТекЭлемент) Тогда
		ПоказатьПредупреждение(,"Выберите элемент справочника для прохождения тестирования!");
		Возврат;
	КонецЕсли;
	
	ПеремешатьНаСервере(ТекЭлемент);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПеремешатьНаСервере(Набор)
	
	НаборОбъект = Набор.ПолучитьОбъект();
	МассивВопросов = НаборОбъект.Содержание.Выгрузить(, "Тест").ВыгрузитьКолонку("Тест");
	Справочники.ТС_НаборыТестов.ПеремешатьНабор(МассивВопросов);
	НаборОбъект.Содержание.Очистить();
	Для Каждого Вопрос Из МассивВопросов Цикл
		НоваяСтрока = НаборОбъект.Содержание.Добавить();
		НоваяСтрока.Тест = Вопрос;
	КонецЦикла;
	Попытка
		НаборОбъект.Записать();
	Исключение
	    Сообщить(ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки; 
КонецПроцедуры

&НаКлиенте
Процедура КурсыПриАктивизацииСтроки(Элемент)
	Если Элементы.Курсы.ТекущиеДанные <> Неопределено Тогда
		ИнициализироватьОтборПоКурсу(Элементы.Курсы.ТекущиеДанные.Ссылка);
	КонецЕсли;
КонецПроцедуры
