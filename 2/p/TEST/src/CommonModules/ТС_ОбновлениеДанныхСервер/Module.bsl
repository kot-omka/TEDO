//*************************************************************
Функция НомерКонфигурации(ТекСтрока)
	
	//Версия максимум из 3 блоков, например Х.YYY.ZZZ
	//Получаем число 100000000 * Х + 10000 * YYYY + ZZZZ
	
	Если СтрДлина(ТекСтрока) = 0 Тогда
		Возврат 0;
	КонецЕсли;
	
	ТекЧисло1 = "";
	ТекЧисло2 = "";
	ТекЧисло3 = "";
	Номер = 1;
	Для Сч = 1 По СтрДлина(ТекСтрока) Цикл
		Симв = Сред(ТекСтрока,Сч,1);
		Если Симв = "." Тогда			
			Номер = Номер + 1;
		ИначеЕсли 
			Симв = "0" ИЛИ
			Симв = "1" ИЛИ
			Симв = "2" ИЛИ
			Симв = "3" ИЛИ
			Симв = "4" ИЛИ
			Симв = "5" ИЛИ
			Симв = "6" ИЛИ
			Симв = "7" ИЛИ
			Симв = "8" ИЛИ
			Симв = "9" Тогда
			Если Номер = 1 Тогда
				ТекЧисло1 = ТекЧисло1 + Симв; 
			ИначеЕсли Номер = 2 Тогда
				ТекЧисло2 = ТекЧисло2 + Симв;
			ИначеЕсли Номер = 3 Тогда
				ТекЧисло3 = ТекЧисло3 + Симв;
			КонецЕсли;
		КонецЕсли;	
	КонецЦикла;
	
	Для Сч = СтрДлина(ТекЧисло2)+1 ПО 3 Цикл
		ТекЧисло2 = ТекЧисло2 + "0";
	КонецЦикла;
				
	Для Сч = СтрДлина(ТекЧисло3)+1 ПО 3 Цикл
		ТекЧисло3 = ТекЧисло3 + "0";
	КонецЦикла;
	
	Возврат Число(ТекЧисло1) * 1000000 + Число(ТекЧисло2) * 1000 + Число(ТекЧисло3);
	
КонецФункции

//*************************************************************
Процедура ВыполнитьОбновлениеДанных() Экспорт
	
	Если Константы.ТС_ТекущаяВерсияКонфигурации.Получить() = Метаданные.Версия Тогда
		//Обновление не требуется
		Возврат;
	КонецЕсли;
	
	//Получим числовое значение конфигурации
	НомерСтаройВерсии = НомерКонфигурации(Константы.ТС_ТекущаяВерсияКонфигурации.Получить());
	НомерНовойВерсии = НомерКонфигурации(Метаданные.Версия);
	
	флПоказыватьСообщение = Ложь;
	флБылиОшибки = Ложь;
	Если НомерСтаройВерсии <= 1400000 Тогда
		флБылиОшибки = флБылиОшибки ИЛИ ВыполнитьОбновлениеСВерсии1400000();
		флПоказыватьСообщение = Истина;
	КонецЕсли;
	Если НомерСтаройВерсии <= 1700000 Тогда
		флБылиОшибки = флБылиОшибки ИЛИ ВыполнитьОбновлениеНаВерсию1700000();
		флПоказыватьСообщение = Истина;
	КонецЕсли;
	
	//Все процедуры выполнены
	Если флПоказыватьСообщение И Не флБылиОшибки Тогда
		Попытка
			Константы.ТС_ТекущаяВерсияКонфигурации.Установить(Метаданные.Версия);
			Сообщить("Выполнен переход на версию " + Метаданные.Версия);
		Исключение
			Сообщить(ОписаниеОшибки());
		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры

//*************************************************************
Функция ВыполнитьОбновлениеСВерсии1400000()
	
	флБылиОшибки = Ложь; 
	
	//Скопируем комментарий наборов тестов
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТС_НаборыТестов.Ссылка,
		|	ТС_НаборыТестов.удКомментарий
		|ИЗ
		|	Справочник.ТС_НаборыТестов КАК ТС_НаборыТестов
		|ГДЕ
		|	ТС_НаборыТестов.удКомментарий <> """"";
	
	РезультатЗапроса = Запрос.Выполнить();	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		СпрОбъект = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
		СпрОбъект.ТС_Комментарий = ВыборкаДетальныеЗаписи.удКомментарий;
		СпрОбъект.удКомментарий = "";
		Попытка
			СпрОбъект.Записать();
		Исключение
			Сообщить(ОписаниеОшибки());
			флБылиОшибки = Истина;
		КонецПопытки;
		
	КонецЦикла;
	
	//Скопируем комментарии файлов
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТС_Файлы.Ссылка,
		|	ТС_Файлы.удКомментарий
		|ИЗ
		|	Справочник.ТС_Файлы КАК ТС_Файлы
		|ГДЕ
		|	ТС_Файлы.удКомментарий <> """"";
	
	РезультатЗапроса = Запрос.Выполнить();	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		СпрОбъект = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
		СпрОбъект.ТС_Комментарий = ВыборкаДетальныеЗаписи.удКомментарий;
		СпрОбъект.удКомментарий = "";
		Попытка
			СпрОбъект.Записать();
		Исключение
			Сообщить(ОписаниеОшибки());
			флБылиОшибки = Истина;
		КонецПопытки;
		
	КонецЦикла;

	//Все успешно
	Возврат флБылиОшибки;
	
КонецФункции

//*************************************************************
функция ВыполнитьОбновлениеНаВерсию1700000()
	
	флБылиОшибки = Ложь;
	ТекПользовательСсылка = ПараметрыСеанса.ТС_ТекущийПользователь;
	Если ЗначениеЗаполнено(ТекПользовательСсылка) Тогда
		ТекПользовательОбъект = ТекПользовательСсылка.ПолучитьОбъект();
		ТекПользовательОбъект.ПеремешиватьОтветыВТесте = Истина;
		Попытка
			ТекПользовательОбъект.Записать();
		Исключение
			Сообщить(ОписаниеОшибки());
			флБылиОшибки = Истина;
		КонецПопытки;
	Иначе
		Сообщить("Не определен текущий пользователь программы!");
		флБылиОшибки = Истина;
	КонецЕсли;
	
	Возврат флБылиОшибки;
	
КонецФункции