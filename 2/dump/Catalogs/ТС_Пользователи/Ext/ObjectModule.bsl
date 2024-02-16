﻿
Процедура ПередУдалением(Отказ)
	
	Если Отказ Тогда 
		Возврат;
	КонецЕсли;
	
	Попытка
		УдаляемыйПользователь = ПользователиИнформационнойБазы.НайтиПоИмени(Код);
	Исключение
		Возврат;
	КонецПопытки;
	
	Если УдаляемыйПользователь = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	УдаляемыйПользователь.Удалить();
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда   
		Возврат;
	КонецЕсли;
	
	Если Не ЭтоНовый() Тогда
		Возврат;
	КонецЕсли;
	
	НовыйПользователь = ПользователиИнформационнойБазы.СоздатьПользователя();
	НовыйПользователь.Имя = Код;
	НовыйПользователь.ПолноеИмя = Наименование;
	НовыйПользователь.АутентификацияСтандартная = Истина; 
	НовыйПользователь.Роли.Добавить(Метаданные.Роли.ТС_Тестирование);
	НовыйПользователь.Роли.Добавить(Метаданные.Роли.ТС_ПросмотрСправочников);
	
	НовыйПользователь.ПоказыватьВСпискеВыбора = Истина;
	НовыйПользователь.Язык = Метаданные.Языки.Русский;
	
	НовыйПользователь.Записать();
	
КонецПроцедуры
