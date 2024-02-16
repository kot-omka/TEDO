﻿
&НаКлиенте
Процедура ВыполнитьНумерациюРазделов(Команда)
	ВыполнитьНумерациюРазделовНаСервере();
	СообщитьПользователю("Обработка завершена");
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ВыполнитьНумерациюРазделовНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТС_Тесты.Ссылка КАК Ссылка,
		|	ТС_Тесты.Наименование КАК Наименование
		|ИЗ
		|	Справочник.ТС_Тесты КАК ТС_Тесты
		|ГДЕ
		|	ТС_Тесты.ЭтоГруппа
		|	И НЕ ТС_Тесты.ПометкаУдаления";
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		
		КоличествоСимволовВНомереРаздела = СтрНайти(Выборка.Наименование, ".") -1;
		
		Если КоличествоСимволовВНомереРаздела = 0 Тогда
			СообщитьПользователю("Не удалось заполнить номер раздела для раздела" + Выборка.Ссылка);
			Продолжить;
		КонецЕсли;
		
		НомерРазделаСтрокой = Лев(Выборка.Наименование, КоличествоСимволовВНомереРаздела);
		
		Попытка
			НомерРаздела = Число(НомерРазделаСтрокой);
		Исключение
			
			СообщитьПользователю("Не удалось заполнить номер раздела для раздела" + Выборка.Ссылка);
			Продолжить;
			
		КонецПопытки;
		
		ОбъектТест = Выборка.Ссылка.ПолучитьОбъект();
		ОбъектТест.НомерРаздела= НомерРаздела;
		ОбъектТест.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьНумерациюВопросов(Команда)
	ВыполнитьНумерациюНомеровНаСервере();
	СообщитьПользователю("Обработка завершена");
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ВыполнитьНумерациюНомеровНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТС_Тесты.Ссылка КАК Ссылка,
		|	ТС_Тесты.Наименование КАК Наименование
		|ИЗ
		|	Справочник.ТС_Тесты КАК ТС_Тесты
		|ГДЕ
		|	ТС_Тесты.НомерВопроса = """"
		|	И НЕ ТС_Тесты.ПометкаУдаления
		|	И НЕ ТС_Тесты.Устаревший";
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		КоличествоСимволовВНомереВопроса = СтрНайти(Выборка.Наименование, "_", НаправлениеПоиска.СКонца); 
		Если КоличествоСимволовВНомереВопроса = 0 Тогда 
			СообщитьПользователю("Не удалось заполнить номер вопроса для вопроса " + Выборка.Ссылка);
			Продолжить;
		КонецЕсли;
		
		НомерВопросаСтрокой = Прав(Выборка.Наименование, КоличествоСимволовВНомереВопроса);
		ОбъектТест = Выборка.Ссылка.ПолучитьОбъект();
		ОбъектТест.НомерВопроса= НомерВопросаСтрокой;
		ОбъектТест.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СообщитьПользователю(ТексСообщения = "")
	
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = ТексСообщения;
	Сообщение.Сообщить();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПараметрыЗагрузкиТестовИзСайтаНаКлиенте(Команда)
	ОткрытьФорму("Обработка.ЗаполнитьДанныеВРегистрПараметрыФормированияЗапросаДляОбновленияТестовИзФайла.Форма");
КонецПроцедуры

