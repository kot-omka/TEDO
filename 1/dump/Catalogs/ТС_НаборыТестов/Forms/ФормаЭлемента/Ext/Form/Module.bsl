﻿///////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ ФОРМЫ

//*************************************************************

&НаКлиенте
Перем ВладелецДоВыбора;



///////////////////////////////////////////////////////////////
// СОБЫТИЯ ФОРМЫ

//*************************************************************
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ВладелецДоВыбора = Объект.Владелец;
	
КонецПроцедуры



///////////////////////////////////////////////////////////////
// ДЕЙСТВИЯ ФОРМЫ

//*************************************************************
&НаКлиенте
Процедура ВладелецПриИзменении(Элемент)
	
	Если ВладелецДоВыбора <> Объект.Владелец 
		И Объект.Содержание.Количество() > 0 Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ВладелецПриИзмененииЗавершение",ЭтаФорма);
		ПоказатьВопрос(ОписаниеОповещения,
			"При смене владельца табличная часть будет очищена, продолжить?",РежимДиалогаВопрос.ДаНет,,,,);
	КонецЕсли;
	
КонецПроцедуры

//*************************************************************
&НаКлиенте
Процедура ВладелецПриИзмененииЗавершение(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
		Объект.Владелец = ВладелецДоВыбора;
	ИначеЕсли Результат = КодВозвратаДиалога.Да Тогда
		Объект.Содержание.Очистить();
	КонецЕсли;	
		
КонецПроцедуры

//*************************************************************
&НаКлиенте
Процедура СодержаниеТестПриИзменении(Элемент)
	
	ТекНомерСтроки = Элементы.Содержание.ТекущиеДанные.НомерСтроки;
	РезультатПроверки = СодержаниеТестПриИзмененииСервер(ТекНомерСтроки);	
	Если РезультатПроверки <> Ложь Тогда
		ПоказатьПредупреждение(,РезультатПроверки);
	КонецЕсли;	
		
КонецПроцедуры

//*************************************************************
&НаСервере
Функция СодержаниеТестПриИзмененииСервер(ТекНомерСтроки)
	
	РезультатПроверки = Ложь;
	ТекСтрока = Объект.Содержание.Получить(ТекНомерСтроки-1);
	ТекТест = ТекСтрока.Тест;
	Для Каждого Строка ИЗ Объект.Содержание Цикл
		Если Строка.НомерСтроки = ТекНомерСтроки Тогда
			Продолжить;
		КонецЕсли;
		Тест = Строка.Тест;
		Если ТекТест.ЭтоГруппа Тогда
			Если Тест.ЭтоГруппа Тогда
				Если ТекТест = Тест Тогда
					РезультатПроверки = 
					"Группа тестов " + ТекТест + " уже присутствует в данном наборе тестов.";
					Объект.Содержание.Удалить(ТекНомерСтроки-1);
					Прервать;
				КонецЕсли;	
			Иначе
				Если Тест.ПринадлежитЭлементу(ТекТест) Тогда
					РезультатПроверки = 
					"В группу " + ТекТест + " входит тест " + Тест + ", который уже добавлен в данный набор тестов.";
					Объект.Содержание.Удалить(ТекНомерСтроки-1);
					Прервать;
				КонецЕсли;
			КонецЕсли;	
		Иначе	
			Если Тест.ЭтоГруппа Тогда
				Если ТекТест.ПринадлежитЭлементу(Тест) Тогда
					РезультатПроверки = 
					"Тест " + ТекТест + " входит в группу " + Тест + ", которая уже добавлена в данный набор тестов.";
					Объект.Содержание.Удалить(ТекНомерСтроки-1);
					Прервать;
				КонецЕсли;
			ИначеЕсли Тест = ТекТест Тогда
				РезультатПроверки = 
				"Тест " + ТекТест + " уже присутствует в данном наборе тестов.";
				Объект.Содержание.Удалить(ТекНомерСтроки-1);
				Прервать;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат РезультатПроверки;
	
КонецФункции

//*************************************************************
&НаКлиенте
Процедура ПройтиТестирование(Команда)
	
	//Откроем форму тестирования
	ЭтаФорма.Закрыть();
	СтруктураПараметров = Новый Структура(
		"Курс,Пользователь,НаборТестов,
		|Избранное,УдалятьТестыИзИзбранного",
		Объект.Владелец,ТС_ОбщегоНазначенияКлиент.ПолучитьТекущегоПользователя(),Объект.Ссылка,
		Ложь,Ложь);
	ФормаТестирования = ПолучитьФорму("Обработка.ТС_Тестирование.Форма.ФормаТестирования",СтруктураПараметров);
	ФормаТестирования.Открыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Подбор(Команда)
	ПараметрыФормы = Новый Структура("ЗакрыватьПриВыборе, МножественныйВыбор, Отбор", Ложь, Истина, Новый Структура("Владелец", Объект.Владелец));
	ОткрытьФорму("Справочник.ТС_Тесты.ФормаВыбора", ПараметрыФормы, Элементы.Содержание);
КонецПроцедуры

&НаКлиенте
Процедура СодержаниеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	//подбор с множественным выбором
	Для Каждого ВыбранныйЭлемент Из ВыбранноеЗначение Цикл
		НоваяСтрока = Объект.Содержание.Добавить();
		НоваяСтрока.Тест = ВыбранныйЭлемент;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура СлучайныйПодборНаСервере()
	
	Объект.Содержание.Очистить();
	МассивВопросов = Справочники.ТС_НаборыТестов.ПолучитьРандомныйНаборВопросов(Объект.Владелец);
	
	Для Каждого Вопрос Из МассивВопросов Цикл
		НоваяСтрока = Объект.Содержание.Добавить();
		НоваяСтрока.Тест = Вопрос;
	КонецЦикла; 
	
КонецПроцедуры

&НаКлиенте
Процедура СлучайныйПодбор(Команда)
	СлучайныйПодборНаСервере();
КонецПроцедуры

&НаСервере
//Процедура ПодборПоОшибочнымНаСервере() //Гладилов 08.04.2021 изменено
Процедура ПодборПоОшибочнымНаСервере(ТолькоТекущийПользователь = Ложь)
	
	Объект.Содержание.Очистить();
	ТекДата = ТекущаяДатаСеанса();
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Данные.Тест,
	               |	ТС_РезультатТестированияТесты.Правильный
	               |ИЗ
	               |	(ВЫБРАТЬ
	               |		ТС_РезультатТестированияТесты.Тест КАК Тест,
	               |		МАКСИМУМ(ТС_РезультатТестированияТесты.Ссылка.Дата) КАК Дата
	               |	ИЗ
	               |		Документ.ТС_РезультатТестирования.Тесты КАК ТС_РезультатТестированияТесты
	               |	ГДЕ
	               |		ТС_РезультатТестированияТесты.Ссылка.Курс = &Владелец
	               |		И ТС_РезультатТестированияТесты.Ссылка.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
	               |		И НЕ ТС_РезультатТестированияТесты.Ссылка.ПометкаУдаления
				   //Гладилов 08.04.2021+
				   |		И (&Пользователь = Неопределено ИЛИ ТС_РезультатТестированияТесты.Ссылка.Пользователь = &Пользователь)
	               //Гладилов 08.04.2021-
	               |	
	               |	СГРУППИРОВАТЬ ПО
	               |		ТС_РезультатТестированияТесты.Тест) КАК Данные
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ТС_РезультатТестирования.Тесты КАК ТС_РезультатТестированияТесты
	               |		ПО Данные.Дата = ТС_РезультатТестированияТесты.Ссылка.Дата
	               |			И Данные.Тест = ТС_РезультатТестированияТесты.Тест
	               |ГДЕ
	               |	ТС_РезультатТестированияТесты.Правильный = ЛОЖЬ
	               |	И ВЫБОР
	               |			КОГДА &Актуальный = ИСТИНА
	               |				ТОГДА ТС_РезультатТестированияТесты.Тест.Актуальный = &Актуальный
	               |			ИНАЧЕ ИСТИНА = ИСТИНА
	               |		КОНЕЦ
	               |	И ТС_РезультатТестированияТесты.Тест.Актуальный = &Актуальный
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Данные.Тест.Наименование";
	Запрос.УстановитьПараметр("Устаревший", Объект.ВключатьУстаревшие);
	Запрос.УстановитьПараметр("Актуальный", Объект.ТолькоАктуальные);
	Запрос.УстановитьПараметр("Владелец", Объект.Владелец);
	Запрос.УстановитьПараметр("ДатаНачала", НачалоДня(ДобавитьМесяц(ТекДата, -1)));
	Запрос.УстановитьПараметр("ДатаОкончания", КонецДня(ТекДата));
	//Гладилов 08.04.2021+
	Запрос.УстановитьПараметр("Пользователь", ?(ТолькоТекущийПользователь, ПараметрыСеанса.ТС_ТекущийПользователь, Неопределено));
	//Гладилов 08.04.2021-
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = Объект.Содержание.Добавить();
		НоваяСтрока.Тест = Выборка.Тест;
	КонецЦикла; 
	 
КонецПроцедуры

//&НаКлиенте
//Процедура ПодборПоОшибочным(Команда)
//	ПодборПоОшибочнымНаСервере();
//КонецПроцедуры
//Гладилов 08.04.2021+
&НаКлиенте
Процедура ПодборПоОшибочным(Команда)
	
	ПоказатьВопрос(Новый ОписаниеОповещения("ПодборПоОшибочнымЗавершение", ЭтотОбъект),
					"Отбирать результаты только текущего пользователя?",
					РежимДиалогаВопрос.ДаНет,10,КодВозвратаДиалога.Да);
КонецПроцедуры

&НаКлиенте
Процедура ПодборПоОшибочнымЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ПодборПоОшибочнымНаСервере(Истина);
	Иначе
		ПодборПоОшибочнымНаСервере();
	КонецЕсли;

КонецПроцедуры

//Гладилов 08.04.2021-

&НаКлиенте
Процедура Перемешать(Команда)
	
	ПеремещатьНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПеремещатьНаСервере()
	МассивВопросов = Объект.Содержание.Выгрузить(, "Тест").ВыгрузитьКолонку("Тест");
	Справочники.ТС_НаборыТестов.ПеремешатьНабор(МассивВопросов);
	Объект.Содержание.Очистить();
	Для Каждого Вопрос Из МассивВопросов Цикл
		НоваяСтрока = Объект.Содержание.Добавить();
		НоваяСтрока.Тест = Вопрос;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ПодборПоЧастымОшибкамНаСервере(Процент)
	
	Объект.Содержание.Очистить();
	ТекДата = ТекущаяДатаСеанса();
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Данные.Тест,
	               |	Данные.Правильный,
	               |	Данные.НеПравильный,
	               |	Данные.Итого
	               |ИЗ
	               |	(ВЫБРАТЬ
	               |		ТС_РезультатТестированияТесты.Тест КАК Тест,
	               |		СУММА(ВЫБОР
	               |				КОГДА ТС_РезультатТестированияТесты.Правильный
	               |					ТОГДА 1
	               |				ИНАЧЕ 0
	               |			КОНЕЦ) КАК Правильный,
	               |		СУММА(ВЫБОР
	               |				КОГДА ТС_РезультатТестированияТесты.Правильный
	               |					ТОГДА 0
	               |				ИНАЧЕ 1
	               |			КОНЕЦ) КАК НеПравильный,
	               |		СУММА(1) КАК Итого
	               |	ИЗ
	               |		Документ.ТС_РезультатТестирования.Тесты КАК ТС_РезультатТестированияТесты
	               |	ГДЕ
	               |		ТС_РезультатТестированияТесты.Ссылка.Курс = &Владелец
	               |		И ТС_РезультатТестированияТесты.Ссылка.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
	               |		И НЕ ТС_РезультатТестированияТесты.Ссылка.ПометкаУдаления
	               |	
	               |	СГРУППИРОВАТЬ ПО
	               |		ТС_РезультатТестированияТесты.Тест) КАК Данные
	               |ГДЕ
	               |	Данные.НеПравильный / Данные.Итого >= &Процент
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Данные.Тест.Наименование";
	Запрос.УстановитьПараметр("Владелец", Объект.Владелец);
	Запрос.УстановитьПараметр("ДатаНачала", НачалоДня(ДобавитьМесяц(ТекДата, -1)));
	Запрос.УстановитьПараметр("ДатаОкончания", КонецДня(ТекДата));
	Запрос.УстановитьПараметр("Процент", Процент/100);
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = Объект.Содержание.Добавить();
		НоваяСтрока.Тест = Выборка.Тест;
	КонецЦикла; 
	 
КонецПроцедуры

&НаСервере
Процедура ПодборПорциямиНаСервере(Порция)
	
	Объект.Содержание.Очистить();
	ТекДата = ТекущаяДатаСеанса();
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ТС_РезультатТестированияТесты.Тест
	               |ПОМЕСТИТЬ ВТОсвоенныеТесты
	               |ИЗ
	               |	Документ.ТС_РезультатТестирования.Тесты КАК ТС_РезультатТестированияТесты
	               |		Внутреннее СОЕДИНЕНИЕ (ВЫБРАТЬ
	               |			ТС_РезультатТестированияТесты.Ссылка КАК Ссылка
	               |		ИЗ
	               |			(ВЫБРАТЬ
	               |				ТС_РезультатТестированияТесты.Ссылка КАК Ссылка,
	               |				Количество(ТС_РезультатТестированияТесты.НомерСтроки) КАК НомерСтроки
	               |			ИЗ
	               |				Документ.ТС_РезультатТестирования.Тесты КАК ТС_РезультатТестированияТесты
	               |			ГДЕ
	               |				ТС_РезультатТестированияТесты.Ссылка.Курс = &Владелец
	               |				И ТС_РезультатТестированияТесты.Ссылка.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
	               |				И НЕ ТС_РезультатТестированияТесты.Ссылка.ПометкаУдаления
	               |			
	               |			СГРУППИРОВАТЬ ПО
	               |				ТС_РезультатТестированияТесты.Ссылка) КАК ТС_РезультатТестированияТесты
	               |		ГДЕ
	               |			ТС_РезультатТестированияТесты.НомерСтроки = &Порция) КАК Данные
	               |		ПО (Данные.Ссылка = ТС_РезультатТестированияТесты.Ссылка) 
				   |;
				   |
				   |////////////////////////////////////////////////////////////////////////////////
				   |ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ " + Порция + "
				   |	ТС_НаборыТестовСодержание.Тест
				   |ИЗ
				   |	Справочник.ТС_НаборыТестов.Содержание КАК ТС_НаборыТестовСодержание
				   |ГДЕ
				   |	ТС_НаборыТестовСодержание.Ссылка.Владелец = &Владелец
				   |	И Не ТС_НаборыТестовСодержание.Тест В
				   |				(ВЫБРАТЬ
				   |					ТС_РезультатТестированияТесты.Тест
				   |				ИЗ
				   |					ВТОсвоенныеТесты КАК ТС_РезультатТестированияТесты)";
	Запрос.УстановитьПараметр("Владелец", Объект.Владелец);
	Запрос.УстановитьПараметр("ДатаНачала", НачалоДня(ДобавитьМесяц(ТекДата, -1)));
	Запрос.УстановитьПараметр("ДатаОкончания", КонецДня(ТекДата));
	Запрос.УстановитьПараметр("Порция", Порция);
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = Объект.Содержание.Добавить();
		НоваяСтрока.Тест = Выборка.Тест;
	КонецЦикла; 
	 
КонецПроцедуры

&НаКлиенте
Процедура ПодборПорциямиПо50(Команда)
	ПодборПорциямиНаСервере(50);
КонецПроцедуры

&НаКлиенте
Процедура ПодборПоЧастымОшибкам50(Команда)
	ПодборПоЧастымОшибкамНаСервере(50);
КонецПроцедуры
 
&НаКлиенте
Процедура ПодборПоЧастымОшибкам70(Команда)
	ПодборПоЧастымОшибкамНаСервере(70);
КонецПроцедуры

&НаКлиенте
Процедура ПодборПоЧастымОшибкам60(Команда)
	ПодборПоЧастымОшибкамНаСервере(60);
КонецПроцедуры

&НаКлиенте
Процедура ПодборПоЧастымОшибкам40(Команда)
	ПодборПоЧастымОшибкамНаСервере(40);
КонецПроцедуры


&НаСервере
Процедура ЗаполнитьНаСервере()
	
	Объект.Содержание.Очистить();
	ТекДата = ТекущаяДатаСеанса();
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ТС_Тесты.Ссылка КАК Тест
	               |ИЗ
	               |	Справочник.ТС_Тесты КАК ТС_Тесты
	               |ГДЕ
	               |	ТС_Тесты.Родитель = &Родитель
	               |	И ВЫБОР
	               |			КОГДА &Устаревший = ИСТИНА
	               |				ТОГДА ТС_Тесты.Устаревший = &Устаревший
	               |			ИНАЧЕ ИСТИНА = ИСТИНА
	               |		КОНЕЦ
	               |	И ВЫБОР
	               |			КОГДА &Актуальный = ИСТИНА
	               |				ТОГДА ТС_Тесты.Актуальный = &Актуальный
	               |			ИНАЧЕ ИСТИНА = ИСТИНА
	               |		КОНЕЦ";
	Запрос.УстановитьПараметр("Устаревший", Объект.ВключатьУстаревшие);
	Запрос.УстановитьПараметр("Актуальный", Объект.ТолькоАктуальные);
	Запрос.УстановитьПараметр("Родитель", Объект.Раздел);
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = Объект.Содержание.Добавить();
		НоваяСтрока.Тест = Выборка.Тест;
	КонецЦикла; 
	 
КонецПроцедуры


&НаКлиенте
Процедура Заполнить(Команда)
	ЗаполнитьНаСервере();
КонецПроцедуры

